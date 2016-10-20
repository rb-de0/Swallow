import Vapor
import HTTP

final class ProjectController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let projects = try Project.all().makeNode()
        return try drop.view.make("projects", Node(["projects": projects]))
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        var newProject = try Project(data: request.data)
        try newProject.save()
        
        let projects = try Project.all().makeNode()
        return try drop.view.make("projects", Node(["projects": projects]))
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index,
            store: store
        )
    }
}
