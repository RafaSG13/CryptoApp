//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Rafael Serrano Gamarra on 4/6/24.
//

import Foundation
import CoreData


class PortfolioDataSource {
    private let container: NSPersistentContainer
    @Published var savedEntities: [Portfolio] = []

    init() {
        self.container = NSPersistentContainer(name: "PortfolioContainer")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading coreData \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }
    
    func updatePortFolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                updateCoin(entity: entity, amount: amount)
            } else { deleteCoin(entity: entity) }
        } else {
            addCoin(coin: coin, amount: amount)
        }
    }
}

// MARK: Private Methods

private extension PortfolioDataSource {
    func getPortfolio() {
            let request = NSFetchRequest<Portfolio>(entityName: "Portfolio")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch(let error) {
            print("Error fetching entities \(error.localizedDescription)")
        }
    }

    func addCoin(coin: Coin, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.coinId = Int64(coin.id)
        entity.amount = amount
        applyChanges()
    }

    func updateCoin(entity: Portfolio, amount: Double) {
        entity.amount = amount
        applyChanges()
    }

    func deleteCoin(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    func save() {
        do {
            try container.viewContext.save()
        } catch(let error ){
            print("Error saving in C  ore Data \(error.localizedDescription)")
        }
    }

    func applyChanges() {
        save()
        getPortfolio()
    }
}
