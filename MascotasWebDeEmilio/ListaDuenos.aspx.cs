using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MascotasWebDeEmilio
{
    public partial class ListaDuenos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DuenosGridView.DataSource = MascotasWebDeEmilio.App_Code.BLL.DuenoBLL.DuenoBLL.GetDuenosBySearch("");
                DuenosGridView.DataBind();
            }
        }

        protected void DuenosGridView_SelectedIndexChanged(object sender, EventArgs e)
        {            
            int objectID = 0;


            try
            {
                objectID = Convert.ToInt32(DuenosGridView.SelectedDataKey["DuenoId"].ToString()); //ObjectID
            }
            catch { }

            if (objectID > 0 )
            {
                Session["DuenoId"] = objectID;
                Response.Redirect("~/DetalleDueno.aspx");

            }
            else
            {
                Response.Redirect("~/ListaDuenos.aspx");
            }
        }
    }
}