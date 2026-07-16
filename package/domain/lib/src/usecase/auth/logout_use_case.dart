import 'package:injectable/injectable.dart';

import '../../repository/repository.dart';
import '../base/base_future_use_case.dart';
import '../base/no_input.dart';

@Injectable()
class LogoutUseCase extends BaseFutureUseCase<NoInput, void> {
  const LogoutUseCase(this._repository);

  final Repository _repository;

  @override
  Future<void> buildUseCase(NoInput input) => _repository.logout();
}
