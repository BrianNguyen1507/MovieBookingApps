document.addEventListener("DOMContentLoaded", function () {
    fetch('./util/sidebar.html') 
        .then(response => response.text())
        .then(html => {
            
            document.querySelectorAll('.sidebar-container').forEach(container => {
                container.innerHTML = html;
            });
        });
});
 