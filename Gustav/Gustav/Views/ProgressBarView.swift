//
//  ProgressBarView.swift
//  Gustav
//
//  Created by Dalibor Janeček on 25.02.2022.
//

import SwiftUI

struct ProgressBarView: View {
    
    @Binding var progress: Double
    
    var color: Color
    
    var body: some View {
            GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 10)
                        .foregroundColor(Color("GrayColor"))
                        .overlay {
                            HStack {
                                RoundedRectangle(cornerRadius: 20).foregroundColor(color)
                                    .frame(width: getProgress(geo: geometry))
                                if progress < 1.0 {
                                    Spacer()
                                }
                                
                                
                            }
                    }
            }
    }
    
    func getProgress(geo: GeometryProxy) -> Double {
        let maxWidth = geo.size.width
        let maxProgress = min(progress, 1.0)
        return max(maxWidth * maxProgress, 0.0)
    }
}



struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(progress: .constant(1.0), color: .red).padding()
    }
}
