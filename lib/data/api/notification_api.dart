import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/responses/notification/notification_response.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api.g.dart';

@RestApi()
@singleton
abstract class NotificationApi {
  @factoryMethod
  factory NotificationApi(Dio dio) = _NotificationApi;

  @GET('/uaa/api/account/news')
  Future<List<NotificationResponse>> getNotifications();

  @GET('/uaa/api/account/news/unread')
  Future<List<NotificationResponse>> getUnreadNotifications(
    @Query('ids') List<int> readNotificationIds,
  );
}
