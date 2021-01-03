//
//  TypeView.swift
//  Pokedex
//
//  Created by claudio cavalli on 03/05/2020.
//  Copyright © 2020 claudio cavalli. All rights reserved.
//

import UIKit

struct TypeViewModel {
    let pokemonType: String
    
    var backgroundColor: UIColor? {
        pokemonType.color()
    }
    
    var pokemonNameUppercased: String {
        pokemonType.uppercased()
    }
}

class TypeView: UIView {
    // MARK: property
    private let label = UILabel()
    
    var viewModel: TypeViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: TypeView init
    init(typeViewModel: TypeViewModel? = nil) {
        self.viewModel = typeViewModel
        super.init(frame: .zero)
        
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setView
    private func setup() {
        addSubview(self.label)
    }
    
    private func style() {
        self.label.textColor = .white
        self.label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        self.label.textAlignment = .center
        
        self.layer.cornerRadius = 6.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    private func update() {
        guard let viewModel = self.viewModel else { return }
        
        self.backgroundColor = viewModel.backgroundColor
        self.label.text = viewModel.pokemonNameUppercased
    }
    
    private func layout() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
    }
    
    // MARK: LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
}
