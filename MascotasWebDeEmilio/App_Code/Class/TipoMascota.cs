using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MascotasWebDeEmilio.App_Code.Class.TipoMascota
{
    public class TipoMascota
    {
        public int TipoMascotaId { get; set; }
        public string Nombre { get; set; }

        public TipoMascota()
        {

        }

        public TipoMascota(int tipoMascotaId,
            string nombre)
        {
            this.TipoMascotaId = tipoMascotaId;
            this.Nombre = nombre;
        }
    }
}