class Validator {
  static String? validateNumber({required String? number}) {
    if (number == null) {
      return null;
    }

    var isNumber = double.tryParse(number) != null;
    if (isNumber) {
      return number;
    } else {
      return null;
    }
  }

  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty.';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter an email address.';
    }

    return null;
  }

  static String? validateFirstName({required String? firstName}) {
    if (firstName == null) {
      return null;
    }
    if (firstName.isEmpty) {
      return 'First name can\'t be empty';
    }

    return null;
  }

  static String? validateBggUsername({required String? bggUsername}) {
    if (bggUsername == null) {
      return null;
    }
    if (bggUsername.isEmpty) {
      return 'Bgg username can\'t be empty';
    }

    return null;
  }

  static bool validateDateTime({required DateTime? date}) {
    if (date == null) {
      return false;
    }

    return true;
  }

  static bool validateGender({required String selectedGender}) {
    if (selectedGender.isEmpty) {
      return false;
    }

    return true;
  }

  static bool validatePhotosArray({required List<String> photosArray}) {
    List<String> tmpPhotos = [];
    for (var i = 0; i < photosArray.length; i++) {
      if (photosArray[i].isNotEmpty) {
        tmpPhotos.add(photosArray[i]);
      }
    }

    if (tmpPhotos.isEmpty) {
      return false;
    }

    return true;
  }

  static String? validatePassword(String password) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
    // should contain at least one upper case
    // should contain at least one lower case
    // should contain at least one digit
    // Must be at least 6 characters in length
    if (password.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(password)) {
        return "Password must be at least 6 characters in length \nand contain at least one upper case, one lower case \nand one digit.";
      } else {
        return null;
      }
    }
  }

  static String? confirmPassword(
      {required String? password, required String? confirmPassword}) {
    print("RFG confirmPassword $password");
    print("RFG confirmPassword $confirmPassword");
    if (confirmPassword!.isEmpty) {
      return "Please enter your password again";
    } else {
      if (password != confirmPassword) {
        return "Password does not match";
      } else {
        return null;
      }
    }
  }
}
