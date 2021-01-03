//
//  Extension.swift
//  Pokedex
//
//  Created by claudio cavalli on 19/12/20.
//

import UIKit

extension UIColor {
    public convenience init(_ hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
    }
}

extension String {
    func color() -> UIColor? {
        switch self {
        case "normal": return UIColor("#A8A979")
        case "fire": return UIColor("#F08030")
        case "water": return UIColor("#6890F0")
        case "grass": return UIColor("#78C851")
        case "electric": return UIColor("#F8D130")
        case "ice": return UIColor("#99D9D8")
        case "fighting": return UIColor("#C12F28")
        case "poison": return UIColor("#A140A1")
        case "ground": return UIColor("#E0C168")
        case "flying": return UIColor("#A890F0")
        case "psychic": return UIColor("#F85888")
        case "bug": return UIColor("#A9B91F")
        case "rock": return UIColor("#B9A038")
        case "ghost": return UIColor("#705898")
        case "dark": return UIColor("#715848")
        case "dragon": return UIColor("#7039F8")
        case "steel": return UIColor("#B8B9D0")
        case "fairy": return UIColor("#F1B7BC")
        case "shadow": return UIColor("#F85887")
        case "unknown": return UIColor("#A9B92F")
        default: return UIColor()
        }
    }
}

extension UIView {
    func vibrate() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.09
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 7.0, y: center.y)
        animation.toValue =  CGPoint(x: center.x + 7.0, y: center.y)
        layer.add(animation, forKey: "position")
    }
    
    func stretch() {
        let animation = CABasicAnimation(keyPath: "position")
        alpha = 1
        animation.duration = 0.8
        animation.fromValue = CGPoint(x: center.x - bounds.width * 2, y: center.y)
        animation.toValue =  CGPoint(x: center.x, y: center.y)
        layer.add(animation, forKey: "position")
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { action in
            self.navigationController?.popViewController(animated: true)
        }
        
        closeAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(closeAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension URL {
    var lastPathString: String {
        let subrange = self.absoluteString.components(separatedBy: "/")
        return subrange.last ?? ""
    }
}
