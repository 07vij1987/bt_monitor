using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Configuration;
using System.Data;
using System.Collections;
using System.Text;
using System.Drawing;

namespace BizTalk_Monitor
{
    public partial class SendPorts : System.Web.UI.Page
    {
        #region GlobalVariables

        string configurationFile = ConfigurationManager.AppSettings["BTConfigFile"];
        XmlDocument ConfigFile = new XmlDocument();
        ArrayList portNameList = null;
        string[] commandDetails = null;

        #endregion

        #region Page Events
        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor |  Send Ports";

            if (Session["AuthenticBTUser"] != null)
            {
                if (Session["BTRole"].Equals("ADMIN") || Session["BTRole"].Equals("USER"))
                {
                    ConfigFile.Load(Server.MapPath(configurationFile));

                    if (!IsPostBack)
                    {
                        try
                        {
                            ViewState["Status"] = "ALL";
                            ViewState["Transport"] = "ALL";
                            ViewState["ApplicationName"] = "ALL";
                            ViewState["SendHandler"] = "ALL";
                            LoadGrid();
                        }
                        catch (Exception ex)
                        {
                            DisplayWebMessage(ex);
                        }
                    }

                    StringBuilder sb = new StringBuilder();
                    sb.Append("<script language=JavaScript> scrollTo('a');</script>\n");
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "scrollDiv", sb.ToString());
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

        protected void btnEnable_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedPortList();
                ManageSendPort(portNameList, "Start");
                ResetGlobalVariables();
                Refresh();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
                Refresh();
            }

        }

