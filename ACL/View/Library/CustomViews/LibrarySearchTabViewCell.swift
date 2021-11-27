
import UIKit

class LibrarySearchTabViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Roboto-Regular", size: 15)
        lbl.textColor = AppTheme.steelGray.withAlphaComponent(0.7)
        return lbl
    }()
    
    var indicatorView: UIView!
    var sliderImageView: UIImageView!
    
    override var isSelected: Bool {
        
        didSet{
            UIView.animate(withDuration: 0.30) {
                self.indicatorView.backgroundColor = .clear
                self.sliderImageView.image = self.isSelected ? UIImage(named: "Slider_up") : nil
                self.sliderImageView.contentMode = .scaleAspectFit
                self.titleLabel.textColor = self.isSelected ? UIColor.white : AppTheme.steelGray
                self.layoutIfNeeded()
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormatString(formate: "V:|[v0]|", views: titleLabel)
        
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        setupIndicatorView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
   
    func setupIndicatorView() {
        indicatorView = UIView()
        addSubview(indicatorView)
       
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: indicatorView)
        addConstraintsWithFormatString(formate: "V:[v0(3)]|", views: indicatorView)
        sliderImageView = UIImageView()
            //UIImageView(frame: CGRect(x: (indicatorView.frame.size.width / 2) - 7.5, y: indicatorView.frame.maxY - 10, width: 15, height: 15))
               //sliderImageView.image = UIImage(named: "Slider_up")
        addSubview(sliderImageView)
        addConstraintsWithFormatString(formate: "H:|[v0]|", views: sliderImageView)
        addConstraintsWithFormatString(formate: "V:[v0(11)]|", views: sliderImageView)
        
    }
    
}
