// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/details.dart';
import 'package:jiffy/jiffy.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void getData() async {
    isLoading = true;
    data = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('expenses').get();
    QuerySnapshot querySnapshotCategories =
        await FirebaseFirestore.instance.collection('categories').get();
    data.addAll(querySnapshot.docs);
    categoriesData.addAll(querySnapshotCategories.docs);
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  bool isLoading = false;
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> categoriesData = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 25.0,
          ),
          Row(
            children: [
              // Use a flexible space or fixed width based on screen size
              SizedBox(
                width: screenWidth * 0.02, // 2% of the screen width
              ),
              // Add Category button
              IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/AddCategory',
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 211, 207, 207),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.60, // 30% of the screen width
              ),
              // Add Type button
              IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/AddType',
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.new_label_outlined,
                  color: Colors.black,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 211, 207, 207),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.01, // 1% of the screen width
              ),
              // Add Ex button
              IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/AddEx',
                    (route) => false,
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.all(5),
                ),
              ),
              SizedBox(width: screenWidth * 0.02,),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/Stat');
                },
                child: Text(
                  'Expenses',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10.0,
              ),
              TextButton(
                onPressed: () async {
                  isLoading = true;
                  data = [];
                  setState(() {});
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('expenses')
                      .get();
                  data.addAll(querySnapshot.docs);
                  setState(() {});
                  isLoading = false;
                  setState(() {});
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 233, 229, 229),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                ),
                child: Text(
                  'All',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 95, 94, 94),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(categoriesData.length, (index) {
                      return Row(
                        children: [
                          TextButton(
                            onLongPress: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                dialogBorderRadius: BorderRadius.circular(50),
                                title: 'Delete',
                                desc: 'we are going to delete this expense!',
                                buttonsTextStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                btnOkText: 'Delete',
                                btnOkColor: Colors.red,
                                btnOkOnPress: () async {
                                  await FirebaseFirestore.instance
                                      .collection('categories')
                                      .doc(categoriesData[index].id)
                                      .delete();
                                  setState(() {});
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/Home', (route) => false);
                                },
                              ).show();
                            },
                            onPressed: () async {
                              isLoading = true;
                              setState(() {});
                              data = [];
                              QuerySnapshot querySnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('expenses')
                                      .where('category',
                                          isEqualTo: categoriesData[index]
                                              ['categoryName'])
                                      .get();
                              data.addAll(querySnapshot.docs);
                              isLoading = false;
                              setState(() {});
                            },
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 233, 229, 229),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: Text(
                              categoriesData[index]['categoryName'],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 95, 94, 94),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),

          isLoading
              ? Column(
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                  width: 320,
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Details(
                                            expenseId: data[index].id,
                                          )));
                            },
                            onLongPress: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                dialogBorderRadius: BorderRadius.circular(50),
                                title: 'Delete',
                                desc: 'we are going to delete this expense!',
                                buttonsTextStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                btnOkText: 'Delete',
                                btnOkColor: Colors.red,
                                btnOkOnPress: () async {
                                  await FirebaseFirestore.instance
                                      .collection('expenses')
                                      .doc(data[index].id)
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection('expenses')
                                      .doc(data[index].id)
                                      .collection('note')
                                      .doc(data[index].id)
                                      .delete();
                                  setState(() {});
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/Home', (route) => false);
                                },
                              ).show();
                            },
                            leading: Icon(
                              Icons.oil_barrel,
                              color: Colors.red,
                            ),
                            title: Text(data[index]['name']),
                            subtitle: Text(Jiffy.parse(
                                    data[index]['dateCreated'],
                                    pattern: 'dd-MM-y')
                                .format(pattern: 'E dd-MM-y')),
                            trailing: Text(
                                '${data[index]['cost'].toString()} ${data[index]['currency']}'),
                          ),
                        );
                      }),
                )),
        ],
      ),
    );
  }
}



// ElevatedButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//               },
//               child: Text('Log Out!')),





// TextButton(
//                             onPressed: () {
//                               Navigator.pushNamedAndRemoveUntil(
//                                   context, '/AddCategory', (route) => false);
//                             },
//                             style: IconButton.styleFrom(
//                               backgroundColor:
//                                   const Color.fromARGB(255, 233, 229, 229),
//                               padding: EdgeInsets.symmetric(horizontal: 15),
//                             ),
//                             child: Icon(
//                               Icons.add,
//                             ),
//                           ),