        protected void btnDisable_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedPortList();
                ManageSendPort(portNameList, "Stop");
                ResetGlobalVariables();
                Refresh();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
                Refresh();
            }
        }

        protected void btnEnlist_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedPortList();
                ManageSendPort(portNameList, "Enlist");
                ResetGlobalVariables();
                Refresh();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
                Refresh();
            }
        }

        protected void btnUnenlist_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedPortList();
                ManageSendPort(portNameList, "Unenlist");
                ResetGlobalVariables();
                Refresh();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void grdViewSendPorts_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                // e.Row.ToolTip = "Click to view artifact.";
                //e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                //e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
            }
        }

        protected void grdViewSendPorts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ShowPopup")
                {
                    LinkButton btndetails = (LinkButton)e.CommandSource;
                    GridViewRow gvrow = (GridViewRow)btndetails.NamingContainer;
                    menuProperties.Items[5].Enabled = false;
                    menuProperties.Items[5].Text = "";

                    lblLocationNTypeName.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[2].Text);
                    lblSendportName.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[2].Text);
                    txtPortStatus.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[3].Text);
                    txtTransportType.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[5].Text);
                    txtTransportURI.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[4].Text);
                    txtHandler.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[6].Text);



                    string strcommand = string.Empty;

                    strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/SendPortInfo").InnerText.Trim();
                    strcommand = String.Format(strcommand, gvrow.Cells[2].Text);

                    DataSet SendPortInfo = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQueryDataSet(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);

                    ClearSendPortInfo();
                    LoadSendPortInfo(SendPortInfo);

                    menuProperties.Items[0].Selected = true;
                    MultiView1.ActiveViewIndex = 0;

                    menuProperties.Items[1].Selected = false;
                    menuProperties.Items[2].Selected = false;
                    menuProperties.Items[3].Selected = false;
                    menuProperties.Items[4].Selected = false;
                    menuProperties.Items[5].Selected = false;
                    Popup(true);
                    ChangeDetailColor(gvrow, grdViewSendPorts);
                }
                else
                {
                    switch (e.CommandName)
                    {
                        case "SortStatus":
                            BindGrdViewMain("Status", GetMainSortDirection("Status"));
                            break;
                        case "SortTransport":
                            BindGrdViewMain("Transport", GetMainSortDirection("Transport"));
                            break;
                        case "SortApplicationName":
                            BindGrdViewMain("ApplicationName", GetMainSortDirection("ApplicationName"));
                            break;
                        case "SortSendHandler":
                            BindGrdViewMain("SendHandler", GetMainSortDirection("SendHandler"));
                            break;
                    }
                    hdnCheckBoxChk.Value = "0";
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void menuProperties_MenuItemClick(object sender, MenuEventArgs e)
        {
            int index = Int32.Parse(e.Item.Value);

            MultiView1.ActiveViewIndex = index;

            Popup(true);
        }

        protected void grdViewSendPorts_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                BindGrdViewMain(e.SortExpression, GetMainSortDirection(e.SortExpression));
                hdnCheckBoxChk.Value = "0";
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            try
            {
                grdViewSendPorts.DataSource = null;
                grdViewSendPorts.DataBind();

                chkAll.Visible = true;
                hdnCheckBoxChk.Value = "0";
                chkAll.Checked = false;
                btnDisable.Visible = true;
                btnEnable.Visible = true;
                btnEnlist.Visible = true;
                btnUnenlist.Visible = true;
                btnDisable.Enabled = false;
                btnEnable.Enabled = false;
                btnEnlist.Enabled = false;
                btnUnenlist.Enabled = false;

                LoadGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void ddlStatusChanged(object sender, EventArgs e)
        {
            DropDownList ddlStatusChanged = (DropDownList)sender;
            ViewState["Status"] = ddlStatusChanged.SelectedValue;
            try
            {
                this.LoadGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }

        }

        protected void ddlTransportChanged(object sender, EventArgs e)
        {
            DropDownList ddlTransportChanged = (DropDownList)sender;
            ViewState["Transport"] = ddlTransportChanged.SelectedValue;
            try
            {
                this.LoadGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }

        }

        protected void ddlApplicationNameChanged(object sender, EventArgs e)
        {
            DropDownList ddlApplicationNameChanged = (DropDownList)sender;
            ViewState["ApplicationName"] = ddlApplicationNameChanged.SelectedValue;
            try
            {
                this.LoadGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }

        }

        protected void ddlReceiveHandlerChanged(object sender, EventArgs e)
        {
            DropDownList ddlReceiveHandlerChanged = (DropDownList)sender;
            ViewState["SendHandler"] = ddlReceiveHandlerChanged.SelectedValue;
            try
            {
                this.LoadGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }

        }

        #endregion

        #region Private Functions

        private void ClearSendPortInfo()
        {
            chkOrdered.Checked = false;
            chkDelivery.Checked = false;
            chkFMR.Checked = false;
            txtPriority.Text = "";
            txtRetryCount.Text = "";
            txtInterval.Text = "";
            txtBTransportType.Text = "";
            txtBTransportURI.Text = "";
            txtBHandler.Text = "";
            txtBRetryCount.Text = "";
            txtBInterval.Text = "";
            txtBServiceWindow.Text = "";
            txtBServiceStart.Text = "";
            txtBServiceStop.Text = "";
            txtReceivePipeline.Text = "";
            txtFullyQualifiedName.Text = "";
            txtSendpipeline.Text = "";
            txtFullyQualifiedSendName.Text = "";
            lblFilters.Text = "";
        }
        
        private void LoadSendPortInfo(DataSet portInfo)
        {
            #region General
            if (portInfo.Tables[0].Rows.Count > 0)
            {
                if (Convert.ToBoolean(portInfo.Tables[0].Rows[0][0].ToString()))
                {
                    chkOrdered.Checked = true;
                }
                if (Convert.ToBoolean(portInfo.Tables[0].Rows[0][1].ToString()))
                {
                    chkDelivery.Checked = true;
                }

                if (!string.IsNullOrEmpty(portInfo.Tables[0].Rows[0][8].ToString()))
                {
                    if (Convert.ToBoolean(portInfo.Tables[0].Rows[0][8].ToString()))
                    {
                        chkFMR.Checked = true;
                    }
                }
                txtRetryCount.Text = " " + portInfo.Tables[0].Rows[0][2].ToString();
                txtPriority.Text = " " + portInfo.Tables[0].Rows[0][3].ToString();
                txtInterval.Text = " " + portInfo.Tables[0].Rows[0][4].ToString();

                if (Convert.ToBoolean(portInfo.Tables[0].Rows[0][5].ToString()))
                    txtServiceWindow.Text = " Enabled";
                else
                    txtServiceWindow.Text = " Disabled";

                txtServiceStart.Text = " " + portInfo.Tables[0].Rows[0][6].ToString();
                txtServiceStop.Text = " " + portInfo.Tables[0].Rows[0][7].ToString();
            }
            #endregion

            #region BackupTransport
            if (portInfo.Tables[1].Rows.Count > 0)
            {
                txtBTransportType.Text = " " + portInfo.Tables[1].Rows[0][1].ToString();
                txtBTransportURI.Text = " " + portInfo.Tables[1].Rows[0][0].ToString();
                txtBHandler.Text = " " + portInfo.Tables[1].Rows[0][2].ToString();
                
                txtBRetryCount.Text = " " + portInfo.Tables[1].Rows[0][3].ToString();
                txtBInterval.Text = " " + portInfo.Tables[1].Rows[0][4].ToString();

                if (Convert.ToBoolean(portInfo.Tables[1].Rows[0][5].ToString()))
                    txtBServiceWindow.Text = " Enabled";
                else
                    txtBServiceWindow.Text = " Disabled";

                txtBServiceStart.Text = " " + portInfo.Tables[1].Rows[0][6].ToString();
                txtBServiceStop.Text = " " + portInfo.Tables[1].Rows[0][7].ToString();
            }
            #endregion

            #region SendPipeLine
            if (portInfo.Tables[2].Rows.Count > 0)
            {
                txtSendpipeline.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[2].Rows[0][0].ToString());
                txtFullyQualifiedSendName.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[2].Rows[0][1].ToString());
            }
            else
            {
                txtSendpipeline.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[3].Rows[0][0].ToString());
                txtFullyQualifiedSendName.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[3].Rows[0][1].ToString());
            }
            #endregion

            #region ReceivePipeline

            if (portInfo.Tables[4].Rows.Count > 0)
            {
                menuProperties.Items[5].Enabled = true;
                menuProperties.Items[5].Text = "RECEIVE PIPELINE";
                txtReceivePipeline.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[4].Rows[0][0].ToString());
                txtFullyQualifiedName.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[4].Rows[0][1].ToString());
            }
            else if (portInfo.Tables[5].Rows.Count > 0)
            {
                menuProperties.Items[5].Enabled = true;
                menuProperties.Items[5].Text = "RECEIVE PIPELINE";
                txtReceivePipeline.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[5].Rows[0][0].ToString());
                txtFullyQualifiedName.Text = HttpUtility.HtmlDecode(" " + portInfo.Tables[5].Rows[0][1].ToString());
            }
            #endregion

            #region Filters
            if (portInfo.Tables[6].Rows.Count > 0)
            {
                if (string.IsNullOrEmpty(portInfo.Tables[6].Rows[0][0].ToString()))
                {
                    lblFilters.Text = "<pre><span style=\"color: gray\"><b>" + " No Filters Set" + "</b></span></pre>";
                }
                else
                {
                    lblFilters.Text=BizTalk_Monitor_Helper.MonitorHelper.ReadFilters(portInfo.Tables[6].Rows[0][0].ToString());
                }
            }
            #endregion
        }
        
        private void ReturnSelectedPortList()
        {
            portNameList = new ArrayList();
            foreach (GridViewRow row in grdViewSendPorts.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkDelete");

                if (chkBoxRows.Checked)
                {
                    portNameList.Add(row.Cells[2].Text);
                }
            }
        }

        private void Refresh()
        {
            grdViewSendPorts.DataSource = null;
            try
            {
                LoadGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
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

        private void BindGrdViewMain(string sortExp, string sortDir)
        {
            DataTable sendPorts = (DataTable)ViewState["SendPortTable"];

            if (sendPorts.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = sendPorts.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdViewSendPorts.DataSource = myDataView;
                grdViewSendPorts.DataBind();
            }
            else
            {
                grdViewSendPorts.DataSource = null;
                grdViewSendPorts.DataBind();
            }
        }

        private void ManageSendPort(ArrayList portNameList, string level)
        {
            try
            {               
                int portStatus = 0;
                if (portNameList != null)
                {
                    switch (level)
                    {
                        case "Start":
                            portStatus = 3;
                            break;
                        case "Stop":
                            portStatus = 2;
                            break;
                        case "Unenlist":
                            portStatus = 1;
                            break;
                    }

                    foreach (string port in portNameList)
                    {
                        BizTalk_Monitor_Helper.MonitorHelper.ManageSendPortOM(port, ConfigurationManager.AppSettings["serverNameKey"].ToString(), portStatus);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void ResetGlobalVariables()
        {
            portNameList = null;
            commandDetails = null;
        }

        private void LoadGrid()
        {
            ArrayList sharedServers = new ArrayList();
            string strcommand = string.Empty;

            try
            {
                sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/SENDPORTSSHARED").InnerText.Trim();
                
                if (sharedServers.Contains(ConfigurationManager.AppSettings["serverNameKey"].ToString()))
                {
                    strcommand = String.Format(strcommand, "AND APP.nvcName LIKE ''%" + Session["AppDomain"].ToString() + "%''", ViewState["Status"].ToString(), ViewState["Transport"].ToString(), ViewState["ApplicationName"].ToString(), ViewState["SendHandler"].ToString());
                }
                else
                {
                    strcommand = String.Format(strcommand,"", ViewState["Status"].ToString(), ViewState["Transport"].ToString(), ViewState["ApplicationName"].ToString(), ViewState["SendHandler"].ToString());
                }

                ViewState["MainGridCommand"] = "";
                ViewState["MainGridCommand"] = strcommand;

                DataTable receiveLocation = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
                ViewState["SendPortTable"] = receiveLocation;
                grdViewSendPorts.DataSource = receiveLocation;
                grdViewSendPorts.DataBind();

                chkAll.Visible = true;
                chkAll.Checked = false;
                hdnCheckBoxChk.Value = "0";
                btnDisable.Visible = true;
                btnEnable.Visible = true;
                btnEnlist.Visible = true;
                btnUnenlist.Visible = true;
                btnDisable.Enabled = false;
                btnEnable.Enabled = false;
                btnEnlist.Enabled = false;
                btnUnenlist.Enabled = false;
                btnRefresh.Visible = true;

                this.BindFilterList();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private void DisplayWebMessage(Exception ex)
        {
            string errorLogFile = ConfigurationManager.AppSettings["ErrorLogs"];
            string logFile = HttpContext.Current.Server.MapPath(errorLogFile);
            BizTalk_Monitor_Helper.MonitorHelper.DisplayMessageLogError(ex, logFile);

            StringBuilder builder = new StringBuilder();
            lblErrorMask.Text = "<pre><span style=\"color: gray\"><b>" + " Error while processing the request, Please check with support." + "</b></span></pre>";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowErrorMask", "javascript:ShowErrorMask()", true);
        }

        private void Popup(bool isDisplay)
        {
            StringBuilder builder = new StringBuilder();
            if (isDisplay)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowPOPUP", "javascript:ShowPopup()", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowPOPUP", "javascript:HidePopup();", true);
            }
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

        private void BindFilterList()
        {
            DataSet dt = new DataSet();
            ArrayList sharedServers = new ArrayList();
            string strcommand = string.Empty;

            try
            {
                DropDownList ddlStatus = (DropDownList)grdViewSendPorts.HeaderRow.FindControl("ddlStatus");
                DropDownList ddlTransport = (DropDownList)grdViewSendPorts.HeaderRow.FindControl("ddlTransport");
                DropDownList ddlApplicationName = (DropDownList)grdViewSendPorts.HeaderRow.FindControl("ddlApplicationName");
                DropDownList ddlReceiveHandler = (DropDownList)grdViewSendPorts.HeaderRow.FindControl("ddlReceiveHandler");

                sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/SendPortFiltersShared").InnerText.Trim();

                if (sharedServers.Contains(ConfigurationManager.AppSettings["serverNameKey"].ToString()))
                {
                    strcommand = String.Format(strcommand, " WHERE nvcName LIKE '%" + Session["AppDomain"].ToString() + "%' ", " AND Name LIKE '%" + Session["HostDomain"].ToString() + "%' ");
                }
                else
                {
                    strcommand = String.Format(strcommand, "", "");
                }

                dt = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQueryDataSet(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);

                ddlStatus.DataSource = dt.Tables[0];
                ddlTransport.DataSource = dt.Tables[1];
                ddlApplicationName.DataSource = dt.Tables[2];
                ddlReceiveHandler.DataSource = dt.Tables[3];


                ddlStatus.DataTextField = "Status";
                ddlStatus.DataValueField = "Status";
                ddlStatus.DataBind();
                ddlStatus.Items.FindByValue(ViewState["Status"].ToString()).Selected = true;

                ddlTransport.DataTextField = "NAME";
                ddlTransport.DataValueField = "NAME";
                ddlTransport.DataBind();
                ddlTransport.Items.FindByValue(ViewState["Transport"].ToString()).Selected = true;

                ddlApplicationName.DataTextField = "nvcName";
                ddlApplicationName.DataValueField = "nvcName";
                ddlApplicationName.DataBind();
                ddlApplicationName.Items.FindByValue(ViewState["ApplicationName"].ToString()).Selected = true;

                ddlReceiveHandler.DataTextField = "NAME";
                ddlReceiveHandler.DataValueField = "NAME";
                ddlReceiveHandler.DataBind();
                ddlReceiveHandler.Items.FindByValue(ViewState["SendHandler"].ToString()).Selected = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dt = null;
            }

        }

        #endregion
    }
}