export function typeofVoucher(type) {
  return type === 1 ? "Phần trăm" : "Tiền cố định";
}

export function symbolType(type) {
  return type === 1 ? "%" : "₫";
}
export function setVoucherTypeDiscount(value) {
  $("#discountTypeInput").val(value);
  console.log(value);
}
