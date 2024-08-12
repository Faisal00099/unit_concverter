import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 14),
        ),
      ),
      home: ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String _fromUnitCategory = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double _convertedValue = 0.0;

  final TextEditingController _inputController = TextEditingController();
  double _inputValue = 0.0;

  final List<String> _lengthUnits = ['Meters', 'Kilometers', 'Miles'];
  final List<String> _weightUnits = ['Grams', 'Kilograms', 'Pounds'];
  final List<String> _temperatureUnits = ['Celsius', 'Fahrenheit'];

  void _convert() {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    double factor = 1.0;

    // Handle conversion based on unit category
    if (_fromUnitCategory == 'Length') {
      if (_fromUnit == 'Meters' && _toUnit == 'Kilometers') {
        factor = 0.001; // Meters to Kilometers
      } else if (_fromUnit == 'Meters' && _toUnit == 'Miles') {
        factor = 0.000621371; // Meters to Miles
      } else if (_fromUnit == 'Kilometers' && _toUnit == 'Meters') {
        factor = 1000; // Kilometers to Meters
      } else if (_fromUnit == 'Kilometers' && _toUnit == 'Miles') {
        factor = 0.621371; // Kilometers to Miles
      } else if (_fromUnit == 'Miles' && _toUnit == 'Meters') {
        factor = 1609.34; // Miles to Meters
      } else if (_fromUnit == 'Miles' && _toUnit == 'Kilometers') {
        factor = 1.60934; // Miles to Kilometers
      }
    } else if (_fromUnitCategory == 'Weight') {
      if (_fromUnit == 'Grams' && _toUnit == 'Kilograms') {
        factor = 0.001; // Grams to Kilograms
      } else if (_fromUnit == 'Grams' && _toUnit == 'Pounds') {
        factor = 0.00220462; // Grams to Pounds
      } else if (_fromUnit == 'Kilograms' && _toUnit == 'Grams') {
        factor = 1000; // Kilograms to Grams
      } else if (_fromUnit == 'Kilograms' && _toUnit == 'Pounds') {
        factor = 2.20462; // Kilograms to Pounds
      } else if (_fromUnit == 'Pounds' && _toUnit == 'Grams') {
        factor = 453.592; // Pounds to Grams
      } else if (_fromUnit == 'Pounds' && _toUnit == 'Kilograms') {
        factor = 0.453592; // Pounds to Kilograms
      }
    } else if (_fromUnitCategory == 'Temperature') {
      if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
        _convertedValue = (_inputValue * 9 / 5) + 32; // Celsius to Fahrenheit
      } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
        _convertedValue = (_inputValue - 32) * 5 / 9; // Fahrenheit to Celsius
      } else {
        _convertedValue = _inputValue; // Same unit conversion
      }
      setState(() {});
      return;
    }

    // Apply factor for length and weight conversions
    _convertedValue = _inputValue * factor;
    setState(() {});
  }

  void _clearInputs() {
    setState(() {
      _inputController.clear(); // Clear the input field
      _inputValue = 0.0;
      _convertedValue = 0.0;
      _fromUnit = _getDropdownMenuItems().first.value!;
      _toUnit = _getDropdownMenuItems().first.value!;
    });
  }

  List<DropdownMenuItem<String>> _getDropdownMenuItems() {
    if (_fromUnitCategory == 'Length') {
      return _lengthUnits.map((unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList();
    } else if (_fromUnitCategory == 'Weight') {
      return _weightUnits.map((unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList();
    } else if (_fromUnitCategory == 'Temperature') {
      return _temperatureUnits.map((unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList();
    }
    return [];
  }

  void _updateToUnitIfSame(String selectedFromUnit) {
    if (selectedFromUnit == _toUnit) {
      // Find a different unit to select as the "to unit"
      final availableUnits = _getDropdownMenuItems();
      for (var unit in availableUnits) {
        if (unit.value != selectedFromUnit) {
          setState(() {
            _toUnit = unit.value!;
          });
          break;
        }
      }
    }
  }

  void _updateFromUnitIfSame(String selectedToUnit) {
    if (selectedToUnit == _fromUnit) {
      // Find a different unit to select as the "from unit"
      final availableUnits = _getDropdownMenuItems();
      for (var unit in availableUnits) {
        if (unit.value != selectedToUnit) {
          setState(() {
            _fromUnit = unit.value!;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isConvertButtonEnabled =
        _fromUnit != _toUnit; // Check if from and to units are different

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Category Selection using Toggle Buttons
                    // Category Selection using Toggle Buttons
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            ['Length', 'Weight', 'Temperature'].map((category) {
                          return Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: _fromUnitCategory == category
                                    ? Colors.white
                                    : Colors.black,
                                backgroundColor: _fromUnitCategory == category
                                    ? Colors.blue
                                    : Colors.grey[300],
                              ),
                              onPressed: () {
                                setState(() {
                                  _fromUnitCategory = category;
                                  _fromUnit =
                                      _getDropdownMenuItems().first.value!;
                                  _toUnit =
                                      _getDropdownMenuItems().first.value!;
                                  _inputController
                                      .clear(); // Clear input when changing category
                                  _convertedValue = 0.0;
                                });
                              },
                              child: Text(category),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // From Unit Dropdown
                    DropdownButton<String>(
                      value: _fromUnit,
                      isExpanded: true,
                      items: _getDropdownMenuItems(),
                      onChanged: (value) {
                        setState(() {
                          _fromUnit = value!;
                          _updateToUnitIfSame(
                              value); // Update to unit if same as from unit
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Input Value Text Field
                    TextField(
                      controller: _inputController, // Use the controller
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Input Value',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _inputValue = double.tryParse(value) ?? 0.0;
                      },
                    ),
                    SizedBox(height: 16),
                    // To Unit Dropdown
                    DropdownButton<String>(
                      value: _toUnit,
                      isExpanded: true,
                      items: _getDropdownMenuItems(),
                      onChanged: (value) {
                        setState(() {
                          _toUnit = value!;
                          _updateFromUnitIfSame(
                              value); // Update from unit if same as to unit
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Convert Button
                    ElevatedButton(
                      onPressed: isConvertButtonEnabled
                          ? _convert
                          : null, // Disable if units are the same
                      child: Text('Convert'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Clear Button
                    ElevatedButton(
                      onPressed: _clearInputs,
                      child: Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        backgroundColor: Colors.blueAccent[100],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Converted Value Display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Converted Value:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$_convertedValue',
                            style: TextStyle(
                                fontSize: 24, color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
