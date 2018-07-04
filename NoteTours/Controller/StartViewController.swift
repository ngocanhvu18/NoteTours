//
//  StartViewController.swift
//  NoteTours
//
//  Created by ngocanh on 7/4/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.currentPage = 0
    }
     //page Control
    
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
