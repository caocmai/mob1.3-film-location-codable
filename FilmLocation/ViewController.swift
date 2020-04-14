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
        return filmsDecoded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel!.text = filmsDecoded[indexPath.row].locations + " " + filmsDecoded[indexPath.row].releaseYear.value
        return cell
    }
    
    var films:[FilmEntry] = []
    var filmsDecoded:[FilmEntryCodable] = []
    
    
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        getDataFromFile("locations")
        getDataFromFile2("locations")
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
                    if let movie = FilmEntry(json: film) {
                        films.append(movie)
                    }

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
                decoder.keyDecodingStrategy = .convertFromSnakeCase
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




// MY JSON
/*
{
    “festival”:
    [
        {
            “date”: “Oct 31 2020”,
            “name”: “Cool Movies”,
            “city”:
            {
                “name”: “Los Angelos”,
                “id”: 12334
            },
        
            “lineup”:
                [
                    {
                    “name”: “Forrest Gump”,
                    “id”: 1
                    },
                    {
                    “name”:  “The Shawshank Redemption”,
                    “id”: 2
                    }
                ],
            
            “type”: "music"
        },
    
        {
            “date”: “December 25 2020”,
            “name”: “Cool Games”,
            “city”:
            {
                “name”: “San Francisco”,
                “id”: 36472
            },
        
            “lineup”:
                [
                    {
                    “name”: “Gran Turismo”,
                    “id”: 1
                    },
                    {
                    “name”:  “Super Mario”,
                    “id”: 2
                    }
                ],
            
            “type”: "game"
            }
    ]
}

 */
