import 'package:flutter/material.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {

  final TextEditingController _editingController = TextEditingController(text: appState.userProfile!.name ?? "");
  final GlobalKey _formKey = GlobalKey<FormState>();
  // String textName = appState.userProfile!.name ?? "";

  @override
  void dispose() {
    // TODO: implement dispose
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        leading: containerBack(context),
        title: const Text("Tên Của Bạn",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40,),
            Form(
              key: _formKey,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: appColor.darkGrey,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: _editingController,
                          onChanged: (value){
                            setState(() {
                            });
                          },
                          maxLength: 30,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                    _editingController.text != '' ? GestureDetector(
                      onTap: (){
                        setState(() {
                          _editingController.text = '';
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Image.asset(appAsset.iconClose, color: Colors.grey,)
                      ),
                    ) : Container()
                  ],
                ),
              )
            ),
            const SizedBox(height: 10,),
            Text("${_editingController.text.length}" + "/30",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),

            Center(
              child: GestureDetector(
                onTap: (){
                  if(_editingController.text != '' || _editingController.text != appState.userProfile!.name!){
                    appState.firebaseBloc.add(updateNameUserEvent(name: _editingController.text, context: context));
                  }
                },
                child: Container(
                  height: 40,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _editingController.text == '' || _editingController.text == appState.userProfile!.name! ? appColor.darkGrey : Colors.blue,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Text("Cập Nhật",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}