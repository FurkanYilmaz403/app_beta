import 'dart:math';

import 'package:app_beta/services/cloud/firebase_cloud.dart';
import 'package:flutter/material.dart';

class Utils {
  Size getScreenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }

  Future<String> getRandomGreeting() async {
    String name = await FirebaseCloud().getName();
    name = name.split(' ').first;
    name = name.toCapitalized();
    List<String> greetings = [
      "Merhaba, $name.",
      "İyi günler, $name.",
      "Tekrar merhaba, $name.",
      "Merhaba $name, bugün nasılsın?",
      "Hoşgeldin, $name.",
      "Tekrar hoşgeldin, $name.",
      "$name, seni görmek çok güzel!",
      "Seni özledik, $name.",
      "$name, geri gelmene sevindik!",
      "Favori kullanıcımız $name bugün nasıl hissediyor?",
      "Aramıza dönmene sevindik $name.",
      "Selamlar, $name.",
      "Hoşgeldin $name, umarız iyi vakit geçiriyorsundur.",
      "Neye ihtiyacın var, $name",
      "$name, servisimizi nasıl buldun?",
      "Güzel günler, $name.",
      "Sevgili $name, hoş geldin.",
      "$name, seni görmek çok güzel. İyi misin?",
      "Hayırlı günler, $name.",
      "$name, keyifler nasıl?",
      "$name, hoşça vakit geçiriyorsun umarım.",
      "Merhaba $name, bugün neler yapıyorsun?",
      "İyi akşamlar, $name.",
      "$name, sana nasıl yardımcı olabilirim?",
      "$name, günün nasıl geçiyor?",
      "Nasılsın, $name?",
      "Umarım günün güzel geçiyordur, $name.",
      "Haydi bir kahve içelim, $name.",
      "Gülümsemeyi unutma, $name.",
      "Nefis bir gün, $name!",
      "Her şey yolunda mı, $name?",
    ];
    return (greetings..shuffle()).first;
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
