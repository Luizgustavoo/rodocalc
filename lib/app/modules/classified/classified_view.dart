// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/classified_controller.dart';
import 'package:rodocalc/app/data/models/classifieds_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/classified/widgets/create_classified_modal.dart';
import 'package:rodocalc/app/modules/classified/widgets/custom_classified_card.dart';
import 'package:rodocalc/app/modules/global/custom_search_field.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class ClassifiedView extends GetView<ClassifiedController> {
  const ClassifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CLASSIFICADOS'),
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
                    controller.searchClassifiedController.clear();
                    controller.listClassifieds.clear();
                    controller.getAll();
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
                          CustomSearchField(
                            labelText: 'PESQUISAR CLASSIFICADO',
                            controller: controller.searchClassifiedController,
                            onChanged: (value) {
                              controller.filterClassifieds(value);
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
                                controller.listClassifieds.isNotEmpty) {
                              return Expanded(
                                child: GridView.builder(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .25),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.6,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount:
                                      controller.filteredClassifieds.length,
                                  itemBuilder: (context, index) {
                                    final Classifieds classificado =
                                        controller.filteredClassifieds[index];

                                    return Dismissible(
                                      key: UniqueKey(),
                                      direction: ServiceStorage.getUserId() ==
                                              classificado.user!.id
                                          ? DismissDirection.endToStart
                                          : DismissDirection.none,
                                      confirmDismiss:
                                          (DismissDirection direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {}
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: InkWell(
                                        child: CustomClassifiedCard(
                                          fnEdit: () {
                                            if (ServiceStorage.getUserId() ==
                                                classificado.user!.id!) {
                                              controller.clearAllFields();
                                              controller
                                                  .fillInFields(classificado);
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) =>
                                                    CreateClassifiedModal(
                                                  isUpdate: true,
                                                  classificado: classificado,
                                                ),
                                              );
                                            } else {
                                              Get.snackbar('Falha!',
                                                  "Classificado não foi criado por você!",
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  snackPosition:
                                                      SnackPosition.BOTTOM);
                                            }
                                          },
                                          classificado: classificado,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('NENHUM CLASSIFICADO CADASTRADO!'),
                              );
                            }
                          }),
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
      floatingActionButton: ServiceStorage.getUserTypeId() == 4
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFFF6B00),
                onPressed: () async {
                  await controller.getQuantityLicences();
                  if (controller.classificadosCadastrados.value >=
                      controller.postsPermitidos.value) {
                    Get.snackbar('Atenção!',
                        'A quantidade de licenças do seu plano estourou!',
                        backgroundColor: Colors.orange,
                        colorText: Colors.black,
                        duration: const Duration(seconds: 2),
                        snackPosition: SnackPosition.BOTTOM);
                  } else {
                    controller.clearAllFields();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const CreateClassifiedModal(
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
