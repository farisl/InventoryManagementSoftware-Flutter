import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/Import.dart';
import 'package:inventory_management_software/models/Supplier.dart';
import 'package:inventory_management_software/models/ImportDetail.dart';
import 'package:inventory_management_software/models/Product.dart';
import 'package:inventory_management_software/pages/ImportDetailProduct.dart';
import 'package:inventory_management_software/services/APIService.dart';


class ImportDetails extends StatefulWidget {
  Import? import;
  //DateTime? date;

  ImportDetails(this.import);

  @override
  _ImportDetailsState createState() => _ImportDetailsState();
}

class _ImportDetailsState extends State<ImportDetails>{
  DateTime? date;
  TextEditingController _dateController =
  new TextEditingController();

  Supplier? _selectedSupplier;
  int? supplierId;
  List<DropdownMenuItem> items = [];
  @override
  void initState() {
    super.initState();
    date = widget.import != null ? widget.import!.date : DateTime.now();
    _dateController.text = date.toString().substring(0,10);
    if(widget.import != null)
      supplierId = widget.import!.supplierId;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import details'),
        actions: [
          RaisedButton(
            onPressed: (){
              if(supplierId == null)
                showAlertDialog(context, 'Supplier is not selected.');
              else {
                var import = Save();
                if (widget.import != null)
                  showAlertDialog(context, 'Import is successfully updated.');
                else
                  showAlertDialog(context, 'Import successfully added.');
              }
            },
            child: Text('Save', style: TextStyle(fontSize: 18),),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 5,
          )
        ],
      ),
      body: importDetailsWdget(context),
        bottomNavigationBar: widget.import != null ? bottomNavigationBar() : null
    );
  }

  Widget bottomNavigationBar(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImportDetailProduct(
                  widget.import!.id, null))
          ).then((value) => setState((){}));
        },
        color: Colors.blue,
        textColor: Colors.white,
        child: Text('Add a product'),
      ),
    );
  }

  showAlertDialog(BuildContext context, String message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Saved!"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget importDetailsWdget(BuildContext context) {
    return FutureBuilder<List<Supplier>>(
      future: GetSuppliers(_selectedSupplier),
      builder: (BuildContext context, AsyncSnapshot<List<Supplier>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text('Loading...'),
          );
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('${snapshot.error}')
          );
        }
        return Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _dateController,
                        //initialValue: widget.date.toString(),
                        decoration: InputDecoration(
                            labelText: 'Import date',
                            labelStyle: TextStyle(fontSize: 20)
                        )
                        ,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: DropdownButtonFormField<dynamic>(
                    key: new GlobalKey<FormState>(),
                    hint: widget.import != null ? Text(widget.import!.supplierName.toString())
                      : Text('Select a supplier'),
                    value: _selectedSupplier,
                    isExpanded: true,
                    items: items,
                    onChanged: (newVal) {
                      _selectedSupplier = newVal;
                      supplierId = _selectedSupplier!.id;
                    },
                  ),
                ),
                Expanded(
                    //padding: EdgeInsets.all(16),
                    child: bodyWidget()
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<Supplier>> GetSuppliers(Supplier? selectedItem) async{
    var suppliers = await APIService.Get('Supplier', null);
    var suppliersList = suppliers!.map((e) => Supplier.fromJson(e)).toList();

    items = suppliersList.map((item){
      return DropdownMenuItem<Supplier>(
          child: Text(item.name.toString()),
          value: item
      );
    }).toList();

    if(selectedItem != null && selectedItem.id != 0){
      _selectedSupplier = suppliersList.where((element) => element.id == selectedItem.id).first;
      supplierId = _selectedSupplier!.id;
    }

    return suppliersList;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date as DateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if(picked != null){
      date = picked;
      _dateController.text = picked.toString().substring(0,10);
    }
  }

  Widget bodyWidget(){
    return FutureBuilder<List<ImportDetail>>(
        future:  GetImportDetails(),
        builder: (BuildContext context, AsyncSnapshot<List<ImportDetail>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Loading...'));
          }
          else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          }
          else{
            return ListView(
              children: snapshot.data!.map((e) => ImportDetailWidget(e)).toList(),
            );
          }
        }
    );
  }

  Future<List<ImportDetail>> GetImportDetails() async{
    String query = 'ImportExportId=';
    if(widget.import != null)
      query = query + widget.import!.id.toString();
     else
       query = query + '0';

    var importDetails = await APIService.Get('ImportDetail', query);
    return importDetails!.map((i)=>ImportDetail.fromJson(i)).toList();
  }

  Widget ImportDetailWidget(importDetail){
    return Card(
      child: TextButton(
        onPressed: (){
          if(widget.import != null) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    ImportDetailProduct(
                        widget.import!.id, importDetail))
            ).then((value) => setState(() {}));
          }
        },
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListTile(
                  title: Text('${importDetail.productName} (${importDetail.quantity.toString()}x)'),
                  //subtitle: Text(product.category),
                  trailing: Text('€${importDetail.price.toStringAsFixed(2)}'),
                )
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async{
                var delete = await APIService.Delete('ImportDetail', importDetail.id);
                setState((){});
              },
            ),
            IconButton(
              icon: Icon(Icons.info_outline ),
              color: Colors.black,
              onPressed: () async{
                Product? product = await RecommendProduct(importDetail.productId);
                if(product != null)
                  showAlertDialog(context, 'Recommended product: ${product.name}');
                else
                  showAlertDialog(context, 'Not enough data for the recommender.');
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Product?> RecommendProduct(int id) async{
    var json = await APIService.Recommend('Product', id);
    Product recommendedProduct = Product.fromJson(json);

    return recommendedProduct;
  }

  Future<void> Save() async{
    /*var body = jsonEncode(<String, String>{
      'date' : date.toString().substring(0,10),
      'inventoryId' : widget.import!.inventoryId.toString(),
      'supplierId' : supplierId.toString()
    });*/
    if(widget.import != null) {
      String bodyText = '{"date": "${date.toString().substring(0, 10)}",'
          '"inventoryId": ${widget.import!.inventoryId.toString()},'
          '"supplierId": ${supplierId.toString()}}';
      var import = await APIService.Put('Import', widget.import!.id, bodyText);
    }
    else{
      String query = 'Date=' + date.toString().substring(0,10)
          + '&InventoryId=' + APIService.inventoryId.toString()
          + '&SupplierId=' + supplierId.toString()
          + '&EmployeeId=' + APIService.employeeId.toString();
      var response = await APIService.Post('Import', query);
      setState(() {
        widget.import = Import.fromJson(response);
      });
    }
  }



}
