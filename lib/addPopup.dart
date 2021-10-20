import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wax_picker/models/waxModel.dart';
import 'package:wax_picker/utils/Database.dart';

class AddPopup extends StatefulWidget {
  @override
  _AddPopupState createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {

  bool waxButtonBlocked = false;
  bool candleButtonBlocked = true;

  disableButton(){

    setState(() {
      waxButtonBlocked = !waxButtonBlocked;
      candleButtonBlocked = !candleButtonBlocked;
    });
  }

  final nameController = TextEditingController();
  final descController = TextEditingController();
  int power = 1;
  int rate = 1;
  List<String> brands = [
    'Yankee Candle',
    'Goose Creek',
    'Kringle Candle',
    'Country Candle',
    'Classic Candle',
    'Eco Candle',
    'Milkhouse Candle',
    'Woodwick',
    'Village Candle',
    'Vera Young',
    'Pachnąca Wanna',
    'Bath and Body Works',
  ];
  String dropdownValue = 'Yankee Candle';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            child: Text("Add",
              style: TextStyle(color: Colors.deepPurple[400]),
            ),
            onPressed: () async {
              var newDBWax = WaxModel(id: 0, propType: waxButtonBlocked ? 'Candle' : 'Wax', name: nameController.text,
                  brand: dropdownValue, description: descController.text, power: power, rating: rate, amount: 1,
              color: Colors.deepPurple[400].value);
              await DBProvider.db.newWax(newDBWax);
              Navigator.of(context).pop();
            }
        )
      ],
      title: Text('Add new item...'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(Icons.filter_vintage),
                    disabledColor: Colors.indigo,
                    color: Colors.grey,
                    tooltip: 'Wax',
                    onPressed: waxButtonBlocked ? disableButton : null),
                IconButton(
                  icon: Icon(Icons.cake),
                  disabledColor: Colors.indigo,
                  color: Colors.grey,
                  tooltip: 'Candle',
                  onPressed: candleButtonBlocked ? disableButton : null),
              ],
            ),
            DropdownButton<String>(
              value: dropdownValue,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: brands.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
              ),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text("Power:"),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              itemSize: 25,
              glow: false,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.local_fire_department_rounded,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                power = rating.toInt();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("Rating:"),
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              itemSize: 25,
              glow: false,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                rate = rating.toInt();
              },
            ),
          ],
        ),
      ),
    );
  }
}

