import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wom_package/wom_package.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class WomRequest {
  static String TABLE = "requeests";
  static String ID = "id";
  static String DEEP_LINK = "deepLink";
  static String AIM_CODE = "aim_code";
  static String AIM_NAME = "aim_name";
  static String AMOUNT = "amount";
  static String STATUS = "status";
  static String NAME = "name";
  static String PASSWORD = "Password";
  static String DATE = "date";
  static String URL = "url";
  static String SOURCE_ID = "SourceId";
  static String LATITUDE = "longitude";
  static String LONGITUDE = "latitude";
  static String NONCE = "Nonce";
  static String VOUCHERS = "Vouchers";
  static String PAYLOAD = "Payload";

  int amount;
  DateTime dateTime;
  String password;
  String registryUrl;
  String name;
  RequestStatus status;
  int id;
  String nonce;
  String aimCode;
  String sourceId;
  List<Wom> vouchers;
  LatLng location;
  Aim aim;
  String aimName;
  String deepLink;

  WomRequest({
    this.id,
    this.amount,
    this.dateTime,
    this.password,
    this.registryUrl,
    this.name,
    this.aim,
    this.status,
    this.aimCode,
    this.aimName,
    this.deepLink,
    this.sourceId,
    this.location,
  }) {
    this.nonce = generateGUID();
  }

  WomRequest.fromMap(Map<String, dynamic> map)
      : this.id = map[ID],
        this.amount = map[AMOUNT],
        this.dateTime = DateTime.fromMillisecondsSinceEpoch(map[DATE]),
        this.aimCode = map[AIM_CODE],
        this.aimName = map[AIM_NAME],
        this.location = (map[LATITUDE] != null && map[LONGITUDE] != null)
            ? LatLng(map[LATITUDE], map[LONGITUDE])
            : null,
        this.name = map[NAME],
        this.nonce = map[NONCE],
        this.password = map[PASSWORD],
        this.deepLink = map[DEEP_LINK],
        this.sourceId = map[SOURCE_ID],
        this.status = RequestStatus.values[map[STATUS]],
        this.registryUrl = map[URL];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map();
    map[AMOUNT] = this.amount;
    map[URL] = this.registryUrl;
    map[PASSWORD] = this.password;
    map[NAME] = this.name;
    map[DATE] = this.dateTime?.millisecondsSinceEpoch;
    map[AIM_CODE] = this.aimCode;
    map[AIM_NAME] = this.aimName;
    map[LATITUDE] = this.location?.latitude;
    map[LONGITUDE] = this.location?.longitude;
    map[NONCE] = this.nonce;
    map[DEEP_LINK] = this.deepLink;
    map[SOURCE_ID] = this.sourceId;
    map[STATUS] = this.status.index;
    return map;
  }

  toPayloadMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[SOURCE_ID] = this.sourceId;
    data[NONCE] = this.nonce;
//    data[PASSWORD] = this.password;
    data[VOUCHERS] = [createWoucher().toMap()];
    return data;
  }

  Wom createWoucher() {
    return Wom(
      aim: aim?.code ?? aimCode,
      latitude: location.latitude,
      longitude: location.longitude,
      timestamp: dateTime,
      count: amount ?? 1,
    );
  }
/*
  List<Wom> createVouchers() {
    return List(amount).map((_) {
      return Wom(
        aim: aim?.code ?? aimCode,
        latitude: location.latitude,
        longitude: location.longitude,
        timestamp: dateTime,
        count: amount ?? 1,
      );
    }).toList();
  }*/

  WomRequest copyFrom() {
    return WomRequest(
      amount: this.amount,
      dateTime: DateTime.now().toUtc(),
      password: this.password,
      registryUrl: this.registryUrl,
      name: this.name,
      aim: this.aim,
      aimCode: this.aimCode,
      aimName: this.aimName,
      status: this.status,
      sourceId: this.sourceId,
      location: this.location,
    );
  }

  String get dateString => DateFormat.yMd().format(dateTime);

  @override
  String toString() {
    return "$name, $dateTime, $aimName, $amount, $password, $status, $registryUrl";
  }
}
