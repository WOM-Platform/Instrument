import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instrument/src/db/wom_request_db.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:instrument/src/screens/generate_wom/pages/aim_selection/bloc.dart';
import 'package:wom_package/wom_package.dart';

import '../../constants.dart';

class GenerateWomBloc extends Bloc {
  AimSelectionBloc aimSelectionBloc;

  TextEditingController nameController;
  TextEditingController amountController;
  TextEditingController passwordController;
  final PageController pageController = PageController();

  LatLng currentPosition;
  LatLng lastPosition;

  int get _amount => int.tryParse(amountController.text);

  final WomRequest draftRequest;

  GenerateWomBloc({@required this.draftRequest}) {
    print("GenerateWomBloc()");
    nameController = TextEditingController(text: draftRequest?.name ?? "");
    amountController =
        TextEditingController(text: draftRequest?.amount?.toString() ?? "");
    passwordController =
        TextEditingController(text: draftRequest?.password ?? "");
    aimSelectionBloc = AimSelectionBloc();
    if (draftRequest?.aimCode != null) {
      aimSelectionBloc.setAimCode(draftRequest.aimCode);
    }
    getLastPosition();
  }

  createModelForCreationRequest() async {
    final aim = await aimSelectionBloc.getAim();
    final String password = passwordController.text;
    final String name = nameController.text;

    final WomRequest womRequest = WomRequest(
      sourceId: "1",
//      password: password,
      dateTime: DateTime.now(),
      amount: _amount,
      aim: aim,
      aimName: aim?.title,
      aimCode: aim?.code,
      location: currentPosition,
      name: name,
      status: RequestStatus.DRAFT,
    );

    if (draftRequest != null) {
      womRequest.id = draftRequest.id;
    }

    return womRequest;
  }

  goToNextPage() {
    pageController.nextPage(
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  goToPreviousPage() {
    pageController.previousPage(
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  bool get isValidName => _validateName();

  bool get isValidAmount => _validateAmount();

  bool get isValidAim => _validateAim();

  bool get isValidPosition => _validatePosition();

  bool get isValidPassword => _validatePassword();

  saveCurrentPosition() async {
    print("saveCurrentPosition");
    MmkvFlutter mmkv = await MmkvFlutter.getInstance();
    mmkv.setDouble(LAST_LATITUDE, currentPosition.latitude);
    mmkv.setDouble(LAST_LONGITUDE, currentPosition.longitude);
    print("currentPositionSaved");
  }

  getLastPosition() async {
    print("getLastPosition");
    MmkvFlutter mmkv = await MmkvFlutter.getInstance();
    final latitude = await mmkv.getDouble(LAST_LATITUDE);
    final longitude = await mmkv.getDouble(LAST_LONGITUDE);

    if (latitude == null || longitude == null) {
      lastPosition = null;
    }
    print("lastPosition = $latitude, $longitude");
    lastPosition = LatLng(latitude, longitude);
  }

  _validatePassword() {
    final password = passwordController.text;
    if (password != null && password.length == 4) {
      return true;
    }
    return false;
  }

  _validatePosition() {
    print("_validatePosition");
    print(currentPosition);
    if (currentPosition != null) {
      return true;
    }
    return false;
  }

  _validateAim() {
    final aimCode = aimSelectionBloc.getAimCode();
    if (aimCode != null) {
      return true;
    }
    return false;
  }

  _validateAmount() {
    final amount = _amount;
    if (amount != null && amount > 0 && amount <= 1000) {
      return true;
    }
    return false;
  }

  _validateName() {
    final name = nameController.text;
    if (name.isNotEmpty && name.length > 4) {
      return true;
    }
    return false;
  }

  saveDraftRequest() async {
    print("saveDraftRequest");
    final db = WomRequestDb.get();
    final womRequest = await createModelForCreationRequest();
    try{
      if(draftRequest == null){
        await db.insertRequest(womRequest);
      }else{
        await db.updateRequest(womRequest);
      }
    }catch(ex){
      print(ex.toString());
    }
  }

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    passwordController.dispose();
    amountController.dispose();
    aimSelectionBloc.dispose();
//    _streamPage.close();
    super.dispose();
  }
}
