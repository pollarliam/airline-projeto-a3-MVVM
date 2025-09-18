import Foundation

struct Flight: Codable, Identifiable, Hashable {
    let id: Int
    let origem: String
    let destino: String
    let partida: Date
    let chegada: Date
    let preco: Double
    let duracao_minutos: Int
}
