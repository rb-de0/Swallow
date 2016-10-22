import Vapor
import Fluent
import Foundation

struct Entity: Model{
    var id: Node?
    
    let apiId: Node
    
    var name: String
    var content: String
    
    let createdAt: String
    var updatedAt: String?
    
    var isSelected = false
    
    // TODO: remove
    var exists: Bool = false
    
    public static var entity: String {
        return "entities"
    }
    
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
    
    func makeNode() throws -> Node {
        return try Node(node: [
            "id": id,
            "api_id": apiId,
            "name": name,
            "content": content,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "selected": isSelected
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

extension Entity{
    init(id: Node, data: Content) throws {
        guard let name = data["name"]?.string, let content = data["content"]?.string else{
            throw NSError(domain: "parseError", code: -1, userInfo: nil)
        }
        
        self.init(name: name, content: content, apiId: id)
    }
}
