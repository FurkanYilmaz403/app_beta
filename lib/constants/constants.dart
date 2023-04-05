import 'package:app_beta/screens/main_app_screen//home_screen.dart';
import 'package:app_beta/screens/main_app_screen/cart_screen.dart';
import 'package:app_beta/screens/main_app_screen/orders_screen.dart';
import 'package:app_beta/screens/main_app_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

List<Widget> screens = [
  const HomeScreen(),
  const CartScreen(),
  const OrdersScreen(),
  const ProfileScreen(),
];

const String logo = "assets/images/logo.jpg";
const String vegetables = "assets/images/vegetables.jpg";

const String appName = "Uygulama İsmi";

const Color primaryColor = Color(0xFF1D3557);
const Color secondaryColor = Color(0xFFF1FAEE);
const Color accentColor = Color(0xFFFFC107);
const Color backgroundColor = Color(0xFFA8DADC);
const Color lightTextColor = Color(0xFFECEFF1);
const Color darkTextColor = Color(0xFF2D3436);
const Color errorColor = Color(0xFFE63946);
const Color successColor = Color(0xFF2ECC71);
const Color warningColor = Color(0xFFF77F00);
const Color infoColor = Color(0xFF118AB2);

final loginMessages = LoginMessages(
  userHint: "Telefon No",
  passwordHint: "Şifre",
  confirmPasswordHint: "Şifreyi doğrulayın",
  forgotPasswordButton: "Şifrenizi mi unuttunuz?",
  loginButton: "Giriş Yap",
  signupButton: "Kayıt Ol",
  recoverPasswordButton: "Sıfırla",
  recoverPasswordIntro: "Şifrenizi sıfırlayın",
  recoverPasswordDescription:
      "Bu telefon numarasına bir onay kodu göndereceğiz",
  goBackButton: "Geri dön",
  confirmPasswordError: "Şifreler eşleşmiyor",
  recoverPasswordSuccess: "Kod gönderildi",
  flushbarTitleError: "Hata",
  flushbarTitleSuccess: "Başarılı",
  signUpSuccess: "Telefonunuza onay kodu gönderildi",
  providersTitleFirst: "ya da burdan devam edin",
  providersTitleSecond: "ya da",
  additionalSignUpSubmitButton: "Onayla",
  additionalSignUpFormDescription:
      "Hesabınızı oluşturmamız için lütfen bilgilerinizi girin",
  confirmSignupIntro: "Telefonunuza bir onay kodu gönderildi. "
      "Lütfen onay kodunu giriniz",
  confirmationCodeHint: "Onay kodu",
  confirmationCodeValidationError: "Hatalı kod",
  resendCodeButton: "Yeni kod gönder",
  resendCodeSuccess: "Yeni bir kod gönderildi",
  confirmSignupButton: "Onayla",
  confirmSignupSuccess: "Hesap oluşturuldu",
  confirmRecoverIntro: "Telefon doğrulandı",
  recoveryCodeHint: "Sıfırlama kodu",
  recoveryCodeValidationError: "Sıfırlama kodu hatalı",
  setPasswordButton: "Şifre belirle",
  confirmRecoverSuccess: "Şifre yenilendi",
  recoverCodePasswordDescription:
      "Şifreyi sıfırlamak için telefonunuza onay kodu göndereceğiz",
);

String verificationIdSaved = "";
String savedName = "";
String savedEmail = "";
String savedReference = "";

const logoSize = 100.0;
const addressSize = 50.0;

const logoTag = "uniqueLogoTag";

const googleMapsDistanceMatrixApiKey =
    "AIzaSyBAnafgLncUjEYYgsOvCJcQQfCmLdTc8Jk";

const minCart = 50;
