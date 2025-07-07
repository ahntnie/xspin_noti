class ProjectModel {
  String? idDuAn;
  String? tenDuAn;
  String? ngayTao;
  String? moTa;
  String? hinhLogo;
  String? maDuAn;

  ProjectModel({
    this.idDuAn,
    this.tenDuAn,
    this.ngayTao,
    this.moTa,
    this.hinhLogo,
    this.maDuAn,
  });
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      idDuAn: json['IdDuAn'] as String?,
      tenDuAn: json['TenDuAn'] as String?,
      ngayTao: json['NgayTao'] as String?,
      moTa: json['MoTa'] as String?,
      hinhLogo: json['HinhLogo'] as String?,
      maDuAn: json['MaDuAn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdDuAn': idDuAn,
      'TenDuAn': tenDuAn,
      'NgayTao': ngayTao,
      'MoTa': moTa,
      'HinhLogo': hinhLogo,
      'MaDuAn': maDuAn,
    };
  }
}
