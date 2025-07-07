import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/view_models/auth/authen_viewModel.dart';
import 'package:xspin_noti/view_models/auth/profile_viewModel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PersonalInfoViewModel>.reactive(
        viewModelBuilder: () => PersonalInfoViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.mono0,
            appBar: AppBar(
              title: Text(
                'Thông tin',
                style: AppTheme.headLineLarge32.copyWith(
                  color: AppColors.gradient100,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  // color: AppColors.mono0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: AppColors.mono0,
              elevation: 4,
              toolbarHeight: 80,
              titleSpacing: 30,
            ),
            body: viewModel.isBusy
                ? Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppColors.prime100,
                      size: 50,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Thông tin cá nhân', style: AppTheme.titleExtraLarge24),
                        const SizedBox(height: 16),
                        _buildInfoField(
                            'Họ tên', viewModel.user?.hoTen ?? 'N/A'),
                        _buildInfoField(
                            'Email', viewModel.user?.email ?? 'N/A'),
                        _buildInfoField(
                            'Ngày tạo', viewModel.user?.ngayTao ?? 'N/A'),
                        _buildInfoField('Số điện thoại',
                            viewModel.user?.soDienThoai ?? 'N/A'),
                        // _buildInfoField(
                        //     'Token', viewModel.user?.tokenNoti ?? 'N/A'),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.handleLogout(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.prime100, // Màu nút
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Đăng xuất',
                                style: AppTheme.bodyExtraLarge18.copyWith(
                                    color: AppColors.mono0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  // Widget để hiển thị một trường thông tin
  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.bodyLarge16),
          const SizedBox(height: 4),
          Text(value, style: AppTheme.bodyExtraLarge18),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
