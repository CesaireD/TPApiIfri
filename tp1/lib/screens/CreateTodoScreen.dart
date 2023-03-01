import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tp1/data/models/Todo.dart';
import 'package:tp1/data/models/user.dart';
import 'package:tp1/data/services/database.dart';
import 'package:tp1/data/services/users_service.dart';
import 'home_screen.dart';
import '../data/services/todo_service.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import 'list_todo.dart';

class CreateTodoScreen extends StatefulWidget{
  final Todo? todo;
  const CreateTodoScreen({super.key, this.todo});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateTodoScreenState();
  }
  
}
class CreateTodoScreenState extends State<CreateTodoScreen>{
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final deadlineController = TextEditingController();
  final createController = TextEditingController();
  final beginController = TextEditingController();
  final finishController = TextEditingController();
  final updateController = TextEditingController();
  late String idController;



  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isEdit = false;
  bool plus = false;


  _createTodo(title, description, deadline) async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(Constant.USER_ID_PREF_KEY);
    //createController.text = DateTime.now().toString();
    updateController.text = DateTime.now().toString();

    print('-----------------------------${deadline}');

    try {
      final todo = Todo(
        id: idController,
        title: title,
        deadlinedAt: deadline == "" ? DateTime(1999) : DateTime.parse(deadline),
        description: description,
        createdAt: DateTime.parse(createController.text),
        beginedAt: beginController.text == "" ? DateTime(1999) : DateTime.parse(beginController.text),
        finishedAt: finishController.text == "" ? DateTime(1999) : DateTime.parse(finishController.text),
        updatedAt: DateTime.parse(updateController.text),
        userId: "biowa"//id!,
      );

      print(todo.id);
      print(todo.title);
      print(todo.description);
      print(todo.deadlinedAt);
      print(todo.createdAt);
      print(todo.beginedAt);
      print(todo.finishedAt);
      print(todo.updatedAt);
      print(todo.userId);



      //var result = await TodoService.create(todo.toJson());
      //print("----\n$result\n-----");
      var res = await DatabaseHelper.addNote(todo);
      print('$res --------------------------------------');
      Fluttertoast.showToast(msg: "--Tache créée avec succès--");
      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTodoScreen()));
    } on DioError catch (e) {
      Map<String, dynamic>? error = e.response?.data;
      if (error != null && error.containsKey('message')) {
        Fluttertoast.showToast(msg: error['message']);
      } else {
        Fluttertoast.showToast(msg: "Une erreur est survenue veuillez rééssayer");
      }
      print(e.response);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String generateID() {
    final random = Random();
    const allChars = 'QWERTYUIOPASDFGHJKLZXCVBNMoiuytrewqasdfghjklzxcvbnm1234567890-';
    final randomString = List.generate(16, (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

  String valueID() {
    final res;
    if(isEdit){
      res = widget.todo!.id == null ? generateID() : widget.todo!.id!;
    }else{
      res = generateID();
    }
    setState(() {
      idController = res;
    });
    return res;
  }

  String hintText(int res) {
    if(res == 1){
      return widget.todo!.deadlinedAt.toString();
    }else if(res == 2){
      return widget.todo!.beginedAt.toString();
    }else{
      return widget.todo!.finishedAt.toString();
    }
  }


  void initState() {
    super.initState();
    if(widget.todo != null){
      isEdit = true;
      titleController.text = widget.todo!.title;
      contentController.text = widget.todo!.description;
      createController.text = widget.todo!.createdAt.toString();
      deadlineController.text = widget.todo!.deadlinedAt.toString() == "null" ? "" : widget.todo!.deadlinedAt.toString();
      beginController.text = widget.todo!.beginedAt.toString() == "null" ? "" : widget.todo!.beginedAt.toString();
      finishController.text = widget.todo!.finishedAt.toString() == "null" ? "" : widget.todo!.finishedAt.toString();
      updateController.text = widget.todo!.updatedAt.toString();

    }else{
      createController.text = DateTime.now().toString();
      updateController.text = DateTime.now().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(isEdit ? 'Mise a jour' : "Nouvelle Tache")),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.green,),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Nouvelle Tache", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.green),),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: valueID(),
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Id",
                          ),

                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          controller: titleController,
                          //initialValue: "label",
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Entrez le titre de la tache",
                            labelText: "Titre",
                          ),
                          validator: (value) {
                            return value == null || value == ""
                                ? "Ce champs est obligatoire"
                                : null;
                          },
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          controller: contentController,
                          //initialValue: isEdit ? widget.todo!.description : null,
                          keyboardType: TextInputType.text,
                          maxLines: 7,
                          decoration: const InputDecoration(
                            labelText: "description",
                          ),
                          validator: (value) {
                            return value == null || value == ""
                                ? "Ce champs est obligatoire"
                                : null;
                          },
                        ),
                        const SizedBox(height: 10.0,),
                        TextFormField(
                          controller: deadlineController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            labelText: "deadline",
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                          //width: 150,//MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  plus == true ? plus = false : plus = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(plus == false ? "plus" : "moins", style: const TextStyle(fontSize: 17, color: Colors.green),),
                                  Icon(plus == false ? Icons.arrow_drop_down : Icons.arrow_drop_up ,color: Colors.green,)
                                ],
                              ),
                            ),
                          ),
                        ),

                        plus ? Column(
                          children: [
                            TextFormField(
                              controller: createController,
                              keyboardType: TextInputType.datetime,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "created at ",
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            TextFormField(
                              controller: beginController,
                              //initialValue: isEdit ? widget.todo!.beginedAt.toString() : null,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: "beginning",
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            TextFormField(
                              controller: finishController,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: "finished at",
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            TextFormField(
                              controller: updateController,
                              keyboardType: TextInputType.datetime,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: "last update",
                              ),
                            ),
                          ],
                        ) : const SizedBox(height: 10,),
                        const SizedBox(height: 20.0,),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: () async {
                              if (!isLoading && formKey.currentState!.validate()) {
                                /*if(isEdit) {
                                  //final res = await TodoService.patch(widget.todo!.id, widget.todo!);
                                  final res = await DatabaseHelper.updateNote(widget.todo!);
                                  print(res);
                                  setState(() {

                                  });
                                }else{*/
                                  await _createTodo(titleController.text, contentController.text, deadlineController.text);
                                  titleController.text = "";
                                  contentController.text = "";
                                  isEdit ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",))) : null;
                               // }

                              }
                            },
                            child: isLoading ? const SizedBox(height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 3,)) : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                isEdit ? 'Mettre a jour' : "Créer"),
                                  )
                        )
                      ],
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()));
                        },
                        child: const Text("Retourner au bilan",
                          style: TextStyle(fontSize: 17, color: Colors.green),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",)));
                        },
                        child: const Text("Voir la liste des Taches",
                          style: TextStyle(fontSize: 17, color: Colors.green),),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}