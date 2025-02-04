//
//  BaseView.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/4/25.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configHierarchy()
        configLayout()
        configView()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() { }
    
    func configLayout() { }
    
    func configView() { }
}
