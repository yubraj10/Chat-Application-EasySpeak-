import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_chatapplication/screens/success_message.dart';
import 'package:online_chatapplication/validators.dart';
import '../services/auth_service.dart';
import '../widgets/buttons.dart';
import '../widgets/container.dart';
import '../widgets/form_widgets.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _fullnameController.text,
          phone: _phoneController.text,
        );
        Get.off(() => SuccessMessageScreen(
          title: 'Your account is successfully created!',
          subtitle: 'Welcome to your ultimate chatting destination! Your account is created. Unleash the joy of seamless chatting.',
          onPressed: () => _authService.navigateToLogin(),
        ));
      } on FirebaseAuthException catch (e) {
        _authService.handleAuthError(context, e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      buildContainer(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildTextFormField(
                                controller: _fullnameController,
                                labelText: 'Full Name',
                                prefixIcon: Icons.person,
                                validator: Validators.validateFullName,
                              ),
                              const SizedBox(height: 16),
                              buildTextFormField(
                                controller: _emailController,
                                labelText: 'Email',
                                prefixIcon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              buildTextFormField(
                                controller: _phoneController,
                                labelText: 'Phone Number',
                                prefixIcon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: Validators.validatePhone,
                              ),
                              const SizedBox(height: 16),
                              buildTextFormField(
                                controller: _passwordController,
                                labelText: 'Password',
                                prefixIcon: Icons.lock,
                                isPasswordVisible: !_isPasswordVisible,
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                validator: Validators.validatePassword,
                              ),
                              const SizedBox(height: 16),
                              buildTextFormField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                prefixIcon: Icons.lock,
                                isPasswordVisible: !_isConfirmPasswordVisible,
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                                validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                              ),
                              const SizedBox(height: 24),
                              _isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : buildElevatedButton(label: 'Sign up',onPressed: _signup)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          buildTextButton(
                            label: 'Log in',
                            onPressed: () => _authService.navigateToLogin(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}