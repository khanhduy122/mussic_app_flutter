
import 'package:flutter/material.dart';

abstract class FirebaseAuthEvent{}

class SendOTPSMSEvent extends FirebaseAuthEvent{
  String numberPhone;
  BuildContext context;

  SendOTPSMSEvent({required this.numberPhone, required this.context});
}

class ReSendOTPSMSEvent extends FirebaseAuthEvent{
  String numberPhone;
  BuildContext context;

  ReSendOTPSMSEvent({required this.numberPhone, required this.context});
}

class LogoutEvent extends FirebaseAuthEvent{
  BuildContext context;

  LogoutEvent({required this.context});
}

class VerifyOTPEvent extends FirebaseAuthEvent{
  String codeOTP;
  BuildContext context;

  VerifyOTPEvent({required this.codeOTP, required this.context,});
}

class LoggedSuccess extends FirebaseAuthEvent {}
