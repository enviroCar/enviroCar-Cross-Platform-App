// TODO: Add missing attributes
class User {
  String _username;
  String _password;
  String _email;
  bool _acceptedTerms;
  bool _acceptedPrivacy;

  User(
      {String username,
      String email,
      String password,
      bool acceptedTerms,
      bool acceptedPrivacy}) {
    setUsername = username;
    setEmail = email;
    setPassword = password;
    setAcceptedTerms = acceptedTerms;
    setAcceptedPrivacy = acceptedPrivacy;
  }

  set setUsername(String username) {
    _username = username;
  }

  set setPassword(String password) {
    _password = password;
  }

  set setEmail(String email) {
    _email = email;
  }

  set setAcceptedTerms(bool terms) {
    _acceptedTerms = terms;
  }

  set setAcceptedPrivacy(bool privacy) {
    _acceptedPrivacy = privacy;
  }

  String get getUsername {
    return _username;
  }

  String get getPassword {
    return _password;
  }

  String get getEmail {
    return _email;
  }

  bool get getAccpetedTerms {
    return _acceptedTerms;
  }

  bool get getAccpetedPrivacy {
    return _acceptedPrivacy;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': getUsername,
      'mail': getEmail,
      'token': getPassword,
      'acceptedTerms': getAccpetedTerms,
      'acceptedPrivacy': getAccpetedPrivacy,
    };
  }
}
