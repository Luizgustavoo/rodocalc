import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/photo_item.dart';
import 'package:rodocalc/app/utils/formatter.dart';

class CreateExpenseModal extends GetView<TransactionController> {
  CreateExpenseModal({super.key, required this.isUpdate});

  final bool isUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: controller.formKeyTransaction,
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
                  'CADASTRO DE DESPESA',
                  style: TextStyle(
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

              Obx(
                () => SingleChildScrollView(
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
                      Row(
                        children: controller.selectedImagesPaths.map((path) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: PhotoItem(
                              isUpdate: path['tipo'] == 'insert' ? false : true,
                              photo: path['arquivo'],
                              onDelete: () {
                                controller.removeImage(path['arquivo']);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              //TERMINA AQUI AS FOTOS

              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtDescriptionController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.message_outlined,
                    size: 25,
                  ),
                  labelText: 'DESCRIÇÃO',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                maxLength: 10,
                controller: controller.txtDateController,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    size: 25,
                  ),
                  labelText: 'DATA DESPESA',
                ),
                onChanged: (value) {
                  FormattedInputers.onDateChanged(
                      value, controller.txtDateController);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data da despesa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.txtValueController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
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
              Obx(
                () => DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        showSpecificTypeModal(context, 'tipoespecificodespesa');
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                      ),
                    ),
                    labelText: 'TIPO ESPECÍFICO',
                  ),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('Selecione um tipo específico'),
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
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (newValue) {
                    controller.selectedSpecificType.value = newValue!;
                  },
                  value: controller.selectedSpecificType.value,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione o tipo específico';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),

              Obx(
                () => DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        showSpecificTypeModal(context, 'categoriadespesa');
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                      ),
                    ),
                    labelText: 'CATEGORIA',
                  ),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('Selecione uma categoria'),
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
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (newValue) {
                    controller.selectedCategory.value = newValue!;
                  },
                  value: controller.selectedCategory.value,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione a categoria';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.txtCityController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_city_outlined,
                        ),
                        labelText: 'CIDADE',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'UF',
                      ),
                      items: controller.ufs.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        controller.selectedUf.value = newValue!;
                      },
                      value: controller.selectedUf.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecione a UF';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtCompanyController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.business_rounded,
                  ),
                  labelText: 'EMPRESA',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.txtPhoneController,
                maxLength: 14,
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(
                    Icons.phone_rounded,
                  ),
                  labelText: 'TELEFONE',
                ),
                onChanged: (value) {
                  FormattedInputers.onContactChanged(
                      value, controller.txtPhoneController);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> retorno = isUpdate
                          ? await controller.updateTransaction("saida")
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
                    child: const Text(
                      'CADASTRAR',
                      style: TextStyle(
                        fontFamily: 'Inter-Bold',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
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
                  fontFamily: 'Inter_bold',
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
            child: TextFormField(
              controller: controller.txtDescriptionExpenseCategoryController,
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
          ),
          actions: <Widget>[
            TextButton(
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCELAR'),
            ),
          ],
        );
      },
    );
  }
}
