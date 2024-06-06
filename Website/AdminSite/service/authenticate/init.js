function initCheckin() {
    const token = sessionStorage.getItem('token');
    if (!token) {
      window.location.href = './signin.html';
    }
  }
  document.addEventListener("DOMContentLoaded", () => {
    initCheckin();
  });