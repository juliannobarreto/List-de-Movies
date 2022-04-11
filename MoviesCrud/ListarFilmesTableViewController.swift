//
//  ListarFilmesTableViewController.swift
//  MoviesCrud
//
//  Created by user212674 on 4/4/22.
//

import UIKit
import CoreData

class ListarFilmesTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var filmes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarFilmes()
    }
    
    func recuperarFilmes() {
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Salvamento")
        let ordenacao = NSSortDescriptor(key: "texto", ascending: false)
            requisicao.sortDescriptors = [ordenacao]
       
            
        do {
            let filmesRecuperados = try context.fetch(requisicao)
            self.filmes = filmesRecuperados as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch let erro {
            print("Erro ao recuperar os filmes: \(erro.localizedDescription)")
        }
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.filmes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        let filme = self.filmes[indice]
        self.performSegue(withIdentifier: "verFilmes", sender: filme)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verFilmes"  {
            
            let  viewDestino = segue.destination as! AdicionarFilmesViewController
            viewDestino.filme = sender as? NSManagedObject
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)

        let filme = self.filmes[indexPath.row]
        let textoRecuperado = filme.value(forKey: "texto")
        celula.textLabel?.text = textoRecuperado as? String

        return celula
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle  == UITableViewCell.EditingStyle.delete {
            
            let indice = indexPath.row
            let filme = self.filmes[indice]
            
            self.context.delete(filme)
            self.filmes.remove(at: indice)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do{
                try self.context.save()
                print("O filme foi deletado com sucesso!")
            } catch let erro {
                print("Erro ao deletar o filme \(erro)")
            }
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
