import 'dart:io';
import '../widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// provide us object, that is managed behind the scenes by FirebaseSDK
final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  // for getting values out of form and other stuff
  final formKey = GlobalKey<FormState>();
  // switching between login and signup content
  var isLogin = true;
  // if it is busy in uploading the credentials
  var isBusy = false;
  // user credentials and meta data
  var userEmail = "";
  var userPassword = "";
  var userName = "";
  File? userImage;

  void submit() async {
    /* 
      1. Validating the user entered email and password by form key
      2. Based upon the mode, login on or sign up, creating new account or authenticating the previous one
      3. if the communication with backend goes successful, all fine, else showing error on the screen
    */

    // validating if the user has entered right data, before moving on
    final isValid = formKey.currentState!.validate();
    if (!isLogin && userImage == null || !isValid) return;

    // saving the data, in case user make changes while it's busy in backend
    formKey.currentState!.save();

    try {
      // now busy in backend
      setState(() {
        isBusy = true;
      });

      // login mode, authentication
      if (isLogin) {
        await firebase.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);
      }
      // sign up mode, creating account
      else {
        final userCredential = await firebase.createUserWithEmailAndPassword(
            email: userEmail, password: userPassword);

        // targeting user_images folder on storage at firebase, if the user_images folder doesn't exist it will be created automatically
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(userImage!);
        final imageURL = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': userName,
          'email': userEmail,
          'image_url': imageURL,
        });
      }
      // incase things go well
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              isLogin ? "Login Successfully" : "Account created Successfuly")));
    }
    // incase things go wrong
    on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Authentication Failed!!")));

      setState(() {
        isBusy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
        // to lift the content up, when keyboard appears
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                margin: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 20),
                child: Image.asset('assets/icon.png'),
              ),

              // form to take inputs for sing in / sign up
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 40),

                // child: SingleChildScrollView(), // will use it later ***

                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 20, right: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isLogin)
                          MessageImagePicker(
                            onPickImage: (image) {
                              userImage = image;
                            },
                          ),
                        // user email
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Email Address: "),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains("@")) {
                              return "Please Enter Valid Email Address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userEmail = value!;
                          },
                        ),

                        // user name
                        if (!isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text("User Name: "),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 4) {
                                return "Minimum Lenght is 4 characters!";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              userName = value!;
                            },
                          ),
                        // user password
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Password: "),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 6) {
                              return "Minimum Lenght is 6 characters!";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userPassword = value!;
                          },
                        ),

                        const SizedBox(height: 20),

                        if (isBusy) const CircularProgressIndicator(),

                        // signing in or signing up
                        if (!isBusy)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            onPressed: submit,
                            child: Text(isLogin ? "Log in" : "Sign Up"),
                          ),

                        // switching between signup and login mode
                        if (!isBusy)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              isLogin
                                  ? "Create New Account"
                                  : "Already have an Account?",
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
