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
        
        let entities = try api.children("api_id", Entity.self).all().makeNode()
        
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
        
        guard let apiId = request.parameters["id"], let api = try Api.find(apiId) else{
            return "hoge"
        }
        
        var newEntity = try Entity(id: Node(apiId), data: request.data)
        try newEntity.save()
        
        let project = try api.parent(api.projectId) as Parent<Project>
        
        guard let projectId = try project.get()?.id else{
            return "hoge"
        }
        
        let entities = try api.children("api_id", Entity.self).all().makeNode()
        
        return try drop.view.make("entities", Node([
            "projectId": projectId,
            "apiId": apiId,
            "apiName": Node(api.name),
            "entities": entities
        ]))
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
