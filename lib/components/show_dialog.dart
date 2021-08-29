import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';

/// Simple class to display a dialog
class ShowDialog extends StatefulWidget {
  ShowDialog(
      {@required this.title,
        @required this.body,
        Key key})
      : super(key: key);

  final String title;
  final Widget body;

  @override
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      drawer: MyDrawer(),
      appBar: AppBar(
          title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (bc) => [
              PopupMenuItem(
                value: 'EditExercise',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('\u00DCbung bearbeiten')
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'DeleteExercise',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('\u00DCbung löschen')
                  ],
                ),
              ),
            ],
            onSelected: _handleTopMenu,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 8, 8),
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Expanded(
                child: widget.body,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      label: Text('Zur\u00FCck'),
                      icon: Icon(Icons.arrow_back),
                      style: ButtonStyle(
                          visualDensity: VisualDensity.adaptivePlatformDensity),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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

  ///Handles the decision where to route to
  void _handleTopMenu(String value) {
    switch (value) {
      case 'EditExercise':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => (null)));
          break;
        }
      case 'DeleteExercise':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => (null)));
          break;
        }
    }
  }
}
