import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/user_plan_model.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/modules/financial/widgets/create_expense_modal.dart';
import 'package:rodocalc/app/modules/financial/widgets/create_receipt_modal.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:rodocalc/app/utils/services.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FinancialView extends GetView<TransactionController> {
  const FinancialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text('FINANCEIRO',
                  style: TextStyle(
                    fontFamily: 'Inter-Black',
                  )),
              Text(
                ServiceStorage.titleSelectedVehicle().toUpperCase(),
                style:
                    const TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
              ),
              const SizedBox(height: 5),
              Text(
                "MOTORISTA: ${ServiceStorage.motoristaSelectedVehicle()}"
                    .toUpperCase(),
                style:
                    const TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
              ),
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
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.find<HomeController>().getLast();
                  Get.back();
                },
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return await controller.getAll();
          },
          child: Stack(
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
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                margin: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildSearchBar(controller),
                    _buildTransactionList(controller),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildReceiveAndExpense()),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 5),
              child: FloatingActionButton(
                heroTag: "export_excel",
                backgroundColor: Colors.green.shade300,
                mini: true,
                onPressed: () async {
                  final planController = Get.put(PlanController());
                  await planController.getMyPlans();
                  List<UserPlan> listplan = planController.myPlans();
                  await controller.exportToExcel();
                  if (listplan.isNotEmpty) {
                    if (planController.myPlans.first.plano!.id == 14 ||
                        planController.myPlans.first.plano!.id == 15) {
                      await controller.exportToExcel();
                    } else {
                      Get.snackbar(
                          'Erro', "Atualize o plano para usar esse recurso!",
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  } else {
                    Get.snackbar(
                        'Erro', "Atualize o plano para usar esse recurso!",
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Icon(
                  FontAwesomeIcons.fileLines,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 5),
              child: FloatingActionButton(
                heroTag: "export_pdf",
                backgroundColor: Colors.grey.shade300,
                mini: true,
                onPressed: () async {
                  final planController = Get.put(PlanController());
                  await planController.getMyPlans();
                  List<UserPlan> listplan = planController.myPlans();
                  if (listplan.isNotEmpty) {
                    if (planController.myPlans.first.plano!.id == 14 ||
                        planController.myPlans.first.plano!.id == 15) {
                      await controller.generateAndSharePdf();
                    } else {
                      Get.snackbar(
                          'Erro', "Atualize o plano para usar esse recurso!",
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  } else {
                    Get.snackbar(
                        'Erro', "Atualize o plano para usar esse recurso!",
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Icon(Icons.download),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 36),
              child: SpeedDial(
                childrenButtonSize: const Size(55, 55),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFFF6B00),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                isOpenOnStart: false,
                animatedIcon: AnimatedIcons.menu_close,
                buttonSize: const Size(50, 50),
                children: [
                  if (ServiceStorage.getUserTypeId() != 4) ...[
                    SpeedDialChild(
                      backgroundColor: Colors.green.shade600,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.attach_money_rounded,
                          color: Colors.white,
                        ),
                      ),
                      label: 'ADICIONAR RECEBIMENTO',
                      labelStyle: const TextStyle(fontFamily: "Inter-Black"),
                      onTap: () {
                        Vehicle v = ServiceStorage.getVehicleStorage();
                        if (v.isEmpty()) {
                          Get.snackbar(
                              'Atenção!', 'Selecione um veículo antes!',
                              backgroundColor: Colors.orange,
                              colorText: Colors.black,
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM);
                        } else {
                          final cityController = Get.put(CityStateController());
                          cityController.getCities();
                          controller.clearAllFields();
                          controller.getMyChargeTypes();
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => CreateReceiptModal(
                              isUpdate: false,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                  SpeedDialChild(
                    backgroundColor: Colors.red.shade600,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.money_off_csred_rounded,
                        color: Colors.white,
                      ),
                    ),
                    label: 'ADICIONAR DESPESA',
                    labelStyle: const TextStyle(fontFamily: "Inter-Black"),
                    onTap: () {
                      Vehicle v = ServiceStorage.getVehicleStorage();
                      if (v.isEmpty()) {
                        Get.snackbar('Atenção!', 'Selecione um veículo antes!',
                            backgroundColor: Colors.orange,
                            colorText: Colors.black,
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        final cityController = Get.put(CityStateController());
                        cityController.getCities();
                        controller.clearAllFields();
                        final transactionController =
                            Get.put(TransactionController());

                        transactionController.getMyCategories();
                        //transactionController.getMySpecifics();

                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => CreateExpenseModal(
                            isUpdate: false,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildReceiveAndExpense() {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Card(
        color: Colors.black,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text(
                    "Entradas",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Obx(() {
                    return Text(
                        "R\$${FormattedInputers.formatValuePTBR(Services.totalRecebimentos.value)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green));
                  }),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Saídas",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Obx(() {
                    return Text(
                      "R\$${FormattedInputers.formatValuePTBR(Services.totalGastos.value)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 3,
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('SALDO ATUAL',
                    style: TextStyle(fontSize: 18, fontFamily: 'Inter-Black')),
                Obx(
                  () {
                    Color c = controller.balance.value == 0
                        ? Colors.black
                        : (controller.balance.value > 0
                            ? Colors.green
                            : Colors.red);
                    return Text(
                      'R\$${FormattedInputers.formatValuePTBR(controller.balance.value)}',
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Inter-Black', color: c),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(TransactionController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.startDateController,
                  decoration: const InputDecoration(
                    hintText: 'DATA INICIAL',
                    prefixIcon: Icon(Icons.date_range),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    fillColor: Colors.transparent,
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      locale: const Locale('pt', 'BR'),
                    );
                    if (pickedDate != null) {
                      controller.startDateController.text =
                          FormattedInputers.formatDate2(pickedDate);
                      if (controller.endDateController.text.isNotEmpty) {
                        DateTime endDate = FormattedInputers.parseDate(
                            controller.endDateController.text);
                        if (pickedDate.isAfter(endDate)) {
                          Get.snackbar('Erro',
                              'A data inicial não pode ser maior que a data final',
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          controller.startDateController.clear();
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: controller.endDateController,
                  decoration: const InputDecoration(
                    hintText: 'DATA FINAL',
                    prefixIcon: Icon(Icons.date_range),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    fillColor: Colors.transparent,
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      if (controller.endDateController.text.isNotEmpty) {
                        DateTime startDate = FormattedInputers.parseDate(
                            controller.endDateController.text);
                        if (pickedDate.isBefore(startDate)) {
                          Get.snackbar('Erro',
                              'A data final não pode ser menor que a data inicial',
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          controller.endDateController.clear();
                        } else {
                          controller.endDateController.text =
                              FormattedInputers.formatDate2(pickedDate);
                        }
                      } else {
                        controller.endDateController.text =
                            FormattedInputers.formatDate2(pickedDate);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 45,
            child: TextFormField(
              controller: controller.txtDescriptionFilterController,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                labelText: 'Pesquisar',
                suffixIcon: IconButton(
                  onPressed: () {
                    if ((controller.startDateController.text.isNotEmpty &&
                            controller.endDateController.text.isNotEmpty) ||
                        controller
                            .txtDescriptionFilterController.text.isNotEmpty) {
                      controller.getTransactionsWithFilter();
                    } else {
                      Get.snackbar('Atenção!',
                          'Selecione data inicial e final, ou uma descrição!',
                          backgroundColor: Colors.orange,
                          colorText: Colors.black,
                          duration: const Duration(seconds: 2),
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Obx(() {
            return controller.tituloSearchTransactions.value.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(controller.tituloSearchTransactions.value,
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  )
                : const SizedBox();
          })
        ],
      ),
    );
  }

  Widget _buildTransactionList(TransactionController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Carregando...'),
              SizedBox(height: 20.0),
              CircularProgressIndicator(
                value: 5,
              ),
            ],
          ),
        );
      } else if (!controller.isLoading.value &&
          controller.listTransactions.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(
                left: 16, top: 16, right: 16, bottom: 130),
            itemCount: controller.listTransactions.length,
            itemBuilder: (context, index) {
              final transaction = controller.listTransactions[index];
              bool isTrecho = transaction.origemTransacao != 'FINANCEIRO';
              return InkWell(
                splashColor: Colors.grey.shade50,
                onTap: () {
                  if (isTrecho) {
                    Get.snackbar('Atenção',
                        "Abra o menu de trechos para alterar esta transação!",
                        colorText: Colors.black,
                        backgroundColor: Colors.orange,
                        snackPosition: SnackPosition.BOTTOM);
                  } else {
                    final cityController = Get.put(CityStateController());
                    cityController.getCities();
                    controller.clearAllFields();
                    controller.fillInFields(transaction);
                    controller.getMyCategories();
                    controller.getMyChargeTypes();
                    controller.getMySpecifics(
                        controller.selectedCategoryCadSpecificType.value!);
                    if (transaction.tipoTransacao == 'entrada') {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => CreateReceiptModal(
                          isUpdate: true,
                          idTransaction: transaction.id!,
                        ),
                      );
                    } else if (transaction.tipoTransacao == 'saida') {
                      final transactionController =
                          Get.put(TransactionController());
                      transactionController.getMyCategories();
                      transactionController.getMySpecifics(transactionController
                          .selectedCategoryCadSpecificType.value!);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => CreateExpenseModal(
                          isUpdate: true,
                          idTransaction: transaction.id,
                        ),
                      );
                    }
                  }
                },
                child: _buildTimelineTile(transaction, context),
              );
            },
          ),
        );
      } else {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              'NÃO HÁ TRANSAÇÕES!',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        );
      }
    });
  }

  Widget _buildTimelineTile(Transacoes transaction, BuildContext context) {
    String stringValor = "";
    String stringTitulo = "";
    late Color cor;
    bool isEntrada = transaction.tipoTransacao == 'entrada';
    bool isFinanceiro = transaction.origemTransacao == 'FINANCEIRO';

    stringTitulo = isFinanceiro
        ? (isEntrada
            ? "${transaction.descricao?.toUpperCase() ?? 'SEM DESCRIÇÃO'}: "
                "${transaction.origem?.toUpperCase() ?? 'N/A'}/"
                "${transaction.destino?.toUpperCase() ?? 'N/A'}"
            : "${transaction.expenseCategory?.descricao?.toUpperCase() ?? 'SEM CATEGORIA'} - "
                "${transaction.specificTypeExpense?.descricao?.toUpperCase() ?? 'SEM TIPO'}")
        : "${transaction.descricao?.toUpperCase() ?? 'SEM DESCRIÇÃO'} - TRECHO";

    stringValor =
        "${isEntrada ? "+" : "-"}R\$ ${FormattedInputers.formatValuePTBR(transaction.valor ?? 0)}";

    cor = isEntrada ? Colors.green : Colors.red;

    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: false,
      indicatorStyle: const IndicatorStyle(
          width: 20,
          indicatorXY: 0.4,
          indicator: Icon(
            Icons.circle_outlined,
            size: 20,
            color: Colors.grey,
          ),
          padding: EdgeInsets.only(top: 3, bottom: 3)),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FormattedInputers.formatApiDate(transaction.data!),
                    style: TextStyle(
                        fontFamily: 'Inter-Bold', fontSize: 14, color: cor),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      stringTitulo,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Inter-Bold', fontSize: 12, color: cor),
                    ),
                  ),
                  Services.isNull(transaction.km.toString())
                      ? const SizedBox()
                      : Text(
                          "QUILOMETRAGEM",
                          style: TextStyle(
                            fontFamily: 'Inter-Regular',
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                  Text(
                    "CÓDIGO",
                    style: TextStyle(
                        fontFamily: 'Inter-Regular', fontSize: 12, color: cor),
                  ),
                  Text(
                    'SALDO',
                    style: TextStyle(
                        fontFamily: 'Inter-Regular', fontSize: 12, color: cor),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    stringValor,
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                      fontSize: 14,
                      color: cor,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 15),
                      Services.isNull(transaction.km.toString())
                          ? const SizedBox()
                          : Text(
                              transaction.km.toString(),
                              style: TextStyle(
                                fontFamily: 'Inter-Regular',
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                      Text(
                        transaction.id.toString().padLeft(5, '0'),
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 12,
                          color: cor,
                        ),
                      ),
                      Text(
                        'R\$ ${FormattedInputers.formatValuePTBR(transaction.saldo!)}',
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 12,
                          color: cor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      beforeLineStyle: const LineStyle(
        color: Colors.grey,
        thickness: 2,
      ),
    );
  }
}
