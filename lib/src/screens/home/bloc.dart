import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instrument/src/db/app_db.dart';
import 'package:instrument/src/db/wom_request_db.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:instrument/src/screens/home/home_event.dart';
import 'package:instrument/src/screens/home/home_state.dart';
import 'package:instrument/src/services/aim/repository.dart';
import 'package:wom_package/wom_package.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController amountController = TextEditingController();

  AimRepository _aimRepository;
  WomRequestDb _requestDb;

  HomeBloc() {
    _aimRepository = AimRepository();
    _aimRepository.updateAim(AppDatabase.get().getDb());
    _requestDb = WomRequestDb.get();
    dispatch(LoadRequest());
  }

  @override
  get initialState => RequestLoading();

  @override
  Stream<HomeState> mapEventToState(event) async* {
    if (event is LoadRequest) {
      final List<WomRequest> requests = await _requestDb.getRequests();
      debugPrint("requests: ${requests.length}");
      yield RequestLoaded(requests: requests);
    }
  }

  Future<int> deleteRequest(int id) async {
    return await _requestDb.deleteRequest(id);
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
