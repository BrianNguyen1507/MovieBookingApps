import { giftVoucher } from "./giftVoucher.js";
import { screenSizeWith } from "../../constant/screenSize.js";

$(document).on("click", "#btn-gift-voucher", async function (event) {
    try {
        const dataId = this.getAttribute("data-id");
        const dataTitle = this.getAttribute("data-title");
        console.log(dataTitle);
        const showForm = async () => {
            return await Swal.fire({
                width: screenSizeWith(),
                title: "Tặng voucher" ,
                html: `
                <h3>${dataTitle}</h3>
                <div class="mb-3">
                    <label for="uantity-gift" class="form-label">Số lượng</label>
                    <input type="number" class="form-control" id="quantity-gift" />
                </div>
            `,
                showCancelButton: true,
                confirmButtonText: "Tặng voucher",
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    const quantity = $("#quantity-gift").val().trim();
                    if (!quantity) {
                        Swal.showValidationMessage(
                            "All fields are required and must be valid."
                        );
                        return false;
                    }

                    return {
                        id:dataId,
                        quantity: quantity,
                    };
                },
            });
        };
        const { value, isConfirmed } = await showForm();
        if (isConfirmed) {
            let result = await giftVoucher(value.quantity,value.id);
            if (result === true) {
                Swal.fire({
                    title: "Success!",
                    text: "Voucher has been added for all account.",
                    icon: "success",
                    confirmButtonText: "OK",
                }).then(() => {
                    getAllRoom();
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
        Swal.fire({
            title: "Error!",
            text: "An unexpected error occurred.",
            icon: "error",
            confirmButtonText: "OK",
        });
    }
});