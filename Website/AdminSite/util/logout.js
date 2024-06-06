export function logOut(){
    window.location.href='signin.html';
    return localStorage.clear();
}

document.addEventListener("DOMContentLoaded", () => {
    const logoutButton = document.getElementById("logoutButton");

    logoutButton.addEventListener("click", () => {
        logOut();
    });
});