import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/game_controller.dart';
import 'package:itmo_grain_frontend/view/owner/create_game/select_questions.dart';
import 'package:itmo_grain_frontend/view/widgets/custom_textfield.dart';

class SelectTeamsView extends GetView<GameController> {
  const SelectTeamsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Выбрано ${controller.selectedTeams.length}/5'),
          actions: [
            TextButton(
                onPressed: () {
                  showDialog<void>(
                      useSafeArea: false,
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return const CreateTeamDialog();
                      });
                },
                child: const Text('Создать команду')),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: controller.allTeams.length,
                itemBuilder: (context, index) {
                  final item = controller.allTeams[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text(
                        'Wins: ${item['wins']}, Games: ${item['games']}, Score: ${item['score']}'),
                    tileColor: controller.selectedTeams.contains(item)
                        ? Colors.blue.withOpacity(
                            0.3) // Измените цвет или прозрачность здесь
                        : Colors.white,
                    onTap: () {
                      controller.toggleSelection(item);
                      controller.update();
                    },
                  );
                },
              )),
              ElevatedButton(
                onPressed: () {
                  if (controller.selectedTeams.length < 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Выберите минимум 2 команды'),
                      ),
                    );
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectQuestionsView()));
                  }
                },
                child: const Text('Далее'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateTeamDialog extends GetView<GameController> {
  const CreateTeamDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      content: Container(
          height: 333,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                CustomTextFieldWidget(
                    controller: nameController,
                    text: 'Название команды',
                    password: false),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFieldWidget(
                    controller: emailController,
                    text: 'Email команды',
                    password: false),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFieldWidget(
                    controller: passwordController,
                    text: 'Пароль команды',
                    password: false),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 18,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      controller.createTeam(
                          name: nameController.text,
                          password: passwordController.text,
                          email: emailController.text);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 52,
                      width: MediaQuery.of(context).size.width - 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Создать'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
