import 'package:dio/dio.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/constants/app_api.dart';
import 'package:xspin_noti/models/user.model.dart';
import 'package:xspin_noti/services/api.services.dart';

class LoginRequest {
  final Dio dio = Dio();
  Future<UserModel?> handleLogin({
    required String maDangNhap,
    required String matKhau,
  }) async {
    final Map<String, dynamic> body = {
      "MaDangNhap": maDangNhap,
      "MatKhau": matKhau,
      "Tokennoti": AppSP.get(AppSPKey.token)
    };
    final response = await ApiService().postRequest(
      '${Api.hostApi}${Api.login}',
      queryParameters: body,
    );
    AppSP.set(AppSPKey.tokenHeader, response.data['Tokenquantri']);
    AppSP.set(AppSPKey.idUser, response.data['IdThanhVien']);
    if (response.statusCode == 200) {
      final data = response.data;

      if (data != null) {
        final status = data['Status'];

        if (status == 0) {
          print('${data}');
          print(
              'Login failed: Tài khoản không tồn tại hoặc thông tin đăng nhập không chính xác');
          return null;
        } else {
          final userModel = UserModel.fromJson(data);

          return userModel;
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

  Future<UserModel?> handleLogout({
    required String IdThanhVien,
    required String Tokennoti,
  }) async {
    final Map<String, dynamic> body = {
      "IdThanhVien": IdThanhVien,
      "Tokennoti": Tokennoti,
      // "Tokennoti": AppSP.get(AppSPKey.token)
    };
    final response = await ApiService().postRequest(
      '${Api.hostApi}${Api.updateToken}',
      queryParameters: body,
    );

    if (response.statusCode == 200) {
      final data = response.data;

      if (data != null) {
        final status = data['Status'];

        if (status == 0) {
          // print('${data}');
          print('Đăng xuất thành công');
          return null;
        } else {
          final userModel = UserModel.fromJson(data);

          return userModel;
        }
      } else {
        print('Không nhận được dữ liệu');
        return null;
      }
    } else {
      print('Đăng xuất thất bại: Mã trạng thái ${response.statusCode}');
      return null;
    }
  }
}
