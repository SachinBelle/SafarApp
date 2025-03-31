import 'package:flutter/material.dart';
import 'package:saffer_app/verify_opt.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isNameFocused = false;
  bool _isPhoneFocused = false;
  bool _isOtpSent = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _nameFocusNode.addListener(() {
      setState(() {
        _isNameFocused = _nameFocusNode.hasFocus || _nameController.text.isNotEmpty;
      });
    });

    _phoneFocusNode.addListener(() {
      setState(() {
        _isPhoneFocused = _phoneFocusNode.hasFocus || _phoneController.text.isNotEmpty;
      });
    });

    _phoneController.addListener(() {
      setState(() {
        _isButtonEnabled = _phoneController.text.length == 10;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "SAFAR",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
        ),
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30), // Added space to prevent overlap
            _buildFloatingTextField(
              controller: _nameController,
              label: "Name Of User",
              focusNode: _nameFocusNode,
              isFocused: _isNameFocused,
            ),
            const SizedBox(height: 20),
            _buildFloatingTextField(
              controller: _phoneController,
              label: "Phone Number",
              focusNode: _phoneFocusNode,
              isFocused: _isPhoneFocused,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 25),
            if (!_isOtpSent)
              Center(
                child: ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          setState(() {
                            _isOtpSent = true;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: _isButtonEnabled
                        ? const Color.fromARGB(141, 94, 99, 237)
                        : Colors.grey,
                  ),
                  child: const Text(
                    "Send OTP",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            if (_isOtpSent)
              Verify(
                phoneNumber: _phoneController.text,
                userName: _nameController.text,
              ), // Render OTP verification UI
            const SizedBox(height: 40), // Extra space at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTextField({
    required TextEditingController controller,
    required String label,
    required FocusNode focusNode,
    required bool isFocused,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Stack(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(141, 255, 255, 255),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 5, blurRadius: 20),
            ],
          ),
          child: Center(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.only(top: 20)),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: isFocused ? 5 : 20,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(fontSize: isFocused ? 12 : 20, fontWeight: FontWeight.bold, color: Colors.black),
            child: Text(label),
          ),
        ),
      ],
    );
  }
}
