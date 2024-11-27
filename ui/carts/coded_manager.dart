import 'package:flutter/foundation.dart';
import '../../models/coded.dart';
import '../../services/coded_service.dart';

class CodedManager with ChangeNotifier {
  Coded? _coded;
  List<Coded> _codeds = [];

  final CodedService _codedService = CodedService();

  Future<Coded?> fetchCoded(String id) async {
    _coded = await _codedService.fetchCoded(id);
    notifyListeners();
    return _coded;
  }

  Future<void> fetchAllCodeds() async {
    _codeds = await _codedService.fetchAllCodeds();
    notifyListeners();
  }

  Future<void> fetchCodedsByUser(String userId) async {
    _codeds = await _codedService.fetchCodedsByUser(userId);
    notifyListeners();
  }

  Future<void> fetchCodedsByCode(String code) async {
    _codeds = await _codedService.fetchCodedsByCode(code);
    notifyListeners();
  }

  int get codedCount {
    return _codeds.length;
  }

  Future<String> addCoded(Map<String, dynamic> codedData) async {
    try {
      final newCoded = Coded.fromJson(codedData);
      final coded = await _codedService.addCoded(newCoded);
      if (coded != null) {
        _codeds.add(coded);
        notifyListeners();
      }
      return 'Coded added successfully';
    } catch (error) {
      return '$error';
    }
  }

  Coded? get coded {
    return _coded;
  }

  String? get id {
    return _coded?.id;
  }

  String? get code {
    return _coded?.code;
  }

  List<Coded> get codeds {
    return [..._codeds];
  }

  Future<Coded?> updateCoded(Coded coded) async {
    final updated = await _codedService.updateCoded(coded);
    if (updated) {
      final index = _codeds.indexWhere((c) => c.id == coded.id);
      if (index != -1) {
        _codeds[index] = coded;
        notifyListeners();
      }
    }
    return coded;
  }

  Future<bool> deleteCoded(String id) async {
    final success = await _codedService.deleteCoded(id);
    if (success) {
      _codeds.removeWhere((coded) => coded.id == id);
      notifyListeners();
    }
    return success;
  }
}
