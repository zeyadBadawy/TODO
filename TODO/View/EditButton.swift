//
//  EditButton.swift
//  TODO
//
//  Created by Zeyad Badawy on 14/05/2022.
//

import SwiftUI

struct EditButton: View {
    @Binding var editMode: EditMode

    var body: some View {
        Button {
            switch editMode {
            case .active: editMode = .inactive
            case .inactive: editMode = .active
            default: break
            }
        } label: {
            if let isEditing = editMode.isEditing, isEditing {
                Text("Done")
            } else {
                Text("Edit")
            }
        }
    }
}
