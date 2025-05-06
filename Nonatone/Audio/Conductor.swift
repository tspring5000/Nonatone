import AudioKit
import SoundpipeAudioKit
import AVFoundation

class Conductor {
    var engine = AudioEngine()
    var mixer = Mixer()
    var end_mixer: Mixer
    var filter: LowPassFilter
    var verb: Reverb
    
    let parameters = AllParameters()
    
    init() {
        filter = LowPassFilter(mixer)
        verb = Reverb(filter)
        verb.dryWetMix = 0.25
        end_mixer = Mixer(verb)
        end_mixer.volume = 0.15
        engine.output = end_mixer
    }
    
    func start() {
        do {
            try engine.start()
        } catch let err {
            Log(err)
        }
        verb.start()
        filter.start()
    }
    
    deinit {
        for osc in mixer.connections {
            osc.stop()
        }
        mixer.removeAllInputs()
        
        filter.stop()
        verb.stop()
        engine.stop()
    }
}
