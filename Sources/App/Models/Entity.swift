import Vapor
import Fluent
import Foundation

struct Entity: Model{
    var id: Node?
    
    let apiId: Node
    
    let name: String
    let content: String
    
    let createdAt: String
    var updatedAt: String?
    
    init(name: String, content: String, apiId: Node){
        self.name = name
        self.content = content
        self.createdAt = String(describing: Date())
        self.apiId = apiId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        apiId = try node.extract("api_id")
        name = try node.extract("name")
        content = try node.extract("content")
        createdAt = try node.extract("created_at")
        updatedAt = try node.extract("updated_at")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "api_id": apiId,
            "name": name,
            "content": content,
            "created_at": createdAt,
            "updated_at": updatedAt
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("entities"){ entities in
            entities.id()
            entities.int("api_id")
            entities.string("name")
            entities.string("content", length: 10000)
            entities.string("created_at")
            entities.string("updated_at", optional: true)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("entities")
    }
}
