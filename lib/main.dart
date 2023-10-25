/*
* Aplicaciones Híbridas
* Proyecto final - Calculadora de Notas
* Desarrollado por Yeison Duvan Franco Rojas
* c.c. 1128452868
* */


import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de notas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Calculadora de notas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<DynamicTextFormField> _listDynamicTextFormField = [
    DynamicTextFormField()
  ];
  double _accumulatedGrade = 0;
  double _accumulatedPercent = 0;

  void _addDynamicTextFormField() {
    // limit number of text fields to 6
    if (_listDynamicTextFormField.length >= 6) {
      _showCustomSnackBar("No puedes crear más de 6 campos");
      return;
    }

    // add new dynamic text field widget to list
    _listDynamicTextFormField.add(DynamicTextFormField());
    setState(() {});
  }

  void _deleteDynamicTextFormField() {
    if (_listDynamicTextFormField.length > 1) {
      _listDynamicTextFormField.removeLast();
      setState(() {});
    }
  }

  // function to retrieve data from text fields and display in a list
  void _submitData() {
    _accumulatedGrade = 0;
    _accumulatedPercent = 0;
    for (var widget in _listDynamicTextFormField) {
      double? grade = double.tryParse(widget.gradeController.text);
      double? percent = double.tryParse(widget.percentController.text);

      if (grade != null && percent != null) {
        if (grade < 0.0 || grade > 5.0) {
          _showCustomSnackBar("La nota debe estar entre 0.0 y 5.0");
          return;
        } else if (percent < 0.0 || percent > 100.0) {
          _showCustomSnackBar("El porcentaje debe estar entre 0.0 y 100.0");
          return;
        }

        _accumulatedGrade += (grade * percent / 100);
        _accumulatedPercent += percent;
      } else {
        _showCustomSnackBar("Campo vacío");
        return;
      }
    }

    if (_accumulatedPercent > 100.0) {
      _showCustomSnackBar("El porcentaje total no puede ser mayor a 100%");
      return;
    }

    setState(() {});
    _showDialog(_accumulatedGrade >= 3.0 ? "Materia aprobada" : "Materia reprobada",
        "Su calificación acumulada es: ${_accumulatedGrade.toStringAsFixed(2)}");
  }

  void _showDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(title),
              content: Text(
                content,
                textAlign: TextAlign.center,
              ),
              icon: const Icon(Icons.info_outline));
        });
  }

  void _showCustomSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                _accumulatedGrade.toStringAsFixed(2),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 3),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Nota", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Porcentaje",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            dynamicTextField(),
            optionButtons(),
            ElevatedButton(
              onPressed: _submitData,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Calcular'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dynamicTextField() => Flexible(
        flex: 2,
        child: ListView.builder(
          itemCount: _listDynamicTextFormField.length,
          itemBuilder: (_, index) => _listDynamicTextFormField[index],
        ),
      );

  Widget optionButtons() => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                _addDynamicTextFormField();
              },
              child: const Text('Agregar campo'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteDynamicTextFormField();
              },
              child: const Text('Eliminar campo'),
            ),
          ],
        ),
      );
}

// widget for dynamic text form field
class DynamicTextFormField extends StatelessWidget {
  DynamicTextFormField({super.key});

  final gradeController = TextEditingController();
  final percentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.deepOrange)),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: gradeController,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: percentController,
              decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.percent),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
