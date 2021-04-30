import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Get a stream of a single document
  Stream<SuperHero> streamHero(String id) {
    return _db
        .collection('heroes')
        .document(id)
        .snapshots()
        .map((snap) => SuperHero.fromMap(snap.data));
  }

  /// Query a subcollection
  Stream<List<Weapon>> streamWeapons(FirebaseUser user) {
    var ref = _db.collection('heroes').document(user.uid).collection('weapons');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Weapon.fromFirestore(doc)).toList());
    
  }

  /// Write data
  Future<void> createHero(String heroId) {
    return _db.collection('heroes').document(heroId).setData({ /* some data */ });
  }

}

class SuperHero {

  final String name;
  final int strength;

  SuperHero({ this.name, this.strength });

  factory SuperHero.fromMap(Map data) {
    data = data ?? { };
    return SuperHero(
      name: data['name'] ?? '',
      strength: data['strength'] ?? 100,
    );
  }

}

class Weapon {
  final String id;
  final String name;
  final int hitpoints;
  final String img;

  Weapon({ this.id, this.name, this.hitpoints, this.img, });

  factory Weapon.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    
    return Weapon(
      id: doc.documentID,
      name: data['name'] ?? '',
      hitpoints: data['hitpoints'] ?? 0,
      img: data['img'] ?? ''
    );
  }

}

