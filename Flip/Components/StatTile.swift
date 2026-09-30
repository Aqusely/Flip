//
//  StatTile.swift
//  Flip
//
//  Created by Наливайко Кирилл on 30.09.2026.
//

import SwiftUI

struct StatTile: View{
    
    let value: String
    let label: String
    let color: Color
    let ink: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2){
            Text(value)
                .font(.unbounded(22, .bold))
            Text(label)
                .font(.manrope(13, .semibold))
        }.padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color, in: RoundedRectangle(cornerRadius: 22))
            .foregroundStyle(ink)
            
    }
}

#Preview {
    StatTile(value: "5", label: "Знаю", color: Color.flipMint, ink: Color.flipMintInk)
}
