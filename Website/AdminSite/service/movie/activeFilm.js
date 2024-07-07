import { getUserToken } from "../authenticate/authenticate";
const url = "http://localhost:8083/cinema/activeFilm?id=";

export async function activeFilm(id) {
  try {
    const token = await getUserToken();
    const response = await fetch(url + id, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });
    if (response.status == 200) {
      const responseData = await response.json();
      Swal.fire({
        title: "Success!",
        text: responseData.message,
        icon: "success",
        confirmButtonText: "OK",
      }).then(() => {
       location.reload();
      });
    } else {
      Swal.fire({
        title: "Error!",
        text: responseData.message,
        icon: "error",
        confirmButtonText: "OK",
      }).then(async () => {
        location.reload();
      });
    }
  } catch (error) {
    console.error("Error fetching and displaying movies:", error);
  }
}
