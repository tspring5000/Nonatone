import Foundation
import AVFoundation

class AllParameters {
    
    // --- Master parameters --- //
    let volumeFilter = buildParameter(id: "volumefilter", name: "VolumeFilter", addr: 0)
    let verb = buildParameter(id: "verb", name: "Reverb", addr: 1)
    
    // --- Oscillator parameters --- //
    // Saw
    let saw1Freq = buildParameter(id: "saw1freq", name: "Saw1 Frequency", addr: 2)
    let saw1Amp = buildParameter(id: "saw1amp", name: "Saw1 Amplitude", addr: 3)
    let saw2Freq = buildParameter(id: "saw2freq", name: "Saw2 Frequency", addr: 4)
    let saw2Amp = buildParameter(id: "saw2amp", name: "Saw2 Amplitude", addr: 5)
    let saw3Freq = buildParameter(id: "saw3freq", name: "Saw3 Frequency", addr: 6)
    let saw3Amp = buildParameter(id: "saw3amp", name: "Saw3 Amplitude", addr: 7)
    // Square
    let squ1Freq = buildParameter(id: "squ1freq", name: "Square1 Frequency", addr: 8)
    let squ1Amp = buildParameter(id: "squ1amp", name: "Square1 Amplitude", addr: 9)
    let squ2Freq = buildParameter(id: "squ2freq", name: "Square2 Frequency", addr: 10)
    let squ2Amp = buildParameter(id: "squ2amp", name: "Square2 Amplitude", addr: 11)
    let squ3Freq = buildParameter(id: "squ3freq", name: "Square3 Frequency", addr: 12)
    let squ3Amp = buildParameter(id: "squ3amp", name: "Square3 Amplitude", addr: 13)
    // Sine
    let sin1Freq = buildParameter(id: "sin1freq", name: "Sine1 Frequency", addr: 14)
    let sin1Amp = buildParameter(id: "sin1amp", name: "Sine1 Amplitude", addr: 15)
    let sin2Freq = buildParameter(id: "sin2freq", name: "Sine2 Frequency", addr: 16)
    let sin2Amp = buildParameter(id: "sin2amp", name: "Sine2 Amplitude", addr: 17)
    let sin3Freq = buildParameter(id: "sin3freq", name: "Sine3 Frequency", addr: 18)
    let sin3Amp = buildParameter(id: "sin3amp", name: "Sine3 Amplitude", addr: 19)
    
    // --- Combined --- //
    let combined: Array<AUParameter>
    
    init() {
        self.combined = [
            volumeFilter, verb,
            saw1Freq, saw1Amp, saw2Freq, saw2Amp, saw3Freq, saw3Amp,
            squ1Freq, squ1Amp, squ2Freq, squ2Amp, squ3Freq, squ3Amp,
            sin1Freq, sin1Amp, sin2Freq, sin2Amp, sin3Freq, sin3Amp
        ]
    }
}

func buildParameter(id: String, name: String, addr: AUParameterAddress) -> AUParameter {
    return AUParameterTree.createParameter(
        withIdentifier: id,
        name: name,
        address: addr,
        min: 0.0,
        max: 1.0,
        unit: .generic,
        unitName: nil,
        flags: [.flag_IsReadable,
                .flag_IsWritable,
                .flag_CanRamp],
        valueStrings: nil,
        dependentParameters: nil
    )
}
