import SwiftUI
import AudioKit

struct MainView: View {
    var conductor: Conductor
    var parms: AllParameters
    
    let saw_osc = OscType(wave: Table(.sawtooth), colour: .red, amp: 0.75)
    let squ_osc = OscType(wave: Table(.square), colour: .blue, amp: 0.5)
    let sin_osc = OscType(wave: Table(.sine), colour: .green, amp: 1.0)
    
    init(conductor: Conductor) {
        self.conductor = conductor
        self.parms = self.conductor.parameters
    }
    
    let backgroundGradient = LinearGradient(
        colors: [
            .black,
            Color(red: 0.2, green: 0.2, blue: 0.2)
        ], startPoint: .bottomLeading, endPoint: .topTrailing
    )
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            HStack{
                VStack {
                    HStack {
                        OscView(cond: conductor, oscType: saw_osc,
                                freqP: parms.saw1Freq, ampP: parms.saw1Amp
                        )
                        OscView(cond: conductor, oscType: saw_osc,
                                freqP: parms.saw2Freq, ampP: parms.saw2Amp
                        )
                        OscView(cond: conductor, oscType: saw_osc,
                                freqP: parms.saw3Freq, ampP: parms.saw3Amp
                        )
                    }
                    HStack {
                        OscView(cond: conductor, oscType: squ_osc,
                                freqP: parms.squ1Freq, ampP: parms.squ1Amp
                        )
                        OscView(cond: conductor, oscType: squ_osc,
                                freqP: parms.squ2Freq, ampP: parms.squ2Amp
                        )
                        OscView(cond: conductor, oscType: squ_osc,
                                freqP: parms.squ3Freq, ampP: parms.squ3Amp
                        )
                    }
                    HStack {
                        OscView(cond: conductor, oscType: sin_osc,
                                freqP: parms.sin1Freq, ampP: parms.sin1Amp
                        )
                        OscView(cond: conductor, oscType: sin_osc,
                                freqP: parms.sin2Freq, ampP: parms.sin2Amp
                        )
                        OscView(cond: conductor, oscType: sin_osc,
                                freqP: parms.sin3Freq, ampP: parms.sin3Amp
                        )
                    }
                }
                .aspectRatio(1.0, contentMode: .fit)
                MasterView(cond: conductor)
                    .aspectRatio(CGSize(width: 1, height: 3), contentMode: .fit)
            }
            .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fit)
            .padding()
        }
    }
}
