import 'package:android_daily/models/alarm_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  DatabaseService(this._auth, this._db);

  Future<String> register(String email, String name) async {
    if (_auth.currentUser != null) {
      await _db.collection('users').doc(_auth.currentUser!.uid).set(
        {
          'Email': email,
          'Name': name,
        },
      );
      return "Registered";
    }
    return "Error";
  }

  Stream<List<AlarmItem>>? streamAlarm() {
    if (_auth.currentUser != null) {
      return _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('alarm')
          .snapshots()
          .map((list) =>
              list.docs.map((doc) => AlarmItem.fromMap(doc.data())).toList());
    }
    return null;
  }

  Future<void> changeAlarmState(AlarmItem alarm) async {
    await _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('alarm')
        .doc(alarm.id.toString())
        .update({'activate': !alarm.activate});
  }

  Future<void> deleteAlarm(AlarmItem alarm) async {
    await _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('alarm')
        .doc(alarm.id.toString())
        .delete();
  }

  Future<void> updateAlarm(AlarmItem alarm) async {
    await _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('alarm')
        .doc(alarm.id.toString())
        .set(alarm.toJson());
  }
}
