import 'package:english_learning_app/models/user.dart';
import 'package:english_learning_app/service/database_service.dart';

import 'core_api_client.dart';

class DataClient {
  static final instance = CoreApiClient();

  static final DataClientModel user = new DataClientModel();
  // static SocketDataClientModel socket = new SocketDataClientModel();

  //notification
  static int? indexMainPageSelection;


  static logout() async {
    print('LOGGING OUT');
    indexMainPageSelection = null;
    // chatInternal.informationCustomer = null;
    user.currentUser = null;

    var dbClient = await (DatabaseService.db);
    //
    dbClient!.delete("Token");

  }
}
