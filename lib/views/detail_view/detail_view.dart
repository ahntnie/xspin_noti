import 'package:flutter/material.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            'Group 1',
            style: AppTheme.headLineLarge32.copyWith(
              color: AppColors.gradient100,
            ),
          ),
          backgroundColor: AppColors.mono20,
          elevation: 4,
          toolbarHeight: 80,
          titleSpacing: 30,
        ),
      ),
      body: const Center(child: Text('Welcome to Home!')),
    );
  }
}
