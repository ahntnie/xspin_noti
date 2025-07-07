class NotiModel {
  final String? idDuAn;
  final String? tieuDe;
  final String? noiDung;
  final String? ngayTao;
  final String? hinhAnh;

  NotiModel({
    this.idDuAn,
    this.tieuDe,
    this.noiDung,
    this.ngayTao,
    this.hinhAnh,
  });

  // Factory constructor để parse từ JSON
  factory NotiModel.fromJson(Map<String, dynamic> json) {
    return NotiModel(
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
      'IdDuAn': idDuAn,
      'TieuDe': tieuDe,
      'NoiDung': noiDung,
      'NgayTao': ngayTao,
      'HinhAnh': hinhAnh,
    };
  }
}
