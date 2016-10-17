import Vapor
import HTTP

final class ApiController: Controller {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("apis")
        //return try Api.all().makeNode().converted(to: JSON.self)
    }
    
    func show(request: Request, api: Api) throws -> ResponseRepresentable {
        return api
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        var newApi = try request.api()
        try newApi.save()
        return newApi
    }
    
    // MARK: - ResourceRepresentable
    func makeResource() -> Resource<Api> {
        return Resource(
            index: index,
            store: store,
            show: show
        )
    }
}

extension Request {
    func api() throws -> Api {
        guard let json = json else { throw Abort.badRequest }
        return try Api(node: json)
    }
}
