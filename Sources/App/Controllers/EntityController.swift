import Vapor
import HTTP
import Fluent

final class EntityController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let id = request.parameters["id"], let api = try Api.find(id) else{
            return "hoge"
        }
        
        let project = try api.parent(api.projectId) as Parent<Project>
        
        guard let projectId = try project.get()?.id else{
            return "hoge"
        }
        
        let entities = try api.children("id", Entity.self).all().makeNode()
        
        return try drop.view.make("entities", Node([
            "projectId": projectId,
            "apiId": id,
            "apiName": Node(api.name),
            "entities": entities
        ]))
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
