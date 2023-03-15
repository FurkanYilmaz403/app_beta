// import 'package:app_beta/services/firebase_auth_provider.dart';
// import 'package:app_beta/utilities/functions/utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// class SignInAndSignUpScreen extends StatefulWidget {
//   const SignInAndSignUpScreen({super.key});

//   @override
//   State<SignInAndSignUpScreen> createState() => _SignInAndSignUpScreenState();
// }

// class _SignInAndSignUpScreenState extends State<SignInAndSignUpScreen> {
//   final screenSize = Utils().getScreenSize();
//   final _formKey1 = GlobalKey<FormState>();
//   final _formKey2 = GlobalKey<FormState>();
//   PhoneNumber initialNumber = PhoneNumber(isoCode: 'TR');
//   PhoneNumber number = PhoneNumber(isoCode: 'TR');
//   bool _phoneIsValid = false;

//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _registerEmail = TextEditingController();
//   final TextEditingController _registerName = TextEditingController();
//   final TextEditingController _registerPhone = TextEditingController();
//   final TextEditingController _registerReference = TextEditingController();

//   void scrollDown() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   void scrollUp() async {
//     _scrollController.animateTo(
//       0.0,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   void getPhoneNumber(String phoneNumber) async {
//     PhoneNumber number =
//         await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

//     setState(() {
//       this.number = number;
//     });
//   }

//   void signUpWithPhone() async {
//     await FirebaseAuthProvider(FirebaseAuth.instance).signUpWithPhone(
//       context,
//       number.phoneNumber!,
//       _registerReference.text,
//     );
//     await FirebaseAuthProvider(FirebaseAuth.instance).addUserInfo(
//       number.phoneNumber!,
//       _registerEmail.text.trim(),
//       _registerName.text.trim(),
//       _registerReference.text,
//     );
//   }

//   @override
//   void dispose() {
//     _registerPhone.dispose();
//     _registerEmail.dispose();
//     _registerName.dispose();
//     _registerReference.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/images/bg4.jpg"),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: ListView(
//           controller: _scrollController,
//           children: [
//             Center(
//               child: CustomPaint(
//                 painter: SignIn(),
//                 child: SizedBox(
//                   width: screenSize.width * 0.85,
//                   height: screenSize.height * 0.85,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Form(
//                       key: _formKey1,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Image.asset(
//                             "assets/images/248.jpg",
//                             width: 200,
//                             height: 200,
//                             color: Colors.black,
//                           ),
//                           TextFormField(
//                             decoration: const InputDecoration(
//                               labelText: 'Email',
//                               labelStyle: TextStyle(color: Colors.black),
//                             ),
//                             style: const TextStyle(color: Colors.black),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               return null;
//                             },
//                           ),
//                           TextFormField(
//                             decoration: const InputDecoration(
//                               labelText: 'Password',
//                               labelStyle: TextStyle(color: Colors.black),
//                             ),
//                             obscureText: true,
//                             style: const TextStyle(color: Colors.black),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter your password';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: () {},
//                             child: const Text('Sign in'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               scrollDown();
//                             },
//                             child: const Text('Sign up'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Center(
//               child: CustomPaint(
//                 painter: SignUp(),
//                 child: SizedBox(
//                   width: screenSize.width * 0.85,
//                   height: screenSize.height * 0.85,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Form(
//                       key: _formKey2,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Image.asset(
//                             "assets/images/248.jpg",
//                             width: 200,
//                             height: 200,
//                             color: Colors.black,
//                           ),
//                           TextFormField(
//                             controller: _registerName,
//                             decoration: const InputDecoration(
//                               labelText: 'Ad Soyad',
//                               labelStyle: TextStyle(color: Colors.black),
//                             ),
//                             style: const TextStyle(color: Colors.black),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return "Lütfen isim giriniz.";
//                               }
//                               return null;
//                             },
//                           ),
//                           TextFormField(
//                             controller: _registerEmail,
//                             decoration: const InputDecoration(
//                               labelText: 'E-posta',
//                               labelStyle: TextStyle(color: Colors.black),
//                             ),
//                             style: const TextStyle(color: Colors.black),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Lütfen e-posta adresi giriniz.';
//                               }
//                               return null;
//                             },
//                           ),
//                           InternationalPhoneNumberInput(
//                             onInputChanged: (PhoneNumber number) {
//                               getPhoneNumber(number.phoneNumber!);
//                             },
//                             onInputValidated: (bool value) {
//                               setState(() {
//                                 _phoneIsValid = value;
//                               });
//                             },
//                             errorMessage: null,
//                             hintText: null,
//                             inputDecoration: InputDecoration(
//                               suffixIcon: _phoneIsValid
//                                   ? const Icon(
//                                       Icons.check_circle_rounded,
//                                       color: Colors.green,
//                                     )
//                                   : const Icon(
//                                       Icons.close_rounded,
//                                       color: Colors.red,
//                                     ),
//                             ),
//                             selectorConfig: const SelectorConfig(
//                               selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                             ),
//                             ignoreBlank: false,
//                             initialValue: initialNumber,
//                             autoValidateMode: AutovalidateMode.disabled,
//                             selectorTextStyle:
//                                 const TextStyle(color: Colors.black),
//                             textFieldController: _registerPhone,
//                             formatInput: true,
//                             keyboardType: const TextInputType.numberWithOptions(
//                                 signed: false, decimal: true),
//                             inputBorder: const OutlineInputBorder(),
//                           ),
//                           TextFormField(
//                             controller: _registerReference,
//                             decoration: const InputDecoration(
//                               labelText: 'Referans Kodu',
//                               labelStyle: TextStyle(color: Colors.black),
//                             ),
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                           const SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: () {
//                               scrollUp();
//                             },
//                             child: const Text('Sign in'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey2.currentState!.validate()) {
//                                 signUpWithPhone();
//                               }
//                             },
//                             child: const Text('Kayıt Ol'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignIn extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     const Gradient gradient = LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [
//         Color.fromARGB(255, 254, 235, 250),
//         Color.fromARGB(255, 235, 159, 244)
//       ],
//       tileMode: TileMode.clamp,
//     );

//     final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
//     final Paint paint = Paint()..shader = gradient.createShader(colorBounds);

//     Path path = Path();
//     path.moveTo(0, 20);
//     path.lineTo(0, size.height * 0.75 - 20);
//     path.quadraticBezierTo(0, size.height * 0.75, 20,
//         size.height * 0.75 + 20 / size.width * size.height * 0.25);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 20);
//     path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
//     path.lineTo(20, 0);
//     path.quadraticBezierTo(0, 0, 0, 20);
//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// class SignUp extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     const Gradient gradient = LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [
//         Color.fromARGB(255, 254, 235, 250),
//         Color.fromARGB(255, 235, 159, 244)
//       ],
//       tileMode: TileMode.clamp,
//     );

//     final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
//     final Paint paint = Paint()..shader = gradient.createShader(colorBounds);

//     Path path = Path();

//     path.moveTo(0, size.height * -0.1);
//     path.lineTo(0, size.height * 0.9 - 20);
//     path.quadraticBezierTo(0, size.height * 0.9, 20, size.height * 0.9);
//     path.lineTo(size.width - 20, size.height * 0.9);
//     path.quadraticBezierTo(
//         size.width, size.height * 0.9, size.width, size.height * 0.9 - 20);
//     path.lineTo(size.width, size.height * 0.15 + 20);
//     path.quadraticBezierTo(size.width, size.height * 0.15 + 5, size.width - 20,
//         size.height * 0.15 * (size.width - 20) / size.width);
//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
