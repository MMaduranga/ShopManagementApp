import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Item extends StatefulWidget {
  const Item({Key? key}) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final buyPriceController = TextEditingController();
  final sellPriceController = TextEditingController();
  final qtyController = TextEditingController();
  final purDateController = TextEditingController();
  final controllerItem = TextEditingController();

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
                hintText: 'Enter Item'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: sellPriceController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Selling Price',
                hintText: 'Enter Sell Price'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: buyPriceController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Buying Price',
                hintText: 'Enter Buying Price'),
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
              onPressed: () {
                final item = controllerItem.text;
                final sellPrice = int.parse(sellPriceController.text);
                final buyPrice = int.parse(buyPriceController.text);
                final qty = int.parse(qtyController.text);
                final purDate = DateTime.parse(purDateController.text);
                addItem(sellPrice, buyPrice, qty, purDate, item);
                Navigator.pop(context);
              },
              child: const Text("Add"))
        ],
      )),
    );
  }

  Future addItem(int sellPrice, int buyPrice, int qty, DateTime purDate,
      String item) async {
    final docItem = FirebaseFirestore.instance.collection('stock').doc();
    final json = {
      'qty': qty,
      'item': item,
      'sellPrice': sellPrice,
      'buyPrice': buyPrice,
      'purDate': purDate
    };
    await docItem.set(json);
  }
}
