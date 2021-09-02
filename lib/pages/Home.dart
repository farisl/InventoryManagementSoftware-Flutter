import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sidemenu'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('InventoryManagementSoftware'),
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
          ],
        ),
      ),
    );
  }
}
