import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'addItem.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  CollectionReference stock = FirebaseFirestore.instance.collection('stock');
  List<String> docId = [];

  Future getItem() async {
    await stock.get().then((snapshot) => snapshot.docs.forEach((document) {
          docId.add(document.reference.id);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {
                docId = [];
              });
            },
            icon: const Icon(Icons.refresh)),
      ),
      body: FutureBuilder(
        future: getItem(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: docId.length,
              itemBuilder: (context, index) {
                return getListTile(context, docId[index], index);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Item()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  getListTile(BuildContext context, String document, int index) {
    return FutureBuilder<DocumentSnapshot>(
        future: stock.doc(document).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius:const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              margin:
                  const EdgeInsets.only(bottom: 2, left: 10, right: 10, top: 2),
              child: ListTile(
                onTap: () async {},
                tileColor: Colors.white,
                trailing: IconButton(
                    onPressed: () async {}, icon: const Icon(Icons.edit)),
                title: Text(
                  data['item'],
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          data['qty'].toString(),
                          style: const TextStyle(
                              color: Colors.green, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Text(
                          getDate(data['purDate'].toDate()),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'B:${data['buyPrice'].toString()}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'S:${data['sellPrice'].toString()}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Text('loading');
        }));
  }

  String getDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
