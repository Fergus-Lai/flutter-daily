// Class For Storing Each Alarm
class AlarmItem {
  int id;
  String name;
  bool activate;

  AlarmItem({required this.id, required this.name, required this.activate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'activate': activate,
    };

    @override
    String toString() {
      return 'AlarmItem(id: $id, name: $name, age: $activate)';
    }
  }
}
