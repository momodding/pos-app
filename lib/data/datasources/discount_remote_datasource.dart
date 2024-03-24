import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/discount_response_model.dart';
import 'package:http/http.dart' as http;
class DiscountRemoteDataSource {
  // get discount data from remote server
  Future<Either<String, DiscountResponseModel>> getDiscounts() async {
    final authData = await AuthLocalDataSource().getAuthData();
    final response = await http.get(Uri.parse('${Variables.baseUrl}/api/discount'), headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      try {
        return Right(DiscountResponseModel.fromJson(response.body));
      } on Exception {
        return const Left('Failed to get discounts');
      }
    } else {
      return const Left('Failed to get discounts');
    }
  }

  // add discount data to remote server
  Future<Either<String, bool>> addDiscount(Map<String, dynamic> data) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final response = await http.post(Uri.parse('${Variables.baseUrl}/api/discount'), headers: {
      'Authorization': 'Bearer ${authData.token}',
      'Accept': 'application/json',
    }, body: data);
    if (response.statusCode == 201) {
      return const Right(true);
    } else {
      return const Left('Failed to add discount');
    }
  }
}