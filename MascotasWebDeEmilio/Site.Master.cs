using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MascotasWebDeEmilio
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void MainButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/MainPage.aspx");
        }

        protected void ListaDuenosLinkButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ListaDuenos.aspx");
        }

        protected void RegistroDuenoLinkButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/RegistroDueno.aspx");
        }

        protected void ListaMascotasLinkButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ListaMascotas.aspx");
        }

        protected void RegistroMascotaLinkButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/RegistroMascota.aspx");
        }
    }
}