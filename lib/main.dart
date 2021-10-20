import 'package:flutter/material.dart';
import 'package:wax_picker/models/waxModel.dart';
import 'package:wax_picker/utils/Database.dart';
import 'package:animations/animations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wax_picker/addPopup.dart';
import 'detailedView.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WaxPicker(),
    theme: ThemeData(
      primaryColor: Colors.deepPurple[800],
      accentColor: Colors.deepPurple[800],
    ),
  ));
}

class WaxPicker extends StatefulWidget {
  @override
  _WaxPickerState createState() => _WaxPickerState();
}

class _WaxPickerState extends State<WaxPicker> {

  String username = 'Ben';
  var whichPressed = 'Wax';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  child: Center(child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,5),
                    child: Text(
                      "Dzień dobry, $username",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  )),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.deepPurple[700],
                            Colors.deepPurple[300],
                          ]
                      )
                  ),
                ),
              ),
              Positioned(
                bottom: -10.0,
                right: 0.0,
                left: 0.0,
                child: FloatingActionButton(
                  backgroundColor: Colors.deepPurple[400],
                  child: Icon(Icons.add),
                  onPressed: () async {
                    await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddPopup();
                      }
                    );
                    setState(() {});
                  },
                )
              )
            ]
          ),
          SizedBox(
            height: 15,
          ),
          FutureBuilder<List<WaxModel>>(
              future: DBProvider.db.getWaxes(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<WaxModel>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 525,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        WaxModel item = snapshot.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: OpenContainer(
                            transitionType: ContainerTransitionType.fade,
                              transitionDuration: Duration(milliseconds: 600),
                              closedBuilder: (context, action) {
                                return Card(
                                  color: Colors.deepPurple[400],
                                  child: Column(
                                    children: [
                                      ListTile(
                                          title: Text(
                                            '${item.name}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: RatingBar.builder(
                                            initialRating: item.rating.toDouble(),
                                            minRating: 1,
                                            itemSize: 20,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              item.rating = rating.toInt();
                                              DBProvider.db.updateWax(item);
                                              print(rating);
                                            },
                                          ),
                                          leading: Text(
                                            '${item.propType}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 10,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () async {
                                              await DBProvider.db.deleteWax(item.name, item.propType);
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.remove_circle),
                                          )
                                      ),
                                    ],
                                  ),
                                );
                              },
                              openBuilder: (context, action) {
                                return DetailedView(item: item);
                              }
                          ),
                        );
                      },
                    ),
                  );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
        ],
      )
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width/2,size.height, size.width, size.height*0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

/*
FloatingActionButton(
child: Icon(Icons.add),
backgroundColor: Colors.deepPurple[300],
onPressed: () async {
var id = await DBProvider.db.countID()+1;
//print(id);
var newDBWax = WaxModel(id: id, propType: 'Wosk', name: 'Passion Fruit Martini',
    brand: 'Yankee Candle', description: 'Usiądź wygodnie i zrelaksuj się popijając soczysty tropikalno-owocowy koktajl. Połączenie marakui, mango i pomarańczy.', power: 1, rating: 1, amount: 1);
await DBProvider.db.newWax(newDBWax);
setState(() {});
}
)
*/
