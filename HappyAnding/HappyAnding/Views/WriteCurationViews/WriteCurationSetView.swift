//
//  WriteCurationSetView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct WriteCurationSetView: View {
    
    @StateObject var viewModel: WriteCurationViewModel
    
    var body: some View {
        VStack {
            ProgressView(value: 1, total: 2)
                .padding(.bottom, 26)
            
            listHeader
            infomation
            if viewModel.shortcutCells.isEmpty {
                Spacer()
                Text(TextLiteral.writeCurationSetViewNoShortcuts)
                    .shortcutsZipBody2()
                    .foregroundColor(.gray4)
                    .multilineTextAlignment(.center)
                Spacer()
                
            } else {
                shortcutList
            }
        }
        .background(Color.shortcutsZipBackground)
        .navigationTitle(viewModel.isEdit ? TextLiteral.writeCurationSetViewEdit : TextLiteral.writeCurationSetViewPost)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMakeCuration()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.isWriting.toggle()
                } label: {
                    Text(TextLiteral.cancel)
                        .shortcutsZipBody1()
                        .foregroundColor(.gray4)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Text(TextLiteral.next)
                    .navigationLinkRouter(data: viewModel, isPresented: $viewModel.isWriting)
                    .shortcutsZipHeadline()
                    .foregroundColor(viewModel.curation.shortcuts.isEmpty ? .shortcutsZipPrimary.opacity(0.3) : .shortcutsZipPrimary)
                    .disabled(viewModel.curation.shortcuts.isEmpty)
            }
        }
    }
    
    ///단축어 선택 텍스트 및 카운터
    var listHeader: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(TextLiteral.writeCurationSetViewSelectionTitle)
                .shortcutsZipSb()
                .foregroundColor(.gray5)
            Text(TextLiteral.writeCurationSetViewSelectionDescription)
                .shortcutsZipFootnote()
                .foregroundColor(.gray3)
            Spacer()
            Text("\(viewModel.curation.shortcuts.count)개")
                .shortcutsZipBody2()
                .foregroundColor(.shortcutsZipPrimary)
        }
        .padding(.horizontal, 16)
    }
    
    ///내가 작성한, 좋아요를 누른 단축어 목록
    var shortcutList: some View {
        
        ScrollView {
            ForEach(Array(viewModel.shortcutCells.enumerated()), id: \.offset) { index, shortcut in
                checkBoxShortcutCell(viewModel: viewModel, index: index)
            }
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden)
    }
    
    // MARK: - 안내문구
    var infomation: some View {
        Text(TextLiteral.writeCurationSetViewSelectionInformation)
            .frame(maxWidth: .infinity, alignment: .leading)
            .shortcutsZipBody2()
            .foregroundColor(.gray5)
            .padding(.all, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.gray1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private func checkBoxShortcutCell(viewModel: WriteCurationViewModel, index: Int) -> some View {
        
        ZStack {
            Color.shortcutsZipBackground
            
            HStack {
                Image(systemName: viewModel.isShortcutsTapped[index] ? "checkmark.square.fill" : "square")
                    .smallIcon()
                    .foregroundColor(viewModel.isShortcutsTapped[index] ? .shortcutsZipPrimary : .gray3)
                    .padding(.leading, 20)
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.fetchGradient(color: viewModel.shortcutCells[index].color))
                        .cornerRadius(8)
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: viewModel.shortcutCells[index].sfSymbol)
                        .mediumShortcutIcon()
                        .foregroundColor(.white)
                }
                .padding(.leading, 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.shortcutCells[index].title)
                        .shortcutsZipHeadline()
                        .foregroundColor(.gray5)
                        .lineLimit(1)
                    Text(viewModel.shortcutCells[index].subtitle)
                        .shortcutsZipFootnote()
                        .foregroundColor(.gray3)
                        .lineLimit(2)
                }
                .padding(.leading, 12)
                .padding(.trailing, 20)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.isShortcutsTapped[index] ? Color.shortcutsZipWhite : Color.backgroudList)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(viewModel.isShortcutsTapped[index] ? Color.shortcutsZipPrimary : Color.backgroudListBorder)
                    )
            )
            .padding(.horizontal, 16)
        }
        .onTapGesture {
            viewModel.checkboxCellTapGesture(index: index)
        }
        .padding(.top, 0)
        .background(Color.shortcutsZipBackground)
    }
}
