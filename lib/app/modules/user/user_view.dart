// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/user_controller.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/user/widgets/create_user_modal.dart';
import 'package:rodocalc/app/modules/user/widgets/custom_user_card.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CRIAR USUÁRIO'),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/signup.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        TextFormField(
                          controller: controller.searchUserController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.search_rounded),
                            labelText: 'PESQUISAR USUÁRIO',
                          ),
                          onChanged: (value) {
                            controller.filterUsers(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Column(
                              children: [
                                Text('Carregando...'),
                                SizedBox(height: 20.0),
                                CircularProgressIndicator(),
                              ],
                            );
                          } else if (!controller.isLoading.value &&
                              controller.listUsers.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 200),
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final User user =
                                      controller.filteredUsers[index];
                                  return CustomFleetOwnerCard(
                                    fnEdit: () {
                                      VehicleController vehicleController =
                                          Get.put(VehicleController());
                                      vehicleController.getAllDropDown();

                                      controller.fillInFields(user);
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => CreateUserModal(
                                          vehicleController: vehicleController,
                                          isUpdate: true,
                                          user: user,
                                        ),
                                      );
                                    },
                                    user: user,
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('Nenhum usuário encontrado!'),
                            );
                          }
                        })
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF6B00),
          onPressed: () async {
            await controller.getQuantityLicences();

            if (controller.usersRegistered.value >= controller.licences.value) {
              Get.snackbar(
                  'Atenção!', 'A quantidade de licenças do seu plano estourou!',
                  backgroundColor: Colors.orange,
                  colorText: Colors.black,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM);
            } else {
              VehicleController vehicleController =
                  Get.put(VehicleController());
              vehicleController.getAllDropDown();
              controller.clearAllFields();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => CreateUserModal(
                  vehicleController: vehicleController,
                  isUpdate: false,
                ),
              );
            }
          },
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
