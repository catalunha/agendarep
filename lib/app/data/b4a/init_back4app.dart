import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'b4a_exception.dart';

class InitBack4app {
  Future<bool> init() async {
    try {
      const keyApplicationId = 'VtcsOwYidKPYKz4gTXbLELZXEiu0s5xbo4JGu3wJ';
      const keyClientKey = 'glVe7bAt5ve2fbPFUOyridy8goa21Ch9jMA0hR1i';
      const keyParseServerUrl = 'https://parseapi.back4app.com';
      await Parse().initialize(
        keyApplicationId,
        keyParseServerUrl,
        clientKey: keyClientKey,
        autoSendSessionId: true,
        debug: true,
      );
      ParseResponse healthCheck = (await Parse().healthCheck());
      if (healthCheck.success) {
        return true;
      }
      throw Exception();
    } catch (e) {
      print('+++ InitBack4app.init');
      print(e);
      print('--- InitBack4app.init');
      throw B4aException('Erro em inicializar o banco de dados',
          where: 'InitBack4app.init');
    }
  }
}
