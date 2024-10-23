import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/photo_item.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/photo_item_network.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:searchfield/searchfield.dart';

class CreateExpenseModal extends GetView<TransactionController> {
  CreateExpenseModal({super.key, required this.isUpdate, this.idTransaction});

  final bool isUpdate;
  final int? idTransaction;

  final cityController = Get.put(CityStateController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: controller.formKeyTransaction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  isUpdate ? "ALTERAR DESPESA" : 'CADASTRO DE DESPESA',
                  style: const TextStyle(
                    fontFamily: 'Inter-Bold',
                    fontSize: 17,
                    color: Color(0xFFFF6B00),
                  ),
                ),
              ),
              const Divider(
                endIndent: 20,
                indent: 20,
                height: 5,
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 10),

              //COMEÇA AQUI AS FOTOS

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showPicker(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Row(
                        children: controller.selectedImagesPaths.map((path) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: PhotoItem(
                              photo: path,
                              onDelete: () {
                                controller.removeImage(path);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: controller.selectedImagesPathsApi.map((path) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: PhotoItemNetwork(
                              photo: path,
                              onDelete: () {
                                controller.removeImageApi(path);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              //TERMINA AQUI AS FOTOS

              const SizedBox(height: 15),
              TextFormField(
                controller: controller.txtValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.monetization_on,
                  ),
                  labelText: 'VALOR',
                ),
                onChanged: (value) {
                  FormattedInputers.onformatValueChanged(
                      value, controller.txtValueController);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.txtDateController,
                decoration: const InputDecoration(
                  labelText: 'DATA',
                  prefixIcon: Icon(Icons.date_range),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  filled: true,
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    locale: const Locale('pt', 'BR'),
                  );
                  if (pickedDate != null) {
                    controller.txtDateController.text =
                        FormattedInputers.formatDate2(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 15),

              Obx(
                () => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    labelText: 'CATEGORIA',
                  ),
                  items: [
                    DropdownMenuItem<int>(
                      value: null,
                      child: SizedBox(
                        width: Get.width * 0.7,
                        child: const Text(
                          'Selecione ou cadastre uma categoria',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    ...controller.expenseCategories
                        .map((ExpenseCategory category) {
                      return DropdownMenuItem<int>(
                        value: category.id!,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: Get.width * .7),
                          child: Text(
                            category.descricao!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'Inter-Bold',
                                color: Colors.black54),
                          ),
                        ),
                      );
                    }),
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: TextButton(
                            onPressed: () {
                              controller.selectedCategory.value = null;
                              controller.clearDescriptionModal();
                              Get.back();
                              showSpecificTypeModal(
                                  context, 'categoriadespesa');
                            },
                            child: const Text(
                              "CADASTRAR NOVA CATEGORIA...",
                              style: TextStyle(
                                  color: Color(0xFFFF6B00),
                                  fontFamily: 'Inter-Bold'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (newValue) {
                    controller.selectedCategory.value = newValue!;
                    controller.getMySpecifics(newValue);
                  },
                  value: controller.expenseCategories.any((specific) =>
                          specific.id == controller.selectedCategory.value)
                      ? controller.selectedCategory.value
                      : null,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione a categoria';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 15),
              Obx(
                () => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                    ),
                    labelText: 'TIPO ESPECÍFICO',
                  ),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text(
                        'Selecione ou cadastre um tipo',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...controller.specificTypes
                        .map((SpecificTypeExpense specific) {
                      return DropdownMenuItem<int>(
                        value: specific.id!,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: Get.width * .7),
                          child: Text(
                            specific.descricao!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'Inter-Bold',
                                color: Colors.black54),
                          ),
                        ),
                      );
                    }),
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: TextButton(
                            onPressed: () {
                              Get.back();
                              controller.selectedSpecificType.value = null;
                              controller.clearDescriptionModal();
                              showSpecificTypeModal(
                                  context, 'tipoespecificodespesa');
                            },
                            child: const Text(
                              "CADASTRAR NOVO TIPO...",
                              style: TextStyle(
                                  color: Color(0xFFFF6B00),
                                  fontFamily: 'Inter-Bold'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (newValue) {
                    controller.selectedSpecificType.value = newValue!;
                  },
                  value: controller.specificTypes.any((specific) =>
                          specific.id == controller.selectedSpecificType.value)
                      ? controller.selectedSpecificType.value
                      : null,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione o tipo específico';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 10),
              Obx(
                () => SearchField<String>(
                  controller: controller.txtCityController,
                  suggestions: cityController.listCities
                      .map((city) =>
                          SearchFieldListItem<String>(city.cidadeEstado!))
                      .toList(),
                  searchInputDecoration: InputDecoration(
                      labelText: cityController.isLoading.value
                          ? "CARREGANDO..."
                          : "CIDADE",
                      hintText: "Digite o nome da cidade",
                      prefixIcon: const Icon(FontAwesomeIcons.city)),
                  onSuggestionTap: (suggestion) {
                    controller.txtCityController.text = suggestion.searchKey;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione a cidade';
                    }
                    // Verifica se a cidade está na lista de sugestões
                    /* bool isValidCity = cityController.listCities
                        .any((city) => city.cidadeEstado == value);
                    if (cityController.listCities.isNotEmpty && !isValidCity) {
                      return 'Cidade não encontrada na lista';
                    }*/
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtCompanyController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.location_city_outlined,
                  ),
                  labelText: 'EMPRESA',
                ),
                onChanged: (text) {
                  controller.txtCompanyController.value = TextEditingValue(
                    text: text.toUpperCase(),
                    selection: controller.txtCompanyController.selection,
                  );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtPhoneController,
                maxLength: 15,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.phone_android_rounded,
                  ),
                  labelText: 'TELEFONE',
                ),
                onChanged: (value) {
                  FormattedInputers.onContactChanged(
                      value, controller.txtPhoneController);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtDescriptionController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.message,
                    size: 25,
                  ),
                  labelText: 'DESCRIÇÃO',
                ),
                onChanged: (text) {
                  controller.txtDescriptionController.value = TextEditingValue(
                    text: text.toUpperCase(),
                    selection: controller.txtDescriptionController.selection,
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: isUpdate
                        ? IconButton(
                            onPressed: () {
                              showDialogDeleteTransaction(
                                  context, idTransaction!, controller);
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 25,
                              color: Colors.red,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 120,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'CANCELAR',
                          style: TextStyle(
                            fontFamily: 'Inter-Bold',
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomElevatedButton(
                    onPressed: () async {
                      controller.resetAll();
                      Map<String, dynamic> retorno = isUpdate
                          ? await controller.updateTransaction(
                              "saida", idTransaction!)
                          : await controller.insertTransaction("saida");

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
                    child: Text(
                      isUpdate ? 'ALTERAR' : 'CADASTRAR',
                      style: const TextStyle(
                        fontFamily: 'Inter-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showSpecificTypeModal(BuildContext context, String type) {
    String titulo = type == 'categoriadespesa'
        ? "CATEGORIA DE DESPESA"
        : "TIPO ESPECÍFICO DE DESPESA";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8.0), // Aqui você pode ajustar o valor para o raio desejado
          ),
          title: Column(
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontFamily: 'Inter-bold',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B00),
                ),
              ),
              const Divider(
                endIndent: 10,
                indent: 10,
                height: 5,
                thickness: 2,
                color: Colors.black45,
              ),
              const SizedBox(height: 10),
            ],
          ),
          content: Form(
            key: controller.formKeyExpenseCategory,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller:
                      controller.txtDescriptionExpenseCategoryController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.message_outlined),
                    labelText: 'DESCRIÇÃO',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição';
                    }
                    return null;
                  },
                ),
                if (type == "tipoespecificodespesa") ...[
                  const SizedBox(height: 15),
                  Obx(
                    () => SizedBox(
                      height: 50,
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          labelText: 'CATEGORIA',
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: null,
                            child: SizedBox(
                              width: Get.width * 0.7, // Ajuste o tamanho
                              child: const Text(
                                'Selecione',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          ...controller.expenseCategories
                              .map((ExpenseCategory category) {
                            return DropdownMenuItem<int>(
                              value: category.id!,
                              child: Container(
                                constraints:
                                    BoxConstraints(maxWidth: Get.width * .7),
                                // Limita a largura
                                child: Text(
                                  category.descricao!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Inter-Bold',
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                        onChanged: (newValue) {
                          controller.selectedCategoryCadSpecificType.value =
                              newValue!;
                        },
                        value: controller.expenseCategories.any((specific) =>
                                specific.id ==
                                controller
                                    .selectedCategoryCadSpecificType.value)
                            ? controller.selectedCategoryCadSpecificType.value
                            : null,
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor, selecione a categoria';
                          }
                          return null;
                        },
                        isExpanded:
                            true, // Garantir que ocupe todo o espaço disponível
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCELAR'),
            ),
            CustomElevatedButton(
              onPressed: () async {
                Map<String, dynamic> retorno =
                    await controller.insertExpenseCategory(type);

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
                'SALVAR',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDialogDeleteTransaction(
      context, int transaction, TransactionController controller) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      title: "Confirmação",
      content: const Text(
        textAlign: TextAlign.center,
        "Tem certeza que deseja excluir esta transação?",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> retorno =
                await controller.deleteTransaction(transaction);

            if (retorno['success'] == true) {
              Get.offAllNamed(Routes.home);
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
}
