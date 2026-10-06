import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity.dart';
import '../models/signup.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all opportunities
  Stream<List<Opportunity>> getOpportunities() {
    return _db.collection('opportunities').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Opportunity.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  // Get user's signups
  Stream<List<Signup>> getUserSignups(String userId) {
    return _db
        .collection('signups')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Signup.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  // Check if user already signed up
  Future<bool> hasUserSignedUp(String userId, String opportunityId) async {
    final querySnapshot = await _db
        .collection('signups')
        .where('userId', isEqualTo: userId)
        .where('opportunityId', isEqualTo: opportunityId)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  // Submit signup and decrement slot
  Future<void> submitSignup(Signup signup, int currentSlots) async {
    // Write in batch to ensure consistency
    final batch = _db.batch();

    // Create signup document
    final signupRef = _db.collection('signups').doc();
    batch.set(signupRef, signup.toMap());

    // Update remaining slots in opportunity
    final oppRef = _db.collection('opportunities').doc(signup.opportunityId);
    batch.update(oppRef, {'remainingSlots': currentSlots - 1});

    await batch.commit();
  }

  // Add dummy opportunities (for testing if the database is empty)
  Future<void> initializeDummyData(List<Opportunity> dummyData) async {
    final snapshot = await _db.collection('opportunities').limit(1).get();
    if (snapshot.docs.isEmpty) {
      final batch = _db.batch();
      for (var opp in dummyData) {
        final docRef = _db.collection('opportunities').doc();
        batch.set(docRef, opp.toMap());
      }
      await batch.commit();
    }
  }
}
