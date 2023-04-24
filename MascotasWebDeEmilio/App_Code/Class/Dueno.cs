using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MascotasWebDeEmilio.App_Code.Class.Dueno
{
    public class Dueno
    {
        public int DuenoId { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Direccion { get; set; }
        public string NombreCompleto { get; set; }

        public Dueno()
        {

        }

        public Dueno(int duenoId,
            string nombres,
            string apellidos,
            string direccion)
        {
            this.DuenoId = duenoId;
            this.Nombres = nombres;
            this.Apellidos = apellidos;
            this.Direccion = direccion;
            this.NombreCompleto = nombres + " " + apellidos;
        }

    }
}