//
//  ContentView.swift
//  whereto
//
//  Created by Ramael Cerqueira on 2025/9/17.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = FlightsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                queryControls
                content
            }
            .padding()
            .navigationTitle("Flights")
            .toolbar {
                Button {
                    Task { await vm.load() }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            .task { await vm.load() }
        }
    }

    private var queryControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("Origem", text: $vm.origem)
                    .textFieldStyle(.roundedBorder)
                TextField("Destino", text: $vm.destino)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Picker("Sort", selection: $vm.sortBy) {
                    Text("Preço").tag("preco")
                    Text("Partida").tag("partida")
                    Text("Duração").tag("duracao")
                }
                .pickerStyle(.menu)
                Picker("Order", selection: $vm.order) {
                    Text("Asc").tag("asc")
                    Text("Desc").tag("desc")
                }
                .pickerStyle(.segmented)
                Picker("Alg", selection: $vm.algorithm) {
                    Text("QuickSort").tag("quicksort")
                    Text("BubbleSort").tag("bubblesort")
                }
                .pickerStyle(.menu)
                Button("Buscar") {
                    Task { await vm.load() }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var content: some View {
        Group {
            if vm.isLoading {
                ProgressView("Carregando...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let msg = vm.errorMessage {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                    Text(msg).foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.flights.isEmpty {
                ContentUnavailableView("Sem resultados", systemImage: "airplane", description: Text("Ajuste os filtros e tente novamente."))
            } else {
                List(vm.flights, id: \.self) { flight in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(flight.origem) → \(flight.destino)")
                            .font(.headline)
                        // preco is a String in backend; format safely
                        if let price = Double(flight.preco) {
                            Text("Preço: \(price, format: .number.precision(.fractionLength(2)))")
                        } else {
                            Text("Preço: \(flight.preco)")
                        }
                        Text("Partida: \(flight.data_ida.formatted())")
                        Text("Duração: \(flight.duracao_min) min")
                        Text("Companhia: \(flight.companhia)")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
