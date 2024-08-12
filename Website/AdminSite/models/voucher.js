export class Voucher {
  constructor(
    title,
    content,
    typeDiscount,
    minLimit,
    discount,
    quantity,
    expired
  ) {
    this.title = title;
    this.content = content;
    this.typeDiscount = typeDiscount;
    this.minLimit = minLimit;
    this.discount = discount;
    this.quantity = quantity;
    this.expired = expired;
  }
}
