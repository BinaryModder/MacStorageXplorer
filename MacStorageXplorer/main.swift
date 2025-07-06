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
