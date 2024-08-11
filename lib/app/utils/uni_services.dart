// import 'dart:math';
//
// import 'package:flutter/services.dart';
// import 'package:uni_links3/uni_links.dart';
//
// class UniServices {
//   static String _code = '';
//
//   static String get code => _code;
//
//   static bool get hasCode => _code.isNotEmpty;
//
//   static void reset() => _code = '';
//
//   static init() async {
//     try {
//       final Uri? uri = await getInitialUri();
//       uniHandler(uri);
//     } on PlatformException catch (e) {
//       log('Falha' as num);
//     } on FormatException catch (e) {
//       log(e as num);
//     }
//
//     uriLinkStream.listen((Uri? uri) async {
//       uniHandler(uri);
//     }, onError: (error) {
//       log('Erro: $error' as num);
//     });
//   }
//
//   static uniHandler(Uri? uri) {
//     if (uri == null || uri.queryParameters.isEmpty) return;
//
//     Map<String, String> param = uri.queryParameters;
//
//     String? receivedCode = param['code'];
//
//     print(receivedCode);
//   }
// }
