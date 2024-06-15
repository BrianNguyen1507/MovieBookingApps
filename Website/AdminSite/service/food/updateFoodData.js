import { getFoodById } from "./getFoodById";

export async function updateFoodData(id){
    const food = await getFoodById(id);
    console.log(food);
    const imagePreview = document.querySelector("#imagePreview");
    const nameInput = document.querySelector("#nameInput");
    const priceInput = document.querySelector("#priceInput");

    imagePreview.src = `data:image/png;base64,${food.image}`; 
    imagePreview.style.display = 'block';           
    nameInput.value = food.name;              
    priceInput.value = food.price; 
}