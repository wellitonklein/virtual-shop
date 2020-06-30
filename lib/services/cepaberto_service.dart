import 'dart:io';

import 'package:dio/dio.dart';
import 'package:virtual_shop/models/cepaberto_address.dart';

const String token = '1595c6b20d5bcd5cae931ac5457a19d7';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = 'https://www.cepaberto.com/api/v3/cep?cep=$cleanCep';

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data.isEmpty) {
        return Future.error('CEP inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError catch (_) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
