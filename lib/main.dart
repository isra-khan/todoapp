import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/constant/color.dart';
import 'package:todoapp/noteapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyCCX77ZjUNmnZvoUHUVGP9rU3Awu3qjjOs',
          appId: '1:100561500685:android:de14f25fcab209db5b7344',
          messagingSenderId: '100561500685',
          projectId: 'todolist-75bc2'));
  runApp(Todo());
}
