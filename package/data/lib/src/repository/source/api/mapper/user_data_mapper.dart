import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../model/auth/user_response.dart';
import 'base/base_data_mapper.dart';

@Injectable()
class UserDataMapper extends BaseDataMapper<UserResponse, User> {
  const UserDataMapper();

  @override
  User mapToEntity(UserResponse? response) => User(
    id: response?.id ?? 0,
    username: response?.username ?? '',
    email: response?.email ?? '',
    firstName: response?.firstName ?? '',
    lastName: response?.lastName ?? '',
    imageUrl: response?.image ?? '',
  );
}
