import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../model/auth/login_response.dart';
import 'base/base_data_mapper.dart';

/// Maps the user fields embedded in the login response to a [User].
@Injectable()
class LoginUserDataMapper extends BaseDataMapper<LoginResponse, User> {
  const LoginUserDataMapper();

  @override
  User mapToEntity(LoginResponse? response) => User(
    id: response?.id ?? 0,
    username: response?.username ?? '',
    email: response?.email ?? '',
    firstName: response?.firstName ?? '',
    lastName: response?.lastName ?? '',
    imageUrl: response?.image ?? '',
  );
}
