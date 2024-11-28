import SwiftUI

struct CustomTFComponent: View {
    @Binding var value: String
    var isemail: Bool = false
    var isUserName: Bool = false
    var reenter: Bool = false
    var isValidationCode: Bool = false
    var isConfirmPassword: Bool = false
    @State private var isPasswordVisible = false // State for password visibility toggle

    var body: some View {
        VStack(spacing: 8) {
            // Field Label
            HStack {
                Text(fieldLabel)
                    .foregroundColor(Color.black.opacity(0.3))
                Spacer()
            }

            HStack {
                // Dynamic TextField/SecureField based on field type
                if isemail || isUserName {
                    TextField("", text: $value)
                        .keyboardType(isemail ? .emailAddress : .default)
                        .autocapitalization(.none)
                } else if isValidationCode {
                    TextField("", text: $value)
                        .keyboardType(.numberPad)
                        .onChange(of: value) { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered.count > 6 {
                                value = String(filtered.prefix(6))
                            } else {
                                value = filtered
                            }
                        }
                } else {
                    Group {
                        if isPasswordVisible {
                            TextField("", text: $value) // TextField for visible password
                        } else {
                            SecureField("", text: $value) // SecureField for hidden password
                        }
                    }
                }

                // Trailing Icon/Button
                if isemail {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(Color("Color1"))
                } else if isUserName {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("Color1"))
                } else if !isemail && !isUserName && !isValidationCode {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(Color("Color1"))
                    }
                }
            }

            Divider()
        }
    }

    // Dynamic field label based on type
    private var fieldLabel: String {
        if isemail { return "Email ID" }
        if isUserName { return "Username" }
        if reenter { return "Re-Enter Password" }
        if isValidationCode { return "Validation Code" }
        if isConfirmPassword { return "Confirm Password" }
        return "Password"
    }
}
