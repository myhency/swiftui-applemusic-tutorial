//
//  ContentView.swift
//  AppleMusicBottomSheet
//
//  Created by James on 2023/04/03.
//

import SwiftUI

struct Home: View {
    /// Animation Properties
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    var body: some View {
        TabView {
            /// Sample Tab's
            ListenNow()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Listen Now")
                }
                /// It should also work when we apply it to the entire TabView, but it's not working; this may be a bug, so apply it to each tab individually
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                /// Hiding tab bar when sheet is expanded
                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            SampleTabView("Browse", "square.grid.2x2.fill")
            SampleTabView("Radis", "dot.radiowaves.left.and.right")
            SampleTabView("Music", "play.square.stack")
            SampleTabView("Search", "magnifyingglass")
        }
        /// Changing Tab Indicator Color
        .tint(.red)
        .safeAreaInset(edge: .bottom) {
            CustomBottomSheet()
        }
        .overlay {
            if expandSheet {
                ExpandedBottomSheet(expandSheet: $expandSheet, animation: animation)
                    /// https://www.youtube.com/watch?v=fOaARtT3_a4
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
    }
    
    /// Custom listen now view
    @ViewBuilder
    func ListenNow() -> some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Image("Card 1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Image("Card 2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Image("Card 3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding()
                .padding(.bottom, 100)
            }
            .navigationTitle("Listen Now")
        }
    }
    
    /// Custom Bottom Sheet
    @ViewBuilder
    func CustomBottomSheet() -> some View {
        /// Animating Sheet Background (To Look Like It's expanding from the bottom)
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        /// Music Info
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
        .frame(height: 70)
        /// Separator Line
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(height: 1)
                .offset(y: -5)
        })
        /// 49: Default Tab Bar Height
        .offset(y: -49)
    }

    @ViewBuilder
    func SampleTabView(_ title: String, _ icon: String) -> some View {
        /// ios bug, it can be avoided by wrapping the view inside ScrollView
        ScrollView(.vertical, showsIndicators: false, content: {
            Text(title)
                .padding(.top, 25)
        })
        .tabItem {
            Image(systemName: icon)
            Text(title)
        }
        /// It should also work when we apply it to the entire TabView, but it's not working; this may be a bug, so apply it to each tab individually
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        /// Hiding tab bar when sheet is expanded
        .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

/// Reusable File
struct MusicInfo: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            /// Adding Matched Geometry Effect (Hero Animation)
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        /// 0$ 의 의미는 closure 의 첫 번째 parameter 의미. 즉, GeometryReader 의 첫 번째 parameter (GeometryProxy) 이다.
                        let size = $0.size
                        
                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            /// For smoother travel, the source view corner radius is updated from 5 to 15 in order to match the destination view corner radius, which is 15.
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                }
            }
            .frame(width: 45, height: 45)
            
            Text("Look What You Made Me do")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer(minLength: 0)
            
            Button {} label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            Button {} label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.leading, 5)
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            /// Expanding Bottom Sheet
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}
