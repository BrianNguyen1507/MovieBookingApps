import { getUserToken } from '../authenticate/authenticate.js';
import { displayErrorMessage } from '../../util/common.js';
const apiUrl = 'http://localhost:8083/cinema/addCategory';

async function addCategory(categoryName) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl,
      method: 'POST',
      contentType: 'application/json',
      headers: {
        'Authorization': `Bearer ${tokenUser}`
      },
      data: JSON.stringify({ name: categoryName })
    });

    if (response.code !== 1000) {
      return response.message;
    }

    return true;
  } catch (error) {
    console.error('Exception:', error);
    return error.responseJSON ? error.responseJSON.message : error.message;
  }
}

$('#AddCategoryForm').submit(async function(event) {
  event.preventDefault();
  const categoryName = $('#categoriesInput').val();

  const result = await addCategory(categoryName);

  if (result === true) {
    Swal.fire({
      title: 'Success!',
      text: 'Category has been added.',
      icon: 'success',
      confirmButtonText: 'OK'
    }).then(() => {
     setTimeout(function() {
  window.location.reload();
}, 300); 
    });
  } else {
    displayErrorMessage(result);
  }
});

