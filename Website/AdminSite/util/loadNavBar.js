document.addEventListener("DOMContentLoaded", function () {
    fetch('./util/navbar.html') 
        .then(response => response.text())
        .then(html => {
            
            document.querySelectorAll('.navbar-container').forEach(container => {
                container.innerHTML = html;
            });
        });
});
