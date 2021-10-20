import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wax_picker/utils/Database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:wax_picker/utils/avg_color.dart';

class DetailedView extends StatefulWidget {

  final item;
  DetailedView({this.item});

  @override
  _DetailedViewState createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  File _image;
  final picker = ImagePicker();

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
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            new Color(widget.item.color),
                            Colors.deepPurple[300],
                          ]
                      )
                  ),
                ),
              ),
              _image == null ? Positioned(
                  bottom: 125.0,
                  right: 0.0,
                  left: 0.0,
                  child: Container(
                    child:  Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          iconSize: 50,
                          color: new Color(widget.item.color).computeLuminance() > 0.5 ? Colors.black : Colors.white,
                          onPressed: () async {
                            final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 100);

                            if (pickedFile!=null) {
                              widget.item.color = await getAvgColor(File(pickedFile.path));
                              DBProvider.db.updateWax(widget.item);
                            }

                            setState(() {
                              if (pickedFile!=null) {
                                _image=File(pickedFile.path);
                              }
                            });
                          },
                        ),
                        Text(
                          "Add image",
                          style: TextStyle(
                            color: new Color(widget.item.color).computeLuminance() > 0.5 ? Colors.black : Colors.white,
                          ),
                        )
                      ],
                    )
                    )
                  ) : Positioned(
                    bottom: -40,
                    right: 0,
                    left: 0,
                    child: Container(
                      child: CircleAvatar(
                      radius: 80,
                      backgroundColor: new Color(widget.item.color),
                      child: ClipOval(child: Image.file(_image))
                ),
                    ),
                  )
            ]
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              '${widget.item.name}',
              style: TextStyle(
                fontSize: 25
              ),
            ),
            Text(
              '${widget.item.description}',
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
                        'Rating'
                    ),
                    RatingBar.builder(
                      initialRating: widget.item.rating.toDouble(),
                      minRating: 1,
                      itemSize: 20,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        widget.item.rating = rating.toInt();
                        DBProvider.db.updateWax(widget.item);
                        print(rating);
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                        'Power'
                    ),
                    RatingBar.builder(
                      initialRating: widget.item.power.toDouble(),
                      minRating: 1,
                      itemSize: 20,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        widget.item.power = rating.toInt();
                        DBProvider.db.updateWax(widget.item);
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
              "${widget.item.brand}",
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