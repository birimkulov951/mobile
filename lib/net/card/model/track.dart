class TrackPayments {
  final String? token;
  final bool? subscribe;
  final String? account;

  TrackPayments({
    this.token,
    this.subscribe,
    this.account,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'subscribe': subscribe,
        'account': account,
      };
}
