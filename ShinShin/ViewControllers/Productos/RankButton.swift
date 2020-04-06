//
//  RankButton.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 05/04/20.
//  Copyright © 2020 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class RankButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var isRanked: Bool = false
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print( "Tapped: ? \(isEnable)" )
//        
//        isEnable = !isEnable
//    }
}
