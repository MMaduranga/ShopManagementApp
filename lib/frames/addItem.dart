import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Item extends StatefulWidget {
  final String? itemName;
  final String? document;
  final String? sPrice;
  final String? bPrice;
  final String? quantity;
  final String? date;
  final List<String>? docItemName;
  const Item(
      {Key? key,
      this.itemName,
      this.bPrice,
      this.sPrice,
      this.date,
      this.quantity,
      this.docItemName,
      this.document})
      : super(key: key);

  @override
  State<Item> createState() => _ItemState(
        itemName: itemName,
        sPrice: sPrice,
        bPrice: bPrice,
        quantity: quantity,
        date: date,
        docItemName: docItemName,
        document: document,
      );
}

class _ItemState extends State<Item> {
  final String? itemName;
  final String? sPrice;
  final String? bPrice;
  final String? quantity;
  final String? date;
  final List<String>? docItemName;
  final String? document;

  final buyPriceController = TextEditingController();
  final sellPriceController = TextEditingController();
  final qtyController = TextEditingController();
  final purDateController = TextEditingController();
  final controllerItem = TextEditingController();
  _ItemState(
      {this.itemName,
      this.bPrice,
      this.sPrice,
      this.date,
      this.quantity,
      this.docItemName,
      this.document});

  final stock = FirebaseFirestore.instance.collection('stock');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerItem.text = itemName!;
    buyPriceController.text = bPrice!;
    sellPriceController.text = sPrice!;
    qtyController.text = quantity!;
    purDateController.text = date!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controllerItem,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Item',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: sellPriceController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Selling Price',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: buyPriceController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Buying Price',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: qtyController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Quantity',
                hintText: 'Enter Quantity'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: purDateController,
            onTap: () async {
              DateTime? pickDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2024));
              if (pickDate != null) {
                setState(() {
                  purDateController.text =
                      DateFormat('yyyy-MM-dd').format(pickDate);
                });
              }
            },
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_month_outlined),
                border: InputBorder.none,
                labelText: 'Purchased Date',
                hintText: 'Enter Purchased Date'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: ()async {
                final item = controllerItem.text;
                final sellPrice = int.parse(sellPriceController.text);
                final buyPrice = int.parse(buyPriceController.text);
                final qty = int.parse(qtyController.text);
                final purDate = DateTime.parse(purDateController.text);
                if (!docItemName!.contains(item)) {
                  addItem(sellPrice, buyPrice, qty, purDate, item);
                  Navigator.pop(context);
                } else {
                  final decision = await existItem(context);
                  if (decision == 'OK') {
                    stock.doc(document).update({
                      'qty': qty,
                      'item': item,
                      'sellPrice': sellPrice,
                      'buyPrice': buyPrice,
                      'purDate': purDate
                    });
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text("Add")),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                final decision = await deleteItem(context);
                if (decision == 'OK') {
                  stock.doc(document).delete();
                }
                Navigator.pop(context);
              },
              child: const Text("Remove")),
        ],
      )),
    );
  }

  Future<String?> existItem(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Item Already exits'),
        content: const Text('Are you want to update?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String?> deleteItem(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Are you sure?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future addItem(int sellPrice, int buyPrice, int qty, DateTime purDate,
      String item) async {
    final json = {
      'qty': qty,
      'item': item,
      'sellPrice': sellPrice,
      'buyPrice': buyPrice,
      'purDate': purDate
    };
    await stock.doc().set(json);
  }

  String getDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
