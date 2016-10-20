import Vapor
import HTTP

final class ApiRegisterController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let projects = try Project.all().makeNode()
        
        guard let id = request.parameters["id"] else{
            return "hoge"
        }
        
        return try drop.view.make("add-api", Node([
            "projectId": id,
            "projects": projects
        ]))
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}