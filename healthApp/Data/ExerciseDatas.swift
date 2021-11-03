//
//  ExerciseDatas.swift
//  healthApp
//
//  Created by hong on 2021/11/04.
//


let exerciseTypes: [String] = ["데드리프트","스쿼트","벤치프레스"]

var exerciseTypesDataStorage: [String: [Int]] = [:]

func making () -> [String: [Int]]  {
    
    var exerciseTypesDataStorage: [String: [Int]] = [:]
    
    for idx in 0..<exerciseTypes.count {
        let storage: [Int] = []
        exerciseTypesDataStorage[exerciseTypes[idx]] = storage
    }
    
    return exerciseTypesDataStorage
}
