using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Text;
using System.Drawing;

namespace BizTalk_Monitor
{
    public partial class ApplicationInformation : System.Web.UI.Page
    {
        #region GlobalVariables

        string configurationFile = ConfigurationManager.AppSettings["BTConfigFile"];
        string warningCount = ConfigurationManager.AppSettings["warningCount"];
        XmlDocument ConfigFile = new XmlDocument();

        #endregion

        #region Page Events

        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor |  Applications";

            if (Session["AuthenticBTUser"] != null)
            {
                if (Session["BTRole"].Equals("ADMIN") || Session["BTRole"].Equals("USER"))
                {
                    ConfigFile.Load(Server.MapPath(configurationFile));
                    if (!IsPostBack)
                    {
                        try
                        {
                            DataTable mainGridDataTable = GetMainGridData(ConfigurationManager.AppSettings["serverNameKey"].ToString());
                            ViewState["ApplicationInformation"] = mainGridDataTable;

                            if (mainGridDataTable.Rows.Count > 0)
                            {
                                grdAppInfo.DataSource = mainGridDataTable;
                                grdAppInfo.DataBind();
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

        protected void grdAppInfo_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                BindGrdViewMain(e.SortExpression, GetMainSortDirection(e.SortExpression));
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void grdAppInfo_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lblSuspension = (Label)e.Row.FindControl("lblSuspensionCount");
                if (Convert.ToInt32(lblSuspension.Text) > Convert.ToInt32(warningCount))
                    lblSuspension.CssClass = "red";
                else
                {
                    lblSuspension.CssClass = "gray";
                    lblSuspension.Text = "";
                }

                if (Convert.ToInt32(e.Row.Cells[2].Text) > 0)
                {
                    e.Row.Cells[2].Text = "Partail";
                }
                else
                {
                    e.Row.Cells[2].Text = "Complete";
                }

            }

        }

        protected void grdAppInfo_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            grdViewRP.DataSource = null;
            grdViewRC.DataSource = null;
            grdViewSP.DataSource = null;
            grdViewODX.DataSource = null;
            grdViewRP.Visible = false;
            grdViewRC.Visible = false;
            grdViewSP.Visible = false;
            grdViewODX.Visible = false;

            if (e.CommandName == "ShowPopup")
            {
                LinkButton btndetails = (LinkButton)e.CommandSource;
                GridViewRow gvrow = (GridViewRow)btndetails.NamingContainer;
                lblAppName.Text = HttpUtility.HtmlDecode(gvrow.Cells[1].Text);

                DataSet artifactInfo = GetArtifactData(lblAppName.Text);
                
                grdViewRP.DataSource = artifactInfo.Tables[0];
                grdViewRC.DataSource = artifactInfo.Tables[1];
                grdViewSP.DataSource = artifactInfo.Tables[2];
                grdViewODX.DataSource = artifactInfo.Tables[3];

                grdViewRP.DataBind();
                grdViewRC.DataBind();
                grdViewSP.DataBind();
                grdViewODX.DataBind();

                grdViewRP.Visible = true;
                grdViewRC.Visible = true;
                grdViewSP.Visible = true;
                grdViewODX.Visible = true;
                MultiView1.ActiveViewIndex = 0;
                menuArtifacts.Items[0].Selected = true;
                Popup(true);
                ChangeDetailColor(gvrow, grdAppInfo);
            }

            

        }

        protected void menuArtifacts_MenuItemClick(object sender, MenuEventArgs e)
        {
            int index = Int32.Parse(e.Item.Value);
            MultiView1.ActiveViewIndex = index;
            Popup(true);
        }

        protected void grdViewArtifactsInfo_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {                
                e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
            }

        }

        #endregion

        #region Private Methods

        private void Popup(bool isDisplay)
        {
            StringBuilder builder = new StringBuilder();
            if (isDisplay)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowPOPUP", "javascript:ShowPopup()", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowPOPUP", "javascript:HidePopup()", true);
            }
        }

        private DataTable GetMainGridData(string serverName)
        {
            string strcommand = string.Empty;
            
            ArrayList sharedServers = new ArrayList();
            sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));

            if (sharedServers.Contains(serverName))
            {
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/APPINFOSHARED").InnerText.Trim();
                strcommand = String.Format(strcommand, Session["AppDomain"] .ToString());
            }
            else
            {
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/APPINFO").InnerText.Trim();
            }
            
            DataTable suspendtable = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQuery(serverName, strcommand);
            return suspendtable;
        }

        private DataSet GetArtifactData(string appName)
        {
            DataSet artifactInfo = new DataSet();
            string strNewcommand = string.Empty;
            
             string rp = ConfigFile.SelectSingleNode(@"/ConfigurationValues/APPReceivePort").InnerText.Trim();
             string rl = ConfigFile.SelectSingleNode(@"/ConfigurationValues/AppReceiveLocation").InnerText.Trim();
             string sp= ConfigFile.SelectSingleNode(@"/ConfigurationValues/AppSendPorts").InnerText.Trim();
             string odx= ConfigFile.SelectSingleNode(@"/ConfigurationValues/AppOrchestrations").InnerText.Trim();


            strNewcommand = String.Format(rp + " " + rl + " "+ sp+" "+ odx, appName);
            artifactInfo = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQueryDataSet(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strNewcommand);

            return artifactInfo;
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

        private void BindGrdViewMain(string sortExp, string sortDir)
        {
            DataTable sendPorts = (DataTable)ViewState["ApplicationInformation"];

            if (sendPorts.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = sendPorts.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdAppInfo.DataSource = myDataView;
                grdAppInfo.DataBind();
            }
            else
            {
                grdAppInfo.DataSource = null;
                grdAppInfo.DataBind();
            }
        }

        private string GetMainSortDirection(string column)
        {
            string sortDirection = "ASC";
            string sortExpression = ViewState["MainSortExpression"] as string;

            if (sortExpression != null)
            {
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["MainSortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                }
            }

            ViewState["MainSortDirection"] = sortDirection;
            ViewState["MainSortExpression"] = column;

            return sortDirection;
        }

        private void ChangeDetailColor(GridViewRow gvrow, GridView grd)
        {
            int count = 0;

            foreach (GridViewRow row in grd.Rows)
            {
                if (count % 2 == 0)
                {
                    row.BackColor = ColorTranslator.FromHtml("#FFFFFF");
                }
                else
                {
                    row.BackColor = ColorTranslator.FromHtml("#EFF3FB");
                }
                row.ForeColor = ColorTranslator.FromHtml("#000000");
                //row.ToolTip = "Click to select this row.";

                count = count + 1;
            }

            gvrow.BackColor = ColorTranslator.FromHtml("#3BB9FF");
            gvrow.ForeColor = ColorTranslator.FromHtml("#FFFFFF");
        }

        #endregion
    }
}