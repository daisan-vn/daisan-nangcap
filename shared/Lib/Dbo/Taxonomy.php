<?php

namespace Lib\Dbo;

class Taxonomy {

    use \Lib\Singleton;

    private $pdo, $img, $media;
    
    public $position, $position_post, $folder;
    
    protected function __construct(){
        $this->pdo = \Lib\DB::instance();
        $this->img = \Lib\Core\Image::instance();
        $this->media = \Lib\Dbo\Media::instance();
        
        $this->position = array(
            1 => "Position 1",
            2 => "Position 2",
            3 => "Position 3",
        );
        
        // $this->position_post = array(
        //     'service' => 'Dịch vụ',
        //     'about' => 'Giới thiệu',
        //     'home' => 'Tin trang chủ'
        // );
        $this->folder = 'media/category/';
    }
    
    
    function get_value($id){
        $value = $this->pdo->fetch_one("SELECT a.*,t.alias AS folder FROM taxonomy a
				LEFT JOIN media m ON a.image=m.id LEFT JOIN taxonomy t ON m.taxonomy_id=t.id
				WHERE a.id=$id");
        $value['thumb'] = $this->media->get_image_byid($value['image'], 1);
        $value['image'] = $this->media->get_image_byid($value['image']);
        
        return $value;
    }
    
    
    function get_taxonomy($type='category', $parent=0, $where=null, $limit=null, $sub=0, $image=1, $sup=0) {
        global $lang, $url_location;
        $where = ($where==null||$where=='') ? '' : "AND ".$where;
        $result = [];
        
        $sql = "SELECT a.id,a.name,a.level,a.alias,a.description,a.icon,a.position";
        if($image==1) $sql .= ",m.name AS image,t.alias AS folder";
        $sql .= " FROM taxonomy a";
        if($image==1) $sql .= " LEFT JOIN media m ON a.image=m.id LEFT JOIN taxonomy t ON m.taxonomy_id=t.id";
        $sql .= " WHERE a.status=1 AND a.type='$type' AND a.parent='$parent' $where ORDER BY a.featured DESC,a.lft";
        if($limit!=null) $sql .= " LIMIT $limit";
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        while ($item = $stmt->fetch()) {
            $item['url'] = $this->get_url($type, $item['id'], $item['alias'], $item['level']);
            //$item['url'] = $this->get_url($url_location, $type, $item['id'], $item['alias'], $item['level']);
           // if($type=='category')  $item['url'] = "?mod=posts&site=index&cid=".$item['id'];
           if($sup==1) $item['url'] = $this->get_url('supplier', $item['id'], $item['alias'], $item['level']); 
           if($image==1){
                $item['thumb'] = $this->img->get_image($this->media->get_path($item['folder'], 1), $item['image']);
                $item['image'] = $this->img->get_image($this->media->get_path($item['folder']), $item['image']);
            }
            $item['sub'] = [];
            if($sub==1 && $this->pdo->check_exist("SELECT id FROM taxonomy WHERE status=1 AND type='$type' AND parent=".$item['id']))
                $item['sub'] = self::get_taxonomy($type, $item['id'], $where, $limit, $sub);
                $result[] = $item;
        }
        return $result;
    }
    
    function get_tax_keyword($id){
        global $url_location;
        $tax_key = $this->pdo->fetch_one("SELECT keyword FROM taxonomy WHERE id=$id");
        $a_keyword = explode(',', $tax_key['keyword']);
        $result = [];
        if (count($a_keyword) > 0) {
            foreach ($a_keyword as $k => $item) {
                $result[$k]['keyword'] =$item;
                $result[$k]['url'] ="product?k=".str_replace(" ","+", trim($item))."&t=0";
                if($location!=0) $result[$k]['url']=$url_location.$result[$k]['url'] ;
            }
        }
        return $result;
    }
    function get_tax_position($type = 'category', $where = null, $limit = null) {
        global $lang;
        $where = ($where == null || $where == '') ? '' : "AND " . $where;
        $result = [];
        
        $sql = "SELECT a.id,a.name,a.level,a.alias,a.image,a.description,m.name AS image,t.alias AS folder FROM taxonomy a
                LEFT JOIN media m ON a.image=m.id LEFT JOIN taxonomy t ON m.taxonomy_id=t.id
				WHERE a.status=1 AND a.type='$type' AND a.lang='$lang' $where ORDER BY a.lft";
        if ($limit != null) $sql .= " LIMIT $limit";
        $stmt = $this->pdo->getPDO()->prepare ( $sql );
        $stmt->execute ();
        while ( $item = $stmt->fetch () ) {
            $item ['url'] = $this->get_url ( $type, $item ['id'], $item ['alias'], $item['level'] );
            $item ['avatar'] = $this->img->get_image($this->media->get_path($item['folder'], 1), $item['image']);
            $item ['image'] = $this->img->get_image($this->media->get_path($item['folder'], 0), $item['image']);
            $result [] = $item;
        }
        return $result;
    }
    
    function get_taxonomy_tree($type='category', $parent=0, $not=null, $position=null) {
        global $lang;
        $result = [];
        
        $sql = "SELECT a.id,a.name,a.level,a.alias FROM taxonomy a WHERE a.type='$type' AND lang='$lang'";
        if($position!=null) $sql .= " AND a.position=$position ";
        if ($parent != 0) {
            $this_parent = $this->pdo->fetch_one("SELECT id,lft,rgt FROM taxonomy WHERE id=$parent");
            $sql .= " AND a.lft >= ".$this_parent['lft']." AND a.rgt <= ".$this_parent['rgt'];
        }
        if($not != null && count(explode(',', $not))>0) $sql .= " AND a.id NOT IN ($not)";
        $sql .= " ORDER BY a.lft";
        
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        while ($item = $stmt->fetch()) {
            $prefix = null;
            for ($i=0; $i<$item['level']; $i++) {
                $prefix .= "&#8212; ";
            }
            $item['sub_name'] = $prefix . $item['name'];
            $item['url'] = $this->get_url($type, $item['id'], $item['alias']);
            $result[] = $item;
        }
        return $result;
    }
    
    function get_checkbox_taxonomy($type='category', $active=[], $parent=0){
        global $lang;
        
        $sql = "SELECT id,name
				FROM taxonomy
				WHERE status=1 AND parent=$parent AND lang='$lang' AND type='$type'
				ORDER BY lft DESC";
       
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        
        $result = "<div class=\"check_level\">";
        while ($item = $stmt->fetch()){
            $result .= "<div id=\"Taxid".$item['id']."\">";
            if(in_array($item['id'], $active))
                $result .= "<div class=\"checkbox\"><label><input type=\"checkbox\" name=\"".$type."[]\" value=\"".$item['id']."\" checked> ";
                else
                    $result .= "<div class=\"checkbox\"><label><input type=\"checkbox\" name=\"".$type."[]\" value=\"".$item['id']."\"> ";
                    
                    $result .= $item['name'];
                    $result .= "</label></div>";
                    if($this->pdo->check_exist("SELECT id FROM taxonomy WHERE status=1 AND lang='$lang' AND parent=".$item['id'])){
                        $result .= $this->get_checkbox_taxonomy($type, $active, $item['id']);
                    }
                    $result .= "</div>";
        }
        $result .= "</div>";
        
        return $result;
    }
    
    
    function get_select_taxonomy($type='category', $active=0, $parent=0, $where=null, $default='Chọn danh mục', $lang_on=1) {
        global $lang;
        $result = "";
        if ($default != null) $result .= '<option value="0">' . $default . '</option>';
        
        $sql = "SELECT a.id,a.name,a.level FROM taxonomy a WHERE a.type='$type' AND a.parent=$parent";
        if ($lang_on == 1) $sql .= " AND a.lang='$lang'";
        if($where != null) $sql .= " AND $where";
        $sql .= " ORDER BY a.lft";
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        while ($item = $stmt->fetch()) {
            if (in_array($item['id'], explode(',', $active))) $result .= '<option value="' . $item['id'] . '" selected>';
            else $result .= '<option value="' . $item['id'] . '">';
            $result .= $item['name'];
            $result .= '</option>';
        }
        return $result;
    }
    
    
    function get_select_taxonomy_tree($type='category', $active=0, $parent=0, $where=null, $default='Chọn danh mục', $lang_on=1) {
        global $lang;
        $result = "";
        if ($default != null) $result .= '<option value="0">' . $default . '</option>';
        
        $sql = "SELECT a.id,a.name,a.level FROM taxonomy a WHERE a.type='$type'";
        if ($lang_on == 1) $sql .= " AND a.lang='$lang'";
        if ($parent != 0) {
            $this_parent = $this->pdo->fetch_one("SELECT lft,rgt FROM taxonomy WHERE id=$parent");
            $sql .= " AND a.lft >= ".$this_parent['lft']." AND a.rgt <= ".$this_parent['rgt'];
        }
        if($where != null) $sql .= " AND $where";
        $sql .= " ORDER BY a.lft";
        
        $stmt = $this->pdo->getPDO()->prepare($sql);
        $stmt->execute();
        while ($item = $stmt->fetch()) {
            if (in_array($item ['id'], explode(',', $active))) $result .= '<option value="' . $item ['id'] . '" selected>';
            else $result .= '<option value="' . $item ['id'] . '">';
            
            for ($i=0; $i<$item['level']; $i++) {
                $result .= "&#8212; ";
            }
            $result .= $item ['name'];
            $result .= '</option>';
        }
        return $result;
    }
    
    
    function get_product_category_ofpage($page_id){
        $sql = "SELECT a.id,a.name FROM taxonomy a
                WHERE a.id IN (SELECT b.taxonomy_id FROM products b WHERE b.status=1 AND b.page_id=$page_id)";
        $category = $this->pdo->fetch_all($sql);
        return $category;
    }
    
    
    function get_all_category_id($parent, $ids=[], $where=null) {
        $ids[] = $parent;
        if ($this->pdo->check_exist("SELECT id FROM taxonomy WHERE status=1 AND parent=$parent LIMIT 1")) {
            $sql = "SELECT id FROM taxonomy WHERE status=1 AND parent=$parent";
            $stmt = $this->pdo->getPDO()->prepare($sql);
            $stmt->execute();
            while ($item = $stmt->fetch()) {
                $ids = array_merge($ids, self::get_all_category_id($item['id'], $ids, $where));
            }
        }
        return array_unique($ids);
    }
    
    function get_allsubid($parent, $type='product') {
        $sql = $this->get_allsubid_query($parent, $type);
        $this->pdo->fetch_all($sql);
        $ids = [];
        foreach ($result AS $item){
            $ids[] = $item['id'];
        }
        return array_unique($ids);
    }
    
    
    function get_allsubid_query($parent, $type='product'){
        return "SELECT id FROM taxonomy WHERE type='$type'
                AND (lft BETWEEN (SELECT lft FROM taxonomy WHERE id=$parent) AND (SELECT rgt FROM taxonomy WHERE id=$parent))
                ORDER BY lft";
    }
    
    function create($type, $name, $alias){
        global $lang;
        $type = 'product';
        $taxonomy = $this->pdo->fetch_one("SELECT id FROM taxonomy WHERE lang='$lang' AND type='$type' AND name='$name'");
        $taxonomy_id = @$taxonomy['id'];
        if(!$taxonomy && $alias!=null){
            $last_tax = $this->pdo->fetch_one("SELECT rgt FROM taxonomy WHERE lang='$lang' AND type='$type' ORDER BY rgt DESC LIMIT 1");
            if(@$last_tax['rgt']==NULL){//chua co content
                $data['lft'] = 0;
                $data['rgt'] = 1;
            }else{
                $data['lft'] = $last_tax['rgt']+1;
                $data['rgt'] = $last_tax['rgt']+2;
            }
            
            $data["name"] = trim($name);
            $data["alias"] = $alias;
            $data["type"] = $type;
            $data["status"] = 1;
            $data["lang"] = $lang;
            $taxonomy_id = $this->pdo->insert("taxonomy", $data);
        }
        return $taxonomy_id;
    }
    
    /**
     * Get array all id taxonomy of id parent input
     * @param int $id
     * @return array id
     */
    function get_subcategory($id){
        $parent = $this->pdo->fetch_one("SELECT id,lft,rgt,lang,type FROM taxonomy WHERE id=$id");
        $where = "type='".$parent['type']."' AND lang='".$parent['lang']."' AND lft>=".$parent['lft']." AND rgt<=".$parent['rgt'];
        return $this->pdo->fetch_array_field('taxonomy', 'id', $where);
    }
    
    
    function get_menu_tree($id, $str=null){
        $taxonomy = $this->pdo->fetch_one("SELECT id,name,parent,type FROM taxonomy WHERE id=$id");
        $taxonomy['url'] = $this->get_url($taxonomy['type'], $taxonomy['id']);
        $strli = "<li><a href=\"".$taxonomy['url']."\">".$taxonomy['name']."</a></li>";
        $str = $strli.$str;
        if($taxonomy['parent']!=0){
            $str = self::get_menu_tree($taxonomy['parent'], $str);
        }
        return $str;
    }
    
    
    function get_biggest_parent($type, $id){
        $taxonomy = $this->pdo->fetch_one("SELECT parent FROM taxonomy WHERE id=$id");
        if(@$taxonomy['parent']==0) return $id;
        else return self::get_biggest_parent($type, $taxonomy['parent']);
    }
    function save_taxonomy_rls($type='post', $taxonomy=[], $post_id=0){
        $this->pdo->query("DELETE FROM taxonomyrls
				WHERE type='$type' AND post_id=$post_id
				AND taxonomy_id NOT IN (".((is_array($taxonomy) && count($taxonomy)>0) ? implode(',', $taxonomy) : "0").")");
        if(is_array($taxonomy) && count($taxonomy)>0 && $post_id!=0){
            foreach ($taxonomy AS $k=>$item){
                if(!$this->pdo->check_exist("SELECT id FROM taxonomyrls WHERE type='$type' AND post_id=$post_id AND taxonomy_id=$item")){
                    $data['type'] = $type;
                    $data['taxonomy_id'] = $item;
                    $data['post_id'] = $post_id;
                    $this->pdo->insert('taxonomyrls', $data);
                    unset($data);
                }
            }
        }
    }
    function get_breadcrumb($type='category', $taxonomy_id=0, $trans=[]){
        $str = null;
        if($type=='category'){
            //$str = "<li><a href='./news.html' title='".@$trans['news']."'>".@$trans['news']."</a></li>";
        }else{
            $str = "<li class='breadcrumb-item'><a href='./products.html' title='".@$trans['product']."'>".@$trans['product']."</a></li>";
        }
        if($taxonomy_id!=0){
            $ids = $this->get_tree_parent($taxonomy_id);
            krsort($ids);
            foreach ($ids AS $k=>$item){
                $str .= "<li class='breadcrumb-item'><a href='".$this->get_url($type, $item['taxonomy_id'], $item['alias'])."' title='".$item['name']."'>";
                $str .= $item['name'];
                $str .= "</a></li>";
            }
        }
        return $str;
    }
    
    function get_url2($type, $id, $alias=null, $level=0){
        $url = "?mod=$type&site=index&id=$id";
        if($level==0) $url = "?mod=$type&site=category&id=$id";
        return $url;
    }
    function get_url($type, $taxonomy_id, $alias = null, $level=0){
        $url = URL_HELPCENTER;
        if ($type == 'product' && $level==0)
            $url = ROUTER_PRODUCT_CATEGORY;
        if($type== 'category') $url = ROUTER_BLOG;
        if($type=='supplier') $url = ROUTER_SUPPLIER;
        if ($type == 'post' && $level==0)
            $url = "?mod=posts&site=index";
            else if ($type == 'product' && $level!=0) $url = ROUTER_PRODUCT_LIST;
            else if ($type == 'tag')
                $url = ROUTER_POST_TAG;
                if ($alias == NULL || $alias == "")
                    $url .= $taxonomy_id;
                    else
                        $url .= $alias;
                        return $url;
    }

}