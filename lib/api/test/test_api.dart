import 'package:cat/utils/http_util.dart';
import 'package:cat/model/user/user_model.dart';

class TestApi {
  Future<UserModel> testService() async {
    return await HttpUtil().get<UserModel>("/cat", fromJson: UserModel.fromJson);
  }
}
