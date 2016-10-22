import Leaf

class Empty: BasicTag{
    
    let name = "empty"
    
    func run(arguments: [Argument]) throws -> Node? {
        
        if arguments.contains(where: {$0.value == nil}){
            return Node(false)
        }
        
        return nil
    }
}
