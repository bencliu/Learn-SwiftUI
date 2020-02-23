//
//  RecipeDetailView.swift
//  My Favourite Recipes
//
//  Created by Chris Barker on 12/12/2019.
//  Copyright © 2019 Packt. All rights reserved.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @State var recipe = RecipeModel()
        
    @State private var viewIndex = 0
    @State private var angle: Double = 0
    @State private var image: Image?
    
    private var isFavourite: Bool {
        return recipe.favourite
    }
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appData: AppData
            
    var body: some View {
        
        // VStack so we can list our components vertically
        VStack(alignment: .center, spacing: 15) {
            
            // Image (currently using flag)
            image?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 400, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                        
            // Favourites Button
            Button(action: {
                self.appData.fontColor = self.isFavourite ? .orange : .black
                self.recipe.favourite.toggle()
                self.appData.updateRecipe(recipe: self.recipe)
                withAnimation(.spring()) {
                    self.angle = self.angle == 1080 ? 0 : 1080
                }
            }) {
                Image(systemName: isFavourite ? "star.fill" : "star")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .rotationEffect(.degrees(angle))
            .frame(height: 45)
                        
            // Name of our recipe
            Text("\(recipe.name)")
                .font(.title)
                .foregroundColor(self.appData.fontColor)
                    
            // Recipe origin
            Text("Origin: \(recipe.origin)")
                .font(.subheadline)
                .padding(.leading, 10)
            
            
            // Picker to choose between Igredients & Recipe
            Picker(selection: $viewIndex.animation(), label: Text("")) {
                Text("Ingredients").tag(0)
                Text("Recipe").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            
            // Logic to determin which Picker View to show.
            if viewIndex == 0 {
                List(recipe.ingredients, id: \.self) { ingredient in
                    Image(systemName: "hand.point.right")
                    Text(ingredient)
                }
                .listStyle(GroupedListStyle())
            } else if viewIndex == 1 {
                Text(recipe.recipe)
                    .padding(15)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .onAppear(perform: loadImage)

    }
        
    private func loadImage() {
        withAnimation(Animation.easeIn(duration: 1.6)) {
            self.image = Image(uiImage: recipe.image)
        }
    }
    
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipe: Helper.mockRecipes().first!)
    }
}
