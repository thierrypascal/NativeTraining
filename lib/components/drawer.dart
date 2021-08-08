import 'package:flutter/material.dart';

/// The Drawer which is located at the right side of the screen
class MyDrawer extends StatelessWidget {
  /// The Drawer which is located at the right side of the screen,
  /// default constructor
  MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child:
                  IconButton(icon: const Icon(Icons.person), onPressed: () {}),
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(children: [
                          ListTile(
                            title: const Text('Meine Trainings'),
                            onTap: () {},
                          ),
                          ListTile(
                            title: const Text('Meine Übungen'),
                            onTap: () {},
                          ),
                          Divider(thickness: 2,),
                          ListTile(
                            title: const Text('Neues Training'),
                            onTap: () {},
                          ),
                          ListTile(
                            title: const Text('Neue Übung'),
                            onTap: () {},
                          ),
                        ]),
                      ),
                    ],
                  )));
        }),
      ),
    );
  }
}
