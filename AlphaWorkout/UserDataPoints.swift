import SwiftUI
import Charts

struct WorkoutPoint: Identifiable, Decodable {
    let id = UUID()
    let date: Date
    let points: Double

    private enum CodingKeys: String, CodingKey {
        case date
        case points
    }
}

extension JSONDecoder {
    static func withDateFormat() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Match your JSON date format
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}

extension Date {
    func shortString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: self)
    }
}

class WorkoutDataLoader: ObservableObject {
    @Published var data: [WorkoutPoint] = []

    init() {
        loadWorkoutData()
    }

    func loadWorkoutData() {
        guard let url = Bundle.main.url(forResource: "UserData", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder.withDateFormat().decode([WorkoutPoint].self, from: jsonData) else {
            print("❌ Failed to load UserData.json")
            return
        }
        self.data = decoded.sorted { (a: WorkoutPoint, b: WorkoutPoint) in
            a.date < b.date
        }
    }
}


struct LineChart: View {
    var data: [WorkoutPoint]

    var body: some View {
        GeometryReader { geometry in
            let maxY = data.map { $0.points }.max() ?? 1
            let width = geometry.size.width
            let height = geometry.size.height
            let spacing = width / CGFloat(data.count - 1)

            Path { path in
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) * spacing
                    let y = height - (CGFloat(point.points) / CGFloat(maxY) * height)

                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)

            ForEach(data.indices, id: \.self) { index in
                let point = data[index]
                let x = CGFloat(index) * spacing
                let y = height - (CGFloat(point.points) / CGFloat(maxY) * height)

                Text(point.date.shortString())
                    .font(.caption2)
                    .position(x: x, y: height + 10)

                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
                    .position(x: x, y: y)
            }
        }
        .frame(height: 200)
        .padding()
    }
}

enum ChartType {
    case points, volume, reps
}

struct UserDataPoints: View {
    @State private var chartType: ChartType = .points

    @StateObject private var pointsLoader = WorkoutDataLoader()
    @StateObject private var volumeLoader = VolumeDataLoader()
    @StateObject private var repsLoader = RepsDataLoader()

    var body: some View {
        VStack {
            Text("All-Time Workout Data")
                .font(.headline)

            HStack {
                Button("Points") {
                    chartType = .points
                }.buttonStyle(FilterButtonStyle(selected: chartType == .points))

                Button("Volume") {
                    chartType = .volume
                }.buttonStyle(FilterButtonStyle(selected: chartType == .volume))

                Button("Reps") {
                    chartType = .reps
                }.buttonStyle(FilterButtonStyle(selected: chartType == .reps))
            }

            switch chartType {
            case .points:
                if pointsLoader.data.isEmpty {
                    Text("No data found.").foregroundColor(.gray)
                } else {
                    LineChart(data: pointsLoader.data)
                }
            case .volume:
                if volumeLoader.data.isEmpty {
                    Text("No data found.").foregroundColor(.gray)
                } else {
                    VolumeBarChart(data: volumeLoader.data)
                }
            case .reps:
                if repsLoader.data.isEmpty {
                    Text("No data found.").foregroundColor(.gray)
                } else {
                    RepsBarChart(data: repsLoader.data)
                }
            }
        }
        .padding()
    }
}


struct VolumeDataPoint: Identifiable, Decodable {
    let id = UUID()
    let date: Date
    let volume: Int
}

struct RepsDataPoint: Identifiable, Decodable {
    let id = UUID()
    let date: Date
    let reps: Int
}

struct VolumeBarChart: View {
    let data: [VolumeDataPoint]

    var body: some View {
        Chart(data) { point in
            BarMark(
                x: .value("Date", point.date.shortString()),
                y: .value("Volume", point.volume)
            )
        }
        .frame(height: 200)
        .padding()
    }
}

struct RepsBarChart: View {
    let data: [RepsDataPoint]

    var body: some View {
        Chart(data) { point in
            BarMark(
                x: .value("Date", point.date.shortString()),
                y: .value("Reps", point.reps)
            )
        }
        .frame(height: 200)
        .padding()
    }
}

class VolumeDataLoader: ObservableObject {
    @Published var data: [VolumeDataPoint] = []

    init() {
        load()
    }

    func load() {
        guard let url = Bundle.main.url(forResource: "UserVolume", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder.withDateFormat().decode([VolumeDataPoint].self, from: jsonData) else {
            print("❌ Failed to load UserVolume.json")
            return
        }
        self.data = decoded.sorted { $0.date < $1.date }
    }
}

class RepsDataLoader: ObservableObject {
    @Published var data: [RepsDataPoint] = []

    init() {
        load()
    }

    func load() {
        guard let url = Bundle.main.url(forResource: "UserReps", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder.withDateFormat().decode([RepsDataPoint].self, from: jsonData) else {
            print("❌ Failed to load UserReps.json")
            return
        }
        self.data = decoded.sorted { $0.date < $1.date }
    }
}


#Preview {
    UserDataPoints()
}
