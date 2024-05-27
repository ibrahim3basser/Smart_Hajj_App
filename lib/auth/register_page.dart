import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';
import 'package:hajj_app/helpers/show_snack_bar.dart';
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
  // bool obscureText = true;
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
                  const Text(
                    'muslim',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'pacifico'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            )),
                      ],
                    ),
                  ),
                  CustomFormTextField(
                    controller: usernameController,
                    onChanged: (value) {
                      email = value;
                    },
                    labelText: 'Username',
                  ),
                  CustomFormTextField(
                    controller: emailController,
                    onChanged: (value) {
                      email = value;
                    },
                    labelText: 'Email',
                  ),
                  CustomFormTextField(
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (value) {
                      password = value;
                    },
                    labelText: 'password',
                    // icon: IconButton(
                    //   onPressed:(){
                    //     obscureText = false;
                    //   },
                    //   icon: Icon(Icons.visibility),
                    //   ),
                  ),
                  CustomFormTextField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      confirmpassword = value;
                    },
                    labelText: 'Confirm Password',
                    // icon: IconButton(
                    //   onPressed:(){
                    //     obscureText = false;
                    //   },
                    //   icon: Icon(Icons.visibility),
                    //   ),
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
                            UserCredential user = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email!, password: password!);
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.user!.uid)
                                .set({
                              'name': usernameController.text,
                              'email': emailController.text,
                              // Add other user details here
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              // ignore: use_build_context_synchronously
                              showSnackBar(context,
                                  'The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              // ignore: use_build_context_synchronously
                              showSnackBar(context,
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showSnackBar(context, 'there was an error');
                          }
                          setState(() {
                            isLoading = false;
                          });
                          // ignore: use_build_context_synchronously
                          showSnackBar(context, 'Account created successfully');
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, 'LoginPage');
                        } else {
                          showSnackBar(context, 'Password does not match');
                        }
                      },
                      text: 'Sign Up'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('already have an account?',
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'LoginPage');
                        },
                        child: const Text('Login',
                            style: TextStyle(color: Colors.white)),
                      )
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

  // // ignore: non_constant_identifier_names
  // Future<void> Auth() async {
  //   UserCredential user = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(email: email!, password: password!);
  // }

  bool isValid() {
    if ((passwordController.text == confirmPasswordController.text) &&
        (formKey.currentState?.validate() ?? false)) {
      return true;
    } else {
      return false;
    }
  }
}