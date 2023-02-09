import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
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
                      .createUserWithEmailAndPassword(
                          email: email, password: passoword);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    Fluttertoast.showToast(
                      msg: "Weak Password",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.teal,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    print(e.code);
                  } else if (e.code == 'email-already-in-use') {
                    const snackBar = SnackBar(
                      content: Text('Email already registered'),
                      backgroundColor: Colors.teal,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    print(e.code);
                  } else if (e.code == 'invalid-email') {
                    const snackBar = SnackBar(
                      content: Text('Invalid email'),
                      backgroundColor: Colors.teal,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    print(e.code);
                  }
                }
              },
              child: const Text('Register'))
        ],
      ),
    );
  }
}
