using MascotasWebDeEmilio.App_Code.Class.TipoMascota;
using MascotasWebDeEmilio.App_Code.DAL;
using MascotasWebDeEmilio.App_Code.DAL.TipoMascotaDSTableAdapters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MascotasWebDeEmilio.App_Code.BLL.TipoMascotaBLL
{
    public class TipoMascotaBLL
    {
        public TipoMascotaBLL()
        {
        }


        private static TipoMascota FillTipoMascotaRecord(TipoMascotaDS.TiposMascotasRow row)
        {
            TipoMascota theNewRecord = new TipoMascota(row.tipoMascotaId, row.nombre);
            return theNewRecord;
        }

        public static List<TipoMascota> GetTiposMascota()
        {
            TiposMascotasTableAdapter localAdapter =
                new TiposMascotasTableAdapter();

            List<TipoMascota> theTipoMascotaList = new List<TipoMascota>();
            try
            {
                MascotasWebDeEmilio.App_Code.DAL.TipoMascotaDS.TiposMascotasDataTable table = localAdapter.GetTiposMascota();

                if (table != null)
                {
                    foreach (TipoMascotaDS.TiposMascotasRow row in table.Rows)
                    {
                        theTipoMascotaList.Add(FillTipoMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener registros de tipo Mascota. ", q); 
            }

            return theTipoMascotaList;
        }

        public static List<TipoMascota> GetTiposMascotaForList()
        {
            TiposMascotasTableAdapter localAdapter =
                new TiposMascotasTableAdapter();

            List<TipoMascota> theTipoMascotaList = new List<TipoMascota>();

            //agregar a la lista un registro vacio [seleccione tipo de mascota...]

            theTipoMascotaList.Add(new TipoMascota(0, "[Seleccione un tipo de mascota]"));

            try
            {
                MascotasWebDeEmilio.App_Code.DAL.TipoMascotaDS.TiposMascotasDataTable table = localAdapter.GetTiposMascota();

                if (table != null)
                {
                    foreach (TipoMascotaDS.TiposMascotasRow row in table.Rows)
                    {
                        theTipoMascotaList.Add(FillTipoMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener registros de tipo Mascota. Funcion: GetTiposMascotaForList().", q); 
            }

            return theTipoMascotaList;
        }

        public static TipoMascota GetTipoMascotaById(int tipoMascotaId)
        {
            if (tipoMascotaId <= 0)
                throw new Exception("El ID de tipo mascota es inválido.");

            TiposMascotasTableAdapter localAdapter =
                new TiposMascotasTableAdapter();

            List<TipoMascota> theTipoList = new List<TipoMascota>();
            try
            {
                MascotasWebDeEmilio.App_Code.DAL.TipoMascotaDS.TiposMascotasDataTable table = localAdapter.GetTipoMascotaById(tipoMascotaId);

                if (table != null)
                {
                    foreach (TipoMascotaDS.TiposMascotasRow row in table.Rows)
                    {
                        theTipoList.Add(FillTipoMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener tipo de mascota por tipoMascotaId: " + tipoMascotaId.ToString(), q);
            }

            return theTipoList[0];
        }

    }
}