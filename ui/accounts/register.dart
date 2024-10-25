import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bcrypt/bcrypt.dart';
import 'account_manager.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Tất cả các trường đều bắt buộc';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Mật khẩu không khớp';
      });
      return;
    }

    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    final accountManager = Provider.of<AccountManager>(context, listen: false);
    final accountData = {
      'username': username,
      'password': hashedPassword,
      'email': email,
      'role': 'client',
      'birthday': DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toIso8601String(),
      'name': '',
      'picture': '',
      'gender': '',
      'address': '',
      'phonenumber': ''
    };

    try {
      final message = await accountManager.addAccount(accountData);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );

      if (message.contains('thành công')) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'image/A1.jpg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Đăng ký',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                  labelText: 'Tên đăng nhập'),
                            ),
                            TextField(
                              controller: _emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                            TextField(
                              controller: _passwordController,
                              decoration:
                                  const InputDecoration(labelText: 'Mật khẩu'),
                              obscureText: true,
                            ),
                            TextField(
                              controller: _confirmPasswordController,
                              decoration: const InputDecoration(
                                  labelText: 'Xác nhận mật khẩu'),
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const CircularProgressIndicator()
                            else
                              ElevatedButton(
                                onPressed: () => _register(context),
                                child: const Text('Đăng ký'),
                              ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
