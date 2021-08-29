import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';

/// Simple class to display a save-abort dialog
class NormalEditDialog extends StatelessWidget {
  /// Text which is displayed on the abort button
  final String abort;

  /// Icon which is displayed on the abort button
  final IconData abortIcon;

  /// Text which is displayed on the save button
  final String save;

  /// Icon which is displayed on the save button
  final IconData saveIcon;

  /// title above the page
  final String title;

  /// callback function which is called upon abort
  final Function abortCallback;

  /// callback function which is called upon save
  final Function saveCallback;

  /// content to display on the page
  final Widget body;

  /// Simple class to display a save-abort dialog
  NormalEditDialog(
      {this.abort = 'Abbrechen',
      this.save = 'Speichern',
      this.saveIcon = Icons.save,
      this.abortIcon = Icons.clear,
      @required this.title,
      @required this.abortCallback,
      @required this.saveCallback,
      Function cancelCallback,
      @required this.body,
      Key key})
      :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      drawer: MyDrawer(),
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Expanded(
                child: body,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      label: Text(abort),
                      icon: Icon(abortIcon),
                      style: ButtonStyle(
                          visualDensity: VisualDensity.adaptivePlatformDensity),
                      onPressed: abortCallback,
                    ),
                    ElevatedButton.icon(
                      label: Text(save),
                      icon: Icon(saveIcon),
                      style: ButtonStyle(
                          visualDensity: VisualDensity.adaptivePlatformDensity),
                      onPressed: saveCallback,
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
