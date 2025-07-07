class UserModel {
  String? idThanhVien;
  String? hoTen;
  String? soDienThoai;
  String? email;
  String? ngayTao;
  String? tokenNoti;
  String? tokenQuantri;

  UserModel({
    this.idThanhVien,
    this.hoTen,
    this.soDienThoai,
    this.email,
    this.ngayTao,
    this.tokenNoti,
    this.tokenQuantri,
  });

  // Chuyển từ JSON sang đối tượng UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idThanhVien: json['IdThanhVien'] as String?,
      hoTen: json['HoTen'] as String?,
      soDienThoai: json['SoDienThoai'] as String?,
      email: json['Email'] as String?,
      ngayTao: json['NgayTao'] as String?,
      tokenNoti: json['Tokennoti'] as String?,
      tokenQuantri: json['Tokenquantri'] as String?,
    );
  }

  // Chuyển từ đối tượng UserModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'IdThanhVien': idThanhVien,
      'HoTen': hoTen,
      'SoDienThoai': soDienThoai,
      'Email': email,
      'NgayTao': ngayTao,
      'Tokennoti': tokenNoti,
      'Tokenquantri': tokenQuantri,
    };
  }
}