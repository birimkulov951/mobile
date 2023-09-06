abstract class HttpView {
  void onSuccess(dynamic body);
  void onFail(String details, {String title, dynamic errorBody});
}
