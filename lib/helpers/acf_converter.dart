import 'dart:convert';

class ACFConverter {
  /// Turns the provided acf string to valid JSON.
  static dynamic acfToJson(String acf){
    // Replace newlines with commas.
    acf = acf.replaceAll(RegExp(r'(\r\n|\r|\n)'), ',');
    // Remove tab characters.
    acf = acf.replaceAll('	', '');
    // Fix key and value pair for simple values by adding a colon.
    acf = acf.replaceAll('""','": "');
    // Remove comma added by the first step.
    acf = acf.replaceAll('{,', '{');
    // Remove "AppState" + the comma added by step 1 at the beginning.
    acf = acf.replaceFirst('"AppState",', '');
    // Fix key and value pair for object values by removing comma added in step 1 and adding a colon.
    acf = acf.replaceAll('",{', '":{');
    // Remove trailing commas on simple values.
    acf = acf.replaceAll(',}', '}');
    // Remove trailing commas on object values.
    acf = acf.replaceAll('},}', '}}');
    // Removes final trailing comma.
    acf = acf.substring(0, acf.length - 1);

    return jsonDecode(acf);
  }
}