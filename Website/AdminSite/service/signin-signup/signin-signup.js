import {saveAuthenticated} from '../authenticate/authenticate.js'
const apiurl = 'http://localhost:8083/cinema/login';
async function signin(email, password) {
  try {
    const signInData = JSON.stringify({ email, password });
    const response = await $.ajax({
      url: apiurl,
      method: 'POST',
      contentType: 'application/json',
      data: signInData,
      error: function(xhr, status, error) {
        console.error('Error:', error);
        notification("Sorry! An unexpected problem occurred");
      }
    });

    if (response.code !== 1000 && response.code !== 1001) {
      return response.message;
    }
    
    const token = response.result.token;
    const auth = response.result.authenticated;
    const role = response.result.role;
    await saveAuthenticated(auth, token, role);
    return true;
  } catch (error) {
    console.error('Exception:', error);
    return error.responseJSON.message;
  }
}

$('#signInForm').submit(async function(event) {
  event.preventDefault();
  const email = $('#floatingInput').val();
  const password = $('#floatingPassword').val();
  const result = await signin(email, password);

  if (result === true) {
    const role = sessionStorage.getItem('role');
    if (role === "ADMIN") {
      Swal.fire({
        title: 'Sign in Success!',
        icon: 'success',
        confirmButtonText: 'OK'
      }).then(() => {
        setTimeout(function() {
          window.location.href('./');
        }, 1000); 
      });
    } else {
      displayErrorMessage("Invalid account");
    }
  } else {
    displayErrorMessage(result); 
  }
});

function displayErrorMessage(message) {
  $('#errorMessageText').text(message);
  $('#errorMessageModal').modal('show');
}

