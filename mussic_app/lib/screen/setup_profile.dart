import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/moduels/firebaseAuth/events/firebase_auth_event.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key, required this.numberPhone, required this.userID, required this.token});
  
  final String numberPhone;
  final String userID;
  final String token;

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  File? imageFromFile;

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80, width: double.infinity,),

          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  ontapCamera().then((file) => {
                    imageFromFile = file
                  });
                  
                },
                child: Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: imageFromFile == null ? BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                      image: AssetImage(appAsset.iconAvataUser),
                      fit: BoxFit.cover
                    )
                  ) : BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: FileImage(imageFromFile!),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 70,
                child: GestureDetector(
                  onTap: () {
                    ontapCamera().then((file) => {
                      imageFromFile = file
                    });
                  },
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 25,)
                  )
              )
            ],
          ),

          const SizedBox(height: 40,),

          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _textController,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Mời bạn nhập tên hiển thị";
                  }
                  return null;
                },
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  label: Text("Name", ),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  )
                ),
              ),
            ),
          ),

          const SizedBox(height: 40,),
          
          ElevatedButton(
            onPressed: () => ontapComfirm(),
            child: const Text("Xác Nhận",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            )
          )
        ],
      ),
    );
  }

  Future<File> ontapCamera() async {
    File? fileAvatar;
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        themeColor: Colors.blue
      ),
    );
    if (result != null && result.isNotEmpty) {
      fileAvatar = await result[0].file;
      setState(() {});
    }
    return fileAvatar!;
  }

  Future<void> ontapComfirm() async {
    if(_formKey.currentState!.validate()){
      if(imageFromFile != null){
        appDiaLog.ShowDialogLoading(context);
        await FirebaseRepo.putFileAvatar(file: imageFromFile!).then((url) => {
          appState.firebaseBloc.add(createUserEvent(userID: widget.userID, numberPhone: widget.numberPhone, name: _textController.text, avatar: url, token: widget.token))
        });
        appState.firebaseBloc.add(getCurrentUserProfileEvent());
        appState.authBloc.add(LoggedSuccess());
        Navigator.popUntil(context, (route) => route.isFirst);
      }else{
        appState.firebaseBloc.add(createUserEvent(userID: widget.userID, numberPhone: widget.numberPhone, name: _textController.text, avatar: appAsset.iconUser, token: widget.token));
        appState.firebaseBloc.add(getCurrentUserProfileEvent());
        appState.authBloc.add(LoggedSuccess());
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }
}



