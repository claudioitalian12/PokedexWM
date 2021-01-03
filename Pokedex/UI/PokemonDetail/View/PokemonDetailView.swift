//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by claudio cavalli on 19/12/20.
//

import UIKit

struct PokemonDetailViewModel {
    private let pokemon: Pokemon
    
    init(model: Pokemon) {
        self.pokemon = model
    }
    
    var pokemonID: String {
        "#\(pokemon.id)"
    }
    
    var primaryTypeColor: UIColor? {
        pokemon.types[0].type.name.color()
    }
    
    var primaryTypeName: String {
        pokemon.types[0].type.name
    }
    
    var secondaryTypeName: String {
        hasTwoTypes ? pokemon.types[1].type.name : "unknown"
    }
    
    var placeholder: UIImage? {
        return UIImage(named: "PokemonsImages/\(self.pokemon.id)") ?? UIImage(named: "pokeball")
    }
    
    var pokemonImageURL: URL {
        PokedexEndpoint.artwork(id: pokemon.id).url
    }
    
    var pokemonStats: [PokemonStat] {
        pokemon.stats
    }
    
    var pokemonHeight: String {
        pokemon.height
    }
    
    var pokemonWeight: String {
        pokemon.weight
    }
    
    var pokemonNameUppercased: String {
        pokemon.name.uppercased()
    }
    
    var hasTwoTypes: Bool {
        pokemon.types.count > 1
    }
}

class PokemonDetailView: UIView {
    private let scrollView = UIScrollView()
    private var pokeImage = UIImageView()
    private let pokemonName = UILabel()
    private let typeStack = UIStackView()
    private let primaryTypeView = TypeView()
    private let secondaryTypeView = TypeView()
    private let dimensionStack = UIStackView()
    private let weight = UILabel()
    private let height = UILabel()
    private let statsStack = UIStackView()
    
    var viewModel: PokemonDetailViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: PokemonView init
    init(viewModel: PokemonDetailViewModel? = nil) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        self.setup()
        self.style()
        self.layout()
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Setup
    func setup() {
        addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.pokeImage)
        self.scrollView.addSubview(self.pokemonName)
        self.scrollView.addSubview(self.typeStack)
        self.scrollView.addSubview(self.dimensionStack)
        self.scrollView.addSubview(self.statsStack)
        
        self.typeStack.addArrangedSubview(self.primaryTypeView)
        self.typeStack.addArrangedSubview(self.secondaryTypeView)
        
        self.dimensionStack.addArrangedSubview(self.weight)
        self.dimensionStack.addArrangedSubview(self.height)
    }
    
    // MARK: Style
    func style() {
        self.typeStack.axis = .horizontal
        self.typeStack.spacing = 10
        self.typeStack.distribution = .fillEqually
        
        self.dimensionStack.axis = .horizontal
        self.dimensionStack.spacing = 10
        self.dimensionStack.distribution = .fillEqually
        
        self.statsStack.axis = .vertical
        self.statsStack.distribution = .fillEqually
        self.statsStack.spacing = 25
        
        self.pokemonName.textColor = .white
        self.pokemonName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.pokemonName.textAlignment = .center
        
        self.weight.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.weight.textColor = .white
        self.weight.textAlignment = .center
        
        self.height.textColor = .white
        self.height.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.height.textAlignment = .center
    }
    
    // MARK: Layout
    func layout() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        self.pokeImage.translatesAutoresizingMaskIntoConstraints = false
        self.pokeImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
        self.pokeImage.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
        self.pokeImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        self.pokeImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.pokemonName.translatesAutoresizingMaskIntoConstraints = false
        self.pokemonName.topAnchor.constraint(equalTo: pokeImage.bottomAnchor).isActive = true
        self.pokemonName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.pokemonName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.typeStack.translatesAutoresizingMaskIntoConstraints = false
        self.typeStack.topAnchor.constraint(equalTo: pokemonName.bottomAnchor, constant: 15).isActive = true
        self.typeStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.typeStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.primaryTypeView.translatesAutoresizingMaskIntoConstraints = false
        self.primaryTypeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        
        self.secondaryTypeView.translatesAutoresizingMaskIntoConstraints = false
        self.secondaryTypeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        
        self.dimensionStack.translatesAutoresizingMaskIntoConstraints = false
        self.dimensionStack.topAnchor.constraint(equalTo: typeStack.bottomAnchor, constant: 15).isActive = true
        self.dimensionStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.dimensionStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        self.weight.translatesAutoresizingMaskIntoConstraints = false
        self.weight.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        
        self.height.translatesAutoresizingMaskIntoConstraints = false
        self.height.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        
        self.statsStack.translatesAutoresizingMaskIntoConstraints = false
        self.statsStack.topAnchor.constraint(equalTo: dimensionStack.bottomAnchor, constant: 20).isActive = true
        self.statsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,constant: -10).isActive = true
        self.statsStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    // MARK: Update
    func update() {
        guard let viewModel = self.viewModel else { return }
        self.backgroundColor = viewModel.primaryTypeColor
        
        self.pokeImage.kf.setImage(with: viewModel.pokemonImageURL, placeholder: viewModel.placeholder, completionHandler:  { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.pokeImage.vibrate()
                }
            case .failure(_): break
            }
        })
        
        self.pokemonName.text = viewModel.pokemonNameUppercased
        
        self.primaryTypeView.viewModel = TypeViewModel(pokemonType: viewModel.primaryTypeName)
        self.secondaryTypeView.viewModel = TypeViewModel(pokemonType: viewModel.secondaryTypeName)
        self.secondaryTypeView.isHidden = !viewModel.hasTwoTypes
        
        self.weight.text = viewModel.pokemonWeight
        self.height.text = viewModel.pokemonHeight
        
        viewModel.pokemonStats.forEach { pokemonStat in
            let type = viewModel.primaryTypeName
            let statView = StatView()
            statView.viewModel = StatViewModel(statName: pokemonStat, type: type)
            
            self.statsStack.addArrangedSubview(statView)
        }
    }
    
    // MARK: LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layout()
    }
}
