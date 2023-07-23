

import 'package:flutter/material.dart';

void showDialogErro({required BuildContext context, required Object erro}){
  showDialog(
    context: context, 
    builder: (context) {
      return Center(
        child: Text(erro.toString(),
          style: TextStyle(color: Colors.white),
        ),
      );
    },
  );
}