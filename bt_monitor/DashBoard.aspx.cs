using System;
using System.Web.UI.WebControls;
using System.Configuration;


namespace bt_monitor
{
    public partial class DashBoard : System.Web.UI.Page
    {
        string serverName = ConfigurationManager.AppSettings["serverNameValue"];

        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor | " + serverName;

            if (Session["AuthenticBTUser"] != null)
            {
                if (Session["BTRole"].Equals("ADMIN") || Session["BTRole"].Equals("USER") || Session["BTRole"].Equals("SUSPENSION"))
                {

                }
                else
                {
                    Response.Redirect("ErrorPage.aspx", true);
                }
            }
        }

        protected void Menu1_MenuItemClick(object sender, MenuEventArgs e)
        {

            int index = Int32.Parse(e.Item.Value);

            MultiView1.ActiveViewIndex = index;
            if (index == 0)
            {
                lblUesrInfoText.Text = "<pre><span style=\"color: gray\">WELCOME, <span style=\"color: green\"><b>" + Session["BTUSER"] + "</b></span></span></pre>";
                lblDatabase.Text = "<pre><span style=\"color: gray\"><b>" + " BizTalkMgmtDb" + "</b></span></pre>";
                lblBTServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["BizTalkServers"].ToString() + " </b></span></pre>";
                lblDBServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["DatabaseServers"].ToString() + " </b></span></pre>";
                lblBTDRServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["DRServers"].ToString() + " </b></span></pre>";
                lblDBDRServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["DRDBServers"].ToString() + " </b></span></pre>";
            }
        }

        protected void btnExecuteQuery_Click(object sender, EventArgs e)
        {

        }

        protected void gridEventViewer_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        }
        protected void gridEventViewer_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
        }
    }
}