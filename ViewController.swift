//
//  ViewController.swift
//  Pote
//
//  Created by macbook on 17.10.20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var trendRecipes: [TrendRecipes] = []
    var Inspirations: [TrendRecipes] = []
    var dessert: [TrendRecipes] = []
    var allRecipes: [TrendRecipes] = []
    
    
    var arrSections = ["THE TREND OF THE MOMENT", "VEGI INSPIRATION?", "A LITTLE SWEETNESS?", "ALL RECIPES"]

    @IBOutlet weak var FavoritesView: UITabBarItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet var appTitle: UILabel!
    @IBOutlet weak var cView1: UICollectionView!
    @IBOutlet var Label2: UILabel!
    @IBOutlet weak var cView2: UICollectionView!
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var cView3: UICollectionView!
    @IBOutlet weak var Label4: UILabel!
    @IBOutlet weak var cView4: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cView1.dataSource = self
        cView1.delegate = self
        cView2.dataSource = self
        cView2.delegate = self
        cView3.delegate = self
        cView3.dataSource = self
        cView4.dataSource = self
        cView4.delegate = self
        
        loadTrendOfMoment()
        loadInspirations()
        loadDesserts()
        loadAllRecipes()
        
        Label1.text = arrSections[0]
        Label2.text = arrSections[1]
        Label3.text = arrSections[2]
        Label4.text = arrSections[3]
        
    }
    


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsController") as? DetailsController
        
        if collectionView == self.cView1 {
            vc?.name = trendRecipes[indexPath.row].title
            vc?.RecipeId = trendRecipes[indexPath.row].id
            self.navigationController?.pushViewController(vc!, animated: true)
            print("you tapped me")
        }
        if collectionView == self.cView2 {
            vc?.name = Inspirations[indexPath.row].title
            vc?.RecipeId = Inspirations[indexPath.row].id
            self.navigationController?.pushViewController(vc!, animated: true)
            print("you tapped me")
        }
        
        if collectionView == self.cView3 {
            vc?.name = dessert[indexPath.row].title
            vc?.RecipeId = dessert[indexPath.row].id
            self.navigationController?.pushViewController(vc!, animated: true)
            print("you tapped me")
        }
        
        if collectionView == self.cView4 {
            vc?.name = allRecipes[indexPath.row].title
            vc?.RecipeId = allRecipes[indexPath.row].id
            self.navigationController?.pushViewController(vc!, animated: true)
            print("you tapped me")
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.cView1 {
            return trendRecipes.count
        }
        
        if collectionView == self.cView2 {
            return Inspirations.count
        }
        
        if collectionView == self.cView3 {
            return dessert.count
        }
        
        if collectionView == self.cView4 {
            return allRecipes.count
        }
        
        return allRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InitCollectionViewCell
        
        if collectionView == cView1 {
            cell.trendLabel.text = trendRecipes[indexPath.row].title
            let trendImG = trendRecipes[indexPath.row].image
            print(trendRecipes[indexPath.row].image)
            print(trendRecipes[indexPath.row].title)
            print(trendRecipes[indexPath.row].id)

            cell.trendImage.loadingImage(url: trendImG)
        }
        if collectionView == cView2 {
            let cell = cView2.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InitCollectionViewCell
            cell.trendLabel.text = Inspirations[indexPath.row].title
            let cusIMG = Inspirations[indexPath.row].image
            cell.trendImage.loadingImage(url: cusIMG)
            return cell
        }
        
        if collectionView == cView3 {
            cell.trendLabel.text = dessert[indexPath.row].title
            let cusIMG = dessert[indexPath.row].image
            cell.trendImage.loadingImage(url: cusIMG)
            return cell
        }
        
        if collectionView == cView4 {
            cell.trendLabel.text = allRecipes[indexPath.row].title
            let trendImG = allRecipes[indexPath.row].image
            cell.trendImage.loadingImage(url: trendImG)
        }
        return cell
    }
    

    
    func loadTrendOfMoment() {
        guard let myURL = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=395bca66702e4b0db1ad8aa45d74fa71&number=5&tags=autumn") else { return }

    URLSession.shared.dataTask(with: myURL) { (data, response, error) in
            guard let data = data else {
                return

            }
            do {
                let moments = try JSONDecoder().decode(TrendListResults.self, from: data)
                self.trendRecipes = moments.recipes
                print(self.trendRecipes)
                DispatchQueue.main.async {
                    self.cView1.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()

    }
    
    
    
    func loadInspirations() {
        guard let urlINS = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=395bca66702e4b0db1ad8aa45d74fa71&number=5&tags=vegetarian") else {
            return
        }
        URLSession.shared.dataTask(with: urlINS) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendListResults.self, from: data)
                self.Inspirations = results.recipes
                    DispatchQueue.main.async {
                    self.cView2.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    
    
    func loadDesserts() {
        guard let urlINS = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=395bca66702e4b0db1ad8aa45d74fa71&number=5&tags=dessert") else {
            return
        }
        URLSession.shared.dataTask(with: urlINS) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendListResults.self, from: data)
                self.dessert = results.recipes
                    DispatchQueue.main.async {
                    self.cView3.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    
    func loadAllRecipes() {
        guard let urlINS = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=395bca66702e4b0db1ad8aa45d74fa71&number=10") else {
            return
        }
        URLSession.shared.dataTask(with: urlINS) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendListResults.self, from: data)
                self.allRecipes = results.recipes
                    DispatchQueue.main.async {
                    self.cView4.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
}

extension UIImageView {
    func loadingImage(url : URL) {
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
