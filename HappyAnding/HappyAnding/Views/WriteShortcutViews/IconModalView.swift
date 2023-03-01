//
//  IconModalView.swift
//  HappyAnding
//
//  Created by 이지원 on 2022/10/19.
//

import SwiftUI

struct IconModalView: View {
    
    @Binding var isShowingIconModal: Bool
    @Binding var iconColor: String
    @Binding var iconSymbol: String
    
    @State var selectedCategory = "개인정보 보호 및 보안"
    
    private let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    private let symbols = [
        "기호": ["square.2.layers.3d", "barcode", "qrcode", "square.and.arrow.down.fill", "square.and.arrow.up.fill", "info.circle.fill", "face.smiling", "xmark.square", "doc.richtext", "square.grid.2x2.fill", "ellipsis", "checklist", "square.grid.4x3.fill", "rays", "circle.dotted", "peacesign", "airplayaudio", "airplayvideo", "music.note.list", "music.note", "waveform.path", "slowmo", "timelapse", "plus.square.fill.on.square.fill", "qrcode.viewfinder"],
        "연결": ["chart.bar.fill", "externaldrive.connected.to.line.below.fill", "network", "icloud.fill", "dot.radiowaves.right", "dot.radiowaves.up.forward", "wifi"],
        "기기": ["car.fill", "car.2.fill", "bolt.car.fill", "applewatch", "laptopcomputer", "keyboard", "printer.fill", "server.rack", "tv.fill", "gamecontroller.fill", "headphones", "headphones.circle.fill", "hifispeaker.fill", "tv.and.hifispeaker.fill", "earpods", "airpods", "airpodspro", "appletv.fill", "homepod.fill", "applewatch.radiowaves.left.and.right", "iphone", "iphone.radiowaves.left.and.right", "apps.iphone", "ipad", "ipad.landscape", "ipod"],
        "카메라 및 사진": ["photo.fill", "camera.fill", "bolt.fill", "photo.fill.on.rectangle.fill", "photo.on.rectangle.angled", "camera.aperture", "chevron.backward.circle.fill", "chevron.right.circle.fill", "chevron.up.circle.fill", "chevron.down.circle.fill", "arrow.down.right.and.arrow.up.left", "arrow.triangle.2.circlepath", "camera.filters", "livephoto.play", "livephoto"],
        "수학": ["plus.circle.fill"],
        "인덱스": ["questionmark.circle.fill", "dollarsign.circle.fill", "eurosign.circle.fill", "sterlingsign.circle.fill", "yensign.circle.fill", "bitcoinsign.circle.fill", "p.square.fill", "t.square.fill"],
        "인간": ["shoeprints.fill", "tshirt.fill", "figure.stand", "figure.roll", "person.fill", "person.2.fill", "person.3.sequence.fill", "figure.dance", "figure.strengthtraining.traditional", "figure.snowboarding", "figure.pool.swim", "figure.hiking", "figure.walk", "figure.run", "figure.run.circle.fill", "brain.head.profile", "brain", "hand.raised.fill", "hand.raised.slash.fill", "hand.raised.slash", "hand.thumbsup.fill", "hand.point.up.braille.fill"],
        "교통": ["car.fill", "car.2.fill", "bolt.car.fill", "bus.fill", "bus.doubledecker.fill", "tram.fill", "bicycle", "airplane", "fuelpump.fill", "figure.walk"],
        "도형": ["square.fill", "square"],
        "손쉬운 사용": ["figure.roll", "hand.point.up.braille.fill", "arrow.up.and.down.and.arrow.left.and.right", "quote.bubble.fill", "quote.bubble"],
        "자동차": ["car.fill", "car.2.fill", "bolt.car.fill", "fuelpump.fill", "key.fill", "exclamationmark.triangle.fill"],
        "상업": ["cart.fill", "bag.fill", "creditcard.fill", "dollarsign.circle.fill", "eurosign.circle.fill", "sterlingsign.circle.fill", "yensign.circle.fill", "bitcoinsign.circle.fill"],
        "날씨": ["sun.max.fill", "moon.fill", "moon.circle.fill", "cloud.fill", "cloud.rain.fill"],
        "시간": ["clock.fill", "alarm.fill", "stopwatch.fill", "hourglass", "timer", "timer.square"],
        "피트니스": ["gamecontroller.fill", "trophy.fill", "figure.roll", "figure.dance", "figure.strengthtraining.traditional", "figure.skiing.crosscountry", "figure.snowboarding", "figure.pool.swim", "figure.hiking", "figure.walk", "figure.run", "figure.run.circle.fill"],
        "게임": ["house.fill", "gamecontroller.fill", "plus.circle.fill", "xmark.circle.fill", "circle.circle"],
        "편집": ["wand.and.stars", "wand.and.rays", "paintbrush.fill", "pencil", "scissors", "eyedropper.halffull", "bandage.fill", "crop", "slider.horizontal.3", "camera.filters", "square.and.pencil", "dial.low.fill", "dial.high.fill"],
        "통신": ["video.fill", "mic.fill", "message.fill", "text.bubble.fill", "envelope.fill", "envelope.open.fill", "phone.fill", "arrow.up.message.fill", "arrow.up.message", "plus.message.fill", "quote.bubble.fill", "quote.bubble", "waveform"],
        "미디어": ["play.rectangle.fill", "play.fill", "play.circle.fill", "backward.circle.fill", "stop.circle.fill", "forward.circle.fill", "infinity", "shuffle"],
        "텍스트 포맷": ["list.bullet", "character.textbox"],
        "홈": ["house.fill", "lightbulb.fill", "stove.fill", "bathtub.fill", "shower.fill", "bed.double.fill"],
        "자연": ["sun.max.fill", "moon.fill", "moon.circle.fill", "cloud.fill", "cloud.rain.fill", "flame.fill", "bolt.fill", "drop.fill", "atom", "pawprint.fill"],
        "키보드": ["sun.max.fill", "globe", "keyboard", "power.circle.fill", "command", "command.circle.fill", "command.square.fill"],
        "개인정보 보호 및 보안": ["key.fill", "lock.fill", "lock.open.fill", "hand.raised.fill", "hand.raised.slash.fill", "hand.raised.slash", "exclamationmark.triangle.fill", "checkmark.circle.fill", "nosign"],
        "사물 및 도구": ["building.2.fill", "cart.fill", "takeoutbag.and.cup.and.straw.fill", "bag.fill", "fork.knife", "fuelpump.fill", "umbrella.fill", "binoculars.fill", "film.fill", "camera.fill", "doc.on.clipboard.fill", "calendar", "paperplane.fill", "paperplane.circle.fill", "briefcase.fill", "folder.fill", "folder", "folder.badge.gearshape", "creditcard.fill", "printer.fill", "internaldrive.fill", "externaldrive.connected.to.line.below.fill", "archivebox.fill", "cube.fill", "gamecontroller.fill", "puzzlepiece.fill", "puzzlepiece.extension.fill", "headphones", "headphones.circle.fill", "speaker.wave.1.fill", "speaker.wave.2.fill", "speaker.wave.3.fill", "speaker.slash.fill", "speaker.fill", "books.vertical.fill", "book.fill", "book.closed.fill", "eyeglasses", "ticket.fill", "theatermasks.fill", "dice.fill", "lifepreserver.fill", "clock.fill", "alarm.fill", "stopwatch.fill", "bell.fill", "trophy.fill", "lightbulb.fill", "flag.fill", "tag.fill", "key.fill", "hourglass", "lock.fill", "lock.open.fill", "battery.100", "wand.and.stars", "wand.and.rays", "paintbrush.fill", "pencil", "paperclip", "scissors", "magnifyingglass", "link", "eyedropper.halffull", "hammer.fill", "gear", "screwdriver.fill", "trash.fill", "cup.and.saucer.fill", "stove.fill", "tshirt.fill", "bathtub.fill", "shower.fill", "pills.fill", "cross.vial.fill", "bandage.fill", "stethoscope", "syringe.fill", "facemask.fill", "graduationcap.fill", "gift.fill", "bed.double.fill", "map.fill", "speedometer", "barometer", "note", "note.text", "note.text.badge.plus", "radio.fill", "bookmark.fill", "doc", "doc.text.fill", "doc.text", "mappin.and.ellipse", "crop", "camera.filters", "calendar.badge.plus", "calendar.badge.exclamationmark", "timer", "timer.square", "square.and.pencil", "dial.low.fill", "dial.high.fill", "camera.viewfinder", "wallet.pass.fill"],
        "건강": ["cross.fill", "heart.fill", "pills.fill", "cross.vial.fill", "bandage.fill", "syringe.fill", "facemask.fill", "bed.double.fill", "brain.head.profile", "brain", "staroflife"],
        "화살표": ["arrowshape.turn.up.left.fill", "arrowshape.turn.up.right.fill", "chevron.backward.circle.fill", "chevron.right.circle.fill", "chevron.up.circle.fill", "chevron.down.circle.fill", "arrow.3.trianglepath", "location.fill", "arrow.down.right.and.arrow.up.left", "arrow.up.and.down.and.arrow.left.and.right", "arrow.2.squarepath", "arrow.triangle.2.circlepath", "arrow.triangle.turn.up.right.diamond.fill", "arrow.triangle.turn.up.right.circle.fill"]
    ]
    
