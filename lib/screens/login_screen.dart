import 'package:fire_services/Utils/auth_services.dart';
import 'package:fire_services/screens/forgot_pass_screen.dart';
import 'package:fire_services/screens/phon_auth_screen.dart';
import 'package:fire_services/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController _usernameController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

AuthServices services = AuthServices();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Firebase with login",
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
        // backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassScreen()),
                          (route) => true);
                    },
                    child: const Text("Forgot Password"),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  services.loginUser(_usernameController.text.toString(),
                      _passwordController.text.toString(), context);
                },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  child: const Center(
                      child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 17),
                  )),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Create new Account"),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                          (route) => true);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhonAuthScreen(),
                        ));
                  },
                  child: const Text("Phon With Login")),
              const SizedBox(height: 20),
              SignInButton(
                Buttons.google,
                onPressed: () {
                  services.signInWithGoogle(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
