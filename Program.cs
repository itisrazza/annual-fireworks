using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using SFML.Graphics;
using SFML.System;
using SFML.Audio;
using Windows.Media.Control;

namespace NY2022
{
    internal static class Program
    {
        public const int BaseWidth = 1280;
        public const int BaseHeight = 720;

        public static RenderWindow? Window { get; private set; }
        public static SoundProcessor? SoundProcessor { get; private set; }

        public static Font ChivoLight, ChivoRegular, ChivoBold, ChivoBlack;

        public static DateTime CountdownTo = DateTime.Now + TimeSpan.FromSeconds(120);

        private static Background Background = new Background();

        private static IDisplay? _currentDisplay = null;
        private static IDisplay? _nextDisplay = null;

        public static IDisplay? CurrentDisplay
        {
            get => _currentDisplay;
            set
            {
                _nextDisplay = value;
            }
        }

        /// <summary>
        ///  The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.SetHighDpiMode(HighDpiMode.SystemAware);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            ChivoLight = new Font(Resources.Chivo_Light);
            ChivoRegular = new Font(Resources.Chivo_Regular);
            ChivoBold = new Font(Resources.Chivo_Bold);
            ChivoBlack = new Font(Resources.Chivo_Black);

            Window = new(new(BaseWidth, BaseHeight), "Happy New Year! 2022", SFML.Window.Styles.Default);
            Window.SetVerticalSyncEnabled(true);
            Window.Closed += (sender, e) => Window.Close();
            CurrentDisplay = new TimeDisplay();

            SoundProcessor = new SoundProcessor();
            SoundProcessor.Start();

            while (Window.IsOpen)
            {
                Window.DispatchEvents();
                if (_nextDisplay != null)
                {
                    _currentDisplay?.Dispose();
                    _currentDisplay = _nextDisplay;
                    _nextDisplay = null;
                }

                Window.Clear();
                DrawWindow();
                Window.Display();

                var frequencies = SoundProcessor.Amplitudes;
                Background.AdvanceColor(0.0001f * (float)frequencies.Sum());

                // check the time
                var countdown = Countdown();
                if (countdown.TotalSeconds < 10)
                {
                    CurrentDisplay = new CountownDisplay();
                }
                else if (countdown.TotalSeconds <= 0)
                {
                    // change to 2022 display
                }
            }

            SoundProcessor.Stop();
        }

        static void DrawWindow()
        {
            Debug.Assert(Window != null);
            Debug.Assert(SoundProcessor != null);

            Background.CircleScale = 1 + 0.1f * SoundProcessor.Boppyness();
            Background.Draw();

            CurrentDisplay?.Draw();

            // plot the frequencies
            var frequencies = SoundProcessor.Amplitudes;
            var frequencyCount = frequencies.Length;

            var y = BaseHeight - 100;
            var yScale = 1;
            var xStep = (double)BaseWidth / (frequencyCount - 1);
            var x = 0.0;
            var vertex = new VertexArray(PrimitiveType.LineStrip);
            for (var i = 0; i < frequencyCount; i++)
            {
                var amplitude = frequencies[i];
                x += xStep;
                vertex.Append(new Vertex(new((float)x - 0, (float)(y - amplitude * yScale) - 0), Color.White));
            }
            Window.Draw(vertex);
        }

        public static TimeSpan Countdown()
        {
            return CountdownTo - DateTime.Now;
        }
    }
}
