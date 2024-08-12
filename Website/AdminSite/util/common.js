export function displayErrorMessage(message) {
    $('#errorMessageText').text(message);
    $('#errorMessageModal').modal('show');
  }