// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:rodocalc/app/data/controllers/signup_controller.dart';
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
                            child: (!ServiceStorage.existsSelectedVehicle() ||
                                    ServiceStorage.photoSelectedVehicle() == "")
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                        width: 200,
                                        height: 60,
                                        child: Image.asset(
                                            'assets/images/logo_horizontal.png')),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(
                                        CupertinoIcons.ellipsis_vertical),
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    iconColor: Colors.white,
                                    onSelected: (String value) async {
                                      switch (value) {
                                        case 'PERFIL':
                                          cityController.getCities();
                                          perfilController.fillInFields();

                                          final signupController =
                                              Get.put(SignUpController());
                                          signupController.getUserTypes();

                                          Get.toNamed(Routes.perfil);
                                          break;
                                        case 'ADICIONAR USUÁRIO':
                                          Map<String, dynamic> verifyPlan =
                                              await planController.verifyPlan();
                                          if (verifyPlan['exists_plan'] ==
                                              false) {
                                            Get.snackbar(
                                              'Atenção!',
                                              'Seu plano expirou e/ou nåo contempla esse módulo!',
                                              backgroundColor:
                                                  const Color(0xFFFF6B00),
                                              colorText: Colors.white,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          } else if (verifyPlan[
                                                  'vehicles_registered'] <=
                                              0) {
                                            Get.snackbar(
                                              'Atenção!',
                                              'Adicione um veículo antes!',
                                              backgroundColor:
                                                  const Color(0xFFFF6B00),
                                              colorText: Colors.white,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          } else {
                                            userController.getMyEmployees();
                                            Get.toNamed(Routes.user);
                                          }

                                          break;
                                        case 'SAIR':
                                          final loginController =
                                              Get.put(LoginController());
                                          loginController.logout();
                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      List<Map<String, dynamic>> choices = [
                                        {
                                          'text': 'PERFIL',
                                          'icon': Icons.person
                                        },
                                        {'text': 'SAIR', 'icon': Icons.logout},
                                      ];

                                      // Adiciona 'Adicionar usuário' apenas se o tipo de usuário for 3
                                      if (ServiceStorage.getUserTypeId() == 3) {
                                        choices.insert(1, {
                                          'text': 'ADICIONAR USUÁRIO',
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
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Obx(() => Text(
                                                'Olá, ${controller.nomeUser}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontFamily: 'Inter-Black',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ),
                                        const SizedBox(width: 5),
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              cityController.getCities();
                                              perfilController.fillInFields();

                                              final signupController =
                                                  Get.put(SignUpController());
                                              signupController.getUserTypes();

                                              Get.toNamed(Routes.perfil);
                                            },
                                            child: CircleAvatar(
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
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(height: 40),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "VEICÚLO: ${ServiceStorage.titleSelectedVehicle()} - MOTORISTA: ${ServiceStorage.motoristaSelectedVehicle()}"
                                      .toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
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
                                    const SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: (!ServiceStorage
                                                  .existsSelectedVehicle() ||
                                              ServiceStorage
                                                      .photoSelectedVehicle() ==
                                                  "")
                                          ? const AssetImage(
                                                  'assets/images/caminhao.jpg')
                                              as ImageProvider
                                          : NetworkImage(
                                              "$urlImagem/storage/fotos/veiculos/${ServiceStorage.photoSelectedVehicle()}",
                                            ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      // Aqui usamos Expanded para que a Column ocupe o espaço disponível.
                                      child: Padding(
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
                                              'Saldo do veículo',
                                              style: TextStyle(
                                                fontFamily: 'Inter-Regular',
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                            if (ServiceStorage
                                                    .getUserTypeId() ==
                                                4) ...[
                                              const SizedBox(
                                                  child: Icon(Icons.lock)),
                                            ] else ...[
                                              Obx(() {
                                                return SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    "R\$${FormattedInputers.formatValuePTBR(transactionController.balance.value)}",
                                                    style: TextStyle(
                                                      color: transactionController
                                                                  .balance
                                                                  .value ==
                                                              0
                                                          ? Colors.black
                                                          : (transactionController
                                                                      .balance
                                                                      .value <
                                                                  0
                                                              ? Colors.red
                                                              : Colors.green),
                                                      fontSize: 24,
                                                      fontFamily: 'Inter-Black',
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
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
                                                      fontFamily:
                                                          'Inter-Regular',
                                                      fontSize: 9.3,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                      color: ServiceStorage.isRotaPermitida(
                                              "vehicle")
                                          ? const Color(0xFFFF6B00)
                                          : Colors.grey.shade700,
                                      imagePath: 'assets/images/caminhao.png',
                                      label: 'Veículos',
                                      onTap: () async {
                                        Map<String, dynamic> verifyPlan =
                                            await planController.verifyPlan();

                                        if (verifyPlan['exists_plan'] == true &&
                                            ServiceStorage.isRotaPermitida(
                                                "vehicle")) {
                                          vehicleController.isLoading.value =
                                              false;
                                          vehicleController.getAll();
                                          Get.toNamed(Routes.vehicle);
                                        } else {
                                          snackExistsPlan();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    if (ServiceStorage.getUserTypeId() !=
                                        4) ...[
                                      CustomHomeCard(
                                        color: ServiceStorage.isRotaPermitida(
                                                "financial")
                                            ? const Color(0xFFFF6B01)
                                            : Colors.grey.shade700,
                                        imagePath: 'assets/images/frete.png',
                                        label: 'Financeiro',
                                        onTap: () async {
                                          Map<String, dynamic> verifyPlan =
                                              await planController.verifyPlan();

                                          if (verifyPlan['exists_plan'] ==
                                                  true &&
                                              ServiceStorage.isRotaPermitida(
                                                  "financial")) {
                                            transactionController.getAll();
                                            transactionController.getSaldo();
                                            Get.toNamed(Routes.financial);
                                          } else {
                                            snackExistsPlan();
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                    if (ServiceStorage.getUserTypeId() !=
                                        4) ...[
                                      CustomHomeCard(
                                        color: ServiceStorage.isRotaPermitida(
                                                "freight")
                                            ? const Color(0xFFFF6B00)
                                            : Colors.grey.shade700,
                                        imagePath: 'assets/images/estrada.png',
                                        label: 'Fretes',
                                        onTap: () async {
                                          Map<String, dynamic> verifyPlan =
                                              await planController.verifyPlan();
                                          if (verifyPlan['exists_plan'] &&
                                              ServiceStorage.isRotaPermitida(
                                                  "freight")) {
                                            freightController.getAll();
                                            Get.toNamed(Routes.freight);
                                          } else {
                                            snackExistsPlan();
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                    CustomHomeCard(
                                      color:
                                          ServiceStorage.isRotaPermitida("trip")
                                              ? const Color(0xFFFF6B00)
                                              : Colors.grey.shade700,
                                      imagePath: 'assets/images/trecho.png',
                                      label: 'Trechos',
                                      onTap: () async {
                                        Map<String, dynamic> verifyPlan =
                                            await planController.verifyPlan();

                                        if (verifyPlan['exists_plan'] &&
                                            ServiceStorage.isRotaPermitida(
                                                "trip")) {
                                          tripController.getAll();
                                          tripController.clearAllFields();
                                          Get.toNamed(Routes.trip);
                                        } else {
                                          snackExistsPlan();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      color: ServiceStorage.isRotaPermitida(
                                              "document")
                                          ? const Color(0xFFFF6B00)
                                          : Colors.grey.shade700,
                                      imagePath: 'assets/images/documento.png',
                                      label: 'Documentos',
                                      onTap: () async {
                                        Map<String, dynamic> verifyPlan =
                                            await planController.verifyPlan();
                                        if (verifyPlan['exists_plan'] == true &&
                                            ServiceStorage.isRotaPermitida(
                                                "document")) {
                                          documentController.getAll();
                                          Get.toNamed(Routes.document);
                                        } else {
                                          snackExistsPlan();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      color: Colors.green,
                                      imagePath: 'assets/images/cifra.png',
                                      label: 'Indicações',
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
                                        color: const Color(0xFFFF6B00),
                                        imagePath: 'assets/images/plano.png',
                                        label: 'Planos',
                                        onTap: () async {
                                          await planController.getAll();
                                          await planController.getMyPlans();
                                          if (planController.myPlans.isEmpty) {
                                            Get.toNamed(Routes.plan);
                                          } else {
                                            Get.toNamed(Routes.newplanview);
                                          }
                                        },
                                      ),
                                    ],
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      color: ServiceStorage.isRotaPermitida(
                                              "classified")
                                          ? const Color(0xFFFF6B00)
                                          : Colors.grey.shade700,
                                      imagePath: 'assets/images/classific.png',
                                      label: 'Classificados',
                                      onTap: () async {
                                        Map<String, dynamic> verifyPlan =
                                            await planController.verifyPlan();
                                        if (verifyPlan['exists_plan'] == true &&
                                            ServiceStorage.isRotaPermitida(
                                                "classified")) {
                                          classifiedsController.getAll();
                                          Get.toNamed(Routes.classified);
                                        } else {
                                          snackExistsPlan();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    CustomHomeCard(
                                      color: ServiceStorage.isRotaPermitida(
                                              "course")
                                          ? const Color(0xFFFF6B00)
                                          : Colors.grey.shade700,
                                      imagePath: 'assets/images/curso.png',
                                      label: 'Cursos',
                                      onTap: () async {
                                        Map<String, dynamic> verifyPlan =
                                            await planController.verifyPlan();
                                        if (verifyPlan['exists_plan'] == true &&
                                            ServiceStorage.isRotaPermitida(
                                                "course")) {
                                          coursesController.getAll();
                                          Get.toNamed(Routes.course);
                                        } else {
                                          snackExistsPlan();
                                        }
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
                  if (ServiceStorage.getUserTypeId() == 4) {
                    return await controller.getLastExpenseTrip();
                  } else {
                    return await controller.getLast();
                  }
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
                              Text(
                                'Últimas movimentações',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontFamily: 'Inter-Bold'),
                              ),
                              if (ServiceStorage.getUserTypeId() != 4 &&
                                  controller.diasRestantes > 0) ...[
                                IconButton(
                                  onPressed: () {
                                    transactionController.getAll();
                                    transactionController.getSaldo();
                                    controller.getLast();
                                    Get.toNamed(Routes.financial);
                                  },
                                  icon: const Icon(Icons.arrow_circle_right),
                                )
                              ]
                            ],
                          ),
                          Obx(
                            () {
                              if (ServiceStorage.getUserTypeId() == 4) {
                                return Column(
                                  children:
                                      controller.listLastExpenseTrip.isNotEmpty
                                          ? controller.listLastExpenseTrip
                                              .map((expenseTrip) {
                                              String stringValor = "";
                                              String subtitulo = "";

                                              stringValor =
                                                  "-R\$ ${FormattedInputers.formatValuePTBR((expenseTrip.valorDespesa! / 100).toString())}";
                                              subtitulo =
                                                  "${expenseTrip.origem}-${expenseTrip.destino}";

                                              return Card(
                                                surfaceTintColor: Colors.white,
                                                color: Colors.white,
                                                elevation: 0,
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                                          flex: 1,
                                                          // Controla a proporção de espaço ocupado
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                expenseTrip
                                                                        .descricao ??
                                                                    "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                              SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Text(
                                                                  subtitulo,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
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
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              Text(
                                                                FormattedInputers
                                                                    .formatApiDate(
                                                                        expenseTrip
                                                                            .dataHora!),
                                                                style: const TextStyle(
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
                                );
                              } else {
                                return Column(
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
                                            if (transaction.origemTransacao ==
                                                'FINANCEIRO') {
                                              subtitulo =
                                                  "${transaction.origem}/${transaction.destino}";
                                            } else {
                                              subtitulo = "RECEBIMENTO TRECHO";
                                            }
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
                                                      flex: 1,
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
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                          SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Text(
                                                              subtitulo,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
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
                                                                  : Colors
                                                                      .green,
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
                                );
                              }
                            },
                          ),
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
                } else if (controller.diasRestantes.value <= 2 &&
                    controller.diasRestantes.value >= 0) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    child: WidgetPlan(
                      planController: planController,
                      titulo: "Renove seu plano.",
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

  void snackExistsPlan() {
    Get.snackbar(
      'Atenção!',
      'Seu plano expirou e/ou nåo contempla esse módulo!',
      backgroundColor: const Color(0xFFFF6B00),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
