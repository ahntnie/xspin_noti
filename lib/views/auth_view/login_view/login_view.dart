import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/view_models/auth/authen_viewModel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.prime100,
            body: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05,
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mono0,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(5, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Logo
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                      Image.asset(
                        'assets/images/img_panel.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                      // Login Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Đăng Nhập Hệ Thống',
                                  style: AppTheme.titleExtraLarge24.copyWith(
                                      color: AppColors.prime100,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                  'assets/images/img_send.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.095,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      // Email Field
                      TextField(
                        controller: viewModel.username,
                        decoration: InputDecoration(
                          hintText: 'Mã đăng nhập',
                          filled: true,
                          fillColor: AppColors.mono0,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Icon(
                                  Icons.key_rounded,
                                  color: AppColors.prime100,
                                )),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Password Field
                      TextField(
                        controller: viewModel.password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          filled: true,
                          fillColor: AppColors.mono0,
                          suffixIcon: Icon(
                            Icons.lock,
                            color: AppColors.prime100,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),

                      // Remember password and forget password

                      SizedBox(height: 50),
                      // Login and Register buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.isBusy
                                ? Center(
                                    child: LoadingAnimationWidget
                                        .threeRotatingDots(
                                      color: AppColors.prime100,
                                      size: 50,
                                    ),
                                  )
                                : viewModel.handleLogin(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          child: Text(
                            'Đăng nhập',
                            style: AppTheme.bodyLarge16.copyWith(
                                color: AppColors.mono0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
