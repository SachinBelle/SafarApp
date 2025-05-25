import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_switch/flutter_switch.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  bool isDarkMode = false;
  bool isAccountSelected = false;
  bool isSettingsSelected = false;
  bool isLogoutSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFDEF6),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  color: const Color(0xFF92A8C1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 160,
                        child: Image.asset('assets/logo/safarword.png'),
                      ),
                      AnimatedTextKit(
                        isRepeatingAnimation: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Hello XXX...',
                            textStyle: GoogleFonts.staatliches(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),

                // Info
                Container(
                  color: const Color(0xFFCFDEF6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 70,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phone',
                            style: GoogleFonts.albertSans(fontSize: 20),
                          ),
                          Text(
                            'XXXXXXXXXX',
                            style: GoogleFonts.albertSans(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email',
                            style: GoogleFonts.albertSans(fontSize: 20),
                          ),
                          Text(
                            'XXXXXXXXXX',
                            style: GoogleFonts.albertSans(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Options
                Expanded(
                  child: ListView(
                    children: [
                      const Divider(
                        thickness: 2,
                        color: Colors.black87,
                        height: 10,
                      ),

                      // Dark Mode / Day Mode Toggle
                      _buildModeToggle(),

                      _buildOption(
                        icon: Icons.person_outline,
                        toggledIcon: Icons.person,
                        title: 'Account Setting',
                        isToggled: isAccountSelected,
                        onTap: () {
                          setState(() {
                            isAccountSelected = !isAccountSelected;
                          });
                        },
                      ),
                      _buildOption(
                        icon: Icons.settings_outlined,
                        toggledIcon: Icons.settings,
                        title: 'Setting',
                        isToggled: isSettingsSelected,
                        onTap: () {
                          setState(() {
                            isSettingsSelected = !isSettingsSelected;
                          });
                        },
                      ),
                      _buildOption(
                        icon: Icons.logout_outlined,
                        toggledIcon: Icons.logout,
                        title: 'Log out',
                        isToggled: isLogoutSelected,
                        onTap: () {
                          setState(() {
                            isLogoutSelected = !isLogoutSelected;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Avatar
            Positioned(
              top: 175,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dark Mode / Day Mode toggle option
  Widget _buildModeToggle() {
    return Column(
      children: [
        Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    isDarkMode ? 'Day Mode' : 'Dark Mode',
                    style: GoogleFonts.albertSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              FlutterSwitch(
                width: 60.0,
                height: 30.0,
                toggleSize: 25.0,
                value: isDarkMode,
                borderRadius: 30.0,
                padding: 4.0,
                activeToggleColor: Colors.yellow[700],
                inactiveToggleColor: Colors.indigo[900],
                activeColor: Colors.grey[300]!,
                inactiveColor: Colors.black26,
                activeIcon: const Icon(
                  Icons.light_mode,
                  color: Colors.white,
                  size: 20,
                ),
                inactiveIcon: const Icon(
                  Icons.dark_mode,
                  color: Colors.white,
                  size: 20,
                ),
                onToggle: (val) {
                  setState(() {
                    isDarkMode = val;
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 0.8,
          indent: 20,
          endIndent: 20,
          color: Colors.black54,
        ),
      ],
    );
  }

  // Other options
  Widget _buildOption({
    required IconData icon,
    required IconData toggledIcon,
    required String title,
    required bool isToggled,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isToggled ? toggledIcon : icon,
                    key: ValueKey<bool>(isToggled),
                    color: isToggled ? Colors.blueAccent : Colors.black,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.albertSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 0.8,
          indent: 20,
          endIndent: 20,
          color: Colors.black54,
        ),
      ],
    );
  }
}
