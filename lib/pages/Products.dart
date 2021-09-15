import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/Department.dart';
import 'package:inventory_management_software/models/Product.dart';
import 'package:inventory_management_software/services/APIService.dart';
import 'package:inventory_management_software/models//ProductSearchObject.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Department? _selectedDepartment;
  List<DropdownMenuItem> items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Column(
        children: [
          Center(child: dropDownWidget(),),
          Expanded(child: bodyWidget())
        ],
      ),
    );
  }

  Widget dropDownWidget(){
    return FutureBuilder<List<Department>>(
      future: GetDepartments(_selectedDepartment),
      builder: (BuildContext context, AsyncSnapshot<List<Department>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Text('Loading...'),
          );
        }
        if(snapshot.hasError){
          return Center(
              child: Text('${snapshot.error}')
          );
        }
        return Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: DropdownButton<dynamic>(
            hint: Text('Select department'),
            isExpanded: true,
            items: items,
            value: _selectedDepartment,
            onChanged: (newVal){
              setState(() {
                _selectedDepartment = newVal as Department?;
                GetProducts(_selectedDepartment);
              });
            },
          ),
        );
      },
    );
  }

  Future<List<Department>> GetDepartments(Department? selectedItem) async{
    String query = 'EmployeeId=${APIService.employeeId}';
    var departments = await APIService.Get('Department', query);
    var departmentsList = departments!.map((e) => Department.fromJson(e)).toList();

    items = departmentsList.map((item){
      return DropdownMenuItem<Department>(
          child: Text(item.name.toString()),
          value: item
      );
    }).toList();

    if(selectedItem != null && selectedItem.id != 0){
      _selectedDepartment = departmentsList.where((element) => element.id == selectedItem.id).first;
    }
    return departmentsList;
  }

  Widget bodyWidget(){
    return FutureBuilder<List<Product>>(
      future: GetProducts(_selectedDepartment),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: Text('Loading...'));
        }
        else if(snapshot.hasError){
          return Center(child: Text('${snapshot.error}'),);
        }
        else{
          return ListView(
            children: snapshot.data!.map((e) => ProductWidget(e)).toList(),
          );
        }
      }
    );
  }

  Future<List<Product>> GetProducts(Department? selectedItem) async{
    String query = 'EmployeeId=${APIService.employeeId}';

    if(selectedItem != null)
      query = query + '&DepartmentId=${selectedItem.id}';

    var products = await APIService.Get('Product', query);
    return products!.map((i)=>Product.fromJson(i)).toList();
  }

  Widget ProductWidget(product){
    return Card(
      child: TextButton(
        onPressed: (){},
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.category),
                  trailing: Text(product.price),
                )
            ),
          ],
        ),
      ),
    );
  }



}


