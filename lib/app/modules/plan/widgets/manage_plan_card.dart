import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/plan_controller.dart';
import 'package:rodocalc/app/data/models/planos_alter_drop_down_model.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';

class ManagePlanCard extends StatelessWidget {
  const ManagePlanCard({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.vencimento,
    required this.valor,
    required this.vehicles,
    required this.controller,
    required this.plano,
  });

  final int plano;
  final String titulo;
  final String descricao;
  final String valor;
  final String vencimento;
  final List<Vehicle>? vehicles;
  final PlanController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(12),
        childrenPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  TextSpan(
                    text: titulo,
                    style: const TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: descricao),
                ],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Inter-Regular',
                ),
                children: [
                  const TextSpan(
                    text: 'VENCIMENTO: ',
                    style: TextStyle(
                      fontFamily: 'Inter-Bold',
                    ),
                  ),
                  TextSpan(text: vencimento),
                ],
              ),
            ),
          ],
        ),
        children: vehicles != null && vehicles!.isNotEmpty
            ? vehicles!.map((vehicle) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(vehicle!.modelo!),
                    trailing: IconButton(
                      onPressed: () {
                        controller.getAllPlansAlterPlanDropDown(plano);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String?
                                selectedOption; // Variável para armazenar a opção selecionada
                            return AlertDialog(
                              title: const Text(
                                'Alterar plano do veículo selecionado.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(
                                    () => DropdownButtonFormField<int?>(
                                      decoration: const InputDecoration(
                                        labelText: 'Plano',
                                      ),
                                      items: [
                                        const DropdownMenuItem<int?>(
                                          value: 0,
                                          child: Text('Selecione um plano'),
                                        ),
                                        ...controller.myPlansDropDownUpdate
                                            .map((AlterPlanDropDown plan) {
                                          // Verifique se plan.id é nulo e use um valor padrão se necessário
                                          if (plan.planoId == null) {
                                            return DropdownMenuItem<int?>(
                                              value: null,
                                              // Ou qualquer outro valor que não conflite
                                              child: Text(plan.plano ??
                                                  'Descrição não disponível'),
                                            );
                                          }

                                          return DropdownMenuItem<int?>(
                                            value: plan.planoId,
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: Get.width * .7),
                                              child: Text(
                                                "${plan.plano}",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                      onChanged: (newValue) {
                                        // controller.selectedPlanDropDown.value =
                                        //     newValue!;
                                      },
                                      value: null,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Por favor, selecione um plano';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fecha o diálogo
                                  },
                                  child: Text('Cancelar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.red.shade500,
                      ),
                    ),
                  ),
                );
              }).toList()
            : [
                ListTile(
                  title: Text('Nenhum veículo disponível'),
                ),
              ],
      ),
    );
  }
}
