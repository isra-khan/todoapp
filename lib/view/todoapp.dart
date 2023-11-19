import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/constant/color.dart';

import 'package:get/get.dart';
import 'package:todoapp/controller/todoappcontroller.dart';

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final todoController = Get.put(TodoAppController());

  @override
  void initState() {
    todoController.getTodoList();
    super.initState();
  }

  // save data
  // text field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Obx(
        () {
          if (todoController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<String> todoList = todoController.todoList.toList();

            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 80,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100,
                  ),
                  child: ListTile(
                    onTap: () async {
                      await todoController.deleteItem(index);
                    },
                    title: Text(todoList[index],
                        style: TextStyle(color: Colors.purple, fontSize: 20)),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _updateDialog(context, index);

                        todoList[index] =
                            todoController.textFieldController.value.text;
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),

      // add items to the to-do list
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  // this Generate list of item widgets
  Widget _buildTodoItem(String title) {
    return GestureDetector(onTap: () {}, child: ListTile(title: Text(title)));
  }

  // display a dialog for the user to enter items
  _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: todoController.textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              ElevatedButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  todoController.addTodoItem(
                      todoController.textFieldController.value.text);
                },
              ),
              // Cancel button
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _updateDialog(BuildContext context, int index) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update a task to your list'),
            content: TextField(
              controller: todoController.textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  todoController.updateTodoItem(index);
                  Navigator.of(context).pop();
                },
              ),
              // Cancel button
              ElevatedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
