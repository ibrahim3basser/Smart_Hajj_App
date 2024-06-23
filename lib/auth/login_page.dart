// ignore_for_file: use_build_context_synchronously
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/helpers/show_snack_bar.dart';
import 'package:hajj_app/views/forget_password_page.dart';
import 'package:hajj_app/views/home_page.dart';
import 'package:hajj_app/auth/register_page.dart';
import 'package:hajj_app/widgets/custom_text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "mohamed@gmail.com".dev);
    passwordController = TextEditingController(text: "12345678".dev);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        //resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 150,
                ),
                const CircleAvatar(
                  radius: 100.0,
                  //child: Image.asset('images/Hajj.png'),
                  backgroundImage: AssetImage('assets/images/Hajj.png'),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                 Text(
                  'الحج الذكى',
                
                   style: GoogleFonts.lemonada(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.arefRuqaa(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomFormTextField(
                    controller: emailController,
                    onChanged: (value) {
                      email = value;
                    },
                    labelText: 'البريد الالكترونى',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomFormTextField(
                    controller: passwordController,
                    obscureText: true, // Pass the true value to enable the eye icon
                    onChanged: (value) {
                      password = value;
                    },
                    labelText: 'الرقم السرى',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text('نسيت كلمه السر؟',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                          )),
                      onTap: () {
                        Navigator.pushNamed(context, ResetPasswordPage.id);
                      }),
                ),
                CustomButton(
                  onTap: () async {
                    // FocusManager.instance.primaryFocus?.unfocus();
                    FocusScope.of(context).unfocus();

                    if (formKey.currentState!.validate() &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        UserCredential user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);

                        if (user.user != null) {
                          showSnackBar(context, 'تم تسجيل الدخول بنجاح');
                          Navigator.pushReplacementNamed(context, HomePage.id);
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'خطأ',
                            desc: 'حدث خطأ ما، يرجى المحاولة مرة أخرى',
                            btnCancelOnPress: () {},
                          ).show();
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "network-request-failed") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'خطأ',
                            desc: 'لا يوجد اتصال بالإنترنت',
                            btnCancelOnPress: () {},
                          ).show();
                        } else if (e.code == "user-not-found") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'خطأ',
                            desc: 'المستخدم غير موجود، يرجى التسجيل',
                            btnCancelOnPress: () {},
                          ).show();
                        } else if (e.code == "wrong-password" ||
                            e.code ==
                                'The supplied auth credential is incorrect, malformed or has expired.' ||
                            e.code == 'invalid-credential') {
                          //case "invalid-credential":
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'خطأ',
                            desc:
                                'لا يمكن تسجيل الدخول، تأكد من البريد الإلكتروني وكلمة المرور الخاصة بك',
                            btnCancelOnPress: () {},
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'خطأ',
                            desc: 'حدث خطأ ما، يرجى المحاولة مرة أخرى',
                            btnCancelOnPress: () {},
                            // btnOkOnPress: () {},
                          ).show();
                          //error = "An error occurred, please try again later";
                        }

                        // showSnackBar(context, e.toString());
                      } on PlatformException catch (e) {
                        showSnackBar(context, e.toString());
                      } catch (e) {
                        showSnackBar(context, e.toString());
                      }

                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'خطأ',
                        desc: 'الرجاء إدخال البريد الإلكتروني وكلمة المرور',
                        btnCancelOnPress: () {},
                        // btnOkOnPress: () {},
                      ).show();
                    }
                  },
                  text: 'تسجيل الدخول',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Register.id);
                        },
                        child: const Text('تسجيل جديد',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const Text('ليس لديك حساب؟',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension Dev on String {
  String? get dev {
    if (kDebugMode) {
      return this;
    } else {
      return null;
    }
  }
}
