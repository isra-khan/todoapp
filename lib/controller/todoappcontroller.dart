import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/constant/color.dart';

class TodoAppController extends GetxController {
  RxList<String> todoList = <String>[].obs;
  RxList<String> docId = <String>[].obs;

  final TextEditingController textFieldController = TextEditingController();

  final CollectionReference todos =
      FirebaseFirestore.instance.collection('notes');

  RxBool isLoading = true.obs;

  Future<List<String>> getTodoList() async {
    QuerySnapshot querySnapshot = await todos.get();
    isLoading.value = true;
    print(isLoading);

    todoList.clear();
    docId.clear();
    querySnapshot.docs.forEach((doc) {
      //  setState(() {});

      todoList.add(doc['note']);
      docId.add(doc.id);
    });
    isLoading.value = false;
    print(isLoading);
    return todoList;
  }

  void addTodoItem(String title) async {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    try {
      await FirebaseFirestore.instance
          .collection("notes")
          .doc()
          .set({'createdAt': DateTime.now(), 'note': title});
      getTodoList();
    } catch (e) {
      print("error $e");
    }
  }

  void updateTodoItem(int index) async {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    try {
      await FirebaseFirestore.instance
          .collection("notes")
          .doc(docId[index].toString())
          .update(
              {'createdAt': DateTime.now(), 'note': textFieldController.text});
      getTodoList();
    } catch (e) {
      print(e);
    }
  }

  deleteItem(int index) async {
    await todos.doc(docId[index].toString()).delete();

    getTodoList();
  }
}
