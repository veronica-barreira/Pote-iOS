//
//  RecipeRequest.swift
//  Pote
//
//  Created by macbook on 19.10.20.
//

import Foundation

struct RecipeRequest {
    let resourceURL: URL
    let API_KEY = "395bca66702e4b0db1ad8aa45d74fa71"
    
//    init(cuisine: String) {
//
//        let resourceString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(API_KEY)&cuisine=\(cuisine)"
//        guard let resourceURL = URL(string: resourceString) else {fatalError()}
//        self.resourceURL = resourceURL
//    }
    
    init(query: String) {
        let resourceString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(API_KEY)&query=\(query)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
//    init(diet: String) {
//        let resourceString = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(API_KEY)&diet=\(query)"
//        guard let resourceURL = URL(string: resourceString) else {fatalError()}
//        self.resourceURL = resourceURL
//    }
    
    func getRecipes(completionHandler: @escaping (RecipeListResults) -> Void) {
        URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let entries = try JSONDecoder().decode(RecipeListResults.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(entries)
                    print(resourceURL)
                }
                
            }
            catch {
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
    }
}
