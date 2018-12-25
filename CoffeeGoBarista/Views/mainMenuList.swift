//
//  mainMenuList.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/25/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainMenuList: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        bottomBar()
        super.viewDidLoad()
        
    }
    
    func bottomBar(){
        settings.style.buttonBarBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = .init(red: 1, green: 120/255, blue: 0, alpha: 1)
        settings.style.selectedBarBackgroundColor = .white
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = UIColor.white
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var storyboard = [UIViewController]()
        
            storyboard.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Coffee"))
        
        return storyboard
    }
    
}
