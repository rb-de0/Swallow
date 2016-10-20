import Vapor
import HTTP
import Fluent

final class EntityController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let apiId = request.parameters["id"], let api = try Api.find(apiId) else{
            return Response(status: .badRequest)
        }
        
        let project = try api.parent(api.projectId) as Parent<Project>
        
        guard let projectId = try project.get()?.id else{
            return Response(status: .badRequest)
        }
        
        return try ListRenderer()
            .addEntities(in: api)
            .make(view: "entities",
                  with: ["projectId": projectId, "apiId": apiId, "apiName": Node(api.name)],
                  using: drop)

    }
    
    func show(request: Request, entity: Entity) throws -> ResponseRepresentable {
        return entity
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        guard let apiId = request.parameters["id"], let api = try Api.find(apiId) else{
            return Response(status: .badRequest)
        }
        
        var newEntity = try Entity(id: Node(apiId), data: request.data)
        try newEntity.save()
        
        let project = try api.parent(api.projectId) as Parent<Project>
        
        guard let projectId = try project.get()?.id else{
            return Response(status: .badRequest)
        }
        
        return try ListRenderer()
            .addEntities(in: api)
            .make(view: "entities",
                  with: ["projectId": projectId, "apiId": apiId, "apiName": Node(api.name)],
                  using: drop)
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
