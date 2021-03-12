class Validator {
  static const Pattern emailPattern =
      '^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})\$';
  static const Pattern passwordPattern =
      '^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}\$';
  static const Pattern usernamePattern = '^[a-z0-9_-]{6,}\$';

  final RegExp emailRegExp = RegExp(emailPattern);
  final RegExp passwordRegExo = RegExp(passwordPattern);
  final RegExp usernameRegExp = RegExp(usernamePattern);

  String validateEmail(String email) {
    if (!emailRegExp.hasMatch(email)) {
      return 'Enter a valid Email';
    } else {
      return null;
    }
  }

  String validatePassword(String password) {
    if (!passwordRegExo.hasMatch(password)) {
      return 'Enter a valid password';
    } else {
      return null;
    }
  }

  String validateUsername(String username) {
    if (!usernameRegExp.hasMatch(username)) {
      return 'Enter a valid username';
    } else {
      return null;
    }
  }
}
