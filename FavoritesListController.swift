//
//  FavoritesList.swift
//  Pote
//
//  Created by macbook on 09.11.20.
//

import Foundation
import UIKit
import CoreData

// Data from the table
var favoritesItems: [Favorites] = []

class FavoritesListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    var favoritesTitles = ""
    var favoritesImages = ""
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        
        fetchFavorites()
        print(favoritesItems)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchFavorites), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
    }
    
    
    @objc func fetchFavorites() {

        // Fetch the data from Core Data to display in the cell
        do {
            favoritesItems = try context.fetch(Favorites.fetchRequest())
            DispatchQueue.main.async {
                self.favCollectionView.reloadData()
            }
        }
        catch let error {
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsController") as? DetailsController
//
//        vc?.name = favoritesItems[indexPath.row].title!
//        print(favoritesItems[indexPath.row].title!)
//        vc?.RecipeId = Int(favoritesItems[indexPath.row].id)
//        print(Int(favoritesItems[indexPath.row].id))
//        self.navigationController?.pushViewController(vc!, animated: true)
//
//        collectionView.deselectItem(at: indexPath, animated: true)
        print("you tapped me")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as! MyCollectionViewCell
        
        cell.ResultsName?.text = favoritesItems[indexPath.row].title
        print(favoritesItems[indexPath.row].title!)
        
        let imageURL = URL(string: (favoritesItems[indexPath.row].image!))
        cell.imageView?.loadImage(url: imageURL!)
    
        return cell
    }
    
    
    // Reload Data when new favorite added
    
    
    // Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailsController, let index = favCollectionView.indexPathsForSelectedItems?.first {
            
            dest.RecipeId = Int(favoritesItems[index.row].id)
            dest.name = favoritesItems[index.row].title!
            
        }
    }
}

