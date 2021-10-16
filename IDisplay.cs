using SFML.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NY2022
{
    internal interface IDisplay : IDisposable
    {
        public void Draw();
    }

    internal class TimeDisplay : IDisplay
    {
        public void Dispose()
        {
            // nothing to dispose
        }

        public void Draw()
        {
            var now = DateTime.Now;
            var hourText = new Text(now.Hour.ToString().PadLeft(2, '0'), Program.ChivoBlack, 300)
            {
                Position = new(80, 40),
                FillColor = Color.White
            };
            var minText = new Text(now.Minute.ToString().PadLeft(2, '0'), Program.ChivoRegular, 300)
            {
                Position = new(440, 167),
                FillColor = Color.White
            };
            var secText = new Text(now.Second.ToString().PadLeft(2, '0'), Program.ChivoLight, 300)
            {
                Position = new(820, 282),
                FillColor = Color.White
            };


            Program.Window?.Draw(hourText);
            Program.Window?.Draw(minText);
            Program.Window?.Draw(secText);
        }
    }

    internal class CountownDisplay : IDisplay
    {
        public void Dispose()
        {
            // nothing to dispose
        }

        public void Draw()
        {
            var seconds = (int)Program.Countdown().TotalSeconds;
            var text = new Text(seconds.ToString(), Program.ChivoBlack, 1200);
            var textBounds = text.GetGlobalBounds();
            text.Origin = new(textBounds.Left + textBounds.Width / 2, textBounds.Top + textBounds.Height / 2);
            text.Position = new(Program.BaseWidth / 2, Program.BaseHeight / 2);

            Program.Window?.Draw(text);
        }
    }
}
