//
//  JoyStick.swift
//  CarController
//
//  Created by Dylan Adal on 3/25/26.
//

import SwiftUI

struct JoystickView: View {
    // .horizontal or .vertical
    var axis: Axis
    
    @Binding var value: UInt8
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            let radius = min(geo.size.width, geo.size.height) / 2
            
            ZStack {
                // background circle
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: radius * 2, height: radius * 2)
                
                // joystick
                Circle()
                    .fill(Color.blue)
                    .frame(width: radius, height: radius)
                    .offset(
                        x: axis == .horizontal ? dragOffset : 0,
                        y: axis == .vertical ? dragOffset : 0
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                // get drag amount in the intended axis
                                let translation = axis == .horizontal ? gesture.translation.width : gesture.translation.height
                                
                                // clamp within radius
                                let clamped = max(min(translation, radius), -radius)
                                dragOffset = clamped
                                
                                // normalize to UInt8 0-255, 128 is center
                                let normalized = UInt8((clamped / radius * 127) + 128)
                                value = normalized
                            }
                            .onEnded { _ in
                                dragOffset = 0
                                value = 128
                            }
                    )
            }
        }
        .frame(width: 300, height: 300)
    }
}
