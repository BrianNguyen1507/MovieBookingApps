import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";
const apiUrl = "http://103.200.20.167:8083/cinema/updateVoucher?id=";

export async function updateVoucher(voucher, voucherId) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl + voucherId,
      method: "PUT",
      contentType: "application/json",
      headers: {
        Authorization: `Bearer ${tokenUser}`,
      },
      data: JSON.stringify(voucher),
    });

    if (response.code !== 1000) {
      return response.message;
    }

    return true;
  } catch (error) {
    console.error("Exception:", error);
    return error.responseJSON ? getMessageWithCode(error.responseJSON.code): error.message;
  }
}
