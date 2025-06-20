import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saffer_app/pages/map/bloc/location_bloc.dart';
import 'package:saffer_app/pages/map/screens/main_map_screen.dart';
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
    final screenHeight=MediaQuery.of(context).size.width;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
     
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                     SizedBox(
                      height: 90,
                      width: 250,
                     
                       child: Image.asset(
                        'assets/logo/safarword.png',
                       fit: BoxFit.cover,
                        
                       ),
                     ),
                      SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      height: 60,
                      color: Color.fromRGBO(213, 160, 33, 0.8),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 10,
                        children: [
                          SvgPicture.asset("assets/icons/two_gps.svg",width: 50,),
                        Text("Locate Your Ride",style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          
                          fontSize: 32,
                        ),)
                      ],),
                    ),
                  //  SizedBox(height: ,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                      "Choose a Driver to Track",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                      "Their Vehicle Location ",
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    ...driverData.map((driver) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: GestureDetector(
                        onTap: (){
                         Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (_) => LocationBloc()..add(StartLocationUpdates()),
                                          child: MainMap(driverUid: driver['uid'].toString(), driverName: driver['driver_name'].toString(), driverOrgName: driver['organization_name'].toString(), driverPhoneNo: driver['phone_number'].toString(), driverVechileNo: driver['vehicle_plate_No'].toString(),),
                                        ),
                                      ),
                            );},
                            
                        child: ListTile(
                          
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(15))),
                          tileColor: const Color(0xFFE0E1DD),
                          leading: GestureDetector(
                            onTap: (){
                               showDialog(
                                                    context: context,
                                                    builder: (_) => Dialog(
                        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
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
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                "https://putmfvonnimjvavnnbwm.supabase.co/storage/v1/object/public/profile.photos/driver_profile_photo/bus_default.jpg",
                                fit: BoxFit.cover,
                                width:60 ,
                                height: 60,
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Name: ",
                                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15,fontFamily: "AlbertSans")),
                                  Text(driver['driver_name'],
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17,fontFamily: "AlbertSans")),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Org Name: ",
                                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12,fontFamily: "AlbertSans")),
                                  Expanded(
                                    child: Text(driver['organization_name'],
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16,fontFamily: "AlbertSans")),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Phone No: ",
                                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15,fontFamily: "AlbertSans")),
                                  Expanded(
                                    child: Text("+${driver['phone_number']}",
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17,fontFamily: "AlbertSans")),
                                  ),
                                ],
                              ),
                            ],
                          ),
                         trailing:SizedBox(
                          height: 100,
                          width: 50,
                          child: SvgPicture.asset("assets/icons/navigator-circular.svg",)),
                        ),
                      ),
                    )),
                    // const SizedBox(height: 4),
                    GestureDetector(
                      onTap: (){
                        showDialog(context: context, 
                        barrierDismissible: true,
                        builder:(BuildContext context){
                          return UidBox();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          height: 90,
                          width: double.infinity,
                          decoration:BoxDecoration(
                            color: const Color.fromARGB(255, 225, 224, 224),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child:Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.start,
                          
                            children: [
                              
                        
                             SizedBox(
                                          width: 50, // Set desired width
                                          height: 50, // Set desired height
                                          child: SvgPicture.asset(
                                            "assets/icons/add-circle.svg",
                                            
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        
                             Text("Click to add Transport Operator through \nDriver UID",style: TextStyle(fontFamily: "Albertsans",fontWeight: FontWeight.w700),)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
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