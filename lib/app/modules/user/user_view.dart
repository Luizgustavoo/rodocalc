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
                RefreshIndicator(
                  onRefresh: () async {
                    controller.searchUserController.clear();
                    controller.listUsers.clear();
                    controller.getMyEmployees();
                  },
                  child: SizedBox(
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredUsers.length,
                                  itemBuilder: (context, index) {
                                    final User user =
                                        controller.filteredUsers[index];
                                    return Dismissible(
                                      key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss:
                                          (DismissDirection direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          showDialog(context, user, controller);
                                        }
                                        return false;
                                      },
                                      background: Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Icon(
                                                    Icons.check_rounded,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'EXCLUIR',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                      child: CustomFleetOwnerCard(
                                        fnEdit: () {
                                          VehicleController vehicleController =
                                              Get.put(VehicleController());
                                          vehicleController.getAllDropDown();

                                          controller.fillInFields(user);
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                CreateUserModal(
                                              vehicleController:
                                                  vehicleController,
                                              isUpdate: true,
                                              user: user,
                                            ),
                                          );
                                        },
                                        user: user,
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('NENHUM USUÁRIO ENCONTRADO!'),
                              );
                            }
                          })
                        ]),
                      ),
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

  void showDialog(context, User user, UserController controller) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja excluir o usuário ${user.people!.nome!.toUpperCase()}?",
        style: const TextStyle(
          fontFamily: 'Inter-Regular',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno =
                await controller.deleteUser(user.id!);

            if (retorno['success'] == true) {
              Get.back();
              Get.snackbar('Sucesso!', retorno['message'].join('\n'),
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM);
            } else {
              Get.snackbar('Falha!', retorno['message'].join('\n'),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: const Text(
            "CONFIRMAR",
            style: TextStyle(fontFamily: 'Poppinss', color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "CANCELAR",
            style: TextStyle(fontFamily: 'Poppinss'),
          ),
        ),
      ],
    );
  }
}
