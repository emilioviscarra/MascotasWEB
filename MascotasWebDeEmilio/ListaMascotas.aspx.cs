using MascotasWebDeEmilio.App_Code.BLL.MascotaBLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MascotasWebDeEmilio
{
    public partial class ListaMascotas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //llenar tabla de mascotas del dueño
            MascotasGridView.DataSource = MascotasWebDeEmilio.App_Code.BLL.MascotaBLL.MascotaBLL.GetMascotaBySearch("");
            MascotasGridView.DataBind();
        }

        protected void MascotasGridView_SelectedIndexChanged(object sender, EventArgs e)
        {
            int duenoId = 0;
            int mascotaId = 0;

            try
            {
                mascotaId = Convert.ToInt32(MascotasGridView.SelectedValue);
            }
            catch { }

            if (mascotaId > 0)
            {
                try
                {
                    duenoId = MascotaBLL.GetMascotaById(mascotaId).DuenoId;
                }
                catch { }

                Session["DuenoId"] = duenoId.ToString();
                Response.Redirect("DetalleDueno.aspx");
            }
        }
    }
}