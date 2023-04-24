using MascotasWebDeEmilio.App_Code.BLL.DuenoBLL;
using MascotasWebDeEmilio.App_Code.Class.Dueno;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class DetalleDueno : System.Web.UI.Page
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

            Dueno theDueno = null;

            if (DuenoId > 0)
            {
                try
                {
                    theDueno = DuenoBLL.GetDuenoDetails(DuenoId);
                }
                catch { }

                DuenoIdHF.Value = DuenoId.ToString();
                Session["DuenoId"] = 0;
            }
            else
                Response.Redirect("ListaDuenos.aspx");

            if (theDueno == null)
            {
                //mensaje de error
            }
            else
            {
                // llenar detalles
                NombreLabel.Text = theDueno.Nombres;
                ApellidosLabel.Text = theDueno.Apellidos;
                DireccionLabel.Text = theDueno.Direccion;
                NombreCompletoDuenoLabel.Text = " " + theDueno.Nombres + " " + theDueno.Apellidos + ":";


                //llenar tabla de mascotas del dueño
                MascotasGridView.DataSource = MascotasWebDeEmilio.App_Code.BLL.MascotaBLL.MascotaBLL.GetMascotasByDueno(theDueno.DuenoId);
                MascotasGridView.DataBind();
            }

        }
    }  

    protected void NuevaMascotaDuenoLinkButton_Click(object sender, EventArgs e)
    {
        int duenoId = 0;

        try
        {
            duenoId = Convert.ToInt32(DuenoIdHF.Value);
        }
        catch { }

        if (duenoId > 0)
        {
            Session["DuenoId"] = duenoId.ToString();
            Response.Redirect("RegistroMascota.aspx");
        }
    }

    protected void CancelarLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ListaDuenos.aspx");
    }

    protected void EditarDuenoBT_Click(object sender, EventArgs e)
    {
        //PENDIENTE, realizar formulario de edicion de dueno
    }
}
