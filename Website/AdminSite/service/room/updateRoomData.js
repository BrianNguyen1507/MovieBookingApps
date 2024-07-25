
import { getRoomById } from "./getRoomById.js";

export async function updateData(id){
    const room = await getRoomById(id);
    console.log(room)
    const selectElement = document.querySelector("#floatingSelectAddForm");
    const numberInput = document.querySelector("#numberInput");
    const columnInput = document.querySelector("#columnInput");
    const rowInput = document.querySelector("#rowInput");

    selectElement.value = room.movieTheater.id;
    numberInput.value = room.number;             
    columnInput.value = room.column;              
    rowInput.value = room.row; 

}
