import Foundation
import Swinject

public class DiscoveryViewModel {
    
    var potentailMatches: [User] = []
    
    init(container: Container) {
        
    }
    
    func fetchPotentialMatches() async throws {
        potentailMatches = mockUsers
    }
}
