//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by claudio cavalli on 19/12/20.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    private let pokemonNumberLabel = UILabel()
    
    var pokemonDetailViewModel: PokemonDetailViewModel? {
        didSet {
            self.update()
        }
    }
    
    init(viewModel: PokemonDetailViewModel? = nil) {
        self.pokemonDetailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = PokemonDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.pokemonNumberLabel.textColor = .white
        self.pokemonNumberLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.pokemonNumberLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func update() {
        guard let pokemonDetailViewModel = self.pokemonDetailViewModel else { return }
        self.pokemonNumberLabel.text = pokemonDetailViewModel.pokemonID
        
        guard let pokemondDetailView = self.view as? PokemonDetailView else { return }
        pokemondDetailView.viewModel = pokemonDetailViewModel
    }
}
