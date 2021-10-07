using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using SFML.Graphics;
using SFML.System;
using SFML.Audio;

namespace NY2022
{
    internal static class Program
    {
        public const int BaseWidth = 1280;
        public const int BaseHeight = 720;

        public static RenderWindow? Window { get; private set; }
        public static SoundProcessor? SoundProcessor { get; private set;  }

        public static Font ChivoLight, ChivoRegular, ChivoBold, ChivoBlack;

        private static Background Background = new Background();

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

            SoundProcessor = new SoundProcessor();
            SoundProcessor.Start();

            while (Window.IsOpen)
            {
                Window.DispatchEvents();

                Window.Clear();
                DrawWindow();
                Window.Display();
                
                var frequencies = SoundProcessor.Amplitudes;
                Background.AdvanceColor(0.0001f * (float)frequencies.Sum());
            }

            SoundProcessor.Stop();
        }

        static void DrawWindow()
        {
            Debug.Assert(Window != null);
            Debug.Assert(SoundProcessor != null);

            Background.Draw();

            //

            var now = DateTime.Now;
            var hourText = new Text(now.Hour.ToString().PadLeft(2, '0'), ChivoBlack, 300)
            {
                Position = new(80, 40),
                Color = Color.White
            };
            var minText = new Text(now.Minute.ToString().PadLeft(2, '0'), ChivoRegular, 300)
            {
                Position = new(440, 167),
                Color = Color.White
            };
            var secText = new Text(now.Second.ToString().PadLeft(2, '0'), ChivoLight, 300)
            {
                Position = new(820, 282),
                Color = Color.White
            };


            Window.Draw(hourText);
            Window.Draw(minText);
            Window.Draw(secText);

            // plot the frequencies
            var frequencies = SoundProcessor.Amplitudes;
            var frequencyCount = frequencies.Length;

            var y = BaseHeight - 100;
            var yScale = 1;
            var xStep = (double)BaseWidth / (frequencyCount - 1);
            var x = 0.0;
            var lastAmplitude = double.NaN;
            var vertex = new VertexArray(PrimitiveType.LinesStrip);
            for (var i = 0; i < frequencyCount; i++)
            {
                var amplitude = frequencies[i];

                // draw the point
                var point = new RectangleShape(new Vector2f(1, 1))
                {
                    Position = new((float)x - 0, (float)(y - amplitude * yScale) - 0),
                    FillColor = Color.White,
                };

                if (i % 250 == 0)
                {
                    var text = new Text(i.ToString(), ChivoRegular, 14) { Position = new((float)x, BaseHeight / 2), Rotation = 45};
                    Window.Draw(text);
                }

                Window.Draw(point);

                lastAmplitude = amplitude;
                x += xStep;
                vertex.Append(new Vertex(point.Position, Color.White));
            }
            Window.Draw(vertex);
        }
    }
}
