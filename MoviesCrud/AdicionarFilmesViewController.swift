//
//  AdicionarFilmesViewController.swift
//  MoviesCrud
//
//  Created by user212674 on 4/4/22.
//

import UIKit
import CoreData
        // Salvar os dados.
class AdicionarFilmesViewController: UIViewController {
    
    @IBOutlet weak var texto: UITextView!
    
    var context: NSManagedObjectContext!
    var filme: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cofigurações iniciais.
        self.texto.becomeFirstResponder()
        //Atualizar.
        if filme != nil {
            
            if let filmeRecuperado = filme.value(forKey: "texto") {
                self.texto.text = String(describing: filmeRecuperado)
            }
        }else{
            self.texto.text = ""
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    @IBAction func salvar(_ sender: Any) {
        
        if filme != nil {// atualizar
            self.atualizarFilme()
        }else{
            self.salvarFilme()
        }
        // Retorna para atela inicial.
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func atualizarFilme() {
        // Adicionar filmes.
        filme.setValue(self.texto.text, forKey: "texto")
        
        do {
            try context.save()
            print("Sucesso ao atualizar o filme!")
        } catch let erro {
            print("Erro ao atualizar o filme!: \(erro.localizedDescription)")
        }
        
    }
        /// Método que salva os dados.
    func salvarFilme() {
        /// Cria objeto para filme
        let NovoFilme = NSEntityDescription.insertNewObject(forEntityName: "Salvamento", into: context)
        /// Configura os filmes.
        NovoFilme.setValue(self.texto.text, forKey: "texto")
        
        do {
            try context.save()
            print("Sucesso ao salvar os filmes!")
        } catch let erro {
            print("Erro ao salvar o filme: \(erro.localizedDescription)")
        }
    }
}
