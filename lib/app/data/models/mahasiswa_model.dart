import 'package:faker/faker.dart';

class Mahasiswa {
  String? angkatan;
  String? ipk;
  String? nama;
  String? nim;
  String? prodi;
  String? imageUrl;

  Mahasiswa(
      {this.angkatan, this.ipk, this.nama, this.nim, this.prodi, this.imageUrl});

  Mahasiswa.fromJson(Map<String, dynamic> json) {
    angkatan = json['angkatan'];
    ipk = json['ipk'];
    nama = json['nama'];
    nim = json['nim'];
    prodi = json['prodi'];
    imageUrl = generateRandomImg();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['angkatan'] = angkatan;
    data['ipk'] = ipk;
    data['nama'] = nama;
    data['nim'] = nim;
    data['prodi'] = prodi;
    return data;
  }

  static String generateRandomImg() {
    final faker = Faker();
    final randomNumber = faker.randomGenerator.integer(999);
    return faker.image.image(
      keywords: ['student', randomNumber.toString()],
    );
  }
}
