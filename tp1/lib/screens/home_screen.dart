
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp1/screens/CreateTodoScreen.dart';
import '../data/models/Todo.dart';
import '../data/services/database.dart';
import '../data/services/todo_service.dart';
import 'list_todo.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Todo?> tache = [];
  bool isLoadingPosts = false;
  int? totalTache;
  int? tacheNonCommencee = 0;
  int? tacheEnCours = 0;
  int? tachefinie = 0;
  int? tacheRetard = 0;

  loadPost () async {
    setState(() {
      isLoadingPosts = true;
    });
    try {
      print("++++++++++++++++++++++++++++++++");
      tache = await DatabaseHelper.getAllNotes();
      //TodoService.fetch();
      totalTache = tache.length;
      tacheNonCommencee = await DatabaseHelper.nonCommencer();
      tacheEnCours = await DatabaseHelper.enCours();
      tachefinie = await DatabaseHelper.finie();
      tacheRetard = await DatabaseHelper.finiEnRetard();
      print("++++++++++++++++++++++++++++++++");
    } on DioError catch(e) {
      print(e);
      Map<String, dynamic> error = e.response?.data;
      if (error != null && error.containsKey('message')) {
        Fluttertoast.showToast(msg: error['message']);
      } else {
        Fluttertoast.showToast(msg: "Une erreur est survenue veuillez rééssayer");
      }
    } finally {
      isLoadingPosts = false;
      setState(() {});
    }
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Bilan")),
          actions: [
            IconButton(
                onPressed: () async{
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                icon: const Icon(Icons.logout, color: Colors.green,)
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTodoScreen()));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          //margin: const EdgeInsets.only(top: 50,left: 30),
          height: double.infinity,
          width: double.infinity,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.025),
                      ],
                    ),
                  ),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Nombre total de taches ",style:TextStyle(fontSize: 25),),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",)));
                        },
                        child: Text(
                            '${tache.length}',
                            style: const TextStyle(fontSize: 25,color: Colors.green)
                        ),
                      ),

                    ],
                  ))
              ),
              const SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 70,
                      width: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Center(child: Column(
                        children: [
                          const Text("Taches non commencees ",style:TextStyle(fontSize: 15),),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",)));
                            },
                            child: Text(
                                '$tacheNonCommencee',
                                style: const TextStyle(fontSize: 25,color: Colors.green)
                            ),
                          ),

                        ],
                      ))
                  ),
                  const SizedBox(width: 10,),
                  Container(
                      height: 70,
                      width: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Center(child: Column(
                        children: [
                          const Text("Taches en cours ",style:TextStyle(fontSize: 15),),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",)));
                            },
                            child: Text(
                                '$tacheEnCours',
                                style: const TextStyle(fontSize: 25,color: Colors.green)
                            ),
                          ),

                        ],
                      ))
                  ),
                ],
              ),
              const SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 70,
                      width: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Center(child: Column(
                        children: [
                          const Text("Taches finies ",style:TextStyle(fontSize: 15),),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",)));
                            },
                            child: Text(
                                '$tachefinie',
                                style: const TextStyle(fontSize: 25,color: Colors.green)
                            ),
                          ),

                        ],
                      ))
                  ),
                  const SizedBox(width: 10,),
                  Container(
                      height: 70,
                      width: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Center(child: Column(
                        children: [
                          const Text("Taches finies en retard ",style:TextStyle(fontSize: 15),),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const ListTodo(title: "Liste des taches",)));
                            },
                            child: Text(
                                '$tacheRetard',
                                style: const TextStyle(fontSize: 25,color: Colors.green)
                            ),
                          ),

                        ],
                      ))
                  ),
                ],
              ),
              const SizedBox(height: 250,),
              Align(
                alignment: Alignment.bottomLeft,
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
          ),
        )




        /*
        isLoadingPosts ? const Center(
          child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator()
          ),
        ) : posts.length > 0 ? ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.list_alt),
                title: Text(posts[index].title!, maxLines: 1,),
                subtitle: Text("Créer par "+posts[index].user!.username!+ " le "+posts[index].createdAt!.toString()),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPostScreen(post: posts[index])));
                },
              ),
            );
          },
        ) : Center(
          child: Text("Aucuns blogs disponibles", style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),),
        ),*/
         // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}