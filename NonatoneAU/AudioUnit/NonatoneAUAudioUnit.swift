import AVFoundation
import AudioKit


public class NonatoneAUAudioUnit: AUAudioUnit {
    var engine: AVAudioEngine!
    var conductor: Conductor!
    
    // Parameter stuff
    open var _parameterTree: AUParameterTree!
    override open var parameterTree: AUParameterTree? {
        get { return self._parameterTree }
        set { _parameterTree = newValue }
    }
    
    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {

        conductor = Conductor()
        engine = conductor.engine.avEngine
        do {
            try super.init(componentDescription: componentDescription, options: options)
            try setOutputBusArrays()
        } catch {
            Log("Could not init audio unit")
            throw error
        }
        
        setupParamTree()
        setInternalRenderingBlock() // set internal rendering block to actually handle the audio buffers
    }
    
    func setupParamTree() {
        parameterTree = AUParameterTree.createTree(withChildren: self.conductor.parameters.combined)
    }
    
    private func setInternalRenderingBlock() {
        self._internalRenderBlock = { [weak self] (actionFlags, timestamp, frameCount, outputBusNumber,
            outputData, renderEvent, pullInputBlock) in
            guard let self = self else { return 1 } //error code?
            if let eventList = renderEvent?.pointee {
                self.handleEvents(eventsList: eventList, timestamp: timestamp)
            }
            
            _ = self.engine.manualRenderingBlock(frameCount, outputData, nil)
            return noErr
        }
    }
    
    private func handleEvents(eventsList: AURenderEvent?, timestamp: UnsafePointer<AudioTimeStamp>) {
        var nextEvent = eventsList
        while nextEvent != nil {
            if (nextEvent!.head.eventType == .parameter ||  nextEvent!.head.eventType == .parameterRamp) {
                handleParameter(parameterEvent: nextEvent!.parameter, timestamp: timestamp)
            }
            nextEvent = nextEvent!.head.next?.pointee
        }
    }
    
    private func handleParameter(parameterEvent event: AUParameterEvent, timestamp: UnsafePointer<AudioTimeStamp>) {
        parameterTree?.parameter(withAddress: event.parameterAddress)?.value = event.value
    }

    override public func allocateRenderResources() throws {
        do {
            try engine.enableManualRenderingMode(.offline, format: outputBus.format, maximumFrameCount: 4096)
            
            try super.allocateRenderResources()
        } catch {
            return
        }
    }

    override public func deallocateRenderResources() {
        engine.stop()
        super.deallocateRenderResources()
    }

    // Internal Render block stuff
    open var _internalRenderBlock: AUInternalRenderBlock!
    override open var internalRenderBlock: AUInternalRenderBlock {
        return self._internalRenderBlock
    }

    // Default OutputBusArray stuff you will need
    var outputBus: AUAudioUnitBus!
    open var _outputBusArray: AUAudioUnitBusArray!
    override open var outputBusses: AUAudioUnitBusArray {
        return self._outputBusArray
    }
    
    open func setOutputBusArrays() throws {
        let defaultAudioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
        outputBus = try AUAudioUnitBus(format: defaultAudioFormat!)
        self._outputBusArray = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.output, busses: [outputBus])
    }
}
