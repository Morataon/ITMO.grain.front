import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/game_controller.dart';
import 'package:itmo_grain_frontend/view/home_screen_view.dart';
import 'package:itmo_grain_frontend/view/owner/create_game/create_quest_view.dart';

class SelectQuestionsView extends GetView<GameController> {
  const SelectQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    controller.getAllQuestions();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateQuestView()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeView()));
        },
        child: const Icon(Icons.navigate_next),
      ),
      body: Obx(
        () => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        List.generate(controller.questions.length, (index) {
                      var item = controller.questions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.changeCategory(
                                int.parse(item['type_id'].toString()));
                          },
                          child: CategoryCard(
                            title: item['type_name'],
                            selectedId: controller.selectedCategory.value,
                            categoryId: int.parse(item['type_id'].toString()),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      (controller.questions[controller.selectedCategory.value]
                              ['questions'] as List)
                          .length, (index) {
                    var item =
                        controller.questions[controller.selectedCategory.value]
                            ['questions'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.toggleQuestionSelection(item);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: controller.selectedQuestions.contains(item)
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['q_text']),
                                SizedBox(height: 4,),
                                Row(
                                  children: [
                                    Text('[${item['answer']}]'),
                                    SizedBox(width: 4,),
                                    Text('Время: ${item['time']}'),
                                    SizedBox(width: 4,),
                                    Text('Баллы: ${item['price']}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final int selectedId;
  final int categoryId;

  const CategoryCard(
      {Key? key,
      required this.title,
      required this.selectedId,
      required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedId == categoryId;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? Colors.blue
            : Colors
                .grey, // Изменение цвета в зависимости от выбранной категории
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          title,
        ),
      ),
    );
  }
}
