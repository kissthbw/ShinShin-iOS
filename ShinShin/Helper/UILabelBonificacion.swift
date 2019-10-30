//
//  UILabelBonificacion.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 28/10/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class UILabelBonificacion: UILabel {
    
    var isBanner = true
    
    let fontSign = UIFont(name: "Nunito SemiBold", size: 18)
    let fontText = UIFont(name: "Nunito Black", size: 21)
    //#FF4D00: 255, 77, 0
    let twoDigitsColor = UIColor(red: 255/255, green: 77/255, blue: 0/255, alpha: 1.0)
    
    //#FE6F01: 254, 111, 1
    let oneDigitsColor = UIColor(red: 254/255, green: 111/255, blue: 1/255, alpha: 1.0)
    
    var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key: Any]()
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
        // Drawing code
//    }
    
//    override func draw(_ rect: CGRect) {
//        let inset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//        super.drawText(in: rect.inset(by: inset))
//    }
//
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }

    init(){
        super.init(frame: .zero)
        self.initUI()
    }


    func initUI(){
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
//        self.textColor = .white
//        self.backgroundColor = .orange
        self.textAlignment = .center
//        attributes: [NSAttributedString.Key: Any] = [
//            .font: fontText,
//            .foregroundColor: UIColor.white,
//        ]
        attributes[.font] = fontText
        attributes[.foregroundColor] = UIColor.white
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        attributes[.paragraphStyle] = style
        
    }
//
    
    override var text: String?{
        didSet{
            if let t = text{
                
                if t.count == 4{
                    self.backgroundColor = oneDigitsColor
                }
                else{
                    self.backgroundColor = twoDigitsColor
                }
                
                super.text = t + "  "
                let attr = NSMutableAttributedString(string: super.text!, attributes: attributes)
                
                let signRange = NSRange(location: 0, length: 2)
                
                var a2: [NSAttributedString.Key: Any] = [NSAttributedString.Key: Any]()
                a2[.font] = fontSign
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.center
                a2[.paragraphStyle] = style
                
                attr.addAttributes(a2, range: signRange)
//                attr.addAttribute(.font, value: fontSign, range: signRange)
                
                self.attributedText = attr
                
            }
        }
    }
}
