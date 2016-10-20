import Vapor
import HTTP

final class ApiController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let projectId = request.parameters["id"], let project = try Project.find(projectId) else{
            return Response(status: .badRequest)
        }
        
        return try ListRenderer()
            .addProjects(selectedId: projectId)
            .addApis(in: project)
            .make(view: "apis", with: ["projectId": projectId, "projectName": Node(project.name)], using: drop)
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        guard let projectId = request.parameters["id"] else{
            return Response(status: .badRequest)
        }
        
        var newApi = try Api(id: Node(projectId), data: request.data)
        try newApi.save()
        
        return Response(redirect: request.uri.path)
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Api> {
        return Resource(
            index: index,
            store: store
        )
    }
}
