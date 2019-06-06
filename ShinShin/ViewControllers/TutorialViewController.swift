//
//  TutorialViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 5/29/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSiguiente: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
    }
    
    //MARK: - UIActions
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
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize.width = view1.frame.width * 2
        
        view2.frame = CGRect(x: view1.frame.width, y: 0, width: view2.frame.width, height: view2.frame.height)
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        
        //PageControl
        
        //Buttons
        btnSiguiente.layer.cornerRadius = 5.0
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

extension TutorialViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
