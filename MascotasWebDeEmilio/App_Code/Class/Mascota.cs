using MascotasWebDeEmilio.App_Code.BLL.DuenoBLL;
using MascotasWebDeEmilio.App_Code.BLL.RazaMascotaBLL;
using MascotasWebDeEmilio.App_Code.BLL.TipoMascotaBLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MascotasWebDeEmilio.App_Code.Class.Mascota
{
    public class Mascota
    {

        public int MascotaId { get; set; }
        public int DuenoId { get; set; }
        public string Nombre { get; set; }
        public int TipoMascotaId { get; set; }
        public int RazaMascotaId { get; set; }
        public DateTime Edad { get; set; }

        public string TipoForDisplay
        {
            get 
            {
                string tipoForDisplay = "";

                try
                {
                    tipoForDisplay = TipoMascotaBLL.GetTipoMascotaById(this.TipoMascotaId).Nombre;

                }
                catch { }
                
                return tipoForDisplay;
            }
        }

        public string RazaForDisplay
        {
            get
            {
                string tipoForDisplay = "";

                try
                {
                    tipoForDisplay = RazaMascotaBLL.GetRazaMascotaById(this.RazaMascotaId).Nombre;

                }
                catch { }

                return tipoForDisplay;
            }
        }

        public string EdadForDisplay
        {
            get
            {
                string edadForDisplay = "";

                try
                {
                    edadForDisplay = (DateTime.Now.Year - this.Edad.Year).ToString()+" años";

                }
                catch { }

                return edadForDisplay;
            }
        }

        public string DuenoForDisplay
        {
            get
            {
                string duenoForDisplay = "";

                try
                {
                    duenoForDisplay = DuenoBLL.GetDuenoDetails(this.DuenoId).NombreCompleto;

                }
                catch { }

                return duenoForDisplay;
            }
        }

        public Mascota()
        {

        }

        public Mascota(int mascotaId,
            int duenoId,
            string nombre,
            int tipoMascotaId,
            int razaMascotaId,
            DateTime edad)
        {
            this.MascotaId = mascotaId;
            this.DuenoId = duenoId;
            this.Nombre = nombre;
            this.TipoMascotaId = tipoMascotaId;
            this.RazaMascotaId = razaMascotaId;
            this.Edad = edad;
        }
    }
}