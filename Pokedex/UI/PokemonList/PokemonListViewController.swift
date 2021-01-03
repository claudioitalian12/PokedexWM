//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by claudio cavalli on 19/12/20.
//

import UIKit

class PokemonListViewController: UIViewController {
    private let pokemonListViewModel = PokemonListViewModel()
    
    private var isFirstPokemonLoad = false
    
    override func loadView() {
        self.view = PokemonListView(viewModel: self.pokemonListViewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInteractions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Pokedex"
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupInteractions() {
        self.pokemonListViewModel.showAlert = { [unowned self] title, message in
            self.showAlert(withTitle: title, andMessage: message)
        }
        
        self.pokemonListViewModel.didSelectPokemon = { [unowned self] pokemon in
            self.showDetailController(pokemon: pokemon)
        }
        
        guard let pokemonListView = self.view as? PokemonListView else { return }
        
        pokemonListView.willDisplayCellAtRow = { [unowned self] row in
            self.pokemonListViewModel.willDislayCell(at: row)
        }
        
        pokemonListView.didSelectPokemonAtRow = { [unowned self] row in
            self.pokemonListViewModel.pokemonForRow(at: row)
        }
        
        pokemonListView.didDisplayPokemonInSecondaryContext = { [unowned self] pokemons in
            if UIDevice.current.userInterfaceIdiom == .pad, !isFirstPokemonLoad, let pokemon = pokemons.first {
                isFirstPokemonLoad = true
                showDetailController(pokemon: pokemon)
            }
        }
    }
    
    private func showDetailController(pokemon: Pokemon) {
        let pokemonDetailViewModel = PokemonDetailViewModel(model: pokemon)
        let pokemonDetailViewController = PokemonDetailViewController(viewModel: pokemonDetailViewModel)
        self.showDetailViewController(pokemonDetailViewController, sender: nil)
    }
}
