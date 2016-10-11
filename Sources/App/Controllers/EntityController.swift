import Vapor
import HTTP

final class EntityController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Entity.all().makeNode().converted(to: JSON.self)
    }
    
    func show(request: Request, entity: Entity) throws -> ResponseRepresentable {
        return entity
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Entity> {
        return Resource(
            index: index,
            show: show
        )
    }
}
