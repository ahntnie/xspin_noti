import 'package:flutter/material.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/views/detail_view/detail_view.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key, required this.notification});
  final String notification;
  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  final List<String> requests = [
    'XSPIN - Yêu cầu gọi lại',
    'XSPIN - Yêu cầu gọi lại',
    'XSPIN - Yêu cầu gọi lại'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.mono60,
            ),
            onPressed: () {
              Navigator.pop(context); // Pop về trang trước
            },
          ),
          title: Text(
            widget.notification,
            style: AppTheme.headLineLarge32.copyWith(
              color: AppColors.gradient100,
            ),
          ),
          backgroundColor: AppColors.mono20,
          elevation: 4,
          toolbarHeight: 80,
          // titleSpacing: 30,
        ),
      ),
      body: ListView.separated(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(
              Icons.notifications,
              color: AppColors.prime100,
              size: 30,
            ),
           
            title: Text(
              requests[index],
              style: AppTheme.bodyLarge16.copyWith(
                color: AppColors.gradient100,
                fontWeight: FontWeight.bold,
              ),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DetailView()));
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
