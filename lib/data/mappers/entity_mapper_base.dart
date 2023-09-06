abstract class CommonMapperBase<Entity, DTO>
    implements ToEntityMapper<Entity, DTO>, ToDTOMapper<Entity, DTO> {
  @override
  Entity toEntity(DTO dto);

  @override
  DTO toDTO(Entity entity);
}

abstract class ToEntityMapper<Entity, DTO> {
  Entity toEntity(DTO dto);
}

abstract class ToDTOMapper<Entity, DTO> {
  DTO toDTO(Entity entity);
}
