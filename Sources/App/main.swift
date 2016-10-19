import Vapor
import VaporMySQL

let drop = Droplet(preparations:[Project.self, Api.self, Entity.self], providers: [VaporMySQL.Provider.self])

drop.resource("posts", PostController())

drop.resource("", ProjectController(drop: drop))

drop.resource("projects", ProjectController(drop: drop))

drop.resource("projects/:id/apis", ApiController(drop: drop))

drop.resource("projects/:id/apis/:id/entities", EntityController(drop: drop))

drop.run()
