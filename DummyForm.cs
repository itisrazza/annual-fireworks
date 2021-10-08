using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Windows.Media;

namespace NY2022
{
    public partial class DummyForm : Form
    {
        internal SystemMediaTransportControls MediaTransportControls => SystemMediaTransportControls.GetForCurrentView();

        public DummyForm()
        {
            InitializeComponent();
        }
    }
}
