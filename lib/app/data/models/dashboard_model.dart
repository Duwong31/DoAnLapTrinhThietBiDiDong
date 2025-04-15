class Dashboard {
  WeekMentalHealth? weekMentalHealth;
  Total? total;
  RequestedCounsellorSummary? requestedCounsellorSummary;

  Dashboard(
      {this.weekMentalHealth, this.total, this.requestedCounsellorSummary});

  Dashboard.fromJson(Map<String, dynamic> json) {
    weekMentalHealth = json['week_mental_health'] != null
        ? WeekMentalHealth.fromJson(json['week_mental_health'])
        : null;
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
    requestedCounsellorSummary = json['requested_counsellor_summary'] != null
        ? RequestedCounsellorSummary.fromJson(
            json['requested_counsellor_summary'])
        : null;
  }
}

class WeekMentalHealth {
  int? depressionPercentage;
  int? anxietyPercentage;
  int? stressPercentage;
  TotalStatus? totalStatus;

  WeekMentalHealth(
      {this.depressionPercentage,
      this.anxietyPercentage,
      this.stressPercentage,
      this.totalStatus});

  WeekMentalHealth.fromJson(Map<String, dynamic> json) {
    depressionPercentage = json['depression_percentage'];
    anxietyPercentage = json['anxiety_percentage'];
    stressPercentage = json['stress_percentage'];
    totalStatus = json['totalStatus'] != null
        ? TotalStatus.fromJson(json['totalStatus'])
        : null;
  }
}

class TotalStatus {
  int? numberUnhealthyDepression;
  int? numberConcerningDepression;
  int? numberModerateDepression;
  int? numberMildDepression;
  int? numberHealthyDepression;
  int? numberUnhealthyAnxiety;
  int? numberConcerningAnxiety;
  int? numberModerateAnxiety;
  int? numberMildAnxiety;
  int? numberHealthyAnxiety;
  int? numberUnhealthyStress;
  int? numberConcerningStress;
  int? numberModerateStress;
  int? numberMildStress;
  int? numberHealthyStress;
  int? totalStatusPax;

  TotalStatus(
      {this.numberUnhealthyDepression,
      this.numberConcerningDepression,
      this.numberModerateDepression,
      this.numberMildDepression,
      this.numberHealthyDepression,
      this.numberUnhealthyAnxiety,
      this.numberConcerningAnxiety,
      this.numberModerateAnxiety,
      this.numberMildAnxiety,
      this.numberHealthyAnxiety,
      this.numberUnhealthyStress,
      this.numberConcerningStress,
      this.numberModerateStress,
      this.numberMildStress,
      this.numberHealthyStress,
      this.totalStatusPax});

  TotalStatus.fromJson(Map<String, dynamic> json) {
    numberUnhealthyDepression = json['numberUnhealthyDepression'];
    numberConcerningDepression = json['numberConcerningDepression'];
    numberModerateDepression = json['numberModerateDepression'];
    numberMildDepression = json['numberMildDepression'];
    numberHealthyDepression = json['numberHealthyDepression'];
    numberUnhealthyAnxiety = json['numberUnhealthyAnxiety'];
    numberConcerningAnxiety = json['numberConcerningAnxiety'];
    numberModerateAnxiety = json['numberModerateAnxiety'];
    numberMildAnxiety = json['numberMildAnxiety'];
    numberHealthyAnxiety = json['numberHealthyAnxiety'];
    numberUnhealthyStress = json['numberUnhealthyStress'];
    numberConcerningStress = json['numberConcerningStress'];
    numberModerateStress = json['numberModerateStress'];
    numberMildStress = json['numberMildStress'];
    numberHealthyStress = json['numberHealthyStress'];
    totalStatusPax = json['totalStatusPax'];
  }
}

class Total {
  int? staff;
  String? counsellingHours;

  Total({this.staff, this.counsellingHours});

  Total.fromJson(Map<String, dynamic> json) {
    staff = json['staff'];
    counsellingHours = json['counselling_hours'];
  }
}

class RequestedCounsellorSummary {
  int? countTicket;
  int? countPendingTicket;
  int? countApprovedTicket;
  int? countRejectedTicket;

  RequestedCounsellorSummary(
      {this.countTicket,
      this.countPendingTicket,
      this.countApprovedTicket,
      this.countRejectedTicket});

  RequestedCounsellorSummary.fromJson(Map<String, dynamic> json) {
    countTicket = json['countTicket'];
    countPendingTicket = json['countPendingTicket'];
    countApprovedTicket = json['countApprovedTicket'];
    countRejectedTicket = json['countRejectedTicket'];
  }
}
