//
//  DetalleController.swift
//  NativeRequest
//
//  Created by Erendira Cruz Reyes on 14/05/22.
//

import UIKit
/*extension UIImageView {
    func load(url: URL) {
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
}*/
class DetalleController: UIViewController {
    @IBOutlet weak var ivPersonaje: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var genero: UILabel!
    @IBOutlet weak var especie: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var type: UILabel!
    var personaje = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNombre?.text = personaje["name"] as? String ?? "Un personaje"
        genero.text = personaje["gender"] as? String ?? "Un genero"
        especie.text = personaje["species"] as? String ?? "Un especie"
        status.text = personaje["status"] as? String ?? "Un status"
        type.text = personaje["type"] as? String ?? "Un tipo"
        let url = URL(string: personaje["image"] as! String)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            ivPersonaje.image = image
        }catch let error as NSError {
            print(error)
        }


        

    }
    

}
