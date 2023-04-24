using MascotasWebDeEmilio.App_Code.Class.Mascota;
using MascotasWebDeEmilio.App_Code.Class.RazaMascota;
using MascotasWebDeEmilio.App_Code.Class.TipoMascota;
using MascotasWebDeEmilio.App_Code.Class.Dueno;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MascotasWebDeEmilio.App_Code.BLL.MascotaBLL;
using MascotasWebDeEmilio.App_Code.BLL.RazaMascotaBLL;

namespace MascotasWebDeEmilio
{
    public partial class RegistroMascota : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                int DuenoId = 0;

                try
                {
                    DuenoId = Convert.ToInt32(Session["DuenoId"]);
                }
                catch { }
                
                //Llenar drop down list de duenos
                List<Dueno> theDuenosList = new List<Dueno>();

                try
                {
                    theDuenosList = MascotasWebDeEmilio.App_Code.BLL.DuenoBLL.DuenoBLL.GetDuenosBySearch("");

                    DuenoDDL.DataSource = theDuenosList;
                    DuenoDDL.DataTextField = "NombreCompleto";
                    DuenoDDL.DataValueField = "DuenoId";
                    DuenoDDL.DataBind();
                }
                catch { }



                if (DuenoId > 0)
                {
                    DuenoDDL.SelectedValue = DuenoId.ToString();
                    DuenoDDL.Enabled = false;
                    DuenoIDHF.Value = DuenoId.ToString();
                    Session["DuenoId"] = 0;                   
                }
                else
                {
                    DuenoDDL.Enabled = true;
                }

                //llenar tipos de mascota
                List<TipoMascota> theTiposMascotaList = new List<TipoMascota>();

                try
                {
                    theTiposMascotaList = MascotasWebDeEmilio.App_Code.BLL.TipoMascotaBLL.TipoMascotaBLL.GetTiposMascotaForList();

                    TiposMascotaDDL.DataSource = theTiposMascotaList;
                    TiposMascotaDDL.DataTextField = "Nombre";
                    TiposMascotaDDL.DataValueField = "TipoMascotaId";
                    TiposMascotaDDL.DataBind();
                }
                catch { }

            }

        }

        protected void TiposMascotaDDL_SelectedIndexChanged(object sender, EventArgs e)
        {
            //llenar razas para el tipo de mascota seleccionado
            List<RazaMascota> theRazasList = new List<RazaMascota>();

            int tipoMascotaId = 0;

            try
            {
                tipoMascotaId = Convert.ToInt32(TiposMascotaDDL.SelectedValue);
            }
            catch { }

            if (tipoMascotaId <= 0)
            {
                RazaDDL.DataSource = new List<RazaMascota>();
                RazaDDL.DataBind();
                return;
            }

            try
            {
                theRazasList = RazaMascotaBLL.GetRazasMascotaByTipo(tipoMascotaId);

                RazaDDL.DataSource = theRazasList;
                RazaDDL.DataTextField = "Nombre";
                RazaDDL.DataValueField = "RazaMascotaId";
                RazaDDL.DataBind();
            }
            catch { }
        }

        protected void GuardarMascotaBT_Click(object sender, EventArgs e)
        {
            Mascota theMascota = new Mascota();

            string nombre = NombreTB.Text.Trim();
            int mascotaId = 0;
            int duenoId = 0;

            try
            {
                duenoId = Convert.ToInt32(DuenoDDL.SelectedValue);
            }
            catch { }

            if (duenoId <= 0)
                return;

            int tipoMascotaId = 0;

            try
            {
                tipoMascotaId = Convert.ToInt32( TiposMascotaDDL.SelectedValue);
            }
            catch { }

            if (tipoMascotaId <= 0)
                return;

            int razaId = 0;

            try
            {
                razaId = Convert.ToInt32( RazaDDL.SelectedValue);
            }
            catch { }

            if (razaId <= 0)
                return;

            DateTime edad = DateTime.MinValue;

            try
            {
                edad = EdadCalendar.SelectedDate;
            }
            catch { }

            //Validar textos


            try
            {
                theMascota = new Mascota(mascotaId, duenoId, nombre, tipoMascotaId, razaId, edad);

                mascotaId = MascotaBLL.InsertarMascota(theMascota);
            }
            catch
            {

            }

            if (mascotaId > 0)
            {
                //enviar a pagina de detalles de dueno
                Session["DuenoId"] = duenoId.ToString();
                Response.Redirect("DetalleDueno.aspx");
            }
            else
            {
                //mensaje de error
            }
        }

        protected void CancelarLinkButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("ListaDuenos.aspx");
        }
    }
}