import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/game_controller.dart';

import 'config_view.dart';

BluetoothConnection? connection;
bool isConnected = false;
int time = 0;
int stopTime = 0;
String receivedData = '';
bool firstQuest = true;
bool usedQuest = false;

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final game = Get.put(GameController());
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: _connectToBluetooth,
              child: const Text('Подключить систему'),
            ),
          ],
          title: Text(
            isConnected ? 'Система подключена' : 'Система не подключена',
            style: const TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Номер вопроса: ${game.index.toString()}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Text(
                    game.quest['q_text'].toString(),
                    style: const TextStyle(fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  Text(game.quest['answer'].toString()),
                  GestureDetector(
                    onTap: () {
                      game.quest['comment'] == null
                          ? null
                          : showDescription(game.quest['comment'], context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Открыть коментарий'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            isConnected == true
                                ? usedQuest == false
                                    ? stopTime == 0
                                        ? time = int.parse(
                                            game.quest.value['time'].toString())
                                        : time = stopTime
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content: Text(
                                            'На этот вопрос уже отвечали!'),
                                        backgroundColor: Colors.red,
                                      ))
                                : ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content: Text('Система не подключена'),
                                    backgroundColor: Colors.red,
                                  ));
                            stopTime = 0;
                            setState(() {});
                            _unlockButtons();
                            timer();
                          },
                          child: time != 0
                              ? Text(
                                  time.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                  ),
                                )
                              : Container(
                                  height: 43,
                                  width: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text('Таймер'),
                                  ),
                                )),
                      const SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          _unlockButtons();
                          _lockButtons();
                          isConnected == true
                              ? time == 0
                                  ? {

                                      game.nextQuest(),
                                      usedQuest = false,
                                      setState(() {})
                                    }
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content: Text('Вопрос уже задан!'),
                                      backgroundColor: Colors.red,
                                    ))
                              : ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content: Text('Система не подключена'),
                                  backgroundColor: Colors.red,
                                ));
                        },
                        child: Container(
                          height: 43,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('Следующий вопрос'),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TeamCardWidget(
                        teamId: 0,
                        color: Colors.red,
                        index: game.t1.value,
                        name: game.selectedTeams[0]['name'],
                      ),
                      TeamCardWidget(
                        teamId: 1,
                        color: Colors.blue,
                        index: game.t2.value,
                        name: game.selectedTeams[1]['name'],
                      ),
                      game.selectedTeams.length > 2
                          ? TeamCardWidget(
                              teamId: 2,
                              color: Colors.white,
                              index: game.t3.value,
                              name: game.selectedTeams[2]['name'],
                            )
                          : const SizedBox(
                              width: 143,
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      game.selectedTeams.length > 3
                          ? TeamCardWidget(
                              color: Colors.yellow,
                              teamId: 3,
                              index: game.t4.value,
                              name: game.selectedTeams[3]['name'],
                            )
                          : const SizedBox(
                              width: 143,
                            ),
                      game.selectedTeams.length > 4
                          ? TeamCardWidget(
                              color: Colors.green,
                              teamId: 4,
                              index: game.t5.value,
                              name: game.selectedTeams[4]['name'],
                            )
                          : const SizedBox(
                              width: 143,
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        isConnected == true
                            ? {
                                game.endGame(),
                                showDialog<void>(
                                    useSafeArea: false,
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: const Color(0xff2D2D2D)
                                            .withOpacity(0),
                                        contentPadding: EdgeInsets.zero,
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),
                                        content: Container(
                                            height: 253,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                            ),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                const Text(
                                                  'Результаты игры',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Center(
                                                  child: Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                1.3 -
                                                            64,
                                                    color:
                                                        const Color(0xff979797),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: List.generate(
                                                        game.selectedTeams
                                                            .length, (index) {
                                                      var teamScore =
                                                          game.t1.value;
                                                      switch (index) {
                                                        case 1:
                                                          teamScore =
                                                              game.t2.value;
                                                        case 2:
                                                          teamScore =
                                                              game.t3.value;
                                                        case 3:
                                                          teamScore =
                                                              game.t4.value;
                                                        case 4:
                                                          teamScore =
                                                              game.t5.value;
                                                      }
                                                      return Column(
                                                        children: [
                                                          Text(game
                                                                  .selectedTeams[
                                                              index]['name']),
                                                          Text(teamScore
                                                              .toString()),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      {
                                                        _unlockButtons();
                                                        _lockButtons();
                                                        connection?.close();
                                                        isConnected = false;
                                                        game.selectedQuestions
                                                            .value = [];
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        'Вернуться на главную',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xff8875FF),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    })
                              }
                            : ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                content: Text('Система не подключена'),
                                backgroundColor: Colors.red,
                              ));
                      },
                      child: Container(
                        height: 52,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('Завершить игру'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _connectToBluetooth() async {
    BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SelectBluetoothDevicePage();
        },
      ),
    );

    if (selectedDevice != null) {
      try {
        connection =
            await BluetoothConnection.toAddress(selectedDevice.address);
        setState(() {
          isConnected = true;
        });
        _startListening();
      } catch (e) {}
    }
  }

  void _startListening() {
    connection?.input?.listen((Uint8List data) {
     var checkReceivedData = String.fromCharCodes(data);
      if(checkReceivedData.isNotEmpty) {
        receivedData = String.fromCharCodes(data);
        print('data: "${receivedData}" ${receivedData.runtimeType}');
      }
        print(data);
        final game = Get.put(GameController());
        stopTime = time;
        time = 0;
        showDialog<void>(
            useSafeArea: false,
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xff2D2D2D).withOpacity(0),
                contentPadding: EdgeInsets.zero,
                insetPadding: const EdgeInsets.symmetric(horizontal: 12),
                content: Container(
                    height: 183,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.9),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Center(
                          child: Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width / 2 - 64,
                            color: const Color(0xff979797),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text('Правильный ответ?'),
                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  height: 52,
                                  width: MediaQuery.of(context).size.width / 4 -
                                      52,
                                  child: const Center(
                                    child: Text(
                                      'Нет',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Color(0xff8875FF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('price ${ game.quest['price']}');
                                  switch (receivedData) {
                                    case '1':
                                      game.t1.value = game.t1.value +
                                          int.parse(game.quest['price']);
                                      print(game.t1.value);
                                    case '2':
                                      game.t2.value = game.t2.value +
                                          int.parse(game.quest['price']);
                                      print(game.t2.value);
                                    case '3':
                                      game.t3.value = game.t3.value +
                                          int.parse(game.quest['price']);
                                      print(game.t3.value);
                                    case '4':
                                      game.t4.value = game.t4.value +
                                          int.parse(game.quest['price']);
                                    case '5':
                                      game.t5.value = game.t5.value +
                                          int.parse(game.quest['price']);
                                  }
                                  usedQuest = true;
                                  setState(() {});
                                  time = 0;
                                  stopTime = 0;
                                  //   game.nextQuest();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 52,
                                  width: MediaQuery.of(context).size.width / 4 -
                                      52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xff8875FF),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Да',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              );
            });
    });
  }

  void _lockButtons() {
    setState(() {
      connection?.output
          .add(ascii.encode('1')); // Send signal '1' to lock buttons
    });
  }

  void _unlockButtons() {
    setState(() {
      connection?.output
          .add(ascii.encode('2')); // Send signal '2' to unlock buttons
    });
  }

  void timer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      time > 0 ? time-- : {timer.cancel(), _lockButtons()};
      setState(() {});
    });
  }

  @override
  void initState() {
    final game = Get.put(GameController());
    game.nextQuest();
    _lockButtons();
    _lockButtons();
    _lockButtons();
    super.initState();
  }
}

