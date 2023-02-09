import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                labelText: 'Email',
                hintText: 'Enter your email account'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.teal,
                )),
                labelText: 'Password',
                hintText: 'Enter password'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        MaterialButton(
            color: Colors.teal,
            textColor: Colors.white,
            onPressed: () async {
              final email = _email.text;
              final passoword = _password.text;
              try {
                final usercredentials = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: passoword);
                print(usercredentials);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        AlertDialog loginError = AlertDialog(
                          title: const Text('Login Error'),
                          content:
                              const Text('User not found. Please try again'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK',
                                    style: TextStyle(color: Colors.teal)))
                          ],
                        );
                        return loginError;
                      });
                  print(e.code);
                } else if (e.code == 'wrong-password') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        AlertDialog loginError = AlertDialog(
                          title: const Text('Login Error'),
                          content: const Text(
                              'The passowrd is invalid. Please try again'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: Colors.teal),
                                ))
                          ],
                        );
                        return loginError;
                      });
                  print(e.code);
                }
              }
            },
            child: const Text('Login'))
      ],
    ));
  }
}
