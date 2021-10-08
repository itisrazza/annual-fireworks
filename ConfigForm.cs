using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace NY2022
{
    public partial class ConfigForm : Form
    {
        public Config Configuration { get; private set; }

        public ConfigForm()
        {
            InitializeComponent();
        }

        public static Config GetConfig()
        {
            var configForm = new ConfigForm();
            configForm.ShowDialog();

            return configForm.Configuration;
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        public struct Config
        {
            string Input { get; set; }
            DateTime CountdownTarget { get; set; }
        }
    }
}
