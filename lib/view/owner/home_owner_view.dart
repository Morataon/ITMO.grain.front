import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/game_controller.dart';
import 'package:itmo_grain_frontend/view/owner/create_game/select_teams.dart';
import 'package:itmo_grain_frontend/view/team/home_team_view.dart';

class HomeOwnerView extends GetView<GameController> {
  const HomeOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    controller.getAllTeams();
    controller.getOwnerGames();
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectTeamsView()));
              },
              child: const Text('Создать игру')),
        ],
      ),
      body: SafeArea(
        child: Obx(
          ()=> Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      controller.changeType(false);
                    },
                    child: Container(
                      height: 52,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: controller.gamesOrTeams.value == false ? Colors.black : Colors.black.withOpacity(0)),
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Игры'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24,),
                  GestureDetector(
                    onTap: (){
                      controller.changeType(true);
                    },
                    child: Container(
                      height: 52,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: controller.gamesOrTeams.value == true ? Colors.black : Colors.black.withOpacity(0)),
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Команды'),
                      ),
                    ),
                  ),
                ],
              ),
           controller.gamesOrTeams.value == true ?   Expanded(
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
                  );
                },
              )) :
           Expanded(
               child: ListView.builder(
                 itemCount: controller.ownerGames.length,
                 itemBuilder: (context, index) {
                   final item = controller.ownerGames[index];
                   return GameCard(item: item);
                 },
               )),
            ],
          ),
        ),
      ),
    );
  }
}