class TeamCardWidget extends GetView<GameController> {
  final Color color;
  final String name;
  var index;
  final teamId;
  TeamCardWidget(
      {super.key,
      required this.index,
      required this.color,
      required this.name,
      required this.teamId});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());
    return Container(
        alignment: Alignment.bottomCenter,
        height: 43,
        width: 143,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(name),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Text(
                //   '0',
                //   style: TextStyle(
                //     color: Colors.red,
                //   ),
                // ),
                // const SizedBox(
                //   width: 4,
                // ),
                Text(
                  index.toString(),
                ),
                // const SizedBox(
                //   width: 4,
                // ),
                // const Text(
                //   '0',
                //   style: TextStyle(
                //     color: Colors.green,
                //   ),
                // ),
              ],
            ),
          ],
        ));
  }
}

void showDescription(String text, BuildContext context) async {
  showDialog<void>(
      useSafeArea: false,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff2D2D2D).withOpacity(0),
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 12),
          content: Container(
              height: 253,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.9),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Комментарий к ответу',
                    style: TextStyle(fontSize: 20),
                  ),
                  Center(
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width / 1.5 - 64,
                      color: const Color(0xff979797),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(text),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        height: 52,
                        width: MediaQuery.of(context).size.width / 4 - 52,
                        child: const Center(
                          child: Text(
                            'Закрыть',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xff8875FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        );
      });
}
