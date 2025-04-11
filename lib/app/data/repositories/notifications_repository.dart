import 'package:rodocalc/app/data/models/charge_type_model.dart';
import 'package:rodocalc/app/data/models/expense_category_model.dart';
import 'package:rodocalc/app/data/models/last_expense_trip_model.dart';
import 'package:rodocalc/app/data/models/notification_model.dart';
import 'package:rodocalc/app/data/models/specific_type_expense_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/vehicle_balance_model.dart';
import 'package:rodocalc/app/data/providers/notifications_provider.dart';
import 'package:rodocalc/app/data/providers/transaction_provider.dart';
import 'package:rodocalc/app/utils/services.dart';

class NotificationsRepository {
  final NotificationsApiClient apiClient = NotificationsApiClient();

  getAll() async {
    List<Notifications> list = <Notifications>[];

    var response = await apiClient.gettAll();

    if (response != null) {
      response['data'].forEach((e) {
        list.add(Notifications.fromJson(e));
      });
    }

    return list;
  }

  markRead(int id) async {
    try {
      var response = await apiClient.markRead(id);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
