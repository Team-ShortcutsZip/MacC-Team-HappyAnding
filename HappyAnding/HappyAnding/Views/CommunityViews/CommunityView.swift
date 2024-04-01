//
//  CommunityView.swift
//  HappyAnding
//
//  Created by HanGyeongjun on 3/30/24.
//

import SwiftUI

struct CommunityView: View {
    
    @State var postTite: String = ""
    @State var postConetent: String = ""
    
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    
    var body: some View {
        ScrollView {
            writePostView()
        }
        .padding(.horizontal, 16)
        .background(Color.shortcutsZipBackground)
        .refreshable {
            //Add code
        }
    }
    
    @ViewBuilder
    private func writePostView() -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "square.2.layers.3d.bottom.filled")
            VStack(alignment: .leading, spacing: 4) {
                TextField("hello", text: $postTite)
                TextEditor(text: $postConetent)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .roundedBorder(cornerRadius: 12)
                        }
                    }
                }
                Divider()
                HStack(alignment: .center, spacing: 8) {
                    Button {
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "photo.badge.plus")
                    }
                    
                    Button {
                        //code
                    } label: {
                        Image(systemName: "square.2.layers.3d.bottom.filled")
                    }
                    
                    Spacer()
                    
                    Button {
                        //code
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.shortcutsZipPrimary)
                    }
                }
            }
        }
        .padding(.all, 8)
        .background(Color.white)
        .cornerRadius(16, corners: .allCorners)
        .sheet(isPresented: $showingImagePicker) {
            PhotoPicker(selectedImages: $selectedImages)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CommunityView()
}
