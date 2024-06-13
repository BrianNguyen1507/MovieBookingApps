import { Voucher } from "../../models/voucher.js";
import { addVoucher } from "./addVoucher.js";
import { formatToDmyHHmmss } from "../../util/converter.js";
import { screenSizeWith } from "../../constant/screenSize.js";
import { getAndDisplayvoucher } from "./getAllVoucher.js";
$(document).on("click", "#btn-add-voucher", async function (event) {
  try {
    const showForm = async () => {
      return await Swal.fire({
        width: screenSizeWith(),
        title: "Thêm Voucher Giảm giá",
        html: `
          <div class="container">
          <div class="row">
          <div class="col-sm-12 col-md-6">
            <div class="bg-light rounded h-100 p-4">
              <form id="AddVoucherForm">
                <div class="mb-3">
                  <label for="voucherTitleInput" class="form-label">Tiêu đề</label>
                  <input type="text" class="form-control" id="voucherTitleInput">
                </div>
                <div class="mb-3">
                  <label for="voucherContentInput" class="form-label">Nội dung</label>
                  <input type="text" class="form-control" id="voucherContentInput">
                </div>
                <div class="mb-3">
                  <label for="discountTypeInput" class="form-label">Loại giảm giá</label>
                  <select class="form-select" id="discountTypeInput">
                    <option value="1">Phần trăm</option>
                    <option value="2">Số tiền cố định</option>
                  </select>
                </div>
              </form>
            </div>
          </div>

          <div class="col-sm-12 col-md-6">
            <div class="bg-light rounded h-100 p-4">
              <form id="AddVoucherForm">
                
                <div class="mb-3">
                  <label for="limitAmountInput" class="form-label">Hạn mức</label>
                  <input type="number" class="form-control" id="limitAmountInput">
                </div>
                <div class="mb-3">
                  <label for="discountAmountInput" class="form-label">Giảm giá (%)</label>
                  <input type="number" class="form-control" id="discountAmountInput">
                </div>
                <div class="mb-3">
                  <label for="quantityInput" class="form-label">Số lượng</label>
                  <input type="number" class="form-control" id="quantityInput">
                </div>
                <div class="mb-3">
                  <label for="expiryDateInput" class="form-label">Ngày hết hạn</label>
                  <input type="datetime-local" class="form-control" id="expiryDateInput">
                </div>
              </form>
              <div "></div>
            </div>
          </div>
          </div>
            <div id="errorMessageText" style="color: red;"></div>
          </div>
        `,
        showCancelButton: true,
        confirmButtonText: "Thêm Voucher",
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
              "All fields are required and must be valid."
            );
            return false;
          }

          const now = new Date();
          const oneDayFromNow = new Date(now.getTime() + 24 * 60 * 60 * 1000);
          const expiryDate = new Date(expiryDateInput);

          if (expiryDate <= oneDayFromNow) {
            Swal.showValidationMessage(
              "Expiry date must be at least one day in the future."
            );
            return false;
          }

          return {
            voucherTitleInput,
            voucherContentInput,
            typeDiscount,
            limitAmountInput,
            discountAmountInput,
            quantityInput,
            formattedExpiryDate: formatToDmyHHmmss(expiryDateInput),
          };
        },
      });
    };

    const { isConfirmed, value } = await showForm();

    if (isConfirmed) {
      const voucher = new Voucher(
        value.voucherTitleInput,
        value.voucherContentInput,
        value.typeDiscount,
        value.limitAmountInput,
        value.discountAmountInput,
        value.quantityInput,
        value.formattedExpiryDate
      );

      const result = await addVoucher(voucher);

      if (result === true) {
        Swal.fire({
          title: "Success!",
          text: "New voucher has been added.",
          icon: "success",
          confirmButtonText: "OK",
        }).then(() => {
          getAndDisplayvoucher();
        });
      } else {
        Swal.fire({
          title: "Error!",
          text: result,
          icon: "error",
          confirmButtonText: "OK",
        }).then(async () => {
          await showForm();
        });
      }
    }
  } catch (error) {
    console.error(error);
  }
});
