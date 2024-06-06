$(document).on("click", "#btn-add-voucher", async function(event) {
    try {
        const { value: formValues } = await Swal.fire({
            title: 'Thêm Voucher Giảm giá',
            html:
                '<div class="col-sm-12">' +
                '<div class="bg-light rounded h-100 p-4">' +
                '<form id="AddVoucherForm">' +
                '<div class="mb-3">' +
                '<label for="voucherTitleInput" class="form-label">Tiêu đề</label>' +
                '<input type="text" class="form-control" id="voucherTitleInput">' +
                '</div>' +
                '<div class="mb-3">' +
                '<label for="voucherContentInput" class="form-label">Nội dung</label>' +
                '<input type="text" class="form-control" id="voucherContentInput">' +
                '</div>' +
                '<div class="mb-3">' +
                '<label for="discountTypeInput" class="form-label">Loại giảm giá</label>' +
                '<select class="form-select" id="discountTypeInput">' +
                '<option value="1">Phần trăm</option>' +
                '<option value="2">Số tiền cố định</option>' +
                '</select>' +
                '</div>' +
                '<div class="mb-3">' +
                '<label for="limitAmountInput" class="form-label">Hạn mức</label>' +
                '<input type="number" class="form-control" id="limitAmountInput">' +
                '</div>' +
                '<div class="mb-3">' +
                '<label for="discountAmountInput" class="form-label">Giảm giá (%)</label>' +
                '<input type="number" class="form-control" id="discountAmountInput">' +
                '</div>' +
                '<div class="mb-3">' +
                '<label for="quantityInput" class="form-label">Số lượng</label>' +
                '<input type="number" class="form-control" id="quantityInput">' +
                '</div>' +
                '<div class="mb-3">' +
                '<label for="expiryDateInput" class="form-label">Ngày hết hạn</label>' +
                '<input type="date" class="form-control" id="expiryDateInput">' +
                '</div>' +
                '<div class="d-grid">' +
                '<button type="submit" class="btn btn-primary btn-outline-dark">Thêm</button>' +
                '</div>' +
                '</form>' +
                '<div id="errorMessageText"></div>' +
                '</div>' +
                '</div>',
            focusConfirm: false,

            preConfirm: () => {
                return [
                    $('#voucherTitleInput').val(),
                    $('#voucherContentInput').val(),
                    $('#discountTypeInput').val(),
                    $('#limitAmountInput').val(),
                    $('#discountAmountInput').val(),
                    $('#quantityInput').val(),
                    $('#expiryDateInput').val()
                ];
            }
        });

        
    } catch (error) {
        console.error(error);
    }
});
