//
//  ContentController.swift
//  NoteTours
//
//  Created by NgọcAnh on 7/11/18.
//  Copyright © 2018 Ngọc Anh. All rights reserved.
//

import UIKit

class ContentController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inforLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    var places: Places?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if places != nil {
            nameLabel.text = places?.name
            inforLabel.text = places?.content
            photoView.download(from: places!.image)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
}
extension UIImageView {
    func download(from urlString: String){
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
