class Result {
  Discipline discipline;
  double value;
}

enum Discipline {
  RUN_50,
  RUN_75,
  RUN_100,
  RUN_800,
  RUN_2000,
  RUN_3000,
  HIGH_JUMP,
  LONG_JUMP,
  SHOT_PUT,
  SLING_BALL,
  BALL_THROWING_80,
  BALL_THROWING_200,
}

String disciplineToReadableValue(Discipline discipline) {
  return _availableDisciplines[discipline];
}

const Map<Discipline, String> _availableDisciplines = {
  Discipline.RUN_50: "50m Sprint",
  Discipline.RUN_75: "75m Sprint",
  Discipline.RUN_100: "100m Sprint",
  Discipline.RUN_800: "800m Lauf",
  Discipline.RUN_2000: "2000m Lauf",
  Discipline.RUN_3000: "3000m Lauf",
  Discipline.HIGH_JUMP: "HochSprung",
  Discipline.LONG_JUMP: "Weitsprung",
  Discipline.SHOT_PUT: "Kugelstoßen",
  Discipline.SLING_BALL: "Schleuderball",
  Discipline.BALL_THROWING_80: "80g Weitwurf",
  Discipline.BALL_THROWING_200: "200g Weitwurf",
};

bool hasMultipleInputs(Discipline discipline) {
  return _disciplineHasMultipleInputs[discipline];
}

const Map<Discipline, bool> _disciplineHasMultipleInputs = {
  Discipline.RUN_50: true,
  Discipline.RUN_75: true,
  Discipline.RUN_100: true,
  Discipline.RUN_800: true,
  Discipline.RUN_2000: true,
  Discipline.RUN_3000: true,
  Discipline.HIGH_JUMP: false,
  Discipline.LONG_JUMP: false,
  Discipline.SHOT_PUT: false,
  Discipline.SLING_BALL: false,
  Discipline.BALL_THROWING_80: false,
  Discipline.BALL_THROWING_200: false,
};