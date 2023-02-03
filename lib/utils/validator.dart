/// Validator patterns for login and register screen
///
/// They are currently not in use and need to be added

class Validator {
  // static const Pattern emailPattern =
  //     '^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})\$';
  // static const Pattern passwordPattern =
  //     '^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}\$';
  // static const Pattern usernamePattern = r'^[a-z0-9_-]{6,}\$';

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$',
  );
  final RegExp passwordRegExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}\$');
  final RegExp usernameRegExp = RegExp(r'[_A-Za-z0-9-]{4,}$');

  String? validateEmail(String email) {
    if (!emailRegExp.hasMatch(email)) {
      return 'Enter a valid Email';
    } else {
      return null;
    }
  }

  String? validatePassword(String password) {
    if (password == '' || password.isEmpty || password == null) {
      return 'Password cannot be empty';
    }

    if (!passwordRegExp.hasMatch(password)) {
      return 'Enter a valid password';
    }

    return null;
  }

  String? validateUsername(String username) {
    if (username == "" || username.isEmpty || username == null) {
      return "Username cannot be blank";
    }

    if (username.contains(' ')) {
      return "Spaces are not allowed";
    }

    if (username.length < 6) {
      return "Username too short";
    }

    if (!usernameRegExp.hasMatch(username)) {
      return 'Enter a valid username';
    }

    return null;
  }
}
