import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/models/transaction_photos_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/repositories/transaction_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';
import 'package:share_plus/share_plus.dart';

class TransactionController extends GetxController {
  RxBool trailerCheckboxValue = false.obs;

  var selectedImagesPaths = <String>[].obs;
  var selectedImagesPathsApi = <String>[].obs;
  var selectedImagesPathsApiRemove = <String>[].obs;
  final tituloSearchTransactions = "".obs;

  //CONTROLLER E KEY DESPESA

  final formKeyTransaction = GlobalKey<FormState>();
  final formKeyExpenseCategory = GlobalKey<FormState>();
  final txtDescriptionController = TextEditingController();
  final txtDescriptionExpenseCategoryController = TextEditingController();
  final txtCityController = TextEditingController();
  final txtCompanyController = TextEditingController();
  final txtDDDController = TextEditingController();
  final txtPhoneController = TextEditingController();
  final txtValueController = TextEditingController();
  final txtDateController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final txtDescriptionFilterController = TextEditingController();

//RECEBIMENTO
  final txtOriginController = TextEditingController();
  final txtDestinyController = TextEditingController();
  final txtTonController = TextEditingController();

  //tipo de carga
  final formkeyChargeType = GlobalKey<FormState>();
  final txtChargeTypeController = TextEditingController();

  RxBool isLoading = true.obs;
  RxBool isLoadingInsertUpdate = false.obs;

  RxBool isLoadingChargeTypes = true.obs;
  RxBool isLoadingBalance = true.obs;

  late Transacoes selectedTransaction;

  RxList<Transacoes> listTransactions = RxList<Transacoes>([]);
  RxList<Transacoes> listLastTransactions = RxList<Transacoes>([]);

  final repository = Get.put(TransactionRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  var ufs = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ].obs;

  var selectedUf = 'AC'.obs;

  var selectedSpecificType = Rxn<int>();
  var selectedCategory = Rxn<int>();
  var selectedCategoryCadSpecificType = Rxn<int>(0);
  var selectedCargoType = Rxn<int>();

  var balance = 0.0.obs;

  var entradasMesAtual = 0.0.obs;
  var saidasMesAtual = 0.0.obs;
  var entradasMesAnterior = 0.0.obs;
  var saidasMesAnterior = 0.0.obs;
  var variacaoEntradas = "".obs;
  var variacaoSaidas = "".obs;

  var transactions = <Transacoes>[].obs;
  var filteredTransactions = <Transacoes>[].obs;
  var searchQuery = ''.obs;

