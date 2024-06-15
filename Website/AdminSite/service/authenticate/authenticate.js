export async function getUserToken() {
  return sessionStorage.getItem("token");
}
export async function getName() {
  const name = await sessionStorage.getItem("name");
  const role = await sessionStorage.getItem("role");
  if (!name || !role) {
    return;
  }
  const targetElementName = document.getElementById("data-name-user");
  const targetElementRole = document.getElementById("data-role-user");
  if (targetElementName && targetElementRole) {
    targetElementRole.textContent = role;
    targetElementName.textContent = name;
  } else {
    targetElementName.textContent = name;
  }
}
