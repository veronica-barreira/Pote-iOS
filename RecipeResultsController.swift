//
//  RecipeResultsController.swift
//  Pote
//
//  Created by macbook on 17.10.20.
//

import Foundation
import UIKit

class RecipeResultsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var listOfRecipes: [RecipeResult] = []
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBar.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsController") as? DetailsController
//        vc?.name = listOfRecipes[indexPath.row].title
//        vc?.RecipeId = listOfRecipes[indexPath.row].id
//        self.navigationController?.pushViewController(vc!, animated: true)
        print("you tapped me")
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfRecipes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! MyCollectionViewCell
        
        if SearchBar.text != "" {
            cell.ResultsName.text = listOfRecipes[indexPath.row].title
        
            let imageURL = listOfRecipes[indexPath.row].image
            print(imageURL)
            cell.imageView.loadImage(url: imageURL)
        }
        
        else {
            print("empty")
        }
        
        return cell
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            return
        }
        let recipeRequest = RecipeRequest(query: searchBarText)
        print(searchBarText)
        
        URLSession.shared.dataTask(with: recipeRequest.resourceURL) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let entries = try JSONDecoder().decode(RecipeListResults.self, from: data)
                self.listOfRecipes = entries.results
                print(self.listOfRecipes)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsController, let index = collectionView.indexPathsForSelectedItems?.first {
            
            destination.RecipeId = listOfRecipes[index.row].id
            destination.name = listOfRecipes[index.row].title
        }
    }
}

extension UIImageView {
    func loadImage(url : URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

