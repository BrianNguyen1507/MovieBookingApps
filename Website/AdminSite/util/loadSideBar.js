document.addEventListener("DOMContentLoaded", function () {
  fetch("./util/sidebar.html")
    .then((response) => response.text())
    .then((html) => {
      document.querySelectorAll(".sidebar-container").forEach((container) => {
        container.innerHTML = html;
        activateCurrentPageLink();
      });

      document
        .querySelector(".sidebar-toggler")
        .addEventListener("click", function () {
          document.querySelector(".sidebar").classList.toggle("open");
          document.querySelector(".content").classList.toggle("open");
        });
    })
    .catch((error) => {
      console.log("togggle side bar" + error);
    });
});

function activateCurrentPageLink() {
  const page = document.body.getAttribute("data-page");
  if (!page) {
    return;
  }
  const link = document.querySelector(
    `.navbar-nav .nav-link[href="${page}.html"]`
  );
  link.classList.add("active");
}
