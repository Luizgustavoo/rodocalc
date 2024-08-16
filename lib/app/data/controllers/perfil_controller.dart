import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rodocalc/app/data/base_url.dart';
import 'package:rodocalc/app/data/models/auth_model.dart';
import 'package:rodocalc/app/data/models/people_model.dart';
import 'package:rodocalc/app/data/models/user_model.dart';
import 'package:rodocalc/app/data/repositories/perfil_repository.dart';
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

      if (auth.user!.people!.foto != null &&
          auth.user!.people!.foto!.isNotEmpty) {
        String imageUrl = auth.user!.people!.foto!;

        if (!imageUrl.startsWith('http')) {
          imageUrl = '$urlImagem/storage/fotos/users/$imageUrl';
        }

        selectedImagePath.value = imageUrl;
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
        cidade: txtCidadeController.text,
        uf: selectedState.value,
        status: 1,
      );

      User user = User(
        id: ServiceStorage.getUserId(),
        email: txtEmailController.text,
        password: txtSenhaController.text,
        status: 1,
      );

      mensagem = await repository.updateUser(people, user);
      if (mensagem != null) {
        retorno = {
          'success': mensagem['success'],
          'message': mensagem['message']
        };
      } else {
        retorno = {
          'success': false,
          'message': ['Falha ao realizar a operação!']
        };
      }
    }
    return retorno;
  }
}
