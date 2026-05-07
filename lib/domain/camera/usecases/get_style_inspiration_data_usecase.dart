import '../entities/style_inspiration_entities.dart';
import '../repositories/style_inspiration_repository.dart';

class GetStyleInspirationDataUseCase {
  final StyleInspirationRepository repository;

  GetStyleInspirationDataUseCase(this.repository);

  Future<StyleInspirationData> execute() {
    return repository.fetchStyleInspirationData();
  }
}
