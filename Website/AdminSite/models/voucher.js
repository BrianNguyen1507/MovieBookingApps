export class Voucher {
    constructor(id,title, content, typeDiscount, minLimit, discount, quantity, expired) {
      this.id = id;
      this.title = title;
      this.content = content;
      this.typeDiscount = typeDiscount;
      this.minLimit = minLimit;
      this.discount = discount;
      this.quantity = quantity;
      this.expired = expired;
    }
  }
  