// ignore_for_file: unnecessary_null_comparison
import '../app_constants.dart';

class AppValidator {
  static String? confirmPasswordValidator(confirmpassword, String password) {
    if (confirmpassword == null) return "confirmPasswordEmptyMsg";

    if (confirmpassword.isEmpty) {
      return "ConfirmPasswordEmptyMsg";
    } else if (confirmpassword.length < 6) {
      return "confirmPasswordGreaterThanMsg";
    } else if (confirmpassword != password) {
      return "confirmPasswordNotMatch";
    }
    return null;
  }

  static String? emailValidator(emailAddress) {
    if (emailAddress == null) return Constants.emailEmptyMsg;

    bool emailValid = RegExp(Constants.regExpEmail).hasMatch(emailAddress);

    if (emailAddress == "") {
      return Constants.emailEmptyMsg;
    } else if (!emailValid) {
      return Constants.invalidEmailAddressMsg;
    }
    return null;
  }

  static String? passwordSignInValidator(password) {
    if (password == null) return Constants.passwordEmptyMsg;
    if (password.isEmpty) {
      return Constants.passwordEmptyMsg;
    }
    return null;
  }

  // static String? requiredName(value) {
  //   if (value == null || valueim().isEmpty) {
  //     return Constants.fieldRequiredMsg;
  //   }
  //   return null;
  // }
  static String? fullNameValidator(fullname) {
    if (fullname == null || fullname.trim().isEmpty) return Constants.fullnameEmptyMsg;

    bool fullNameValid = RegExp(Constants.regExpFullName).hasMatch(fullname);

    if (fullname == "") {
      return Constants.fullnameEmptyMsg;
    } else if (!fullNameValid) {
      return Constants.enterAlphabetsMsg;
    }
    return null;
  }

  // static String? fullNameValidator(String? fullname) {
//   if (fullname == null || fullname.isEmpty) {
//     return Constants.fullnameEmptyMsg;
//   }

//   bool fullNameValid = RegExp(Constants.regExpFullName).hasMatch(fullname);

//   if (!fullNameValid) {
//     return Constants.enterAlphabetsMsg;
//   }

//   // Check if the name contains spaces
//   if (fullname.contains(" ")) {
//     return "Full name should not contain spaces";
//   }

//   return null;
// }

  static String? otpValidator(otp) {
    // if (otp == null) return "otpEmptyMsg";

    if (otp == "") {
      return Constants.otpEmptyMsg;
    } else if (otp.length < 4) {
      return Constants.invalidOtpAddressMsg;
    }
    return null;
  }

  static String? passwordValidator(password) {
    if (password == null) return Constants.passwordEmptyMsg;
    String pattern = Constants.regExpPassword;
    RegExp regExp = RegExp(pattern);
    bool passwordValid = regExp.hasMatch(password);

    if (password.isEmpty) {
      return Constants.passwordEmptyMsg;
    } else if (password.length < 6) {
      return Constants.passwordGreaterThanMsg;
    } else if (!passwordValid) {
      return Constants.enterValidPasswordHintMsg;
    }
    return null;
  }
  static String? newPasswordValidator(password) {
    if (password == null) return Constants.passwordEmptyMsg;
    String pattern = Constants.regExpPassword;
    RegExp regExp = RegExp(pattern);
    bool passwordValid = regExp.hasMatch(password);

    if (password.isEmpty) {
      return Constants.passwordNewEmptyMsg;
    } else if (password.length < 6) {
      return Constants.passwordGreaterThanMsg;
    } else if (!passwordValid) {
      return Constants.enterValidPasswordHintMsg;
    }
    return null;
  }

  static String? phoneValidator(phone) {
    if (phone.isEmpty) {
      return Constants.phoneNumberEmptyMsg;
    }
    // else if ((phone.contains(RegExp(Constants.regExpPhoneNumber))) &&
    //     (phone.contains('-'))) {
    //   return Constants.enterValidPhoneNoHintMsg;
    // }
    else if (phone.length > 16) {
      return Constants.enterValidPhoneNoMsg;
    } else if (phone.length < 9) {
      return Constants.enterValidPhoneNoMsg;
    }
    // else if (phone[0] != "+" || phone[1] != "1") {
    //   return Constants.enterValidPhoneNoPlus;
    // }
    return null;
  }

  static String? required(value) {
    if (value == null || value.trim().isEmpty) {
      return Constants.fieldRequiredMsg;
    }
    return null;
  }

  static String? onlyNumber(value) {
    if (value == null || value.trim().isEmpty) {
      return Constants.fieldRequiredMsg;
    } else if (value.toString().contains(',')) {
      return '';
    }
    return null;
  }

  static String? requiredCode(value) {
    if (value == null || value.isEmpty) {
      return "+1";
    }
    return null;
  }

  static String? requiredNull(value) {
    if (value == null || value.isEmpty) {
      return "";
    }
    return null;
  }

  static String? userNameValidator(username) {
    if (username == null) return Constants.usernameEmptyMsg;

    bool userNameValid = RegExp(Constants.regExpUserName).hasMatch(username);

    if (username == "") {
      return Constants.usernameEmptyMsg;
    }
    // else if (!userNameValid) {
    //   return Constants.enterValidUsernameMsg;
    // }
    return null;
  }
}

extension ExtString on String {
  bool get isNotNull {
    return this != null;
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}
