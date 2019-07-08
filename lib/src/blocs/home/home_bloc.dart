import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instrument/src/blocs/home/home_event.dart';
import 'package:instrument/src/blocs/home/home_state.dart';
import 'package:instrument/src/db/app_db.dart';
import 'package:instrument/src/db/wom_request_db.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:wom_package/wom_package.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController amountController = TextEditingController();
  AimRepository _aimRepository;
  WomRequestDb _requestDb;

  HomeBloc() {
    _aimRepository = AimRepository();
    _requestDb = WomRequestDb.get();
    _aimRepository.updateAim(AppDatabase.get().getDb()).then((_) {
      dispatch(LoadRequest());
    });
  }

  @override
  get initialState => RequestLoading();

  @override
  Stream<HomeState> mapEventToState(event) async* {
    if (event is LoadRequest) {
      final List<Aim> aims =
      await _aimRepository.getFlatAimList(AppDatabase.get().getDb());
      final List<WomRequest> requests = await _requestDb.getRequests();
      for (WomRequest r in requests) {
        final Aim aim = aims.firstWhere((a) {
          return a.code == r.aimCode;
        }, orElse: () {
          return null;
        });
        r.aim = aim;
      }

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
