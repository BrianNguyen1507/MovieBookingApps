document.addEventListener("DOMContentLoaded", function () {
  fetch("./util/footer.html")
    .then((response) => response.text())
    .then((html) => {
      document.querySelectorAll(".footer-bar").forEach((container) => {
        container.innerHTML = html;
      });
    });
});
