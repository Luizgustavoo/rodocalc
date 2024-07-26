import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/financial_controller.dart';

class CreateExpenseModal extends GetView<FinancialController> {
  const CreateExpenseModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: controller.formKeyExpense,
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
              GestureDetector(
                onTap: () => _showPicker(context),
                child: Obx(() => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey,
                        child: controller.selectedImagePath.value != ''
                            ? Image.file(
                                File(controller.selectedImagePath.value),
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                    )),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.descriptionExpenseController,
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      showSpecificTypeModal(context);
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                    ),
                  ),
                  labelText: 'TIPO ESPECÍFICO',
                ),
                items: controller.specificTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedSpecificType.value = newValue!;
                },
                value: controller.selectedSpecificType.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o tipo específico';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_rounded,
                    ),
                  ),
                  labelText: 'CATEGORIA',
                ),
                items: controller.categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedCategory.value = newValue!;
                },
                value: controller.selectedCategory.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller.cityController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_city_outlined,
                        ),
                        labelText: 'CIDADE',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a cidade';
                        }
                        return null;
                      },
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
                controller: controller.companyController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.business_rounded,
                  ),
                  labelText: 'EMPRESA',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da empresa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: controller.dddController,
                      decoration: const InputDecoration(
                        labelText: 'DDD',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o DDD';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: controller.phoneController,
                      maxLength: 14,
                      decoration: const InputDecoration(
                        counterText: '',
                        prefixIcon: Icon(
                          Icons.phone_rounded,
                        ),
                        labelText: 'TELEFONE',
                      ),
                      onChanged: (value) {
                        controller.onContactChanged(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o telefone';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: controller.valueController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
                  ),
                  labelText: 'VALOR',
                ),
                onChanged: (value) {
                  controller.onValueChanged(value, 'value');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {},
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

  void showSpecificTypeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'CATEGORIA DE DESPESA',
            style: TextStyle(fontFamily: 'Inter_bold', fontSize: 18),
          ),
          content: Form(
            child: TextFormField(
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
              onPressed: () {},
              child: const Text('SALVAR'),
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
