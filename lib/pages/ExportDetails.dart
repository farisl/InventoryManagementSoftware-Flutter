import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/Export.dart';
import 'package:inventory_management_software/models/Customer.dart';
import 'package:inventory_management_software/models/ExportDetail.dart';
import 'package:inventory_management_software/pages/ExportDetailProduct.dart';
import 'package:inventory_management_software/services/APIService.dart';


class ExportDetails extends StatefulWidget {
  Export? export;
  //DateTime? date;

  ExportDetails(this.export);

  @override
  _ExportDetailsState createState() => _ExportDetailsState();
}

class _ExportDetailsState extends State<ExportDetails>{
  DateTime? date;
  TextEditingController _dateController =
  new TextEditingController();

  Customer? _selectedCustomer;
  int? customerId;
  List<DropdownMenuItem> items = [];
  @override
  void initState() {
    super.initState();
    date = widget.export != null ? widget.export!.date : DateTime.now();
    _dateController.text = date.toString().substring(0,10);
    if(widget.export != null)
      customerId = widget.export!.customerId;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Export details'),
          actions: [
            RaisedButton(
              onPressed: (){
                if(customerId == null)
                  showAlertDialog(context, 'Customer is not selected.');
                else {
                  var export = Save();
                  if (widget.export != null)
                    showAlertDialog(context, 'Export is successfully updated.');
                  else
                    showAlertDialog(context, 'Export successfully added.');
                }
              },
              child: Text('Save', style: TextStyle(fontSize: 18),),
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 5,
            )
          ],
        ),
        body: exportDetailsWdget(context),
        bottomNavigationBar: widget.export != null ? bottomNavigationBar() : null
    );
  }

  Widget bottomNavigationBar(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExportDetailProduct(
                  widget.export!.id, null))
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

  Widget exportDetailsWdget(BuildContext context) {
    return FutureBuilder<List<Customer>>(
      future: GetCustomers(_selectedCustomer),
      builder: (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
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
                            labelText: 'Export date',
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
                    hint: widget.export != null ? Text(widget.export!.customerName.toString())
                        : Text('Select a customer'),
                    value: _selectedCustomer,
                    isExpanded: true,
                    items: items,
                    onChanged: (newVal) {
                      _selectedCustomer = newVal;
                      customerId = _selectedCustomer!.id;
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

  Future<List<Customer>> GetCustomers(Customer? selectedItem) async{
    var customers = await APIService.Get('Customer', null);
    var customersList = customers!.map((e) => Customer.fromJson(e)).toList();

    items = customersList.map((item){
      return DropdownMenuItem<Customer>(
          child: Text(item.name.toString()),
          value: item
      );
    }).toList();

    if(selectedItem != null && selectedItem.id != 0){
      _selectedCustomer = customersList.where((element) => element.id == selectedItem.id).first;
      customerId = _selectedCustomer!.id;
    }

    return customersList;
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
    return FutureBuilder<List<ExportDetail>>(
        future:  GetExportDetails(),
        builder: (BuildContext context, AsyncSnapshot<List<ExportDetail>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Loading...'));
          }
          else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          }
          else{
            return ListView(
              children: snapshot.data!.map((e) => ExportDetailWidget(e)).toList(),
            );
          }
        }
    );
  }

  Future<List<ExportDetail>> GetExportDetails() async{
    String query = 'ExportId=';
    if(widget.export != null)
      query = query + widget.export!.id.toString();
    else
      query = query + '0';

    var exportDetails = await APIService.Get('ExportDetail', query);
    return exportDetails!.map((i)=>ExportDetail.fromJson(i)).toList();
  }

  Widget ExportDetailWidget(exportDetail){
    return Card(
      child: TextButton(
        onPressed: (){
          if(widget.export != null) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    ExportDetailProduct(
                        widget.export!.id, exportDetail))
            ).then((value) => setState(() {}));
          }
        },
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListTile(
                  title: Text('${exportDetail.productName} (${exportDetail.quantity.toString()}x)'),
                  //subtitle: Text(product.category),
                  trailing: Text('€${exportDetail.price.toStringAsFixed(2)}'),
                )
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async{
                var delete = await APIService.Delete('ExportDetail', exportDetail.id);
                setState((){});
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> Save() async{
    /*var body = jsonEncode(<String, String>{
      'date' : date.toString().substring(0,10),
      'inventoryId' : widget.export!.inventoryId.toString(),
      'customerId' : customerId.toString()
    });*/
    if(widget.export != null) {
      String bodyText = '{"date": "${date.toString().substring(0, 10)}",'
          '"inventoryId": ${widget.export!.inventoryId.toString()},'
          '"customerId": ${customerId.toString()}}';
      var export = await APIService.Put('Export', widget.export!.id, bodyText);
    }
    else{
      String query = 'Date=' + date.toString().substring(0,10)
          + '&InventoryId=' + APIService.inventoryId.toString()
          + '&CustomerId=' + customerId.toString()
          + '&EmployeeId=' + APIService.employeeId.toString();
      var response = await APIService.Post('Export', query);
      setState(() {
        widget.export = Export.fromJson(response);
      });
    }
  }



}
