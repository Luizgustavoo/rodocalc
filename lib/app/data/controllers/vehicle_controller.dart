import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rodocalc/app/data/models/search_plate.dart';
import 'package:rodocalc/app/data/models/user_plan_dropdown.dart';
import 'package:rodocalc/app/data/models/vehicle_model.dart';
import 'package:rodocalc/app/data/repositories/vehicle_repository.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

import '../../utils/formatter.dart';

class VehicleController extends GetxController {
  final box = GetStorage('rodocalc');

  var selectedImagePath = ''.obs;
  var selectedPlanDropDown = 0.obs;
  RxBool setImage = false.obs;

  RxBool trailerCheckboxValue = false.obs;

  late Vehicle selectedVehicle;
  late Vehicle initialVehicle = Vehicle().obs as Vehicle;

  late SearchPlate searchPlate;

  final formKeyVehicle = GlobalKey<FormState>();
  final txtPlateController = TextEditingController();
  final txtBrandController = TextEditingController();
  final txtYearController = TextEditingController();
  final txtModelController = TextEditingController();
  final txtFipeController = TextEditingController();
  final txtFipeValueController = TextEditingController();
  final txtTrailerController = TextEditingController();
  final searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxBool isLoadingQuantityLicences = true.obs;
  RxBool isLoadingInitial = true.obs;
  RxBool isLoadingDropDown = true.obs;

  RxInt licences = 0.obs;
  RxInt vehiclesRegistered = 0.obs;

  RxList<Vehicle> listVehicles = RxList<Vehicle>([]);
  RxList<Vehicle> filteredVehicles = RxList<Vehicle>([]);
  RxList<Vehicle> listVehiclesDropDown = RxList<Vehicle>([]);
  RxList<UserPlanDropdown> listMyPlans = RxList<UserPlanDropdown>([]);

  final repository = Get.put(VehicleRepository());

  //PARA ADICIONAR O VEICULO SELECIONADO NA LISTAGEM DE VEÍCULOS
  var selectedVehicleInAplication = Rx<Vehicle?>(null);

  void setVehicle(Vehicle vehicle) {
    selectedVehicleInAplication.value = vehicle;
    box.write('vehicle', vehicle.toJson());
  }

  Vehicle? get getVehicle => selectedVehicleInAplication.value;

