class Document {
  final String id;
  final String nomeDocumento;
  String? base64Content;
  String? dataVencimento;

  Document({
    required this.id,
    required this.nomeDocumento,
    this.base64Content,
    this.dataVencimento,
  });
}
