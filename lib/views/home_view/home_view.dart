import 'package:flutter/material.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/views/group_view/group_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Danh sách mẫu cho các thông báo
  final List<String> notifications = [
    'XSPIN Đăng ký',
    'XSPIN Yêu cầu',
    'XSPIN Giao việc'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            'All Notifications',
            style: AppTheme.headLineLarge32.copyWith(
                color: AppColors.gradient100, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.mono20,
          elevation: 4,
          toolbarHeight: 80,
          titleSpacing: 30,
        ),
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(
              Icons.notifications,
              color: AppColors.prime100,
              size: 30,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notifications[index],
                  style: AppTheme.bodyLarge16.copyWith(
                    color: AppColors.gradient100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      '13:00',
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.mono40,
                      size: 15,
                    ),
                  ],
                )
              ],
            ),
            subtitle: Text(
              'Received: ${DateTime.now().toString().substring(0, 16)}',
              style: AppTheme.bodySmall12.copyWith(
                  // color: AppColors.mono50,
                  ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupView(
                            notification: notifications[index],
                          )));
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.mono40,
          indent: 16,
          endIndent: 16,
        ),
      ),
    );
  }
}
