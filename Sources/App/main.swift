import Vapor
import VaporMySQL

let drop = Droplet()

drop.addProvider(try VaporMySQL.Provider(config: drop.config))

drop.preparations = [Project.self, Api.self, Entity.self]

drop.resource("", ProjectController(drop: drop))

drop.resource("projects", ProjectController(drop: drop))

drop.resource("projects/:projectId/apis", ApiController(drop: drop))

drop.resource("projects/:projectId/apis/register", ApiRegisterController(drop: drop))

drop.resource("projects/:projectId/apis/:apiId/entities", EntityController(drop: drop))

drop.resource("projects/:projectId/apis/:apiId/entities/register", EntityRegisterController(drop: drop))

drop.resource("get/projects/:projectId/apis/:apiId/entities/:entityId", EntityProvideController(drop: drop))

drop.resource("get/projects/:projectId/apis/:apiId/entities", EntityProvideController(drop: drop))

drop.resource("download/projects/:projectId/apis/:apiId/entities/:entityId", EntityDownloadController(drop: drop))

(drop.view as? LeafRenderer)?.stem.register(Empty())

drop.run()