  Future<void> getAll() async {
    tituloSearchTransactions.value = "";
    isLoading.value = true;
    try {
      listTransactions.value = await repository.getAll();
      filteredTransactions.value = listTransactions;
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  //*RELATORIO */
  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    final int randomNum = Random().nextInt(100000);

    // Carregar a logo
    final ByteData logoData = await rootBundle.load('assets/images/logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.zero,
        ),
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 70, left: 20, right: 20),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'RELATÓRIO TRANSAÇÕES',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
              ),
              pw.Image(logoImage,
                  width: 50), // Tamanho da logo ajustado para o header
            ],
          ),
        ),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20, bottom: 10),
          child: pw.Text(
            'DATA RELATÓRIO: $formattedDate',
            style: const pw.TextStyle(fontSize: 12, height: 10),
          ),
        ),
        build: (context) => [
          ...listTransactions.map((transaction) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(left: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 10),
                  pw.Text(
                      'ORIGEM: ${transaction.origem == 'null' ? 'N/A' : transaction.origem}'),
                  pw.Text(
                      'DESTINO: ${transaction.destino == 'null' ? 'N/A' : transaction.destino}'),
                  pw.Text(
                      'EMPRESA: ${transaction.uf == 'null' ? 'N/A' : transaction.uf}'),
                  pw.Text(
                      'DATA: ${transaction.data != 'null' ? FormattedInputers.formatApiDate(transaction.data!) : 'N/A'}'),
                  pw.Text(
                      'EMPRESA: ${transaction.empresa == 'null' ? 'N/A' : transaction.empresa}'),
                  pw.Text(
                      'DESCRIÇÃO: ${transaction.descricao == 'null' ? 'N/A' : transaction.descricao}'),
                  pw.Text(
                      'VALOR: ${transaction.valor != 'null' ? FormattedInputers.formatCurrency(transaction.valor.toDouble()) : 'N/A'}'),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                ],
              ),
            );
          }),
        ],
      ),
    );

    final output = await pdf.save();
    await showShareDialog(
      Get.context!,
      'Relatório_Transacao_$randomNum',
      output,
    );
  }

  Future<void> showShareDialog(
      BuildContext context, String fileName, List<int> pdfData) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Compartilhar Relatório'),
          titleTextStyle:
              const TextStyle(fontFamily: 'Poppinss', color: Colors.black),
          content:
              const Text('Como você gostaria de compartilhar o relatório?'),
          contentTextStyle:
              const TextStyle(fontFamily: 'Poppins', color: Colors.black),
          actions: [
            TextButton.icon(
              onPressed: () {
                Get.back();
                saveFile(pdfData, fileName);
              },
              label: const Text(
                'Salvar',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              icon: const Icon(
                Icons.save_alt_rounded,
                color: Colors.black,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Get.back();
                shareFileByWhatsApp(pdfData, fileName);
              },
              label: const Text(
                'E-mail/Whatsapp',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              icon: const Icon(
                Icons.email_rounded,
                color: Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkStoragePermission() async {
    if (Platform.isAndroid) {
      // Verifica se a permissão foi negada permanentemente e abre as configurações se necessário
      if (await Permission.manageExternalStorage.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied) {
        await openAppSettings();
        return;
      }

      // Verifica permissões para Android 13+ e versões anteriores
      final manageExternalStorageGranted =
          await Permission.manageExternalStorage.request().isGranted;
      final storagePermissionGranted =
          await Permission.storage.request().isGranted;
      if (!storagePermissionGranted) {
        return;
      }
      // Verifica se pelo menos uma das permissões foi concedida
      if (!manageExternalStorageGranted && !storagePermissionGranted) {
        Get.snackbar(
          'Permissão negada',
          'A permissão de gerenciamento de arquivos é necessária para salvar o arquivo.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
        return; // Interrompe o processo se a permissão não for concedida
      }
    }
  }

  Future<void> saveFile(List<int> pdfData, String fileName) async {
    // Verifica permissões
    await checkStoragePermission();

    // Antes de salvar, verifica se a permissão foi realmente concedida
    final storagePermissionGranted = await Permission.storage.isGranted;
    final manageExternalStorageGranted =
        await Permission.manageExternalStorage.isGranted;

    if (!storagePermissionGranted && !manageExternalStorageGranted) {
      Get.snackbar(
        'Erro!',
        'Permissão de armazenamento não foi concedida. Não foi possível salvar o arquivo.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return; // Interrompe o processo se a permissão não foi concedida
    }

    try {
      Directory directory;
      if (Platform.isAndroid) {
        // Diretório padrão de download para Android
        directory = Directory('/storage/emulated/0/Download');
      } else {
        // Diretório de documentos no iOS ou outro sistema
        directory = await getApplicationDocumentsDirectory();
      }

      bool hasExisted = await directory.exists();
      if (!hasExisted) {
        await directory.create(recursive: true);
      }

      final filePath =
          "${directory.path}${Platform.pathSeparator}$fileName.pdf";
      final file = File(filePath);

      await file.writeAsBytes(pdfData);

      Get.snackbar(
        'Sucesso!',
        'Arquivo salvo com sucesso em $filePath',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro!',
        'Ocorreu um erro ao salvar o arquivo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> shareFileByWhatsApp(List<int> pdfData, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    final file = File('$path/$fileName.pdf');
    await file.writeAsBytes(pdfData);

    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Segue em anexo o relatório de empresas.',
      );
      Get.snackbar(
        'Sucesso',
        'Arquivo compartilhado com sucesso!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Ocorreu um erro ao compartilhar o arquivo.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  //* fim relatorio*/

  Future<void> getTransactionsWithFilter() async {
    tituloSearchTransactions.value = "";
    isLoading.value = true;
    try {
      String inicio = startDateController.text.isNotEmpty
          ? "${FormattedInputers.parseDateForApi(startDateController.text)} 00:00:00"
          : "";
      String fim = endDateController.text.isNotEmpty
          ? "${FormattedInputers.parseDateForApi(endDateController.text).toString()} 00:00:00"
          : "";

      String dataInicio =
          startDateController.text.isNotEmpty ? startDateController.text : "";
      String dataFim =
          endDateController.text.isNotEmpty ? endDateController.text : "";

      if (dataInicio.isNotEmpty && dataFim.isNotEmpty) {
        tituloSearchTransactions.value += "$dataInicio - $dataFim";
      }
      if (txtDescriptionFilterController.text.isNotEmpty) {
        tituloSearchTransactions.value +=
            " ${txtDescriptionFilterController.text}";
      }

      listTransactions.value = await repository.getTransactionsWithFilter(
        inicio,
        fim,
        txtDescriptionFilterController.text,
      );
      filteredTransactions.value = listTransactions;
      clearAllFields();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getSaldo() async {
    isLoadingBalance.value = true;
    try {
      final balanceVehicle = await repository.getSaldo();
      if (balanceVehicle != null) {
        balance.value = (balanceVehicle.saldoTotal as num).toDouble();
        entradasMesAtual.value = balanceVehicle.entradasMesAtual;
        saidasMesAtual.value = balanceVehicle.saidasMesAtual;
        entradasMesAnterior.value = balanceVehicle.entradasMesAnterior;
        saidasMesAnterior.value = balanceVehicle.saidasMesAnterior;
        variacaoEntradas.value = balanceVehicle.variacaoEntradas;
        variacaoSaidas.value = balanceVehicle.variacaoSaidas;
      }
    } catch (e) {
      Exception(e);
    }
    isLoadingBalance.value = false;
  }

  RxList<ExpenseCategory> expenseCategories = <ExpenseCategory>[].obs;
  RxList<SpecificTypeExpense> specificTypes = <SpecificTypeExpense>[].obs;
  RxList<ChargeType> listChargeTypes = <ChargeType>[].obs;

  Future<void> getMyChargeTypes() async {
    isLoadingChargeTypes.value = true;
    try {
      listChargeTypes.value = await repository.getMyChargeTypes();
    } catch (e) {
      Exception(e);
    }
    isLoadingChargeTypes.value = false;
  }

  Future<void> getMyCategories() async {
    isLoading.value = true;
    try {
      expenseCategories.value = await repository.getMyCategories();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<void> getMySpecifics(int categoriaId) async {
    isLoading.value = true;
    try {
      specificTypes.value = await repository.getMySpecifics(categoriaId);
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  void pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
      for (var pickedFile in pickedFiles) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Recortar Imagem',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: 'Recortar Imagem',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
          ],
        );
        if (croppedFile != null) {
          selectedImagesPaths.add(croppedFile.path);
        }
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Recortar Imagem',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: 'Recortar Imagem',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
          ],
        );
        if (croppedFile != null) {
          selectedImagesPaths.add(croppedFile.path);
        }
      } else {
        Get.snackbar('Erro', 'Nenhuma imagem selecionada');
      }
    }
  }

  void removeImage(String path) {
    selectedImagesPaths.remove(path);
  }

  void removeImageApi(String path) {
    selectedImagesPathsApiRemove.add(path);
    selectedImagesPathsApi.remove(path);
  }

  Future<Map<String, dynamic>> insertTransaction(String typeTransaction) async {
    isLoadingInsertUpdate.value = true;
    if (formKeyTransaction.currentState!.validate()) {
      final RegExp cidadeUfRegex = RegExp(r'^[A-Za-zÀ-ÿ\s]+-[A-Z]{2}$');

      dynamic cidadePartes;
      dynamic cidade = "";
      dynamic uf = "";

      if (typeTransaction == "saida" && txtCityController.text.isNotEmpty) {
        if (!cidadeUfRegex.hasMatch(txtCityController.text)) {
          return {
            'success': false,
            'message': ['Formato de cidade e UF inválido! Use "Cidade-UF".']
          };
        }

        cidadePartes = txtCityController.text.split('-');
        if (cidadePartes.length != 2) {
          return {
            'success': false,
            'message': ['Formato de cidade inválido!']
          };
        }
        cidade = cidadePartes[0];
        uf = cidadePartes[1];
      } else {
        if (txtOriginController.text.isNotEmpty &&
            txtDestinyController.text.isNotEmpty) {
          if (!cidadeUfRegex.hasMatch(txtOriginController.text)) {
            return {
              'success': false,
              'message': [
                'Formato de cidade (origem) e UF inválido! Use "Cidade-UF".'
              ]
            };
          }

          if (!cidadeUfRegex.hasMatch(txtDestinyController.text)) {
            return {
              'success': false,
              'message': [
                'Formato de cidade (destino) e UF inválido! Use "Cidade-UF".'
              ]
            };
          }
        }
      }

      List<TransactionsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(TransactionsPhotos(arquivo: element));
        }
      }

      Transacoes transaction = Transacoes();

      transaction.descricao = txtDescriptionController.text;
      transaction.data = txtDateController.text;

      if (typeTransaction == "saida") {
        transaction.categoriaDespesaId = selectedCategory.value;
        transaction.tipoEspecificoDespesaId = selectedSpecificType.value;
        transaction.cidade = cidade;
        transaction.uf = uf;
        transaction.ddd = txtDDDController.text;
        transaction.telefone = txtPhoneController.text;
        transaction.empresa = txtCompanyController.text;
      } else if (typeTransaction == "entrada") {
        transaction.quantidadeTonelada =
            FormattedInputers.convertToDouble(txtTonController.text);
        transaction.origem = txtOriginController.text;
        transaction.destino = txtDestinyController.text;
        transaction.tipoCargaId = selectedCargoType.value;
      }

      transaction.valor =
          FormattedInputers.convertToDouble(txtValueController.text);
      transaction.status = 1;
      transaction.pessoaId = ServiceStorage.getUserId();
      transaction.veiculoId = ServiceStorage.idSelectedVehicle();

      transaction.tipoTransacao = typeTransaction;
      transaction.photos = photos;

      mensagem = await repository.insert(transaction);

      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
        getSaldo();
        if (mensagem['success'] == true) {
          clearAllFields();
        }
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    isLoadingInsertUpdate.value = false;
    return retorno;
  }

  Future<Map<String, dynamic>> updateTransaction(
      String typeTransaction, int $id) async {
    isLoadingInsertUpdate.value = true;
    if (formKeyTransaction.currentState!.validate()) {
      List<TransactionsPhotos>? photos = [];
      if (selectedImagesPaths.isNotEmpty) {
        for (var element in selectedImagesPaths) {
          photos.add(TransactionsPhotos(arquivo: element));
        }
      }

      mensagem = await repository.update(
          Transacoes(
            id: $id,
            descricao: txtDescriptionController.text,
            data: txtDateController.text,
            categoriaDespesaId: selectedCategory.value,
            tipoEspecificoDespesaId: selectedSpecificType.value,
            valor: FormattedInputers.convertToDouble(txtValueController.text),
            empresa: txtCompanyController.text,
            cidade: txtCityController.text,
            uf: selectedUf.value,
            ddd: txtDDDController.text,
            telefone: txtPhoneController.text,
            status: 1,
            pessoaId: ServiceStorage.getUserId(),
            veiculoId: ServiceStorage.idSelectedVehicle(),
            origem: txtOriginController.text,
            destino: txtDestinyController.text,
            quantidadeTonelada:
                FormattedInputers.convertToDouble(txtTonController.text),
            tipoCargaId: selectedCargoType.value,
            tipoTransacao: typeTransaction,
            photos: photos,
          ),
          selectedImagesPathsApiRemove);
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
        getSaldo();
        clearAllFields();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    isLoadingInsertUpdate.value = false;
    return retorno;
  }

  Future<Map<String, dynamic>> insertExpenseCategory(String type) async {
    if (formKeyExpenseCategory.currentState!.validate()) {
      int? categoryId = type == "categoriadespesa"
          ? 0
          : selectedCategoryCadSpecificType.value;
      mensagem = await repository.insertCategory(
          ExpenseCategory(
            descricao: txtDescriptionExpenseCategoryController.text,
            status: 1,
            userId: ServiceStorage.getUserId(),
          ),
          type,
          categoryId!);
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getMyCategories();
        getMySpecifics(selectedCategoryCadSpecificType.value!);
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> insertChargeType() async {
    if (formkeyChargeType.currentState!.validate()) {
      mensagem = await repository.insertChargeType(
        ChargeType(descricao: txtChargeTypeController.text, status: 1),
      );
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getMyChargeTypes();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteTransaction(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(Transacoes(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    }
    return retorno;
  }

  void fillInFields(Transacoes selected) {
    txtDescriptionController.text = selected.descricao!;

    if (selected.data != null && selected.data!.isNotEmpty) {
      try {
        DateTime date = DateFormat('yyyy-MM-dd').parse(selected.data!);
        txtDateController.text = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        txtDateController.clear();
      }
    } else {
      txtDateController.clear();
    }

    txtValueController.text =
        FormattedInputers.formatValuePTBR(selected.valor!.toString());
    txtCityController.text =
        selected.cidade != null ? selected.cidade.toString() : "";
    txtCompanyController.text =
        selected.empresa != null ? selected.empresa.toString() : "";
    txtDDDController.text = selected.ddd != null ? selected.ddd.toString() : "";
    txtPhoneController.text =
        selected.telefone != null ? selected.telefone.toString() : "";

    txtOriginController.text =
        selected.origem != null ? selected.origem.toString() : "";
    txtDestinyController.text =
        selected.destino != null ? selected.destino.toString() : "";

    txtTonController.text = selected.quantidadeTonelada != null
        ? selected.quantidadeTonelada.toString()
        : "";

    if (selected.tipoTransacao == 'saida') {
      selectedCategory.value = selected.categoriaDespesaId!;
      selectedSpecificType.value = selected.tipoEspecificoDespesaId;
    } else {
      selectedCargoType.value = selected.tipoCargaId;
    }

    if (selected.photos!.isNotEmpty) {
      selectedImagesPathsApiRemove.clear();
      selectedImagesPathsApi.clear();
      for (var photo in selected.photos!) {
        selectedImagesPathsApi.add(photo.arquivo!.toString());
      }
    }
  }

  void clearAllFields() {
    final textControllers = [
      txtDescriptionController,
      txtDescriptionExpenseCategoryController,
      txtCityController,
      txtCompanyController,
      txtDDDController,
      txtPhoneController,
      txtValueController,
      txtDateController,
      txtOriginController,
      txtDestinyController,
      txtTonController,
      startDateController,
      endDateController,
      txtDescriptionFilterController,
      txtDescriptionFilterController,
      startDateController,
      endDateController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }
    selectedImagesPaths.clear();
    selectedImagesPathsApi.clear();
    selectedImagesPathsApiRemove.clear();
  }

  void clearDescriptionModal() {
    final textControllers = [
      txtDescriptionExpenseCategoryController,
      txtChargeTypeController,
    ];
    for (final controller in textControllers) {
      controller.clear();
    }
  }

  void filterTransactions(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredTransactions.value = transactions;
    } else {
      filteredTransactions.value = transactions.where((transaction) {
        return transaction.descricao!
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }
  }
}
