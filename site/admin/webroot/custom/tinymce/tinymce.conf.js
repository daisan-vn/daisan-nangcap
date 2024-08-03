tinymce.init({
    selector: 'textarea.tinymce',
    plugins: 'code image link lists imagetools wordcount table',
    toolbar1: 'insertfile undo redo | bold italic underline forecolor backcolor | align | bullist numlist outdent indent | media_lib',
    setup: function (editor) {
        editor.ui.registry.addButton('media_lib', {
            text: 'MEDIA',
            icon: 'browse',
            onAction: function (_) {
              LoadMedia('Image2Editor');
            }
          });        
    },
    remove_script_host: false,
    convert_urls: false
});