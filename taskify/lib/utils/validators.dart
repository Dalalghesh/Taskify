class Validators {
  static String? emptyValidator(String? text) {
    if (text!.isEmpty || text == null || text.trim() == '')
      return 'Please Fill in the field';

    final regExp = RegExp(r'^[a-zA-Z]+$');

    if (!regExp.hasMatch(text.trim())) {
      return 'You cannot enter special characters !@#\%^&*()';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please Fill in the email';
    }

    const p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(gmail.com)$';

    final regExp = RegExp(p, caseSensitive: false);

    if (!regExp.hasMatch(email.trim())) {
      return 'Please Enter Gmail Email Address';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Please Fill in the password';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(
      String? password, String? oldPassword) {
    if (password!.isEmpty) {
      return 'Please fill in the password';
    }

    if (password != oldPassword) {
      return "Passwords don't match";
    }
    return null;
  }

  static String? lengthValidator(String? field, {int length = 4}) {
    if (field!.isEmpty) {
      return 'Please Fill in the field';
    }

    if (field.length < length) {
      return 'Text must be at least $length characters';
    }
    return null;
  }

  static String? lengthVal(String? field, {int length = 15}) {
    if (field!.isEmpty) {
      return 'Please Fill in the field';
    }

    if (field.length < length) {
      return 'Text must be at most $length characters';
    }
    return null;
  }
}
