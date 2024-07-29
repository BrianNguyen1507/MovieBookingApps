export function logoutService() {
  fetch("http://localhost:8083/cinema/logout", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      token: sessionStorage.getItem("token"),
    }),
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then((data) => {
      sessionStorage.clear();
    })
    .catch((error) => {
      console.error("Error LOGOUT:", error);
    });
}
