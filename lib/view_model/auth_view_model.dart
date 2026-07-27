import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../res/constants/toast_message.dart';

import '../repository/auth_repository.dart';
import '../services/notification_service.dart';
import '../services/shared_pref_service.dart';
import '../res/routes/routes_name.dart';
import '../view/verification_view/verification_screen.dart';
import 'user_view_model.dart';

class AuthViewModel with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  String? verificationId;

  /// SIGN-IN REQUEST
  bool _loginLoading = false;

  bool get loginLoading => _loginLoading;

  void setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  Future<void> signInApi(String number, context) async {
    setLoginLoading(true);
    try {
      // In BiteEx they called checkUser, but for Rider we go straight to Firebase verifyPhoneNumber
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$number',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setLoginLoading(false);
          ToastMessage.cherryMessage(
            context,
            e.message.toString(),
            ToastType.error,
          );
        },
        codeSent: (String vId, int? resendToken) async {
          try {
            verificationId = vId;
            final fcmToken = await _notificationService.getToken();
            await AuthRepository.signIn(
              number: number,
              fcmToken: fcmToken,
            );
            setLoginLoading(false);
            ToastMessage.cherryMessage(
              context,
              'OTP sent successfully.',
              ToastType.success,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(mobile: number),
              ),
            );
          } catch (e) {
            setLoginLoading(false);
            ToastMessage.cherryMessage(
              context,
              e.toString(),
              ToastType.error,
            );
          }
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId = vId;
        },
      );
    } catch (e) {
      setLoginLoading(false);
      ToastMessage.cherryMessage(
        context,
        e.toString(),
        ToastType.error,
      );
    }
  }

  /// RE-SEND REQUEST
  bool _resendLoading = false;

  bool get resendLoading => _resendLoading;

  void setResendLoading(bool value) {
    _resendLoading = value;
    notifyListeners();
  }

  Future<void> resendApi(String number, context) async {
    setResendLoading(true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$number',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setResendLoading(false);
          ToastMessage.cherryMessage(
            context,
            e.message.toString(),
            ToastType.error,
          );
        },
        codeSent: (String vId, int? resendToken) async {
          try {
            verificationId = vId;
            final fcmToken = await _notificationService.getToken();
            await AuthRepository.signIn(
              number: number,
              fcmToken: fcmToken,
            );
            setResendLoading(false);
            ToastMessage.cherryMessage(
              context,
              'OTP sent successfully.',
              ToastType.success,
            );
          } catch (e) {
            setResendLoading(false);
            ToastMessage.cherryMessage(
              context,
              e.toString(),
              ToastType.error,
            );
          }
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId = vId;
        },
      );
    } catch (e) {
      setResendLoading(false);
      ToastMessage.cherryMessage(
        context,
        e.toString(),
        ToastType.error,
      );
    }
  }

  /// VERIFY REQUEST
  bool _verifyLoading = false;

  bool get verifyLoading => _verifyLoading;

  void setVerifyLoading(bool value) {
    _verifyLoading = value;
    notifyListeners();
  }

  Future<void> verifyApi(String number, String otp, context) async {
    setVerifyLoading(true);
    try {
      if (verificationId != null) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otp,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final response = await AuthRepository.verification(
        number: number,
        otp: '1111',
      );
      setVerifyLoading(false);
      ToastMessage.cherryMessage(
        context,
        'OTP verified successfully.',
        ToastType.success,
      );

      if (response['token'] != null) {
        final userViewModel = Provider.of<UserViewModel>(
          context,
          listen: false,
        );
        SharedPrefService.savePref('token', response['token']);
        await userViewModel.getUserApi(context);
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.bottomNavigationBarScreen,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setVerifyLoading(false);
      ToastMessage.cherryMessage(
        context,
        e.message ?? 'Invalid OTP',
        ToastType.error,
      );
    } catch (e) {
      setVerifyLoading(false);
      ToastMessage.cherryMessage(
        context,
        e.toString(),
        ToastType.error,
      );
    }
  }

  /// LOGOUT
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await SharedPrefService.clearPref('token');
      await SharedPrefService.clearPref('user');

      if (context.mounted) {
        final userViewModel = Provider.of<UserViewModel>(
          context,
          listen: false,
        );
        userViewModel.setUser(null);

        ToastMessage.cherryMessage(
          context,
          'Logged out successfully.',
          ToastType.success,
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.signInScreen,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
    }
  }
}
