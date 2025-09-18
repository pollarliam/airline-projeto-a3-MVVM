import Foundation
import Observation

@MainActor
final class FlightsViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Query parameters
    @Published var origem: String = ""
    @Published var destino: String = ""
    @Published var sortBy: String = "preco"
    @Published var order: String = "asc"
    @Published var algorithm: String = "quicksort"

    private let service = FlightsService()

    func load(page: Int = 1, pageSize: Int = 20) async {
        isLoading = true
        errorMessage = nil
        do {
            let results = try await service.listFlights(
                origem: origem.isEmpty ? nil : origem,
                destino: destino.isEmpty ? nil : destino,
                sortBy: sortBy,
                order: order,
                page: page,
                pageSize: pageSize,
                algorithm: algorithm
            )
            self.flights = results
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
