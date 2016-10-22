import Vapor
import HTTP

class Renderer {
    
    private var context = [String: Node]()
    
    func addProjects(selectedId: Node = Node(-1)) throws -> Self{
        
        let projects = try Project.all().map{(project: Project) -> Project in
            var adjusted = project
            
            if adjusted.id?.int == selectedId.int{
                adjusted.isSelected = true
            }
            
            return adjusted
        }.flatMap{try? $0.makeNode()}
        
        context.updateValue(Node(projects), forKey: "projects")
        return self
    }
    
    func addProject(from request: Request) throws -> Self{
        guard let projectId = request.parameters["projectId"], let projectName = try Project.find(projectId)?.name else{
            return self
        }
        
        context.updateValue(projectId, forKey: "projectId")
        context.updateValue(Node(projectName), forKey: "projectName")
        
        return self
    }
    
    func addApi(from request: Request) throws -> Self{
        guard let apiId = request.parameters["apiId"], let apiName = try Api.find(apiId)?.name else{
            return self
        }
        
        context.updateValue(apiId, forKey: "apiId")
        context.updateValue(Node(apiName), forKey: "apiName")
        
        return self
    }
    
    func addApis(in project: Project) throws -> Self{
        let apis = try project.children("project_id", Api.self).all().makeNode()
        context.updateValue(apis, forKey: "apis")
        return self
    }
    
    func addEntities(in api: Api, selectedId: Node = Node(-1)) throws -> Self{
        let entities = try api.children("api_id", Entity.self).all().map{(entity: Entity) -> Entity in
            var adjusted = entity
            
            if adjusted.id?.int == selectedId.int{
                adjusted.isSelected = true
            }
            
            return adjusted
        }.flatMap{try? $0.makeNode()}
        
        context.updateValue(Node(entities), forKey: "entities")
        return self
    }
    
    func beSecure(with request: Request, using drop: Droplet)-> Self{
        if let token = CsrfHelper.getAuthenticityToken(with: request, using: drop){
            print(token)
            context.updateValue(token, forKey: "authenticity_token")
        }
        
        return self
    }
    
    func make(view path: String, with context: [String: Node] = [:], using drop: Droplet) throws -> View {
        
        for (key, value) in context{
            self.context.updateValue(value, forKey: key)
        }
        
        return try drop.view.make(path, Node(self.context))
    }
}
