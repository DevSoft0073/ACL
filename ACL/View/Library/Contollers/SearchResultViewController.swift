//
//  SearchResultViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 27/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
    @IBOutlet weak var menuBarView: MenuTabsView!
    
    @IBOutlet weak var headerBackview: UIView!
    
    @IBOutlet weak var backToMyACLButton: UIButton!
    @IBOutlet weak var backToMainbutton: UIButton!
    @IBOutlet weak var searchTitle: UILabel!
    
    var currentIndex: Int = 0
    var tabs = ["Meditations","Quotes","Challenges","Videos"]
    var pageController: UIPageViewController!
    var viewModel = SearchResultViewModel()
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTitle.text = searchText
        menuBarView.dataArray = tabs
        //menuBarView.isSizeToFitCellsNeeded = true
        menuBarView.collView.backgroundColor = UIColor.clear
        presentPageVCOnView()
        
        menuBarView.menuDelegate = self
        pageController.delegate = self
        pageController.dataSource = self
        
        //For Intial Display
        menuBarView.collView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
//        pageController.setViewControllers([viewController(At: 0)!], direction: .forward, animated: true, completion: nil)
        
        // With CallBack Function...
        //menuBarView.menuDidSelected = myLocalFunc(_:_:)
        SwiftLoader.show(animated: true)
        viewModel.getSearchContent(searchText: searchText) { (isSucess, message) in
            print(isSucess)
            SwiftLoader.hide()
            self.pageController.setViewControllers([self.viewController(At: 0)!], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    
    /*
     // Call back function
    func myLocalFunc(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        
        
        if indexPath.item != currentIndex {
            
            if indexPath.item > currentIndex {
                self.pageController.setViewControllers([viewController(At: indexPath.item)!], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([viewController(At: indexPath.item)!], direction: .reverse, animated: true, completion: nil)
            }
            
            menuBarView.collView.scrollToItem(at: IndexPath.init(item: indexPath.item, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
    }
     */
 
    func presentPageVCOnView() {
        
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "SearchPageViewController") as! SearchPageViewController
        var maxY = menuBarView.frame.maxY - 3
        if UIDevice().isRegularModel() {
            maxY = menuBarView.frame.maxY - 27
        }
        self.pageController.view.frame = CGRect.init(x: 0, y: maxY, width: self.view.frame.width, height: self.view.frame.height - maxY)
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
        self.view.bringSubviewToFront(backToMyACLButton)
        self.view.bringSubviewToFront(backToMainbutton)
        
    }
    
    @IBAction private func backToMainAction(_ sender: UIButton) {
        guard let viewControllers =  self.navigationController?.viewControllers else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        for vc in viewControllers {
            if vc.isKind(of: MainViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func backToMyACL(_ sender: UIButton) {
        guard let viewControllers =  self.navigationController?.viewControllers else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        for vc in viewControllers {
            if vc.isKind(of: MyACLViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    //Present ViewController At The Given Index
    
    func viewController(At index: Int) -> UIViewController? {
        
        if((self.menuBarView.dataArray.count == 0) || (index >= self.menuBarView.dataArray.count)) {
            return nil
        }
        
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "SearchContentViewController") as! SearchContentViewController
        contentVC.pageIndex = index
        contentVC.viewModel = viewModel
        currentIndex = index
        return contentVC
        
    }
    
}





extension SearchResultViewController: MenuBarDelegate {

    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int) {

        // If selected Index is other than Selected one, by comparing with current index, page controller goes either forward or backward.
        
        if index != currentIndex {

            if index > currentIndex {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .reverse, animated: true, completion: nil)
            }

            menuBarView.collView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)

        }

    }

}


extension SearchResultViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! SearchContentViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewController(At: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! SearchContentViewController).pageIndex
        
        if (index == tabs.count) || (index == NSNotFound) {
            return nil
        }
        
        index += 1
        return self.viewController(At: index)
        
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            if completed {
                let cvc = pageViewController.viewControllers!.first as! SearchContentViewController
                let newIndex = cvc.pageIndex
                menuBarView.collView.selectItem(at: IndexPath.init(item: newIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
                menuBarView.collView.scrollToItem(at: IndexPath.init(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
        
    }
    
}

