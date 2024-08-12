import { getMessageWithCode } from "../../util/exception/exception.js";
import { getUserToken } from "../authenticate/authenticate.js";

const apiUrl = "http://localhost:8083/cinema/addVoucher";

 export async function addVoucher(voucher) {
  try {
    const tokenUser = await getUserToken();
    const response = await $.ajax({
      url: apiUrl,
      method: 'POST',
      contentType: 'application/json',
      headers: {
        'Authorization': `Bearer ${tokenUser}`
      },
      data: JSON.stringify(voucher)
    });

    return true;
  } catch (error) {
    console.error('Exception:', error);
    return error.responseJSON ? getMessageWithCode(error.responseJSON.code) : error.message;
  }
}
