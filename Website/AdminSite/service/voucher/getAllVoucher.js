import { getUserToken } from "../authenticate/authenticate.js";
const url = "http://localhost:8083/cinema/getAllVoucher";
async function getAndDisplayvoucher() {
  try {
    const token = await getUserToken();
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
      const row = document.createElement("tr");

      const indexCell = document.createElement("td");
      indexCell.textContent = index + 1;
      row.appendChild(indexCell);

      const titleVoucher = document.createElement("td");
      titleVoucher.textContent = voucherData.title;
      row.appendChild(titleVoucher);

      const contentVoucher = document.createElement("td");
      contentVoucher.textContent = voucherData.content;
      row.appendChild(contentVoucher);

      const minLimit = document.createElement("td");
      minLimit.textContent = voucherData.minLimit;
      row.appendChild(minLimit);

      const discount = document.createElement("td");
      discount.textContent = voucherData.discount;
      row.appendChild(discount);
      const typeDiscount = document.createElement("td");
      typeDiscount.textContent = TypeofVouvher(voucherData.typeDiscount);
      row.appendChild(typeDiscount);
      const quantity = document.createElement("td");
      quantity.textContent = voucherData.quantity;
      row.appendChild(quantity);

      const expired = document.createElement("td");
      expired.textContent = voucherData.expired;
      row.appendChild(expired);

      const actionCell = document.createElement("td");
      actionCell.innerHTML = `
        <button class="btn btn-primary" data-id="">Edit</button>
        <button class="btn btn-danger" data-id="">Delete</button>
      `;
      row.appendChild(actionCell);

      tbody.appendChild(row);
    });
  } catch (error) {
    console.error("Error fetching and displaying voucher:", error);
  }
}
getAndDisplayvoucher();

function TypeofVouvher(type) {
  return type === 1 ? "Phần trăm" : "Số tiền cố định";
}
