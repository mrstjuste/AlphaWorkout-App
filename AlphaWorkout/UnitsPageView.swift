import SwiftUI

struct UnitsPageView: View {
    @State private var selectedSystem: UnitSystem = .metric
    @State private var selectedWeightUnit: WeightUnit = .kilograms
    @State private var selectedDistanceUnit: DistanceUnit = .meters
    @State private var selectedBodyMeasurementUnit: BodyMeasurementUnit = .centimeters
    
    @State private var navigateToHome = false  // Controls navigation
    
    var body: some View {
        VStack {
            // Title
            Text("Select Units")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            // System Selection Picker
            Picker("Unit System", selection: $selectedSystem) {
                ForEach(UnitSystem.allCases, id: \.self) { system in
                    Text(system.rawValue.capitalized).tag(system)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Form with Unit Options
            Form {
                Section(header: Text("Weight Units")) {
                    Picker("Weight", selection: $selectedWeightUnit) {
                        ForEach(selectedSystem == .metric ? WeightUnit.metricUnits : WeightUnit.imperialUnits, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Distance Units")) {
                    Picker("Distance", selection: $selectedDistanceUnit) {
                        ForEach(selectedSystem == .metric ? DistanceUnit.metricUnits : DistanceUnit.imperialUnits, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Body Measurements")) {
                    Picker("Measurements", selection: $selectedBodyMeasurementUnit) {
                        ForEach(selectedSystem == .metric ? BodyMeasurementUnit.metricUnits : BodyMeasurementUnit.imperialUnits, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            // Continue Button
            NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                Button(action: {
                    navigateToHome = true
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 220)
        }
        .navigationBarHidden(true) // Hides back button
    }
}


// Enums for different unit categories
enum UnitSystem: String, CaseIterable {
    case metric = "Metric"
    case imperial = "Imperial"
}

enum WeightUnit: String, CaseIterable {
    case kilograms = "Kilograms"
    case pounds = "Pounds"
    
    static var metricUnits: [WeightUnit] { [.kilograms] }
    static var imperialUnits: [WeightUnit] { [.pounds] }
}

enum DistanceUnit: String, CaseIterable {
    case meters = "Meters"
    case kilometers = "Kilometers"
    case feet = "Feet"
    case miles = "Miles"
    
    static var metricUnits: [DistanceUnit] { [.meters, .kilometers] }
    static var imperialUnits: [DistanceUnit] { [.feet, .miles] }
}

enum BodyMeasurementUnit: String, CaseIterable {
    case centimeters = "Centimeters"
    case inches = "Inches"
    
    static var metricUnits: [BodyMeasurementUnit] { [.centimeters] }
    static var imperialUnits: [BodyMeasurementUnit] { [.inches] }
}

// Preview for SwiftUI Canvas
struct UnitsPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UnitsPageView()
        }
    }
}
