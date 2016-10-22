import Foundation

import Vapor
import HTTP
import Node

class CsrfHelper{
    
    class func getAuthenticityToken(with request: Request, using drop: Droplet) -> Node?{
        
        try! request.session().data["start"] = ""
        
        guard let session = try? request.session(), let identifier = session.identifier else{
            return nil
        }
        
        guard let token = try? drop.hash.make(identifier) else{
            return nil
        }
        
        session.data["authenticity_token"] = Node(token)
        
        return Node(token)
        
    }
    
    class func verifyAuthenticityToken(with request: Request) throws {
        let session = try request.session()
        
        guard let sessionToken = session.data["authenticity_token"]?.string, let requestToken = request.data["authenticity_token"]?.string else{
            throw NSError(domain: "Invalud Request", code: -1, userInfo: nil)
        }
        
        if sessionToken != requestToken {
            throw NSError(domain: "Invalud Request", code: -1, userInfo: nil)
        }
    }
}
