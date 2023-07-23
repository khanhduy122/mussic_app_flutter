import 'package:flutter/material.dart';

Widget containerBack (BuildContext context){
  return  GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: const Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
  );
}
  
