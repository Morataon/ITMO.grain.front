import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/server_routes.dart';
import 'package:itmo_grain_frontend/view/auth/login_view.dart';

class GameController extends GetxController {
  RxBool gamesOrTeams = false.obs;
  RxInt selectedCategory = 0.obs; //вкладка при выборе вопроса
  RxList categories = [].obs; //в создании вопроса
  RxList allTeams = [].obs; //все команды
  RxList selectedTeams = [].obs; //выбранные команды
  RxList questions = [].obs; //все вопросы
  RxList smallQuestions = [].obs; //резерв памяти
  RxMap quest = {}.obs; //объект текущего вопроса в запущеной игре (т.е. тот вопрос на который сейчас отвечают)
  RxList teamGames = [].obs;
  RxMap team = {}.obs;
  RxList ownerGames = [].obs;
  RxInt selectedCategoryCreate =
      0.obs; //выбрная категория в которой будет создан вопрос
  Dio dio = Dio(); //библиотека работы с сетью
  RxString receivedData = ''.obs; //ответ от блютуза
  RxInt t1 = 0.obs; //счёт первой команды
  RxInt t2 = 0.obs; //счёт второй команды
  RxInt t3 = 0.obs; //счёт третьей команды
  RxInt t4 = 0.obs; //счёт четвертой команды
  RxInt t5 = 0.obs; //счёт пятой команды
  @override
  void onInit() {
    super.onInit(); //загрузка списка команд на экран при его открытии
    getAllTeams();
  }

  Future<void> getAllTeams() async {
    final response = await dio.get('${ServerRouter.host}/teams');
    allTeams.value = List<Map<String, dynamic>>.from(
        jsonDecode(response.data)); //функция получения списка команд с сервера
  }

  void toggleSelection(Map<String, dynamic> team) {
    //выбор команд с ограничением в 5
    if (selectedTeams.contains(team)) {
      selectedTeams.remove(team);
      notifyChildrens();
      allTeams.refresh();
    } else {
      if (selectedTeams.length < 5) {
        //реализация ограничения
        selectedTeams.add(team);
        allTeams.refresh();
        selectedTeams.refresh();
        notifyChildrens();
      }
    }
    notifyChildrens();
    update();
  }

  Future<void> createTeam(
      {required name, required password, required email}) async {
    //регистрация новой команды
    await dio.post('${ServerRouter.host}/registration', data: {
      'name': name,
      'password': password,
      'type': true.toString(),
      'email': email,
    });
    Future.delayed(Duration(milliseconds: 100), () {
      getAllTeams();
    });
  }

  Future<void> getAllQuestions() async {
    //получения всех вопросов и разделение по вкладкам
    final response = await dio.get('${ServerRouter.host}/questions');
    questions.value = jsonDecode(response.data);
    notifyChildrens();
  }

  void changeCategory(cat) {
    selectedCategory.value = cat; //смена вкладки
    notifyChildrens();
  }

  RxList<Map<String, dynamic>> selectedQuestions =
      <Map<String, dynamic>>[].obs; //выбранные вопросы

  void toggleQuestionSelection(Map<String, dynamic> question) {
    if (selectedQuestions.contains(question)) {
      selectedQuestions.remove(question);
    } else {
      selectedQuestions.add(question);
    }
  }

  int index = 0;
  void nextQuest() {
    quest.value = selectedQuestions[index];  //новый вопрос
    index = index + 1;
    notifyChildrens();
  }

  void addScore(team, int newScore) { //добавление счёта
    switch (team) {
      case 0:
        t1.value = t1.value + 3;
      case 1:
        t2.value = t2.value + 3;
      case 2:
        t3.value = t3.value + 3;
      case 3:
        t4.value = t4.value + 3;
      case 4:
        t5.value = t5.value + 3;
    }
    notifyChildrens();
  }

  void delScore(team, int newScore) {
    switch (team) {
      case 0:
        t1.value = t1.value - newScore;
      case 1:
        t2.value = t2.value - newScore;
      case 2:
        t3.value = t3.value - newScore;
      case 3:
        t4.value = t4.value - newScore;
      case 4:
        t5.value = t5.value - newScore;
    }
  }

  Future<void> endGame() async {
    final game = Get.put(GameController());
    var legnht = game.selectedTeams.length;
    dio.post('${ServerRouter.host}/endGame', data: {
      'team1_id': game.selectedTeams.value[0]['id'],
      'team2_id': game.selectedTeams.value[1]['id'],
      'team3_id': legnht > 2 ? game.selectedTeams.value[2]['id'] : '-1',
      'team4_id': legnht > 3 ? game.selectedTeams.value[3]['id'] : '-1',
      'team5_id': legnht > 4 ? game.selectedTeams.value[4]['id'] : '-1',
      'team1_score': game.t1.value.toString(),
      'team2_score': game.t2.value.toString(),
      'team3_score': game.t3.value.toString(),
      'team4_score': game.t4.value.toString(),
      'team5_score': game.t5.value.toString(),
      'winner': '5',
      'master_id': uid,
    });
  }

  Future<void> getCategories() async {
    final response = await dio.get('${ServerRouter.host}/categories');
    categories.value = jsonDecode(response.data);
    notifyChildrens();
  }

  void selectCategory(int category) {
    selectedCategoryCreate.value = category;
    notifyChildrens();
  }

  Future<void> createQuest(
      {required text,
      required answer,
      required delay,
      required comment,
      required price,
      required category}) async {
    dio.post('${ServerRouter.host}/questions', data: {
      'q_text': text,
      'q_answer': answer,
      'q_delay': delay,
      'q_comment': comment,
      'uid': '1',
      'tip': category,
      'price': price,
    });
  }
  Future<void> getTeamGames() async{
    final response = await dio.post('${ServerRouter.host}/teamGames',data: {
      'id': uid,
    });
    teamGames.value = jsonDecode(response.data);
    notifyChildrens();
  }
  Future<void> getTeamInfo() async {
    final response = await dio.post("${ServerRouter.host}/getTeamInfo",data: {
      'id':uid,
    });
    team.value = jsonDecode(response.data);
    notifyChildrens();

  }
  Future<void> getOwnerGames() async {
    final response = await dio.post("${ServerRouter.host}/getOwnerGames",data: {
      'id':uid,
    });
    ownerGames.value = jsonDecode(response.data);
    notifyChildrens();
  }
  void changeType (bool type) {
    gamesOrTeams.value = type;
    notifyChildrens();
  }
}
