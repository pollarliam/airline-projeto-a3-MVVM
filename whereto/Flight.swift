import Foundation

struct Flight: Codable, Identifiable, Hashable {
    let id: Int
    let origem: String
    let destino: String
    let data_ida: Date
    let companhia: String
    let preco: String
    let duracao_min: Int
}
