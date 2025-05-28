import 'package:flutter/material.dart';
import 'package:saffer_app/pages/uid_page.dart';
import 'package:saffer_app/student/parent_signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:saffer_app/pages/profile_page.dart';


class UidListPage extends StatefulWidget {
   List<String> uidList;
   UidListPage({super.key,required this.uidList});

  @override
  State<UidListPage> createState() => _UidListPageState();
}

class _UidListPageState extends State<UidListPage> {
  int _selectedIndex = 1;
  List<dynamic> driverData = [];
  bool isLoading = true;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentProfilePage()));
    }
  }

  Future<void> fetchDriverData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserSignUp()));
      return;
    }
    try {
      final response = await Supabase.instance.client
          .from('user_data')
          .select('user_linked_uid')
          .eq('user_uid', user.id)
          .maybeSingle();

      final List<dynamic>? linkedUids = response?['user_linked_uid'];

        
        
      final List<String> uidList = linkedUids?.map((e) => e.toString()).toList() ?? [];
      if (uidList.isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UIDPage()));
      }
      final driver_data = await Supabase.instance.client
          .from('drivers_data')
          .select()
          .filter('uid','in', linkedUids);

      setState(() {
        driverData = driver_data;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(
        child: Text("Got an error $e",style: TextStyle(color: Colors.red),),
      )));
     
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDriverData();
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  const SizedBox(height: 20),
                  Text("Select Transport Operator", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  ...driverData.map((driver) => Card(
                        child: ListTile(
                          title: Text("Name: ${driver['driver_name'] ?? 'N/A'}",style: Theme.of(context).textTheme.titleMedium,),
                          subtitle: Text("Organization name: ${driver['organization_name'] ?? 'N/A'}",),
                        ),
                      )),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                       // Go back to UID entry page
                    },
                    child: const Text("ADD ANOTHER UID"),
                  )
                ],
              ),
            ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
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

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
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
