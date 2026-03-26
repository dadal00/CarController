//
//  JoyStick.swift
//  CarController
//
//  Created by Dylan Adal on 3/25/26.
//

import SwiftUI

struct JoystickView: View {
    @Binding var magnitude: UInt8
    @Binding var angle: UInt16
    
    @State private var dragOffset: CGSize = .zero
    
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
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let dx = gesture.translation.width
                                let dy = gesture.translation.height
                                
                                // distance from center
                                let distance = sqrt(dx * dx + dy * dy)
                                
                                // clamp inside circle
                                let clampedDistance = min(distance, radius)
                                
                                let angleRad = atan2(dy, dx)
                                
                                let clampedX = cos(angleRad) * clampedDistance
                                let clampedY = sin(angleRad) * clampedDistance
                                
                                dragOffset = CGSize(width: clampedX, height: clampedY)
                                
                                // --- magnitude (0–255)
                                let mag = clampedDistance / radius
                                magnitude = UInt8(mag * 255)
                                
                                // --- angle (0–359)
                                var deg = angleRad * 180 / .pi
                                
                                // convert to 0–360
                                if deg < 0 { deg += 360 }
                                
                                angle = UInt16(deg)
                            }
                            .onEnded { _ in
                                dragOffset = .zero
                                magnitude = 0
                                angle = 0
                            }
                    )
            }.rotationEffect(.degrees(-90))
        }
        .frame(width: 300, height: 300)
    }
}
