import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
import 'package:rodocalc/app/data/controllers/vehicle_controller.dart';
import 'package:rodocalc/app/modules/home/widgets/custom_home_card.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final vehicleController = Get.put(VehiclesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          // AppBar customizada com Stack
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
                                    // Texto responsivo

                                    Expanded(
                                      child: Text(
                                        'Olá, ${ServiceStorage.getUserName()}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontFamily: 'Inter-Black',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Espaço entre o texto e o avatar
                                    const SizedBox(width: 5),
                                    // Avatar
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352156-stock-illustration-default-placeholder-profile-icon.jpg',
                                      ),
                                    ),
                                    // Espaço entre o avatar e o menu

                                    // Menu popup
                                    PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      iconColor: Colors.white,
                                      tooltip: 'Mostrar menu',
                                      onSelected: (String value) {
                                        switch (value) {
                                          case 'Alterar senha':
                                            // Lógica para alterar senha
                                            break;
                                          case 'Sair':
                                            final loginController =
                                                Get.put(LoginController());
                                            loginController.logout();
                                            break;
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return {'Alterar senha', 'Sair'}
                                            .map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Text(
                                              choice,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins'),
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Scania Bitrem FCF-0827',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      !ServiceStorage.existsSelectedVehicle()
                                          ? const AssetImage(
                                                  'assets/images/caminhao.jpg')
                                              as ImageProvider
                                          : NetworkImage(
                                              "$urlImagem/storage/fotos/veiculos/${ServiceStorage.photoSelectedVehicle()}",
                                            ),
                                ),
                                const SizedBox(width: 20),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Saldo do caminhão',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      Text(
                                        'R\$ 10.307,00',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 24,
                                            fontFamily: 'Inter-Black'),
                                      ),
                                      Text(
                                        '+15% entradas últimos 30 dias',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomHomeCard(
                                  imagePath: 'assets/images/caminhao.png',
                                  label: 'Caminhões',
                                  onTap: () {
                                    vehicleController.isLoading.value = false;
                                    vehicleController.getAll();
                                    Get.toNamed(Routes.vehicle);
                                    // print(ServiceStorage.idSelectedVehicle());
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomHomeCard(
                                  imagePath: 'assets/images/frete.png',
                                  label: 'Financeiro',
                                  onTap: () {
                                    Get.toNamed(Routes.financial);
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomHomeCard(
                                  imagePath: 'assets/images/estrada.png',
                                  label: 'Fretes',
                                  onTap: () {
                                    Get.toNamed(Routes.freight);
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomHomeCard(
                                  imagePath: 'assets/images/documento.png',
                                  label: 'Documentos',
                                  onTap: () {
                                    Get.toNamed(Routes.document);
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomHomeCard(
                                  imagePath: 'assets/images/indicador.png',
                                  label: 'Indicador',
                                  onTap: () {
                                    Get.toNamed(Routes.indicator);
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomHomeCard(
                                  imagePath: 'assets/images/plano.png',
                                  label: 'Planos',
                                  onTap: () {
                                    Get.toNamed(Routes.plan);
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
          // Card de conteúdo com borda arredondada somente na parte de cima
          Positioned(
            top: MediaQuery.of(context).size.height / 1.8,
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Últimas movimentações',
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: 'Inter-Bold'),
                        ),
                        Icon(Icons.arrow_circle_right)
                      ],
                    ),
                    Obx(() => Column(
                          children:
                              controller.recentTransactions.map((transaction) {
                            return Card(
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                elevation: 0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(transaction['title']),
                                            Text(transaction['description'])
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'R\$ ${transaction['amount'].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  color:
                                                      transaction['amount'] < 0
                                                          ? Colors.red
                                                          : Colors.green),
                                            ),
                                            Text(transaction['date'],
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ));
                          }).toList(),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
