import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/models/workout.dart';

class MyWorkoutPage extends StatefulWidget {
  MyWorkoutPage({Key key}) : super(key: key);

  @override
  _MyWorkoutPageState createState() => _MyWorkoutPageState();
}

class _MyWorkoutPageState extends State<MyWorkoutPage> {
  Workout w1 = new Workout.empty();
  Workout w2 = new Workout.empty();
  Workout w3 = new Workout.empty();
  List<Workout> workouts = [];

  @override
  void initState() {
    w1.title = "Test1";
    w2.title = "Test2";
    w3.title = "Test3";
    workouts.add(w1);
    workouts.add(w2);
    workouts.add(w3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(workouts.length);

    return Scaffold(
      appBar: AppBar(
        title: Text("Meine Trainings"),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final item = workouts[index];
              return Card(
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.title, style: TextStyle(fontWeight: FontWeight.bold),),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.play_arrow_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              // return ListTile(
              //   title: Text(item.title),
              // );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Neues Training',
        child: Icon(Icons.add),
      ),
    );
  }
}
