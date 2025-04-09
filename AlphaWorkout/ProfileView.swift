import SwiftUI
import Charts

struct ProfileView: View {
    let username = "Brian St. Juste"
    @State private var height = "6'0\""
    @State private var weight = "185 lbs"
    let profilePic = "profile_image"
    
    let workoutData: [(type: String, count: Int, color: Color)] = [
        ("Strength Training", 15, .red),
        ("Conditioning", 10, .yellow),
        ("Recovery", 5, .green)
    ]
    
    let daysActive: [Int] = [1, 2, 3, 6, 7, 10, 12, 14, 16, 18, 20, 22, 25, 28]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(profilePic)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    Text(username)
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack {
                        Text("Height: ")
                        TextField("Enter height", text: $height)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                    }

                    HStack {
                        Text("Weight: ")
                        TextField("Enter weight", text: $weight)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                    }

                }
                .padding(.leading)
                Spacer()
            }
            .padding(.top)
            
            HStack(alignment: .top) {
                Chart {
                    ForEach(workoutData, id: \.type) { data in
                        SectorMark(
                            angle: .value("Workouts", data.count),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(1)
                        )
                        .foregroundStyle(data.color)
                    }
                }
                .frame(width: 150, height: 150)
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Workout Summary")
                        .font(.headline)
                    ForEach(workoutData, id: \.type) { data in
                        HStack {
                            Circle()
                                .fill(data.color)
                                .frame(width: 10, height: 10)
                            Text("\(data.type): \(data.count)")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
            
            VStack(alignment: .leading) {
                Text("Monthly Activity")
                    .font(.headline)
                    .padding(.top)
                
                let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(1...30, id: \.self) { day in
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 20, height: 20)
                            .foregroundColor(daysActive.contains(day) ? .green : .gray.opacity(0.3))
                            .overlay(Text("\(day)").font(.caption2))
                    }
                }
            }
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
