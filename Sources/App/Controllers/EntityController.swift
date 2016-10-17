import Vapor
import HTTP

final class EntityController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("entities")
        //return try Entity.all().makeNode().converted(to: JSON.self)
    }
    
    func show(request: Request, entity: Entity) throws -> ResponseRepresentable {
        return entity
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        var newEntity = try request.entity()
        try newEntity.save()
        return newEntity
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Entity> {
        return Resource(
            index: index,
            store: store,
            show: show
        )
    }
}

extension Request {
    func entity() throws -> Entity {
        guard let json = json else { throw Abort.badRequest }
        return try Entity(node: json)
    }
}
