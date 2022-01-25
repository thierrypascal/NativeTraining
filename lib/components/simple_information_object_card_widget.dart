import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/information_object.dart';
import 'package:native_training/services/service_provider.dart';

///a single card to display the basic information of an object in a list
class SimpleInformationObjectCard extends StatelessWidget {
  /// the [InformationObject] to display
  final InformationObject object;

  /// what should happen if you tap on the card
  final Function onTapHandler;

  /// if a card is selected
  final bool selected;

  /// if this flag is set, the buttons bearbeiten and löschen will be removed
  final bool showDeleteAndEdit;

  /// what should happen if you delete the card
  final Function onDeleteHandler;

  final ServiceProvider _serviceProvider;

  /// formKey to control the amount input field
  final GlobalKey<FormState> formKey;

  /// Non expandable ListTile, displaying a [Workout] or a [Exercise]
  SimpleInformationObjectCard(this.object,
      {this.onTapHandler,
      this.onDeleteHandler,
      this.selected = false,
      this.showDeleteAndEdit = false,
      ServiceProvider serviceProvider,
      this.formKey,
      Key key})
      : _serviceProvider = serviceProvider ?? ServiceProvider.instance,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: selected
          ? RoundedRectangleBorder(
              side: BorderSide(color: Colors.green, width: 2.0), borderRadius: BorderRadius.circular(3.0))
          : RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(3.0)),
      child: InkWell(
        onTap: onTapHandler,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _serviceProvider.imageService
                  .getImageByUrl(object.imageURL, height: 60, width: 60, fit: BoxFit.cover),
            ),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(object.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showDeleteAndEdit)
              IconButton(
                onPressed: onDeleteHandler,
                icon: Icon(Icons.remove),
              ),
          ],
        ),
      ),
    );
  }
}
