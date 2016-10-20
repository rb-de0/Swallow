import Vapor
import HTTP
import Fluent

final class EntityRegisterController: Controller {
    
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
                  with: ["projectId": projectId, "apiId": apiId],
                  using: drop)
    }

    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}
