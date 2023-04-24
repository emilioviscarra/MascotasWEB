using System;
using MascotasWebDeEmilio.App_Code.Class.Dueno;
using MascotasWebDeEmilio.App_Code.DAL.DuenoDSTableAdapters;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MascotasWebDeEmilio.App_Code.DAL;

namespace MascotasWebDeEmilio.App_Code.BLL.DuenoBLL
{
    [System.ComponentModel.DataObject]
    public class DuenoBLL
    {
        public DuenoBLL()
        {
        }

        private static Dueno FillDuenoRecord(DuenoDS.DuenoRow row)
        {
            Dueno theNewRecord = 
                new Dueno(row.duenoId, row.nombre, row.apellidos, row.direccion);
            return theNewRecord;
        }

        public static int InsertarDueno(Dueno theClass)
        {
            int? duenoId = 0;

            DuenoTableAdapter localAdapter =
                new DuenoTableAdapter();
            try
            {
                localAdapter.InsertDueno(theClass.Nombres,
                    theClass.Apellidos,
                    theClass.Direccion,
                    ref duenoId);
            }
            catch (Exception q)
            {
                throw new Exception("Error al registrar al dueño.", q);
            }

            return (int)duenoId;
        }

        public static List<Dueno> GetDuenosBySearch(string searchParams)
        {
            if (searchParams == null)
                searchParams = "";

            DuenoTableAdapter localAdapter =
                new DuenoTableAdapter();

            List<Dueno> theDuenosList = new List<Dueno>();
            try
            {
                MascotasWebDeEmilio.App_Code.DAL.DuenoDS.DuenoDataTable table = localAdapter.GetDuenosBySearch(searchParams);

                if (table != null)
                {
                    foreach (DuenoDS.DuenoRow row in table.Rows)
                    {
                        theDuenosList.Add(FillDuenoRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener los registros de dueño.", q);
            }

            return theDuenosList;
        }

        public static Dueno GetDuenoDetails(int duenoId)
        {
            if (duenoId <= 0)
                throw new Exception("El ID de dueño es inválido.");

            DuenoTableAdapter localAdapter =
                new DuenoTableAdapter();

            List<Dueno> theDuenosList = new List<Dueno>();
            try
            {
                MascotasWebDeEmilio.App_Code.DAL.DuenoDS.DuenoDataTable table = localAdapter.GetDuenoDetails(duenoId);

                if (table != null)
                {
                    foreach (DuenoDS.DuenoRow row in table.Rows)
                    {
                        theDuenosList.Add(FillDuenoRecord(row));
                    }
                }
            }
            catch (Exception q)
            {
                throw new Exception("Error al obtener el detalle de dueño con ID: "+duenoId.ToString(), q); ;
            }

            return theDuenosList[0];
        }
    }
}