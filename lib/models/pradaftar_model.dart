class PraDaftar {
  List<Aktor> aktor;
  List<Grup> grup;
  List<Komunitas> komunitas;

  PraDaftar({this.aktor, this.grup, this.komunitas});

  PraDaftar.fromJson(Map<String, dynamic> json) {
    if (json['aktor'] != null) {
      aktor = new List<Aktor>();
      json['aktor'].forEach((v) {
        aktor.add(new Aktor.fromJson(v));
      });
    }
    if (json['grup'] != null) {
      grup = new List<Grup>();
      json['grup'].forEach((v) {
        grup.add(new Grup.fromJson(v));
      });
    }
    if (json['komunitas'] != null) {
      komunitas = new List<Komunitas>();
      json['komunitas'].forEach((v) {
        komunitas.add(new Komunitas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aktor != null) {
      data['aktor'] = this.aktor.map((v) => v.toJson()).toList();
    }
    if (this.grup != null) {
      data['grup'] = this.grup.map((v) => v.toJson()).toList();
    }
    if (this.komunitas != null) {
      data['komunitas'] = this.komunitas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Aktor {
  int id;
  String jenis;

  Aktor({this.id, this.jenis});

  Aktor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jenis = json['jenis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jenis'] = this.jenis;
    return data;
  }
}

class Grup {
  int id;
  String jenis;
  String deskripsi;
  Null deletedAt;

  Grup({this.id, this.jenis, this.deskripsi, this.deletedAt});

  Grup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jenis = json['jenis'];
    deskripsi = json['deskripsi'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['jenis'] = this.jenis;
    data['deskripsi'] = this.deskripsi;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Komunitas {
  int id;
  String namaKomunitas;
  String telepon;
  int rekening;
  String alamat;
  String lembagaJenis;
  String pengisiId;
  String createdAt;
  Null updatedAt;

  Komunitas(
      {this.id,
      this.namaKomunitas,
      this.telepon,
      this.rekening,
      this.alamat,
      this.lembagaJenis,
      this.pengisiId,
      this.createdAt,
      this.updatedAt});

  Komunitas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaKomunitas = json['nama_komunitas'];
    telepon = json['telepon'];
    rekening = json['rekening'];
    alamat = json['alamat'];
    lembagaJenis = json['lembaga_jenis'];
    pengisiId = json['pengisi_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_komunitas'] = this.namaKomunitas;
    data['telepon'] = this.telepon;
    data['rekening'] = this.rekening;
    data['alamat'] = this.alamat;
    data['lembaga_jenis'] = this.lembagaJenis;
    data['pengisi_id'] = this.pengisiId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}