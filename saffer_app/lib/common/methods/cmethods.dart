//used to build common element quickly as scaffold messender or snack bar with an specific message message

import 'package:flutter/material.dart';

class cmethods{

void showSnackBarError(context,String message){
  if(!context.mounted) return;
  final snackBar=SnackBar(content:Center(
    child: Center(child: Text(message,style:TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 15,
      color: Colors.red,
    ),)), 
  ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
bool userformValidation(BuildContext context,{ required TextEditingController? nameTED,required TextEditingController phoneNumberTED}){
    String name=nameTED!.text.trim();
     
    String phoneNumber=phoneNumberTED.text.trim();
    
    
      if(name.isEmpty||phoneNumber.isEmpty){
  showSnackBarError(context, "Enter All Details");
  return false;
      }
  if(name.length<3){
  showSnackBarError(context, "User Name should contain more than three characters");
    return false;
  }
  if(phoneNumber.length!=10){
     showSnackBarError(context, "Phone Number must contain 10 digits");
    return false;
  }
  return true;

}

}