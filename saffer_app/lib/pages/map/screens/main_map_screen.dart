

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saffer_app/global/global_assets.dart';
import 'package:saffer_app/global/global_assets.dart' as global;
import 'package:saffer_app/pages/map/methods/methods.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class MainMap extends StatefulWidget {
  final String driver_uid;
  const MainMap({super.key, required this.driver_uid});

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


  @override
  void initState() {
    super.initState();
    _initializeMap();
    _loadCustomMarkers();
    _fetchDriverLocation();
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

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  }

  Future<void> _initializeMap() async {
    await _requestLocationPermission();

    if (cachedUserLocation == null) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      cachedUserLocation = LatLng(position.latitude, position.longitude);
    }

  

    if (_isMapReady) {
       _moveToDriverLocation();
    }
  }

  Future<void> _fetchDriverLocation() async {
    try {
      final supabase = Supabase.instance.client;
      final data = await supabase
          .from('driver_tracking')
          .select('latitude, longitude')
          .eq('driver_uid', widget.driver_uid)
          .maybeSingle();

      if (data != null && data['latitude'] != null && data['longitude'] != null) {
        setState(() {
          final latitude = (data['latitude'] as num).toDouble();
          final longitude = (data['longitude'] as num).toDouble();
          _driverLocation = LatLng(latitude, longitude);
         _drawRouteWithGoogleDirectionsAPI();
        });
      }
    } catch (e) {
      print('Error fetching driver location: \$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(
          child: Text("Error fetching driver location: \$e",style: TextStyle(color: Colors.red),),
        ))
      );
    }
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
  Future<void> _drawRouteWithGoogleDirectionsAPI() async {
  const String apiKey = global.googleMapApi; // Replace with your actual key

  if (cachedUserLocation == null || _driverLocation == null) return;

  try {
    List<LatLng> route = await getRoutePolyline(
      origin: _driverLocation!,
      destination: cachedUserLocation!,
      apiKey: apiKey,
    );

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
        content: Text("Failed to load route: $e", style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}





//to set google map an dark theme 
Future<void> _setMapStyle() async {
  String style = await DefaultAssetBundle.of(context)
      .loadString('assets/map_styles/dark_map_style.json');
  _mapController.setMapStyle(style);
}








  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(126,225,111,0.9),
        title: SizedBox(
          height: 100,
          width: 160,
          child: Image.asset('assets/logo/safarword.png'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children:[ Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 147,
                  color: const Color.fromRGBO(126,225,111,0.9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 90,
                      color: const Color.fromRGBO(219, 219, 219, 1),
                      child: Row(
                        children: [
                         Image.asset("assets/icons/location_pin.png"),
                          Text("hello world")

                        ],
                      ),
                    ),
                  ),
                ),
                _isLocationReady && _customUserMarker != null && _customDriverMarker != null
                    ? SizedBox(
                        height: 485,
                        width: double.infinity,
                        child: GoogleMap(
                          compassEnabled: false,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: cachedUserLocation!,
                            zoom: 17,
                          ),
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          markers: {
                            Marker(
                              markerId: const MarkerId('user_location'),
                              position: cachedUserLocation!,
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
               ] ),
        ),
      ),
    );
  }
}


