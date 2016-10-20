import Vapor
import Fluent
import Foundation

struct Project: Model{
    var id: Node?
    let name: String
    
    // TODO: remove
    var exists: Bool = false
    
    init(name: String){
        self.name = name
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("projects"){ projects in
            projects.id()
            projects.string("name")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("projects")
    }
}

extension Project{
    init(data: Content) throws {
        guard let name = data["name"]?.string else{
            throw NSError(domain: "parseError", code: -1, userInfo: nil)
        }
        
        self.init(name: name)
    }
}
