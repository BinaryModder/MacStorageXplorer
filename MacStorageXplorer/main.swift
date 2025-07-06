
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
func checkPermissions() {
    print("Проверка прав доступа...")
    
    // Проверяем доступ к некоторым защищенным директориям
    let testPaths = [
        "/Library/Application Support",
        "/System/Library",
        "/Users/Shared"
    ]
    
    var hasFullAccess = true
    
    for path in testPaths {
        if FileManager.default.isReadableFile(atPath: path){
            continue
        } else {
            hasFullAccess = false
            break
        }
    }
    
    if !hasFullAccess {
        print("\n⚠️  Внимание: Обнаружены ограничения доступа")
        print("Для полного сканирования файловой системы необходим полный доступ к диску.")
        print("Инструкция по предоставлению доступа:")
        print("1. Откройте Системные настройки > Конфиденциальность и безопасность > Полный доступ к диску")
        print("2. Нажмите '+' и добавьте это приложение")
        print("3. Перезапустите приложение после предоставления доступа\n")
    } else {
        print("✅ Доступ к файловой системе получен")
    }
}

// Сброс цвета
let resetColor = "\u{001B}[0m"






checkPermissions()

//Основной цикл программы 
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
                print("Введите путь к директории для сканирования (нажмите Enter для вашей домашней директории):", terminator: "")
                let input = readLine() ?? ""
                path = input.isEmpty ? FileManager.default.homeDirectoryForCurrentUser.path : input
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


