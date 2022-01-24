import 'package:flutter/material.dart';
import 'package:native_training/components/simple_information_object_card_widget.dart';
import 'package:native_training/models/information_object.dart';
import 'package:native_training/pages/exercise_page/show_exercise_page.dart';
import 'package:native_training/pages/workout_page/show_workout_page.dart';
import 'package:native_training/services/service_provider.dart';

/// Creates a List Widget displaying all provided InformationObjects
class InformationObjectListWidget extends StatefulWidget {
  /// if this flag is set, the buttons bearbeiten and löschen will be removed
  final bool showDeleteAndEdit;

  /// A list of InformationObjects which should be displayed
  final List<InformationObject> objects;

  final ServiceProvider _serviceProvider;

  ///ScrollPhysics for the list of Info
  final ScrollPhysics physics;

  /// what should happen if you tap on the card, only to be given to siocw
  final bool toReturnSelected;

  /// which type is being shown to decide onTapHandler, only used if toReturnSelected = true
  final int type;

  /// if card is used for a workout or an exercise
  final bool isWorkout;

  /// Creates a List Widget displaying all provided InformationObjects
  InformationObjectListWidget(this.toReturnSelected,
      {Key key,
      this.objects,
      this.type,
      this.isWorkout = false,
      //TODO: implement showDeleteAndEdit
      this.showDeleteAndEdit = false,
      this.physics = const ScrollPhysics(),
      ServiceProvider serviceProvider})
      : _serviceProvider = serviceProvider ?? ServiceProvider.instance,
        super(key: key);

  @override
  _InformationObjectListWidgetState createState() => _InformationObjectListWidgetState();
}

class _InformationObjectListWidgetState extends State<InformationObjectListWidget> {
  final items = <InformationObject>[];

  @override
  void initState() {
    super.initState();
    items.addAll(widget.objects);
  }

  @override
  Widget build(BuildContext context) {
    final workoutService = widget._serviceProvider.workoutService;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Noch kein Eintrag vorhanden, m\u00F6chtest du einen neuen anlegen?',
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      physics: widget.physics,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final element = items.elementAt(index);
                        if ((widget.toReturnSelected)) {
                          return SimpleInformationObjectCard(
                            element,
                            selected: (() {
                              switch (widget.type) {
                                case 1:
                                  {
                                    return workoutService.getCurrentlySelectedWarmupWorkouts().contains(element);
                                  }
                                  break;
                                case 2:
                                  {
                                    return workoutService.getCurrentlySelectedWorkoutWorkouts().contains(element);
                                  }
                                  break;
                                case 3:
                                  {
                                    return workoutService.getCurrentlySelectedCooldownWorkouts().contains(element);
                                  }
                                  break;
                              }
                            }()),
                            serviceProvider: widget._serviceProvider,
                            onTapHandler: () {
                              setState(() {
                                switch (widget.type) {
                                  case 1:
                                    {
                                      workoutService.addToCurrentlySelectedWarmupWorkouts(element);
                                    }
                                    break;
                                  case 2:
                                    {
                                      workoutService.addToCurrentlySelectedWorkoutWorkouts(element);
                                    }
                                    break;
                                  case 3:
                                    {
                                      workoutService.addToCurrentlySelectedCooldownWorkouts(element);
                                    }
                                    break;
                                }
                              });
                            },
                          );
                        } else {
                          return SimpleInformationObjectCard(
                            element,
                            serviceProvider: widget._serviceProvider,
                            onTapHandler: () {
                              //TODO: use animations_package to detailview
                              (widget.isWorkout)
                                  ? Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => ShowWorkoutPage(element)))
                                  : Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => ShowExercisePage(element)));
                            },
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 5);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
