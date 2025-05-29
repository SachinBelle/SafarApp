import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/common/methods/cmethods.dart';
import 'package:saffer_app/pages/uid_pages/uid_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter/services.dart';

final cmethod = cmethods();

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  final supabase = Supabase.instance.client;

  bool isSendOtpEnabled = false;
  bool isOtpSectionVisible = false;
  int _resendTimer = 60;
  bool _isResendEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    phoneController.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _validatePhoneNumber() {
    setState(() {
      final isValid = phoneController.text.trim().length == 10;
      isSendOtpEnabled = isValid;
      if (!isValid) {
        isOtpSectionVisible = false;
        for (var controller in _otpControllers) {
          controller.clear();
        }
        // &&
        // _phoneController.text.startsWith('+91');
      }
    });
  }

  Future<void> _sendOtp() async {
    try {
      await supabase.auth.signInWithOtp(
        phone: "+91${phoneController.text}",
        channel: OtpChannel.sms,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              "OTP Sent Successfully!",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );

      setState(() {
        isOtpSectionVisible = true;
        _resendTimer = 60;
        _isResendEnabled = false;
      });

      _startResendTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              "Failed to send OTP: ${e.toString()}",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }
  }

  void _startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        setState(() {
          _isResendEnabled = true;
          timer.cancel();
        });
      }
    });
  }

 Future<void> _verifyOtp() async {
  String otp = _otpControllers.map((e) => e.text).join();
  if (otp.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: Text(
            'Please enter a valid 6-digit OTP',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
    return;
  }

  try {
    final response = await supabase.auth.verifyOTP(
      phone: "+91${phoneController.text}",
      token: otp,
      type: OtpType.sms,
    );

    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Verification failed',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
      return;
    }

    // Check if user already exists in the database
    final existingUser = await supabase
        .from('user_data')
        .select()
        .eq('phone_number', phoneController.text)
        .maybeSingle();

    if (existingUser == null) {
      // User does not exist, insert new record
      await supabase.from('user_data').insert({
        'user_name': nameController.text,
        'phone_number': "91${phoneController.text}",
      });
    }

    // ✅ Store phone number in shared preferences
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'phone_number', phoneController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: Text(
            'Verification successful!',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ),
    );

    // ✅ Navigate to UIDPage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => UIDPage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            "Verification failed: ${e.toString()}",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}


  Future<void> _resendOtp() async {
    try {
      await supabase.auth.signInWithOtp(
        phone: "+91${phoneController.text}",
        channel: OtpChannel.sms,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              "OTP resent successfully",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );
      setState(() {
        _resendTimer = 60;
        _isResendEnabled = false;
      });
      _startResendTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              "Failed to resend OTP: ${e.toString()}",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // For dark icons
  ));
    bool formValidation() {
      return cmethod.userformValidation(
        context,
        nameTED: nameController,
        phoneNumberTED: phoneController,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFCFDEF6),
      //   title: const Text(
      //     "SAFAR",
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
      //   ),
      //   centerTitle: true,
      //   elevation: 3,
      // ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.5, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150, // Slightly reduced height
                      width: 200,
                  child: Image.asset('assets/logo/safarword.png'),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset(
                    'assets/animations/signup_animation.json',
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    "SignUp Parent/Student",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildUnderlineTextField(
              controller: nameController,
              label: "  User Name",
              focusNode: _nameFocusNode,
            ),
            const SizedBox(height: 20),
            _buildPhoneNumberField(),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: isSendOtpEnabled ? _sendOtp : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:
                      isSendOtpEnabled
                          ? const Color.fromARGB(255, 2, 35, 248)
                          : Colors.grey,
                ),
                child: const Text(
                  "SEND OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (isOtpSectionVisible) ...[
              const Center(
                child: Text(
                  "Verify Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              _buildOtpFields(),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formValidation()) {
                          _verifyOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(255, 76, 175, 79),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isResendEnabled ? _resendOtp : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor:
                            _isResendEnabled ? Colors.blue : Colors.grey,
                      ),
                      child: const Text(
                        "RESEND",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isResendEnabled
                          ? "You can resend now"
                          : "Resend in $_resendTimer seconds",
                      style: TextStyle(
                        fontSize: 14,
                        color: _isResendEnabled ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    return Container(
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(201, 232, 240, 239),
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        inputFormatters: [
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;
            String capitalized =
                newValue.text[0].toUpperCase() + newValue.text.substring(1);
            return TextEditingValue(
              text: capitalized,
              selection: TextSelection.collapsed(offset: capitalized.length),
            );
          }),
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          // enabledBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black, width: 2),
          // ),
          // focusedBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black, width: 2),
          // ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(201, 232, 240, 239),
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: phoneController,
        focusNode: _phoneFocusNode,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          prefixText: "",
          labelText: "  Phone Number",
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          // enabledBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black, width: 2),
          // ),
          // focusedBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black, width: 2),
          // ),
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
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
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
              }
            },
          ),
        ),
      ),
    );
  }
}
