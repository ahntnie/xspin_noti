import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/models/noti.model.dart';
import 'package:xspin_noti/models/project.model.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/view_models/project/projectNoti_viewModel.dart';

class DetailView extends StatefulWidget {
  const DetailView({
    super.key,
    required this.idPush,
    required this.notiModel,
  });
  final String idPush;
  final NotiModel notiModel;
  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mono0,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            widget.notiModel.tenDuAn ?? '',
            style: AppTheme.headLineLarge32.copyWith(
              color: AppColors.mono0,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.mono0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppColors.prime100,
          elevation: 4,
          toolbarHeight: 80,
          titleSpacing: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  widget.notiModel.hinhLogo ?? '',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notiModel.tieuDe ?? '',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: AppTheme.titleLarge20,
                      ),
                      Text(
                        'Từ ngày ${widget.notiModel.ngayTao}',
                        style: AppTheme.bodyMedium14.copyWith(
                          color: AppColors.mono100,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.notiModel.noiDung ?? 'Chưa có mô tả nào',
              style: AppTheme.bodyMedium14.copyWith(
                color: AppColors.mono100,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
