
import { getRoomById } from "./getRoomById";

export async function updateData(id){
    const room = await getRoomById(id);
    console.log(room)
    const selectElement = document.querySelector("#floatingSelectAddForm");
    const numberInput = document.querySelector("#numberInput");
    const columnInput = document.querySelector("#columnInput");
    const rowInput = document.querySelector("#rowInput");
    console.log(room.movieTheater.name);
    selectElement.value = room.movieTheater.id; // Replace "someOptionValue" with the actual value you want to set for the select element
    numberInput.value = room.number;               // Replace "123" with the actual value you want to set for the number input
    columnInput.value = room.column;                 // Replace "A" with the actual value you want to set for the column input
    rowInput.value = room.row; 

}
