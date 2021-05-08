//
//  recipe.swift
//  Pote
//
//  Created by macbook on 17.10.20.
//

import Foundation

struct RecipeListResults: Codable {
    let results: [RecipeResult]
}

struct RecipeResult: Codable {
    let id: Int
    let image: URL
    let title: String
}


struct RecipeDetails: Codable {
//    let vegetarian: Bool
    let vegan: Bool
    let veryHealthy: Bool
    let healthScore: Int
    let extendedIngredients: [Ingredients]
    let id: Int
    let readyInMinutes: Int
    let servings: Int
    let title: String
    let image: String
    
//    let instructions: String



}

struct Ingredients: Codable {
    let name: String
    let original: String
    let amount: Float
    let unit: String
    
}


struct Instructions: Codable {
    let steps: [AllSteps]
}

struct AllSteps: Codable {
    let step: String
}

struct TrendListResults: Codable {
    let recipes: [TrendRecipes]
}

struct TrendRecipes: Codable {
    let id: Int
    //let calories: Int
    //let fat: String
    let image: URL
    //let protein: String
    let title: String
}
