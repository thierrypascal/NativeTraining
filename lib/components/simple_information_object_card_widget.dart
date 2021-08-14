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

  final ServiceProvider _serviceProvider;

  /// formKey to control the amount input field
  final GlobalKey<FormState> formKey;

  /// Non expandable ListTile, displaying a [Workout] or a [Exercise]
  SimpleInformationObjectCard(this.object,
      {this.onTapHandler,
      ServiceProvider serviceProvider,
      this.formKey,
      Key key})
      : _serviceProvider = serviceProvider ?? ServiceProvider.instance,
        super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: InkWell(
        onTap: onTapHandler,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                          Text(object.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3)),
                child: _serviceProvider.imageService.getImage(
                    object.title, object.type,
                    height: 60, width: 60, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
    );
  }
}
