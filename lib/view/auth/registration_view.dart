import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itmo_grain_frontend/controller/auth_controller.dart';
import 'package:itmo_grain_frontend/view/widgets/custom_textfield.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController =TextEditingController();
TextEditingController _nameController = TextEditingController();

class RegistrationView extends GetView<AuthController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32,),
            Obx(
              ()=> Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      controller.changeType(false);
                    },
                    child: Container(
                      height: 52,
                      width: 150,
                      decoration: BoxDecoration(
                        color: controller.regType.value == false ? Colors.grey :Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Как ведущий'
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32,),
                  GestureDetector(
                    onTap: () {
                      controller.changeType(true);
                    },
                    child: Container(
                      height: 52,
                      width: 150,
                      decoration: BoxDecoration(
                        color: controller.regType.value == true ? Colors.grey :Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('Как команда')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24,),
            CustomTextFieldWidget(controller: _emailController, text: 'Email', password: false),
            const SizedBox(height: 12,),
            CustomTextFieldWidget(controller: _nameController, text: 'Name', password: false),
            const SizedBox(height: 12,),
            CustomTextFieldWidget(controller: _passwordController, text: 'Password', password: true),
            const SizedBox(height: 12,),
            Center(
              child: GestureDetector(
                onTap: () {
                  controller.createAccount(name: _nameController.text, email: _emailController.text, rules: controller.regType.value , password: _passwordController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(color: Colors.green, child: Center(child: Text('Аккаунт успешно создан!'),),),backgroundColor: Colors.green,));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Зарегистрироваться'),
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
