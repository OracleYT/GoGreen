import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// import 'package:walk_with_you/style/theme.dart' as Theme;
import '../constant.dart';
import '../main.dart';
import '../onboarding/authmethods.dart';
import '../widget/textField.dart';

class RegstrationPage extends StatefulWidget {
  const RegstrationPage({
    Key key,
  }) : super(key: key);

  @override
  _RegstrationPageState createState() => _RegstrationPageState();
}

class _RegstrationPageState extends State<RegstrationPage> {
  final signUpFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool success = false;

  PageController pageController;
  AnimationController animationController;

  TextEditingController name = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Color left = Colors.black;
  Color right = Colors.white;

  bool page = false;
  bool isgreen = false;

  @override
  void initState() {
    pageController = PageController();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // widget.pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    // return

    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 36, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  "Get Along ...",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 16, left: 64, right: 64),
                //   child: Text(
                //     "Join Challenges. Get Fit.\n Earn Rewards.",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       color: Color.fromARGB(255, 166, 172, 179),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 34, right: 34),
                      child: // 0.4
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      // fontWeight: FontWeight.w900,
                                      color: Color.fromARGB(255, 166, 172,
                                          179) //Color.fromARGB(255, 18, 18, 18),
                                      ),
                                  text: page == false
                                      ? "Already have an account?"
                                      : "Don't have an account?",
                                  children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  page == false
                                      ? pageController.animateToPage(1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.decelerate)
                                      : pageController.animateToPage(0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.decelerate);
                                },
                              text: page == false
                                  ? "  Login here  "
                                  : "  Sign Up  ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 18, 18, 18),
                              ),
                            )
                          ]))),
                ),
                SizedBox(
                  // color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height:
                      //MediaQuery.of(context).size.height >= 775.0
                      //     ? MediaQuery.of(context).size.height
                      // :
                      400.0,
                  child: PageView(
                    controller: pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          page = false;
                          // pageController.page;
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          page = true;
                          // pageController.page;
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      _buildSignUp(context),
                      _buildSignIn(context),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 58,
              width: 188,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xff132137),
              ),
              child: InkWell(
                // key: const ValueKey('Sign Up button'),
                onTap: page == false ? signUp : signIn,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Icon(Icons.arrow_forward_rounded,
                      //     color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    final isValid = signInFormKey.currentState.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      String res = await AuthMethods()
          .loginUser(email: email.text.trim(), password: password.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  Future signUp() async {
    final isValid = signUpFormKey.currentState.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      String res = await AuthMethods().signUpUser(
        email: email.text.trim(),
        password: password.text.trim(),
        username: name.text.trim(),
        isgreen: isgreen,
        // bio: bio.text,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState.popUntil((route) => route.isFirst);
  }

  Widget _buildSignIn(BuildContext context) {
    return Form(
        key: signInFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          padding: const EdgeInsets.only(top: 23.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 300.0,
                // height: 190.0,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      hint: "Email ID",
                      icon: const Icon(Icons.email),
                      obsecure: false,
                      autofocus: false,
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern as String);

                        if ((value != null && value.trim().isEmpty) ||
                            value == null) {
                          return "Please enter your email";
                        } else if (!regex.hasMatch(value.trim())) {
                          return "Enter valid email address";
                        }

                        return null;
                      },
                      textController: email,
                    ),

                    //SPACE
                    Container(
                      height: 12.0,
                    ),

                    //Password
                    CustomTextField(
                      hint: "Password",
                      icon: const Icon(Icons.lock),
                      obsecure: true,
                      autofocus: false,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter the password";
                        } else if (value.length < 3) {
                          return "Password must be longer than 6 characters";
                        }

                        return null;
                      },
                      textController: password,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSignUp(BuildContext context) {
    return Form(
        key: signUpFormKey,
        // key: viewModel.signUpFormKey,
        child: Container(
          padding: const EdgeInsets.only(top: 23.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 300.0,
                // height: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CustomTextField(
                      hint: "Name",
                      icon: const Icon(Icons.people),
                      obsecure: false,
                      autofocus: false,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter your name";
                        } else if (value.length < 3) {
                          return "Name must be longer than 2 characters";
                        }

                        return null;
                      },
                      textController: name,
                    ),

                    //SPACE
                    Container(
                      height: 12.0,
                    ),

                    //Email ID
                    CustomTextField(
                      hint: "Email ID",
                      icon: const Icon(Icons.email),
                      obsecure: false,
                      autofocus: false,
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern as String);

                        if ((value != null && value.trim().isEmpty) ||
                            value == null) {
                          return "Please enter your email";
                        } else if (!regex.hasMatch(value.trim())) {
                          return "Enter valid email address";
                        }

                        return null;
                      },
                      textController: email,
                    ),

                    //SPACE
                    Container(
                      height: 12.0,
                    ),

                    //Password
                    CustomTextField(
                      hint: "Password",
                      icon: const Icon(Icons.lock),
                      obsecure: true,
                      autofocus: false,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter the password";
                        } else if (value.length < 3) {
                          return "Password must be longer than 6 characters";
                        }

                        return null;
                      },
                      textController: password,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //SizedBox
                        SizedBox(width: 10), //SizedBox
                        /** Checkbox Widget **/
                        Checkbox(
                          activeColor: Color.fromRGBO(79, 171, 93, 1),
                          value: this.isgreen,
                          onChanged: (bool value) {
                            setState(() {
                              this.isgreen = value;
                            });
                          },
                        ),
                        Text(
                          'Are u green',
                          style: TextStyle(
                              // fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 166, 172,
                                  179) //Color.fromARGB(255, 18, 18, 18),
                              ),
                        ),
                        SizedBox(
                          width: 30,
                        ), //Text
                      ], //<Widget>[]
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
