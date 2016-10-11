import Vapor
import HTTP

final class ApiController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Api.all().makeNode().converted(to: JSON.self)
    }
    
    func show(request: Request, api: Api) throws -> ResponseRepresentable {
        return api
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Api> {
        return Resource(
            index: index,
            show: show
        )
    }
}
