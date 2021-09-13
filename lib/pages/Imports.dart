import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/Import.dart';
import 'package:inventory_management_software/pages/ImportDetails.dart';
import 'package:inventory_management_software/services/APIService.dart';

class Imports extends StatefulWidget {
  const Imports({Key? key}) : super(key: key);

  @override
  _ImportsState createState() => _ImportsState();
}

class _ImportsState extends State<Imports> {
  DateTime dateFrom = DateTime(2021,1,1);
  DateTime dateTo = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imports'),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              children: [
                SizedBox(width: 15,),
                Expanded(child: dateFromWidget(dateFrom)),
                SizedBox(width: 100,),
                Expanded(child: dateFromWidget(dateTo))
              ],
            ),
          ),
          Expanded(child: bodyWidget())
        ],
      ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportDetails(null))
              ).then((value) => setState((){}));
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('New import'),
          ),
        )
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime date) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        if(date == dateFrom)
          dateFrom = picked;
        else
          dateTo = picked;
        GetImports();
      });
  }

  Widget dateFromWidget(DateTime date){
    return Padding(
      padding: EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(date == dateFrom ? 'Date from' : 'Date to'),
            //SizedBox(height: 1.0,),
            RaisedButton(
              onPressed: () => _selectDate(context, date),
              child: Text("${date.toLocal()}".split(' ')[0]),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget(){
    return FutureBuilder<List<Import>>(
        future: GetImports(),
        builder: (BuildContext context, AsyncSnapshot<List<Import>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Loading...'));
          }
          else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          }
          else{
            return ListView(
              children: snapshot.data!.map((e) => ImportWidget(e)).toList(),
            );
          }
        }
    );
  }

  Future<List<Import>> GetImports() async{
    String query = 'EmployeeId=${APIService.employeeId}';
    query = query + '&DateFrom=' + dateFrom.toString().substring(0,10);
    query = query + '&DateTo=' + dateTo.toString().substring(0,10);
    var imports = await APIService.Get('Import', query);
    return imports!.map((i)=>Import.fromJson(i)).toList();
  }

  Widget ImportWidget(import){
    return Card(
      child: TextButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImportDetails(import))
          ).then((value) => setState((){}));
        },
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListTile(
                  title: Text(import.dateString),
                  subtitle: Text(import.supplierName),
                  trailing: Text(import.productsCount),
                )
            ),
          ],
        ),
      ),
    );
  }

}