  void pickImage(ImageSource source) async {
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
        selectedImagePath.value = croppedFile.path;
      }
    } else {
      Get.snackbar('Erro', 'Nenhuma imagem selecionada');
    }
  }

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  @override
  void onInit() {
    super.onInit();
    filteredVehicles.assignAll(listVehicles);
  }

  Future<void> getAll() async {
    isLoading.value = true;
    try {
      searchController.clear();
      listVehicles.value = await repository.getAll();
      filteredVehicles.assignAll(listVehicles);
    } catch (e) {
      listVehicles.clear();
      filteredVehicles.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  void filterVehicles(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, mostra todos os fretes
      filteredVehicles.assignAll(listVehicles);
    } else {
      // Filtra os fretes com base no campo "origem", "destino" ou qualquer outro
      filteredVehicles.assignAll(
        listVehicles
            .where((vehicle) =>
                vehicle.modelo!.toLowerCase().contains(query.toLowerCase()) ||
                vehicle.marca!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  Future<void> getQuantityLicences() async {
    isLoadingQuantityLicences.value = true;
    try {
      var data = await repository.getQuantityLicences();
      licences.value = data['licencas'];
      vehiclesRegistered.value = data['veiculos'];
    } catch (e) {
      Exception(e);
    }
    isLoadingQuantityLicences.value = false;
  }

  Future<void> getAllDropDown() async {
    isLoadingDropDown.value = true;
    try {
      listVehiclesDropDown.value = await repository.getAllDropDown();
    } catch (e) {
      Exception(e);
    }
    isLoadingDropDown.value = false;
  }

  Future<void> getAllUserPlans() async {
    isLoadingDropDown.value = true;
    try {
      listMyPlans.value = await repository.getAllUserPlans();
    } catch (e) {
      Exception(e);
    }
    isLoadingDropDown.value = false;
  }

  Future<void> searchPlates() async {
    isLoading.value = true;
    try {
      var response = await repository.searchPlate(txtPlateController.text);

      String marcaModelo = response["veiculo"]["marca_modelo"];
      List<String> partes = marcaModelo.split('/');

      if (partes.length >= 2) {
        txtBrandController.text = partes[0].trim(); // Marca
        txtModelController.text = partes[1].trim(); // Modelo
      } else {
        txtBrandController.text =
            marcaModelo; // Atribui a string inteira se não puder separar
        txtModelController.text = ''; // Limpa o modelo
      }

      print(response["fipes"][0]["valor"]);
      txtYearController.text = response["veiculo"]["ano"];
      txtFipeController.text = response["fipes"][0]["codigo"];
      // Acessando o valor da jipe
      int fipeValue = response["fipes"][0]["valor"];

      if (fipeValue > 0) {
        double formattedValue = fipeValue * 100 / 100;
        String formattedCurrency = NumberFormat.currency(
          locale: 'pt_BR',
          symbol: 'R\$',
          decimalDigits: 2,
        ).format(formattedValue);
        txtFipeValueController.text = (formattedCurrency).toString();
      } else {
        txtFipeValueController.text =
            '0'; // Ou qualquer valor padrão que você desejar
      }
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<Map<String, dynamic>> insertVehicle() async {
    if (formKeyVehicle.currentState!.validate()) {
      mensagem = await repository.insert(Vehicle(
        pessoaId: ServiceStorage.getUserId(),
        marca: txtBrandController.text,
        ano: txtYearController.text,
        modelo: txtModelController.text,
        placa: txtPlateController.text,
        fipe: txtFipeController.text,
        valorFipe:
            FormattedInputers.convertForCents(txtFipeValueController.text),
        reboque: trailerCheckboxValue.value ? 'sim' : 'nao',
        foto: selectedImagePath.value,
        status: 1,
        planoUsuarioId: selectedPlanDropDown.value,
      ));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  void fillInFields() {
    txtPlateController.text = selectedVehicle.placa.toString();
    txtBrandController.text = selectedVehicle.marca.toString();
    txtYearController.text = selectedVehicle.ano.toString();
    txtModelController.text = selectedVehicle.modelo.toString();
    txtFipeController.text = selectedVehicle.fipe.toString();
    txtTrailerController.text = selectedVehicle.reboque.toString();
    selectedPlanDropDown.value = selectedVehicle.planoUsuarioId!;
    trailerCheckboxValue.value =
        selectedVehicle.reboque == 'sim' ? true : false;
    if (selectedVehicle.foto!.isNotEmpty) {
      setImage(true);
      selectedImagePath.value = selectedVehicle.foto!;
    }

    txtFipeValueController.text =
        'R\$${FormattedInputers.formatValuePTBR((selectedVehicle.valorFipe! / 100).toString())}';
  }

  void clearAllFields() {
    final textControllers = [
      txtPlateController,
      txtBrandController,
      txtYearController,
      txtModelController,
      txtFipeController,
      txtFipeValueController,
      txtTrailerController
    ];

    selectedImagePath.value = "";
    setImage.value = false;

    for (final controller in textControllers) {
      controller.clear();
    }
  }

  Future<Map<String, dynamic>> updateVehicle(int id) async {
    if (formKeyVehicle.currentState!.validate()) {
      mensagem = await repository.update(Vehicle(
        id: id,
        pessoaId: ServiceStorage.getUserId(),
        marca: txtBrandController.text,
        ano: txtYearController.text,
        modelo: txtModelController.text,
        placa: txtPlateController.text,
        fipe: txtFipeController.text,
        valorFipe:
            FormattedInputers.convertForCents(txtFipeValueController.text),
        reboque: trailerCheckboxValue.value ? 'sim' : 'nao',
        foto: selectedImagePath.value,
        status: 1,
        planoUsuarioId: selectedPlanDropDown.value,
      ));
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
        getAll();
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteVehicle(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(Vehicle(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getAll();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }

    return retorno;
  }
}
