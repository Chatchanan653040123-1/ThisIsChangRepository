import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// CacheRamUserV-1.0.0
class GetDataMarker {
  static DocumentReference<Map<String, dynamic>> getDatabaseMoto4() {
    Map<String, dynamic> x ={};
    final docRef =
        FirebaseFirestore.instance.collection("parkPlace").doc("motorcycle");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        x = data;
        print(x);
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return docRef;
  }

  static DocumentReference<Map<String, dynamic>> getDatabaseCar4() {
    Map<String, dynamic> x ={};
    final docRef =
        FirebaseFirestore.instance.collection("parkPlace").doc("car");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        x = data;
        print(x);
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return docRef;
  }
}