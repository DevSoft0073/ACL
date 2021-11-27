//
//  ACLPageControllView.swift
//  ACL
//
//  Created by RGND on 14/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class ACLPageControllView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetUp()
    }
    
    /// Setup of container view for CustomAlertView
    func viewSetUp() {
        // setup the view from .xib
        guard let view = Bundle.main.loadNibNamed("ACLPageControllView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

//    func loadViewFromNib(_ nibName: String) -> UIView? {
//        // grabs the appropriate bundle
//        let bundle = Bundle.init(for: type(of: self))
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as? UIView
//    }
}
