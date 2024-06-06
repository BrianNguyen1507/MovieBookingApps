document.addEventListener("DOMContentLoaded", function () {

  const token = sessionStorage.getItem("token");  
  if (!token) {
    window.location.href ='signin.html';
  } 
});
