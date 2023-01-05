import 'package:scoped_model/scoped_model.dart';
import 'package:Edimu/scoped_model/connected_model.dart';

class MainModel extends Model
    with ConnectedModel, transactionModel, userModel, UtilityModel {}
