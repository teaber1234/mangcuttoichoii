import 'package:connect_1000/models/place.dart';
import 'package:connect_1000/repositories/place_repository.dart';
import 'package:flutter/material.dart';

//hàm lấy giá trị về
class DiachiModel with ChangeNotifier {
  List<City> listCity = [];
  List<Ward> listWard = [];
  List<District> listDistrict = [];
  int curCityId = 0;
  int curDictId = 0;
  int curWardId = 0;
  String address = "";
  Future<void> initialize(int Cid, int Did, int Wid) async {
    curCityId = Cid;
    curWardId = Wid;
    curDictId = Did;
    final repo = PlaceRepository();
    listCity = await repo.getListCity();
    if (curCityId != 0) {
      listDistrict = await repo.getListDistrict(curCityId);
    }
    if (curDictId != 0) {
      listWard = await repo.getListWard(curDictId);
    }
  }

  Future<void> setCity(int Cid) async {
    if (Cid != curCityId) {
      curCityId = Cid;
      curDictId = 0;
      curWardId = 0;
      final repo = PlaceRepository();
      listDistrict = await repo.getListDistrict(curCityId);
      listWard.clear();
    }
  }

  Future<void> setDictrict(int Did) async {
    if (Did != curCityId) {
      curDictId = Did;
      curWardId = 0;
      final repo = PlaceRepository();
      listWard = await repo.getListWard(curDictId);
    }
  }

  Future<void> setWardId(int Wid) async {
    if (Wid != curWardId) {
      curWardId = Wid;
    }
  }
}
