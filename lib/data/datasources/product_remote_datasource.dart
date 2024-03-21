import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDataSource {

  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDataSource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/product'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        return Right(ProductResponseModel.fromJson(response.body));
      } on Exception catch (ex, strace) {
         print('Stack trace:\n $strace');
        return const Left('Failed to get products');
      }
    } else {
      return const Left('Failed to get products');
    }
  }
}