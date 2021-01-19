//
//  StatView.swift
//  Pokedex
//
//  Created by claudio cavalli on 03/05/2020.
//  Copyright © 2020 claudio cavalli. All rights reserved.
//

import UIKit

struct StatViewModel {
    var statName: PokemonStat
    var type: String
    
    var statNameUppercased: String {
        statName.stat.name.uppercased()
    }
    
    func statBarViewModelForStat() -> StatBarViewModel {
        StatBarViewModel(base_stat: statName.base_stat, typeName: type)
    }
}

class StatView: UIView {
    // MARK: property
    private var statBar = StatBarView()
    private let label = UILabel()
    private let stack = UIStackView()
    
    var viewModel: StatViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: StatView init
    init(viewModel: StatViewModel? = nil) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        self.setup()
        self.style()
        self.layout()
        self.update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        addSubview(self.stack)
        self.stack.addArrangedSubview(self.label)
        self.stack.addArrangedSubview(self.statBar)
    }
    
    // MARK: Style
    private func style() {
        self.layer.cornerRadius = 6.0
        
        self.stack.axis = .horizontal
        self.stack.spacing = 0
        self.stack.distribution = .fillEqually
        
        self.label.textColor = .white
        self.label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    // MARK: Update
    private func update() {
        guard let viewModel = self.viewModel else { return }
        
        self.statBar.viewModel = viewModel.statBarViewModelForStat()
        
        self.label.text = viewModel.statNameUppercased
    }
    
    // MARK: Layout
    private func layout() {
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.stack.translatesAutoresizingMaskIntoConstraints = false
        self.stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
    }
}
