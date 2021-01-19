//
//  StatBar.swift
//  Pokedex
//
//  Created by claudio cavalli on 03/05/2020.
//  Copyright © 2020 claudio cavalli. All rights reserved.
//

import UIKit

struct StatBarViewModel {
    var base_stat: CGFloat
    var typeName: String
    
    var backgroundColor: UIColor? {
        typeName.color()?.withAlphaComponent(0.3)
    }
    
    var statValue: CGFloat {
        base_stat/252
    }
}

class StatBarView: UIView {
    // MARK: property 
    private var pokeValue = UIView()
    
    var viewModel: StatBarViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: StatBarView init
    init(viewModel: StatBarViewModel? = nil) {
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
        addSubview(self.pokeValue)
    }
    
    // MARK: Style
    private func style() {
        self.alpha = 1.0
        self.clipsToBounds = true
        
        self.pokeValue.layer.cornerRadius = 6.0
        self.pokeValue.alpha = 0
        self.pokeValue.backgroundColor = .white
        
        self.pokeValue.layer.shadowOpacity = 0.3
        self.pokeValue.layer.shadowRadius = 2
        self.pokeValue.layer.shadowColor = UIColor.black.cgColor
        self.pokeValue.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 1)
    }
    
    // MARK: Update
    private func update() {
        guard let viewModel = self.viewModel else { return }
        
        self.backgroundColor = viewModel.backgroundColor
        self.animatableLayout()
    }
    
    // MARK: Layout
    private func layout() {
        self.pokeValue.translatesAutoresizingMaskIntoConstraints = false
        self.pokeValue.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.pokeValue.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.pokeValue.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func animatableLayout() {
        guard let viewModel = self.viewModel else { return }
        self.pokeValue.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: viewModel.statValue).isActive = true
        DispatchQueue.main.async { [unowned self] in
            self.pokeValue.stretch()
        }
    }
}
