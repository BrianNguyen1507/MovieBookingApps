import { classify } from "../models/classify.js";

export function populateSelectWithOptions(classityValue) {
  const selectElement = document.getElementById("classifyInput");
  for (let key in classify) {
    if (Object.prototype.hasOwnProperty.call(classify, key)) {
      let option = document.createElement("option");
      option.value = classify[key];
      option.text = classify[key];
      selectElement.appendChild(option);
      if (classify[key] == classityValue) {
        option.selected = true;
      }
    }
  }
}
