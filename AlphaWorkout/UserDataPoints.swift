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

struct UserDataPoints: View {
    @StateObject private var loader = WorkoutDataLoader()

    var body: some View {
        VStack {
            Text("All-Time Workout Points")
                .font(.headline)
            if loader.data.isEmpty {
                Text("No data found.")
                    .foregroundColor(.gray)
            } else {
                LineChart(data: loader.data)
            }
        }
        .padding()
    }
}


#Preview {
    UserDataPoints()
}
