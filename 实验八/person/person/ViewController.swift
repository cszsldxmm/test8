//
//  ViewController.swift
//  person
//
//  Created by 7 on 2018/12/17.
//  Copyright © 2018 7. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var students = [Student]()
    var teachers = [Teacher]()
    var tableTitle = ["Teacher", "Student"]
    var table: UITableView!
    var rightItem: UIBarButtonItem!
    var alert: UIAlertController!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return teachers.count
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = tableTitle[indexPath.section]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            let style: UITableViewCell.CellStyle = (identifier == "Teacher") ? .subtitle : .default
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
            cell?.accessoryType = .disclosureIndicator
        }
        
        switch identifier {
        case "Teacher":
            cell?.textLabel?.text = teachers[indexPath.row].fullName
            cell?.detailTextLabel?.text = teachers[indexPath.row].title
        case "Student":
            cell?.textLabel?.text = students[indexPath.row].fullName
        default:
            break
        }
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableTitle[section]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for i in 1...3 {
            let temp = Teacher(title: "教授", firstName: "王", lastName: "\(i)", age: 28, gender: .female, department: .one)
            teachers.append(temp)
        }
        for i in 1..<5 {
            let temp = Student(stuNo: 201611040 + i, firstName: "孙", lastName: "\(i)", age: 18, gender: .male, department: .two)
            students.append(temp)
        }
        
        teachers.sort { return $0.fullName < $1.fullName }
        students.sort { return $0.fullName < $1.fullName }
        
        table = UITableView(frame: self.view.bounds)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        //导航栏控制器右边的按钮
        rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = rightItem
        
        //导航栏控制器左边的按钮
        let leftItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(addStudent))
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        
    }
    
    @objc func edit() {
        if table.isEditing {
            rightItem.title = "编辑"
            table.isEditing = false
        } else {
            rightItem.title = "完成"
            table.isEditing = true
        }
    }
    
    @objc func addStudent() {
        
        alert = UIAlertController(title: "添加学生", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "学生学号"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生姓"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生名"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生性别"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "学生年龄"
        }
        let OKBtn = UIAlertAction(title: "确定", style: .default) { (alert) in
            self.add()
        }
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(OKBtn)
        alert.addAction(cancelBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func add() {
        let no = Int(alert.textFields![0].text!)
        let firstName = alert.textFields![1].text!
        let lastName = alert.textFields![2].text!
        let gender: Gender
        switch alert.textFields![3].text! {
        case "男":
            gender = .male
        case "女":
            gender = .female
        default:
            gender = .unknow
        }
        let age = Int(alert.textFields![4].text!)
        let student = Student(stuNo: no!, firstName: firstName, lastName: lastName, age: age!, gender: gender)
        students.append(student)
        
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if indexPath.section == 0 {
                teachers.remove(at: indexPath.row)
            } else {
                students.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = tableTitle[indexPath.section]
        
        let name: String
        if indexPath.section == 0 {
            name = teachers[indexPath.row].fullName
        } else {
            name = students[indexPath.row].fullName
        }
        
        let message = "you selected \(category), name: \(name)"
        
        let alert = UIAlertController(title: "系统提示", message: message, preferredStyle: .alert)
        let OKBtn = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(OKBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section {
            tableView.reloadData()
        } else {
            if sourceIndexPath.section == 0 {
                teachers.insert(teachers.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            } else {
                students.insert(students.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            }
        }
    }

}

