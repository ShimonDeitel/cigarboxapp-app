import XCTest
@testable import Cigarbox

@MainActor
final class CigarboxTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
    }

    func testSeedDataStaysUnderFreeLimit() {
        XCTAssertLessThan(Store.seedData.count, Store.freeLimit)
    }

    func testAddItem() {
        store.add(name: "Test Cigar", brand: "Padron", purchaseDate: "2025-11-02")
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "Test Cigar")
    }

    func testCanAddBelowLimit() {
        XCTAssertTrue(store.canAdd())
    }

    func testFreeLimitBlocksAdd() {
        for i in 0..<Store.freeLimit {
            store.add(name: "Item \(i)", brand: "Padron", purchaseDate: "2025-11-02")
        }
        XCTAssertFalse(store.canAdd())
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(name: "Item \(i)", brand: "Padron", purchaseDate: "2025-11-02")
        }
        XCTAssertTrue(store.canAdd())
    }

    func testDeleteItem() {
        store.add(name: "ToDelete", brand: "Padron", purchaseDate: "2025-11-02")
        let item = store.items[0]
        store.delete(item)
        XCTAssertEqual(store.items.count, 0)
    }

    func testUpdateItem() {
        store.add(name: "Original", brand: "Padron", purchaseDate: "2025-11-02")
        var item = store.items[0]
        item.name = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.name, "Updated")
    }

    func testDeleteAtOffsets() {
        store.add(name: "A", brand: "Padron", purchaseDate: "2025-11-02")
        store.add(name: "B", brand: "Padron", purchaseDate: "2025-11-02")
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.name, "B")
    }
}
