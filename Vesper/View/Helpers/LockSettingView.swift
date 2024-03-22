//
//  AppLockView.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/21.
//

import SwiftUI

struct LockSettingView: View {
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    @AppStorage("lockPin") private var lockPin: String = ""
    @AppStorage("lockType") private var lockType: LockType = .both
    /// For Sliding Effect
    @Namespace private var animation
    /// View Properties
    @State private var activeLockType: LockType = .both
    @State private var changePin: Bool = false
    @State private var pin: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 12) {
                Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                
                if isAppLockEnabled {
                    Toggle("Lock When App Goes Background", isOn: $lockWhenAppGoesBackground)
                    
                    LockTypeSlider()
                    
                    if lockType != .biometric {
                        pinView()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("App Lock")
        .tint(appTint)
        .background(.gray.opacity(0.15))
        .onAppear {
            if activeLockType != lockType {
                activeLockType = lockType
            }
        }
        .sheet(isPresented: $changePin, content: {
            changeLockPinView()
                .presentationDetents([.medium])
        })
    }
    
    @ViewBuilder
    func changeLockPinView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                        .frame(width: 50, height: 55)
                        .overlay {
                            /// Safe Check
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.primary)
                            }
                        }
                        .onTapGesture {
                            changePin.toggle()
                        }
                }
            }
            .padding(.top, 15)
            
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            /// Adding Number to Pin
                            /// Max Limit - 4
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if pin.count < 4 {
                            pin.append("0")
                        }
                    }, label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .foregroundStyle(.primary)
                    
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    })
                    .foregroundStyle(.primary)
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    /// Validate Pin
                    lockPin = pin
                    pin = ""
                    changePin = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .frame(height: 410)
    }
    
    @ViewBuilder
    func pinView() -> some View {
        HStack {
            Text("Pin:")
            
            Spacer()
            
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
                    .frame(width: 50, height: 55)
                    .overlay {
                        /// Safe Check
                        if lockPin.count > index {
                            let index = lockPin.index(lockPin.startIndex, offsetBy: index)
                            let string = String(lockPin[index])
                            
                            Text(string)
                                .font(.title.bold())
                                .foregroundStyle(.primary)
                        }
                    }
                    .onTapGesture {
                        changePin.toggle()
                    }
            }
        }
        .frame(height: 40)
        .padding(.top, 12)
        .hSpacing(.leading)
    }
    
    @ViewBuilder
    func LockTypeSlider() -> some View {
        GeometryReader { geo in
            let size = geo.size
            let tabWidth: CGFloat = size.width / CGFloat(LockType.allCases.count)
            
            HStack(spacing: 0) {
                ForEach(LockType.allCases, id: \.rawValue) { type in
                    Text("\(type.rawValue)")
                        .foregroundStyle(type.rawValue == activeLockType.rawValue ? Color.white : Color.primary)
                        .frame(width: tabWidth, height: 32)
                        .padding(.vertical, 4)
                        .background {
                            ZStack {
                                if type.rawValue == activeLockType.rawValue {
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .fill(appTint)
                                        .matchedGeometryEffect(id: "ACTIVELOCKTYPE", in: animation)
                                }
                            }
                            .animation(.snappy, value: activeLockType)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            activeLockType = type
                            lockType = activeLockType
                        }
                }
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .shadow(color: .primary.opacity(0.15), radius: 5, x: 0, y: 3)
        }
    }
}

#Preview {
    NavigationStack {
        LockSettingView()
    }
}
