import 'package:flutter/foundation.dart';
import '../../models/codeuse.dart';
import '../../services/codeuse_service.dart';

class CodeUseManager with ChangeNotifier {
  CodeUse? _codeUse;
  List<CodeUse> _codeUses = [];

  final CodeUseService _codeUseService = CodeUseService();

  Future<CodeUse?> fetchCodeUse(String id) async {
    _codeUse = await _codeUseService.fetchCodeUse(id);
    notifyListeners();
    return _codeUse;
  }

  Future<void> fetchAllCodeUses() async {
    _codeUses = await _codeUseService.fetchAllCodeUses();
    notifyListeners();
  }

  Future<void> fetchCodeUsesByUser(String userId) async {
    _codeUses = await _codeUseService.fetchCodeUsesByUser(userId);
    notifyListeners();
  }

  Future<void> fetchCodeUsesByCode(String codeId) async {
    _codeUses = await _codeUseService.fetchCodeUsesByCode(codeId);
    notifyListeners();
  }

  int get codeUseCount {
    return _codeUses.length;
  }

  Future<String> addCodeUse(Map<String, dynamic> codeUseData) async {
    try {
      final newCodeUse = CodeUse.fromJson(codeUseData);
      final codeUse = await _codeUseService.addCodeUse(newCodeUse);
      if (codeUse != null) {
        _codeUses.add(codeUse);
        notifyListeners();
      }
      return 'CodeUse added successfully';
    } catch (error) {
      return '$error';
    }
  }

  CodeUse? get codeUse {
    return _codeUse;
  }

  String? get id {
    return _codeUse?.id;
  }

  String? get codeId {
    return _codeUse?.codeid;
  }

  List<CodeUse> get codeUses {
    return [..._codeUses];
  }

  Future<CodeUse?> updateCodeUse(CodeUse codeUse) async {
    final updated = await _codeUseService.updateCodeUse(codeUse);
    if (updated) {
      final index = _codeUses.indexWhere((c) => c.id == codeUse.id);
      if (index != -1) {
        _codeUses[index] = codeUse;
        notifyListeners();
      }
    }
    return codeUse;
  }

  Future<bool> deleteCodeUse(String id) async {
    final success = await _codeUseService.deleteCodeUse(id);
    if (success) {
      _codeUses.removeWhere((codeUse) => codeUse.id == id);
      notifyListeners();
    }
    return success;
  }
}
