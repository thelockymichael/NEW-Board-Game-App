
class UserQuery {
  late String field;
  late String condition;
  late dynamic value;

  UserQuery(String field, String condition, dynamic value) {
    this.field = field;
    this.condition = condition;
    this.value = value;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gender': field,
      'condition': condition,
      'value': value,
    };
  }
}
