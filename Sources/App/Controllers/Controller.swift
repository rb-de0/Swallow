import Vapor

protocol Controller: ResourceRepresentable{
    init(drop: Droplet)
}
