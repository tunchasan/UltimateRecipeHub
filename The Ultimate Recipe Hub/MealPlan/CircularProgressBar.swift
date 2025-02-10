import SwiftUI

struct CircularProgressBar: View {
    var progress: Double // Progress (0.0 to 1.0)
    var lineWidth: CGFloat = 10
    var progressColor: Color = .blue
    var backgroundColor: Color = Color.gray.opacity(0.3)
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            
            // Progress Circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeInOut, value: progress)
        }
        .frame(width: 100, height: 100)
    }
}

struct ContentView: View {
    @State private var progress: Double = 0.5 // Example progress

    var body: some View {
        VStack {
            CircularProgressBar(progress: progress)
            
            Slider(value: $progress, in: 0...1) // Control progress
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}