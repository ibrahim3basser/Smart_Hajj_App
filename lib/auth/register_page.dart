import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/services/auth_service.dart';
import 'package:hajj_app/widgets/custom_button.dart';
import 'package:hajj_app/widgets/custom_text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static String id = 'RegisterPage';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? email;
  String? confirmpassword;
  String? password;
  String? username;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController emailController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        // resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  const CircleAvatar(
                    radius: 100.0,
                    //child: Image.asset('images/Hajj.png'),
                    backgroundImage: AssetImage('assets/images/Hajj.png'),
                    backgroundColor: Colors.white,
                  ),
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
                    padding:
                        const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ' حساب جديد',
                          style: GoogleFonts.lemonada(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                        )
                      ],
                    ),
                  ),
                  CustomFormTextField(
                    controller: usernameController,
                    onChanged: (value) {
                      email = value;
                    },
                    labelText: 'اسم المستخدم',
                  ),
                  CustomFormTextField(
                    controller: emailController,
                    onChanged: (value) {
                      email = value;
                    },
                    labelText: 'البريد الالكترونى',
                  ),
                  CustomFormTextField(
                    controller: passwordController,
                    obscureText:
                        true, // Pass the true value to enable the eye icon
                    onChanged: (value) {
                      password = value;
                    },
                    labelText: 'الرقم السرى',
                  ),
                  CustomFormTextField(
                    controller: confirmPasswordController,
                    obscureText:
                        true, // Pass the true value to enable the eye icon
                    onChanged: (value) {
                      confirmpassword = value;
                    },
                    labelText: ' تأكيد كلمه السر',
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomButton(
                    onTap: () async {
                      if (isValid()) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          AuthService authService = AuthService();
                          authService.registerUser(emailController.text,
                              passwordController.text, usernameController.text);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.bottomSlide,
                              title: 'خطأ',
                              desc: 'كلمه السر ضعيفه',
                              btnOkOnPress: () {},
                            ).show();
                          } else if (e.code == 'email-already-in-use') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.bottomSlide,
                              title: 'خطأ',
                              desc: 'البريد الالكترونى مستخدم بالفعل',
                              btnOkOnPress: () {},
                            ).show();
                          }
                        } catch (e) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            title: 'خطأ',
                            desc: 'حدث خطأ ما',
                            btnOkOnPress: () {},
                          ).show();
                        }
                        setState(() {
                          isLoading = false;
                        });

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.bottomSlide,
                          title: 'تم بنجاح',
                          desc: 'تم تسجيل الحساب بنجاح',
                          btnOkOnPress: () {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, 'LoginPage');
                          },
                        ).show();
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.bottomSlide,
                          title: 'خطأ',
                          desc: 'كلمه السر غير مطابقه',
                          btnOkOnPress: () {},
                        ).show();
                      }
                    },
                    text: 'تسجيل',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'LoginPage');
                        },
                        child: const Text(' تسجيل الدخول',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const Text(' لديك حساب بالفعل ؟ ',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValid() {
    if ((passwordController.text == confirmPasswordController.text) &&
        (formKey.currentState?.validate() ?? false)) {
      return true;
    } else {
      return false;
    }
  }
}
