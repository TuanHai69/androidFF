import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/account.dart';
import 'account_manager.dart';

class UploadImageScreen extends StatefulWidget {
  final Account account;

  const UploadImageScreen({super.key, required this.account});

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  late Account _account;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _account = widget.account;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateImage() async {
    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final updatedAccount = _account.copyWith(picture: base64Image);
      final accountManager =
          Provider.of<AccountManager>(context, listen: false);
      final result = await accountManager.updateAccount(updatedAccount);

      if (result != null) {
        setState(() {
          _account = result;
        });
        Navigator.pop(context, result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật hình ảnh thất bại')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật ảnh đại diện'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(75),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: _imageFile != null
                    ? CircleAvatar(
                        radius: 75,
                        backgroundImage: FileImage(_imageFile!),
                      )
                    : _account.picture.isNotEmpty
                        ? CircleAvatar(
                            radius: 75,
                            backgroundImage:
                                MemoryImage(base64Decode(_account.picture)),
                          )
                        : const CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person,
                                size: 75, color: Colors.white),
                          ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Chọn ảnh từ thư viện'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateImage,
              child: const Text('Cập nhật ảnh đại diện'),
            ),
          ],
        ),
      ),
    );
  }
}
