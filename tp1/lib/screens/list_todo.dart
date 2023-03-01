import 'package:flutter/material.dart';
import 'package:tp1/data/services/database.dart';
import 'package:tp1/data/services/todo_service.dart';

import '../data/models/Todo.dart';
import 'CreateTodoScreen.dart';
import 'home_screen.dart';

class ListTodo extends StatefulWidget{
  final String title;
  const ListTodo({Key? key, required this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListTodoState();
  }
  
}
class ListTodoState extends State<ListTodo>{
  List<Todo?> items = [];
  bool isLoading = true;

  void initState(){
    super.initState();
    fetchTodo();
  }

  void editer(Todo item) {
    print(item.id);
    print(item.title);
    print(item.description);
    print(item.deadlinedAt);
    print(item.createdAt);
    print(item.beginedAt);
    print(item.finishedAt);
    print(item.updatedAt);
    print(item.userId);
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTodoScreen(todo: item)));
  }

  Future<void> fetchTodo() async {
    items = await DatabaseHelper.getAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Center(child: Text('Bilan',style: TextStyle(fontSize: 18),))//Icon(Icons.arrow_back_ios_new_outlined, color: Colors.green,),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTodoScreen()));
              setState(() {
                isLoading = true;
              });
              fetchTodo();
            },
            label: const Text('Ajouter Tache')
        ),
        body: Visibility(
          visible: isLoading,
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Todo;
                  //final String? id = item.id;
                  //final data = item;
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}'),),
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    trailing: PopupMenuButton(
                      onSelected: (value) async {
                        if(value == 'edit') {
                          editer(item);
                        }else if (value == 'delete') {
                          //var res = await TodoService.delete(id, data);
                          var res = await DatabaseHelper.deleteNote(item);
                          print(res);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",)));
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(value: 'edit', child: Text('Editer')),
                          const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                        ];
                      },
                    ),
                  );
                }
            ),
          ),
          child: const Center(child: CircularProgressIndicator(),),
        ),
      )
    );
  }
  
}