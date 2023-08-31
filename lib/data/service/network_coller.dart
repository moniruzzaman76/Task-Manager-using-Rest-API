import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../app.dart';
import '../../ui/auth/login_screen.dart';
import '../model/auth_utility.dart';
import 'network_response.dart';



class NetWorkCaller{

  Future<NetworkResponse>getRequest(String url,{bool isSuccessOTP = false})async{

   try {
      Response response = await get(Uri.parse(url),headers: {"token": AuthUtility.userInfo.token.toString()});
      final Map<String,dynamic> decodeResponse = jsonDecode(response.body);
      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200 && decodeResponse["status"] == "success") {
         return NetworkResponse(true,response.statusCode, jsonDecode(response.body));

      } else if(response.statusCode == 401){
        gotoLogin();
      }
      else {
       return NetworkResponse(false,response.statusCode,null);
      }
    }catch(e){
     log(e.toString());
   }
   return NetworkResponse(false,-1, null);
  }


  Future<NetworkResponse>postRequest(String url,Map<String,dynamic>body, {bool isLogin = false})async{
    log(body.toString());
    Response response = await post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json',"token": AuthUtility.userInfo.token.toString()},
        body:jsonEncode(body)
    );
    log(response.statusCode.toString());
    log(response.body);
    try{
      if(response.statusCode==200 ){
        return NetworkResponse(true, response.statusCode, jsonDecode(response.body));
      }
      else if(response.statusCode == 401){
        if(isLogin == false ){
          gotoLogin();
        }
      }
      else{
        return NetworkResponse(false, response.statusCode, null);
      }
    }catch(e){
      log(e.toString());
    }
    return NetworkResponse(false, response.statusCode, null);
  }

  void gotoLogin()async{
    await AuthUtility.clearUserInfo();

    Navigator.pushAndRemoveUntil(MyApp.globalKey.currentContext!, MaterialPageRoute(
        builder: (context)=>const LoginScreen()),
            (route) => false);
  }

}