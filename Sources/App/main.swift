import Vapor
import VaporMySQL

let drop = Droplet(preparations:[Project.self, Api.self, Entity.self], providers: [VaporMySQL.Provider.self])

drop.resource("", ProjectController(drop: drop))

drop.resource("projects", ProjectController(drop: drop))

drop.resource("projects/:id/apis", ApiController(drop: drop))

drop.resource("projects/:id/apis/register", ApiRegisterController(drop: drop))

drop.resource("projects/:id/apis/:id/entities", EntityController(drop: drop))

drop.resource("projects/:id/apis/:id/entities/register", EntityRegisterController(drop: drop))

drop.run()
