//
//  ProgressRing.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

struct ProgressRing: View {
    
    let progress: Double
    let color: Color
    var lineWidth = 5.0
    
    @State private var shown = false
    
    var body: some View {
        ZStack{
            Circle().stroke(color.opacity(0.15), lineWidth: lineWidth)
            Circle().trim(from: 0, to: shown ? CGFloat(progress) : 0)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
        }.onAppear{
            withAnimation(.easeInOut(duration: 1)){
                self.shown = true
            }
        }
    }
}

#Preview {
    ProgressRing(progress: 0.5, color: Color.black)
}
