import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../models/product.dart';
import '../../models/auth_token.dart';
import '../../services/products_service.dart';

class ProbooksManager with ChangeNotifier {
  //Comment danh sách sản phẩm
  List<Probook> _items = [];

  final ProbooksService _probooksService;

  ProbooksManager([AuthToken? authToken])
      : _probooksService = ProbooksService(authToken);

  set authToken(AuthToken? authToken) {
    _probooksService.authToken = authToken;
  }

  Future<void> fetchProbooks([bool filterByUser = false]) async {
    _items = await _probooksService.fetchProbooks(filterByUser);
    notifyListeners();
  }

  Future<void> addProbook(Probook probook) async {
    final newProbook = await _probooksService.addProbook(probook);
    if (newProbook != null) {
      _items.add(newProbook);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<Probook> get items {
    return [..._items];
  }

  List<Probook> get starItems {
    return _items.where((prodItem) => prodItem.isStar).toList();
  }

  List<Probook> get completedItems {
    return _items.where((prodItem) => prodItem.isCompleted).toList();
  }

  Probook findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProbook(Probook probook) async {
    final index = _items.indexWhere((item) => item.id == probook.id);
    if (index >= 0) {
      if (await _probooksService.updateProbook(probook)) {
        _items[index] = probook;
        notifyListeners();
      }
    }
  }

  Future<void> toggleStarStatus(Probook probook) async {
    final savedStatus = probook.isStar;
    probook.isStar = !savedStatus;

    if (!await _probooksService.saveStarStatus(probook)) {
      probook.isStar = savedStatus;
    }
  }

  Future<void> toggleCompletedStatus(Probook probook) async {
    final savedStatus = probook.isCompleted;
    probook.isCompleted = !savedStatus;

    if (!await _probooksService.saveCompletedStatus(probook)) {
      probook.isCompleted = savedStatus;
    }
  }

  Future<void> deleteProbook(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Probook? existingProbook = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _probooksService.deleteProbook(id)) {
      _items.insert(index, existingProbook);
      notifyListeners();
    }
  }
}
