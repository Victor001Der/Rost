//метод сортировки возрастов
String getAgeWord(int years) {
  if (years % 100 >= 11 && years % 100 <= 19) return 'лет';
  if (years % 10 == 1) return 'годик';
  if (years % 10 >= 2 && years % 10 <= 4) return 'года';
  return 'лет';
}