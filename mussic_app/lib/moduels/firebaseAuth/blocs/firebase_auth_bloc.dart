import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/moduels/firebaseAuth/events/firebase_auth_event.dart';
import 'package:flutter/material.dart';
import 'package:mussic_app/moduels/firebaseAuth/repos/firebase_auth_repo.dart';
import 'package:mussic_app/screen/setup_profile.dart';
import 'package:mussic_app/screen/verify_OTP_screen.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState>{

  FirebaseAuth _auth = FirebaseAuth.instance;
  String verifiID = "";
  String numberPhone = '';


  FirebaseAuthBloc() : super(FirebaseAuthState()) {
    on((event, emit) async {
      if(event is SendOTPSMSEvent){
        bool isErroSendCode = false;
        numberPhone = event.numberPhone;
        appDiaLog.ShowDialogLoading(event.context);
        FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: event.numberPhone,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            isErroSendCode = true;
            print(e.code);
            Navigator.pop(event.context);
            if(e.code == "too-many-requests"){
              appDiaLog.showDialogNotify(content: "Bạn đã đăng nhập qua nhều lần, hãy thử lại sao", context: event.context);
            }

            if(e.code == "invalid-phone-number"){
              appDiaLog.showDialogNotify(content: "Số điện thoại không hợp lệ", context: event.context);
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            if(isErroSendCode == false){
              verifiID = verificationId;
              Navigator.pop(event.context);
              Navigator.push(event.context, MaterialPageRoute(builder: (context) => VerifyOTPScreen(numberPhone: event.numberPhone),));
            }
          },
          timeout: const Duration(seconds: 60), 
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
        
      }

      if(event is VerifyOTPEvent){
        appDiaLog.ShowDialogLoading(event.context);
        try{
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verifiID, smsCode: event.codeOTP);
          await _auth.signInWithCredential(credential);
          print("OTP Succes");
          if(await FirebaseAuthRepo.userExists(numberPhone)){
            await FirebaseRepo.getCurrentUserProfile();
            add(LoggedSuccess());
            Navigator.pop(event.context);
            Navigator.pop(event.context);
            Navigator.pop(event.context);
            Navigator.pop(event.context);
          }else{
            final String token = await appState.user!.getIdToken();
            Navigator.pop(event.context);
            Navigator.push(event.context, MaterialPageRoute(builder: (context) => SetupProfileScreen(numberPhone: numberPhone, userID: appState.user!.uid, token: token ),));
          }
        }on FirebaseAuthException catch(e){
          if(e.code == 'invalid-verification-code'){
            appDiaLog.ToastNotifi(title: 'Mã OTP không đúng, vui lòng nhập lại');
          }
          Navigator.pop(event.context);
          print('ERROR: '+e.toString());
          
        }
      }

      if(event is ReSendOTPSMSEvent){
        FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: event.numberPhone,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            print(e.code);
            if(e.code == "too-many-requests"){
              appDiaLog.showDialogNotify(content: "Bạn đã đăng nhập qua nhều lần, hãy thử lại sao", context: event.context);
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            verifiID = verificationId;
          },
          timeout: const Duration(seconds: 60), 
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }

      if(event is LoggedSuccess){
        emit(LoggedSuccessState());
      }

      if(event is LogoutEvent){
        if(await appDiaLog.showModalComfirm(context: event.context, tiltle: "Đăng Xuất", subTitle: "Bạn có chắc muốn đăng xuất tài khoản")){
          await _auth.signOut();
          emit(LogOutState());
        }
      }
    });
  }

}


class FirebaseAuthState{}

class LoadingState extends FirebaseAuthState{}
class SendedOTPState extends FirebaseAuthState{
  String verifyID;

  SendedOTPState({required this.verifyID});
}

class LoggedSuccessState extends FirebaseAuthState{}

class LogOutState extends FirebaseAuthState{}

