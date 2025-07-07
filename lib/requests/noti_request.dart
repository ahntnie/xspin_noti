import 'package:dio/dio.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/constants/app_api.dart';
import 'package:xspin_noti/models/noti.model.dart';
import 'package:xspin_noti/models/project.model.dart';
// import 'package:xspin_noti/models/user.model.dart';
import 'package:xspin_noti/services/api.services.dart';

class NotiRequest {
  final Dio dio = Dio();
  Future<List<NotiModel>?> handleLoadNoti(
      {required String idThanhVien, required String idDuAn}) async {
    final Map<String, dynamic> body = {
      "idThanhVien": idThanhVien,
      "IdDuAn": idDuAn
    };
    List<NotiModel> lstNoti = [];
    final response = await ApiService().postRequest(
        '${Api.hostApi}${Api.getListNoti}',
        queryParameters: body,
        customHeaders: {'Tokenquantri': AppSP.get(AppSPKey.tokenHeader)});
    if (response.statusCode == 200) {
      List<dynamic>? data = response.data;

      if (response.data is List) {
        lstNoti = data!.map((json) => NotiModel.fromJson(json)).toList();

        return lstNoti;
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
