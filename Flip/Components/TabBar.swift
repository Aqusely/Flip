//
//  TabBar.swift
//  Flip
//
//  Created by Наливайко Кирилл on 29.09.2026.
//

import SwiftUI

struct TabBar: View{
    
    @Binding var selection: Int
    @Namespace private var ns
    
    let icons = [
        "square.grid.2x2",
        "chart.bar",
        "person"
    ]
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(icons.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)){
                        self.selection = index
                    }
                }){
                    Image(systemName: icons[index])
                        .frame(width: 56, height: 48)
                        .font(.system(size: 20, weight: .semibold))
                        .background{
                            if selection == index {
                                Capsule().fill(Color.flipBackground)
                                    .matchedGeometryEffect(id: "pill", in: ns)
                            }
                        }
                        .foregroundStyle(selection == index ? Color.flipInk : Color.flipOnInk)
                }.buttonStyle(.plain)
            }
        }.padding(8)
            .background(Color.flipInk)
            .clipShape(Capsule())
    }
}
#Preview{
    @Previewable @State var tab = 0
    TabBar(selection: $tab)
}
