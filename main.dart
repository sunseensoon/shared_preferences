import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController number1Controller = TextEditingController();
  final TextEditingController number2Controller = TextEditingController();
  final TextEditingController operationController = TextEditingController();
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator Sederhana'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: number1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Bilangan 1'),
            ),
            TextField(
              controller: number2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Bilangan 2'),
            ),
            TextField(
              controller: operationController,
              decoration: InputDecoration(labelText: 'Operasi (+, -, *, /)'),
            ),
            ElevatedButton(
              onPressed: calculateResult,
              child: Text('Hitung'),
            ),
            ElevatedButton(
              onPressed: navigateToResultScreen,
              child: Text('Hasil'),
            ),
          ],
        ),
      ),
    );
  }

  void calculateResult() {
    final num1 = double.tryParse(number1Controller.text);
    final num2 = double.tryParse(number2Controller.text);
    final operation = operationController.text;

    if (num1 == null || num2 == null) {
      setState(() {
        result = 'Bilangan tidak valid';
      });
      return;
    }

    double calculatedResult;

    if (operation == '+') {
      calculatedResult = num1 + num2;
    } else if (operation == '-') {
      calculatedResult = num1 - num2;
    } else if (operation == '*') {
      calculatedResult = num1 * num2;
    } else if (operation == '/') {
      calculatedResult = num1 / num2;
    } else {
      setState(() {
        result = 'Operasi tidak valid';
      });
      return;
    }

    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.setDouble('result', calculatedResult);
      sharedPrefs.setString('operation', operation);
    });

    setState(() {
      result = 'Hasil: $calculatedResult';
    });
  }

  void navigateToResultScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ResultScreen();
      },
    ));
  }
}

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double? result;
  String? operation;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() {
        result = sharedPrefs.getDouble('result');
        operation = sharedPrefs.getString('operation');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Operasi Aritmatika'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hasil Operasi: ${result ?? "Data tidak ditemukan"}'),
            Text(
                'Operasi yang Dipilih: ${operation ?? "Data tidak ditemukan"}'),
          ],
        ),
      ),
    );
  }
}
