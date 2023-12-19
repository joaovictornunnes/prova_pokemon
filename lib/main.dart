import 'package:flutter/material.dart';
import 'widgets/telaCaptura.dart';
import 'widgets/telaPokemonCapturado.dart';
import 'widgets/telaSobre.dart'; // Importe a TelaSobre

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terceira Prova',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    TelaCaptura(),
    TelaPokemonCapturado(),
    TelaSobre(), // Adicione a TelaSobre à lista
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terceira Prova'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Captura',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Capturados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Sobre', // Adicione um terceiro item à BottomNavigationBar
          ),
        ],
      ),
    );
  }
}