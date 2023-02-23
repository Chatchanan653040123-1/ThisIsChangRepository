import 'package:app01/Atom/SimpleMaps.dart';
import 'package:app01/data/Place.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Searching extends StatefulWidget {
  const Searching({super.key});

  @override
  State<Searching> createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  final controller = TextEditingController();
  late TextEditingController _editingController; // gobalvar

  List<Place> places = allPlace;
  bool _isShow = false;

  @override
  void initState() {
    _editingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 54,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: Theme.of(context).primaryColor.withOpacity(0.23),
                )
              ]),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.only(right: 20),
                onPressed: () {
                  SimpleMaps().openDrawerCus();
                },
                icon: Icon(Icons.menu,
                    // color: Theme.of(context).primaryColor.withOpacity(0.5)),
                    color: Colors.black),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              // ),
              Expanded(
                child: TextField(
                  controller: _editingController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                        // color: Theme.of(context).primaryColor.withOpacity(0.5)),
                        color: Colors.black45),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              _editingController.text.trim().isEmpty
                  ? IconButton(
                      icon: Icon(Icons.search,
                          color:
                             Colors.black),
                          // color:
                          //     Theme.of(context).primaryColor.withOpacity(0.5)),
                      onPressed: null)
                  : IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.clear,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5)),
                      onPressed: () => setState(() {
                            _editingController.clear();
                          })),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> placeKhao = {};
  void getDatabaseCar() {
    final docRef =
        FirebaseFirestore.instance.collection("parkPlace").doc("place");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        placeKhao = data;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  void searchplace(String query) {
    final suggestions = allPlace.where((place) {
      final placeName = place.place.toLowerCase();
      final input = query.toLowerCase();

      return placeName.contains(input);
    }).toList();
    setState(() {
      places = suggestions;
    });
  }
}
