import 'package:dio/dio.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/constants/app_api.dart';
import 'package:xspin_noti/models/project.model.dart';
// import 'package:xspin_noti/models/user.model.dart';
import 'package:xspin_noti/services/api.services.dart';

class ProjectRequest {
  final Dio dio = Dio();
  Future<List<ProjectModel>?> handleLoadProject(
      {required String idThanhVien}) async {
    final Map<String, dynamic> body = {
      "idThanhVien": idThanhVien,
    };
    List<ProjectModel> lstProject = [];
    final response = await ApiService().postRequest(
        '${Api.hostApi}${Api.getListProject}',
        queryParameters: body,
        customHeaders: {'Tokenquantri': AppSP.get(AppSPKey.tokenHeader)});
    if (response.statusCode == 200) {
      List<dynamic>? data = response.data;

      if (response.data is List) {
        lstProject = data!.map((json) => ProjectModel.fromJson(json)).toList();

        return lstProject;
      } else {
        print('Không nhận được dữ liệu');
        return null;
      }
    } else {
      print('Đăng nhập thất bại: Mã trạng thái ${response.statusCode}');
      return null;
    }
  }

  Future<ProjectModel?> handleLoadProjectByID(
      {required String idThanhVien, required String idDuAn}) async {
    final Map<String, dynamic> body = {
      "idThanhVien": idThanhVien,
      "IdDuAn": idDuAn
    };
    final response = await ApiService().postRequest(
        '${Api.hostApi}${Api.getProject}',
        queryParameters: body,
        customHeaders: {'Tokenquantri': AppSP.get(AppSPKey.tokenHeader)});
    if (response.statusCode == 200) {
      final data = response.data;
      print('data ${data}');
      if (data != null) {
        final status = data['Status'];
        if (status == 0) {
          print('${data}');
          print('Faild');
          return null;
        } else {
          final projectModel = ProjectModel.fromJson(data);

          return projectModel;
        }
      } else {
        print('Không nhận được dữ liệu');
        return null;
      }
    } else {
      print('Đăng nhập thất bại: Mã trạng thái ${response.statusCode}');
      return null;
    }
  }
}
