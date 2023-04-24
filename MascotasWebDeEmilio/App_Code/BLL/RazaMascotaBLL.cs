using MascotasWebDeEmilio.App_Code.Class.RazaMascota;
using MascotasWebDeEmilio.App_Code.DAL;
using MascotasWebDeEmilio.App_Code.DAL.RazaMascotaDSTableAdapters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using static MascotasWebDeEmilio.App_Code.DAL.RazaMascotaDS;

namespace MascotasWebDeEmilio.App_Code.BLL.RazaMascotaBLL
{
    public class RazaMascotaBLL
    {
        public RazaMascotaBLL()
        {
        }

        private static RazaMascota FillRazaMascotaRecord(MascotasWebDeEmilio.App_Code.DAL.RazaMascotaDS.RazaMascotaRow row)
        {
            RazaMascota theNewRecord = new RazaMascota(row.razaMascotaId, row.tipoMascotaId, row.nombre);
            return theNewRecord;
        }

        public static List<RazaMascota> GetRazasMascotaByTipo(int tipoMascotaId)
        {
            RazaMascotaTableAdapter localAdapter =
                new RazaMascotaTableAdapter();

            List<RazaMascota> theRazaMascotaList = new List<RazaMascota>();

            try
            {
                MascotasWebDeEmilio.App_Code.DAL.RazaMascotaDS.RazaMascotaDataTable table = localAdapter.GetRazaMascotaByTipo(tipoMascotaId);

                if (table != null)
                {
                    foreach (MascotasWebDeEmilio.App_Code.DAL.RazaMascotaDS.RazaMascotaRow row in table.Rows)
                    {
                        theRazaMascotaList.Add(FillRazaMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener mascota por tipoId: "+tipoMascotaId.ToString() , q); 
            }

            return theRazaMascotaList;
        }

        public static RazaMascota GetRazaMascotaById(int razaMascotaId)
        {
            if (razaMascotaId <= 0)
                throw new Exception("El ID de raza mascota es inválido.");

            RazaMascotaTableAdapter localAdapter =
                new RazaMascotaTableAdapter();

            List<RazaMascota> theTipoList = new List<RazaMascota>();
            try
            {
                RazaMascotaDataTable table = localAdapter.GetRazaMascotaById(razaMascotaId);

                if (table != null)
                {
                    foreach (MascotasWebDeEmilio.App_Code.DAL.RazaMascotaDS.RazaMascotaRow row in table.Rows)
                    {
                        theTipoList.Add(FillRazaMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener raza de mascota por razaMascotaId: " + razaMascotaId.ToString(), q);
            }

            return theTipoList[0];
        }
    }
}