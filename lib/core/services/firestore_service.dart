import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parent_model.dart';
import '../models/child_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static CollectionReference<Map<String, dynamic>> get _parentsCollection =>
      _firestore.collection('parents');

  // Parent operations
  static Future<void> createParent(ParentModel parent) async {
    try {
      await _parentsCollection.doc(parent.id).set(parent.toMap());
      print('✅ FirestoreService: Parent created successfully');
    } catch (e) {
      print('❌ FirestoreService: Error creating parent - $e');
      rethrow;
    }
  }

  static Future<ParentModel?> getParent(String parentId) async {
    try {
      final doc = await _parentsCollection.doc(parentId).get();
      if (doc.exists) {
        return ParentModel.fromMap(parentId, doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ FirestoreService: Error getting parent - $e');
      return null;
    }
  }

  static Future<void> updateParent(ParentModel parent) async {
    try {
      await _parentsCollection.doc(parent.id).update(
        parent.copyWith(updatedAt: DateTime.now()).toMap(),
      );
      print('✅ FirestoreService: Parent updated successfully');
    } catch (e) {
      print('❌ FirestoreService: Error updating parent - $e');
      rethrow;
    }
  }

  static Future<void> updateParentPasscodeStatus(String parentId, bool isPasscodeSet) async {
    try {
      await _parentsCollection.doc(parentId).update({
        'isPasscodeSet': isPasscodeSet,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ FirestoreService: Parent passcode status updated');
    } catch (e) {
      print('❌ FirestoreService: Error updating passcode status - $e');
      rethrow;
    }
  }

  // Child operations
  static CollectionReference<Map<String, dynamic>> _getChildrenCollection(String parentId) {
    return _parentsCollection.doc(parentId).collection('children');
  }

  static Future<String> createChild(String parentId, ChildModel child) async {
    try {
      final docRef = await _getChildrenCollection(parentId).add(child.toMap());
      print('✅ FirestoreService: Child created successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ FirestoreService: Error creating child - $e');
      rethrow;
    }
  }

  static Future<List<ChildModel>> getChildren(String parentId) async {
    try {
      final snapshot = await _getChildrenCollection(parentId).get();
      return snapshot.docs
          .map((doc) => ChildModel.fromMap(doc.id, parentId, doc.data()))
          .toList();
    } catch (e) {
      print('❌ FirestoreService: Error getting children - $e');
      return [];
    }
  }

  static Stream<List<ChildModel>> getChildrenStream(String parentId) {
    return _getChildrenCollection(parentId).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => ChildModel.fromMap(doc.id, parentId, doc.data()))
          .toList(),
    );
  }

  static Future<ChildModel?> getChild(String parentId, String childId) async {
    try {
      final doc = await _getChildrenCollection(parentId).doc(childId).get();
      if (doc.exists) {
        return ChildModel.fromMap(childId, parentId, doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ FirestoreService: Error getting child - $e');
      return null;
    }
  }

  static Future<void> updateChild(String parentId, ChildModel child) async {
    try {
      await _getChildrenCollection(parentId).doc(child.id).update(child.toMap());
      print('✅ FirestoreService: Child updated successfully');
    } catch (e) {
      print('❌ FirestoreService: Error updating child - $e');
      rethrow;
    }
  }

  static Future<void> deleteChild(String parentId, String childId) async {
    try {
      await _getChildrenCollection(parentId).doc(childId).delete();
      print('✅ FirestoreService: Child deleted successfully');
    } catch (e) {
      print('❌ FirestoreService: Error deleting child - $e');
      rethrow;
    }
  }
}
