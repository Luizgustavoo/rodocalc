import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/home_controller.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
import 'package:rodocalc/app/modules/home/widgets/custom_chart.dart';
import 'package:rodocalc/app/modules/home/widgets/custom_home_card.dart';
import 'package:rodocalc/app/modules/home/widgets/custom_stack_card.dart';
import 'package:rodocalc/app/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        toolbarHeight: 200,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomStackCard(),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Image.network(
                'https://via.placeholder.com/150', // Substitua pela URL da sua imagem
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // Adicione outros itens do drawer aqui
                  ListTile(
                    title: const Text('Item 1'),
                    onTap: () {
                      // Ação do Item 1
                    },
                  ),
                  ListTile(
                    title: const Text('Item 2'),
                    onTap: () {
                      // Ação do Item 2
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Sair'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                final loginController = Get.put(LoginController());
                loginController.logout();
                // Fecha o drawer
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/signup.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Saldo Atual: ',
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Inter-Regular'),
                            ),
                            const SizedBox(width: 5),
                            Obx(() => Text(
                                  'R\$ ${controller.balance}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.orange,
                                      fontFamily: 'Inter-Bold'),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            children: [
                              CustomHomeCard(
                                icon: Icons.directions_car,
                                label: 'Veículos',
                                onTap: () {
                                  Get.toNamed(Routes.vehicle);
                                },
                              ),
                              CustomHomeCard(
                                icon: Icons.attach_money,
                                label: 'Financeiro',
                                onTap: () {
                                  Get.toNamed(Routes.financial);
                                },
                              ),
                              CustomHomeCard(
                                icon: Icons.local_shipping,
                                label: 'Frete',
                                onTap: () {
                                  Get.toNamed(Routes.freight);
                                },
                              ),
                              CustomHomeCard(
                                icon: Icons.insert_drive_file,
                                label: 'Documentos',
                                onTap: () {
                                  Get.toNamed(Routes.document);
                                },
                              ),
                              CustomHomeCard(
                                icon: Icons.accessibility_new_rounded,
                                label: 'Indicações',
                                onTap: () {
                                  Get.toNamed(Routes.indicator);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: CustomChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
