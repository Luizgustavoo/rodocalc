import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/modules/trip/widgets/create_expense_trip_modal.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class ViewListExpenseTripModal extends GetView<TripController> {
  const ViewListExpenseTripModal({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'LANCAMENTOS DO TRECHO',
                    style: TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 17,
                        color: Color(0xFFFF6B00)),
                  ),
                  trip.situacao!.toUpperCase() == "CLOSE"
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () {
                            Get.back();
                            controller.clearAllFieldsExpense();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => CreateExpenseTripModal(
                                isUpdate: false,
                                trip: trip,
                              ),
                            );
                          },
                          icon: const Icon(Icons.add))
                ],
              ),
            ),
            const Divider(
              endIndent: 20,
              indent: 20,
              height: 5,
              thickness: 2,
              color: Colors.black,
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200, // Defina a altura manualmente
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: trip.transactions!.length,
                itemBuilder: (ctx, index) {
                  final Transacoes transacao = trip.transactions![index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(context, transacao, controller);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              if (trip.situacao!.toUpperCase() != "CLOSE")
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.clearAllFieldsExpense();
                                    controller
                                        .fillInFieldsExpenseTrip(transacao);
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          CreateExpenseTripModal(
                                        isUpdate: true,
                                        trip: trip,
                                        transaction: transacao,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              IconButton(
                                onPressed: () {
                                  // Implementar lógica de anexar foto
                                },
                                icon: const Icon(Icons.camera_alt),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Inter-Regular',
                              ),
                              children: [
                                const TextSpan(
                                  text: 'DESCRIÇÃO: ',
                                  style: TextStyle(
                                    fontFamily: 'Inter-Bold',
                                  ),
                                ),
                                TextSpan(
                                  text: transacao.descricao,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Inter-Regular',
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'DATA: ',
                                      style: TextStyle(
                                        fontFamily: 'Inter-Bold',
                                      ),
                                    ),
                                    TextSpan(
                                      text: FormattedInputers.formatApiDateHour(
                                          transacao.data!),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Inter-Regular',
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'VALOR: ',
                                      style: TextStyle(
                                        fontFamily: 'Inter-Bold',
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "R\$${FormattedInputers.formatValuePTBR((transacao.valor! / 100).toString())}",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'Inter-Regular',
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'KM: ',
                                      style: TextStyle(
                                        fontFamily: 'Inter-Bold',
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${transacao.km} Km" ?? "",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

void showDialog(context, Transacoes transacao, TripController controller) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir a transação selecionada?",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.deleteExpenseTrip(transacao.id!);
          Get.back();
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
