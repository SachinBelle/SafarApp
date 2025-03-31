import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:saffer_app/verify_opt.dart';
=======
import 'package:flutter/services.dart';
>>>>>>> 3dea360f11f4a2573c11e96ba4e7d7b0216d8f36

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
<<<<<<< HEAD

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
=======
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
>>>>>>> 3dea360f11f4a2573c11e96ba4e7d7b0216d8f36

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
<<<<<<< HEAD
=======
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
>>>>>>> 3dea360f11f4a2573c11e96ba4e7d7b0216d8f36
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: const Color(0xFFCFDEF6),
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
              capitalizeFirstLetter: true,
            ),
            const SizedBox(height: 20),
            _buildFloatingTextField(
              controller: _phoneController,
              label: "Phone Number",
              focusNode: _phoneFocusNode,
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
<<<<<<< HEAD
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
=======
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Verify Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _otpFocusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_otpFocusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(
                          context,
                        ).requestFocus(_otpFocusNodes[index - 1]);
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color.fromARGB(141, 94, 99, 237),
                ),
                child: const Text(
                  "RESEND",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 4),
>>>>>>> 3dea360f11f4a2573c11e96ba4e7d7b0216d8f36
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTextField({
    required TextEditingController controller,
    required String label,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    bool capitalizeFirstLetter = false,
  }) {
<<<<<<< HEAD
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
=======
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      inputFormatters:
          maxLength != null
              ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxLength),
              ]
              : null,
      onChanged: (text) {
        if (capitalizeFirstLetter && text.isNotEmpty) {
          controller.value = controller.value.copyWith(
            text: text[0].toUpperCase() + text.substring(1),
            selection: TextSelection.collapsed(offset: text.length),
          );
        }
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
>>>>>>> 3dea360f11f4a2573c11e96ba4e7d7b0216d8f36
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        counterText: '',
      ),
    );
  }
}
