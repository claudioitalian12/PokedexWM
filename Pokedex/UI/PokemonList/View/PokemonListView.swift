//
//  PokemonListView.swift
//  Pokedex
//
//  Created by claudio cavalli on 19/12/20.
//

import UIKit

class PokemonListViewModel {
    let publishedPokemons: Observable<[Pokemon]> = Observable([])
    let isDownloading = Observable(false)
    
    // Total of pokemons to download from API
    private let pokemonNumber = 898
    private let offset = 0
    private var pokemons: [Pokemon] = []
    
    var pokemonCount: Int {
        pokemons.count
    }
    
    //Callbacks
    var showAlert: ((String, String) -> Void)?
    var didSelectPokemon: ((Pokemon) -> Void)?
    
    init() {
        self.setup()
    }
    
    private func setup() {
        self.loadPokemons(count: self.offset)
    }
    
    private func loadPokemons(count: Int) {
        self.setDownloadingStatus(to: true)
        Networking<Pokedex>.getPokedex(offset: String(count), completion: { [weak self] response in
            
            guard let self = self else { return }
            
            switch response {
            case .success(let response):
                guard let response = response else { return }
                
                self.getPokemonsDetail(from: response.results)
                
            case .failure(let error):
                self.setDownloadingStatus(to: false)
                
                self.loadLocalData(error: error)
            }
        })
    }
    
    private func getPokemonsDetail(from pokemonsReference: [NamedAPIResource]) {
        let dispatchGroup = DispatchGroup()
        
        pokemonsReference.forEach { pokemonReference in
            dispatchGroup.enter()
            
            Networking<Pokemon>.getPokemon(id: pokemonReference.name, completion: { [weak self] response in
                defer { dispatchGroup.leave() }
                
                guard let self = self else { return }
                
                switch response {
                case .success(let response):
                    guard let response = response else { return }
                    
                    self.pokemons.append(response)
                    
                case .failure(let error):
                    self.loadLocalData(error: error)
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            self.pokemons.sort(by: { $0.id.localizedStandardCompare($1.id) == .orderedAscending })
            
            self.publishedPokemons.value = self.pokemons
            
            self.setDownloadingStatus(to: false)
        }
    }
    
    private func loadLocalData(error: NetworkError) {
        if self.pokemons.isEmpty {
            self.localJSON()
        } else {
            self.showAlert?("Pokedex", error.rawValue)
        }
    }
    
    private func localJSON() {
        if let pokemons = JSONManager<Pokemon>.readLocalJSON(named: "Pokemons") {
            pokemons.forEach { pokemon in
                self.pokemons.append(pokemon)
                self.publishedPokemons.value = self.pokemons
            }
        }
    }
    
    private func setDownloadingStatus(to value: Bool) {
        self.isDownloading.value = value
    }
    
    func pokemonForCellView(at row: Int) -> Pokemon {
        pokemons[row]
    }
    
    func pokemonForRow(at row: Int) {
        let pokemon = self.pokemons[row]
        
        self.didSelectPokemon?(pokemon)
    }
    
    func willDislayCell(at row: Int) {
        let offset = self.pokemons.count
        
        if row == offset - 1 && offset < self.pokemonNumber && !self.isDownloading.value {
            self.loadPokemons(count: offset)
        }
    }
}

class PokemonListView: UIView {
    // MARK: property
    private let tableView = UITableView()
    private let loadPokemonIndicator = UIActivityIndicatorView(style: .gray)
    private var viewModel: PokemonListViewModel
    
    // MARK: Interactions
    var willDisplayCellAtRow: ((Int) -> ())?
    var didSelectPokemonAtRow: ((Int) -> ())?
    var didDisplayPokemonInSecondaryContext: (([Pokemon]) -> Void)?
    
    // MARK: PokemonListView init
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        self.setup()
        self.setupEvent()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = self.loadPokemonIndicator
        self.tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.reuseIdentifier)
        
        self.addSubview(tableView)
    }
    
    private func setupEvent() {
        self.viewModel.isDownloading.bind { [weak self] value in
            if value {
                self?.loadPokemonIndicator.startAnimating()
            } else {
                self?.loadPokemonIndicator.stopAnimating()
            }
        }
        
        self.viewModel.publishedPokemons.bind { [weak self] pokemon in
            self?.didDisplayPokemonInSecondaryContext?(pokemon)
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Style
    private func style() {
        self.backgroundColor = .black
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - Layout
    private func layout() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    // MARK: LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
}

// MARK: - UITableViewDataSource
extension PokemonListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.pokemonCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as? PokemonCell
        guard let pokemonCell = cell else {return UITableViewCell()}
        let pokemon = viewModel.pokemonForCellView(at: indexPath.row)
        
        pokemonCell.viewModel = PokemonCellViewModel(pokemon: pokemon)
        return pokemonCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.willDisplayCellAtRow?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectPokemonAtRow?(indexPath.row)
    }
}

// MARK: - UITableViewDelegate
extension PokemonListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
