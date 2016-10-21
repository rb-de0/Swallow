import Vapor
import HTTP
import Fluent

import Foundation

final class EntityController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let apiId = request.parameters["apiId"], let api = try Api.find(apiId), let projectId = request.parameters["projectId"] else{
            return Response(status: .badRequest)
        }
        
        return try ListRenderer()
            .addEntities(in: api)
            .make(view: "entities",
                  with: ["projectId": projectId, "apiId": apiId, "apiName": Node(api.name)],
                  using: drop)

    }
    
    func show(request: Request, entity: Entity) throws -> ResponseRepresentable {
        
        guard let api = try Api.find(entity.apiId), let projectId = request.parameters["projectId"] else{
            return Response(status: .badRequest)
        }
        
        return try ListRenderer()
            .addEntities(in: api)
            .make(view: "entity",
                  with: ["projectId": projectId,
                         "apiId": entity.apiId,
                         "apiName": Node(api.name),
                         "content": Node(entity.content),
                         "name": Node(entity.name),
                         "id": entity.id!],
                  using: drop)
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        if request.data["_method"]?.string == "patch", let entityId = request.data["id"]?.string, let entity = try Entity.find(entityId) {
            return try update(request: request, entity: entity)
        }
        
        guard let apiId = request.parameters["apiId"] else{
            return Response(status: .badRequest)
        }
        
        var newEntity = try Entity(id: Node(apiId), data: request.data)
        try newEntity.save()
        
        return Response(redirect: request.uri.path)
    }
    
    func update(request: Request, entity: Entity) throws -> ResponseRepresentable {
        
        let modified = try Entity(id: entity.apiId, data: request.data)
        
        var copy = entity
        copy.content = modified.content
        copy.name = modified.name
        copy.updatedAt = String(describing: Date())
        
        try copy.save()
        
        return Response(redirect: request.uri.path + "/\(entity.id!.string!)")
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
