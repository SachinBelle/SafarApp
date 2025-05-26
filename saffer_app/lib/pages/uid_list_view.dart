
import 'package:flutter/material.dart';
import 'package:saffer_app/pages/profile_page.dart';

class UidListPage extends StatefulWidget {
  const UidListPage({super.key});

  @override
  State<UidListPage> createState() => _UidListPageState();
}

 

class _UidListPageState extends State<UidListPage> {
   int _selectedIndex = 1;
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: SizedBox(
                              height: 80,
                              width: 160,
                              child: Image.asset('assets/logo/safarword.png'),
                            ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(226, 206, 230, 224),
      ),
      body:SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
            
              children: [
                SizedBox(height:15),
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
                  SizedBox(height: 20,),
                  Text("Select Transport Operator",style: Theme.of(context).textTheme.titleMedium,),
                  

              ],

            ),
          ),
        ),
      ),
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