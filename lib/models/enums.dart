enum TicketStatus {
  pending,      // 0
  inProgress,   // 1
  resolved,     // 2
  closed;       // 3

  static TicketStatus fromInt(int value) => TicketStatus.values[value];
  int toInt() => index;
}

enum Sector {
  infrastructure, // 0
  health,         // 1
  education,      // 2
  safety,         // 3
  other;          // 4

  static Sector fromInt(int value) => Sector.values[value];
  int toInt() => index;
}

enum Priority {
  low,    // 0
  medium, // 1
  high;   // 2

  static Priority fromInt(int value) => Priority.values[value];
  int toInt() => index;
}
