import Vapor
import HTTP

final class ApiController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let projects = try Project.all().makeNode()
        
        guard let id = request.parameters["id"], let project = try Project.find(id) else{
            return "hoge"
        }
        
        let apis = try project.children("project_id", Api.self).all().makeNode()

        return try drop.view.make("apis", Node([
            "projectId": id,
            "projectName": Node(project.name),
            "apis": apis,
            "projects": projects
        ]))
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        guard let projectId = request.parameters["id"], let project = try Project.find(projectId) else{
            return "hoge"
        }
        
        var newApi = try Api(id: Node(projectId), data: request.data)
        try newApi.save()
        
        let projects = try Project.all().makeNode()
        let apis = try project.children("project_id", Api.self).all().makeNode()
        
        return try drop.view.make("apis", Node([
            "projectId": projectId,
            "projectName": Node(project.name),
            "apis": apis,
            "projects": projects
        ]))
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Api> {
        return Resource(
            index: index,
            store: store
        )
    }
}
