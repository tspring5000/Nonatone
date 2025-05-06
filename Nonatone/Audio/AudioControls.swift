import SwiftUI
import AudioKit
import SoundpipeAudioKit
import AVFoundation

class ParameterValue: ObservableObject {
    @Published var value: Float
    var parameter: AUParameter
    
    init(parameter: AUParameter) {
        self.parameter = parameter
        self.value = self.parameter.value
    }
}

struct MasterView: View {
    var conductor: Conductor
    @ObservedObject var handle: ParameterValue
    var verbParam: AUParameter
    
    init(cond: Conductor) {
        self.conductor = cond
        self.conductor.start()
        self.handle = ParameterValue(parameter: self.conductor.parameters.volumeFilter)
        self.verbParam = self.conductor.parameters.verb
        
        setVolumeFilter(value: self.handle.value)
        setVerb(value: self.verbParam.value)
        paramCallbacks()
    }
    
    func setVolumeFilter(value: Float) {
        let fixed_value = min(max(0.0, value), 1.0)
        self.conductor.mixer.volume = fixed_value
        self.conductor.filter.cutoffFrequency = (1.0 - fixed_value) * 6900.0
    }
    
    func setVerb(value: Float) {
        self.conductor.verb.dryWetMix = min(max(0.0, value), 1.0)
    }
    
    func paramCallbacks() {
        self.handle.parameter.implementorValueObserver = { _, v in
            DispatchQueue.main.async {
                self.handle.value = v
                setVolumeFilter(value: self.handle.value)
            }
        }
        
        self.verbParam.implementorValueObserver = { _, v in
            setVerb(value: v)
        }
    }
    
    var body: some View {
        BoxSlider(value: $handle.value, col: .orange)
            .onChange(of: handle.value) { _ in
                self.handle.parameter.value = self.handle.value
            }
    }
}

struct OscType {
    var wave: AudioKit.Table
    var colour: Color
    var amp: Float
}

struct OscView: View {
    var conductor: Conductor
    var osc: Oscillator
    @ObservedObject var handle: ParameterValue
    var ampParam: AUParameter
    @State private var wave_colour: Color
    
    init(cond: Conductor, oscType: OscType, freqP: AUParameter, ampP: AUParameter) {
        self.conductor = cond
        self.osc = Oscillator(waveform: oscType.wave)
        self.handle = ParameterValue(parameter: freqP)
        self.ampParam = ampP
        self.conductor.mixer.addInput(self.osc)
        self.wave_colour = oscType.colour
        
        setFreq(value: self.handle.value)
        if self.ampParam.value > 0.0 {
            setAmp(value: self.ampParam.value)
        } else {
            self.ampParam.value = oscType.amp
        }
        paramCallbacks()
    }
    
    func paramCallbacks() {
        self.handle.parameter.implementorValueObserver = { _, v in
            DispatchQueue.main.async {
                self.handle.value = v
                setFreq(value: self.handle.value)
            }
        }
        
        self.ampParam.implementorValueObserver = { _, v in
            setAmp(value: v)
        }
    }
    
    func setFreq(value: Float) {
        let fixed_value = min(max(0.0, value), 1.0)
        self.osc.frequency = fixed_value * 800.0
        if fixed_value <= 0.0 {
            if osc.isStarted {
                osc.stop()
            }
        } else if !osc.isStarted {
            osc.start()
        }
    }
    
    func setAmp(value: Float) {
        self.osc.amplitude = min(max(0.0, value), 1.0)
    }
    
    var body: some View {
        BoxSlider(value: $handle.value, col: wave_colour)
            .onChange(of: handle.value) { _ in
                self.handle.parameter.value = self.handle.value
            }
    }
}


struct AudioControlsPreview: View {
    var conductor: Conductor
    var parms: AllParameters
    
    init() {
        self.conductor = Conductor()
        self.parms = self.conductor.parameters
    }
    
    var body: some View {
        HStack {
            OscView(cond: conductor, oscType: OscType(wave: Table(.sawtooth), colour: .red, amp: 0.5),
                    freqP: parms.saw1Freq, ampP: parms.saw1Amp)
            MasterView(cond: conductor)
        }
        .padding()
    }
}

#Preview {
    AudioControlsPreview()
}
