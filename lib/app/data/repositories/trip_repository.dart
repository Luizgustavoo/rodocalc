import 'package:rodocalc/app/data/models/expense_trip_model.dart';
import 'package:rodocalc/app/data/models/transactions_model.dart';
import 'package:rodocalc/app/data/models/trip_model.dart';
import 'package:rodocalc/app/data/models/viagens_model.dart';
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

  getTripsWithFilter(
      {String? dataInicial, String? dataFinal, String? search}) async {
    List<Viagens> list = <Viagens>[];

    try {
      var response = await apiClient.getTripsWithFilter(
        dataInicial: dataInicial,
        dataFinal: dataFinal,
        search: search,
      );

      if (response != null) {
        response['data'].forEach((e) {
          list.add(Viagens.fromJson(e));
        });
      } else {
        return null;
      }
    } catch (e) {
      Exception(e);
    }

    return list;
  }

  generatePDF({String? dataInicial, String? dataFinal, String? search}) async {
    List<Trip> list = <Trip>[];

    try {
      return await apiClient.generatePDF(
        dataInicial: dataInicial,
        dataFinal: dataFinal,
        search: search,
      );
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

  insertFotoTrecho(Trip trip) async {
    try {
      var response = await apiClient.insertFotoTrecho(trip);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  insertFotoTrechoTransaction(Transacoes transaction) async {
    try {
      var response = await apiClient.insertFotoTrechoTransaction(transaction);
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

  deletePhotoTrip(int id) async {
    try {
      var response = await apiClient.deletePhotoTrip(id);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  deleteExpensePhotoTrip(int id) async {
    try {
      var response = await apiClient.deleteExpensePhotoTrip(id);
      return response;
    } catch (e) {
      Exception(e);
    }
  }

  close(Trip trip) async {
    try {
      var response = await apiClient.close(trip);
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

  deleteTransactionTrip(int id) async {
    try {
      var response = await apiClient.deleteTransactionTrip(id);
      return response;
    } catch (e) {
      Exception(e);
    }
  }
}
