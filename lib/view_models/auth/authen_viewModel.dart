import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:stacked/stacked.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/models/user.model.dart';
import 'package:xspin_noti/requests/login_request.dart';
import 'package:xspin_noti/services/api.services.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/views/home_view/home_view.dart';

class LoginViewModel extends BaseViewModel {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  late BuildContext viewContext;

  LoginRequest loginRequest = LoginRequest();
  UserModel? data;
  late UserModel responseLogin;
  LoginViewModel() {
    _loadUserData();
  }

  Future<void> handleLogin(BuildContext context) async {
    setBusy(true);
    final firebaseMessaging = FirebaseMessaging.instance;
    String? token;
    token = await firebaseMessaging.getToken();
    print('token: $token');
    AppSP.set(AppSPKey.token, token);
    data = await loginRequest.handleLogin(
        maDangNhap: username.text, matKhau: password.text);
    if (data != null) {
      await _saveUserToSharedPreferences(data!);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (Route<dynamic> route) => false,
      );
    } else {
      showSignInFailedDialog(
          context, 'Tên đăng nhập hoặc mật khẩu không chính xác!');
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    setBusy(true);
    try {
      final userJson = await AppSP.get(AppSPKey.userInfo);
      if (userJson != null) {
        data = UserModel.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> _saveUserToSharedPreferences(UserModel user) async {
    final userInfo = jsonEncode(user.toJson()); // Chuyển UserModel thành JSON
    await AppSP.set(AppSPKey.userInfo, userInfo);
  }

  void showSignInFailedDialog(BuildContext context, String desc) {
    AwesomeDialog(
      context: viewContext,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Đăng nhập thất bại',
      desc: desc,
      btnOkColor: AppColors.prime100,
      btnOkOnPress: () {},
      btnOkText: 'Thử lại',
    ).show();
  }
}
