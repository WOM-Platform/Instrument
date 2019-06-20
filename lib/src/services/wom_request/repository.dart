import 'package:flutter/services.dart';
import 'package:instrument/src/constants.dart';
import 'package:instrument/src/model/wom_request.dart';
import 'dart:convert';
import 'package:instrument/src/services/wom_request/api.dart';
import 'package:simple_rsa/simple_rsa.dart';
import 'package:wom_package/wom_package.dart';

import '../../../app.dart';

class WomRequestRepository {
  WomRequestApiProvider _apiProvider;

  WomRequestRepository() {
    _apiProvider = WomRequestApiProvider();
  }

  Future<RequestVerificationResponse> requestWomCreation(
      WomRequest womRequest) async {
    try {
      final payloadMap = womRequest.toPayloadMap();

      print(payloadMap);

      //encode map to json string
      final payloadMapEncoded = json.encode(payloadMap);

//      final privateKeyString1 = await _loadKey('assets/source.pem');
      final privateKeyString = user.privateKey;
      final publicKeyString = await _loadKey('assets/registry.pub');
//      final publicKeyString = user.publicKey;

//      assert(publicKeyString == publicKeyString1);
//      assert(privateKeyString == privateKeyString1);

      final encrypted = await encryptString(payloadMapEncoded, publicKeyString);

      final Map<String, dynamic> map = {
        "SourceId": womRequest.sourceId,
        "Nonce": womRequest.nonce,
        "Payload": encrypted,
      };
      print("requestWomCreation()");
      print(map);

      final responseBody =
          await _apiProvider.requestWomCreation(URL_CREATION_REQUEST, map);

      //decode response body into json
      final jsonResponse = json.decode(responseBody);

      final decryptedPayload =
          await decryptString(jsonResponse["payload"], privateKeyString);

      //decode decrypted paylod into json
      final Map<String, dynamic> jsonDecrypted = json.decode(decryptedPayload);
      print(jsonDecrypted.toString());
      return RequestVerificationResponse.fromMap(jsonDecrypted);
    } catch (ex) {
      return RequestVerificationResponse(ex.toString());
    }
  }

  Future<bool> verifyWomCreation(RequestVerificationResponse response) async {
    final Map<String, String> payloadMap = {
      "Otc": response.otc,
    };

    print(payloadMap);

    try {
      final String payloadMapEncoded = json.encode(payloadMap);
      final String publicKeyString = await _loadKey('assets/registry.pub');
//      final String publicKeyString = user.publicKey;
//      assert(publicKeyString == publicKeyString1);
      final String payloadEncrypted =
          await encryptString(payloadMapEncoded, publicKeyString);

      final Map<String, dynamic> map = {
        "Payload": payloadEncrypted,
      };

      return _apiProvider.verifyWomCreation(URL_CREATION_VERIFICATION, map);
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  Future<String> _loadKey(String path) async {
    return await rootBundle.loadString(path);
  }
}
