import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/Employee.dart';
import 'package:inventory_management_software/services/APIService.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Employee? employee;
  String? email;
  String? phone;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Image(image: AssetImage('assets/imssq-newwhite.jpg')
                ),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent
                  ),
                ),
                ListTile(
                  title: Text('Products'),
                  onTap: (){
                    Navigator.of(context).pushNamed('/products');
                  },
                ),
                ListTile(
                  title: Text('Imports'),
                  onTap: (){
                    Navigator.of(context).pushNamed('/imports');
                  },
                ),
                ListTile(
                  title: Text('Exports'),
                  onTap: (){
                    Navigator.of(context).pushNamed('/exports');
                  },
                ),
                ListTile(
                  title: Text('User profile'),
                  onTap: (){
                    Navigator.of(context).pushNamed('/userProfile');
                  },
                ),
                ListTile(
                  title: Text('Notifications'),
                  onTap: (){
                    Navigator.of(context).pushNamed('/notifications');
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            bottom: TabBar(
                tabs: [
                  Tab(text: 'Info'),
                  Tab(text: 'Contact'),
                  Tab(text: 'Work')
                ],
            ),
            title: Text('User profile'),
            actions: [
              RaisedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()) {
                    showAlertDialog(context, 'User data successfully saved.');
                    var update = Save();
                  }
                },
                child: Text('Save', style: TextStyle(fontSize: 18),),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 5,
              )
            ],
          ),
          body: TabBarView(
            children: [
              infoWidget(),
              contactWidget(),
              workWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoWidget(){
    return FutureBuilder<Employee>(
      future: GetEmployee(),
      builder: (BuildContext context, AsyncSnapshot<Employee> snapshot) {
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
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    initialValue: employee!.fullName,
                    decoration: InputDecoration(
                        labelText: 'Full name',
                        labelStyle: TextStyle(fontSize: 20)
                    )
                    ,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    initialValue: employee!.jmbg,
                    decoration: InputDecoration(
                        labelText: 'JMBG',
                        labelStyle: TextStyle(fontSize: 20)
                    )
                    ,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    initialValue: employee!.birthDate.toString().substring(0,10),
                    decoration: InputDecoration(
                        labelText: 'Birth date',
                        labelStyle: TextStyle(fontSize: 20)
                    )
                    ,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    initialValue: employee!.genderName,
                    decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(fontSize: 20)
                    )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget contactWidget(){
    return FutureBuilder<Employee>(
      future: GetEmployee(),
      builder: (BuildContext context, AsyncSnapshot<Employee> snapshot) {
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
        return Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        readOnly: true,
                        initialValue: employee!.username,
                        decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 20)
                        )
                        ,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return 'Email is a required field.';
                          return null;
                        },
                        initialValue: employee!.email,
                        onFieldSubmitted: (newVal){
                          email = newVal;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 20)
                        )
                        ,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        readOnly: true,
                        initialValue: employee!.addressName,
                        decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(fontSize: 20)
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          initialValue: employee!.city,
                          decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(fontSize: 20)
                          )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value){
                          if(value == null || value.isEmpty)
                            return 'Phone number is a required field.';
                          return null;
                        },
                        initialValue: employee!.phoneNumber,
                        onFieldSubmitted: (newVal){
                          phone = newVal;
                        },
                        decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(fontSize: 20)
                        )
                        ,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget workWidget(){
    return FutureBuilder<Employee>(
      future: GetEmployee(),
      builder: (BuildContext context, AsyncSnapshot<Employee> snapshot) {
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
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    initialValue: employee!.inventory,
                    decoration: InputDecoration(
                        labelText: 'Inventory',
                        labelStyle: TextStyle(fontSize: 20)
                    )
                    ,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    initialValue: employee!.hireDate.toString().substring(0,10),
                    decoration: InputDecoration(
                        labelText: 'Hire date',
                        labelStyle: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: TextFormField(
                      textAlign: TextAlign.center,
                      readOnly: true,
                      initialValue: r'$' + employee!.salary.toString(),
                      decoration: InputDecoration(
                          labelText: 'Salary',
                          labelStyle: TextStyle(fontSize: 20)
                      )
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Future<Employee> GetEmployee() async{
    var json = await APIService.GetById('Employee', APIService.employeeId);
    employee = Employee.fromJson(json);
    email = employee!.email;
    phone = employee!.phoneNumber;
    return employee!;
  }

  Future<void> Save() async{
    String body = '{"firstName": "${employee!.firstName}",'
        '"lastName": "${employee!.lastName}",'
        '"addressName": "${employee!.addressName}",'
        '"cityId": ${employee!.cityId},'
        '"email": "$email",'
        '"phoneNumber": "$phone",'
        '"active": ${employee!.active},'
        '"inventoryId": ${APIService.inventoryId},'
        '"hireDate": "${employee!.hireDate.toString().substring(0,10)}",'
        '"salary": ${employee!.salary},'
        '"genderId": ${employee!.genderId},'
        '"birthDate": "${employee!.birthDate.toString().substring(0,10)}",'
        '"jmbg": "${employee!.jmbg}"}';
    //print(body);
    var response = await APIService.Put('Employee', APIService.employeeId, body);
  }

}
