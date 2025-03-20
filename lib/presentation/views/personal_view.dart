import 'package:flutter/material.dart';

import '../../common/widgets/appbar/appbar.dart';

class PersonalView extends StatefulWidget {
  const PersonalView({super.key});

  @override
  State<PersonalView> createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Personal"),
      body: Center(
        child: Text('Personal Screen',),
      ),
    );
  }
}