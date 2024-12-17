import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Instellingen")
                .font(.title)
                .bold()
                .padding()

            // Settings options go here
            Text("Settings options like notifications, privacy settings, etc.")
                .padding()

            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
