import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/models/project.model.dart';
import 'package:xspin_noti/models/user.model.dart';
import 'package:xspin_noti/requests/login_request.dart';
import 'package:xspin_noti/requests/project_request.dart';
import 'package:xspin_noti/views/auth_view/login_view/login_view.dart';

class ProjectViewmodel extends BaseViewModel {
  List<ProjectModel>? projectsModel;
  List<ProjectModel>? projectsModelByID;

  late BuildContext viewContext;
  ProjectRequest projectRequest = ProjectRequest();
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
    setBusy(true);
    projectsModelByID = await projectRequest.handleLoadProjectByID(
        idThanhVien: AppSP.get(AppSPKey.idUser), idDuAn: idDuAn);
    print(projectsModelByID!.length);
    setBusy(false);
    notifyListeners();
  }
}
