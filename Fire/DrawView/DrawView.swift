//
//  DrawView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import SwiftUI


struct DrawView: View {

    @State var curves: [[CGPoint]] = [[]]

    var body: some View {
        drawSection(curves: $curves)
    }
}

struct drawSection: View {

    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    @Binding var curves: [[CGPoint]]

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .gesture(DragGesture().onChanged( { value in
                    self.addNewPoint(value, borderX: width, borderY: height)
                }).onEnded( { value in
                    curves.append([])
                }))
            ForEach(curves.indices, id: \.self) { index in
                DrawShape(points: curves[index])
                    .stroke(lineWidth: 5) // here you put width of lines
                    .foregroundColor(.blue)
            }
        }
        .frame(width: width, height: height)
    }

    private func addNewPoint(_ value: DragGesture.Value, borderX: CGFloat, borderY: CGFloat) {
        if value.location.y >= -0, value.location.y <= 630 {
            curves[curves.endIndex - 1].append(value.location)
        }
    }
}

private struct DrawShape: Shape {

    var points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }

        path.move(to: firstPoint)
        for pointIndex in 1..<points.count {
            path.addLine(to: points[pointIndex])

        }
        return path
    }
}
