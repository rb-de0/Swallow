import Vapor
import HTTP

final class ApiRegisterController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let id = request.parameters["projectId"] else{
            return Response(status: .badRequest)
        }

        return try Renderer()
            .addProjects(selectedId: id)
            .addProject(from: request)
            .beSecure(with: request, using: drop)
            .make(view: "add-api", using: drop)
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}
