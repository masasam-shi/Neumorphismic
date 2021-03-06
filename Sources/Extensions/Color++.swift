//
//  Color++.swift
//  Neumorphismic
//
//  Created by Masashi Aso on 2020/01/14.
//  Copyright © 2020 Masashi Aso. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, OSX 10.15, watchOS 6, tvOS 13, *)
public extension Color {
    
    init(hue: Double, saturation: Double, lightness: Double, opacity: Double = 1) {
        let (h, s, b) = ColorTransformer.hslToHsb(h: hue, s: saturation, l: lightness)
        self = Color(hue: h, saturation: s, brightness: b, opacity: opacity)
    }
    
    init(hex: String, opacity: Double = 1.0) {
        let v = Int(hex, radix: 16) ?? 0
        let r = Double(v / Int(powf(256, 2)) % 256) / 255
        let g = Double(v / Int(powf(256, 1)) % 256) / 255
        let b = Double(v / Int(powf(256, 0)) % 256) / 255
        self = Color(red: r, green: g, blue: b, opacity: opacity)
    }
    
    func lighter(_ value: Double) -> Color {
        let (h, s, l, a) = getHSLA()
        return Color(hue: h, saturation: s, lightness: min(l + value, 1), opacity: a)
    }

    func darker(_ value: Double) -> Color {
        let (h, s, l, a) = getHSLA()
        return Color(hue: h, saturation: s, lightness: max(l - value, 0), opacity: a)
    }
    
    internal func primary(_ value: Double) -> Color {
        let (_, _, l, _) = getHSLA()
        return (l > 0.5) ? darker(value) : lighter(value)
    }
    
    func getRGBA() -> (r: Double, g: Double, b: Double, a: Double) {
        let string = String(self.description.dropFirst())
        let v = Int(string, radix: 16) ?? 0
        
        let r = Double(v / Int(powf(256, 3)) % 256) / 255
        let g = Double(v / Int(powf(256, 2)) % 256) / 255
        let b = Double(v / Int(powf(256, 1)) % 256) / 255
        let a = Double(v / Int(powf(256, 0)) % 256) / 255
        
        return (r, g, b, a)
    }
    
    func getHSLA() -> (h: Double, s: Double, l: Double, a: Double) {
        let (r, g, b, a) = getRGBA()
        let (h, s, l) = ColorTransformer.rgbToHsl(r: r, g: g, b: b)
        return (h, s, l, a)
    }
    
    func getHSBA() -> (h: Double, s: Double, b: Double, a: Double) {
        let (r, g, b, a) = getRGBA()
        let (h, s, v) = ColorTransformer.rgbToHsb(r: r, g: g, b: b)
        return (h, s, v, a)
    }
    
}

@available(iOS 13, OSX 10.15, watchOS 6, tvOS 13, *)
internal struct ColorPreview: View {
    var color: Color
    init(_ color: Color) { self.color = color }
    var body: some View {
        VStack {
            preview(color)
            preview(color.lighter(0.12))
            preview(color.darker(0.18))
            preview(color.darker(1))
        }
    }
    func preview(_ color: Color) -> some View {
        ZStack {
            color
            Text(color.description)
                .foregroundColor(color.primary(1.0))
        }
    }
}

@available(iOS 13, OSX 10.15, watchOS 6, tvOS 13, *)
internal struct ColorExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ColorPreview(Color(hex: "C1D2EB"))
            ColorPreview(Color(hex: "000000"))
            ColorPreview(Color(hex: "FFFFFF"))
        }
        .edgesIgnoringSafeArea(.all)
        .previewLayout(.fixed(width: 200, height: 100))
    }
}

#endif
