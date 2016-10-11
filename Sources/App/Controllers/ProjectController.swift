import Vapor
import HTTP

final class ProjectController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Project.all().makeNode().converted(to: JSON.self)
    }
    
    func show(request: Request, project: Project) throws -> ResponseRepresentable {
        return project
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index,
            show: show
        )
    }
}
