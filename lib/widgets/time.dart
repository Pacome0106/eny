allTime(double heures) {

  // Conversion en années, mois, jours, heures, minutes et secondes
  int annees = (heures ~/ (24 * 365)).toInt();
  int mois = ((heures % (24 * 365)) ~/ (24 * 30)).toInt();
  int jours = (((heures % (24 * 365)) % (24 * 30)) ~/ 24).toInt();
  int heuresRestantes = (((heures % (24 * 365)) % (24 * 30)) % 24).toInt();
  int minutes = ((heures % 1) * 60).toInt();
  // int secondes = (((heures % 1) * 60) % 1 * 60).toInt();


  // Construction de la chaîne de caractères pour afficher le temps
  String resultat = '';
  if (annees > 0) {
    resultat += '$annees an${annees > 1 ? 's' : ''}, ';
  }
  if (mois > 0) {
    resultat += '$mois mois, ';
  }
  if (jours > 0) {
    resultat += '$jours jr${jours > 1 ? 's' : ''}, ';
  }
  if (heuresRestantes > 0) {
    resultat += '$heuresRestantes heure${heuresRestantes > 1 ? 's' : ''}, ';
  }
  if (minutes > 0) {
    resultat += '$minutes minute${minutes > 1 ? 's' : ''} ';
  }
  // if (secondes > 0) {
  //   resultat += '$secondes seconde${secondes > 1 ? 's' : ''}';
  // }

  return resultat;
}
allTime2(double heures) {

  // Conversion en années, mois, jours, heures, minutes et secondes
  int annees = (heures ~/ (24 * 365)).toInt();
  int mois = ((heures % (24 * 365)) ~/ (24 * 30)).toInt();

  // Construction de la chaîne de caractères pour afficher le temps
  String resultat = '';
  if (annees > 0) {
    resultat += '$annees an${annees > 1 ? 's' : ''}, ';
  }
  if (mois > 0) {
    resultat += '$mois mois ';
  }
  return resultat;
}