import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_expense_trip_modal.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_trip_modal.dart';
import 'package:rodocalc/app/modules/trip/widgets/custom_trip_card.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class TripView extends GetView<TripController> {
  const TripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('TRECHOS',
                style: TextStyle(
                  fontFamily: 'Inter-Black',
                )),
            Text(
              ServiceStorage.titleSelectedVehicle(),
              style: const TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50, right: 20),
            child: Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
        flexibleSpace: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.darken,
                ),
                child: !ServiceStorage.existsSelectedVehicle()
                    ? Image.asset(
                        'assets/images/caminhao.jpg',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "$urlImagem/storage/fotos/veiculos/${ServiceStorage.photoSelectedVehicle()}",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: Stack(children: [
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 5),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(Icons.search_rounded),
                      labelText: 'PESQUISAR TRECHOS',
                    ),
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
                        controller.listTrip.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.listTrip.length,
                        itemBuilder: (context, index) {
                          Trip trip = controller.listTrip[index];
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            confirmDismiss: (DismissDirection direction) async {
                              controller.clearAllFields();
                              if (direction == DismissDirection.endToStart) {
                                showDialog(context, trip, controller);
                              }
                              if (direction == DismissDirection.startToEnd) {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => CreateExpenseTripModal(
                                    isUpdate: false,
                                    trip: trip,
                                  ),
                                );
                              }
                              return false;
                            },
                            secondaryBackground: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            background: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_rounded,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'LANÇAR DESPESA',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            child: CustomTripCard(
                              trip: trip,
                              functionEdit: () {
                                controller.fillInFields(trip);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => CreateTripModal(
                                    isUpdate: true,
                                    trip: trip,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('Nenhum veículo encontrado!'),
                      );
                    }
                  }),
                ]),
              ),
            ),
          )
        ])),
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF6B00),
          onPressed: () {
            if (ServiceStorage.idSelectedVehicle() == null ||
                ServiceStorage.idSelectedVehicle() <= 0) {
              Get.snackbar('Atenção', 'Selecione um veículo antes!',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM);
            } else {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => const CreateTripModal(isUpdate: false),
              );
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void showDialog(context, Trip trip, TripController controller) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir o calculo selecionado?",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno = await controller.deleteTrip(trip.id!);

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
