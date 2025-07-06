//
//  main.swift
//  MacStorageXplorer
//
//  Created by Moddeeeeeeep on 05.07.2025.
//

import Foundation

func formatFileSize(_ size: Int64) -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useMB, .useGB, .useTB]
        byteCountFormatter.countStyle = .file
        return byteCountFormatter.string(fromByteCount: size)
}

func colorForSize(_ size: Int64) -> String {
    let GB: Int64 = 1024 * 1024 * 1024
    
    if size > 100 * GB {
        return "\u{001B}[31m" // Красный для больших файлов
    } else if size > 10 * GB {
        return "\u{001B}[33m" // Желтый
    } else if size > 1 * GB {
        return "\u{001B}[32m" // Зеленый
    } else {
        return "\u{001B}[36m" // Голубой для небольших файлов
    }
}

// Сброс цвета
let resetColor = "\u{001B}[0m"


var shouldExit = false

while(!shouldExit)
{
    print("\nВыберите действие:")
    print("1. Сканировать директорию")
    print("2. Выход")
    print("Введите номер опции: ", terminator: "")
    
    let choice = readLine() ?? ""
    
    switch choice{
    case "1":
            let path: String
            if CommandLine.arguments.count > 1 {
                path = CommandLine.arguments[1]
            } else {
                print("Введите путь к директории для сканирования (нажмите Enter для текущей директории):")
                let input = readLine() ?? ""
                path = input.isEmpty ? "/Users/Documents" : input
            }

        // Проверяем существование пути
            if !FileManager.default.fileExists(atPath: path) {
                print("Ошибка: Директория не найдена по пути \(path)")
                //exit(1)
                continue
            }

            print("Сканирование директории: \(path)")

        // Сканируем директорию
            let scanner = FileScanner()
            let fileInfos = scanner.scanDirectory(atPath: path)

        // Выводим результаты
            print("\nРезультаты (отсортированы по размеру):")
            print("-------------------------------------------")
            for fileInfo in fileInfos {
                let sizeString = formatFileSize(fileInfo.size)
                let colorCode = colorForSize(fileInfo.size)
                let icon = fileInfo.isDirectory ? "📁" : "📄"
            
                print("\(icon) \(fileInfo.name.padding(toLength: 40, withPad: " ", startingAt: 0)) \(colorCode)\(sizeString)\(resetColor)")
            }
    case "2":
            shouldExit = true
    default:
        print("Неверный выбор. Пожалуйста, выберите 1 или 2.")
    }
    
        
    
    

    
}


