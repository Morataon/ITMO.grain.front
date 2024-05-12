import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/game_controller.dart';
import 'package:itmo_grain_frontend/view/owner/create_game/create_category.dart';

TextEditingController _textController = TextEditingController();
TextEditingController _commentController = TextEditingController();
TextEditingController _answerController = TextEditingController();
TextEditingController _timeController = TextEditingController();
TextEditingController _scoreController = TextEditingController();

class CreateQuestView extends GetView<GameController> {
  const CreateQuestView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    controller.getCategories();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Создание вопроса'),
          actions: [
            GestureDetector(
              child: const Text('Создать категорию'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CreateCategory()));
              },
            ),
          ],
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Текст вопроса'),
                      TextField(
                        controller: _textController,
                      ),
                      const Text('Ответ на вопрос'),
                      TextField(
                        controller: _answerController,
                      ),
                      const Text('Коментарий к ответу'),
                      TextField(
                        controller: _commentController,
                      ),
                      const Text('Время на ответ'),
                      TextField(
                        controller: _timeController,
                      ),
                      const Text('Баллы за вопрос'),
                      TextField(
                        controller: _scoreController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              controller.categories.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.5),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.selectCategory(int.parse(
                                            controller.categories[index]['id']
                                                .toString()));
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: controller
                                                        .selectedCategoryCreate
                                                        .value !=
                                                    int.parse(controller
                                                        .categories[index]['id']
                                                        .toString())
                                                ? Colors.grey
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(controller
                                                .categories[index]['name']),
                                          )),
                                    ),
                                  )),
                        ),
                      ),
                      const SizedBox(height: 18,),
                      GestureDetector(
                        onTap: () {
                          controller.createQuest(text: _textController.text, answer: _answerController.text, delay: _timeController.text, comment: _commentController.text, price: _scoreController.text, category: controller.selectedCategoryCreate.value.toString());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                          height: 43,
                          width: 150,
                          child: const Center(child: Text('Создать')),

                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
