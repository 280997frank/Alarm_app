class Alarm {
  int id;
  DateTime clock;
  bool active;
  bool isNotification;

  Alarm(int id, DateTime clock, bool active, bool isNotification) {
    this.id = id;
    this.clock = clock;
    this.active = active;
    this.isNotification = isNotification;
  }
}
