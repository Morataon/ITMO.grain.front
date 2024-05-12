import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/game_controller.dart';
import 'package:itmo_grain_frontend/server_routes.dart';

TextEditingController _categoryController = TextEditingController();
class CreateCategory extends GetView<GameController> {
  const CreateCategory({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _categoryController,
            ),
            TextButton(onPressed: () {
              Dio dio = Dio();
                  dio.post('${ServerRouter.host}/category',
                  data: {'name': _categoryController.text});
                  Navigator.pop(context);
              controller.getAllQuestions();
              controller.getCategories();
            }, child: const Text('Добавить')),
          ],
        ),
      ),
    );
  }
}
