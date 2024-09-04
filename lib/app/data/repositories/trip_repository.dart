import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/providers/trip_provider.dart';

class TripRepository {
  final TripApiClient apiClient = TripApiClient();

  getAll() async {
    List<Trip> list = <Trip>[];

    try {
      var response = await apiClient.getAll();

      if (response != null) {
        response['data'].forEach((e) {
          list.add(Trip.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }

  insert(Trip trip) async {
    try {
      var response = await apiClient.insert(trip);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
  
  update(Trip trip) async {
    try {
      var response = await apiClient.update(trip);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  delete(Trip trip) async {
    try {
      var response = await apiClient.delete(trip);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  insertExpenseTrip(ExpenseTrip expense) async {
    try {
      var response = await apiClient.insertExpenseTrip(expense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  updateExpenseTrip(ExpenseTrip expense) async {
    try {
      var response = await apiClient.updateExpenseTrip(expense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  deleteExpenseTrip(ExpenseTrip expense) async {
    try {
      var response = await apiClient.deleteExpenseTrip(expense);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
