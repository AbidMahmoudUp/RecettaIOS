import SwiftUI
import PhotosUI

struct InventoryViewUI: View {
    @StateObject var inventoryViewModel = InventoryViewModel()
    @StateObject var scannerViewModel = ScannerViewModel()
    @State private var isRefreshing = false
    @State private var navigateToAddIngredient = false
    @State private var initialIngredientUpdateDto = IngredientUpdateDto(ingredients: [])
    @State private var isSelectionMode = false
    @State private var selectedIngredients: [String: Int] = [:]
    @State private var navigateToRecipeList = false
    @State private var isLoading = false
    @State private var progress: Float = 0.0
    @State private var showError = false
    @State private var generatedRecipes: [Recipe] = []
    @State private var isImagePickerPresented = false
    @State private var isImagePickerRecipePresented = false
    @State private var selectedImage: UIImage?
    @State private var isLoadingRecipe = false
    @State private var updateSuccessRecipe = false
    @State private var recipes: [Recipe] = []
    @State private var navigateToGeneratedRecipes = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top bar with navigation and title
                HStack(spacing: 0) {
                    Text("Food Manager")
                        .font(.headline)
                        .padding(.leading, 8)
                    Spacer()
                    Image(systemName: "camera.viewfinder")
                        .font(.title)
                        .padding(.trailing, 16)
                        .onTapGesture {

                            isImagePickerPresented = true
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerPresented,
                                        uploadImageAction: uploadImage,
                                        startLoading: {
                                                            isLoading = true // Start the animation when the image is picked
                                                        })
                        }
                    Image(systemName: "takeoutbag.and.cup.and.straw") // Dish icon
                           .onTapGesture {

                               isImagePickerRecipePresented = true
                           }
                           .font(.title)
                           .sheet(isPresented: $isImagePickerRecipePresented) {
                               ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerRecipePresented,
                                           uploadImageAction: uploadRecipe,
                                           startLoading: {
                                                               isLoadingRecipe = true // Start the animation when the image is picked
                                                           })
                           }
                }
                .padding()
                .background(Color.white)
               
                

                HStack {
                    if isSelectionMode {
                        Button(action: {
                            // Exit selection mode
                            isSelectionMode = false
                            selectedIngredients.removeAll()
                        }) {
                            Text("Done")
                                .font(.headline)
                                .padding(.leading, 16)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button(action: {
                            // Prepare IngredientRecipe list
                            let ingredientRecipes = selectedIngredients.map { key, value in
                                IngredientRecipe(ingredient: inventoryViewModel.inventory?.ingredients.first(where: { $0.ingredient.id == key })?.ingredient, qte: value)
                            }
                            // Pass the ingredient list to the next view
                            initialIngredientUpdateDto.ingredients = Set(ingredientRecipes)
                            Task{await generateRecipeOnBackground()}
                        }) {
                            Text("Generate")
                                .font(.headline)
                                .padding(.trailing, 16)
                        }
                    } else {
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.leading, 16)
                        Spacer()
                        Text("Add ingredient")
                            .font(.headline)
                            .padding(.trailing, 16)
                            .foregroundColor(Color.orange)
                            .onTapGesture {
                                // Set the state to navigate
                                navigateToAddIngredient = true
                            }
                    }
                }

                // NavigationLink to AddIngredientViewUI when Add Ingredient is tapped
                NavigationLink(destination: AddIngredientViewUI(
                    inventoryViewModel: inventoryViewModel,
                    ingredientViewModel: IngredientViewModel(), listIngredientQte: initialIngredientUpdateDto // pass the appropriate ViewModel
                ).navigationBarBackButtonHidden(), isActive: $navigateToAddIngredient) {
                }

                // Display inventory or empty state
                if let inventory = inventoryViewModel.inventory {
                    if inventory.ingredients.isEmpty {
                                            NoIngredientSection(
                                                image: "crying_tomato",
                                                title: "No Ingredients Found",
                                                description: "We couldn't find any ingredients in your inventory. Add some to get started!"
                                            )
                    } else {
                        
                        VStack {
                            // Pull-to-refresh feature
                            ScrollView {
                                VStack {
                                    ForEach(inventory.ingredients, id: \.ingredient.id) { ingredientQte in
                                        IngredientCardUIViewComponent(
                                            ingredient: ingredientQte,
                                            isSelectionMode: $isSelectionMode,
                                            selectedIngredients: $selectedIngredients
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                    }
                                }
                                .refreshable {
                                    // Trigger the refresh action
                                    await refreshInventory()
                                }
                            }
                        }
                    } } else if let errorMessage = inventoryViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Loading inventory...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .background(Color.white)
            .onAppear {
                Task {
                    if let userId = AuthManager.shared.getUserId() {
                        await inventoryViewModel.fetchInventory(userId: userId)
                    }
                }
            }
            .overlay(
                            RecipeGenerationLoadingView(progress: $progress, isLoading: $isLoading)
                                .edgesIgnoringSafeArea(.all)
                        )
            
            
            
            NavigationLink(
                       destination: GeneratedRecipeListViewUI(recipes: generatedRecipes),
                       isActive: $navigateToRecipeList
                   ) {
                       EmptyView()
                   }
            NavigationLink(
                           destination: GeneratedRecipeListViewUI(recipes: recipes),
                           isActive: $navigateToGeneratedRecipes
                       ) {
                           EmptyView()
                       }

        }.overlay(
            Group {
                if isLoading || isLoadingRecipe {
                    RecipeGenerationLoadingView(progress: $progress, isLoading: isLoading ? $isLoading : $isLoadingRecipe)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                }
            })

    }

    private func uploadImage(_ selectedImage: UIImage) async {
        isLoading = true // Show loading indicator
        
        defer {
            isLoading = false // Hide loading indicator when the task completes
        }

        guard let imageData = selectedImage.jpegData(compressionQuality: 1.0) else {
            print("Error: Unable to convert image to data.")
            return
        }

        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let tempFileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString + ".jpg")

        do {
            try imageData.write(to: tempFileURL)

            var body = Data()
            let boundary = "Boundary-\(UUID().uuidString)"
            let boundaryPrefix = "--\(boundary)\r\n"

            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(tempFileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(try Data(contentsOf: tempFileURL))
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            let userId = AuthManager.shared.getUserId() ?? ""
            let url = URL(string: "\(Constants.baseURL)/inventory/updateInventoryWithImage/\(userId)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            request.httpBody = body

            let session = URLSession.shared
            
            // Use async/await to wait for the response
            let (data, response) = try await session.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Upload successful")
               
            } else {
                print("Failed with response: \(response)")
            }
            await inventoryViewModel.fetchInventory(userId: AuthManager.shared.getUserId() ?? "")
            try FileManager.default.removeItem(at: tempFileURL)
        } catch {
            print("Error writing file or uploading: \(error)")
        }
    }


    private func uploadRecipe(_ selectedImage: UIImage) async {
        isLoadingRecipe = true // Show loading indicator
        
        defer {
            isLoadingRecipe = false // Hide loading indicator when the task completes
        }

        guard let imageData = selectedImage.jpegData(compressionQuality: 1.0) else {
            print("Error: Unable to convert image to data.")
            return
        }

        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let tempFileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString + ".jpg")

        do {
            // Write the image data to a temporary file
            try imageData.write(to: tempFileURL)
            
            var body = Data()
            let boundary = "Boundary-\(UUID().uuidString)"
            let boundaryPrefix = "--\(boundary)\r\n"
            
            // Add the multipart form-data parts
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"fileImage\"; filename=\"\(tempFileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(try Data(contentsOf: tempFileURL))
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            // Prepare the URL and the request
            let url = URL(string: "\(Constants.baseURL)/generative-ia-recipe")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Set necessary headers for the request
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            request.httpBody = body

            let session = URLSession.shared
            
            // Use async/await to wait for the response
            let (data, response) = try await session.data(for: request)
            
            // Print the response for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                print("Response headers: \(httpResponse.allHeaderFields)")
            }
            
            // Decode the response data into a Recipe instance
            let decoder = JSONDecoder()
            do {
                let recipe = try decoder.decode(Recipe.self, from: data)
                print("Decoded Recipe: \(recipe)")
                DispatchQueue.main.async {
                    self.recipes = [recipe]  // Store the recipe list in a state or view model
                    self.navigateToGeneratedRecipes = true  // Trigger the navigation
                }

            } catch {
                print("Error decoding response: \(error)")
            }

            // Clean up the temporary file
            try FileManager.default.removeItem(at: tempFileURL)
            
        } catch {
            print("Error writing file or uploading: \(error)")
        }
    }




    // Refresh action
    private func refreshInventory() async {
        Task{
            if let userId = AuthManager.shared.getUserId() {
                // Update the inventory
                await inventoryViewModel.fetchInventory(userId: userId)
            }
        }
    }

    // Generate recipes in background
      private func generateRecipeOnBackground() async {
          isLoading = true
          progress = 0.0
          let recipeViewModel = RecipeViewModel()
          let maxLoadingTime: TimeInterval = 30.0
          let startTime = Date()

          do {
              try await recipeViewModel.generateRecipe(ingredients: initialIngredientUpdateDto.ingredients)

              while isLoading {
                  let elapsed = Date().timeIntervalSince(startTime)
                  if elapsed >= maxLoadingTime {
                      isLoading = false
                      showError = recipeViewModel.generatedRecipes.isEmpty
                      break
                  }

                  if !recipeViewModel.generatedRecipes.isEmpty {
                      DispatchQueue.main.async {
                          self.generatedRecipes = recipeViewModel.generatedRecipes
                          self.isLoading = false
                          self.navigateToRecipeList = true
                      }
                      break
                  }

                  progress = Float(elapsed / maxLoadingTime)
                  try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
              }
          } catch {
              isLoading = false
              print("Error generating recipes: \(error.localizedDescription)")
          }
      }
}

struct NoIngredientSection: View {
    let image: String // Image name from assets
    let title: String
    let description: String

    var body: some View {
        VStack {
            Spacer() // Push content to the center
                .frame(height: 175) // Equivalent spacing at the top
            
            Image(image) // Replace with your asset name
                .resizable()
                .frame(width: 89, height: 94)
                .padding(.bottom, 12) // Space below the image
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 12) // Space below the title
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 112 / 255, green: 108 / 255, blue: 108 / 255))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity) // Make the column take the full width
        .padding() // Add padding around the content
    }
}
#Preview {
    InventoryViewUI()
}







struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    var uploadImageAction: ((UIImage) async -> Void) // Closure to handle image upload
    var startLoading: () -> Void // Closure to start the animation

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    if let selectedImage = image as? UIImage {
                        self?.parent.selectedImage = selectedImage
                        
                        // Start the loading animation when the image is selected
                        self?.parent.startLoading()
                        
                        // Call the uploadImage action asynchronously
                        Task {
                            await self?.parent.uploadImageAction(selectedImage)
                        }
                    }
                }
            }
        }
    }
}
