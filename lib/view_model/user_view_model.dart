import 'dart:core';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../repository/user_repository.dart';
import '../res/routes/routes_name.dart';
import '../services/shared_pref_service.dart';
import '../res/constants/toast_message.dart';

class UserViewModel with ChangeNotifier {
  bool _getUserLoading = false;

  bool? get getUserLoading => _getUserLoading;

  void setUserLoading(bool value) {
    _getUserLoading = value;
    notifyListeners();
  }

  bool _updateUserLoading = false;

  bool? get updateUserLoading => _updateUserLoading;

  void setUpdateUserLoading(bool value) {
    _updateUserLoading = value;
    notifyListeners();
  }

  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> getUserApi(BuildContext context) async {
    setUserLoading(true);
    try {
      final response = await UserRepository.getUser();
      if (response['data'] != null) {
        await SharedPrefService.savePref('user', response['data']);
      }
      setUser(User.fromJson(response));
      setUserLoading(false);
    } catch (e) {
      setUserLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
    }
  }

  /// EDIT REQUEST

  bool _editProfileLoading = false;

  bool get editProfileLoading => _editProfileLoading;

  void setEditProfileLoading(bool value) {
    _editProfileLoading = value;
    notifyListeners();
  }

  Future<void> editProfileApi(
    BuildContext context, {
    String? imagePath,
    String? name,
  }) async {
    setEditProfileLoading(true);
    try {
      await UserRepository.editProfile(
        imagePath: imagePath,
        name: name,
      );
      setEditProfileLoading(false);
      if (context.mounted) {
        await getUserApi(context);
      }
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          'Profile updated successfully.',
          ToastType.success,
        );
      }
    } catch (e) {
      setEditProfileLoading(false);
      if (context.mounted) {
        ToastMessage.cherryMessage(
          context,
          e.toString(),
          ToastType.error,
        );
      }
    }
  }

  bool _deleteProfileLoading = false;

  bool get deleteProfileLoading => _deleteProfileLoading;

  void setDeleteProfileLoading(bool value) {
    _deleteProfileLoading = value;
    notifyListeners();
  }

  Future<bool> deleteProfileApi(BuildContext context) async {
    setDeleteProfileLoading(true);
    try {
      final response = await UserRepository.deleteProfile();
      setDeleteProfileLoading(false);
      await SharedPrefService.clearPref('token');
      await SharedPrefService.clearPref('user');

      if (!context.mounted) return false;

      ToastMessage.cherryMessage(
        context,
        response['message'] ?? 'Account deleted successfully.',
        ToastType.success,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.signInScreen,
        (route) => false,
      );
      return true;
    } catch (e) {
      setDeleteProfileLoading(false);
      if (!context.mounted) return false;
      ToastMessage.cherryMessage(
        context,
        e.toString(),
        ToastType.error,
      );
      return false;
    }
  }
}
