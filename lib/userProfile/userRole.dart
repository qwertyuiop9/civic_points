/// Class to handle the role of a user.
class RuoloUtente {
  final String ruolo;

  RuoloUtente(
      {
      this.ruolo});

  factory RuoloUtente.fromJson(Map<String, dynamic> json) {
    return RuoloUtente(
        ruolo: json['ruolo'],
        );
  }

}
