import Vapor
import Fluent
import Foundation

struct Api: Model{
    var id: Node?
    
    let projectId: Node
    let name: String
    let path: String
    
    init(name: String, path: String, projectId: Node){
        self.name = name
        self.path = path
        self.projectId = projectId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        path = try node.extract("path")
        projectId = try node.extract("project_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "path": path,
            "project_id": projectId
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("apis"){ projects in
            projects.id()
            projects.int("project_id")
            projects.string("name")
            projects.string("path")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("apis")
    }
}
