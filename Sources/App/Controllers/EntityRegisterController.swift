import Vapor
import HTTP
import Fluent

final class EntityRegisterController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let apiId = request.parameters["apiId"], let api = try Api.find(apiId) else{
            return Response(status: .badRequest)
        }
        
        return try Renderer()
            .addEntities(in: api)
            .addProject(from: request)
            .addApi(from: request)
            .beSecure(with: request, using: drop)
            .make(view: "add-entity",
                  using: drop)
    }

    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}
