import Vapor

class ListRenderer {
    
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
    
    func addApis(in project: Project) throws -> Self{
        let apis = try project.children("project_id", Api.self).all().makeNode()
        context.updateValue(apis, forKey: "apis")
        return self
    }
    
    func addEntities(in api: Api) throws -> Self{
        let entities = try api.children("api_id", Entity.self).all().makeNode()
        context.updateValue(entities, forKey: "entities")
        return self
    }
    
    func make(view path: String, with context: [String: Node] = [:], using drop: Droplet) throws -> View {
        
        for (key, value) in context{
            self.context.updateValue(value, forKey: key)
        }
        
        return try drop.view.make(path, Node(self.context))
    }
}
