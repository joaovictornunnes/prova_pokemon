import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações dos desenvolvedores'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Joao victor nunnes'),
            Text('Lucas moura nascimento'),
          ],
        ),
      ),
    );
  }
}