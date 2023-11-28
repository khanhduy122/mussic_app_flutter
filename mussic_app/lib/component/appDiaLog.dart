import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';

class appDiaLog {

  static Future<bool> showModalComfirm({required BuildContext context , required String tiltle ,required String subTitle}) async {
    bool isComfirm;
    isComfirm = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            decoration: const BoxDecoration(
              color: appColor.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Center(
                    child: Text(tiltle,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Center(
                    child: Text(subTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16,),
                    ),
                  ),
                  const SizedBox(height: 10,),
                 GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                   child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: appColor.blue,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Text("Có",
                        style:  TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                 ),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: appColor.LightGray,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Text("Không",
                        style:  TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),  
          )
        );
      },
    );

    return isComfirm;
  }

  static void ToastNotifi({required String title}){
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0
    );
  } 

  static void ShowDialogLoading(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) => Container(
        color: Colors.transparent,
        child: const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
          )),
        )
        ),
    );
  }

  static void showDialogNotify({required String content, required BuildContext context}){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thông Báo",
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ) ,
          content: Text(content),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text("OK",
                style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
              ) ,
            )
          ],
        );
      },
    );
  }

  static Future<bool> showDialogComfirmAndroid({required BuildContext context ,required String tiltle, required String subTitle}) async {
    bool confirm = await showDialog(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(tiltle),
          content: Text(subTitle),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Không",
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
              ) ,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("có",
                style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
              ) ,
            ),
          ],
        );
      },
    );

    return confirm ;
  }

  static void showDialogErro({required String message, required BuildContext context}){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thông Báo",
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ) ,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }, 
              child: const Text("OK",
                style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
              ) ,
            )
          ],
        );
      },
    );
  }
  
  static void showModuelBottonNewPlaylist(BuildContext context){
    String? name;
    showModalBottomSheet(
      backgroundColor: appColor.primaryColor,
      isScrollControlled: true,
      context: context, 
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: StatefulBuilder(
            builder:(context, setState) {
              return Column(
                children: [
                  const SizedBox(height: 20,),
                  const Center(
                    child: Text("Tạo playlist mới",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: appColor.darkGrey,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        autofocus: true,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          hintText: "Hãy nhập tên playlist",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16,),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      if(name != null){
                        PlayList playList = PlayList(title: name);
                        FirebaseRepo.addUserPlayList(playList: playList);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: name != null ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Text("Tạo PlayList",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ),
                  )
                ],
              );
            },
             
          ),
        );
      },
    );
  }
  
}