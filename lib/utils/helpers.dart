class Helpers {
  static String capitalize(String data){
    String result = "";
    if(data.contains(" ")) {
      if (data.isEmpty) {
        return "";
      }
      if (data.length <= 1) {
        return data.toUpperCase();
      }
      final List<String> words = data.split(' ');
      final capitalizedWords = words.map((word) {
        if (word.trim().isNotEmpty) {
          final String firstLetter = word.trim().substring(0, 1).toUpperCase();
          final String remainingLetters = word.trim().substring(1);

          return '$firstLetter$remainingLetters';
        }
        return '';
      });
      return capitalizedWords.join(' ');
    } else {
      if (data.isEmpty) {
        return "";
      }
      result = data[0].toUpperCase() + data.substring(1).toLowerCase();
      return result;
    }
  }

  static String titleCase(String data){
    if (data.isEmpty) {
      return "";
    }

    if (data.length <= 1) {
      return data.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = data.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }
}