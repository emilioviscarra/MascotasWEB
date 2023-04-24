using MascotasWebDeEmilio.App_Code.Class.Mascota;
using MascotasWebDeEmilio.App_Code.DAL;
using MascotasWebDeEmilio.App_Code.DAL.MascotaDSTableAdapters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using static MascotasWebDeEmilio.App_Code.DAL.MascotaDS;

namespace MascotasWebDeEmilio.App_Code.BLL.MascotaBLL
{
    public class MascotaBLL
    {
        public MascotaBLL()
        {
        }

        private static Mascota FillMascotaRecord(MascotasWebDeEmilio.App_Code.DAL.MascotaDS.MascotaRow row)
        {
            Mascota theNewRecord =
                new Mascota(
                    row.mascotaId,
                    row.duenoId,
                    row.nombre,
                    row.IstipoMascotaNull() ? 0 : row.tipoMascotaId,
                    row.IsrazaMascotaIdNull() ? 0 : row.razaMascotaId,
                    row.IsedadAnosNull() ? DateTime.MinValue : row.edad) ;

            return theNewRecord;
        }


        public static List<Mascota> GetMascotaBySearch(string searchParams)
        {
            if (searchParams == null)
                searchParams = "";

            MascotaTableAdapter localAdapter =
                new MascotaTableAdapter();

            List<Mascota> theMascotasList = new List<Mascota>();
            try
            {
                MascotaDataTable table = localAdapter.GetMascotasBySearch(searchParams);

                if (table != null)
                {
                    foreach (MascotasWebDeEmilio.App_Code.DAL.MascotaDS.MascotaRow row in table.Rows)
                    {
                        theMascotasList.Add(FillMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener los registros de mascotas.", q); 
            }

            return theMascotasList;
        }

        public static List<Mascota> GetMascotasByDueno(int duenoId)
        {
            if (duenoId <= 0)
                return null;

            MascotaTableAdapter localAdapter =
                new MascotaTableAdapter();

            List<Mascota> theMascotasList = new List<Mascota>();
            try
            {
                MascotaDataTable table = localAdapter.GetMascotasByDueno(duenoId);

                if (table != null)
                {
                    foreach (MascotasWebDeEmilio.App_Code.DAL.MascotaDS.MascotaRow row in table.Rows)
                    {
                        theMascotasList.Add(FillMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener el detalle de mascota por dueño con DuenoId:"+duenoId.ToString(), q); 
            }

            return theMascotasList;
        }

        public static int InsertarMascota(Mascota theClass)
        {
            int? mascotaId = 0;

            MascotaTableAdapter localAdapter =
                new MascotaTableAdapter();

            try
            {
                localAdapter.InsertMascota(theClass.DuenoId,
                    theClass.Nombre,
                    theClass.TipoMascotaId,
                    theClass.RazaMascotaId,
                    theClass.Edad,
                    ref mascotaId);
            }
            catch (Exception q)
            {
                throw new Exception("Error al registrar mascota.",q);
            }

            return (int)mascotaId;
        }

        public static Mascota GetMascotaById(int mascotaId)
        {
            if (mascotaId <= 0)
                throw new Exception("El ID de mascota es inválido.");

            MascotaTableAdapter localAdapter =
                new MascotaTableAdapter();

            List<Mascota> theMascotasList = new List<Mascota>();
            try
            {
                MascotasWebDeEmilio.App_Code.DAL.MascotaDS.MascotaDataTable table = localAdapter.GetMascotaById(mascotaId);

                if (table != null)
                {
                    foreach (MascotasWebDeEmilio.App_Code.DAL.MascotaDS.MascotaRow row in table.Rows)
                    {
                        theMascotasList.Add(FillMascotaRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener el detalle de mascota con ID: " + mascotaId.ToString(), q); ;
            }

            return theMascotasList[0];
        }


    }
}