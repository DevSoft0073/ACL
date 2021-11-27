//
//  MeditationArchivesController.swift
//  ACL
//
//  Created by RGND on 25/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

protocol MeditationArchivesControllerDelegate: class {
    func meditationDidSelect(_ meditation: Meditation)
}

class MeditationArchivesController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var arrowBtn: UIButton!
    
    
    var isButtonPositionTop = false
    var viewModel = DailyMeditationViewModel()
    
    weak var delegate: MeditationArchivesControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollToBottom(){
        if isButtonPositionTop == false{
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.arrowBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            let numberOfSections = collectionView.numberOfSections
            let numberOfRows = collectionView.numberOfItems(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: false)
            }
        }else{
            collectionView.setContentOffset(.zero, animated: false)
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.arrowBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            }
        }
    }
    
    @IBAction func downArrowBtn(_ sender: UIButton) {
        scrollToBottom()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetMaxY: Float = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight: Float = Float(scrollView.contentSize.height)
        let height = contentOffsetMaxY > contentHeight - 8
        if height {
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.arrowBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            self.isButtonPositionTop = true
        }else{
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.arrowBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            }
            self.isButtonPositionTop = false
        }
    }
    
}

extension MeditationArchivesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.customeMeditations.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeditationArchivesCollectionCell", for: indexPath) as? MeditationArchivesCollectionCell {
            
            let category = viewModel.customeMeditations[indexPath.row]
            cell.imageView.sd_setImage(with: URL(string: category.categoryIcon ?? "daily_meditation_category_body_centered"), completed: nil)
            cell.titleLabel.text = category.categoryName
            
            return cell
        }
        return MeditationArchivesCollectionCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Singleton.sharedInstance.backgroundSettingisOn{
            let meditation = viewModel.customeMeditations[indexPath.row]
            delegate?.meditationDidSelect(meditation)
            self.navigationController?.popViewController(animated: true)

        }else{
            self.showError("To play the sound it should turn on from setting screen")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets:CGFloat = 50
        return CGSize(width: (UIScreen.main.bounds.width - sectionInsets)/2, height: 90)
    }
    
}
