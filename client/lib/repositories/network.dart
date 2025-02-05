import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if(connectivityResult.contains(ConnectivityResult.none)) {
      Get.rawSnackbar(
          messageText: const Text(
            "Please connect to the internet",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14
            ),
          ),
          isDismissible: true,
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.blue[400]!,
          icon: const Icon(Icons.wifi_off, color: Colors.white, size: 35),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED
      );
    } else {
      if(Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
