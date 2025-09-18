import Foundation

struct FlightsResponse: Codable {
    let total: Int?
    let data: [Flight]
    let sortDuration: Double?
    let algorithm: String?
}

final class FlightsService {
    private let baseURL = URL(string: "http://127.0.0.1:4000")!

    private var decoder: JSONDecoder {
        let d = JSONDecoder()
        // Prefer ISO8601 with fractional seconds, fall back to standard ISO8601
        let iso8601WithFractional = ISO8601DateFormatter()
        iso8601WithFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso8601 = ISO8601DateFormatter()

        d.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            if let date = iso8601WithFractional.date(from: string) {
                return date
            }
            if let date = iso8601.date(from: string) {
                return date
            }
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Invalid ISO8601 date: \(string)")
            )
        }
        // Keep keys as-is; if backend uses camelCase and you switch Swift to camelCase, consider .convertFromSnakeCase
        d.keyDecodingStrategy = .useDefaultKeys
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
        do {
            let wrapper = try decoder.decode(FlightsResponse.self, from: data)
            return wrapper.data
        } catch {
            #if DEBUG
            if let raw = String(data: data, encoding: .utf8) {
                print("[FlightsService] Decode failed. Raw response:\n\(raw)")
            }
            if let decodingError = error as? DecodingError {
                print("[FlightsService] DecodingError: \(decodingError)")
            } else {
                print("[FlightsService] Error: \(error.localizedDescription)")
            }
            #endif
            throw error
        }
    }
}
