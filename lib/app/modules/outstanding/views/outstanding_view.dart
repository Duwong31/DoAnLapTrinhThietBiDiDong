import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/outstanding_controller.dart';

class OutstandingView extends GetView<OutstandingController> {
  const OutstandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Nổi bật',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
