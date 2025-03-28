import 'package:flutter/material.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneNumberController=TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            TextField(
              decoration: InputDecoration(
                hintText: "Name Of User",
                hintStyle: TextStyle(fontWeight: FontWeight.w900,fontSize: 24),
                filled: true,
                fillColor: const Color.fromRGBO(217, 217, 217, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Phone Number",
                   hintStyle: TextStyle(fontWeight: FontWeight.w900,fontSize: 24),
                filled: true,
                 fillColor: const Color.fromRGBO(217, 217, 217, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Verify Phone Number",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Enter OTP sent to your phone number",
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  "RESEND",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            Spacer(flex: 4,),
          ],
        ),
      ),
    );
  }
}