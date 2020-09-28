import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:isolate/ports.dart';
import 'package:frusty_logger/frusty_logger.dart';

import 'constants.dart' as ffi;
import 'ffi.dart' as ffi;

class SunshineClient {
  SunshineClient({
    @required Directory root,
    @required Uri chainspecPath,
  })  : _root = root,
        _chainspecPath = chainspecPath {
    ffi.store_dart_post_cobject(NativeApi.postCObject);
    FrustyLogger.init(ffi.dl);
  }

  final Directory _root;
  final Uri _chainspecPath;
  bool _started = false;

  Future<bool> get ready => startUpClient();
  Future<bool> startUpClient() async {
    // to avoid any other calls
    if (_started) {
      return true;
    }
    FrustyLogger.addListener(print);
    final spec = (await _getChainspecPath()).toUtf8Pointer();
    final completer = Completer<int>();
    final port = singleCompletePort(completer);
    final result = ffi.client_init(
      port.nativePort,
      _root.path.toUtf8Pointer(),
      spec,
    );
    if (result == ffi.ok) {
      return _clientInitOkay(completer.future);
    } else if (result == ffi.alreadyInit) {
      return true;
    } else {
      throw StateError('Status Code: $result');
    }
  }

  Future<bool> hasKey() {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final result = ffi.client_key_exists(port.nativePort);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<String> uid() {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final result = ffi.client_key_uid(port.nativePort);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<bool> lockKey() {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final result = ffi.client_key_lock(port.nativePort);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<bool> unlockKey(String password) {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final result =
        ffi.client_key_unlock(port.nativePort, password.toUtf8Pointer());
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<String> setKey(String password, {String suri, String paperKey}) {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final s = suri != null ? suri.toUtf8Pointer() : nullptr;
    final phrase = paperKey != null ? paperKey.toUtf8Pointer() : nullptr;
    final result = ffi.client_key_set(
        port.nativePort, password.toUtf8Pointer(), s, phrase);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<bool> updatePassword(String password) {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final result = ffi.client_account_change_password(
      port.nativePort,
      password.toUtf8Pointer(),
    );
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<BigInt> balance(String identifier) {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final id = identifier != null ? identifier.toUtf8Pointer() : nullptr;
    final result = ffi.client_wallet_balance(port.nativePort, id);
    assert(result == ffi.ok);
    return completer.future.then(BigInt.parse);
  }

  Future<String> transfer(String identifier, BigInt amount) {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final result = ffi.client_wallet_transfer(
      port.nativePort,
      identifier.toUtf8Pointer(),
      amount.toInt(),
    );
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<BigInt> mint() {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final result = ffi.client_faucet_mint(port.nativePort);
    assert(result == ffi.ok);
    return completer.future.then(BigInt.parse);
  }

  Future<String> currentDevice() {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final result = ffi.client_device_current(port.nativePort);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<bool> hasDeviceKey() {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final result = ffi.client_device_has_key(port.nativePort);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<bool> addDevice(String deviceId) {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final id = Utf8.toUtf8(deviceId);
    final result = ffi.client_device_add(port.nativePort, id);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<bool> removeDevice(String deviceId) {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final id = Utf8.toUtf8(deviceId);
    final result = ffi.client_device_remove(port.nativePort, id);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<List<String>> listDevices(String identifier) {
    final completer = Completer<List<dynamic>>();
    final port = singleCompletePort(completer);
    final id = Utf8.toUtf8(identifier);
    final result = ffi.client_device_list(port.nativePort, id);
    assert(result == ffi.ok);
    return completer.future.then((value) {
      return value.map((e) => e.toString()).toList();
    });
  }

  Future<String> addPaperKey() {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final result = ffi.client_device_paperkey(port.nativePort);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<List<String>> listIdentities(String uid) {
    final completer = Completer<List<dynamic>>();
    final port = singleCompletePort(completer);
    final id = Utf8.toUtf8(uid);
    final result = ffi.client_id_list(port.nativePort, id);
    assert(result == ffi.ok);
    return completer.future.then((value) {
      return value.map((e) => e.toString()).toList();
    });
  }

  Future<String> resolveUid(String identifier) {
    final completer = Completer<String>();
    final port = singleCompletePort(completer);
    final id = Utf8.toUtf8(identifier);
    final result = ffi.client_id_resolve(port.nativePort, id);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<List<String>> proveIdentity(String service) {
    final completer = Completer<List<dynamic>>();
    final port = singleCompletePort(completer);
    final s = Utf8.toUtf8(service);
    final result = ffi.client_id_prove(port.nativePort, s);
    assert(result == ffi.ok);
    return completer.future.then((value) {
      return value.map((e) => e.toString()).toList();
    });
  }

  Future<bool> revokeIdentity(String service) {
    final completer = Completer<bool>();
    final port = singleCompletePort(completer);
    final s = Utf8.toUtf8(service);
    final result = ffi.client_id_revoke(port.nativePort, s);
    assert(result == ffi.ok);
    return completer.future;
  }

  Future<bool> _clientInitOkay(FutureOr<int> f) async {
    final start = DateTime.now();
    final res = await f;
    final end = DateTime.now();
    final elapsed = end.difference(start);
    print(
      'Client Started in:\n'
      '\t=> ${elapsed.inMinutes} min\n'
      '\t=> ${elapsed.inSeconds} sec\n',
    );
    _started = res == ffi.ok;
    return res == ffi.ok;
  }

  // ignore: unused_element
  Future<String> _getChainspecPath() async {
    final path = '${_root.path}/chainspec.json';
    final exists = File(path).existsSync();
    if (exists) {
      return path;
    } else {
      final bytes = await rootBundle.load(
        _chainspecPath.path,
      );
      final f = await File(path).writeAsBytes(
        bytes.buffer.asUint8List(),
        flush: true,
      );
      return f.path;
    }
  }
}

extension BigIntUtf8Pointer on BigInt {
  Pointer<Utf8> toUtf8Pointer() {
    return Utf8.toUtf8(toString());
  }
}

extension StringUtf8Pointer on String {
  Pointer<Utf8> toUtf8Pointer() {
    return Utf8.toUtf8(this);
  }
}
