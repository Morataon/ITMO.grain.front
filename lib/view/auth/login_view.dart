import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/auth_controller.dart';
import 'package:itmo_grain_frontend/view/auth/registration_view.dart';
import 'package:itmo_grain_frontend/view/owner/home_owner_view.dart';
import 'package:itmo_grain_frontend/view/team/home_team_view.dart';
import 'package:itmo_grain_frontend/view/widgets/custom_textfield.dart';

TextEditingController _loginController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
var uid = '';
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('GRAIN',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),)),
          const SizedBox(
            height: 12,
          ),
          Center(
            child: CustomTextFieldWidget(
                controller: _loginController, text: 'Email', password: false),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomTextFieldWidget(
              controller: _passwordController, text: 'Пароль', password: true),
          const SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () async {
            Map response = await  controller.login(_loginController.text, _passwordController.text);
          if(response['success'] == true) {
            uid =response['uid'];
            if(response['rules'] == '0') {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeOwnerView()));
            }
            else {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeTeamView()));
            }
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(color: Colors.red, child: const Center(child: Text('Неверный логин или пароль!'),),),backgroundColor: Colors.red,));

          }

            },
            child: Container(
              height: 52,
              width: 230,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: const Center(
                child: Text('Войти',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),),
              ),
            ),
          ),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegistrationView()));
          }, child: const Text('Регистрация')),
        ],
      ),
    );
  }
}
