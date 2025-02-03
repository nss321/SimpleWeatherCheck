//
//  ConfigUI.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/3/25.
//

protocol ConfigUI {
    func configHierarchy()
    func configLayout()
    func configView()
}

extension ConfigUI where Self: BaseViewController {
    func configBackgrounColor() {
        view.backgroundColor = .tertiarySystemBackground
    }
}

