public protocol Activatable {

    func activate()
    func deactivate()
    var isActive: Bool { get }
}
