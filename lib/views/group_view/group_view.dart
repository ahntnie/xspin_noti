import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/models/project.model.dart';
import 'package:xspin_noti/utils/colors/app_color.dart';
import 'package:xspin_noti/utils/colors/app_theme.dart';
import 'package:xspin_noti/view_models/project/project_viewModel.dart';
import 'package:xspin_noti/views/detail_view/detail_view.dart';

class GroupView extends StatefulWidget {
  const GroupView(
      {super.key, required this.projectModel, required this.projectViewModel});
  final ProjectModel projectModel;
  final ProjectViewmodel projectViewModel;
  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.projectViewModel.viewContext = context;
      await widget.projectViewModel
          .loadProjectDataByID(widget.projectModel.idDuAn!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.projectViewModel,
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors.mono0,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.gradient100,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.projectModel.tenDuAn ?? '',
                style: AppTheme.headLineLarge32.copyWith(
                  color: AppColors.gradient100,
                ),
              ),
              backgroundColor: AppColors.mono0,
              elevation: 4,
              toolbarHeight: 80,
            ),
          ),
          body: widget.projectViewModel.isBusy
              ? Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.prime100,
                    size: 50,
                  ),
                )
              : widget.projectViewModel.projectsModelByID == null ||
                      widget.projectViewModel.projectsModelByID!.isEmpty
                  ? const Center(child: Text('Không có dữ liệu'))
                  : ListView.separated(
                      itemCount:
                          widget.projectViewModel.projectsModelByID!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            widget.projectViewModel.projectsModel![index]
                                .hinhLogo!,
                            width: 40,
                            height: 40,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.projectViewModel
                                        .projectsModelByID![index].tenDuAn ??
                                    '',
                                style: AppTheme.bodyLarge16.copyWith(
                                  color: AppColors.gradient100,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.projectViewModel
                                        .projectsModelByID![index].ngayTao!
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
                            '${widget.projectViewModel.projectsModelByID![index].ngayTao ?? ''}',
                            style: AppTheme.bodySmall12.copyWith(
                                // color: AppColors.mono50,
                                ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailView(
                                        projectViewModel: viewModel,
                                        projectModel: viewModel
                                            .projectsModelByID![index])));
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
      },
    );
  }
}
