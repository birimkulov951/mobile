import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_ultra/data/api/dto/requests/feedback_request.dart';
import 'package:mobile_ultra/data/api/dto/responses/feedback_status_response.dart';
import 'package:retrofit/retrofit.dart';

part 'feedback_api.g.dart';

@RestApi()
@Singleton()
abstract class FeedbackApi {
  @factoryMethod
  factory FeedbackApi(Dio dio) = _FeedbackApi;

  @GET('microservice/api/check/feedback')
  Future<FeedbackStatusResponse> getUserFeedbackStatus();

  @POST('microservice/api/update/feedback')
  Future<void> sendFeedback(@Body() FeedbackRequest feedbackRequest);
}
