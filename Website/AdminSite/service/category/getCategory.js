import { getUserToken } from '../authenticate/authenticate.js';

const apiUrl = 'http://localhost:8083/cinema/deleteCategory?id=';
const tokenUser = await getUserToken();
async function deleteCategoryById(categoryId) {
  try {
    const response = await fetch(`${apiUrl}${categoryId}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${tokenUser}`
      }
    });

    if (!response.ok) {
      const data = await response.json();
      throw new Error(data.message);
    }

    return true;
  } catch (error) {
    console.error('Error deleting category:', error);
    throw error;
  }
}
const UpdateCategory = (id) => {
  Swal.fire({
      title: "Cập nhật thể loại",
      html: `
      <div class="input-group">
          <span class="input-group-text" id="basic-addon3">Tên thể loại</span>
          <input type="text" class="form-control" id="editcategory" aria-describedby="basic-addon3 basic-addon4">
      </div>
      `,
      showCancelButton: true,
      confirmButtonText: "Cập nhật",
      showLoaderOnConfirm: true,
      preConfirm: () => {
          const name = document.getElementById('editcategory').value;
          return fetch('http://localhost:8083/cinema/updateCategory', {
              method: 'PUT',
              headers: {
                  'Content-Type': 'application/json',
                
                  'Authorization': `Bearer ${tokenUser}`
                 
              },
              body: JSON.stringify({
                  id,
                  name,
              }),
          })
          .then(response => {
              if (!response.ok) {
                  throw new Error(response.statusText);
              }
              return response.json();
          })
          .catch(error => {
              Swal.showValidationMessage(
                  `Cập nhật thể loại thất bại: ${error}`
              );
          });
      },
      allowOutsideClick: () => !Swal.isLoading(),
  }).then((result) => {
      if (result.isConfirmed) {
          Swal.fire({
              icon: "success",
              title: `Cập nhật thể loại thành công`,
          });
          getAndDisplayCategories();
      }
  });
};

const url = 'http://localhost:8083/cinema/getAllCategory';
async function getAndDisplayCategories() {
  try {
    const token = await getUserToken();
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      }
    });

    const categories = await response.json();
    if (categories.code !== 1000) {
      return;
    }

    const tbody = document.querySelector('#categories-table tbody');
    tbody.innerHTML = ''; 

    categories.result.forEach((category, index) => {
      const row = document.createElement('tr');

      const indexCell = document.createElement('td');
      indexCell.textContent = index + 1;
      row.appendChild(indexCell);

      const nameCell = document.createElement('td');
      nameCell.textContent = category.name;
      row.appendChild(nameCell);

      const actionCell = document.createElement('td');
      actionCell.innerHTML = `
        <button class="btn btn-primary" data-id="${category.id}">Edit</button>
        <button class="btn btn-danger" data-id="${category.id}">Delete</button>
      `;
      row.appendChild(actionCell);

      const deleteButton = actionCell.querySelector('.btn-danger');
      const editButton = actionCell.querySelector('.btn-primary');

      deleteButton.addEventListener('click', async () => {
        try {
          const confirmation = await Swal.fire({
            title: 'Are you sure?',
            text: 'Do you really want to delete this category?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'No, cancel'
          });
      
          if (confirmation.isConfirmed) {
            const result = await deleteCategoryById(category.id);
            if (result) {
              tbody.removeChild(row);
              Swal.fire({
                title: 'Deleted!',
                text: 'Category has been deleted.',
                icon: 'success',
                confirmButtonText: 'OK'
              });
            } else {
              Swal.fire({
                title: 'Error!',
                text: 'Failed to delete the category.',
                icon: 'error',
                confirmButtonText: 'OK'
              });
            }
          } else {
            Swal.fire({
              title: 'Cancelled',
              text: 'Category deletion was cancelled.',
              icon: 'info',
              confirmButtonText: 'OK'
            });
          }
        } catch (error) {
          Swal.fire({
            title: 'Error!',
            text: error.message,
            icon: 'error',
            confirmButtonText: 'OK'
          });
        }
      });
      editButton.addEventListener('click', async () => {
        try {
           
            const result = await UpdateCategory(category.id);
            if (result) {
                Swal.fire({
                    title: 'Update Success!',
                    icon: 'success',
                    confirmButtonText: 'OK'
                });
            }
        } catch (error) {
            Swal.fire({
                title: 'Error!',
                text: error.message,
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    });
    ;
      tbody.appendChild(row);
    });
  } catch (error) {
    console.error('Error fetching and displaying categories:', error);
  }
}
getAndDisplayCategories();
