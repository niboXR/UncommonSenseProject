window.onload = resizeFooter;

function resizeFooter() {
    var footer = document.getElementById('sticky-footer');
    footer.style.height = 'calc(100vh - ' + (window.innerHeight - footer.offsetTop) + 'px)';
}