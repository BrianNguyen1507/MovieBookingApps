class ValidReponse {
  final int code;

  const ValidReponse._(this.code);

  static String getMessage(int code, context) {
    switch (code) {
      case 1030:
        return 'Không tìm thấy vé';
      case 1041:
        return 'Vé đã được sử dụng hoặc đã hết hạn';
      case 1047:
        return 'Vé chưa đến thời gian chiếu. Vui lòng quay lại sau.';
      default:
        return 'Không tìm thấy vé';
    }
  }
}
