import { getUserToken } from "../authenticate/authenticate.js";
import { typeofVoucher } from "../../util/voucherUtil/typeDiscount.js";
import { symbolType } from "../../util/voucherUtil/typeDiscount.js";
import { Voucher } from "../../models/voucher.js";

const url = "http://103.200.20.167:8083/cinema/getAllVoucher";

const token = await getUserToken();

export async function getAndDisplayGiftVoucher() {
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
    const tbody = document.querySelector("#gift-table tbody");
    tbody.innerHTML = "";

    voucher.result.forEach((voucherData, index) => {
      const voucher = new Voucher(
        voucherData.title,
        voucherData.content,
        voucherData.typeDiscount,
        voucherData.minLimit,
        voucherData.discount,
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

      const actionCell = document.createElement('td');
      actionCell.innerHTML = `
        <button class="btn btn-primary" id="btn-gift-voucher" data-id="${voucherData.id}" data-title ="${voucherData.title}">Tặng voucher</button>
      `;
      row.appendChild(actionCell);
      tbody.appendChild(row);

    
    });
  } catch (error) {
    console.error("Error fetching and displaying voucher:", error);
  }
}
getAndDisplayGiftVoucher();
