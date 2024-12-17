import SwiftUI
import AVFoundation
import PhotosUI
import MapKit
import CoreLocation

// LocationManager: Manages the user's location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion
    
    override init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default location
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

// DatabaseHelper: A class that interacts with the database
class DatabaseHelper {
    // Simulate inserting a defect into a database
    func insertDefect(title: String, description: String, category: String, imagePath: String, latitude: Double, longitude: Double) {
        // Implement actual database insertion logic here
        print("Defect inserted: \(title), \(category), \(latitude), \(longitude)")
    }
    
    // Simulate fetching defects from the database
    func fetchDefects() -> [(id: Int, title: String, description: String, category: String, imagePath: String, latitude: Double, longitude: Double)] {
        // Replace this with actual fetching logic
        return []
    }
}

// ImagePicker: Allows the user to pick an image from the photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

// CameraPicker: Zorgt ervoor dat mensen foto's kunnen maken met hun camera
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// RegistrationView: View voor registratie
struct RegistrationView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var defectName: String = ""
    @State private var defectDescription: String = ""
    @State private var selectedCategory: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var isCameraAuthorized = false

    let categories = ["Grondkabels", "Hoogspanning", "Schakelkasten", "Luchtkabels"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Defect Registreren")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                TextField("Defectnaam", text: $defectName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)

                TextEditor(text: $defectDescription)
                    .frame(height: 100)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 1))
                    .autocapitalization(.sentences)
                    .disableAutocorrection(false)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Categorie")
                        .font(.headline)
                    Picker("Selecteer een categorie", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Afbeelding toevoegen")
                        .font(.headline)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    } else {
                        HStack {
                            Button(action: {
                                checkCameraPermission()
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("Camera gebruiken")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            Button(action: {
                                showImagePicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text("Afbeelding selecteren")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                .sheet(isPresented: $showCameraPicker) {
                    CameraPicker(selectedImage: $selectedImage)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Locatie van defect")
                        .font(.headline)

                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                        .frame(height: 200)
                        .cornerRadius(10)
                }

                Spacer()

                Button(action: {
                    registerDefect()
                }) {
                    Text("Defect Opslaan")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    // Defect registreren
    private func registerDefect() {
        let dbHelper = DatabaseHelper()
        let imagePath = saveImageToDocuments(selectedImage)
        let latitude = locationManager.userLocation?.latitude ?? 0.0
        let longitude = locationManager.userLocation?.longitude ?? 0.0
        
        dbHelper.insertDefect(
            title: defectName,
            description: defectDescription,
            category: selectedCategory,
            imagePath: imagePath,
            latitude: latitude,
            longitude: longitude
        )
        print("Defect registered successfully")
    }
    // Sla image/foto op
    private func saveImageToDocuments(_ image: UIImage?) -> String {
        guard let data = image?.jpegData(compressionQuality: 0.8) else { return "" }
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        try? data.write(to: fileURL)
        return fileURL.path
    }

    private func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { response in
            DispatchQueue.main.async {
                self.isCameraAuthorized = response
                if self.isCameraAuthorized {
                    self.showCameraPicker.toggle()
                } else {
                    // Handle camera access denial
                    print("Camera access denied")
                }
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.dismissKeyboard()
    }
}

// Functie zodat je uit het toetsenbord kan
extension UIApplication {
    func dismissKeyboard() {
        windows.filter {$0.isKeyWindow}.first?.endEditing(true)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
