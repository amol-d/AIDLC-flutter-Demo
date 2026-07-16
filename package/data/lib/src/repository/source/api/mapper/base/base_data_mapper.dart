/// Maps nullable wire DTOs to non-null domain entities with safe defaults.
/// Every response-to-entity conversion goes through a subclass of this.
abstract class BaseDataMapper<Response, Model> {
  const BaseDataMapper();

  Model mapToEntity(Response? response);

  List<Model> mapToEntityList(List<Response>? responses) =>
      responses?.map(mapToEntity).toList(growable: false) ?? const [];
}
