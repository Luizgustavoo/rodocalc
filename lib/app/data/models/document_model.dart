import 'document_type_model.dart';

class DocumentModel {
  int? id;
  String? descricao;
  int? tipoDocumentoId;
  int? pessoaId;
  String? arquivo;
  String? imagemPdf;
  int? status;
  String? createdAt;
  String? updatedAt;

  String? nomeDocumento;
  String? base64Content;
  String? dataVencimento;

  DocumentType? documentType;

  DocumentModel({
    this.id,
    this.descricao,
    this.tipoDocumentoId,
    this.pessoaId,
    this.arquivo,
    this.imagemPdf,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.nomeDocumento,
    this.base64Content,
    this.dataVencimento,
    this.documentType,
  });

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    tipoDocumentoId = json['tipodocumento_id'];
    pessoaId = json['pessoa_id'];
    arquivo = json['arquivo'];
    imagemPdf = json['imagem_pdf'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    documentType = json['tipodocumento'] != null
        ? DocumentType.fromJson(json['tipodocumento'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['tipodocumento_id'] = tipoDocumentoId;
    data['pessoa_id'] = pessoaId;
    data['arquivo'] = arquivo;
    data['imagem_pdf'] = imagemPdf;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (documentType != null) {
      data['tipodocumento'] = documentType!.toJson();
    }

    return data;
  }

  bool isEmpty() {
    return id == null && descricao == null && arquivo == null;
  }
}
