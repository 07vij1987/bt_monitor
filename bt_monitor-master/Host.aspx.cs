using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Configuration;
using System.Data;
using System.Collections;
using System.Text;

namespace BizTalk_Monitor
{
    public partial class Host : System.Web.UI.Page
    {

        #region GlobalVariables
        string configurationFile = ConfigurationManager.AppSettings["BTConfigFile"];
        XmlDocument ConfigFile = new XmlDocument();
        #endregion
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor |  Hosts";

            if (Session["AuthenticBTUser"] != null)
            {
                if (Session["BTRole"].Equals("ADMIN") || Session["BTRole"].Equals("USER"))
                {

                    if (ViewState["HostDomain"] == null)
                    {
                        ViewState["HostDomain"] = Session["HostDomain"].ToString();
                    }
                    
                    ConfigFile.Load(Server.MapPath(configurationFile));
                   // btnHost.Visible = true;
                    if (!IsPostBack)
                    {
                        try
                        {
                            if (ViewState["HostDomain"] != null)
                            {
                                string strcommand = string.Empty;
                                ArrayList sharedServers = new ArrayList();

                                sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));

                                if (sharedServers.Contains(ConfigurationManager.AppSettings["serverNameKey"].ToString()))
                                {
                                    strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/HOSTINFOSHARED").InnerText.Trim();
                                    strcommand = String.Format(strcommand, ViewState["HostDomain"].ToString());
                                }
                                else
                                {
                                    strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/HOSTINFO").InnerText.Trim();
                                }

                                DataTable hostTable = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);

                                grdViewHostMain.DataSource = hostTable;
                                grdViewHostMain.DataBind();
                                grdViewHostMain.UseAccessibleHeader = true;
                                grdViewHostMain.HeaderRow.TableSection = TableRowSection.TableHeader;

                               // btnHost.Visible = false;
                            }
                            else
                            {
                                Response.Redirect("DashBoard.aspx");
                            }
                        }
                        catch (Exception ex)
                        {
                            DisplayWebMessage(ex);
                        }
                    }
                }
                else
                {
                    if (Session["BTRole"].Equals("SUSPENSION"))
                        Response.Redirect("DashBoard.aspx", true);
                    else
                    {
                        Response.Redirect("ErrorPage.aspx", true);
                    }
                }
            }
        }
        protected void grdViewHostMain_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");

            }

        }
        protected void grdViewHostMain_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        private void DisplayWebMessage(Exception ex)
        {
            string errorLogFile = ConfigurationManager.AppSettings["ErrorLogs"];
            string logFile = HttpContext.Current.Server.MapPath(errorLogFile);
            StringBuilder sb = new StringBuilder();
            sb.Append("<script type=\'text/javascript\'>");
            sb.Append("alert('");
            sb.Append("Error while processing!Please check with support" + "')");
            sb.Append("</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "disable", sb.ToString());
            BizTalk_Monitor_Helper.MonitorHelper.DisplayMessageLogError(ex,logFile);
        }
    }
}