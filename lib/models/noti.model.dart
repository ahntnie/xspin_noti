class NotiModel {
  final String? idPush;
  final String? idDuAn;
  final String? tenDuAn;
  final String? hinhLogo;
  final String? tieuDe;
  final String? noiDung;
  final String? ngayTao;
  final String? hinhAnh;

  NotiModel({
    this.idPush,
    this.tenDuAn,
    this.hinhLogo,
    this.idDuAn,
    this.tieuDe,
    this.noiDung,
    this.ngayTao,
    this.hinhAnh,
  });

  // Factory constructor để parse từ JSON
  factory NotiModel.fromJson(Map<String, dynamic> json) {
    return NotiModel(
      idPush: json['IdPush'] as String?,
      tenDuAn: json['TenDuAn'] as String?,
      hinhLogo: json['HinhLogo'] as String?,
      idDuAn: json['IdDuAn'] as String?,
      tieuDe: json['TieuDe'] as String?,
      noiDung: json['NoiDung'] as String?,
      ngayTao: json['NgayTao'] as String?,
      hinhAnh: json['HinhAnh'] as String?,
    );
  }

  // Chuyển model về JSON (nếu cần)
  Map<String, dynamic> toJson() {
    return {
      'IdPush': idPush,
      'TenDuAn': tenDuAn,
      'HinhLogo': hinhLogo,
      'IdDuAn': idDuAn,
      'TieuDe': tieuDe,
      'NoiDung': noiDung,
      'NgayTao': ngayTao,
      'HinhAnh': hinhAnh,
    };
  }
}
