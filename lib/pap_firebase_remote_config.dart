// @dart=2.9
library pap_firebase_remote_config;

import 'dart:convert';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:pap_firebase_remote_config/services/platform_service.dart';

abstract class IPapRemoteConfigService {
  Future<void> initialize({String projectName});
  bool getBoolean({@required String variableName});
  String getString({@required String variableName});
  int getInt({@required String variableName});
}

class PapFirebaseRemoteConfigFactory {
  final IPlatformService _platformService;
  final RemoteConfig _remoteConfig;

  PapFirebaseRemoteConfigFactory(
      {@required IPlatformService platformService, RemoteConfig remoteConfig})
      : this._platformService = platformService,
        this._remoteConfig = remoteConfig;

  IPapRemoteConfigService getInstance() {
    if (!_platformService.isWeb()) {
      return _PapRemoteConfigServiceMobile(remoteConfig: this._remoteConfig);
    } else {
      return _PapRemoteConfigServiceWeb();
    }
  }
}

class _PapRemoteConfigServiceWeb extends IPapRemoteConfigService {
  String _apiUrl;
  Map<String, dynamic> _apiAnswer;

  @override
  bool getBoolean({@required String variableName}) {
    try {
      if (this
              ._apiAnswer['parameters'][variableName]['defaultValue']['value']
              .toString()
              .toLowerCase() ==
          'true')
        return true;
      else
        return false;
    } catch (e) {
      print('error' + e.toString());
      return false;
    }
  }

  @override
  String getString({@required String variableName}) {
    try {
      String value = this
          ._apiAnswer['parameters'][variableName]['defaultValue']['value']
          .toString();
      return value;
    } catch (e) {
      print('error' + e.toString());
      return '';
    }
  }

  @override
  int getInt({@required String variableName}) {
    try {
      int value = int.parse(
          this._apiAnswer['parameters'][variableName]['defaultValue']['value']);
      return value;
    } catch (e) {
      print('error' + e.toString());
      return 0;
    }
  }

  @override
  Future<void> initialize({String projectName}) async {
    this._apiUrl = 'https://firebaseremoteconfig.googleapis.com/v1/projects/' +
        projectName +
        '/remoteConfig';

    final String response = await rootBundle
        .loadString('assets/googlekey/service_account_key.json');
    final data = await json.decode(response);
    var accountCredentials = ServiceAccountCredentials.fromJson(data);

    var scopes = [
      'https://www.googleapis.com/auth/firebase.remoteconfig',
      'https://www.googleapis.com/auth/cloud-platform'
    ];

    String auth = '';

    var client = http.Client();
    await obtainAccessCredentialsViaServiceAccount(
            accountCredentials, scopes, client)
        .then((AccessCredentials credentials) async {
      // Access credentials are available in [credentials].
      auth = credentials.accessToken.data;
      client.close();
    });

    // send request..
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $auth",
    };

    var result = await http.get(
      Uri.parse(this._apiUrl),
      headers: headers,
    );

    this._apiAnswer = json.decode(result.body);
  }
}

class _PapRemoteConfigServiceMobile extends IPapRemoteConfigService {
  RemoteConfig _remoteConfig;

  _PapRemoteConfigServiceMobile({RemoteConfig remoteConfig}) {
    if (remoteConfig != null) _remoteConfig = remoteConfig;
    initialize();
  }

  initialize({String projectName}) async {
    if (_remoteConfig == null) {
      _remoteConfig = RemoteConfig.instance;
    }

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }

  @override
  bool getBoolean({@required String variableName}) {
    return _remoteConfig.getBool(variableName);
  }

  @override
  String getString({@required String variableName}) {
    return _remoteConfig.getString(variableName);
  }

  @override
  int getInt({@required String variableName}) {
    return _remoteConfig.getInt(variableName);
  }
}
