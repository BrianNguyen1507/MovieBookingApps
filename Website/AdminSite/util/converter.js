export const formatToDmy = (dateString) => {
  const date = new Date(dateString);
  const dd = String(date.getDate()).padStart(2, "0");
  const mm = String(date.getMonth() + 1).padStart(2, "0");
  const yyyy = date.getFullYear();
  return `${dd}-${mm}-${yyyy}`;
};
export const formatToYmd = (dateString) => {
  const date = new Date(dateString);
  const dd = String(date.getDate()).padStart(2, "0");
  const mm = String(date.getMonth() + 1).padStart(2, "0");
  const yyyy = date.getFullYear();
  return `${yyyy}-${mm}-${dd}`;
};

export function handleFileSelect(event) {
  const file = event.target.files[0];
  if (!file) {
    return;
  }
  const reader = new FileReader();
  reader.onload = function (e) {
    const base64String = e.target.result.split(",")[1];
    $("#posterInput").data("base64", base64String);
  };
  reader.readAsDataURL(file);
}
export function stringToBase64(input) {
  return btoa(input);
}

export function base64ToString(base64) {
  try {
    const decodedData = atob(base64);

    let stringData = "";
    for (let i = 0; i < decodedData.length; i++) {
      stringData += String.fromCharCode(decodedData.charCodeAt(i));
    }

    return decodeURIComponent(escape(stringData));
  } catch (error) {
    console.error("Error decoding Base64 string:", error);
    return null;
  }
}

export function base64ToImage(base64) {
  return `data:image/jpeg;base64,${base64}`;
}
