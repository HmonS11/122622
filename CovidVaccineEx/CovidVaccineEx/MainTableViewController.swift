//
//  MainTableViewController.swift
//  CovidVaccineEx
//
//  Created by runnysun on 2022/10/25.
//

import UIKit

class MainTableViewController: UITableViewController {
    @IBOutlet weak var btnNext: UIBarButtonItem!
    @IBOutlet weak var btnPrev: UIBarButtonItem!
    let serviceKey = "crvISqeM4ZGeUaXVitA19HO0ZousqjFZ%2FZyeSU5FWm6sYBSCK4CEEMwaUNYsZJ4WOkgrv9R2SgicAsjhlE%2Fnlg%3D%3D"
    var hospitals:[[String:String]] = []
    var hospital:[String:String] = [:]
    var key:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        //self.btnNext.isEnabled = !root.meta.is_end
        
    }

    @IBAction func actNext(_ sender: Any) {
        //page += 1
    }
    @IBAction func actPrev(_ sender: Any) {
        //page -= 1
    }
    func search(with query:String, page:Int) {
        guard let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let str = "https://api.odcloud.kr/api/apnmOrg/v1/list?page=\(page)&cond[orgZipaddr::LIKE]=\(q)&serviceKey=\(serviceKey)&returnType=XML"
               
                guard let url = URL(string: str) else { return }
        let requerst = URLRequest(url:url)
        let session = UISession.shared
        session.dataTask(with: request, _, error in
        guard let data = data

        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hospitals.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "covidcell", for: indexPath)
        let hospital = hospitals[indexPath.row]
        
        let lblName = cell.viewWithTag(1) as? UILabel
        lblName?.text = hospital["orgnm"]
       
        let lblAddress = cell.viewWithTag(2) as? UILabel
        lblAddress?.text = hospital["orgZipaddr"]
        
        let lblPhone = cell.viewWithTag(3) as? UILabel
        lblPhone?.text = hospital["orgUlno"]
        
        
        
        return cell
    }

}

extension MainTableViewController: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        hospitals = []
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item"{
            hospital = [:]  //초기화
        }else if elementName == "col" {
            self.key = attributeDict["name"]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let key = self.key{
            hospital[key] = string
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            hospitals.append(hospital)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        tableView.reloadData()
        
    }
}
