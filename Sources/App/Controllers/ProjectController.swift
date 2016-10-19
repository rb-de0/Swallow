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
    
    func show(request: Request, project: Project) throws -> ResponseRepresentable {
        return project
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        var newProject = try request.project()
        try newProject.save()
        return newProject
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index,
            store: store,
            show: show
        )
    }
}

extension Request {
    func project() throws -> Project {
        guard let json = json else { throw Abort.badRequest }
        return try Project(node: json)
    }
}
