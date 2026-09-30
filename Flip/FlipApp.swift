import SwiftUI

@main
struct FlipApp: App {

    @StateObject private var store = DeckStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DecksView(store: store)
            }
        }
    }
}
