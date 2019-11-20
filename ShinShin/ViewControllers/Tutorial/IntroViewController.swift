//
//  IntroViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/21/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    //MARK: - Propiedades
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var btnOmitir: UIButton!
    var restore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent = false
        
        view.layoutIfNeeded()
        initUIElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Actions
    @IBAction func change(_ sender: Any) {
        //Se puede continuar con el paginador hasta llegar al ultimo elemento de vistas
        if pageControl.currentPage == (pageControl.numberOfPages - 1){
            dismiss(animated: true, completion: nil)
        }
        else{
            let nextPage = pageControl.currentPage + 1
            let x = CGFloat(nextPage) * scrollView.frame.size.width
            scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
            pageControl.currentPage = nextPage
            
            if nextPage == (pageControl.numberOfPages - 1){
                animate(isEnd: true)
                restore = !restore
            }
            else{
                if restore{
                    animate(isEnd: false)
                    restore = !restore
                }
            }
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Helper methods
    func initUIElements(){
        //UIScrolView
        let view1 = Bundle.main.loadNibNamed("Intro1", owner: nil, options: nil)!.first as! UIView
        let view2 = Bundle.main.loadNibNamed("Intro2", owner: nil, options: nil)!.first as! UIView
        let view3 = Bundle.main.loadNibNamed("Intro3", owner: nil, options: nil)!.first as! UIView
        let view4 = Bundle.main.loadNibNamed("Intro4", owner: nil, options: nil)!.first as! UIView
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize.width = scrollView.frame.width * 4
        
        view1.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        view2.frame = CGRect(x: scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        view3.frame = CGRect(x: scrollView.frame.width * 2, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        view4.frame = CGRect(x: scrollView.frame.width * 3, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
        scrollView.addSubview(view4)
        
        //PageControl
        
        //Buttons
        btnSiguiente.layer.cornerRadius = 10.0
        btnOmitir.layer.cornerRadius = 10.0
    }

    func animate(isEnd: Bool){
        if isEnd{
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                let y = CGRect(x: 78, y: 45, width: self.btnSiguiente.frame.width, height: self.btnSiguiente.frame.height)
                self.btnSiguiente.frame = y
                self.btnSiguiente.setTitle("¡Listo!", for: .normal)
                self.btnOmitir.alpha = 0.0
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
                let y = CGRect(x: 156, y: 45, width: self.btnSiguiente.frame.width, height: self.btnSiguiente.frame.height)
                self.btnSiguiente.frame = y
                self.btnSiguiente.setTitle("Siguiente", for: .normal)
                self.btnOmitir.alpha = 1.0
            }, completion: nil)
        }
    }
}

//MARK: - Extensions
extension IntroViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        if pageControl.currentPage == (pageControl.numberOfPages - 1){
            animate(isEnd: true)
            restore = !restore
        }
        else{
            if restore{
                animate(isEnd: false)
                restore = !restore
            }
        }
    }
}
