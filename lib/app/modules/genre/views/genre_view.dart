import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/genre_controller.dart';

class GenreView extends GetView<GenreController> {
  const GenreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Genre', style: TextStyle(color: Colors.black, fontSize: 20),),
      ),
      body: const Center(
        child: Text(
          'Tính năng đang phát triển!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    );
  }
}
