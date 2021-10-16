using NAudio.Wave;
using SFML.Audio;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Media;

namespace NY2022
{
    internal class SoundProcessor
    {
        private WaveInEvent _waveIn;

        private volatile double[] _frequencies = Array.Empty<double>();
        private volatile double[] _amplitudes = Array.Empty<double>();

        public double[] Frequencies => _frequencies;

        public double[] Amplitudes => _amplitudes;

        public const int SampleRate = 48000;

        public SoundProcessor()
        {
            _waveIn = new WaveInEvent();
            _waveIn.DataAvailable += OnDataAvailable;
            _waveIn.WaveFormat = new(rate: SampleRate, 16, 1);
            _waveIn.DeviceNumber = 0;
            _waveIn.BufferMilliseconds = 20;
        }

        public void Start()
        {
            _waveIn.StartRecording();
        }

        public void Stop()
        {
            _waveIn.StopRecording();
        }

        public float Boppyness()
        {
            if (Amplitudes.Length == 0) return 0;

            // isolate the bottom bit
            var amps = new ArraySegment<double>(Amplitudes, 0, 100);
            return 1 + (float)amps.Max() / 500;
        }

        private void OnDataAvailable(object? _, WaveInEventArgs e)
        {
            var bytesPerSample = _waveIn.WaveFormat.BitsPerSample / 8;
            var samplesRecorded = e.BytesRecorded / bytesPerSample;
            var samples = new double[samplesRecorded];
            for (var i = 0; i < samplesRecorded; i++)
            {
                samples[i] = BitConverter.ToInt16(e.Buffer, i * bytesPerSample);
            }

            double[] window = FftSharp.Window.Hanning(samples.Length);
            double[] windowed = FftSharp.Window.Apply(window, samples);
            double[] zeroPadded = FftSharp.Pad.ZeroPad(windowed);
            double[] fftPower = FftSharp.Transform.FFTmagnitude(zeroPadded);
            double[] fftFreq = FftSharp.Transform.FFTfreq(SampleRate, fftPower.Length);

            _amplitudes = fftPower;
            _frequencies = fftFreq;
        }
    }
}
