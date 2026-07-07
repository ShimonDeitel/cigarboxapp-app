import Foundation

struct CigarItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var brand: String
    var purchaseDate: String
    var notes: String = ""
    var dateAdded: Date = Date()
}
