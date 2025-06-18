import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/http/interface/request_base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saffer_app/global/global_assets.dart' as global;

import 'package:saffer_app/pages/map/bloc/location_bloc.dart';
import 'package:saffer_app/pages/map/methods/map_methods.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class MainMap extends StatefulWidget {
  final String driverUid;
  final String driverName;
  final String driverOrgName;
  final String driverPhoneNo;
  final String driverVechileNo;
  const MainMap({super.key, required this.driverUid, required this.driverName, required this.driverOrgName, required this.driverPhoneNo, required this.driverVechileNo});

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  late GoogleMapController _mapController;
  bool _isLocationReady = false;
  bool _isMapReady = false;
  BitmapDescriptor? _customUserMarker;
  BitmapDescriptor? _customDriverMarker;
  LatLng? _driverLocation;
  final Set<Polyline> _polylines = {};
  StreamSubscription<Position>? _locationSubscription;
  Position? _currentPosition;
  List<LatLng>? _pendingRoute;

  @override
  void initState() {
    super.initState();
    
    _loadCustomMarkers();
    _fetchDriverLocation();
    _subscribeToDriverLocation();
  }

  @override
  void dispose() {
    BlocProvider.of<LocationBloc>(context).add(StopLocationUpdates());
    Supabase.instance.client.removeChannel(_driverChannel);
    super.dispose();
  }

  Future<void> _loadCustomMarkers() async {
    final userMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(50, 50)),
      'assets/icons/student_marker_icon.png',
    );

    final driverMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(50, 50)),
      'assets/icons/bus_icon_enhanced.png',
    );

    setState(() {
      _customUserMarker = userMarker;
      _customDriverMarker = driverMarker;
    });
  }



 

  Future<void> _fetchDriverLocation() async {
    try {
      final supabase = Supabase.instance.client;
      final data =
          await supabase
              .from('driver_tracking')
              .select('latitude, longitude')
              .eq('driver_uid', widget.driverUid)
              .maybeSingle();

      if (data != null &&
          data['latitude'] != null &&
          data['longitude'] != null) {
        setState(() {
          final latitude = (data['latitude'] as num).toDouble();
          final longitude = (data['longitude'] as num).toDouble();
          _driverLocation = LatLng(latitude, longitude);
          _drawRouteAndShowInfo();
        });
      }
    } catch (e) {
      print('Error fetching driver location: \$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              "Error fetching driver location: \$e",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }
  }
  late RealtimeChannel _driverChannel;

void _subscribeToDriverLocation() {
  final supabase = Supabase.instance.client;

  _driverChannel = supabase.channel('driver_location_updates');

  _driverChannel
    .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'driver_tracking',
      filter:  PostgresChangeFilter(
        type:  PostgresChangeFilterType.eq,
  column: 'driver_uid',
  
  value: widget.driverUid, 
),
      callback: (payload) {
        final newData = payload.newRecord;
        if (newData != null &&
            newData['latitude'] != null &&
            newData['longitude'] != null) {
          final latitude = (newData['latitude'] as num).toDouble();
          final longitude = (newData['longitude'] as num).toDouble();

          setState(() {
            _driverLocation = LatLng(latitude, longitude);
            _drawRouteAndShowInfo();
          });
        }
      },
    )
    .subscribe();
}


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapReady = true;
    // _setMapStyle();

    if (_isLocationReady && _driverLocation != null) {
      _moveToDriverLocation();
    }
  }

  void _moveToDriverLocation() {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_driverLocation!, 17),
    );
  }

  Widget _buildShimmerMapPlaceholder() {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 485,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
        const Positioned.fill(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
  List<LatLng>? _routePolyline;
  String _distanceText="";
  String _durationText="";
  void _drawRouteAndShowInfo() async {
  final result = await getRoutePolyline(
    origin: _driverLocation!,
    destination: global.cachedUserLocation!,
    apiKey: global.googleMapApi,
  );

  final polyline = result['polyline'] as List<LatLng>;
  final distance = result['distance'] as String;
  final duration = result['duration'] as String;

  setState(() {
    _routePolyline = polyline;
    _distanceText = distance;
    _durationText = duration;
  });

  print('Distance: $distance, ETA: $duration');



  try {
      List<LatLng> route = _routePolyline!;

      final polyline = Polyline(
        polylineId: const PolylineId('google_route'),
        color: const Color.fromARGB(255, 255, 230, 0),
        width: 6,
        points: route,
      );

      setState(() {
        _polylines.clear();
        _polylines.add(polyline);
        _isLocationReady = true;
      });
    } catch (e) {
      print('Error drawing route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to load route: $e",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
}


  

  

  //to set google map an dark theme
  Future<void> _setMapStyle() async {
    String style = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_styles/dark_map_style.json');
    _mapController.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
         if (state is LocationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text(state.message)), backgroundColor: Colors.red),
          );
        } else if (state is LocationSuccess) {
          setState(() {
            _currentPosition = state.position;
            global.cachedUserLocation = LatLng(
              state.position.latitude,
              state.position.longitude,
            );
          });

          // Redraw route if available
          if (_driverLocation != null) {
            _drawRouteAndShowInfo();
          }}
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(126, 225, 111, 0.9),
          title: SizedBox(
            height: 100,
            width: 160,
            child: Image.asset('assets/logo/safarword.png'),
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 147,
                    color: const Color.fromRGBO(126, 225, 111, 0.9),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              
                              height: 100,
                              width: 60,
                              child: SvgPicture.asset("assets/icons/map_gps_pin.svg",fit: BoxFit.contain,)),
                         
                          Padding(
                            padding: const EdgeInsets.only(top: 10,left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 0,
                              children:[
                                Text.rich(
                                TextSpan(children:[
                                  TextSpan(
                                    text: "Driver is ",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  TextSpan(
                                    text: "Online! ",
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Colors.green
                                      ),
                                  ),
                                  TextSpan(
                                    text: "Tracking your Ride",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ] )
                                ),
                               
                                Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _durationText.isEmpty
                                    ? "Calculating time of arrival of driver"
                                    : "Arriving in ",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (_durationText.isNotEmpty)
                                TextSpan(
                                  text: _durationText,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: const Color.fromARGB(255, 255, 183, 1), // 👈 custom color here
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: _distanceText.isEmpty
                                    ? "Calculating distance between you and driver!"
                                    : "",
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              if (_distanceText.isNotEmpty)
                                ...[
                                  TextSpan(
                                    text: _distanceText,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.blue, // 👈 highlight distance text
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' away from your stop',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                            ],
                          ),
                        ),
                        
                                
                              ],
                            ),
                          )
                          ],
                        ),
                      ),
                    ),
                  ),
                  _isLocationReady &&
                          _customUserMarker != null &&
                          _customDriverMarker != null
                      ? SizedBox(
                        height: 490,
                        width: double.infinity,
                        child: GoogleMap(
                          compassEnabled: false,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: global.cachedUserLocation!,
                            zoom: 17,
                          ),
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          markers: {
                            Marker(
                              markerId: const MarkerId('user_location'),
                              position: global.cachedUserLocation!,
                              icon: _customUserMarker!,
                            ),
                            if (_driverLocation != null)
                              Marker(
                                markerId: const MarkerId('driver_location'),
                                position: _driverLocation!,
                                icon: _customDriverMarker!,
                              ),
                          },
                          polylines: _polylines,
                        ),
                      )
                      : _buildShimmerMapPlaceholder(),
                ],
              ),
             Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 140), // 👈 distance from top
                  child: Container(
                    width: 125,
                    height: 60,
                    decoration: BoxDecoration(
          color: const Color.fromARGB(255, 132, 228, 136),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
                    ),
                    child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Mode", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("Pick Up", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("ON RIDE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          Positioned(
            top: 650,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromRGBO(126, 225, 111, 0.9),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   SvgPicture.asset("assets/icons/bus_driver_profile.svg"),
                   const SizedBox(width: 10,),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "Name: ",
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize: 16
                          )
                          
                       
                        ),
                        TextSpan(
                          text: widget.driverName,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)
                        )
                       
                       ]
                       )
                       ),
                       Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "Vehicle Plate NO: ",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 16
                      )
                      

                    ),
                    TextSpan(
                      text: widget.driverVechileNo,
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)
                    )

                   ]
                   )
                   )
                     ],

                   ),
                    IconButton(onPressed: (){

                    }, icon:Icon(Icons.arrow_drop_down,size: 30,))
                    ]
                   
                  
                  ),
                  const SizedBox(height: 13,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12), // Optional to center nicely
                        child: SvgPicture.asset(
                          "assets/icons/Bus_whiteIcon.svg",
                          fit: BoxFit.contain,
                          color: Colors.white, // 👈 Force it visible on black background
                        ),
                      ),
                    ),
                     Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12), // Optional to center nicely
                        child: SvgPicture.asset(
                          "assets/icons/Bus_whiteIcon.svg",
                          fit: BoxFit.contain,
                          color: Colors.white, // 👈 Force it visible on black background
                        ),
                      ),
                    ),
                  ],
                )


                ],
              ),
            ),
          )
          
            ],
          ),
        ),
      ),
    );
  }
}
