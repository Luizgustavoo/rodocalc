import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/models/user_type_model.dart';
import 'package:rodocalc/app/data/repositories/auth_repository.dart';
import 'package:rodocalc/app/data/repositories/cep_repository.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class SignUpController extends GetxController {
  var selectedImagePath = ''.obs;
  var selectedState = ''.obs;

  RxList<UserType> listUserTypes = RxList<UserType>([]);
  var isLoading = false.obs;
  var isLoadingIndicatorName = false.obs;
  var selectedUserType = 0.obs;
  var indicatorName = "".obs;

  final TextEditingController txtNomeController = TextEditingController();
  final TextEditingController txtTelefoneController = TextEditingController();
  final TextEditingController txtDDDController = TextEditingController();
  final TextEditingController txtCidadeController = TextEditingController();
  final TextEditingController txtUfController = TextEditingController();
  final TextEditingController txtCpfController = TextEditingController();
  final TextEditingController txtApelidoController = TextEditingController();
  final TextEditingController txtEmailController = TextEditingController();
  final TextEditingController txtSenhaController = TextEditingController();
  final TextEditingController txtCodigoIndicadorController =
      TextEditingController(text: ServiceStorage.getCodeIndicator().toString());
  final TextEditingController txtConfirmaSenhaController =
      TextEditingController();

  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final formSignupKey = GlobalKey<FormState>();

  RxBool loading = false.obs;

  final repository = Get.put(AuthRepository());
  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

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
      }
    } else {
      Get.snackbar('Erro', 'Nenhuma imagem selecionada');
    }
  }

  Future<Map<String, dynamic>> insertUser() async {
    if (formSignupKey.currentState!.validate()) {
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
        cupomRecebido: txtCodigoIndicadorController.text,
        userTypeId: selectedUserType.value,
      );

      mensagem = await repository.insertUser(people, user);
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
    }
    return retorno;
  }

  Future<void> getUserTypes() async {
    isLoading.value = true;
    try {
      listUserTypes.value = await repository.getUserTypes();
    } catch (e) {
      Exception(e);
    }
    isLoading.value = false;
  }

  Future<bool> getIndicador() async {
    isLoadingIndicatorName.value = true;
    try {
      String id = txtCodigoIndicadorController.text;
      People peopleIndicator = await repository.getIndicador(id);
      indicatorName.value =
          (peopleIndicator.nome != null && peopleIndicator.nome!.isNotEmpty)
              ? peopleIndicator.nome.toString()
              : "CÓDIGO INVÁLIDO";

      if (peopleIndicator.nome != null && peopleIndicator.nome!.isNotEmpty) {
        return true;
      }
    } catch (e) {
      Exception(e);
      return false;
    }
    isLoadingIndicatorName.value = false;
    return false;
  }
}
