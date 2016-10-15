import Vapor
import HTTP

final class ProjectController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Project.all().makeNode().converted(to: JSON.self)
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
