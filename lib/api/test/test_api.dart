import 'package:my_app_cat/utils/http_util.dart';
import 'package:my_app_cat/model/user/user_model.dart';

class TestApi {
  Future<UserModel> testService() async {
    return await HttpUtil().get<UserModel>("/cat", fromJson: UserModel.fromJson);
  }
}
