////
////  CoreDataDBFeedBack.swift
////  MdFahimFaezAbir-30028
////
////  Created by Bjit on 13/1/23.
////
//
//import Foundation
//
//class UserDBHelper{
//
//    static let shared = UserDBHelper()
//    private init(){}
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    func addUser(userId: Int,userName: String, userEmail: String, userPassword: String){
//        let user = User(context: context)
//        user.userId = Int32(userId)
//        user.userName = userName
//        user.userEmail = userEmail
//        user.userPassword = userPassword
//        do {
//            try context.save()
//            print("Saved")
//
//        }catch {
//            print(error)
//        }
//    }
//    func getAllUser()-> [User]?{
//        var user = [User]()
//        do{
//            user = try context.fetch(User.fetchRequest())
//            return user
//        }catch{
//            print(error)
//            return nil
//        }
//    }
//
//
//}
