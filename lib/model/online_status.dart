class OnlineStatus {
  OnlineStatus({
      String? userId, 
      String? state,}){
    _userId = userId;
    _state = state;
}

  OnlineStatus.fromJson(dynamic json) {
    _userId = json['user_id'];
    _state = json['state'];
  }
  String? _userId;
  String? _state;
OnlineStatus copyWith({  String? userId,
  String? state,
}) => OnlineStatus(  userId: userId ?? _userId,
  state: state ?? _state,
);
  String? get userId => _userId;
  String? get state => _state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['state'] = _state;
    return map;
  }

}