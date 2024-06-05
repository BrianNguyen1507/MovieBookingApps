function showAlert(content, activity, icon) {
    Swal.fire({
      title: activity ,
      text: content,
      icon: icon, 
      confirmButtonText: 'OK'
    });
  }
  
  