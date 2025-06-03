
import Foundation

struct PageResponse: Decodable {
    let code: Int
    let status: String
    let data: PageData
}

struct PageData: Decodable {
    let number: Int
    let ayahs: [PageAyah]
    let surahs: [String: PageSurah] 
    let edition: PageEdition
}

struct PageAyah: Decodable {
    let number: Int
    let text: String
    let surah: PageSurah
    let numberInSurah: Int
    let juz: Int
    let manzil: Int
    let page: Int
    let ruku: Int
    let hizbQuarter: Int
    let sajda: Bool
}

struct PageSurah: Decodable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let revelationType: String
    let numberOfAyahs: Int
}

struct PageEdition: Decodable {
    let identifier: String
    let language: String
    let name: String
    let englishName: String
    let format: String
    let type: String
    let direction: String
} 
