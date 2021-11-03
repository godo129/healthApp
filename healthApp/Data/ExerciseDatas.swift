//
//  ExerciseDatas.swift
//  healthApp
//
//  Created by hong on 2021/11/04.
//


let exerciseTypes: [String] = ["데드리프트","스쿼트","벤치프레스"]


func making () -> [String: [Int]]  {
    
    var exerciseTypesStorage: [String: [Int]] = [:]
    
    for idx in 0..<exerciseTypes.count {
        let storage: [Int] = []
        exerciseTypesStorage[exerciseTypes[idx]] = storage
    }
    
    return exerciseTypesStorage
}
