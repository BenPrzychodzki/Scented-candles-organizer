import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wax_picker/utils/Database.dart';

class DetailedView extends StatelessWidget {

  final item;
  DetailedView({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (dragUpdateDetails) {
          if(dragUpdateDetails.delta.dy<-1){
            Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                height: 350,
                width: double.infinity,
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
            Text(
              '${item.name}',
              style: TextStyle(
                fontSize: 25
              ),
            ),
            Text(
              '${item.description}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 15,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                        'Ocena'
                    ),
                    RatingBar.builder(
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
                  ],
                ),
                Column(
                  children: [
                    Text(
                        'Moc'
                    ),
                    RatingBar.builder(
                      initialRating: item.power.toDouble(),
                      minRating: 1,
                      itemSize: 20,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        item.power = rating.toInt();
                        DBProvider.db.updateWax(item);
                        print(rating);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "${item.brand}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ),
          ],
            ),
      ),
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