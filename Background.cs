using SFML.Graphics;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NY2022
{
    internal class Background
    {
        private float _hue = 223;

        private const float BackgroundHueOffset = 0;
        private const float CircleHueOffset = -360/3;
        private const float Saturation = 1f;
        private const float Lightness = 0.27f;

        private float CircleRadius = 964f / 3;
        private float _circleActualScale = 1;
        public float CircleScale = 1;

        public void Draw()
        {
            Debug.WriteLine(_hue);
            Debug.Assert(Program.Window != null);

            Program.Window.Clear(HSL(_hue + BackgroundHueOffset, Saturation, Lightness));

            var circle = new CircleShape(CircleRadius, 200)
            {
                Position = new(Program.BaseWidth / 2, Program.BaseHeight / 2),
                Origin = new(CircleRadius, CircleRadius),
                FillColor = HSL(_hue + CircleHueOffset, Saturation, Lightness),
                Scale = new(_circleActualScale, _circleActualScale),
            };
            Program.Window.Draw(circle);

            _circleActualScale += 0.5f * (CircleScale - _circleActualScale) / 2;
        }

        public void AdvanceColor(float extent)
        {
            Debug.WriteLine(_hue);
            Debug.Assert(extent >= 0);

            _hue = (_hue + extent) % 360;
        }

        private static Color HSL(float h, float s, float l)
        {
            h %= 360;
            if (h < 0) h += 360;

            var c = (1 - MathF.Abs(2 * l - 1) * s);
            var x = c * (1 - MathF.Abs((h / 60) % 2 - 1));
            var m = l - c / 2;

            (float R, float G, float B) color = h switch
            {
                < 60 => (c, x, 0),
                < 120 => (x, c, 0),
                < 180 => (0, c, x),
                < 240 => (0, x, c),
                < 300 => (x, 0, c),
                < 360 => (c, 0, x),
                _ => throw new ArgumentException ("what happened?")
            };

            return new Color(
                (byte)(255 * (color.R + m)), 
                (byte)(255 * (color.G + m)),
                (byte)(255 * (color.B + m)));
        }
    }
}
