import 'package:bloc/bloc.dart';
import 'package:instrument/src/db/wom_request_db.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:wom_package/wom_package.dart';
import 'package:instrument/src/screens/request_confirm/wom_creation_event.dart';
import 'package:instrument/src/screens/request_confirm/wom_creation_state.dart';
import 'package:instrument/src/services/wom_request/repository.dart';
import 'package:meta/meta.dart';

class RequestConfirmBloc extends Bloc<WomCreationEvent, WomCreationState> {
  WomRequestRepository _repository;
  final WomRequest womRequest;

  WomRequestDb _requestDb;

  RequestConfirmBloc({@required this.womRequest}) {
    _repository = WomRequestRepository();
    _requestDb = WomRequestDb.get();
    dispatch(CreateWomRequest());
  }

  @override
  get initialState => WomCreationRequestEmpty();

  @override
  Stream<WomCreationState> mapEventToState(event) async* {
    if (event is CreateWomRequest) {
      yield WomCreationRequestLoading();

      final RequestVerificationResponse response =
          await _repository.requestWomCreation(womRequest);
      if (response.error != null) {
        print(response.error);
        insertRequestOnDb();
        yield WomCreationRequestError(error: response.error);
      } else {
        final bool verificationResponse =
            await _repository.verifyWomCreation(response);
        if (verificationResponse) {
          womRequest.deepLink =
              DeepLinkBuilder(response.otc, TransactionType.VOUCHERS).build();
          print(womRequest.deepLink);
          womRequest.status = RequestStatus.COMPLETE;
          womRequest.registryUrl = response.registryUrl;
          womRequest.password = response.password;
          await insertRequestOnDb();
          yield WomVerifyCreationRequestComplete(
            response: response,
          );
        } else {
          womRequest.status = RequestStatus.DRAFT;
          insertRequestOnDb();
          yield WomCreationRequestError(error: response.error);
        }
      }
    }
  }

  insertRequestOnDb() async {
    try {
      if (womRequest.id == null) {
        int id = await _requestDb.insertRequest(womRequest);
        print(id);
        womRequest.id = id;
        print(womRequest.id);
      } else {
        await _requestDb.updateRequest(womRequest);
      }
    } catch (ex) {
      print(ex.toString());
    }
  }
}
