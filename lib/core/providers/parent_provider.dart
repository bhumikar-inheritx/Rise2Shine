import 'package:flutter/material.dart';
import '../models/parent_model.dart';
import '../models/child_model.dart';
import '../services/firestore_service.dart';

class ParentProvider extends ChangeNotifier {
  ParentModel? _parent;
  List<ChildModel> _children = [];
  bool _isLoading = false;
  String? _errorMessage;

  ParentModel? get parent => _parent;
  List<ChildModel> get children => _children;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasParent => _parent != null;
  bool get hasChildren => _children.isNotEmpty;

  // Initialize parent data
  Future<void> initializeParent(String parentId) async {
    _setLoading(true);
    try {
      // Get parent from Firestore
      _parent = await FirestoreService.getParent(parentId);
      if (_parent != null) {
        // Load children
        await loadChildren(parentId);
      }
      _setLoading(false);
    } catch (e) {
      _setError('Error loading parent data: $e');
      _setLoading(false);
    }
  }

  // Create parent in Firestore
  Future<bool> createParent({
    required String parentId,
    required String fullName,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    try {
      final now = DateTime.now();
      final parent = ParentModel(
        id: parentId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        isPasscodeSet: false,
        createdAt: now,
        updatedAt: now,
      );

      await FirestoreService.createParent(parent);
      _parent = parent;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error creating parent: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update parent passcode status
  Future<bool> updatePasscodeStatus(bool isPasscodeSet) async {
    if (_parent == null) return false;

    _setLoading(true);
    try {
      await FirestoreService.updateParentPasscodeStatus(_parent!.id, isPasscodeSet);
      _parent = _parent!.copyWith(isPasscodeSet: isPasscodeSet, updatedAt: DateTime.now());
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error updating passcode status: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load children
  Future<void> loadChildren(String parentId) async {
    try {
      _children = await FirestoreService.getChildren(parentId);
      notifyListeners();
    } catch (e) {
      _setError('Error loading children: $e');
    }
  }

  // Get children stream
  Stream<List<ChildModel>> getChildrenStream(String parentId) {
    return FirestoreService.getChildrenStream(parentId);
  }

  // Create child
  Future<String?> createChild(String parentId, ChildModel child) async {
    _setLoading(true);
    try {
      final childId = await FirestoreService.createChild(parentId, child);
      await loadChildren(parentId); // Reload children list
      _setLoading(false);
      return childId;
    } catch (e) {
      _setError('Error creating child: $e');
      _setLoading(false);
      return null;
    }
  }

  // Update child
  Future<bool> updateChild(String parentId, ChildModel child) async {
    _setLoading(true);
    try {
      await FirestoreService.updateChild(parentId, child);
      await loadChildren(parentId); // Reload children list
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Error updating child: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete child
  Future<bool> deleteChild(String parentId, String childId) async {
    _setLoading(true);
    try {
      await FirestoreService.deleteChild(parentId, childId);
      await loadChildren(parentId); // Reload children list
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Error deleting child: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get child by ID
  ChildModel? getChildById(String childId) {
    try {
      return _children.firstWhere((child) => child.id == childId);
    } catch (e) {
      return null;
    }
  }

  // Clear all data (on logout)
  void clear() {
    _parent = null;
    _children = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}
