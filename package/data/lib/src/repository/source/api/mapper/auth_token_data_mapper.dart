import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../model/auth/login_response.dart';
import 'base/base_data_mapper.dart';

@Injectable()
class AuthTokenDataMapper extends BaseDataMapper<LoginResponse, AuthToken> {
  const AuthTokenDataMapper();

  @override
  AuthToken mapToEntity(LoginResponse? response) => AuthToken(
    accessToken: response?.effectiveAccessToken ?? '',
    refreshToken: response?.refreshToken ?? '',
  );
}
