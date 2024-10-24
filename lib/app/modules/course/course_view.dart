import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rodocalc/app/data/controllers/course_controller.dart';
import 'package:rodocalc/app/global/custom_app_bar.dart';
import 'package:rodocalc/app/modules/course/widgets/custom_course_card.dart';
import 'package:rodocalc/app/utils/formatter.dart';

import '../../data/models/courses_model.dart';

class CourseView extends GetView<CourseController> {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CURSOS'),
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
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    controller.searchCourseController.clear();
                    controller.listCourses.clear();
                    controller.getAll();
                  },
                  child: SizedBox(
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
                        child: Column(children: [
                          TextFormField(
                            controller: controller.searchCourseController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: const Icon(Icons.search_rounded),
                              labelText: 'PESQUISAR CURSO',
                            ),
                            onChanged: (value) {
                              controller.filterCourses(value);
                            },
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () {
                              if (controller.isLoading.value) {
                                return const Column(
                                  children: [
                                    Text('Carregando...'),
                                    SizedBox(height: 20.0),
                                    CircularProgressIndicator(),
                                  ],
                                );
                              } else if (!controller.isLoading.value &&
                                  controller.listCourses.isNotEmpty) {
                                return ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .25),
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: controller.filteredCourses.length,
                                  itemBuilder: (context, index) {
                                    final Courses curso =
                                        controller.filteredCourses[index];
                                    return CustomCourseCard(
                                      descricao: curso.descricao.toString(),
                                      duracao: curso.duracao.toString(),
                                      valor:
                                          "R\$ ${FormattedInputers.formatValuePTBR(curso.valor.toString())}",
                                      link: curso.link.toString(),
                                      imagem: curso.imagem!,
                                      titulo: curso.titulo!,
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text('NENHUM CURSO CADASTRADO!'),
                                );
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
