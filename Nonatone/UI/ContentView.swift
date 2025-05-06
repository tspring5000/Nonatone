import SwiftUI

struct ContentView: View {
    var conductor = Conductor()
    
    var body: some View {
        MainView(conductor: conductor)
            .onAppear() {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear() {
                UIApplication.shared.isIdleTimerDisabled = false
            }
    }
}

#Preview {
    ContentView()
}
