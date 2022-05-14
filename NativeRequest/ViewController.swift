//
//  ViewController.swift
//  NativeRequest
//
//  Created by Erendira Cruz Reyes on 13/05/22.
//

import UIKit
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:ri, for:indexPath)
        let dict = personajes[indexPath.row]
        cell.textLabel?.text = dict["name"] as? String ?? "Un personaje"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "detalle", sender: self)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nuevoVC = segue.destination as! DetalleController
                // Pass the selected object to the new view controller.
                if let indexPath = tablev.indexPathForSelectedRow {
                    let personaje = personajes[indexPath.row]
                    nuevoVC.personaje = personaje
                    tablev.deselectRow(at: indexPath, animated: true)
                }
    }
}
class ViewController: UIViewController{
    
var tablev = UITableView()
    var personajes = [[String:Any]]()
    let ri = "reuseId"
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = InternetStatus.instance
        // Do any additional setup after loading the view.
        tablev.frame = self.view.bounds
        self.view.addSubview(tablev)
        tablev.register(UITableViewCell.self, forCellReuseIdentifier: ri)
        tablev.dataSource = self
        tablev.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if InternetStatus.instance.internetType == .none {
            let alert = UIAlertController(title: "ERRRORRRRRR!!!", message: "no hay conexión a internet!!!!!!", preferredStyle: .alert)
            let boton = UIAlertAction(title: "Ok", style: .default) { alert in
                // se cierra el app (es como provocar un crash)
                exit(666)
            }
            alert.addAction(boton)
            self.present(alert, animated:true)
        }
        else if InternetStatus.instance.internetType == .cellular {
            let alert = UIAlertController(title: "Confirme", message: "Solo hay conexión a internet por datos celulares", preferredStyle: .alert)
            let boton1 = UIAlertAction(title: "Continuar", style: .default) { alert in
                self.descargar()
            }
            let boton2 = UIAlertAction(title: "Cancelar", style: .cancel)
            alert.addAction(boton1)
            alert.addAction(boton2)
            self.present(alert, animated:true)
        }
        else {
            self.descargar()
        }
    }
    func descargar(){
        if let url = URL (string: "https://rickandmortyapi.com/api/character"){
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            let sesion = URLSession.shared
            let tarea = sesion.dataTask(with: request as URLRequest){
                datos, respuesta, error in
                if error != nil {
                    print("algo salio mal 1\(error?.localizedDescription)")
                }
                else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: datos!, options: .fragmentsAllowed) as! [String : Any]
                        print(json)
                        self.personajes = json["results"] as! [[String:Any]]
                        DispatchQueue.main.async {
                            self.tablev.reloadData()
                        }
                        
                    }catch{
                        print("algo salio mal 2.0")
                    }
                }
            }
            tarea.resume()
        }
    }

}

