import Combine
import SwiftUI

class CircularImageViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var image: UIImage?

    private var dataSource: ImageDataSource?
    private var cancellables = Set<AnyCancellable>()

    init(with coinMetadata: Binding<[Int: Metadata]>) {
        _ = coinMetadata.wrappedValue.map { _ in
            self.dataSource = ImageDataSource(coinMetadata: coinMetadata)
            self.addSubscribers()
        }
    }

    private func addSubscribers() {
        dataSource?.$coinLogo
            .handleEvents(receiveSubscription: { [weak self] _ in
                 self?.isLoading = true
             }, receiveCompletion: { [weak self] _ in
                 self?.isLoading = false
             })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] logo in
                guard let self else { return }
                self.image = logo
            }
            .store(in: &cancellables)
    }

    func getImage(for coin: Coin) async {
        do {
            let newImage = try await dataSource?.getImage(for: coin)
            await MainActor.run {
                     self.image = newImage
                 }
        } catch(let error) {
            print("NO SE NI QUE HAGO")
        }
    }

}
