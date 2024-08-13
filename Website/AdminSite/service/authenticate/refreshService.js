function refreshToken() {
  fetch("http://103.200.20.167:8083/cinema/refresh", {
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
