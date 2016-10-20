import Vapor
import HTTP

final class ApiRegisterController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let id = request.parameters["id"] else{
            return Response(status: .badRequest)
        }
        
        return try ListRenderer()
            .addProjects()
            .make(view: "app-api", with: ["projectId": id] , using: drop)
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}