    private let colors = [
        "Red",
        "Coral",
        "Orange",
        "Yellow",
        "Green",
        "Mint",
        "Teal",
        "Cyan",
        "Blue",
        "Purple",
        "LightPurple",
        "Pink",
        "Gray",
        "Khaki",
        "Brown"
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    self.isShowingIconModal = false
                } label: {
                    Text(TextLiteral.close)
                        .foregroundColor(.gray5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                }
                
                Text(TextLiteral.iconModalViewTitle)
                    .shortcutsZipHeadline()
                    .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 24)
            
            ScrollView(.vertical) {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.gray1)
                        .cornerRadius(UIScreen.main.bounds.size.height > 700 ? 20 : 12.35)
                        .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                    
                    Rectangle()
                        .fill(Color.fetchGradient(color: iconColor))
                        .cornerRadius(UIScreen.main.bounds.size.height > 700 ? 20 : 12.35)
                        .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                    
                    Image(systemName: iconSymbol)
                        .font(.system(size: UIScreen.main.bounds.size.height > 700 ? 48 : 32))
                        .frame(width: UIScreen.main.bounds.size.height > 700 ? 136 : 84, height: UIScreen.main.bounds.size.height > 700 ? 136 : 84)
                        .foregroundColor(.textIcon)
                }
                .padding(.bottom, 24)
                
                Text(TextLiteral.iconModalViewColor)
                    .shortcutsZipSubtitle()
                    .padding(.horizontal, 16)
                    .foregroundColor(.gray4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: gridLayout, spacing: 12) {
                    ForEach(colors, id: \.self) { item in
                        ColorCell(iconColor: $iconColor, paletteColor: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                Text(TextLiteral.iconModalViewIcon)
                    .shortcutsZipSubtitle()
                    .padding(.horizontal, 16)
                    .foregroundColor(.gray4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(symbols.keys.sorted(), id: \.self) { item in
                            Button(action: {
                                selectedCategory = item
                            }, label: {
                                Text(item)
                                    .shortcutsZipBody2()
                                    .foregroundColor(Color.shortcutsZipWhite)
                            })
                            .buttonStyle(.bordered)
                            .background(item == selectedCategory ? Color.gray3 : Color.gray1)
                            .cornerRadius(12)
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .padding(.horizontal, 16)
                
                LazyVGrid(columns: gridLayout, spacing: 12) {
                    ForEach(symbols[selectedCategory] ?? [], id: \.self) { item in
                        SymbolCell(iconSymbol: $iconSymbol, paletteSymbol: item)
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            Button(action: {
                isShowingIconModal = false
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty ? .shortcutsZipPrimary : .shortcutsZipPrimary.opacity(0.13))
                        .frame(maxWidth: .infinity, maxHeight: 52)
                    
                    Text(TextLiteral.done)
                        .foregroundColor(!iconColor.isEmpty && !iconSymbol.isEmpty ? .textButton : .textButtonDisable )
                        .shortcutsZipBody1()
                }
            })
            .disabled(iconColor.isEmpty || iconSymbol.isEmpty)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.shortcutsZipBackground)
    }
    
    struct ColorCell: View {
        @Binding var iconColor: String
        
        let paletteColor: String
        
        var body: some View {
            Button(action: {
                iconColor = paletteColor
            }, label: {
                ZStack {
                    Rectangle()
                        .fill(Color.fetchGradient(color: paletteColor))
                        .cornerRadius(8)
                        .frame(width: 36, height: 36)
                    
                    if paletteColor == iconColor {
                        Image(systemName: "checkmark")
                            .smallIcon()
                            .foregroundColor(.textIcon)
                    }
                }
            })
        }
    }
    
    struct SymbolCell: View {
        @Binding var iconSymbol: String
        
        let paletteSymbol: String
        
        var body: some View {
            Button(action: {
                iconSymbol = paletteSymbol
            }, label: {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(paletteSymbol == iconSymbol ? Color.gray1 : Color.clear)
                        .cornerRadius(8)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: paletteSymbol)
                        .foregroundColor(paletteSymbol == iconSymbol ? Color.gray5 : Color.gray3)
                }
            })
        }
    }
}

struct IconModalView_Previews: PreviewProvider {
    static var previews: some View {
        IconModalView(isShowingIconModal: .constant(true), iconColor: .constant("LightPurple"), iconSymbol: .constant("bus.fill"))
    }
}
