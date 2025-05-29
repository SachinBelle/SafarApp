import 'package:flutter/material.dart';
import 'package:saffer_app/pages/uid_pages/add_uid_box.dart';
import 'package:saffer_app/pages/uid_pages/uid_page.dart';
import 'package:saffer_app/student/parent_signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:saffer_app/pages/profile_page/profile_page.dart';
import 'package:saffer_app/global/global_assets.dart' as global;


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
   
     List<dynamic>? linkedUids;
    if(widget.uidList.isEmpty){

      try {
      final response = await Supabase.instance.client
          .from('user_data')
          .select('user_linked_uid')
          .eq('user_uid',global.userId )
          .maybeSingle();

       linkedUids= response?['user_linked_uid'];
      }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(
        child: Text("Got an error $e",style: TextStyle(color: Colors.red),),
      )));
    }}
    else{
      linkedUids=widget.uidList;
    }
    
        
        
      final List<String> uidList = linkedUids?.map((e) => e.toString()).toList() ?? [];
      if (uidList.isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UIDPage()));
      }
      try{
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
          height: 100,
          width: 160,
          child: Image.asset('assets/logo/safarword.png'),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 187, 201, 225),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20,top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      
                      children: [
                        Text("Select Transport Operator", style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 24,
                          fontFamily: 'albertSans'
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...driverData.map((driver) => Card(
                        child: ListTile(
                          onTap: (){

                          },
  tileColor: Color.from(alpha: 0.557, red: 0.851, green: 0.851, blue: 0.851),
  leading:GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: // Optional: allows zoom and pan
             ClipOval(
              child: Image.network(
          "https://putmfvonnimjvavnnbwm.supabase.co/storage/v1/object/public/profile.photos/driver_profile_photo/bus_default.jpg",
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
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
      fit: BoxFit.contain,
      width: 48.5,
      height: 70,
    ),
  ),
),

  title: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     
      Row(
        children: [
          Text("Name: ", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
          Text(driver['driver_name'], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        ],
      ),
       Row(
        children: [
           
        
          Text("Orgnization Name: ", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
           Expanded(
             child: Text(
                formatOrganizationName(driver['organization_name']),
                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              
                  // optional
               ),
           ),
             
        ],
      ),
      Row(
        children: [
          Text("Phone No: ", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
          Text("+${driver['phone_number']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
       
        ],
      ),
     
    ],
  ),
  // trailing: ClipRRect(
  //     child: Image.asset(
  //       width: 5,
  //       height: 70,
  //       "assets/icons/locate_icon.png",
  //       fit: BoxFit.contain,
  //     ),
  //   ),
 
)
                      ),
                      ),
                const SizedBox(height: 15,),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Card(
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context, builder:(_)=>Dialog(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: GestureDetector(
                        onTap: ()=>Navigator.of(context).pop(),
                        child: UidBox(),
                      ),

                    ));
              
                },
                
                  tileColor: Color.fromARGB(228, 217, 217, 217),
                   title: Text("Click to Join other Transport Operator through UID",style: TextStyle(
                    fontWeight: FontWeight.w300, fontSize: 15
                   ),),
                  leading:
                   ClipRRect(
                    child: Image.asset(
                      width: 50,
                      height: 50,
                      "assets/icons/add_icon.png",
                      fit: BoxFit.contain,
                    ),
                  ),
              
              
              ),
            ),
          ),

                      

            
                 
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

String formatOrganizationName(String orgName, {int wordsPerLine = 2}) {
  final words = orgName.split(' ');
  final buffer = StringBuffer();

  for (int i = 0; i < words.length; i++) {
    buffer.write(words[i]);
    if ((i + 1) % wordsPerLine == 0 && i != words.length - 1) {
      buffer.write('\n');
    } else {
      buffer.write(' ');
    }
  }

  return buffer.toString().trim();
}