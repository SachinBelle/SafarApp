import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:saffer_app/global/global_assets.dart' as global;
import 'package:saffer_app/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saffer_app/pages/uid_list_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class UIDPage extends StatefulWidget {
  
  const UIDPage({super.key});

  @override
  State<UIDPage> createState() => _UIDPageState();
}

class _UIDPageState extends State<UIDPage> {
  final List<TextEditingController> _uidControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _uidFocusNodes = List.generate(6, (_) => FocusNode());

  int _selectedIndex = 1;

  @override
  void dispose() {
    for (var controller in _uidControllers) {
      controller.dispose();
    }
    for (var focusNode in _uidFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFDEF6),
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Safar logo
                      Padding(
                        padding: const EdgeInsets.only(left: 22.5, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Center(
                            child: SizedBox(
                              height: 80,
                              width: 160,
                              child: Image.asset('assets/logo/safarword.png'),
                            ),
                          ),
                        ),
                      ),

                      // Locate Transport image
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/Avatars/locate_bus1.png',
                            fit: BoxFit.cover,
                            width: 270,
                            height: 64,
                          ),
                        ),
                      ),

                      // Main content
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 228, 234, 248),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                              
                             Text(
                              'No Saved Operator Found',
                              style: GoogleFonts.albertSans(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                             Text(
                              'Enter UID To Add Operator',
                               style: GoogleFonts.albertSans(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // UID input boxes
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                6,
                                (index) => SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: TextField(
                                      inputFormatters: [
                                        UpperCaseTextFormatter(),
                                      ],
                                      controller: _uidControllers[index],
                                      focusNode: _uidFocusNodes[index],
                                      // keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter.digitsOnly,
                                      // ],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        height: 1, // Adjusts vertical centering
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: -5,
                                          horizontal: 1,
                                        ), // Ensures perfect vertical centering
                                        // isDense:
                                        //     true, // Makes the field more compact
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty && index < 5) {
                                          FocusScope.of(context).requestFocus(
                                            _uidFocusNodes[index + 1],
                                          );
                                        } else if (value.isEmpty && index > 0) {
                                          FocusScope.of(context).requestFocus(
                                            _uidFocusNodes[index - 1],
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                             Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Contact your transport operator or organization to get UID',
                                textAlign: TextAlign.center,
                                 style: GoogleFonts.albertSans(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom box above keyboard when open
              if (isKeyboardVisible)
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ElevatedButton(
                     onPressed: () async {
  final uid = _uidControllers.map((c) => c.text).join().toUpperCase();

  if (uid.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(child: Text("Please enter full 6-character UID")),
      ),
    );
    return;
  }

  try {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    // Check if the UID exists in drivers_data
    final driver = await supabase
        .from('drivers_data')
        .select()
        .eq('uid', uid)
        .maybeSingle();

    if (driver == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text("No driver found with this UID"))),
      );
      return;
    }

    // Fetch current list of linked UIDs
    final userRow = await supabase
        .from('user_data')
        .select('user_linked_uid')
        .eq('user_uid', currentUser.id)
        .maybeSingle();

    List<dynamic> existingUids = userRow?['user_linked_uid'] ?? [];

    // Convert to List<String> safely
    List<String> uidList = existingUids.cast<String>();

    if (!uidList.contains(uid)) {
      uidList.add(uid);

      // Update Supabase user record
      await supabase.from('user_data').update({
        'user_linked_uid': uidList,
      }).eq('user_uid', currentUser.id);
    }

    // Navigate to list page with updated UID list
    global.linked_user_uid = uidList;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => UidListPage(uidList: uidList,)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text("Error: ${e.toString()}",style: TextStyle(color: Colors.red),))),
    );
  }
},


                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child:  Text(
                          'SAVE THIS UID DRIVER',
                           style: TextStyle(
                            fontFamily: "",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFE9E9E9),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          selectedIconTheme: const IconThemeData(color: Colors.black),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: [
            _buildNavItem(Icons.notifications, 'NOTICE', 0),
            _buildNavItem(Icons.location_on, 'LOCATE', 1),
            _buildNavItem(Icons.person, 'PROFILE', 2),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.amber : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, size: 28, color: Colors.black),
      ),
      label: label,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
