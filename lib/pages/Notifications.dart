import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_management_software/models/UserNotification.dart';
import 'package:inventory_management_software/services/APIService.dart';


class Notifications extends StatefulWidget {
  Notifications();

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: notificationsWdget(context),
    );
  }

  Widget notificationsWdget(BuildContext context) {
    return Center(
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              //padding: EdgeInsets.all(16),
                child: bodyWidget()
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget(){
    return FutureBuilder<List<UserNotification>>(
        future:  GetNotifications(),
        builder: (BuildContext context, AsyncSnapshot<List<UserNotification>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Loading...'));
          }
          else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          }
          else{
            return ListView(
              children: snapshot.data!.map((e) => NotificationWidget(e)).toList(),
            );
          }
        }
    );
  }

  Future<List<UserNotification>> GetNotifications() async{
    String query = 'UserId=' + APIService.userId.toString();

    var notifications = await APIService.Get('UserNotification', query);
    return notifications!.map((i)=>UserNotification.fromJson(i)).toList();
  }

  Widget NotificationWidget(notification){
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ListTile(
                title: Text('${notification.notificationText}'),
                subtitle: Text(notification.notificationDate),
              )
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () async{
              String body = '{"isRead": true}';
              var delete = await APIService.Put('UserNotification', notification.id, body);
              setState((){});
            },
          )
        ],
      ),
    );
  }

}
