const ErrorCode = [
  {
    code: 8888,
    message: "Đối tượng rỗng",
  },
  {
    code: 9999,
    message: "Lỗi không phân loại",
  },
  {
    code: 1001,
    message: "Key không hợp lệ",
  },
  {
    code: 1002,
    message: "Bạn không có quyền truy cập",
  },
  {
    code: 1003,
    message: "Email không hợp lệ",
  },
  {
    code: 1009,
    message: "Email hoặc mật khẩu không chính xác",
  },
  {
    code: 1012,
    message: "Không tìm thấy thể loại",
  },
  {
    code: 1013,
    message: "Không tìm thấy phim",
  },
  {
    code: 1014,
    message: "Phòng đã tồn tại trong rạp chiếu phim",
  },
  {
    code: 1015,
    message: "Tên thể loại rỗng",
  },
  {
    code: 1016,
    message: "Thông tin chưa được điền đầy đủ",
  },
  {
    code: 1017,
    message: "Thời gian chiếu phải từ 90 đến 150 phút",
  },
  {
    code: 1018,
    message: "Chưa xác thực",
  },
  {
    code: 1019,
    message: "Ngày không hợp lệ",
  },
  {
    code: 1020,
    message: "Số không được âm",
  },
  {
    code: 1021,
    message: "Giá không hợp lệ",
  },
  {
    code: 1022,
    message: "Email không tồn tại",
  },
  {
    code: 1023,
    message: "Tên thể loại đã tồn tại",
  },
  {
    code: 1024,
    message: "Tên phim đã tồn tại",
  },
  {
    code: 1028,
    message: "Tài khoản không tồn tại",
  },
  {
    code: 1031,
    message: "Không tìm thấy thức ăn và nước uống",
  },
  {
    code: 1034,
    message: "Vui lòng nhập thông tin đầy đủ",
  },
  {
    code: 1036,
    message: "Lịch chiếu đã đầy",
  },
  {
    code: 1037,
    message: "Không tìm thấy phòng",
  },
  {
    code: 1038,
    message: "Không tìm thấy lịch chiếu phim",
  },
  {
    code: 1039,
    message: "Phim chưa được công chiếu",
  },
  {
    code: 1040,
    message: "Bạn phải xếp lịch sau 7 ngày từ thời điểm hiện tại",
  },
  {
    code: 1043,
    message: "Không tìm thấy ưu đãi",
  },
  {
    code: 1045,
    message: "Không tìm thấy rạp chiếu",
  },
  {
    code: 1046,
    message: "Tên rạp chiếu đã tồn tại",
  },
];
export function getMessageWithCode(code) {
  const error = ErrorCode.find((err) => err.code === code);

  const message = error ? error.message : "Không tìm thấy mã lỗi";
  return message;
}
