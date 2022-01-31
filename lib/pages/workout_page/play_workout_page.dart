import 'package:flutter/material.dart';
import 'package:native_training/components/PageViewDotIndicator.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/services/service_provider.dart';

import 'my_workouts_page.dart';

class PlayWorkoutPage extends StatefulWidget {
  PlayWorkoutPage(this.workout, {Key key}) : super(key: key);

  final Workout workout;

  @override
  _PlayWorkoutPageState createState() => _PlayWorkoutPageState();
}

class _PlayWorkoutPageState extends State<PlayWorkoutPage> {
  int pos = 0;
  PageController controller = PageController();
  List<Exercise> allExercises = [];
  final exerciseService = ServiceProvider.instance.exerciseService;

  @override
  void initState() {
    allExercises.addAll(exerciseService.getWorkoutExercises(widget.workout.warmupExercises));
    allExercises.addAll(exerciseService.getWorkoutExercises(widget.workout.workoutExercises));
    allExercises.addAll(exerciseService.getWorkoutExercises(widget.workout.cooldownExercises));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.workout.title),
      ),
      body: Stack(children: [
        PageView.builder(
          itemBuilder: (context, position) {
            return _buildPage(allExercises[position], position);
          },
          onPageChanged: (page) {
            setState(() {
              pos = page;
            });
          },
          itemCount: allExercises.length,
          scrollDirection: Axis.vertical,
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 11.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: PageViewDotIndicator(
              currentItem: pos,
              count: allExercises.length,
              size: Size(20, 20),
              margin: const EdgeInsets.symmetric(vertical: 8),
              unselectedColor: Colors.white60,
              selectedColor: Colors.white,
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildPage(Exercise exercise, int position) {
    Color gradientStart;

    switch (exercise.type) {
      case 0:
        gradientStart = Colors.grey;
        break;
      case 1:
        gradientStart = Colors.green;
        break;
      case 2:
        gradientStart = Colors.deepOrange;
        break;
      case 3:
        gradientStart = Colors.deepPurple;
        break;
      default:
        gradientStart = Colors.grey;
        break;
    }

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [gradientStart, Theme.of(context).scaffoldBackgroundColor],
          begin: const FractionalOffset(0.0, 1.0),
          end: const FractionalOffset(1.0, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 8, 8),
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child:
                            ServiceProvider.instance.imageService.getImageByUrl(exercise.imageURL, fit: BoxFit.cover),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                exercise.title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                        child: TextFormField(
                          enabled: false,
                          maxLines: null,
                          initialValue: exercise.description,
                          decoration: const InputDecoration(
                              labelText: 'Beschreibung', contentPadding: EdgeInsets.symmetric(vertical: 4)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    if (position != 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: ElevatedButton(
                          child: Icon(Icons.skip_previous),
                          style: ButtonStyle(visualDensity: VisualDensity.adaptivePlatformDensity),
                          onPressed: () {
                            controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                          },
                        ),
                      ),
                    if (position != allExercises.length - 1)
                      Expanded(
                        child: ElevatedButton.icon(
                          label: Text('Fertig'),
                          icon: Icon(Icons.done),
                          style: ButtonStyle(visualDensity: VisualDensity.adaptivePlatformDensity),
                          onPressed: () {
                            controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton.icon(
                          label: Text('Training abschliessen'),
                          icon: Icon(Icons.done_all),
                          style: ButtonStyle(visualDensity: VisualDensity.adaptivePlatformDensity),
                          onPressed: () {
                            //TODO: mark workout as done/set last done
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                //TODO: show WorkoutFinishedPage -> play Sound, confirm to continue to MyWorkoutPage
                                builder: (context) => WhiteRedirectPage(
                                      'Du hast das Training ${widget.workout.title} abgeschlossen. Gratulation!',
                                      MyWorkoutPage(),
                                    )));
                                // builder: (context) => WorkoutFinishedRedirectPage(
                                //           'Du hast das Training ${widget.workout.title} abgeschlossen. Gratulation!',
                                //           MyWorkoutPage(),
                                //         )));
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
