import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/list_controller.dart';

class ListPageView extends GetView<ListController> {
  const ListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Danh sách',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
