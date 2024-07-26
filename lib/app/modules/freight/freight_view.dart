import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/freight_controller.dart';
import 'package:rodocalc/app/modules/freight/widgets/create_freight_modal.dart';
import 'package:rodocalc/app/modules/freight/widgets/custom_freight_card.dart';

class FreightView extends GetView<FreightController> {
  const FreightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('FRETES',
                style: TextStyle(
                  fontFamily: 'Inter-Black',
                )),
            Text(
              'SCANIA - P360 BITRUCK - CARROCERIA 9MTS',
              style: TextStyle(fontFamily: 'Inter-Regular', fontSize: 14),
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
                child: Image.network(
                  'https://portalgoverno.com.br/wp-content/uploads/2023/11/Caminhao-Carroceria-Plataforma-Mercedes-Benz-Atego-333054-Imagem-Ilustrativa-00-uai-634x634.jpg',
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
          Card(
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
                    labelText: 'PESQUISAR FRETE',
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const CustomFreightCard(
                        origin: 'ARAPONGAS - PR',
                        destination: 'FLORIANÓPOLIS - SC',
                        distance: '700KM',
                        value: 'R\$ 25.000,00',
                      );
                    })
              ]),
            ),
          )
        ])),
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF6B00),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const CreateFreightModal(),
            );
          },
          child: const Icon(
            Icons.calculate_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
