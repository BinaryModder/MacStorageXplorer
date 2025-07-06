import Foundation

import os.log

class FileScanner
{
    private let fileManager = FileManager.default
    private let log = OSLog(subsystem: "com.moddeeeeeeep.MacStorageXplorer", category: "FileScanner")
    
    struct FileInformation
    {
        let url : URL
        let size : Int64
        let isDirectory : Bool
        
        var name : String {return url.lastPathComponent}
    }
    
    func scanDirectory(atPath path: String) -> [FileInformation]
    {
        do {
            let directoryURL = URL(fileURLWithPath: path)
            let contents = try fileManager.contentsOfDirectory(at: directoryURL , includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey], options: [])
            
            var FileInfosArray = [FileInformation]()
            
            for itemURL in contents
            {
                let fileInfo = try getFileInformation(for: itemURL)
                FileInfosArray.append(fileInfo)
                
                return FileInfosArray.sorted {$0.size > $1.size}
                
            }
            
            
        }catch {os_log("Error scanning directory: %{public}@", log: log, type: .error, error.localizedDescription)
            return []}
        
        
    }
    
    
}
