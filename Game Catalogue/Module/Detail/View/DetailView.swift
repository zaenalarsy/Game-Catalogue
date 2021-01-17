//
//  DetailView.swift
//  Game Catalogue
//
//  Created by Zaenal Arsy on 12/01/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var presenter: DetailPresenter
  @State var showingAlert = false
  @State var alertMessage: AlertOneMessage = AlertOneMessage()

  var body: some View {
    ZStack {
      Color(UIColor.Ext.Blue)
      VStack {
        if presenter.loadingState {
          loadingIndicator
        } else {
          if let detail = presenter.detailGame {
            mainContent(detail: detail)
            Spacer()
          } else {
            Text("Empty Data")
              .foregroundColor(.white)
              .font(.largeTitle)
          }
        }
      }
    }
    .alert(isPresented: $showingAlert) {
      Alert(title: Text(alertMessage.title), message: Text(alertMessage.message), dismissButton: .default(Text(alertMessage.buttonText)))
    }
    .onAppear {
      if presenter.detailGame == nil {
        presenter.getDetailGame()
      }
    }
    .navigationBarTitle(
      Text("Detail Game"),
      displayMode: .inline
    )
    .navigationBarItems(leading: Button(
                          action: {
                            presentationMode.wrappedValue.dismiss()
                          }, label: {
                            Image(systemName: "chevron.left")
                              .foregroundColor(.white)
                              .imageScale(.large)
                          }),
                        trailing: Button(
                          action: {
                            presenter.favouriteGame { result in
                              self.alertMessage = result
                              self.showingAlert = true
                            }
                          }, label: {
                            if presenter.game.favourite {
                              Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            } else {
                              Image(systemName: "heart")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            }
                          })
    )
    .navigationBarBackButtonHidden(true)
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

extension DetailView {
    var loadingIndicator: some View {
      VStack {
        Text("Loading...")
          .bold()
          .foregroundColor(.white)
        ActivityIndicator()
      }
    }
    func mainContent(detail: DetailGameModel) -> some View {
      VStack {
        ScrollView {
          ZStack(alignment: .bottomTrailing) {
            gameImage(url: detail.imageUrl)
            rating(rating: detail.rating)
          }.padding(.vertical, 20)
          infoDetail(title: "Name: ", value: detail.name)
          infoDetail(title: "Released At: ", value: detail.releasedAt)
          HStack {
            Text("Description")
              .foregroundColor(.white)
              .padding(.leading, 20)
            Spacer()
          }.padding(.vertical, 2)
          HStack {
            Text(detail.description)
              .foregroundColor(.white)
              .fontWeight(.semibold)
              .padding(.leading, 20)
            Spacer()
          }.padding(.vertical, 2)
        }
        Spacer()
      }
      .padding(10)
    }
    func infoDetail(title: String, value: String) -> some View {
      HStack {
        Text(title)
          .foregroundColor(.white)
          .padding(.leading, 20)
        Text(value)
          .foregroundColor(.white)
          .fontWeight(.semibold)
        Spacer()
      }
    }
    func rating(rating: String) -> some View {
      VStack {
        ZStack {
          Color(UIColor.Ext.Cream)
          HStack(alignment: .center, spacing: 6) {
            Text(rating)
              .font(.callout)
              .padding(.horizontal, 2)
            Image(systemName: "star.fill")
              .resizable()
              .foregroundColor(Color(UIColor.Ext.DarkBlue))
              .frame(width: 16, height: 16, alignment: .center)
              .padding(.horizontal, 2)
          }
        }
      }
      .cornerRadius(10, corners: [.topLeft, .bottomRight])
      .frame(width: 90, height: 30)
    }
    func gameImage(url: String) -> some View {
      WebImage(url: URL(string: url))
        .resizable()
        .indicator(.activity)
        .cornerRadius(10, corners: [.allCorners])
        .shadow(color: Color(UIColor.Ext.DarkBlue), radius: 6, x: 4, y: 4)
        .transition(.fade(duration: 0.5))
        .frame(width: 220.0, height: 110.0, alignment: .center)
    }
}
