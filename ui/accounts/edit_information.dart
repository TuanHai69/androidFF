import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/account.dart';
import 'account_manager.dart';

class EditInformationScreen extends StatefulWidget {
  final Account account;

  const EditInformationScreen({super.key, required this.account});

  @override
  _EditInformationScreenState createState() => _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late Account _account;
  late TextEditingController _birthdayController;

  @override
  void initState() {
    super.initState();
    _account = widget.account;
    _birthdayController = TextEditingController(text: _account.birthday);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _updateAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final accountManager =
          Provider.of<AccountManager>(context, listen: false);
      final updatedAccount = await accountManager.updateAccount(_account);
      if (updatedAccount != null) {
        Navigator.pop(context, updatedAccount);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thất bại')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    if (_account.birthday.isNotEmpty) {
      initialDate = DateTime.parse(_account.birthday);
    } else {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        _birthdayController.text = picked.toIso8601String().split('T').first;
        _account = _account.copyWith(birthday: _birthdayController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Tên người dùng', _account.username, (value) {
                _account = _account.copyWith(username: value);
              }),
              _buildTextField('Họ và tên', _account.name, (value) {
                _account = _account.copyWith(name: value);
              }),
              _buildDateField('Ngày sinh', _birthdayController, () {
                _selectDate(context);
              }),
              _buildGenderField('Giới tính', _account.gender, (value) {
                _account = _account.copyWith(gender: value);
              }),
              _buildTextField('Địa chỉ', _account.address, (value) {
                _account = _account.copyWith(address: value);
              }),
              _buildTextField('Số điện thoại', _account.phonenumber, (value) {
                _account = _account.copyWith(phonenumber: value);
              }),
              _buildTextField('Email', _account.email, (value) {
                _account = _account.copyWith(email: value);
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateAccount,
                child: const Text('Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String initialValue, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildDateField(
      String label, TextEditingController controller, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: onTap,
      ),
    );
  }

  Widget _buildGenderField(
      String label, String initialValue, Function(String) onSaved) {
    List<String> genderOptions = ['Nam', 'Nữ'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: genderOptions.contains(initialValue) ? initialValue : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: genderOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onSaved(value);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng chọn $label';
          }
          return null;
        },
      ),
    );
  }

  // Widget _buildGenderField(
  //     String label, String initialValue, Function(String) onSaved) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: DropdownButtonFormField<String>(
  //       value: initialValue.isNotEmpty ? initialValue : null,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: const OutlineInputBorder(),
  //       ),
  //       items: ['Nam', 'Nữ'].map((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(value),
  //         );
  //       }).toList(),
  //       onChanged: (value) {
  //         if (value != null) {
  //           onSaved(value);
  //         }
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Vui lòng chọn $label';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }
}
