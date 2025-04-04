import 'package:get/get.dart';

import '../core/styles/style.dart';

void showAlertDialog({
  required String title,
  required String description,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(description),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
