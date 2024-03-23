import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/order_model.dart';
import 'package:http/http.dart' as http;
class OrderRemoteDataSource {
  // save order to remote
  Future<bool> saveOrder(OrderModel orderModel) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/order'),
      body: orderModel.toJson(),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}