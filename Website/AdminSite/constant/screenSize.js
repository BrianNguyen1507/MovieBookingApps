export function screenSizeWith() {
  const screenWidth = window.innerWidth;
  const width = Math.min(screenWidth * 0.8, 1000);
  return `${width}px`;
}
