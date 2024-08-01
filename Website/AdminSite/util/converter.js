export const formatToDmy = (dateString) => {
  const date = new Date(dateString);
  const dd = String(date.getDate()).padStart(2, "0");
  const mm = String(date.getMonth() + 1).padStart(2, "0");
  const yyyy = date.getFullYear();
  return `${dd}-${mm}-${yyyy}`;
};

export const formatToDmyHHmmss = (dateString) => {
  const date = new Date(dateString);
  const dd = String(date.getDate()).padStart(2, "0");
  const yyyy = date.getFullYear();
  const HH = String(date.getHours()).padStart(2, "0");
  const mm = String(date.getMinutes()).padStart(2, "0");
  const ss = String(date.getSeconds()).padStart(2, "0");

  return `${dd}-${mm}-${yyyy} ${HH}:${mm}:${ss}`;
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
  const utf8Bytes = new TextEncoder().encode(input);
  const binaryString = String.fromCharCode(...utf8Bytes);
  return btoa(binaryString);
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

export function translateDateFormat(inputDate) {
  const parts = inputDate.split("-");

  const yyyyMMdd = `${parts[2]}-${parts[1].padStart(
    2,
    "0"
  )}-${parts[0].padStart(2, "0")}`;

  return yyyyMMdd;
}
export function extractYouTubeVideoId(url) {
  const regExp = /https:\/\/youtu\.be\/([a-zA-Z0-9_-]{11})/;

  const match = url.match(regExp);

  return match ? match[1] : null;
}

export function DateConverter(dateTime) {
  const date = dateTime.split("T")[0];
  return date;
}
