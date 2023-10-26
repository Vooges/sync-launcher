class AccountValue {
  final int id;
  final int launcherId;
  String? value;
  final String name;

  AccountValue({
    required this.id, 
    required this.launcherId, 
    required this.value, 
    required this.name
  });

  AccountValue.fromMap({required Map<String, Object?> map}) :
    id = map['id'] as int,
    launcherId = map['launcher_id'] as int,
    value = map['value'] as String?,
    name = map['name'] as String;

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'launcher_id': launcherId,
      'value': value,
      'name': name
    };
  }
}