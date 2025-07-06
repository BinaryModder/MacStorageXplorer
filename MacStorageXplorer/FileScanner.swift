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
                let fileInfo = try getFileInfromation(url: itemURL)
                FileInfosArray.append(fileInfo)
                
                
                
            }
            
            return FileInfosArray.sorted {$0.size > $1.size}
            
        }catch {os_log("Error scanning directory: %{public}@", log: log, type: .error, error.localizedDescription)
            return []}
        
        
    }
    
    private func getFileInfromation(url: URL) throws -> FileInformation
    {
        let resourcesValues = try url.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])
        let isDirectory = resourcesValues.isDirectory ?? false
        
        if isDirectory {
            let size = try calculateDirectorySize(url: url)
            return FileInformation(url:url, size: size, isDirectory: true)
        }
        else{
            let size = Int64(resourcesValues.fileSize ?? 0)
            return FileInformation(url: url, size: size, isDirectory: false)
        }
    }
    
    private func calculateDirectorySize(url: URL) throws -> Int64
    {
        let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey], options: [] )
        var totalSize : Int64 = 0
        
        for itemURL in contents
        {
            
            let resourcesValues = try itemURL.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])
            
            if resourcesValues.isDirectory ?? false {
                totalSize += try calculateDirectorySize(url: itemURL)
            }else{
                totalSize += Int64(resourcesValues.fileSize ?? 0)
            }
            
        }
        return totalSize
    }
    
}
