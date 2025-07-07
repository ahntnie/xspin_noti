import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/models/user.model.dart';
import 'package:xspin_noti/requests/login_request.dart';
import 'package:xspin_noti/views/auth_view/login_view/login_view.dart';

class PersonalInfoViewModel extends BaseViewModel {
  UserModel? user;
  late BuildContext viewContext;
  LoginRequest loginRequest = LoginRequest();
  PersonalInfoViewModel() {
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    setBusy(true);
    try {
      final userJson = await AppSP.get(AppSPKey.userInfo);
      if (userJson != null) {
        user = UserModel.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
    setBusy(false);
    notifyListeners();
  }

  // Xử lý đăng xuất
  Future<void> handleLogout(BuildContext context) async {
    DateTime now = DateTime.now(); // This should work fine
    String formattedDateTime = DateFormat('yyyyMMdd_HHmmss').format(now);
    String tokenNoti = "chuoidangxuatXEP" + formattedDateTime;
    user = await loginRequest.handleLogout(
        IdThanhVien: AppSP.get(AppSPKey.idUser), Tokennoti: tokenNoti);
    setBusy(true);
    await AppSP.remove(AppSPKey.userInfo);
    await AppSP.remove(AppSPKey.tokenHeader);
    await AppSP.remove(AppSPKey.idUser);
    // await AppSP.remove(AppSPKey.token);
    user = null;
    setBusy(false);
    notifyListeners();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (Route<dynamic> route) => false,
    );
  }
}
