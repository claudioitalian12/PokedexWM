//
//  PokemonCell.swift
//  Pokedex
//
//  Created by claudio cavalli on 19/12/20.
//

import UIKit
import Kingfisher

struct PokemonCellViewModel {
    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    var name: String {
        pokemon.name
    }
    
    var primaryTypeName: String {
        pokemon.types[0].type.name
    }
    
    var secondaryTypeName: String? {
        hasTwoTypes ? pokemon.types[1].type.name : nil
    }
    
    var id: String {
        pokemon.id
    }
    
    var placeholder: UIImage? {
        UIImage(named: "PokemonsImages/\(self.pokemon.id)") ?? UIImage(named: "pokeball")
    }
    
    var imageURL: URL? {
        PokedexEndpoint.artwork(id: pokemon.id).url
    }
    
    var hasTwoTypes: Bool {
        pokemon.types.count > 1
    }
}

class PokemonCell: UITableViewCell {
    // MARK: property
    static let reuseIdentifier = "PokemonCell"
    
    var backgroundCell = UIView()
    var nameLabel = UILabel()
    var idLabel = UILabel()
    var artwork = UIImageView()
    
    var primaryType = TypeView()
    var secondaryType = TypeView()
    
    var viewModel: PokemonCellViewModel? {
        didSet {
            self.update()
        }
    }
    
    // MARK: PokemonCell init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
        self.style()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.artwork.image = nil
        
        self.secondaryType.isHidden = false
    }
    
    // MARK: Setup
    private func setup() {
        self.contentView.addSubview(self.backgroundCell)
        self.backgroundCell.addSubview(self.nameLabel)
        self.backgroundCell.addSubview(self.idLabel)
        self.backgroundCell.addSubview(self.artwork)
        self.backgroundCell.addSubview(self.primaryType)
        self.backgroundCell.addSubview(self.secondaryType)
    }
    
    // MARK: Style
    private func style() {
        self.selectionStyle = .none
        
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        self.idLabel.textColor = .white
        self.idLabel.alpha = 0.8
        self.idLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.idLabel.adjustsFontSizeToFitWidth = true
        self.idLabel.textAlignment = .center
        
        self.backgroundCell.backgroundColor = .white
        self.backgroundCell.layer.cornerRadius = 16
        self.backgroundCell.layer.shadowOpacity = 0.3
        self.backgroundCell.layer.shadowRadius = 2
        self.backgroundCell.layer.shadowColor = UIColor.black.cgColor
        self.backgroundCell.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        self.contentView.backgroundColor = .white
    }
    
    // MARK: Update
    private func update() {
        guard let model = self.viewModel else {return}
        self.nameLabel.text = model.name
        self.idLabel.text = "#\(model.id)"
        self.backgroundCell.backgroundColor = model.primaryTypeName.color()
        self.secondaryType.isHidden = !model.hasTwoTypes
        self.artwork.kf.setImage(with: model.imageURL, placeholder: model.placeholder)
        
        self.primaryType.viewModel = TypeViewModel(pokemonType: model.primaryTypeName)
        
        guard let secondaryTypeColor = model.secondaryTypeName else { return }
        self.secondaryType.viewModel = TypeViewModel(pokemonType: secondaryTypeColor)
    }
    
    // MARK: Layout
    private func layout() {
        self.backgroundCell.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundCell.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.backgroundCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        self.backgroundCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        self.backgroundCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        
        self.artwork.translatesAutoresizingMaskIntoConstraints = false
        self.artwork.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.artwork.widthAnchor.constraint(equalToConstant: 90).isActive = true
        self.artwork.centerYAnchor.constraint(equalTo: self.backgroundCell.centerYAnchor).isActive = true
        self.artwork.leadingAnchor.constraint(equalTo: self.backgroundCell.leadingAnchor).isActive = true
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.bottomAnchor.constraint(equalTo: self.backgroundCell.centerYAnchor).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.artwork.rightAnchor, constant:  5).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.backgroundCell.rightAnchor, constant:  -5).isActive = true
        
        self.idLabel.translatesAutoresizingMaskIntoConstraints = false
        self.idLabel.topAnchor.constraint(equalTo: self.backgroundCell.topAnchor, constant: 5).isActive = true
        self.idLabel.rightAnchor.constraint(equalTo: self.backgroundCell.rightAnchor, constant:  -5).isActive = true
        
        self.primaryType.translatesAutoresizingMaskIntoConstraints = false
        self.primaryType.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5).isActive = true
        self.primaryType.leftAnchor.constraint(equalTo: self.artwork.rightAnchor, constant:  5).isActive = true
        
        self.secondaryType.translatesAutoresizingMaskIntoConstraints = false
        self.secondaryType.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5).isActive = true
        self.secondaryType.leftAnchor.constraint(equalTo: self.primaryType.rightAnchor, constant:  10).isActive = true
    }
}
