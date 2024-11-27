import 'dart:convert';
import 'package:flutter/material.dart';
import '../order/order_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_manager.dart';
import '../../models/account.dart';
import 'change_pass.dart';
import 'edit_information.dart';
import 'information.dart';
import 'upload_image.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Account? _account;
  bool _isLoading = true;

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userRole');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAccount();
  }

  Future<void> _fetchAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      final accountManager =
          Provider.of<AccountManager>(context, listen: false);
      final account = await accountManager.fetchAccount(userId);
      setState(() {
        _account = account;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin tài khoản'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _account == null
              ? const Center(child: Text('Không tìm thấy thông tin tài khoản'))
              : SingleChildScrollView(
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
                          child: _account!.picture.isNotEmpty
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: MemoryImage(
                                      base64Decode(_account!.picture)),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.person,
                                      size: 50, color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildActionButton('Đơn hàng', Icons.task_alt, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderScreen(),
                          ),
                        );
                      }),
                      _buildActionButton('Đổi mật khẩu', Icons.lock, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      }),
                      _buildActionButton('Thông tin cá nhân', Icons.info, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InformationScreen(account: _account!),
                          ),
                        );
                      }),
                      _buildActionButton(
                          'Chỉnh sửa thông tin cá nhân', Icons.edit, () async {
                        final updatedAccount = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditInformationScreen(account: _account!),
                          ),
                        );

                        if (updatedAccount != null) {
                          setState(() {
                            _account = updatedAccount;
                          });
                        }
                      }),
                      _buildActionButton(
                          'Cập nhật ảnh đại diện', Icons.camera_alt, () async {
                        final updatedAccount = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UploadImageScreen(account: _account!),
                          ),
                        );

                        if (updatedAccount != null) {
                          setState(() {
                            _account = updatedAccount;
                          });
                        }
                      }),
                      _buildActionButton('Trợ giúp', Icons.help, () {
                        // Xử lý trợ giúp
                      }),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _logout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(
                              double.infinity, 50), // Chiều ngang toàn màn hình
                        ),
                        child: const Text(
                          'Đăng xuất',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: Colors.black),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5, // Khung nổi lên so với nền
        ),
      ),
    );
  }
}
