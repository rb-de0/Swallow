import Vapor
import HTTP

final class ProjectController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try ListRenderer().addProjects().make(view: "projects", using: drop)
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        var newProject = try Project(data: request.data)
        try newProject.save()
        
        return try ListRenderer().addProjects().make(view: "projects", using: drop)
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index,
            store: store
        )
    }
}
