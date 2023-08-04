class FormValidation {
  static String? validateEmail(String? value) {
    RegExp regex = RegExp(r'\w+@\w+\.\w+');
    if (value == null || value.isEmpty) {
      return "email alanı boş bırakılamaz.";
    } else if (!regex.hasMatch(value)) {
      return "email formatı yanlıştır.";
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "şifre alanı boş bırakılamaz.";
    } else if (value.length < 6 || value.length > 12) {
      return "şifre 6 ile 12 karakter arası olmalıdır.";
    } else {
      return null;
    }
  }
}
