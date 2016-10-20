import Vapor
import HTTP
import Fluent

final class EntityRegisterController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let id = request.parameters["id"], let api = try Api.find(id) else{
            return "hoge"
        }
        
        let project = try api.parent(api.projectId) as Parent<Project>
        
        guard let projectId = try project.get()?.id else{
            return "hoge"
        }
        
        let entities = try api.children("id", Entity.self).all().makeNode()
        
        return try drop.view.make("add-entity", Node([
            "projectId": projectId,
            "apiId": id,
            "entities": entities
        ]))
    }

    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}
