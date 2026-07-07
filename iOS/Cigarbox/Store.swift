import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [CigarItem] = []
    @Published var categoriesEnabled: Bool = true
    @Published var isPro: Bool = false

    /// Free tier item cap. Seed data below always stays under this so a fresh
    /// install never trips the paywall immediately.
    static let freeLimit = 20

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("cigarbox_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = Store.seedData
            save()
        }
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= Store.freeLimit
    }

    func canAdd() -> Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(name: String, brand: String, purchaseDate: String, notes: String = "") {
        guard canAdd() else { return }
        let item = CigarItem(name: name, brand: brand, purchaseDate: purchaseDate, notes: notes)
        items.append(item)
        save()
    }

    func update(_ item: CigarItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: CigarItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([CigarItem].self, from: data) else { return }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static let seedData: [CigarItem] = [
        CigarItem(name: "Sample Cigar 1", brand: "Padron", purchaseDate: "2025-11-02"),
        CigarItem(name: "Sample Cigar 2", brand: "Padron", purchaseDate: "2025-11-02"),
        CigarItem(name: "Sample Cigar 3", brand: "Padron", purchaseDate: "2025-11-02")
    ]
}
