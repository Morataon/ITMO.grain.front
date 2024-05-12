import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/game_controller.dart';

import '../auth/login_view.dart';

class HomeTeamView extends GetView<GameController> {
  const HomeTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    controller.getTeamGames();
    controller.getTeamInfo();
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Имя'),
                          Text(
                            controller.team['name'],
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        children: [
                          const Text('Очки'),
                          Text(
                            controller.team['score'],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        children: [
                          const Text('Игры'),
                          Text(
                            controller.team['games'],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        children: [
                          const Text('Победы'),
                          Text(
                            controller.team['wins'],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: ListView(
                  children: List.generate(controller.teamGames.length, (index) {
                    var item = controller.teamGames[index];
                    return GameCard(item: item);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class GameCard extends StatelessWidget {
  final item;
  const GameCard({super.key,required this.item});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width:
                        MediaQuery.of(context).size.width / 5 -
                            50,
                        child: Column(
                          children: [
                            Text(
                              item['team1_name'],
                              style: TextStyle(
                                color: item['team1_id'] == uid ?Colors.green : Colors.black,
                              ),
                            ),
                            Text(
                              item['team1_score'],
                            ),
                            item['winner_id']  == item['team1_id'] ?     const Text('Победитель',style: TextStyle(color: Colors.orange),) :const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width:
                        MediaQuery.of(context).size.width / 5 -
                            50,
                        child: Column(
                          children: [
                            Text(
                              item['team2_name'],
                              style: TextStyle(
                                color: item['team2_id'] == uid ?Colors.green : Colors.black,
                              ),
                            ),
                            Text(
                              item['team2_score'],
                            ),
                            item['winner_id']  == item['team2_id'] ?     const Text('Победитель',style: TextStyle(color: Colors.orange)) :const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width:
                        MediaQuery.of(context).size.width / 5 -
                            50,
                        child: Column(
                          children: [
                            Text(
                              item['team3_name'],
                              style: TextStyle(
                                color: item['team3_id'] != '-1' ? item['team3_id'] == uid ?Colors.green : Colors.black : Colors.red,
                              ),
                            ),
                            Text(
                              item['team3_score'],
                            ),
                            item['winner_id']  == item['team3_id'] ?     const Text('Победитель',style: TextStyle(color: Colors.orange)) :const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width:
                        MediaQuery.of(context).size.width / 5 -
                            50,
                        child: Column(
                          children: [
                            Text(
                              item['team4_name'],
                              style: TextStyle(
                                color: item['team4_id'] != '-1' ? item['team4_id'] == uid ?Colors.green : Colors.black : Colors.red,
                              ),
                            ),
                            Text(
                              item['team4_score'],
                            ),
                            item['winner_id']  == item['team4_id'] ?     const Text('Победитель',style: TextStyle(color: Colors.orange)) :const SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width:
                        MediaQuery.of(context).size.width / 5 -
                            50,
                        child: Column(
                          children: [
                            Text(
                              item['team5_name'],
                              style: TextStyle(
                                color: item['team5_id'] != '-1' ? item['team5_id'] == uid ?Colors.green : Colors.black : Colors.red,
                              ),
                            ),
                            Text(
                              item['team5_score'],
                            ),
                            item['winner_id']  == item['team5_id'] ?     const Text('Победитель',style: TextStyle(color: Colors.orange)) :const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  item['winner_id'] == '-1' ? Text('Ничья'):SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
