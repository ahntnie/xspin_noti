import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/constants/app_api.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/views/auth_view/profile_view/profile_view.dart';
import 'package:xspin_noti/views/detail_view/detail_view.dart';
import 'package:xspin_noti/views/group_view/group_view.dart';

import '../../view_models/project/projectNoti_viewModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectViewmodel>.reactive(
        viewModelBuilder: () => ProjectViewmodel(),
        onViewModelReady: (viewModel) async {
          viewModel.viewContext = context;
          await viewModel.loadProjectData();
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.mono0,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: AppBar(
                title: Text(
                  'Tất cả thông báo',
                  style: AppTheme.headLineLarge32.copyWith(
                    color: AppColors.mono0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: AppColors.prime100,
                elevation: 4,
                toolbarHeight: 80,
                titleSpacing: 30,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: AppColors.mono0,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileView()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    // await viewModel.loadLstNoti('');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupView(
                                projectViewModel: viewModel, id: '')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/icon_app_tron.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Tất cả thông báo',
                              style: AppTheme.bodyHuge20.copyWith(
                                color: AppColors.gradient100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.mono40,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.loadProjectData,
                    child: viewModel.isBusy
                        ? Center(
                            child: LoadingAnimationWidget.threeRotatingDots(
                              color: AppColors.prime100,
                              size: 50,
                            ),
                          )
                        : viewModel.projectsModel!.isEmpty
                            ? const Center(
                                child: Text('Không có thông báo nào!'))
                            : ListView.separated(
                                itemCount: viewModel.projectsModel!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Image.network(
                                      viewModel.projectsModel![index]
                                              .hinhLogo! ??
                                          '${Api.hostImage}viewModel.projectsModel![index].hinhLogo!',
                                      width: 40,
                                      height: 40,
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          viewModel.projectsModel![index]
                                                  .tenDuAn ??
                                              '',
                                          style: AppTheme.bodyLarge16.copyWith(
                                            color: AppColors.gradient100,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              viewModel.projectsModel![index]
                                                  .ngayTao!
                                                  .split(' ')[1],
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              color: AppColors.mono40,
                                              size: 15,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${viewModel.projectsModel![index].ngayTao ?? ''}',
                                      style: AppTheme.bodySmall12.copyWith(),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    onTap: () async {
                                      await viewModel.loadProjectDataByID(
                                          viewModel.projectsModel![index]
                                                  .idDuAn ??
                                              '');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GroupView(
                                                  projectViewModel: viewModel,
                                                  id: viewModel
                                                          .projectsModel![index]
                                                          .idDuAn ??
                                                      '')));
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.mono40,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                              ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
