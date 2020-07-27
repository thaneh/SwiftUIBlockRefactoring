//
//  ContentView.swift
//  Refactoring
//
//  Created by Thane Heninger on 7/26/20.
//

import SwiftUI

extension CGSize {
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
}

struct ContentView: View {
    
    public enum BoxMove {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        var alignment: Alignment {
            switch self {
            case .topLeft:      return .topLeading
            case .topRight:     return .topTrailing
            case .bottomLeft:   return .bottomLeading
            case .bottomRight:  return .bottomTrailing
            }
        }
        
        var clickOffset: CGSize {
            let offset = CGFloat(10)
            
            switch self {
            case .topLeft:      return CGSize(width: -offset, height: -offset)
            case .topRight:     return CGSize(width:  offset, height: -offset)
            case .bottomLeft:   return CGSize(width: -offset, height:  offset)
            case .bottomRight:  return CGSize(width:  offset, height:  offset)
            }
        }
    }
    
    @State private var bigBoxOffset = CGSize.zero
    private let mediumBoxSize = CGFloat(128)
    private let smallBoxSize = CGFloat(32)

    private struct Box: View {
        let lineWidth = CGFloat(2)
        let size: CGFloat
        let lineColor: Color
        
        var body: some View {
            Rectangle()
                .stroke(lineColor, lineWidth: lineWidth)
                .frame(width: size, height: size)
        }
    }
    
    struct SquareData: Identifiable {
        let id = UUID()
        let direction: BoxMove
        let color: Color
    }
    
    private let bigBoxSize = CGFloat(256)
    
    let corners = [SquareData(direction: .topLeft,     color: .red),
                   SquareData(direction: .topRight,    color: .blue),
                   SquareData(direction: .bottomLeft,  color: .green),
                   SquareData(direction: .bottomRight, color: .yellow)]
    
    var body: some View {
        ZStack {
            Box(size: mediumBoxSize, lineColor: .black)
            
            ForEach(corners) { corner in
                Box(size: smallBoxSize, lineColor: corner.color)
                    .frame(width: bigBoxSize, height: bigBoxSize,
                           alignment: corner.direction.alignment)
                    .onTapGesture {
                        self.bigBoxOffset += corner.direction.clickOffset
                    }
            }
        }
        .offset(bigBoxOffset)
    }
}

struct SwiftUIViewG5_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
