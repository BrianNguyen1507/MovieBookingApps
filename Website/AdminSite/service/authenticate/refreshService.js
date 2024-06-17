// Function to refresh token
function refreshToken() {
  fetch("http://localhost:8083/cinema/refresh", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      token: sessionStorage.getItem("token"),
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.code !== 1000) {
        console.log("Token refresh failed");
      } else {
        console.log(`New token: ${data.result.token}`);
        sessionStorage.setItem("token", data.result.token);
      }
    })
    .catch((error) => {
      console.error("Error refreshing token:", error);
    });
}

setInterval(() => {
  refreshToken();
}, 3600000);
