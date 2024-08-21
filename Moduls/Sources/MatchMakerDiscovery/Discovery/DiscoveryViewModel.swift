import Foundation
import Swinject

public class DiscoveryViewModel {
    
    private let repository: DiscoveryRepository
    var potentailMatches: [User] = []
    
    init(container: Container) {
        repository = container.resolve(DiscoveryRepository.self)!
    }
    
    func fetchPotentialMatches() async throws {
        potentailMatches = try await repository.fetchPotentialMatches()
    }
}
