import Vapor
import HTTP
import Fluent

final class EntityDownloadController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        guard let entityId = request.parameters["entityId"], let entity = try Entity.find(entityId) else{
            return Response(status: .badRequest)
        }
        
        return Response(headers:
            [
                "Content-Type": "application/force-download",
                "Content-Disposition": "attachment; filename=\(request.uri.path).json"
            ], body: entity.content.toBytes())
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Project> {
        return Resource(
            index: index
        )
    }
}
