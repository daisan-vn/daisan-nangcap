tinymce.init({
    selector: '#Tinymce',
    entity_encoding: 'raw',
    plugins: [
        'advlist autolink lists link image charmap print preview hr anchor pagebreak',
        'searchreplace wordcount visualblocks visualchars code fullscreen',
        'insertdatetime media nonbreaking save table contextmenu directionality',
        'emoticons template paste textcolor colorpicker textpattern imagetools'
    ],
    toolbar1: 'insertfile undo redo | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | medialib |',
    lineheight_formats: '1.0 1.4 1.5 1.6 1.8 2.0',
    textindent_formats: '0px 10px 15px 20px 25px 30px 40px',
    content_style: 'h1,h2,h3,h4,h5,h6{font-weight:400} p{margin:0 0 8px}',
    image_advtab: true,
    templates: [
        {title: 'Template 1', content: 'Content of template 1'},
        {title: 'Template 2', content: 'Content of template 2'}
    ],
    setup: function (editor) {
        editor.addButton('medialib', {
            text: 'Chèn media',
            icon: 'mce-ico mce-i-browse',
            onclick: function () {
                LoadMedia('Image2Editor');
            }
        });
    },
    relative_url: false,
    remove_script_host: false,
    convert_urls: false
});