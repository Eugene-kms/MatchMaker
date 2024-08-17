import Foundation
import Swinject

class MatchesViewModel {
    var matches: [User] = []
    
    init(container: Container) {}
    
    func fetchMAtches() async throws {
        matches = mockUsers
    }
}
