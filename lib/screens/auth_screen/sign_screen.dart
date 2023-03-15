import 'package:app_beta/constants/constants.dart';
import 'package:app_beta/screens/main_app_screen/screen_layout.dart';
import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:app_beta/services/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// ignore: must_be_immutable
class SignScreen extends StatelessWidget {
  SignScreen({super.key});

  String? phoneValidator(String? phone) {
    if (phone != null) {
      if (phone.length != 10) {
        return '10 haneli olacak şekilde giriniz';
      } else {
        return null;
      }
    } else {
      return "Lütfen telefon numaranızı giriniz";
    }
  }

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return "Lütfen isminizi giriniz";
    } else {
      savedName = name;
      return null;
    }
  }

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return "Lütfen e-postanızı giriniz";
    } else {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        savedEmail = email;
        return null;
      } else {
        return "Lütfen geçerli bir e-posta giriniz";
      }
    }
  }

  String? referenceValidator(String? reference) {
    if (reference == null || reference.isEmpty) {
      return null;
    } else {
      if (reference.length != 8) {
        return "Lütfen geçerli bir referans kodu giriniz";
      } else {
        savedReference = reference;
        return null;
      }
    }
  }

  Future<String?>? onSwitchToAdditionalFields(SignupData? data) async {
    if (!(await FirebaseCloud().checkIfUserExists(phoneNumber: data?.name))) {
      final returnCode = await FirebaseAuthProvider(FirebaseAuth.instance)
          .signUpWithPhone(data?.name);
      if (returnCode != null && returnCode.isNotEmpty) {
        return "Bir hata oluştu. Lütfen girdiğiniz bilgileri gözden geçiriniz.";
      } else {
        return null;
      }
    } else {
      return "Bu telefon zaten kayıtlı";
    }
  }

  Future<String?>? Function(String, LoginData) onConfirmSignup =
      (String otp, LoginData data) async {
    try {
      String? returnCode =
          await FirebaseAuthProvider(FirebaseAuth.instance).verifyOTP(otp);
      if (returnCode != null && returnCode.isNotEmpty) {
        return "Onaylama esnasında hata çıktı. Lütfen tekrar deneyiniz.";
      } else {
        return null;
      }
    } catch (e) {
      return "Onaylama esnasında hata çıktı. Lütfen tekrar deneyiniz.";
    }
  };

  Future<String?>? Function(SignupData) onSignup = (SignupData data) async {
    try {
      final returnCode =
          await FirebaseAuthProvider(FirebaseAuth.instance).addUserInfo(
        savedEmail,
        savedName,
        savedReference,
      );
      if (returnCode != null && returnCode.isNotEmpty) {
        return "Bir hata oluştu. Lütfen bilgilerinizi gözden geçirip tekrar deneyin.";
      } else {
        return null;
      }
    } catch (e) {
      return "Bir hata oluştu. Lütfen bilgilerinizi gözden geçirip tekrar deneyin.";
    }
  };

  Future<String?>? onLogin(LoginData data) async {
    if (await FirebaseCloud().checkIfUserExists(phoneNumber: data.name)) {
      final returnCode = await FirebaseAuthProvider(FirebaseAuth.instance)
          .signUpWithPhone(data.name);
      if (returnCode != null && returnCode.isNotEmpty) {
        return "Bir hata oluştu. Lütfen girdiğiniz bilgileri gözden geçiriniz.";
      } else {
        return null;
      }
    } else {
      return "Bu telefon kayıtlı değil";
    }
  }

  Future<String?>? Function(SignupData) onResendCode = (SignupData data) async {
    final returnCode = await FirebaseAuthProvider(FirebaseAuth.instance)
        .signUpWithPhone(data.name);
    if (returnCode != null && returnCode.isNotEmpty) {
      return "Bir hata oluştu. Lütfen girdiğiniz bilgileri gözden geçiriniz.";
    } else {
      return null;
    }
  };

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: appName,
      theme: LoginTheme(
        primaryColor: primaryColor,
        accentColor: accentColor,
        errorColor: errorColor,
        titleStyle: const TextStyle(
          fontSize: 45.0,
          color: lightTextColor,
        ),
      ),
      logo: const AssetImage(logo),
      onLogin: onLogin,
      logoTag: logoTag,
      onSignup: onSignup,
      userType: LoginUserType.phone,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ScreenLayout(),
        ));
      },
      onRecoverPassword: (_) => Future(() => null),
      messages: loginMessages,
      userValidator: phoneValidator,
      navigateBackAfterRecovery: true,
      hidePassword: true,
      hideForgotPasswordButton: true,
      additionalSignupFields: [
        UserFormField(
          keyName: "İsim Soyisim",
          fieldValidator: nameValidator,
        ),
        UserFormField(
          keyName: "Email",
          icon: const Icon(Icons.email_outlined),
          fieldValidator: emailValidator,
        ),
        UserFormField(
          keyName: "Referans (Opsiyonel)",
          fieldValidator: referenceValidator,
          icon: const Icon(Icons.keyboard_command_key_outlined),
        ),
      ],
      onSwitchToAdditionalFields: onSwitchToAdditionalFields,
      onConfirmSignup: onConfirmSignup,
      confirmSignupKeyboardType: TextInputType.number,
      onResendCode: onResendCode,
      /*TODO

      ------GİRİŞ EKRANINI GÜZELLEŞTİRMEK İÇİN------
      onsubmitanimationcompleted'da logotag ve titletag ile güzel bir animasyon yapılıyor sanırım
      
      
      ------TERMS OF SERVİCES------
      terms of services oluşturalacak, henüz nasıl bilmiyorum

      ------GİRİŞ EKRANINI DOLU GÖSTERMEK İÇİN------
      children belki instagram twitter gibi hesap linki ekleyebiliriz
      belki footer

      */
    );
  }
}
