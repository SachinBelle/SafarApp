import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saffer_app/pages/map_page/main_map.dart';
import 'package:saffer_app/pages/profile_page/profile_page.dart';
import 'package:saffer_app/pages/uid_pages/add_uid_box.dart';
import 'package:saffer_app/pages/uid_pages/uid_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:saffer_app/global/global_assets.dart' as global;

class UidListPage extends StatefulWidget {
  final List<String> uidList;

  const UidListPage({super.key, required this.uidList});

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentProfilePage()),
      );
    }
  }

  Future<void> fetchDriverData() async {
    List<dynamic>? linkedUids;

    if (widget.uidList.isEmpty) {
      try {
        final response = await Supabase.instance.client
            .from('user_data')
            .select('user_linked_uid')
            .eq('user_uid', global.userId)
            .maybeSingle();

        linkedUids = response?['user_linked_uid'];
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text("Got an error $e", style: TextStyle(color: Colors.red)),
            ),
          ),
        );
      }
    } else {
      linkedUids = widget.uidList;
    }

    final List<String> uidList = linkedUids?.map((e) => e.toString()).toList() ?? [];

    if (uidList.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UIDPage()),
      );
      return;
    }

    try {
      final fetchedData = await Supabase.instance.client
          .from('drivers_data')
          .select()
          .filter('uid', 'in', uidList);

      setState(() {
        driverData = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("Got an error $e", style: TextStyle(color: Colors.red)),
          ),
        ),
      );
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
     
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,left: 0,right:0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Container(
                        
                         height: 35,
                          width: 147,
                         child:Image.asset(
                          'assets/logo/safarword.png',
                         fit: BoxFit.contain,
                          
                         ),
                       ),
                      const SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/Avatars/locate_bus1.png',
                          fit: BoxFit.cover,
                          width: 270,
                          height: 64,
                        ),
                      ),
                      const SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text(
                              "Select Transport Operator",
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 26,
                                    fontFamily: 'albertSans',
                                    fontWeight: FontWeight.bold,
                  
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...driverData.map((driver) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                        child: Card(
                              color: Colors.white,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainMap()));
                                },
                                child: ListTile(
                                  tileColor: const Color.fromRGBO(217, 217, 217, 0.56),
                                  leading: GestureDetector(
                                    onTap: (){
                                       showDialog(
                                                            context: context,
                                                            builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.all(20),
                                child: Center(
                                  child: ClipOval(
                                                  child: Image.network(
                                                         "https://putmfvonnimjvavnnbwm.supabase.co/storage/v1/object/public/profile.photos/driver_profile_photo/bus_default.jpg",
                                
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                  ),
                                ),
                                                            ),
                                                          );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        "https://putmfvonnimjvavnnbwm.supabase.co/storage/v1/object/public/profile.photos/driver_profile_photo/bus_default.jpg",
                                        fit: BoxFit.cover,
                                        width: 45,
                                        height: 45,
                                      ),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Name: ",
                                              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
                                          Text(driver['driver_name'],
                                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Org Name: ",
                                              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                                          Text(driver['organization_name'],
                                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Phone No: ",
                                              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
                                          Text("+${driver['phone_number']}",
                                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                                        ],
                                      ),
                                    ],
                                  ),
                                 
                                ),
                              ),
                            ),
                      )),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                         showDialog(context: context, builder: (context)=>UidBox());
                         
                        },
                        child: const Text("ADD ANOTHER UID"),
                      )
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