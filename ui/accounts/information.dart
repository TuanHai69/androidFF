import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/account.dart';

class InformationScreen extends StatelessWidget {
  final Account account;

  const InformationScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: screenHeight / 5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: account.picture.isNotEmpty
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            MemoryImage(base64Decode(account.picture)),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Tên người dùng:', account.username),
            _buildInfoRow('Họ và tên:', account.name),
            _buildInfoRow('Ngày sinh:', account.birthday),
            _buildInfoRow('Giới tính:', account.gender),
            _buildInfoRow('Địa chỉ:', account.address),
            _buildInfoRow('Số điện thoại:', account.phonenumber),
            _buildInfoRow('Email:', account.email),
            _buildInfoRow('Vai trò:', account.role),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
