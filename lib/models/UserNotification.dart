import 'dart:convert';

class UserNotification {
  final int? id;
  final bool? isRead;
  final int? notificationId;
  final int? userId;
  final String? notificationText;
  final String? notificationDate;


  UserNotification({
    this.id,
    this.isRead,
    this.notificationId,
    this.userId,
    this.notificationText,
    this.notificationDate
  });

  factory UserNotification.fromJson(Map<String, dynamic> json){
    return UserNotification(
        notificationText: json['notificationText'],
        notificationDate: json['notificationDate'],
        id: int.parse(json["id"].toString()),
        notificationId: int.parse(json["notificationId"].toString()),
        userId: int.parse(json["userId"].toString()),
        isRead: json["isRead"]
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "notificationText": notificationText,
        "notificationDate": notificationDate,
        "id": id,
        "userId": userId,
        "notificationId": notificationId,
        "isRead": isRead
      };
}

