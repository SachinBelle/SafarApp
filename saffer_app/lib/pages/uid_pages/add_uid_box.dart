import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saffer_app/global/global_assets.dart' as global;
import 'package:saffer_app/pages/uid_pages/uid_list_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




class UidBox extends StatefulWidget {
  const UidBox({super.key});

  @override
  State<UidBox> createState() => _UidBoxState();
}

class _UidBoxState extends State<UidBox> {
  final List<TextEditingController> _uidControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _uidFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _uidControllers) {
      controller.dispose();
    }
    for (var node in _uidFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.80,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Enter UID To Add Operator',
              style: GoogleFonts.albertSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40,
                  height: 40,
                  child: TextField(
                    controller: _uidControllers[index],
                    focusNode: _uidFocusNodes[index],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                      UpperCaseTextFormatter(),
                    ],
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: -5, horizontal: 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).requestFocus(
                            _uidFocusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).requestFocus(
                            _uidFocusNodes[index - 1]);
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Contact your transport operator or organization to get UID',
                textAlign: TextAlign.center,
                style: GoogleFonts.albertSans(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (isKeyboardVisible)
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    final uid = _uidControllers.map((c) => c.text).join().toUpperCase();

                    if (uid.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(196, 0, 0, 0),
                          content:
                              Center(child: Center(child: Text("Please enter full 6-character UID",style: TextStyle(color: Color.fromARGB(255, 255, 0, 0),fontWeight: FontWeight.bold),))),
                        ),
                      );
                      return;
                    }

                    try {
                      final supabase = Supabase.instance.client;
                      final currentUser = supabase.auth.currentUser;

                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Center(child: Text("User not logged in"))),
                        );
                        return;
                      }

                      final driver = await supabase
                          .from('drivers_data')
                          .select()
                          .eq('uid', uid)
                          .maybeSingle();

                      if (driver == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          
                          const SnackBar(
                              backgroundColor: Color.fromARGB(156, 0, 0, 0),
                              content: Center(child: Text("No driver found with this UID",style: TextStyle(color: Color.fromARGB(255, 255, 17, 0),fontWeight: FontWeight.bold),))),
                        );
                        return;
                      }

                      final userRow = await supabase
                          .from('user_data')
                          .select('user_linked_uid')
                          .eq('user_uid', currentUser.id)
                          .maybeSingle();

                      List<dynamic> existingUids =
                          userRow?['user_linked_uid'] ?? [];

                      List<String> uidList = existingUids.cast<String>();

                      if (!uidList.contains(uid)) {
                        uidList.add(uid);

                        await supabase.from('user_data').update({
                          'user_linked_uid': uidList,
                        }).eq('user_uid', currentUser.id);
                      }
                      else{
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Center(child: Center(child: Text("UID already saved in your account",style: TextStyle(color: Color.fromARGB(255, 206, 218, 100),
                              
                                  fontWeight:FontWeight.bold),
                              )
                              )
                              )
                              ));
                               if (context.mounted) Navigator.pop(context);
                               return;

                      }

                      global.linkedUserUid = uidList;
                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Center(child: Center(child: Text("Successfully saved this Operator",style: TextStyle(color: Color.fromARGB(255, 100, 218, 104),
                              
                                  fontWeight:FontWeight.bold),
                              )
                              )
                              )
                              ),
                        );
                      if (context.mounted) Navigator.pop(context); 
                      return;// Dismiss dialog

                     
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                    child: Text(
                      'SAVE THIS UID DRIVER',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

// Helper class to format uppercase input
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
