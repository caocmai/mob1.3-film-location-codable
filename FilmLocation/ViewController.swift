//
//  ViewController.swift
//  FilmLocation
//
//  Created by Cao Mai on 4/13/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel!.text = films[indexPath.row].locations
        return cell
    }
    
    var films:[FilmEntry] = []
    var filmsDecoded:[FilmEntryCodable] = []

    
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDataFromFile("locations")
//        getDataFromFile2("locations")
        setUpTable()
    }
    
    func getDataFromFile(_ fileName: String){
        
        let path = Bundle.main.path(forResource: fileName, ofType: ".json")
        
        if let path = path {
          let url = URL(fileURLWithPath: path)
          print(url)
            
            
            let contents = try? Data(contentsOf: url)
            do {
              if let data = contents,
              let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] {
                print(jsonResult)
                
                
                for film in jsonResult{
                    let firstActor = film["actor_1"] as? String ?? ""
                    let locations = film["locations"] as? String  ?? ""
                    let releaseYear = film["release_year"] as? String  ?? ""
                    let title = film["title"] as? String  ?? ""
                    let movie = FilmEntry(firstActor: firstActor, locations: locations, releaseYear: releaseYear, title: title)
                    films.append(movie)

                }
                
              }
            } catch {
              print("Error deserializing JSON: \(error)")
            }
            
            
        }
        

    }
    
    func getDataFromFile2(_ fileName:String){
        let path = Bundle.main.path(forResource: fileName, ofType: ".json")
        if let path = path {
            let url = URL(fileURLWithPath: path)
            let contents = try? Data(contentsOf: url)
            if let data = contents{
                let decoder = JSONDecoder()
                do {
                    let filmsFromJSON = try decoder.decode([FilmEntryCodable].self, from: data)
                    filmsDecoded = filmsFromJSON
                    table.reloadData()
                } catch {
                    print("Parsing Failed")
                }
            }
        }
    }
    
    
    func setUpTable() {
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false

        table.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        
        table.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    
}

extension FilmEntry {
    init?(json: [String: Any]) {
        guard let locations = json["locations"] as? String,
            let a1 = json["actor_1"] as? String,
            let year = json["release_year"] as? String,
            let title = json["title"] as? String
            else{
                return nil
        }
        self.firstActor = a1
        self.releaseYear = year
        self.title = title
        self.locations = locations
    }
}
