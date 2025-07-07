import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/models/project.model.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/view_models/project/project_viewModel.dart';

class DetailView extends StatefulWidget {
  const DetailView(
      {super.key, required this.projectModel, required this.projectViewModel});
  final ProjectModel projectModel;
  final ProjectViewmodel projectViewModel;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.projectViewModel,
        onViewModelReady: (viewModel) async {
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.mono0,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: AppBar(
                title: Text(
                  widget.projectModel.tenDuAn ?? '',
                  style: AppTheme.headLineLarge32.copyWith(
                    color: AppColors.gradient100,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
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
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        widget.projectModel.hinhLogo!,
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.projectModel.tenDuAn ?? '',
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: AppTheme.titleLarge20,
                            ),
                            Text(
                              'Từ ${widget.projectModel.tenDuAn} ngày ${widget.projectModel.ngayTao}',
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
                    widget.projectModel.moTa ?? 'Chưa có mô tả nào',
                    style: AppTheme.bodyMedium14.copyWith(
                      color: AppColors.mono100,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy_all),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.ios_share_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
