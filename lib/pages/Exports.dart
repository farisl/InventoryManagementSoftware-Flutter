import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/Export.dart';
import 'package:inventory_management_software/pages/ExportDetails.dart';
import 'package:inventory_management_software/services/APIService.dart';

class Exports extends StatefulWidget {
  const Exports({Key? key}) : super(key: key);

  @override
  _ExportsState createState() => _ExportsState();
}

class _ExportsState extends State<Exports> {
  DateTime dateFrom = DateTime(2021,1,1);
  DateTime dateTo = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Exports'),
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
                  MaterialPageRoute(builder: (context) => ExportDetails(null))
              ).then((value) => setState((){}));
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('New export'),
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
        GetExports();
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
    return FutureBuilder<List<Export>>(
        future: GetExports(),
        builder: (BuildContext context, AsyncSnapshot<List<Export>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Loading...'));
          }
          else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          }
          else{
            return ListView(
              children: snapshot.data!.map((e) => ExportWidget(e)).toList(),
            );
          }
        }
    );
  }

  Future<List<Export>> GetExports() async{
    String query = 'EmployeeId=${APIService.employeeId}';
    query = query + '&DateFrom=' + dateFrom.toString().substring(0,10);
    query = query + '&DateTo=' + dateTo.toString().substring(0,10);
    var exports = await APIService.Get('Export', query);
    return exports!.map((i)=>Export.fromJson(i)).toList();
  }

  Widget ExportWidget(export){
    return Card(
      child: TextButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExportDetails(export))
          ).then((value) => setState((){}));
        },
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListTile(
                  title: Text(export.dateString),
                  subtitle: Text(export.customerName),
                  trailing: Text(export.productsCount),
                )
            ),
          ],
        ),
      ),
    );
  }



}
