import 'package:sunshine/models/models.dart';
import 'package:sunshine/sunshine.dart';
import 'package:injectable/injectable.dart';

import 'client_service.dart';
import 'sunshine_client_service.dart';

@prod
@LazySingleton(as: ClientService)
class ProdClientService implements ClientService {
  ProdClientService({SunshineClientService sunshineClientService})
      : _sunshineClientService = sunshineClientService;
  final SunshineClientService _sunshineClientService;

  @override
  Future<bool> get ready => _sunshineClientService.ready;

  @override
  Future<String> deviceId() async {
    return _sunshineClientService.currentDevice();
  }

  @override
  Future<String> addPaperKey() {
    return _sunshineClientService.addPaperKey();
  }

  @override
  Future<bool> addDevice(String id) {
    return _sunshineClientService.addDevice(id);
  }

  @override
  Future<List<String>> identities(String uid) async {
    return _sunshineClientService.listIdentities(uid);
  }

  @override
  Future<ProveIdentityResult> proveIdentity(
      SocialIdentityService service) async {
    final result = await _sunshineClientService.proveIdentity(service.display);
    return ProveIdentityResult(result[0], result[1]);
  }

  @override
  Future<List<String>> devices() async {
    return _sunshineClientService.listDevices(await uid());
  }

  @override
  Future<bool> revokeDevice(String id) {
    return _sunshineClientService.removeDevice(id);
  }

  @override
  Future<bool> revokeIdentity(SocialIdentityService service) {
    return _sunshineClientService.revokeIdentity(service.display);
  }

  @override
  Future<String> uidOf(String id) {
    return _sunshineClientService.resolveUid(id);
  }

  @override
  Future<bool> lock() {
    return _sunshineClientService.lockKey();
  }

  @override
  Future<String> setKey(String password, {String suri, String paperKey}) async {
    return _sunshineClientService.setKey(
      password,
      suri: suri,
      paperKey: paperKey,
    );
  }

  @override
  Future<bool> unlock(String password) {
    return _sunshineClientService.unlockKey(password);
  }

  @override
  Future<bool> updatedPassword(String password) async {
    return true;
  }

  @override
  Future<String> balance() async {
    return _sunshineClientService
        .balance(null)
        .then((value) => value.toString());
  }

  @override
  Future<String> transfer(String id, BigInt amount) {
    return _sunshineClientService.transfer(id, amount);
  }

  @override
  Future<String> uid() async {
    return _sunshineClientService.resolveUid(await deviceId());
  }

  @override
  Future<BigInt> mint() {
    return _sunshineClientService.mint();
  }

  @override
  Future<bool> hasKey() {
    return _sunshineClientService.hasKey();
  }
}
