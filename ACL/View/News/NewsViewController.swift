//
//  NewsViewController.swift
//  ACL
//
//  Created by Gagandeep on 26/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topBanner: UIImageView!
    
    let viewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setup3dTouch()
        loadData()
    }
    
    func setup3dTouch(){
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    func loadData() {
        // show loader
        SwiftLoader.show(animated: true)
        // get news
        viewModel.getNews { status, error in
            // hide loader
            SwiftLoader.hide()
            // show error if accoured
            if !status {
                self.showError(error)
                return
            }
            // update view
            self.updateView()
        }
    }
    
    func updateView() {
        if let imageName = viewModel.listingBanner {
            topBanner.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "NewsBanner"))
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "NewsBackground")
//        bottomView.addSubview(imageView)
       // bottomView.applyGradient(colours: [AppTheme.darkPurple, AppTheme.megenta])
    }
    
    func setupTable() {
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    @IBAction func videoAction(_ sender: Any) {
        if let videoViewController = UIStoryboard(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
            videoViewController.viewType = .news
            self.navigationController?.present(videoViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func introBtn(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
                   self.navigationController?.present(vc, animated: true, completion: nil)
               }
    }
    @IBAction func Backction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell {
            cell.selectionStyle = .none
            let newsData = viewModel.newsArray[indexPath.row]
            cell.setup(newsData)
            
            return cell
        }
        return NewsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = detailViewController(for: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
        //        if let newsDetailViewController = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController {
        //
        //            let newsData = viewModel.newsArray[indexPath.row]
        //            newsDetailViewController.news = newsData
        //
        //            self.navigationController?.pushViewController(newsDetailViewController, animated: true)
        //        }
        
    }
}

extension NewsViewController : UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
            return detailViewController(for: indexPath.row)
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func detailViewController(for index: Int) -> NewsDetailViewController {
        guard let vc = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else {
            fatalError("Couldn't load detail view controller")
        }
        let newsData = viewModel.newsArray[index]
        vc.news = newsData
        return vc
    }
    
    
}
