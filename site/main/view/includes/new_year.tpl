{literal}

<style>
.popup_new_year {
    position: fixed;
    z-index: 9999999999;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
    display: none;
}
.popup_new_year_body {
    position: fixed;
    top: 45vh;
    left: 50vw;
    transform: translate(-50%, -50%);
    background: #eee;
    border-radius: 4px;
    padding: 4px;
    overflow: hidden;
    max-width: 600px;
    width: 90%;
}
.popup_new_year_close {
    position: absolute;
    top: 4px;
    right: 4px;
    width: 32px;
    height: 32px;
    padding-left: 8px;
    padding-top: 2px;
    font-size: 20px;
    background: rgba(0,0,0,.15);
    color: #eee;
    cursor: pointer;
}
.popup_new_year img {
    width: 100%;
    border-radius: 4px;
}
</style>

<div class="popup_new_year">
    <div class="popup_new_year_body">
        <img class="popup_new_year_main" src="https://daisan.vn/site/upload/nghi_tet_2024.png" alt=""/>
        <div class="popup_new_year_close">&#10005;</div>
    </div>
</div>

<script>
    let popup_new_year = document.querySelector('.popup_new_year');

    let show_new_year = JSON.parse(localStorage.getItem('show_new_year') || '{}');
    if (!show_new_year.time) {
        setTimeout(() => {
            popup_new_year.style.display = 'block';
        }, 3000);

        popup_new_year.addEventListener('click', function(event) {
            let element = event.target;
            if (!element.classList.contains('popup_new_year_main')) {
                popup_new_year.style.display = 'none';
            }
            let option = {};
            option.time = (new Date()).getTime();
            localStorage.setItem('show_new_year', JSON.stringify(option));
        });
    }
</script>

{/literal}