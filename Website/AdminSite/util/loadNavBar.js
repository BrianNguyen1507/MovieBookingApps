import { getName } from "../service/authenticate/authenticate";

document.addEventListener("DOMContentLoaded", async function () {
  try {
    const response = await fetch("./util/navbar.html");
    const html = await response.text();
    document.querySelectorAll(".navbar-container").forEach((container) => {
      container.innerHTML = html;
    });
    await getName();
  } catch (error) {
    console.log("Error loading Navbar: " + error);
  }
});
