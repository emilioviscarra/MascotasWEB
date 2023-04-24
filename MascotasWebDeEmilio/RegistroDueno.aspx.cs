using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class RegistroDueno : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
        }
    }

    protected void GuardarDuenoBT_Click(object sender, EventArgs e)
    {
        MascotasWebDeEmilio.App_Code.Class.Dueno.Dueno theDueno = new MascotasWebDeEmilio.App_Code.Class.Dueno.Dueno();

        string nombre = NombreTB.Text.Trim();
        string apellidos = ApellidosTB.Text.Trim();
        string direccion = DireccionTB.Text.Trim();
        int duenoId = 0;

        //Validar textos

        try
        {
            theDueno = new MascotasWebDeEmilio.App_Code.Class.Dueno.Dueno(duenoId, nombre, apellidos, direccion);

            duenoId = MascotasWebDeEmilio.App_Code.BLL.DuenoBLL.DuenoBLL.InsertarDueno(theDueno);
        }
        catch
        {

        }

        if (duenoId > 0)
        {
            //enviar a pagina de detalles
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

