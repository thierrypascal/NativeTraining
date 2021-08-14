import 'package:flutter/material.dart';
import 'package:native_training/components/simple_information_object_card_widget.dart';
import 'package:native_training/models/information_object.dart';
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

  /// Creates a List Widget displaying all provided InformationObjects
  InformationObjectListWidget(
      {Key key,
      this.objects,
      this.showDeleteAndEdit = false,
      this.physics = const ScrollPhysics(),
      ServiceProvider serviceProvider})
      : _serviceProvider = serviceProvider ?? ServiceProvider.instance,
        super(key: key);

  @override
  _InformationObjectListWidgetState createState() =>
      _InformationObjectListWidgetState();
}

class _InformationObjectListWidgetState
    extends State<InformationObjectListWidget> {
  final items = <InformationObject>[];

  @override
  void initState() {
    super.initState();
    items.addAll(widget.objects);
  }

  @override
  Widget build(BuildContext context) {
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
                            'Leider keine Einträge vorhanden',
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Icons.dangerous,
                            size: 80,
                          )
                        ],
                      ),
                    )
                  : ListView.separated(
                      physics: widget.physics,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final element = items.elementAt(index);
                        return SimpleInformationObjectCard(
                                element,
                                serviceProvider: widget._serviceProvider,
                              );
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
