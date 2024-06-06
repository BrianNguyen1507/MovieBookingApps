export function saveAuthenticated(auth, token) {
  sessionStorage.setItem('authenticated', auth);
  sessionStorage.setItem('token', token);
}

export async function getUserToken() {
  return sessionStorage.getItem('token');
}

export async function logout() {
  window.location.href = "./signin.html";
  return sessionStorage.clear();
}

export async function initCheckin() {
  const token = await getUserToken();
  if (!token) {
      window.location.href = "./signin.html";
      return sessionStorage.clear();
  }
}
