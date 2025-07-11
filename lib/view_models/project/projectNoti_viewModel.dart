import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/models/noti.model.dart';
import 'package:xspin_noti/models/project.model.dart';
import 'package:xspin_noti/models/user.model.dart';
import 'package:xspin_noti/requests/login_request.dart';
import 'package:xspin_noti/requests/noti_request.dart';
import 'package:xspin_noti/requests/project_request.dart';
import 'package:xspin_noti/views/auth_view/login_view/login_view.dart';

class ProjectViewmodel extends BaseViewModel {
  List<ProjectModel>? projectsModel;
  ProjectModel? projectsModelByID;
  List<NotiModel>? notiModel;
  ProjectModel? currentProject;
  NotiModel? currentNoti;
  NotiModel? detailNoti;
  late BuildContext viewContext;
  ProjectRequest projectRequest = ProjectRequest();
  NotiRequest notiRequest = NotiRequest();
  // ProjectViewmodel() {
  //   loadProjectData();
  // }
  Future<void> loadProjectData() async {
    setBusy(true);
    projectsModel = await projectRequest.handleLoadProject(
        idThanhVien: AppSP.get(AppSPKey.idUser));
    print(projectsModel!.length);
    setBusy(false);
    notifyListeners();
  }

  Future<void> loadProjectDataByID(String idDuAn) async {
    projectsModelByID = await projectRequest.handleLoadProjectByID(
        idThanhVien: AppSP.get(AppSPKey.idUser), idDuAn: idDuAn);
  }

  Future<void> loadLstNoti(String idDuAn) async {
    setBusy(true);
    notiModel = await notiRequest.handleLoadNoti(
        idThanhVien: AppSP.get(AppSPKey.idUser), idDuAn: idDuAn);
    print('notiModel!.length: ${notiModel!.length}');
    setBusy(false);
    notifyListeners();
  }

  Future<void> loadDetailNoti(String? idPush) async {
    // setBusy(true);
    detailNoti = await notiRequest.handleGetDetailNoti(
        IdThanhVien: AppSP.get(AppSPKey.idUser), IdPush: idPush!);
    print('Ten noti: ${detailNoti!.noiDung}}');
    // setBusy(false);
    // notifyListeners();
  }
}
