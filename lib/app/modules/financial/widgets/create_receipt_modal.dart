import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/controllers/city_state_controller.dart';
import 'package:rodocalc/app/data/controllers/transaction_controller.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/photo_item.dart';
import 'package:rodocalc/app/modules/vehicle/widgets/photo_item_network.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/custom_elevated_button.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:searchfield/searchfield.dart';

class CreateReceiptModal extends GetView<TransactionController> {
  CreateReceiptModal({super.key, required this.isUpdate, this.idTransaction});

  final bool isUpdate;
  final int? idTransaction;

  final cityController = Get.put(CityStateController());

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
                    'CADASTRO DE RECEBIMENTO',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                          children:
                              controller.selectedImagesPathsApi.map((path) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtDescriptionController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.description_rounded,
                      size: 25,
                    ),
                    labelText: 'DESCRIÇÃO',
                  ),
                  onChanged: (text) {
                    controller.txtDescriptionController.value =
                        TextEditingValue(
                      text: text.toUpperCase(),
                      selection: controller.txtDescriptionController.selection,
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLength: 10,
                  controller: controller.txtDateController,
                  decoration: const InputDecoration(
                    counterText: '',
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      size: 25,
                    ),
                    labelText: 'DATA RECEBIMENTO',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onDateChanged(
                        value, controller.txtDateController);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data da despesa';
                    } else if (!FormattedInputers.validateDate(value)) {
                      return 'Por favor, insira uma data válida!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Obx(
                  () => SearchField<String>(
                    controller: controller.txtOriginController,
                    suggestions: cityController.listCities
                        .map((city) =>
                            SearchFieldListItem<String>(city.cidadeEstado!))
                        .toList(),
                    searchInputDecoration: InputDecoration(
                      labelText: cityController.isLoading.value
                          ? "CARREGANDO"
                          : "ORIGEM",
                      hintText: "Digite o nome da cidade de origem",
                    ),
                    onSuggestionTap: (suggestion) {
                      controller.txtOriginController.text =
                          suggestion.searchKey;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione a origem';
                      }
                      // Verifica se a cidade está na lista de sugestões
                      bool isValidCity = cityController.listCities
                          .any((city) => city.cidadeEstado == value);
                      if (!isValidCity) {
                        return 'Cidade não encontrada na lista';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => SearchField<String>(
                    controller: controller.txtDestinyController,
                    suggestions: cityController.listCities
                        .map((city) =>
                            SearchFieldListItem<String>(city.cidadeEstado!))
                        .toList(),
                    searchInputDecoration: const InputDecoration(
                      labelText: "DESTINO",
                      hintText: "Digite o nome da cidade de destino",
                    ),
                    onSuggestionTap: (suggestion) {
                      controller.txtDestinyController.text =
                          suggestion.searchKey;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione o destino';
                      }

                      // Verifica se a cidade está na lista de sugestões
                      bool isValidCity = cityController.listCities
                          .any((city) => city.cidadeEstado == value);
                      if (!isValidCity) {
                        return 'Cidade não encontrada na lista';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtValueController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.monetization_on,
                    ),
                    labelText: 'VALOR RECEBIDO',
                  ),
                  onChanged: (value) {
                    FormattedInputers.onformatValueChanged(
                        value, controller.txtValueController);
                    // controller.onValueChanged(value, 'valueReceive');
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o valor recebido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.txtTonController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.balance_rounded,
                    ),
                    labelText: 'TONELADAS',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira as toneladas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                Obx(() {
                  if (controller.isLoadingChargeTypes.value) {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.sort_by_alpha_rounded,
                        ),
                        labelText: 'TIPO DE CARGA',
                      ),
                      items: const [
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text('Carregando...'),
                        ),
                      ],
                      onChanged: null, // Desabilitar mudanças enquanto carrega
                    );
                  } else if (controller.listChargeTypes.isNotEmpty) {
                    return DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                        ),
                        labelText: 'TIPO DE CARGA',
                      ),
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('Selecione ou cadastre um tipo'),
                        ),
                        ...controller.listChargeTypes.map((ChargeType charge) {
                          return DropdownMenuItem<int>(
                            value: charge.id,
                            child: Text(
                              charge.descricao!,
                              overflow: TextOverflow.ellipsis,
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
                                  showSpecificTypeModal(context);
                                },
                                child: const Text(
                                  "CADASTRAR NOVO TIPO...",
                                  style: TextStyle(
                                      color: Color(0xFFFF6B00),
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (newValue) {
                        controller.selectedCargoType.value = newValue;
                      },
                      value: controller.selectedCargoType.value,
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione o tipo de carga';
                        }
                        return null;
                      },
                    );
                  } else {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.sort_by_alpha_rounded,
                        ),
                        labelText: 'TIPO DE CARGA',
                      ),
                      items: const [
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text('Nenhum tipo encontrado!'),
                        ),
                      ],
                      onChanged:
                          null, // Desabilitar mudanças se nenhum tipo estiver disponível
                    );
                  }
                }),

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
                    Obx(
                      () => controller.isLoadingInsertUpdate.value
                          ? CircularProgressIndicator()
                          : CustomElevatedButton(
                              onPressed: () async {
                                Map<String, dynamic> retorno = isUpdate
                                    ? await controller.updateTransaction(
                                        "entrada", idTransaction!)
                                    : await controller
                                        .insertTransaction("entrada");

                                if (retorno['success'] == true) {
                                  Get.back();
                                  Get.snackbar(
                                      'Sucesso!', retorno['message'].join('\n'),
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                      snackPosition: SnackPosition.BOTTOM);
                                } else {
                                  Get.snackbar(
                                      'Falha!', retorno['message'].join('\n'),
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
                                    color: Colors.white),
                              ),
                            ),
                    )
                  ],
                ),
              ],
            ),
          )),
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
          backgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8.0), // Aqui você pode ajustar o valor para o raio desejado
          ),
          title: const Column(
            children: [
              Text(
                'CADASTRAR TIPO DE CARGA',
                style: TextStyle(
                  fontFamily: 'Inter-bold',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B00),
                ),
              ),
              Divider(
                endIndent: 10,
                indent: 10,
                height: 5,
                thickness: 2,
                color: Colors.black45,
              ),
              SizedBox(height: 10),
            ],
          ),
          content: Form(
            key: controller.formkeyChargeType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: controller.txtChargeTypeController,
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
                    await controller.insertChargeType();

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
