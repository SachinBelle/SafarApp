
import 'package:flutter/material.dart';

class UidListPage extends StatefulWidget {
  const UidListPage({super.key});

  @override
  State<UidListPage> createState() => _UidListPageState();
}

class _UidListPageState extends State<UidListPage> {
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
    );
  }
}