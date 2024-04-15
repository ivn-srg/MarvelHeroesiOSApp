//
//  HeroDao.swift
//  MarvelHeroesApp
//
//  Created by Sergey Ivanov on 12.04.2024.
//

import Foundation

protocol HeroDAO {
    func saveHeroes(heroes: [HeroModel]) -> (Bool)
    func getHeroes()-> [HeroModel]
}
