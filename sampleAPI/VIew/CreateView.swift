//
//  ContentView.swift
//  sampleAPI
//
//  Created by kazuya on 2020/11/01.
//

import SwiftUI

struct CreateView: View {
    
    @State var zipcode = ""
    @State var address01 = ""
    @State var address02 = ""
    
    @ObservedObject var createVM = CreateViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        TextField("Please input zipcode", text: $zipcode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 15)
                        Button(action: {
                            // api request
                            self.createVM.getAddress(self.zipcode) {
                                if !self.createVM.isPresented {
                                    self.address01 = self.createVM.addressString
                                }
                            }
                        }){
                            Text("Search")
                                .frame(width: 60, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color.white)
                        }.background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .sheet(isPresented: self.$createVM.isPresented,
                               onDismiss: {
                                self.address01 = self.createVM.addressString
                               }) {
                            AddressListView(addressStrings: self.$createVM.addressArrayStrings,
                                            createVM: self.createVM)
                        }
                        .alert(isPresented: self.$createVM.alertStruct.showAlert) {
                            Alert(title: Text("\(self.createVM.alertStruct.alertTitle)"),
                                  message: Text("\(self.createVM.alertStruct.alertMsg)"))
                        }
                    }
                    TextField("Please input your address01", text: $address01)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 15)
                    TextField("Please input your address02", text: $address02)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 15)
                    Button(action: {
                        // save action
                    }){
                        Text("save")
                            .frame(width: UIScreen.main.bounds.width - 30,
                                   height: 40)
                            .foregroundColor(Color.white)
                    }.background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                }
                .navigationBarTitle("プロフィール登録", displayMode: .inline)
            }
        }
    }
}

struct AddressListView: View {
    @Binding var addressStrings: [String]
    @ObservedObject var createVM: CreateViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            List(addressStrings, id: \.self) { address in
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.createVM.addressString = address
                }) {
                    Text("\(address)")
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}