// Taken from AudioKit Cookbook and adapted.

import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import Combine
import SoundpipeAudioKit
import SwiftUI

import AVFoundation

public struct TunerData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var noteNameWithSharps = "-"
    var noteNameWithFlats = "-"

    var askBits: String = ""
    var carrierAmplitudeThreshold: Float = 0.0001
}

public class TunerConductor: ObservableObject, HasAudioEngine {
    @Published var data = TunerData()

    public let engine = AudioEngine()
    let initialDevice: Device

    let mic: AudioEngine.InputNode
    let tappableNodeA: Fader
    let tappableNodeB: Fader
    // let tappableNodeB2: Node
    let tappableNodeC: Fader
    let silence: Fader

    var tracker: PitchTap!

    var fftTracker: FFTTap!

    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

    var twoKiloHertzAmplitudeSubject = PassthroughSubject<Float, Never>()

    private var cancellables: [AnyCancellable] = []

    init() {
#if os(iOS)
        do {
            Settings.bufferLength = .short
            // Settings.sampleRate = 96_000
            // Settings.channelCount = 2
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                            options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
#endif

        guard let input = engine.input else { fatalError() }
        guard let device = engine.inputDevice else { fatalError() }

        initialDevice = device

        mic = input
        tappableNodeA = Fader(mic)//, gain: 12)
        tappableNodeB = Fader(tappableNodeA)
//        tappableNodeB2 = BandPassFilter(tappableNodeB, centerFrequency: 440, bandwidth: 12_000)
//        tappableNodeB2 = EqualizerFilter(tappableNodeB, centerFrequency: 440)
        tappableNodeC = Fader(tappableNodeB)
        //tappableNodeC.avAudioNode

        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence

        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0], amp[0])
            }
        }
        //        tracker.start()

        fftTracker = FFTTap(mic, bufferSize: 512, callbackQueue: .main) { [weak self] frequencies in
            let binWidth: Float = Float(44_100 / 2) / Float(frequencies.count)

            let carrierFrequency = 2000
            let carrierBinIndex = carrierFrequency / Int(binWidth)
            self?.twoKiloHertzAmplitudeSubject.send(frequencies[carrierBinIndex])

            let line = frequencies
                .enumerated()
                .sorted(by: { $0.element > $1.element } )
                .dropLast(frequencies.count - 4)
                 .filter { $0.element > 0.0005 }
                .map { "\(Float($0.offset) * binWidth): \($0.element)" }
                .joined(separator: " | ")

            guard !line.isEmpty else { return }
//            print(line)
        }
        fftTracker.isNormalized = false
        fftTracker.start()

        twoKiloHertzAmplitudeSubject
            .sink { [weak self] in
                self?.appendBit($0)
            }
            .store(in: &cancellables)
    }

    private func appendBit(_ v: Float) {
        var string = data.askBits

        string = String(string.suffix(50))
        string.append(v > data.carrierAmplitudeThreshold ? "1" : "." )

        data.askBits = string
    }

    func setThreshold(_ threshold: Float) {
        data.carrierAmplitudeThreshold = threshold
    }

    func update(_ pitch: AUValue, _ amp: AUValue) {
        // Reduces sensitivity to background noise to prevent random / fluctuating data.
        guard amp > 0.1 else { return }

        data.pitch = pitch
        data.amplitude = amp

        var frequency = pitch
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies[0]) {
            frequency *= 2.0
        }

        var minDistance: Float = 10000.0
        var index = 0

        for possibleIndex in 0 ..< noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        let octave = Int(log2f(pitch / frequency))
        data.noteNameWithSharps = "\(noteNamesWithSharps[index])\(octave)"
        data.noteNameWithFlats = "\(noteNamesWithFlats[index])\(octave)"
    }
}

public struct TunerView: View {
    @StateObject var conductor = TunerConductor()

    public init() { }

    public var body: some View {
        VStack {
            /*
            VStack {
                HStack {
                    Text("Frequency")
                    Spacer()
                    Text("\(conductor.data.pitch, specifier: "%0.1f")")
                }

                HStack {
                    Text("Amplitude")
                    Spacer()
                    Text("\(conductor.data.amplitude, specifier: "%0.1f")")
                }

                HStack {
                    Text("Note Name")
                    Spacer()
                    Text("\(conductor.data.noteNameWithSharps) / \(conductor.data.noteNameWithFlats)")
                }
            }
            .padding()
            .hidden()
            */

            InputDevicePicker(device: conductor.initialDevice)

            NodeRollingView(conductor.tappableNodeA).clipped()
                .frame(height: 64)
            NodeOutputView(conductor.tappableNodeB).clipped()

            FFTView(
                conductor.tappableNodeC,
                barCount: 256
                //,
                //validBinCount: .sixtyFour
            )
            .clipped()
            //NodeFFTView(conductor.tappableNodeC).clipped()


            Text("2kHz bits")
                .monospaced()
            Group {
                Text("^" + conductor.data.askBits.prefix(25))
                    .monospaced()
                Text(conductor.data.askBits.suffix(25) + "$")
                    .monospaced()
            }
//            .font(.system(size: 8))

            VStack {
                Slider(
                    value: .init(
                        get: { conductor.data.carrierAmplitudeThreshold },
                        set: { conductor.setThreshold($0) }
                    ),
                    in: 0.0001...0.001
                )
                .padding()
                Text("Carrier amplitude threshold: \(conductor.data.carrierAmplitudeThreshold)")
            }
        }
        .padding(.bottom)
        .navigationTitle("Tuner")
        .onAppear {
            conductor.start()
        }
        .onDisappear {
            conductor.stop()
        }
    }
}

struct InputDevicePicker: View {
    @State var device: Device

    var body: some View {
        Picker("Input: \(device.deviceID)", selection: $device) {
            ForEach(getDevices(), id: \.self) {
                Text($0.deviceID)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: device, perform: setInputDevice)
    }

    func getDevices() -> [Device] {
        AudioEngine.inputDevices.compactMap { $0 }
    }

    func setInputDevice(to device: Device) {
        do {
            try AudioEngine.setInputDevice(device)
        } catch let err {
            print(err)
        }
    }
}
