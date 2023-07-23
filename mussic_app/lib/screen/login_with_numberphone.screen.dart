import 'package:flutter/material.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/moduels/firebaseAuth/events/firebase_auth_event.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';

class loginWithNumberPhone extends StatefulWidget {
  const loginWithNumberPhone({super.key});

  @override
  State<loginWithNumberPhone> createState() => _loginWithNumberPhoneState();
}

class _loginWithNumberPhoneState extends State<loginWithNumberPhone> {

  String? numberPhone;
  String verifyID = '';
  
  @override
  Widget build(BuildContext context) {

    Size size =MediaQuery.of(context).size;

    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 24,),
                      child: containerBack(context)),
                  
                  Container(
                      height: size.height/3,
                      width: size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(appAsset.imgLogin),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    const SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Nhập số điện thoại của bạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Chung tôi sẽ gữi mã OTP gồm 6 chữ số đến máy của bạn',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: appColor.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: const Text(
                            '+84 ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Text(
                          ' |  ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                numberPhone = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Số Điện Thoại',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                counterText: ''),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            maxLength: 10,
                            cursorColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if((numberPhone == null)){
                        return;
                      }else{
                        if(numberPhone!.isEmpty){
                          return;
                        }
    
                        if(numberPhone!.length < 10){
                          return;
                        }else{
                          if(numberPhone![0] == "0"){
                            numberPhone = "+84" + numberPhone!.substring(1);
                          }else{
                            numberPhone = "+84" + numberPhone!.substring(1);
                          }
                          print(numberPhone!);
                          appState.authBloc.add(SendOTPSMSEvent(numberPhone: numberPhone!, context: context));
                        }
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: numberPhone == null ? const Color.fromARGB(255, 39, 39, 39) : appColor.blue,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Text('Gửi Mã',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
}
