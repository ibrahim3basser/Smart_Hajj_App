// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/helpers/show_snack_bar.dart';
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
                const Text(
                  'Muslim',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          )),
                    ],
                  ),
                ),
                CustomFormTextField(
                  controller: emailController,
                  onChanged: (value) {
                    email = value;
                  },
                  labelText: 'Email',
                ),
                CustomFormTextField(
                  controller: passwordController,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  labelText: 'Password',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: const Text('Forget password ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ))),
                  ),
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
                          showSnackBar(context, 'success');
                          Navigator.pushReplacementNamed(context, HomePage.id);
                        } else {
                          showSnackBar(context, "Wrong credentials");
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "network-request-failed") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'check your network connection',
                            btnCancelOnPress: () {},
                          ).show();
                        } else if (e.code == "user-not-found") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'user not found',
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
                            title: 'Error',
                            desc:
                                'we couldn\'t find an account with that email address or password',
                            btnCancelOnPress: () {},
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'An error occurred, please try again later',
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
                        title: 'Error',
                        desc: 'Please fill all fields',
                        btnCancelOnPress: () {},
                        // btnOkOnPress: () {},
                      ).show();
                    }
                  },
                  text: 'Sign In',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account ? ',
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Register.id);
                        },
                        child: const Text('Register',
                            style: TextStyle(color: Colors.white)),
                      )
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
