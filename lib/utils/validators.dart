import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Validators extends ChangeNotifier {
  String? simpleEmailValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Ju lutemi vendosni email-in';
    } 
    return null;
  }

  String? emailValidator(String? value, BuildContext context) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (value == null || value.isEmpty) {
      return 'Ju lutemi vendosni email-in';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Ju lutem vendoni nje email te sakte';
    }
    return null;
  }

  String? simplePasswordValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Ju lutemi vendosni password-in';
    }
    return null;
  }

  String? firstNameValidator(String? value, BuildContext context) {
    RegExp regex = RegExp(r'^[a-zA-Z]+$');
    if (value == null || value.isEmpty) {
      return 'Ju lutemi vendosni nje emer';
    } else if (!regex.hasMatch(value)) {
      return 'Emri duhet te permbaje vetem germa';
    }
    return null;
  }

  String? lastNameValidator(String? value, BuildContext context) {
    RegExp regex = RegExp(r'^[a-zA-Z]+$');
    if (value == null || value.isEmpty) {
      return 'Ju lutemi vendosni nje mbiemer';
    } else if (!regex.hasMatch(value)) {
      return 'Mbiemri duhet te permbaje vetem germa';
    }
    return null;
  }

  String? cityValidator(String? value, BuildContext context) {
    RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
    if (value == null || value.isEmpty) {
      return 'Ju lutemi vendosni nje qytet';
    } else if (!regex.hasMatch(value)) {
      return 'Qyteti duhet te permbaje vetem germa';
    }
    return null;
  }

  String? addressValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Ju lutem vendosni nje adrese';
    }
    return null;
  }

  String? dateValidator(String year, String month, String day, BuildContext context, bool isBirthdate) {
    List<String> missingFields = [];

    if (year.isEmpty) {
      missingFields.add('vitin');
    }
    if (month.isEmpty) {
      missingFields.add('muajin');
    }
    if (day.isEmpty) {
      missingFields.add('ditën');
    }

    if (missingFields.isNotEmpty) {
      return 'Ju lutemi vendosni ${missingFields.join('/')}';
    }

    int yearInt = int.tryParse(year) ?? 0;
    int monthInt = int.tryParse(month) ?? 0;
    int dayInt = int.tryParse(day) ?? 0;
    
    int currentYear = DateTime.now().year;

    if (isBirthdate) {
      if (yearInt < 1920 || yearInt > currentYear) {
        return 'Viti i lindjes duhet të jetë ndërmjet 1920 dhe $currentYear.';
      }
    } else {
      if (yearInt <= 2023) {
        return 'Viti i automjetit duhet të jetë pas vitit 2023.';
      }
    }
    
    if (monthInt < 1 || monthInt > 12) {
      return 'Ju lutemi vendosni një muaj të vlefshëm (1-12).';
    }

    int daysInMonth = DateTime(yearInt, monthInt + 1, 0).day;
    if (dayInt < 1 || dayInt > daysInMonth) {
      return 'Ju lutemi vendosni një ditë të vlefshme (1-$daysInMonth).';
    }

    return null;
  }

  String? registerPasswordValidator(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'Ju lutem vendosni nje password';
  } else if (value.length < 8) {
    return 'Passwordi duhet te permbaje me shume se 8 karaktere';
  } else if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Passwordi duhet te kete te pakten nje germe te madhe te shtypit';
  }
  return null;
}

}



