//
//  TutorialViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 5/29/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    //MARK: - Propiedades
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSiguiente: UIButton!
    @IBOutlet weak var btnOmitir: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent = false
        initUIElements()
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
                btnSiguiente.setTitle("Finalizar", for: .normal)
            }
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Helper methods
    func initUIElements(){
        //UIScrolView
        let view1 = Bundle.main.loadNibNamed("Page1", owner: nil, options: nil)!.first as! UIView
        let view2 = Bundle.main.loadNibNamed("Page2", owner: nil, options: nil)!.first as! UIView
        let view3 = Bundle.main.loadNibNamed("Page3", owner: nil, options: nil)!.first as! UIView
        let view4 = Bundle.main.loadNibNamed("Page4", owner: nil, options: nil)!.first as! UIView
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize.width = view1.frame.width * 4
        
        view2.frame = CGRect(x: view1.frame.width, y: 0, width: view2.frame.width, height: view2.frame.height)
        view3.frame = CGRect(x: view1.frame.width * 2, y: 0, width: view2.frame.width, height: view2.frame.height)
        view4.frame = CGRect(x: view1.frame.width * 3, y: 0, width: view2.frame.width, height: view2.frame.height)
        
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
        scrollView.addSubview(view4)
        
        //PageControl
        
        //Buttons
        btnSiguiente.layer.cornerRadius = 10.0
        btnOmitir.layer.cornerRadius = 10.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Extensions
extension TutorialViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
