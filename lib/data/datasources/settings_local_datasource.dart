import 'package:flutter_posresto_app/presentation/setting/models/tax_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  // save tax to shared preferences
  Future<bool> saveTax(TaxModel taxModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('tax', taxModel.toJson());
  }

  // get tax from shared preferences
  Future<TaxModel> getTax() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final tax = prefs.getString('tax');
    if (null == tax) {
      return TaxModel(name: 'Pajak Pertambahan Nilai', type: TaxType.pajak, value: 11);
    }
    return TaxModel.fromJson(tax);
  }

  // save service charge to shared preferences
  Future<bool> saveServiceCharge(int serviceCharge) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt('serviceCharge', serviceCharge);
  }

  // get service charge from shared preferences
  Future<int> getServiceCharge() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('serviceCharge') ?? 0;
  }
}