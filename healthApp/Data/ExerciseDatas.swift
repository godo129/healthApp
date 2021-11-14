//
//  ExerciseDatas.swift
//  healthApp
//
//  Created by hong on 2021/11/04.
//


let exerciseTypes: [String] = ["데드리프트","스쿼트","벤치프레스","싯업","워킹"]


let exerciseParts = ["하체","복부","가슴","등","어깨","팔","유산소","기타"]

let exerciseAll: [String:[String]] = ["복부":["싯업","크런치","리버스 크런치","바이시클 크런치","플러터 킥","레그 레이즈","행잉 레그 레이즈","엘보 플랭크","힐 터치","할로우 포지션","할로우 락","토즈투 바","러시안 트위스트"],
                                         "하체":["런지","바벨 백스쿼트","프론트 스쿼트","스플릿 스쿼트","점프 스쿼트","컨벤셔널 데드리프트","스모 데드리프트","루마니안 데드리프트","레그 프레스","레그 컬","스텝업","바벨 스텝업","힙 쓰러스트"],
                                         "가슴": ["벤치프레스","인클라인 벤치프레스","덤벨 벤치프레스","인클라인 덤벨 벤치프레스","덤벨 플라이","인클라인 덤벨 플라이","덤벨 풀오버","푸시업","힌두 푸시업","아처 푸시업","케이블 크로스오버"],
                                         "등": ["풀업","친업","바벨 로우","덤벨 로우","펜들레이 로우","랫풀다운","시티드 케이블 로우","원암 덤벨 로우","인클라인 바벨 로우","인버티드 로우","바벨 풀오버","백 익스텐션","중량 하이퍼 익스텐션"],
                                         "어깨":["오버헤드 프레스","덤벨 숄더 프레스","덤벨 레터럴 레이즈","덤벨 프론트 레이즈","덤벨 슈러그","비하인드 넥 프레스","페이스 풀","케이블 리버스 플라이","바벨 업라이트 로우","벤트오버 덤벨 레터럴 레이즈","아놀드 덤벨 프레스","숄더 프레스 머신"],
                                         "팔":["클로즈 그립 벤치프레스","바벨 컬","덤벨 컬","덤벨 해머 컬","덤벨 리스트 컬","덤벨 삼두 익스텐션","케이블 삼두 익스텐션","시티드 덤벨 익스텐션","덤벨 킥백","케이블 푸시 다운","클로즈그립 푸시업","이지바 컬","케이브 컬","스컬 크러셔"],
                                         "기타":["버피","케틀벨 스윙","마운틴 클라이머"],
                                         "유산소":["싸이클","로잉머신"]]




struct ExerciseData {
    
    var ExerciseName: String
    var ExerciseImage: String
    var ExerciseType: String
    
    init(eType: String, eName: String, eImage: String) {
        ExerciseName = eName
        ExerciseType = eType
        ExerciseImage = eImage
    }
    
}






var exerciseTypesDataStorage: [String: [Int]] = [:]

func making () -> [String: [Int]]  {
    
    var exerciseTypesDataStorage: [String: [Int]] = [:]
    
    for idx in 0..<exerciseTypes.count {
        let storage: [Int] = []
        exerciseTypesDataStorage[exerciseTypes[idx]] = storage
    }
    
    return exerciseTypesDataStorage
}


