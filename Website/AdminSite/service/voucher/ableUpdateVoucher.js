import { Voucher } from "../../models/voucher.js";
import { updateVoucher } from "./updateVoucher.js";
import { screenSizeWith } from "../../constant/screenSize.js";
import { getAndDisplayvoucher } from "./getAllVoucher.js";

$(document).on("click", "#btn-edit", async function (event) {
  const voucherId = $(this).data("id");
  const voucherTitle = $(this).data("title");
  const voucherContent = $(this).data("content");
  const voucherDiscount = $(this).data("discount");
  const voucherQuantity = $(this).data("quantity");
  const voucherExpired = $(this).data("expired");
  const voucherMinLimit = $(this).data("minlimit");
  const voucherTypeDiscount = $(this).data("type");
  updateVoucherForm(voucherId,voucherTitle,voucherContent,voucherDiscount,voucherQuantity,voucherExpired,voucherMinLimit,voucherTypeDiscount);
});
async function updateVoucherForm(voucherId,voucherTitle,voucherContent,voucherDiscount,voucherQuantity,voucherExpired,voucherMinLimit,voucherTypeDiscount) {
  try {
    const showForm = async () => {
      return await Swal.fire({
        width: screenSizeWith(),
        title: "Cập nhật Voucher Giảm giá",
        html: `
        <div class="container">
          <div class="row">
          <div class="col-sm-12 col-md-6">
            <div class="bg-light rounded h-100 p-4">
                <form id="updateVoucherForm">
                  <div class="mb-3">
                    <label for="voucherTitleInput" class="form-label">Tiêu đề</label>
                    <input type="text" value="${voucherTitle}" class="form-control" id="voucherTitleInput">
                  </div>
                  <div class="mb-3">
                    <label for="voucherContentInput" class="form-label">Nội dung</label>
                    <input type="text" value="${voucherContent}" class="form-control" id="voucherContentInput">
                  </div>
                  <div class="mb-3">
                    <label for="discountTypeInput" class="form-label">Loại giảm giá</label>
                    <select class="form-select" id="discountTypeInput">
                      <option id="percentageOption" value="1">Phần trăm</option>
                      <option id="fixedAmountOption" value="2">Số tiền cố định</option>
                    </select>
                  </div>
                </form>
              </div>
            </div>
        
            <div class="col-sm-12 col-md-6">
            <div class="bg-light rounded h-100 p-4">
                <form id="updateVoucherForm">
                  <div class="mb-3">
                    <label for="limitAmountInput" class="form-label">Hạn mức</label>
                    <input type="number" value="${voucherMinLimit}" class="form-control" id="limitAmountInput">
                  </div>
                  <div class="mb-3">
                    <label for="discountAmountInput" class="form-label">Giảm giá (%)</label>
                    <input type="number" value="${voucherDiscount}" class="form-control" id="discountAmountInput">
                  </div>
                  <div class="mb-3">
                    <label for="quantityInput" class="form-label">Số lượng</label>
                    <input type="number" value="${voucherQuantity}" class="form-control" id="quantityInput">
                  </div>
                  <div class="mb-3">
                    <label for="expiryDateInput" class="form-label">Ngày hết hạn</label>
                    <input type="date" class="form-control" value="${voucherExpired}"  id="expiryDateInput">
                  </div>
                </form>
              </div>
            </div>
          </div>
            <div id="errorMessageText" style="color: red;"></div>
        </div>
        `,

        didOpen: () => {
          const selectElement = $("#discountTypeInput");
          selectElement.val(voucherTypeDiscount);
        },
        showCancelButton: true,
        confirmButtonText: "Cập nhật Voucher",
        showLoaderOnConfirm: true,

        preConfirm: () => {
          const voucherTitleInput = $("#voucherTitleInput").val().trim();
          const voucherContentInput = $("#voucherContentInput").val().trim();
          const typeDiscount = parseInt($("#discountTypeInput").val(), 10);
          const limitAmountInput = parseInt($("#limitAmountInput").val(), 10);
          const discountAmountInput = parseInt(
            $("#discountAmountInput").val(),
            10
          );
          const quantityInput = parseInt($("#quantityInput").val(), 10);
          const expiryDateInput = $("#expiryDateInput").val();

          if (
            !voucherTitleInput ||
            !voucherContentInput ||
            isNaN(typeDiscount) ||
            isNaN(limitAmountInput) ||
            isNaN(discountAmountInput) ||
            isNaN(quantityInput) ||
            !expiryDateInput
          ) {
            Swal.showValidationMessage(
             "Vui lòng nhập đầy đủ thông tin."
            );
            return false;
          }

          const now = new Date();
          const oneDayFromNow = new Date(now.getTime() + 24 * 60 * 60 * 1000);
          const expiryDate = new Date(expiryDateInput);

          if (expiryDate <= oneDayFromNow) {
            Swal.showValidationMessage(
              "Ngày hết hạn phải cách ít nhất một ngày trong tương lai."
            );
            return false;
          }

          return {
            title: voucherTitleInput,
            content: voucherContentInput,
            typeDiscount: typeDiscount,
            minLimit: limitAmountInput,
            discount: discountAmountInput,
            quantity: quantityInput,
            expiryDate: expiryDateInput,
          };
        },
      });
    };

    const { isConfirmed, value } = await showForm();

    if (isConfirmed) {
      const voucher = new Voucher(
        value.title,
        value.content,
        value.typeDiscount,
        value.minLimit,
        value.discount,
        value.quantity,
        value.expiryDate
      );

      const result = await updateVoucher(voucher, voucherId);

      if (result === true) {
        Swal.fire({
          title: "Thành công!",
          text: "Ưu đãi đã được sửa.",
          icon: "success",
          confirmButtonText: "OK",
        }).then(() => {
          getAndDisplayvoucher();
        });
      } else {
        Swal.fire({
          title: "Thất bại!",
          text: result,
          icon: "error",
          confirmButtonText: "OK",
        }).then(async () => {
          await updateVoucherForm(voucherId,voucherTitle,voucherContent,voucherDiscount,voucherQuantity,voucherExpired,voucherMinLimit,voucherTypeDiscount);
        });
      }
    }
  } catch (error) {
    console.error(error);
  }
}