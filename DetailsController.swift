//
//  DetailsController.swift
//  Pote
//
//  Created by macbook on 30.10.20.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard
var favIDs = defaults.array(forKey: "SavedFav")

class DetailsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Reference to managed obejct context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var Ingred: [Ingredients] = []
    var ToDo: [AllSteps] = []
    var name = ""
    var RecipeId: Int = 0
    var stringArray = ""
    var favorites: Bool = false
    var imageURL = ""
    
    
    @IBOutlet weak var RecipePhoto: UIImageView!
    @IBOutlet weak var RecipeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wNeeded: UILabel!
    @IBOutlet weak var IngCollectionView: UICollectionView!
    @IBOutlet weak var howTodo: UILabel!
    @IBOutlet weak var LabelText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelText.text = ""
        titleLabel.text = name
        checkFav()
        
        IngCollectionView.delegate = self
        IngCollectionView.dataSource = self

        print("Recipe ID: ", RecipeId)
        
        loadIngredients()
        loadInstructions()
        print("Name: ", name)
        
        
    }


    @IBAction func toggleFav(_ sender: UIButton) {
        if favorites {
            favorites = false
            defaults.set(false, forKey: String(RecipeId))
            favButton.tintColor = .gray
            removeFavorite()
            

        }
        else {
            favorites = true
            defaults.set(true, forKey: String(RecipeId))
            favButton.tintColor = .red
            addNewFavorites()
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Ingred.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let IngCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredCell", for: indexPath) as! IngredCollectionViewCell
        IngCell.amountLabel.text = Ingred[indexPath.row].original
        
        return IngCell
    }


    
    func loadIngredients() {
        
        guard let myURL = URL(string: "https://api.spoonacular.com/recipes/\(RecipeId)/information?apiKey=395bca66702e4b0db1ad8aa45d74fa71") else { return }

        URLSession.shared.dataTask(with: myURL) { (data, response, error) in
            guard let data = data else {
                return }
            do {
                let moments = try JSONDecoder().decode(RecipeDetails.self, from: data)
                DispatchQueue.main.async {
                    for ingredientes in moments.extendedIngredients {
                        self.Ingred.append(ingredientes)
                        self.IngCollectionView.reloadData()
                        self.imageURL = moments.image
                        let detailIMG = URL(string: moments.image)
                        self.RecipePhoto.loadImage(url: detailIMG!)
                        self.timeLabel.text = String(moments.readyInMinutes) + "min."
                        self.servingLabel.text = String(moments.servings) + "servings"

                    }
                }
                
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    
    func loadInstructions() {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(RecipeId)/analyzedInstructions?apiKey=395bca66702e4b0db1ad8aa45d74fa71") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode([Instructions].self, from: data)
                DispatchQueue.main.async {
                    for entry in results {
                        for result in entry.steps {
                            self.ToDo.append(result)
                        }
                    }
                    self.stringArray = self.ToDo.map({ $0.step }).joined(separator: "\n")
                    print("stringarray:", self.stringArray)
                    self.LabelText.text = self.stringArray
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
        
    }
    
    
    func checkFav() {
        let favKey = String(RecipeId)
        let savedData = defaults.bool(forKey: favKey)
        favorites = savedData
        if favorites == true {
            favButton.tintColor = .red
        }
        
        else {
            favButton.tintColor = .gray
        }
    }
    
    func addNewFavorites() {
        // Create new favorite
        let newFavorite = Favorites(context: self.context)
        newFavorite.title = self.name
        newFavorite.id = Int32(self.RecipeId)
        newFavorite.image = self.imageURL
        
        // Save the data
        do {
            try self.context.save()
            print("saved completed")
        }
        catch {
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    func removeFavorite() {
        // Which favorite to remove
        for item in favoritesItems {
            if item.id == RecipeId {
                self.context.delete(item)
            }
        }
        // Save the data
        do {
            try self.context.save()
        }
        catch {
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
}
