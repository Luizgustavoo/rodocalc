import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/modules/financial/widgets/create_expense_modal.dart';
import 'package:rodocalc/app/modules/financial/widgets/create_receipt_modal.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
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
                ServiceStorage.titleSelectedVehicle(),
                style:
                    const TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
              ),
              Text(
                "Motorista: ${ServiceStorage.motoristaSelectedVehicle()}",
                style:
                    const TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
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
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: SpeedDial(
            childrenButtonSize: const Size(55, 55),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFFF6B00),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      Get.snackbar('Atenção!', 'Selecione um veículo antes!',
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
                    transactionController.getMySpecifics();

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
        ));
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Saldo Atual',
                  style: TextStyle(fontSize: 18, fontFamily: 'Inter-Bold')),
              const SizedBox(width: 5),
              Obx(
                () {
                  Color c = controller.balance.value == 0
                      ? Colors.black
                      : (controller.balance.value > 0
                          ? Colors.green
                          : Colors.red);
                  return Text(
                    'R\$ ${FormattedInputers.formatValuePTBR(controller.balance.value)}',
                    style: TextStyle(
                        fontSize: 22, fontFamily: 'Inter-Black', color: c),
                  );
                },
              ),
            ],
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
          //INICIA AQUI

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Data Inicial',
                    prefixIcon: Icon(Icons.date_range),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    filled: true,
                    fillColor: Colors.transparent,
                    // Altere para a cor desejada
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Cor da borda inferior
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.5), // Cor da borda quando focado
                    ),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    filled: true,
                    labelText: 'Data Final',
                    prefixIcon: Icon(Icons.date_range),
                    fillColor: Colors.transparent,
                    // Altere para a cor desejada
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // Cor da borda inferior
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.5), // Cor da borda quando focado
                    ),
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
                      if (controller.startDateController.text.isNotEmpty) {
                        DateTime startDate = FormattedInputers.parseDate(
                            controller.startDateController.text);
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

          //FINALIZA AQUI

          const SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 40,
            child: TextFormField(
              controller: controller.txtDescriptionFilterController,
              decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  suffixIcon: IconButton(
                      onPressed: () {
                        if ((controller.startDateController.text.isNotEmpty &&
                                controller.endDateController.text.isNotEmpty) ||
                            controller.txtDescriptionFilterController.text
                                .isNotEmpty) {
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
                      icon: Icon(Icons.search))),
            ),
          )
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
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 60),
            itemCount: controller.listTransactions.length,
            itemBuilder: (context, index) {
              final transaction = controller.listTransactions[index];
              return InkWell(
                splashColor: Colors.grey.shade50,
                onTap: () {
                  //METODO PARA EDITAR UMA TRANSAÇÃO
                  controller.clearAllFields();
                  controller.fillInFields(transaction);
                  controller.getMyCategories();
                  controller.getMyChargeTypes();
                  controller.getMySpecifics();

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
                    transactionController.getMySpecifics();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CreateExpenseModal(
                        isUpdate: true,
                        idTransaction: transaction.id,
                      ),
                    );
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
              'NÃO HÁ TRANSAÇÕES PARA O VEÍCULO SELECIONADO!',
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
    if (transaction.tipoTransacao == 'entrada') {
      stringTitulo =
          "${transaction.descricao!.toUpperCase()}: ${transaction.origem!.toUpperCase()}/${transaction.destino!.toUpperCase()}";
      stringValor =
          "+R\$ ${FormattedInputers.formatValuePTBR(transaction.valor)}";
      cor = Colors.green;
    } else {
      stringTitulo =
          "${transaction.expenseCategory!.descricao!.toUpperCase()} - ${transaction.specificTypeExpense!.descricao!.toUpperCase()}";
      stringValor =
          "-R\$ ${FormattedInputers.formatValuePTBR(transaction.valor)}";
      cor = Colors.red;
    }

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
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FormattedInputers.formatApiDate(transaction.data!),
                    style: TextStyle(
                        fontFamily: 'Inter-Bold', fontSize: 11, color: cor),
                  ),
                  Text(
                    stringTitulo,
                    style: TextStyle(
                        fontFamily: 'Inter-Bold', fontSize: 12, color: cor),
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
                      fontSize: 13,
                      color: cor,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        transaction.id.toString().padLeft(5, '0'),
                        style: TextStyle(
                          fontFamily: 'Inter-Regular',
                          fontSize: 12,
                          color: cor,
                        ),
                      ),
                      Text(
                        'R\$ ${transaction.saldo!.toStringAsFixed(2)}',
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
