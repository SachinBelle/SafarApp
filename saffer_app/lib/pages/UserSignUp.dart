import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/common/methods/cmethods.dart';
import 'package:saffer_app/pages/uid_pages/uid_list_view.dart';
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
        content: Text(
          'Please enter a valid 6-digit OTP',
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
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
          content: Text(
            'Verification failed',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
      );
      return;
    }

    final userId = user.id; // UUID from Supabase Auth

    // Check if user exists in user_data
    final existingUser = await supabase
        .from('user_data')
        .select('user_linked_uid')
        .eq('user_uid', userId)
        .maybeSingle();

    if (existingUser == null) {
      // New user → insert into user_data
      await supabase.from('user_data').insert({
        'user_name': nameController.text.trim(),
        'phone_number': "91${phoneController.text.trim()}",
        'user_uid': userId,
        'user_linked_uid': [], // start with empty list
      });

      // Save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone_number', phoneController.text.trim());
      await prefs.setString('UserName', nameController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Welcome! Account created.',
            style: TextStyle(color: Colors.green),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
      );

      // Navigate to UID creation page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => UIDPage()),
      );
    } else {
      // Existing user → get UID list
      final List<dynamic> uidList = existingUser['user_linked_uid'] ?? [];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone_number', phoneController.text.trim());
      await prefs.setString('UserName', nameController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Welcome back!',
            style: TextStyle(color: Colors.green),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
      );

      // Navigate to UIDList screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UidListPage(uidList: List<String>.from(uidList)),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Verification failed: ${e.toString()}",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
              padding: const EdgeInsets.only(left: 22.5, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 100, // Slightly reduced height
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
                    height: 150,
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
              label: "User Name",
              focusNode: _nameFocusNode,
            ),
           
            _buildPhoneNumberField(),
            const SizedBox(height: 10),
              if(!isOtpSectionVisible) Padding(
              padding: const EdgeInsets.only(right: 25,top:0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 10,
                children: [
                  Text("Verify Phone number through otp",style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontSize: 13,
                  ),),
               ElevatedButton(
                    onPressed: (){
                  
                      if(isSendOtpEnabled){
                        _sendOtp();
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(
                       child:  Text("Enter a valid ten digit phone number")
                      )
                      )
                      );
                  
                    
                      }
                    },
                    
                      
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(12),
                        
                      ),
                      backgroundColor:
                          isSendOtpEnabled
                              ? Colors.green
                              :    const Color.fromARGB(255, 233, 233, 233),
                  
                    ),
                    child: Text(
                      "SEND OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:isSendOtpEnabled?Colors.white:Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
           isOtpSectionVisible==true? Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Center(
                    child: Text(
                      "Enter OTP Send to Your Phone Number",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,fontFamily: "Albertsans"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildOtpFields(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
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
                          backgroundColor:  const Color.fromARGB(255, 107, 202, 110),
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
                              _isResendEnabled ? const Color.fromARGB(255, 107, 202, 110) : const Color.fromARGB(131, 255, 255, 255),
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
                     
                    ],
                  ),
                   Center(
                     child: Text(
                            _isResendEnabled
                                ? "You can resend now"
                                : "Resend in $_resendTimer seconds",
                            style: TextStyle(
                              fontSize: 14,
                              color: _isResendEnabled ? Colors.green : Colors.red,
                            ),
                          ),
                   ),
                   Center(
                     child: TextButton(onPressed: (){
                     
                     }, child: Text("Want to change your Number?",style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 12,
                     ),)),
                   )
                ],
                
                ),
              ),
            ):Container(),
            
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    child: Container(
      height: 60, // Adjusted to a more compact height
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 233, 233),
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Albertsans"
        ),
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
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(198, 0, 0, 0),
             fontFamily: "Albertsans"
          ),
          isDense: true,
 contentPadding: EdgeInsets.only(left: 25, bottom: 15,top: 10),        ),
      ),
    ),
  );
}


 Widget _buildPhoneNumberField() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 233, 233),
        border: Border.all(color: Colors.grey, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: phoneController,
        focusNode: _phoneFocusNode,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "Phone Number",
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(205, 0, 0, 0),
             fontFamily: "Albertsans"
          ),
          isDense: true,
          contentPadding: EdgeInsets.only(left: 25, bottom: 15,top: 10),
          counterText: '',
        ),
      ),
    ),
  );
}


  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: List.generate(
        6,
        (index) => Container(
          decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 233, 233),
        border: Border.all(color: Colors.grey, width: 1),
           borderRadius: BorderRadius.all(Radius.circular(15)),
      
      ),
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
             
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
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
