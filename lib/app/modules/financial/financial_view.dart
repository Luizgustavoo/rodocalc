import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/financial_controller.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/modules/financial/widgets/create_expense_modal.dart';
import 'package:rodocalc/app/modules/financial/widgets/create_receipt_modal.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:timeline_tile/timeline_tile.dart';

class FinancialView extends GetView<FinancialController> {
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
                      ? Image.asset('assets/images/caminhao.jpg')
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
              SpeedDialChild(
                backgroundColor: const Color(0xFFFF6B00),
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
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => const CreateReceiptModal(),
                  );
                },
              ),
              SpeedDialChild(
                backgroundColor: const Color(0xFFFF6B00),
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
                  final transactionController =
                      Get.put(TransactionController());
                  transactionController.getMyCategories();
                  transactionController.getMySpecifics();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => const CreateExpenseModal(),
                  );
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text('Saldo Atual',
              style: TextStyle(fontSize: 18, fontFamily: 'Inter-Bold')),
          const SizedBox(width: 5),
          Obx(() => Text('R\$ ${controller.balance.value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontFamily: 'Inter-Black'))),
        ],
      ),
    );
  }

  Widget _buildSearchBar(FinancialController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: TextFormField(
          onChanged: (value) => controller.filterTransactions(value),
          decoration: const InputDecoration(
            labelText: 'Pesquisar',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(FinancialController controller) {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredTransactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.filteredTransactions[index];
            return _buildTimelineTile(transaction);
          },
        );
      }),
    );
  }

  Widget _buildTimelineTile(Transaction transaction) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: true,
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.date,
                    style: const TextStyle(
                        fontFamily: 'Inter-Regular', fontSize: 11),
                  ),
                  Text(
                    transaction.description,
                    style:
                        const TextStyle(fontFamily: 'Inter-Bold', fontSize: 11),
                  ),
                  Text(
                    transaction.type,
                    style: const TextStyle(
                        fontFamily: 'Inter-Regular', fontSize: 12),
                  ),
                  const Text(
                    'SALDO',
                    style: TextStyle(fontFamily: 'Inter-Regular', fontSize: 12),
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
                    '+R\$ ${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 13,
                        color:
                            transaction.amount < 0 ? Colors.red : Colors.green),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        transaction.code,
                        style: const TextStyle(
                            fontFamily: 'Inter-Regular', fontSize: 12),
                      ),
                      const Text(
                        'R\$ 8.850,00',
                        style: TextStyle(
                            fontFamily: 'Inter-Regular', fontSize: 12),
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
        color: Colors.orange,
        thickness: 2,
      ),
    );
  }
}
