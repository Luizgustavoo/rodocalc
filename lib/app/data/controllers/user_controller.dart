import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/repositories/cep_repository.dart';
import 'package:rodocalc/app/data/repositories/user_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class UserController extends GetxController {
  var selectedImagePath = ''.obs;
  var selectedState = ''.obs;
  RxBool setImage = false.obs;

  RxBool isLoadingQuantityLicences = true.obs;
  RxInt licences = 0.obs;
  RxInt usersRegistered = 0.obs;
  var caminhoes = "".obs;
  var tituloVeiculosDoMotorista = "".obs;

  var selectedVehicleDropDown = 0.obs;

  final formUserKey = GlobalKey<FormState>();
  final TextEditingController txtNomeController = TextEditingController();
  final TextEditingController txtTelefoneController = TextEditingController();
  final TextEditingController txtDDDController = TextEditingController();
  final TextEditingController txtCidadeController = TextEditingController();
  final TextEditingController txtUfController = TextEditingController();
  final TextEditingController txtCpfController = TextEditingController();
  final TextEditingController txtApelidoController = TextEditingController();
  final TextEditingController txtEmailController = TextEditingController();
  final TextEditingController txtSenhaController = TextEditingController();
  final TextEditingController txtConfirmaSenhaController =
      TextEditingController();

  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();

  final TextEditingController searchUserController = TextEditingController();

  List<String> get states => [
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
      ];

  final cepRepository = Get.put(CepRepository());

  final repository = Get.put(UserRepository());

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  RxBool isLoading = true.obs;
  RxList<User> listUsers = RxList<User>([]);
  RxList<User> filteredUsers = RxList<User>([]);

  @override
  void onInit() {
    super.onInit();
    filteredUsers.assignAll(listUsers);
  }

  void fetchAddressFromCep(String cep) async {
    if (cep.length == 9) {
      final address = await cepRepository.getAddressByCep(cep);
      if (address != null) {
        addressController.text = address.logradouro;
        neighborhoodController.text = address.bairro;
        txtCidadeController.text = address.cidade;
        selectedState.value = address.uf;
      }
    }
  }

  void onCEPChanged(String cep) {
    final formattedCEP = FormattedInputers.formatCEP(cep);
    cepController.value = TextEditingValue(
      text: formattedCEP.value,
      selection: TextSelection.collapsed(offset: formattedCEP.value.length),
    );
  }

  bool validateCEP() {
    return FormattedInputers.validateCEP(cepController.text);
  }

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
        setImage(false);
      }
    } else {
      Get.snackbar('Erro', 'Nenhuma imagem selecionada');
    }
  }

  Future<void> getMyEmployees() async {
    isLoading.value = true;
    try {
      searchUserController.clear();
      listUsers.value = await repository.getMyEmployees();
      filteredUsers.assignAll(listUsers);
    } catch (e) {
      listUsers.clear();
      filteredUsers.clear();
      Exception(e);
    }
    isLoading.value = false;
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      // Se a busca estiver vazia, mostra todos os fretes
      filteredUsers.assignAll(listUsers);
    } else {
      // Filtra os fretes com base no campo "origem", "destino" ou qualquer outro
      filteredUsers.assignAll(
        listUsers
            .where((user) =>
                user.people!.nome!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  Future<void> getQuantityLicences() async {
    isLoadingQuantityLicences.value = true;
    try {
      var data = await repository.getQuantityLicences();
      licences.value = data['licencas'];
      usersRegistered.value = data['usuarios'];
    } catch (e) {
      Exception(e);
    }
    isLoadingQuantityLicences.value = false;
  }

  Future<Map<String, dynamic>> insertUser() async {
    if (formUserKey.currentState!.validate()) {
      People people = People(
        nome: txtNomeController.text,
        foto: selectedImagePath.value,
        ddd: txtDDDController.text,
        telefone: txtTelefoneController.text,
        cpf: txtCpfController.text,
        apelido: txtApelidoController.text,
        cidade: txtCidadeController.text,
        uf: selectedState.value,
        status: 1,
        cupomParaIndicar: "",
        bairro: neighborhoodController.text,
        cep: cepController.text,
        endereco: addressController.text,
        numeroCasa: houseNumberController.text,
      );

      User user = User(
        email: txtEmailController.text,
        password: txtSenhaController.text,
        status: 1,
        cupomRecebido: ServiceStorage.getCodeIndicator(),
      );

      mensagem = await repository.insertUser(
          people, user, selectedVehicleDropDown.value);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getMyEmployees();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> updateUser(int id) async {
    if (formUserKey.currentState!.validate()) {
      People people = People(
        id: id,
        nome: txtNomeController.text,
        foto: selectedImagePath.value,
        ddd: txtDDDController.text,
        telefone: txtTelefoneController.text,
        cpf: txtCpfController.text,
        apelido: txtApelidoController.text,
        cidade: txtCidadeController.text,
        uf: selectedState.value,
        status: 1,
        cupomParaIndicar: "",
        bairro: neighborhoodController.text,
        cep: cepController.text,
        endereco: addressController.text,
        numeroCasa: houseNumberController.text,
      );

      User user = User(
        id: id,
        email: txtEmailController.text,
        password: txtSenhaController.text,
        status: 1,
        cupomRecebido: null,
      );

      mensagem = await repository.updateUser(
          people, user, selectedVehicleDropDown.value);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };

      getMyEmployees();
    }
    return retorno;
  }

  Future<Map<String, dynamic>> deleteUser(int id) async {
    if (id > 0) {
      mensagem = await repository.delete(User(id: id));
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      getMyEmployees();
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }

    return retorno;
  }

  void fillInFields(User user) {
    txtNomeController.text = user.people!.nome ?? '';
    FormattedInputers.onContactChanged(
        user.people!.telefone ?? '', txtTelefoneController);
    txtDDDController.text = user.people!.ddd ?? '';
    txtCidadeController.text = user.people!.cidade ?? '';
    txtUfController.text = user.people!.uf ?? '';
    selectedState.value = user.people!.uf ?? '';
    txtCpfController.text = user.people!.cpf ?? '';
    txtApelidoController.text = user.people!.apelido ?? '';
    txtEmailController.text = user.email ?? '';
    txtSenhaController.text = "";
    txtConfirmaSenhaController.text = "";
    if (user.vehicles!.isNotEmpty) {
      caminhoes.value =
          user.vehicles!.map((e) => "${e.marca}/${e.modelo}").join(', ');
      tituloVeiculosDoMotorista.value = "VEÍCULOS VINCULADOS:";
    } else {
      caminhoes.value = "";
      tituloVeiculosDoMotorista.value = "NENHUM VEÍCULO VINCULADO!";
    }
    cepController.text = user.people!.cep ?? '';
    addressController.text = user.people!.endereco ?? '';
    neighborhoodController.text = user.people!.bairro ?? '';
    houseNumberController.text = user.people!.numeroCasa ?? '';

    if (user.people!.foto != null && user.people!.foto!.isNotEmpty) {
      String imageUrl = user.people!.foto!;
      selectedImagePath.value = imageUrl;
      setImage(true);
    }
  }

  void clearAllFields() {
    final textControllers = [
      txtNomeController,
      txtTelefoneController,
      txtDDDController,
      txtCidadeController,
      txtUfController,
      txtCpfController,
      txtApelidoController,
      txtEmailController,
      txtSenhaController,
      txtConfirmaSenhaController,
      cepController,
      addressController,
      neighborhoodController,
      houseNumberController,
    ];

    for (final controller in textControllers) {
      controller.clear();
    }

    selectedImagePath = ''.obs;
    selectedState = ''.obs;

    selectedVehicleDropDown = 0.obs;
    setImage(false);
  }
}
