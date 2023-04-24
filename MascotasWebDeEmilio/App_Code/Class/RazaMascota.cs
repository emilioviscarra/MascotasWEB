using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MascotasWebDeEmilio.App_Code.Class.RazaMascota
{
    public class RazaMascota
    {

        public int RazaMascotaId { get; set; }
        public int TipoMascotaId { get; set; }
        public string Nombre { get; set; }

        public RazaMascota()
        {

        }

        public RazaMascota(int razaMascotaId, int tipoMascotaId, 
            string nombre)
        {
            this.RazaMascotaId = razaMascotaId;
            this.TipoMascotaId = tipoMascotaId;
            this.Nombre = nombre;
        }
    }
}