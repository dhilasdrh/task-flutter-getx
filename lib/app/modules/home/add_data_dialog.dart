import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class AddDataDialog {
  static Future<void> show(HomeController controller) async {
    final formKey = GlobalKey<FormState>();

    await Get.dialog(
      AlertDialog(
        title: Text(
          'Add Data',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xff001e61)),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: controller.namaController,
                  labelText: 'Nama',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Nama cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: controller.nimController,
                  labelText: 'NIM',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'NIM cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: controller.prodiController,
                  labelText: 'Program Studi',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Program Studi cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: controller.angkatanController,
                  labelText: 'Angkatan',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Angkatan cannot be empty';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: controller.ipkController,
                  labelText: 'IPK',
                  keyboardType: TextInputType.number,
                  isNumeric: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'IPK cannot be empty';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Get.back();
                // controller.tryAddTempData();
                controller.addData();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xff001e61)),
              foregroundColor: MaterialStateProperty.all(Colors.grey.shade200),
              fixedSize: MaterialStateProperty.all(const Size(80, 20)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool isNumeric;
  final double fontSize;
  final double labelFontSize;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    this.isNumeric = false,
    this.fontSize = 12,
    this.labelFontSize = 10,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: fontSize),
        inputFormatters: isNumeric
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]'))]
            : null,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: labelFontSize),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
