async function saveAuthenticated(auth, token) {
    sessionStorage.setItem('authenticated', auth);
    sessionStorage.setItem('token', token);
  }

  export async function getUserToken() {
    return sessionStorage.getItem('token');
  }