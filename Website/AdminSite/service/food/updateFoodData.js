import { Food } from "../../models/food";

export async function updateFoodData(id, image, name, price) {
  const food = new Food(id, image, name, price);
  const imagePreview = document.querySelector("#imagePreview");
  const nameInput = document.querySelector("#nameInput");
  const priceInput = document.querySelector("#priceInput");

  imagePreview.src = `data:image/png;base64,${food.image}`;
  imagePreview.style.display = "block";
  nameInput.value = food.name;
  priceInput.value = food.price;
}
