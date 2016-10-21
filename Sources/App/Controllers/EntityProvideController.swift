import Vapor
import HTTP
import Fluent

final class EntityProvideController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        if let entityId = request.parameters["entityId"], let entity = try Entity.find(entityId){
            return entity.content
        }
        
        guard let apiId = request.parameters["apiId"],
            let api = try Api.find(apiId),
            let first = try api.children("api_id", Entity.self).all().first else{
                
            return Response(status: .badRequest)
        }
        
        return first.content
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}
