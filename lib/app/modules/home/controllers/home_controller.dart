import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/mahasiswa_model.dart';
import '../../../data/providers/mahasiswa_provider.dart';
import '../add_data_dialog.dart';

class HomeController extends GetxController {
  final MahasiswaProvider _provider = Get.find<MahasiswaProvider>();

  TextEditingController namaController = TextEditingController();
  TextEditingController nimController = TextEditingController();
  TextEditingController prodiController = TextEditingController();
  TextEditingController ipkController = TextEditingController();
  TextEditingController angkatanController = TextEditingController();

  RxList<Mahasiswa> data = <Mahasiswa>[].obs;
  RxBool loading = false.obs;
  RxString errorDisplay = ''.obs;
  RxBool addDataError = false.obs;
  RxBool sortAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onClose() {
    namaController.dispose();
    nimController.dispose();
    ipkController.dispose();
    angkatanController.dispose();
    prodiController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    try {
      loading(true);

      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        loading(false);
        errorDisplay('No internet connection. Please check your internet connection and try again');
        return;
      }

      final response = await _provider.getDataMahasiswa();

      if (response.statusCode == 200) {
        data.clear();
        response.body.forEach((key, value) {
          var newData = Mahasiswa.fromJson(value);
          data.add(newData);
        });
        showSuccessSnackbar("Successfully fetch data. Status code: ${response.statusCode}. Status: ${response.statusText}");
        loading(false);
        errorDisplay('');
      } else {
        loading(false);
        showErrorSnackbar('Failed to fetch data from API. Status code: ${response.statusCode}. Status: ${response.statusText}');
        errorDisplay('Failed to fetch data from API. Please check your internet connection and try again.');
      }
    } catch (e) {
      loading(false);
      if (e is SocketException) {
        showErrorSnackbar('No internet connection');
      } else {
        showErrorSnackbar('Unexpected error occurred');
      }
    }
  }

  Future<void> addData() async {
    try {
      loading(true);
      final response = await _provider.postMahasiswa(
        Mahasiswa(
          ipk: ipkController.text,
          nama: namaController.text,
          nim: nimController.text,
          prodi: prodiController.text,
          angkatan: angkatanController.text,
        ),
      );

      if (response.statusCode == 200) {
        // showSuccessSnackbar("Successfully add new data. Status code: ${response.statusCode}. Status: ${response.statusText}");
        loading(false);
        showSuccessSaveDialog("The data has been added");
        await fetchData();
      } else {
        loading(false);
        showErrorSaveDialog('Failed to add new data due to error. Please check your internet and try again');
        showErrorSnackbar('Save data failed. Status code: ${response.statusCode}. Status: ${response.statusText}');
      }
    } catch (e) {
      loading(false);
    }
  }

  void showSuccessSaveDialog(String message) {
    Get.defaultDialog(
      title: 'Success',
      titleStyle: TextStyle(color: Color(0xff001e61), fontWeight: FontWeight.bold),
      content: Column(
        children: [
          Image.asset("assets/image/success-mark.png", height: 150,),
          Text(message),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: (){
            Get.back();
            clearInputField();
          },
          child: Text('OK'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40),
            backgroundColor: Color(0xff001e61),
          ),
        )
      ],
    );
  }

  void showErrorSaveDialog(String message) {
    addDataError(true);

    Get.defaultDialog(
      title: 'Error',
      titleStyle: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
      content: Column(
        children: [
          Image.asset("assets/image/error-warning.png", height: 150),
          Text(message),
        ],
      ),
      buttonColor: Colors.red.shade800,
      textConfirm: 'Try Again',
      onConfirm: ()  {
        Get.back();
        AddDataDialog.show(this);
      },
    );
  }

  void showErrorSnackbar(String message){
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade800,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
      isDismissible: true,
    );
  }

  void showSuccessSnackbar(String successMessage){
    Get.snackbar(
      'Success',
      successMessage,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
      isDismissible: true,
    );

  }

  void clearInputField() {
    angkatanController.clear();
    ipkController.clear();
    namaController.clear();
    nimController.clear();
    prodiController.clear();
  }

  void tryAddTempData() {
    Mahasiswa newMahasiswa = Mahasiswa(
      angkatan: angkatanController.text,
      ipk: ipkController.text,
      nama: namaController.text,
      nim: nimController.text,
      prodi: prodiController.text,
      imageUrl: generateFakeImageUrl(),
    );

    data.add(newMahasiswa);

    if (data.contains(newMahasiswa)) {
      showSuccessSaveDialog("Successfully add temporary data");

      // Get.snackbar(
      //   'Success',
      //   'Local data added successfully',
      //   backgroundColor: Color(0xffe01932),
      //   colorText: Colors.white,
      // );
    } else {
      showErrorSaveDialog("Failed to add temporary file");

      // Get.snackbar(
      //   'Error',
      //   'Failed to add data locally. Please try again.',
      //   backgroundColor: Colors.red.shade800,
      //   colorText: Colors.white,
      // );
    }
  }

  static String generateFakeImageUrl() {
    final faker = Faker();
    final randomNumber = faker.randomGenerator.integer(999);
    return faker.image.image(
      keywords: ['student', randomNumber.toString()],
    );
  }

  void toggleSortName() {
    sortAscending.value = !sortAscending.value;
    sortData();
  }

  void sortData() {
    List<Mahasiswa> data = Get.find<HomeController>().data;

    data.sort((a, b) {
      if (sortAscending.value) {
        return a.nama!.compareTo(b.nama!);
      } else {
        return b.nama!.compareTo(a.nama!);
      }
    });
  }


}