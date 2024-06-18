import { getUserToken } from "../authenticate/authenticate.js";
import { typeofVoucher } from "../../util/voucherUtil/typeDiscount.js";
import { symbolType } from "../../util/voucherUtil/typeDiscount.js";
import { Voucher } from "../../models/voucher.js";
import { deleteVoucher } from "./deleteVoucher.js";
import { DateConverter } from "../../util/converter.js";
const url = "http://localhost:8083/cinema/getAllVoucher";

const token = await getUserToken();

export async function getAndDisplayvoucher() {
  try {
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
    });

    const voucher = await response.json();
    if (voucher.code !== 1000) {
      return;
    }

    const tbody = document.querySelector("#voucher-table tbody");
    tbody.innerHTML = "";

    voucher.result.forEach((voucherData, index) => {
      const dateFormat = DateConverter(voucherData.expired);
      const voucher = new Voucher(
        voucherData.title,
        voucherData.content,
        voucherData.minLimit,
        voucherData.discount,
        voucherData.typeDiscount,
        voucherData.quantity,
        voucherData.expired
      );
      const row = document.createElement("tr");

      const indexCell = document.createElement("td");
      indexCell.textContent = index + 1;
      row.appendChild(indexCell);

      const titleVoucher = document.createElement("td");
      titleVoucher.textContent = voucher.title;
      row.appendChild(titleVoucher);

      const contentVoucher = document.createElement("td");
      contentVoucher.textContent = voucher.content;
      row.appendChild(contentVoucher);

      const minLimit = document.createElement("td");
      minLimit.textContent = voucher.minLimit;
      row.appendChild(minLimit);

      const discount = document.createElement("td");
      discount.textContent =
        voucher.discount + symbolType(voucherData.typeDiscount);
      row.appendChild(discount);
      const typeDiscount = document.createElement("td");
      typeDiscount.textContent = typeofVoucher(voucherData.typeDiscount);

      row.appendChild(typeDiscount);
      const quantity = document.createElement("td");
      quantity.textContent = voucher.quantity;
      row.appendChild(quantity);

      const expired = document.createElement("td");
      expired.textContent = voucher.expired;
      row.appendChild(expired);

      const actionCell = document.createElement("td");
      actionCell.innerHTML = `
       <button class="btn btn-primary" id="btn-edit"data-type="${voucherData.typeDiscount}" data-minlimit="${voucher.minLimit}" data-title="${voucher.title}" data-content="${voucher.content}" data-quantity="${voucher.quantity}"data-discount="${voucher.discount}"  data-expired="${dateFormat}"  data-id="${voucherData.id}">Edit</button>
        <button class="btn btn-danger btn-del" data-id="${voucherData.id}">Delete</button>
      `;
      //event del
      const deleteVoucherButton = actionCell.querySelector(".btn-del");
      deleteVoucherButton.addEventListener("click", async () => {
        try {
          const confirmation = await Swal.fire({
            title: "Are you sure?",
            text: "Do you really want to delete this voucher?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, delete it!",
            cancelButtonText: "No, cancel",
          });

          if (confirmation.isConfirmed) {
            const result = await deleteVoucher(voucherData.id);
            if (result) {
              tbody.removeChild(row);
              Swal.fire({
                title: "Deleted!",
                text: `${voucher.title} has been deleted.`,
                icon: "success",
                confirmButtonText: "OK",
              });
            } else {
              Swal.fire({
                title: "Error!",
                text: "Failed to delete the voucher.",
                icon: "error",
                confirmButtonText: "OK",
              });
            }
          } else {
            Swal.fire({
              title: "Cancelled",
              text: "voucher deletion was cancelled.",
              icon: "info",
              confirmButtonText: "OK",
            });
          }
        } catch (error) {
          Swal.fire({
            title: "Error!",
            text: error.message,
            icon: "error",
            confirmButtonText: "OK",
          });
        }
      });
      row.appendChild(actionCell);
      tbody.appendChild(row);
    });
  } catch (error) {
    console.error("Error fetching and displaying voucher:", error);
  }
}
getAndDisplayvoucher();
