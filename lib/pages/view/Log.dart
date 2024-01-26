import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Log extends StatefulWidget {
  const Log({Key? key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');
  var refreshFlag = false;
  var searchQuery = '';

  void queryProduk(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warna.background,
      appBar: AppBar(
        backgroundColor: warna.appbar,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15), // Adjust the value as needed
          ),
        ),
        title: Center(
          child: Text(
            'Log',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: warna.putih,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: warna.background,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      queryProduk(value);
                    },
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'All Log',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: logsCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> logs = snapshot.data!.docs;

                final filteredlogs = searchQuery.isEmpty
                    ? logs
                    : logs.where((logs) {
                        final name = logs['userName'].toString().toLowerCase();
                        return name.contains(searchQuery);
                      }).toList();
                if (filteredlogs.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 50,
                          color: warna.ungu,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Log tidak ditemukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filteredlogs.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10), // Add spacing
                  itemBuilder: (context, index) {
                    var logsData =
                        filteredlogs[index].data() as Map<String, dynamic>;
                    String name = logsData['userName' ?? 'NoName'];
                    String activity = logsData['activity'];
                    // Check if 'created_At' field exists and is a Timestamp
                    Timestamp? createdTimestamp =
                        logsData['created_At'] as Timestamp?;
                    DateTime createdDateTime =
                        createdTimestamp?.toDate() ?? DateTime.now();

                    return Container(
                      padding: EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: Colors.white,
                        onTap: () {
                          // Add your onTap logic here if needed
                        },
                        leading: Container(
                          margin: EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: warna.ungu,
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          activity,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(createdDateTime),
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
