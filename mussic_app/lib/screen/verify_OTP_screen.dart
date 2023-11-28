import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/moduels/firebaseAuth/events/firebase_auth_event.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key, required this.numberPhone});

  final String numberPhone;

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {

  String Pin1 = '';
  String Pin2 = '';
  String Pin3 = '';
  String Pin4 = '';
  String Pin5 = '';
  String Pin6 = '';
  String code = '';
  final _formKey =GlobalKey<FormState>();
  int start = 60;
  final _countdownCtl = StreamController();
  late final Timer? timer;
  

  @override
  void initState() {
    countDown();
    super.initState();
  }

  @override
  void dispose() {
    _countdownCtl.close();
    if(timer != null){
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () => appDiaLog.showDialogComfirmAndroid(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có chắc muốn thoát khỏi đăng nhập"),
        child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: containerBack(context)
                    ),
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
                    const Text('Xác Nhận Mã OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10,),
                    Text('Mã gồm 6 chữ số đã được gửi tới số ${widget.numberPhone}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 48,),
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor.LightGray),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  Pin1 = value;
                                });
                                if(value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                if(value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor.LightGray),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  Pin2 = value;
                                });
                                if(value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                if(value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor.LightGray),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  Pin3 = value;
                                });
                                if(value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                if(value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor.LightGray),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  Pin4 = value;
                                });
                                if(value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                if(value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor.LightGray),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  Pin5 = value;
                                });
                                if(value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                                if(value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor.LightGray),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                  Pin6 = value;
                                });
                                if(value.length == 1) {
                                  FocusScope.of(context).unfocus();
                                }
                                if(value.isEmpty) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20,),
                  StreamBuilder(
                    stream: _countdownCtl.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data == 0){
                          return GestureDetector(
                            onTap: (){
                              appState.authBloc.add(ReSendOTPSMSEvent(numberPhone: widget.numberPhone, context: context));
                              start = 60;
                              countDown();
                            },
                            child: const Text("Gửi lại Mã",
                              style: TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          );
                        }else{
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text("Gửi lại mã sau ",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text("${snapshot.data}s",
                                  style: const TextStyle(color: Colors.blue, fontSize: 14),
                                ),
        
                              ],
                            ) ,
                          );
                        }
                      }else{
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: const Text("Gửi lại mã",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ) ,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      String codeOTP = Pin1+Pin2+Pin3+Pin4+Pin5+Pin6;
                      if(codeOTP.length == 6){
                        if(start == 0){
                          appDiaLog.ToastNotifi(title: 'Mã OTP dã hết hạn');
                        }else{
                          appState.authBloc.add(VerifyOTPEvent(codeOTP: codeOTP , context: context));
                        }
                      }
                    },
                    child: Center(
                        child: Container(
                          height: 40,
                          width: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Pin1 == '' || Pin2 == '' || Pin3 == '' || Pin4 == '' || Pin5 == '' || Pin6 == '' ?const Color.fromARGB(255, 39, 39, 39): Colors.blue,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Text('Xác Nhận',
                            style: TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  void countDown(){
    timer =  Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
            if(start > 0){
              start--;
              _countdownCtl.sink.add(start);
            }else{
              timer.cancel();
              _countdownCtl.sink.add(0);
            }
          }
      );
  }
}
