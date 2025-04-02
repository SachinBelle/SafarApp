import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
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
            Center(
              child: Lottie.asset(
                'assets/signup_animation.json', // Ensure this file is in assets
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            _buildUnderlineTextField(
              controller: _nameController,
              label: "Name Of User",
              focusNode: _nameFocusNode,
            ),
            const SizedBox(height: 20),
            _buildPhoneNumberField(),
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderlineTextField({
    required TextEditingController controller,
    required String label,
    required FocusNode focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return TextField(
      controller: _phoneController,
      focusNode: _phoneFocusNode,
      keyboardType: TextInputType.number,
      maxLength: 10,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: const InputDecoration(
        prefixText: "+91 ",
        prefixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        labelText: "Enter Your Number",
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        counterText: '',
      ),
    );
  }
}
