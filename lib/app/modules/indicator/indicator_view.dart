import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/indicator_controller.dart';
import 'package:rodocalc/app/data/models/indication_model.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/indicator/widgets/create_indicator_modal.dart';
import 'package:rodocalc/app/modules/indicator/widgets/custom_indicator_card.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class IndicatorView extends GetView<IndicationController> {
  const IndicatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'INDICAÇÕES'),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 5),
                          Card(
                            color: Colors.grey.shade300,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text('A receber:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Inter-Bold')),
                                  const SizedBox(width: 3),
                                  const Text(
                                    'R\$ 200,00',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter-Black',
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.green.shade700,
                                        Colors.greenAccent.shade400
                                      ]),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: const Text(
                                        'SOLICITAR\nSAQUE',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Inter-Bold',
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: const Icon(Icons.search_rounded),
                              labelText: 'PESQUISAR INDICAÇÃO',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.listIndications.length,
                                itemBuilder: (context, index) {
                                  Indication indication =
                                      controller.listIndications[index];

                                  return CustomIndicatorCard(
                                    name: indication.nome!,
                                    phone: indication.telefone!,
                                    status: indication.status!,
                                    date: FormattedInputers.formatApiDate(
                                        indication.createdAt!),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF6B00),
          onPressed: () {
            controller.clearAllFields();
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const CreateIndicatorModal(
                isUpdate: false,
              ),
            );
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
