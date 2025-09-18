import Foundation

final class FlightsService {
    private let baseURL = URL(string: "http://localhost:4000")!

    private var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    func health() async throws -> [String: String] {
        let url = baseURL.appendingPathComponent("health")
        let (data, _) = try await URLSession.shared.data(from: url)
        let obj = try JSONSerialization.jsonObject(with: data) as? [String: String]
        return obj ?? [:]
    }

    func listFlights(origem: String?, destino: String?, sortBy: String?, order: String?, page: Int?, pageSize: Int?, algorithm: String?) async throws -> [Flight] {
        var components = URLComponents(url: baseURL.appendingPathComponent("flights"), resolvingAgainstBaseURL: false)!
        var items: [URLQueryItem] = []
        if let origem { items.append(URLQueryItem(name: "origem", value: origem)) }
        if let destino { items.append(URLQueryItem(name: "destino", value: destino)) }
        if let sortBy { items.append(URLQueryItem(name: "sortBy", value: sortBy)) }
        if let order { items.append(URLQueryItem(name: "order", value: order)) }
        if let page { items.append(URLQueryItem(name: "page", value: String(page))) }
        if let pageSize { items.append(URLQueryItem(name: "pageSize", value: String(pageSize))) }
        if let algorithm { items.append(URLQueryItem(name: "algorithm", value: algorithm)) }
        components.queryItems = items

        let url = components.url!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode([Flight].self, from: data)
    }
}
