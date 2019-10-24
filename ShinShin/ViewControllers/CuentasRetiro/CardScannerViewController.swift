//
//  CardScannerViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/28/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol CardScannerViewControllerDelegate: class{
    func cardScanViewController(_ controller: CardScannerViewController, didFinish cardNumber: String)
}

class CardScannerViewController: UIViewController {
    
    @IBOutlet weak var cardView: CardIOView!
    weak var delegate: CardScannerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CardIOUtilities.preload()
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        let cardIOView = CardIOView(frame: self.cardView.frame)
        cardIOView.hideCardIOLogo = true
        cardIOView.scanInstructions = ""
        cardIOView.delegate = self
        self.cardView.addSubview(cardIOView)
    }
    
    
    @IBAction func customScanAction(_ sender: Any) {
        let cardIOView = CardIOView(frame: self.view.frame)
        cardIOView.delegate = self
        self.view.addSubview(cardIOView)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CardScannerViewController: CardIOViewDelegate{
    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        
        if let info = cardInfo {
            print( "\(info)" )
            cardIOView.removeFromSuperview()
            delegate?.cardScanViewController(self, didFinish: info.cardNumber)
        }

    }
    
    
}
