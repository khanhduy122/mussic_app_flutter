import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/moduels/firebaseAuth/blocs/firebase_auth_bloc.dart';
import 'package:mussic_app/screen/login_with_numberphone.screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 24, left: 24),
                child: containerBack(context)),
            const SizedBox(
              height: 100,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                appAsset.iconHeadPhoneBigSize,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            BlocProvider<FirebaseAuthBloc>(
              create: (context) => FirebaseAuthBloc(),
              child: optionLogin(
                icon: appAsset.iconSmartphone, 
                tiltle: 'Sử dụng số điện thoại',
                ontap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const loginWithNumberPhone(),));
                }
              ),
            ),
            optionLogin(
              icon: appAsset.iconFacebook, 
              tiltle: 'Tiếp tục với Facebook', 
              ontap: (){

              }
            ),
            optionLogin(
              icon: appAsset.iconGoogle,
              tiltle: 'Tiếp tục với google',
              ontap: (){

              }
            ),
            optionLogin(
              icon: appAsset.iconApple, 
              tiltle: 'Tiếp tục với Apple',
              ontap: (){

              }
            ),
          ],
        ),
      ),
    );
  }
}

Widget optionLogin({required Function() ontap, required String icon, required String tiltle, }) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          color: appColor.darkGrey, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Image.asset(icon),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              tiltle,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ))
        ],
      ),
    ),
  );
}
