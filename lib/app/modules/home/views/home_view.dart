import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/mahasiswa_model.dart';
import '../../detail/views/detail_view.dart';
import '../add_data_dialog.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Data Mahasiswa'),
        centerTitle: true,
        title: Image.asset("assets/image/university-logo.png", height: 45, ),
        backgroundColor: const Color(0xFFF2F6FF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              controller.toggleSortName();
            },
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: _buildBody(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.indigo.shade200,
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
      onPressed: () {
        controller.clearInputField();
        _addDataDialog();
      },
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        controller.data.clear();
        controller.onInit();
      },
      child: Obx(() {
        if (controller.loading.value) {
          return _buildLoadingWidget();
        } else if (controller.errorDisplay.value.isNotEmpty) {
          return _buildEmptyStateWidget();
        } else {
          return _buildDataListView();
        }
      }),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: const Color(0xFFF2F6FF),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildDataListView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: controller.data.length,
        itemBuilder: (context, index) {
          Mahasiswa mahasiswa = controller.data[index];
          return _buildListItem(mahasiswa);
        },
      ),
    );
  }

  Widget _buildListItem(Mahasiswa mahasiswa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            mahasiswa.imageUrl ?? '',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          mahasiswa.nama ?? '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff001e61),
          ),
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mahasiswa.prodi ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            const Text('-', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 5),
            Text(mahasiswa.angkatan ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.chevron_right_outlined, color: Colors.grey.shade300),
        ),
        onTap: () {
          Get.to(() => DetailView(), arguments: mahasiswa);
        },
      ),
    );
  }


  Widget _buildEmptyStateWidget() {

    String errorMessage = controller.errorDisplay.value;

    if (errorMessage.isEmpty) {
      errorMessage = 'No data available.';
    } else {
      errorMessage = errorMessage;
    }

    return RefreshIndicator(
      onRefresh: () async {
        controller.data.clear();
        controller.onInit();
        controller.loading.value = true;
      },
      child: Center(
        child: Container(
          width: double.infinity,
          color: const Color(0xFFF2F6FF),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/image/error-mark.png", height: 300, ),
              Text(
                errorMessage,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Obx(() {
                return controller.loading.value
                    ? const CircularProgressIndicator()
                    : FilledButton(
                  onPressed: () {
                    controller.data.clear();
                    controller.loading.value = true;
                    controller.fetchData();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    backgroundColor: Color(0xff001e61),
                  ),
                  child: const Text('Retry'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addDataDialog() async {
    await AddDataDialog.show(controller);
  }

}


