// TODO: Add missing attributes
class User {
  late String _username;
  late String _password;
  String? _email;
  late bool _acceptedTerms;
  late bool _acceptedPrivacy;

  User({
    required String username,
    String? email,
    required String password,
    required bool acceptedTerms,
    required bool acceptedPrivacy,
  }) {
    setUsername = username;
    if (email != null) {
      setEmail = email;
    }
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

  String? get getEmail {
    return _email;
  }

  bool get getAcceptedTerms {
    return _acceptedTerms;
  }

  bool get getAcceptedPrivacy {
    return _acceptedPrivacy;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': getUsername,
      'mail': getEmail,
      'token': getPassword,
      'acceptedTerms': getAcceptedTerms,
      'acceptedPrivacy': getAcceptedPrivacy,
    };
  }
}
