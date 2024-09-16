// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/classified_controller.dart';
import 'package:rodocalc/app/data/controllers/comission_indicator_controller.dart';
import 'package:rodocalc/app/data/controllers/course_controller.dart';
import 'package:rodocalc/app/data/controllers/document_controller.dart';
import 'package:rodocalc/app/data/controllers/freight_controller.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
import 'package:rodocalc/app/data/controllers/indicator_controller.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
import 'package:rodocalc/app/data/controllers/perfil_controller.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/controllers/user_controller.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/modules/global/bottom_navigation.dart';
import 'package:rodocalc/app/modules/home/widgets/custom_home_card.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final vehicleController = Get.put(VehicleController());
  final transactionController = Get.put(TransactionController());
  final indicationController = Get.put(IndicationController());
  final perfilController = Get.put(PerfilController());
  final documentController = Get.put(DocumentController());
  final freightController = Get.put(FreightController());
  final planController = Get.put(PlanController());
  final coursesController = Get.put(CourseController());
  final classifiedsController = Get.put(ClassifiedController());
  final comissionIndicatorController = Get.put(ComissionIndicatorController());
  final userController = Get.put(UserController());
  final tripController = Get.put(TripController());
  final cityController = Get.put(CityStateController());

  @override
  Widget build(BuildContext context) {
    transactionController.getSaldo();

    return Scaffold(
      backgroundColor: Colors.grey,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double screenHeight = constraints.maxHeight;
          double topPosition = screenHeight * 0.56;

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(300),
                  child: AppBar(
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 40.0, horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                    width: 200,
                                    height: 60,
                                    child: Image.asset(
                                        'assets/images/logo_horizontal.png')),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Obx(() => Text(
                                                'Olá, ${controller.nomeUser}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontFamily: 'Inter-Black',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ),
                                        const SizedBox(width: 5),
                                        Obx(() => CircleAvatar(
                                              radius: 30,
                                              backgroundImage: controller
                                                          .userPhoto
                                                          .value
                                                          .isNotEmpty ||
                                                      controller.userPhoto
                                                              .value ==
                                                          null
                                                  ? CachedNetworkImageProvider(
                                                          "$urlImagem/storage/fotos/users/${controller.userPhoto.value}")
                                                      as ImageProvider
                                                  : const NetworkImage(
                                                      'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352156-stock-illustration-default-placeholder-profile-icon.jpg'),
                                            )),
                                        PopupMenuButton<String>(
                                          color: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                          iconColor: Colors.white,
                                          onSelected: (String value) {
                                            switch (value) {
                                              case 'Perfil':
                                                cityController.getCities();
                                                perfilController.fillInFields();
                                                Get.toNamed(Routes.perfil);
                                                break;
                                              case 'Adicionar usuário':
                                                userController.getMyEmployees();
                                                Get.toNamed(Routes.user);
                                                break;
                                              case 'Sair':
                                                final loginController =
                                                    Get.put(LoginController());
                                                loginController.logout();
                                                break;
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            List<Map<String, dynamic>> choices =
                                                [
                                              {
                                                'text': 'Perfil',
                                                'icon': Icons.person
                                              },
                                              {
                                                'text': 'Sair',
                                                'icon': Icons.logout
                                              },
                                            ];

                                            // Adiciona 'Adicionar usuário' apenas se o tipo de usuário for 3
                                            if (ServiceStorage
                                                    .getUserTypeId() ==
                                                3) {
                                              choices.insert(1, {
                                                'text': 'Adicionar usuário',
                                                'icon': Icons.add
                                              });
                                            }

                                            return choices.map((choice) {
                                              return PopupMenuItem<String>(
                                                value: choice['text'],
                                                child: ListTile(
                                                  leading: Icon(choice['icon'],
                                                      color: Colors.black),
                                                  title: Text(
                                                    choice['text'],
                                                    style: const TextStyle(
                                                        fontFamily: 'Poppins'),
                                                  ),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                "Veículo: ${ServiceStorage.titleSelectedVehicle()} - Motorista: ${ServiceStorage.motoristaSelectedVehicle()}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Card(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: !ServiceStorage
                                              .existsSelectedVehicle()
                                          ? const AssetImage(
                                                  'assets/images/caminhao.jpg')
                                              as ImageProvider
                                          : NetworkImage(
                                              "$urlImagem/storage/fotos/veiculos/${ServiceStorage.photoSelectedVehicle()}",
                                            ),
                                    ),
                                    const SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 8,
                                          right: 18),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Saldo do caminhão',
                                            style: TextStyle(
                                                fontFamily: 'Inter-Regular',
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          Obx(() {
                                            return Text(
                                              "R\$ ${FormattedInputers.formatValuePTBR(transactionController.balance.value)}",
                                              style: TextStyle(
                                                  color: transactionController
                                                              .balance.value ==
                                                          0
                                                      ? Colors.black
                                                      : (transactionController
                                                                  .balance
                                                                  .value <
                                                              0
                                                          ? Colors.red
                                                          : Colors.green),
                                                  fontSize: 24,
                                                  fontFamily: 'Inter-Black'),
                                            );
                                          }),
                                          Obx(() {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .58,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  '${transactionController.variacaoEntradas} entradas (em comparação ao mês anterior)',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Inter-Regular',
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomHomeCard(
                                      imagePath: 'assets/images/caminhao.png',
                                      label: 'Caminhões',
                                      onTap: () {
                                        vehicleController.isLoading.value =
                                            false;
                                        vehicleController.getAll();
                                        Get.toNamed(Routes.vehicle);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    if (ServiceStorage.getUserTypeId() !=
                                        4) ...[
                                      CustomHomeCard(
                                        imagePath: 'assets/images/frete.png',
                                        label: 'Financeiro',
                                        onTap: () {
                                          transactionController.getAll();
                                          transactionController.getSaldo();
                                          Get.toNamed(Routes.financial);
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                    if (ServiceStorage.getUserTypeId() !=
                                        4) ...[
                                      CustomHomeCard(
                                        imagePath: 'assets/images/estrada.png',
                                        label: 'Fretes',
                                        onTap: () {
                                          freightController.getAll();
                                          Get.toNamed(Routes.freight);
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                    CustomHomeCard(
                                      imagePath: 'assets/images/trecho.png',
                                      label: 'Trechos',
                                      onTap: () {
                                        tripController.getAll();
                                        Get.toNamed(Routes.trip);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      imagePath: 'assets/images/documento.png',
                                      label: 'Documentos',
                                      onTap: () {
                                        documentController.getAll();
                                        Get.toNamed(Routes.document);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      imagePath: 'assets/images/indicador.png',
                                      label: 'Indicador',
                                      onTap: () {
                                        comissionIndicatorController
                                            .getAllToReceive();
                                        comissionIndicatorController
                                            .getExistsPedidoSaque();
                                        indicationController.getAll();
                                        Get.toNamed(Routes.indicator);
                                      },
                                    ),
                                    if (ServiceStorage.getUserTypeId() !=
                                        4) ...[
                                      const SizedBox(width: 5),
                                      CustomHomeCard(
                                        imagePath: 'assets/images/plano.png',
                                        label: 'Planos',
                                        onTap: () {
                                          planController.getAll();
                                          planController.getMyPlans();
                                          Get.toNamed(Routes.plan);
                                        },
                                      ),
                                    ],
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      imagePath: 'assets/images/classific.png',
                                      label: 'Classificados',
                                      onTap: () {
                                        classifiedsController.getAll();
                                        Get.toNamed(Routes.classified);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      imagePath: 'assets/images/curso.png',
                                      label: 'Cursos',
                                      onTap: () {
                                        coursesController.getAll();
                                        Get.toNamed(Routes.course);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  return await controller.getLast();
                },
                child: Positioned(
                  top: topPosition,
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: Card(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Últimas movimentações',
                                style: TextStyle(
                                    fontSize: 18.0, fontFamily: 'Inter-Bold'),
                              ),
                              IconButton(
                                  onPressed: () {
                                    transactionController.getAll();
                                    transactionController.getSaldo();
                                    controller.getLast();
                                    Get.toNamed(Routes.financial);
                                  },
                                  icon: const Icon(Icons.arrow_circle_right))
                            ],
                          ),
                          Obx(() => Column(
                                children: controller
                                        .listLastTransactions.isNotEmpty
                                    ? controller.listLastTransactions
                                        .map((transaction) {
                                        String stringValor = "";
                                        String subtitulo = "";
                                        if (transaction.tipoTransacao ==
                                            'saida') {
                                          stringValor =
                                              "-R\$ ${FormattedInputers.formatValuePTBR(transaction.valor)}";
                                          subtitulo =
                                              "${transaction.expenseCategory?.descricao}";
                                        } else {
                                          stringValor =
                                              "+R\$ ${FormattedInputers.formatValuePTBR(transaction.valor)}";
                                          subtitulo =
                                              "${transaction.origem}/${transaction.destino}";
                                        }

                                        return Card(
                                          surfaceTintColor: Colors.white,
                                          color: Colors.white,
                                          elevation: 0,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Primeira coluna
                                                  Expanded(
                                                    flex: 2,
                                                    // Controla a proporção de espaço ocupado
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          transaction
                                                                  .descricao ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // Usa "..." no final do texto
                                                          maxLines: 1,
                                                          // Limita o texto a uma linha
                                                          style: TextStyle(
                                                              fontSize:
                                                                  16), // Ajusta o tamanho da fonte, se necessário
                                                        ),
                                                        Text(
                                                          subtitulo,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // Usa "..." no final do texto, se necessário
                                                          maxLines: 1,
                                                          // Limita o texto a uma linha
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey), // Estilo para subtítulo
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Segunda coluna (lado direito)
                                                  Expanded(
                                                    flex: 1,
                                                    // Controla a proporção de espaço ocupado
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          stringValor,
                                                          style: TextStyle(
                                                            color: transaction
                                                                        .tipoTransacao ==
                                                                    'saida'
                                                                ? Colors.red
                                                                : Colors.green,
                                                          ),
                                                        ),
                                                        Text(
                                                          FormattedInputers
                                                              .formatApiDate(
                                                                  transaction
                                                                      .data!),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        );
                                      }).toList()
                                    : [],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (controller.diasRestantes.value <= 5 &&
                    controller.diasRestantes.value >= 0) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    child: WidgetPlan(
                      titulo:
                          "${controller.diasRestantes.value} dia(s) restante(s) para o vencimento!",
                      data: controller.dataVencimento.value,
                    ),
                  );
                } else {
                  return Container(); // Retorna um widget vazio
                }
              }),
            ],
          );
        },
      ),
    );
  }
}
