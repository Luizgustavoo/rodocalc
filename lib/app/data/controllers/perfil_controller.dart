// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/controllers/login_controller.dart';
import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/repositories/cep_repository.dart';
import 'package:rodocalc/app/data/repositories/perfil_repository.dart';
import 'package:rodocalc/app/routes/app_routes.dart';
import 'package:rodocalc/app/utils/formatter.dart';
import 'package:rodocalc/app/utils/service_storage.dart';

class PerfilController extends GetxController {
  var selectedImagePath = ''.obs;
  var selectedState = ''.obs;

  final perfilKey = GlobalKey<FormState>();

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

  RxInt userTypeUpdateController = 0.obs;

  final cepRepository = Get.put(CepRepository());

  void fetchAddressFromCep(String cep) async {
    if (cep.length == 9) {
      final address = await cepRepository.getAddressByCep(cep);
      if (address != null) {
        addressController.text = address.logradouro;
        neighborhoodController.text = address.bairro;
        txtCidadeController.text = "${address.cidade}-${address.uf}";
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

  Map<String, dynamic> retorno = {
    "success": false,
    "data": null,
    "message": ["Preencha todos os campos!"]
  };
  dynamic mensagem;

  final repository = Get.put(PerfilRepository());

  void fillInFields() {
    Auth auth = ServiceStorage.getDataUser();

    if (auth.user != null) {
      txtNomeController.text = auth.user!.people!.nome ?? '';
      FormattedInputers.onContactChanged(
          auth.user!.people!.telefone ?? '', txtTelefoneController);
      txtDDDController.text = auth.user!.people!.ddd ?? '';
      txtCidadeController.text = auth.user!.people!.cidade ?? '';
      txtUfController.text = auth.user!.people!.uf ?? '';
      txtCpfController.text = auth.user!.people!.cpf ?? '';
      txtApelidoController.text = auth.user!.people!.apelido ?? '';
      txtEmailController.text = auth.user!.email ?? '';
      cepController.text = auth.user!.people!.cep ?? '';
      neighborhoodController.text = auth.user!.people!.bairro ?? '';
      addressController.text = auth.user!.people!.endereco ?? '';
      houseNumberController.text = auth.user!.people!.numeroCasa ?? '';

      if (auth.user!.people!.foto != null &&
          auth.user!.people!.foto!.isNotEmpty) {
        String imageUrl = auth.user!.people!.foto!;

        if (!imageUrl.startsWith('http')) {
          imageUrl = '$urlImagem/storage/fotos/users/$imageUrl';
        }

        selectedImagePath.value = imageUrl;
        selectedState.value = auth.user!.people!.uf ?? '';
      }
    }
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

  Future<Map<String, dynamic>> updateUser() async {
    if (perfilKey.currentState!.validate()) {
      People people = People(
        id: ServiceStorage.getUserId(),
        nome: txtNomeController.text,
        foto: selectedImagePath.value,
        ddd: txtDDDController.text,
        telefone: txtTelefoneController.text,
        cpf: txtCpfController.text,
        apelido: txtApelidoController.text,
        cep: cepController.text,
        numeroCasa: houseNumberController.text,
        cidade: txtCidadeController.text,
        uf: selectedState.value,
        endereco: addressController.text,
        bairro: neighborhoodController.text,
        status: 1,
      );

      User user = User(
        id: ServiceStorage.getUserId(),
        email: txtEmailController.text,
        password: txtSenhaController.text,
        status: 1,
      );

      if (userTypeUpdateController.value > 0) {
        user.userTypeId = userTypeUpdateController.value;
      }

      mensagem = await repository.updateUser(people, user);
      if (mensagem != null) {
        retorno = {'success': mensagem['success'], 'message': mensagem['data']};
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }

  deleteAccount() async {
    mensagem = await repository.deleteUser();
    if (mensagem != null) {
      retorno = {
        'success': mensagem['success'],
        'message': mensagem['message']
      };
      final loginController = Get.put(LoginController());
      loginController.loginKey.currentState?.dispose();
      loginController.logout();
      Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed(Routes.login);
      });
    } else {
      retorno = {
        'success': false,
        'message': ['Falha ao realizar a operação!']
      };
    }

    return retorno;
  }
}
