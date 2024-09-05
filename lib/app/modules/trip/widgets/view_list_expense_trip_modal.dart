import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/trip_controller.dart';
import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class ViewListExpenseTripModal extends GetView<TripController> {
  const ViewListExpenseTripModal({super.key, required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
          key: controller.tripFormKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    'DESPESAS DO TRECHO',
                    style: TextStyle(
                        fontFamily: 'Inter-Bold',
                        fontSize: 17,
                        color: Color(0xFFFF6B00)),
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
                    itemCount: trip.expenseTrip!.length,
                    itemBuilder: (ctx, index) {
                      final ExpenseTrip expense = trip.expenseTrip![index];
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(context, expense, controller);
                            },
                            icon: Icon(Icons.delete),
                          ),
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
                                  text: expense.descricao,
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
                                          expense.dataHora!),
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
                                          "R\$${FormattedInputers.formatValuePTBR((expense.valorDespesa! / 100).toString())}",
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
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          )),
    );
  }
}

void showDialog(context, ExpenseTrip expense, TripController controller) {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.all(16),
    contentPadding: const EdgeInsets.all(16),
    title: "Confirmação",
    content: const Text(
      textAlign: TextAlign.center,
      "Tem certeza que deseja excluir a despesa selecionada?",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Map<String, dynamic> retorno =
              await controller.deleteExpenseTrip(expense.id!);
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
