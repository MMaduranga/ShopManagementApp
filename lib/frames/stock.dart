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
  List<String> docItemName = [];
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
              context,
              MaterialPageRoute(
                  builder: (context) => Item(
                        itemName: '',
                        bPrice: '',
                        sPrice: '',
                        quantity: '',
                        date: '',
                        docItemName: docItemName,
                        document: '',
                      )));
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
            docItemName.add(data['item']);
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              margin:
                  const EdgeInsets.only( left: 10, right: 10, top: 4),
              child: ListTile(
                onTap: () {},
                tileColor: Colors.white,
                trailing: IconButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Item(
                                    itemName: data['item'],
                                    bPrice: data['buyPrice'].toString(),
                                    sPrice: data['sellPrice'].toString(),
                                    quantity: data['qty'].toString(),
                                    date: data['purDate'].toDate().toString(),
                                    docItemName: docItemName,
                                    document: docId[index],
                                  )));
                    },
                    icon: const Icon(Icons.edit)),
                title: Text(
                  data['item'],
                  style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Mechanical'),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Quantity : ',
                          style:
                          TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          data['qty'].toString(),
                          style: const TextStyle(
                              color: Colors.green, fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Purchased Date : ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            Text(
                              getDate(data['purDate'].toDate()),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Buying Price : ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            Text(
                              data['buyPrice'].toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Selling Price : ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            Text(
                              data['sellPrice'].toString(),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
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
