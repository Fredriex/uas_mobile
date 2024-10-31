class Karyawan{
  String? kode;
  String? nama;
  String? email;
  String? hp1;
  String? hp2;
  String? alamat;
  int? umur;


  Karyawan(this.kode, this.nama, this.email, this.hp1, this.hp2, this.alamat, this.umur);

  karyawanMap() {
    var mapping = Map<String, dynamic>();
    mapping['kode'] = kode ?? null;
    mapping['nama'] = nama!;
    mapping['email'] = email!;
    mapping['hp1'] = hp1!;
    mapping['hp2'] = hp2!;
    mapping['alamat'] = alamat!;
    mapping['umur'] = umur!;
    return mapping;
  }
}
