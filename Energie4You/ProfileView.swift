import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Mijn Profiel")
                .font(.title)
                .bold()
                .padding()

            // Profile details or settings
            Text("User Profile Information goes here.")
                .padding()

            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
