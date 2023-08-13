bool isPhoneNumber(String input) {
  // Remove any non-digit characters
  String digits = input.replaceAll(RegExp(r'\D'), '');

  // A basic check for US phone numbers (10 digits)
  if (digits.length == 10) {
    return true;
  }

  // You can add additional checks for other formats here

  return false;
}