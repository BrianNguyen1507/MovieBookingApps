import { getName } from "../service/authenticate/authenticate.js";

document.addEventListener("DOMContentLoaded", async function () {
  try {
    let sidebarLoading = false;
    const response = await fetch("./util/sidebar.html");
    const html = await response.text();

    document.querySelectorAll(".sidebar-container").forEach((container) => {
      container.innerHTML = html;
    });
    sidebarLoading = true;
    await getName();

    if (sidebarLoading) {
      document.querySelectorAll(".sidebar-toggler").forEach((toggler) => {
        toggler.addEventListener("click", function () {
          document.querySelector(".sidebar").classList.toggle("open");
          document.querySelector(".content").classList.toggle("open");
        });
      });
    }
    activateCurrentPageLink();
  } catch (error) {
    console.log("Error loading sidebar: " + error);
  }
});

function activateCurrentPageLink() {
  const page = document.body.getAttribute("data-page");
  if (!page) {
    return;
  }
  const link = document.querySelector(
    `.navbar-nav .nav-link[href="${page}.html"]`
  );
  if (link) {
    link.classList.add("active");
  }
}
