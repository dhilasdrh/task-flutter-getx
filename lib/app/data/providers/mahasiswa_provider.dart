import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/mahasiswa_model.dart';

class MahasiswaProvider extends GetConnect {
  String baseURL = 'https://btj-academy-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<Response> getDataMahasiswa() async => await get(
        '$baseURL/mahasiswa.json');

  Future<Response> postMahasiswa(Mahasiswa mahasiswa) async => await post(
      '$baseURL/mahasiswa.json',
      mahasiswa.toJson());

  Future<Response> deleteMahasiswa(String id) async =>
      await delete('$baseURL/mahasiswa/$id.json');


  // use external path
  Future<Response<Map<String, dynamic>>> getFileDataMahasiswa() async {
    try {
      String jsonString = await rootBundle.loadString('assets/json/data.json');
      Map<String, dynamic> data = json.decode(jsonString);
      return Response<Map<String, dynamic>>(statusCode: 200, body: data);
    } catch (e) {
      return Response<Map<String, dynamic>>(statusCode: 500, body: {'error': 'Failed to load data'});
    }
  }
}
