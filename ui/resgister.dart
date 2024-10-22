import 'package:flutter/material.dart';

import 'registerform.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Đăng ký tài khoản"),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "image/A1.jpg"), // Thay "assets/images/background.jpg" bằng đường dẫn tới hình ảnh của bạn
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: 320,
                height: 660,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(30)),
                child: RegisterForm(),
              ),
            ),
          ),
        ));
  }
}
