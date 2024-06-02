async function signin(email, password) {
  const apiUrl = 'http://localhost:8083/cinema/login';
  try {
    const signInData = JSON.stringify({ email, password });
    const response = await fetch(apiUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(signInData),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const responseData = await response.json();
    if (responseData.code !== 1000) {
      return responseData.message;
    }

    const token = responseData.result.token;
    const auth = responseData.result.authenticated.toString();
    await saveAuthenticated(auth, token);

    return true;
  } catch (error) {
    console.error('Exception:', error);
    return `Sign-in failed: ${error.message}`;
  }
}
document.getElementById('signInForm').addEventListener('submit', async function(event) {
  event.preventDefault();
  const email = document.getElementById('floatingInput').value;
  const password = document.getElementById('floatingPassword').value;
  const result = await signin(email, password);
  if (result === true) {
    window.location.href = './';
  } else {
    alert(result);
  }
});
