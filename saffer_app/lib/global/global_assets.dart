library;

import 'package:google_maps_flutter/google_maps_flutter.dart';

String phoneNumber="N/A";
String userName="N/A";
String userId="";
List<String> linkedUserUid=[];
const String googleMapApi="AIzaSyBf53N_S2WC4awDxgOVzqLDue4PC93sUbw";

LatLng? cachedUserLocation;

void setPhoneNumber(String value) {
  phoneNumber = value;
}

void setUserName(String value){
  userName=value;
}
void setUserId(String value){
  userId=value;
}