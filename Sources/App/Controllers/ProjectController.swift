import Vapor
import HTTP

final class ProjectController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Renderer()
            .addProjects()
            .beSecure(with: request, using: drop)
            .make(view: "projects", using: drop)
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        try CsrfHelper.verifyAuthenticityToken(with: request)
        
        var newProject = try Project(data: request.data)
        try newProject.save()
        
        return Response(redirect: request.uri.path)
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index,
            store: store
        )
    }
}
