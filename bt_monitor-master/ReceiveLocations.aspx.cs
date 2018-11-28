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
    public partial class ReceiveLocations : System.Web.UI.Page
    {
        #region GlobalVariables

        string configurationFile = ConfigurationManager.AppSettings["BTConfigFile"];
        XmlDocument ConfigFile = new XmlDocument();
        ArrayList locationNameList = null;
        ArrayList portNameList = null;
        string[] commandDetails = null;

        #endregion

        #region Page Events
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor |  Receive Locations";

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
                            ViewState["PortName"] = "ALL";
                            ViewState["ReceiveHandler"] = "ALL";

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
                ReturnSelectedLocationList();
                ManageReceiveLocation(locationNameList, true);
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
                ReturnSelectedLocationList();
                ManageReceiveLocation(locationNameList, false);
                ResetGlobalVariables();
                Refresh();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
                Refresh();
            }
        }

        protected void btnEnableWindow_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedLocationList();
                EnableDisableServiceWindow(locationNameList, true);
                ResetGlobalVariables();
                Refresh();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
                Refresh();
            }
        }

        protected void btnDisableWindow_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedLocationList();
                EnableDisableServiceWindow(locationNameList,false);
                ResetGlobalVariables();
                Refresh();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void grdViewReceiveLocations_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
        }

        protected void grdViewReceiveLocations_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ShowPopup")
                {

                    LinkButton btndetails = (LinkButton)e.CommandSource;
                    GridViewRow gvrow = (GridViewRow)btndetails.NamingContainer;
                    menuProperties.Items[3].Enabled = false;
                    menuProperties.Items[3].Text = "";

                    lblLocationNTypeName.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[2].Text);
                    lblRecvLocationName.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[2].Text);
                    txtLocationStatus.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[3].Text);
                    txtReceivePort.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[9].Text);
                    txtTransportType.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[4].Text);
                    txtTransportURI.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[8].Text);
                    txtHandler.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[10].Text);
                    txtServiceStart.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[6].Text);
                    txtServiceStop.Text = HttpUtility.HtmlDecode(" " + gvrow.Cells[7].Text);

                    if (gvrow.Cells[5].Text.Equals("owYES"))
                        txtServiceWindow.Text = " Enabled";
                    else
                        txtServiceWindow.Text = " Disabled";

                    string strcommand = string.Empty;
                    string sendPipelineCmd = string.Empty;

                    strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/ReceivePIPELINEInfo").InnerText.Trim();
                    strcommand = String.Format(strcommand, gvrow.Cells[2].Text);
                    sendPipelineCmd = ConfigFile.SelectSingleNode(@"/ConfigurationValues/SendPIPELINEInfo").InnerText.Trim();
                    sendPipelineCmd = String.Format(sendPipelineCmd, gvrow.Cells[2].Text);

                    DataSet ReceivePipelineDataSet = null;
                    DataSet SendPipelineDataSet = null;


                    ReceivePipelineDataSet = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQueryDataSet(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
                    SendPipelineDataSet = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQueryDataSet(ConfigurationManager.AppSettings["serverNameKey"].ToString(), sendPipelineCmd);

                    ClearPipelineInfo();

                    LoadReceivePipelineInfo(ReceivePipelineDataSet);
                    LoadSendPipelineInfo(SendPipelineDataSet);

                    menuProperties.Items[0].Selected = true;
                    MultiView1.ActiveViewIndex = 0;

                    menuProperties.Items[1].Selected = false;
                    menuProperties.Items[2].Selected = false;
                    menuProperties.Items[3].Selected = false;
                    Popup(true);
                    ChangeDetailColor(gvrow, grdViewReceiveLocations);
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
                        case "SortPortName":
                            BindGrdViewMain("PortName", GetMainSortDirection("PortName"));
                            break;
                        case "SortReceiveHandler":
                            BindGrdViewMain("ReceiveHandler", GetMainSortDirection("ReceiveHandler"));
                            break;
                    }
                    hdnCheckBoxChk.Value = "0";
                    hdnCheckBoxChkW.Value = "0";
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

        protected void grdViewReceiveLocations_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                BindGrdViewMain(e.SortExpression, GetMainSortDirection(e.SortExpression));
                hdnCheckBoxChk.Value = "0";
                hdnCheckBoxChkW.Value = "0";
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
                grdViewReceiveLocations.DataSource = null;
                grdViewReceiveLocations.DataBind();
                
                chkAll.Visible = true;
                chkAll.Checked = false;
                hdnCheckBoxChk.Value = "0";
                hdnCheckBoxChkW.Value = "0";
                btnDisable.Visible = true;
                btnEnable.Visible = true;
                btnDisable.Enabled = false;
                btnEnable.Enabled = false;
                btnDisableWindow.Visible = true;
                btnEnableWindow.Visible = true;
                btnDisableWindow.Enabled = false;
                btnEnableWindow.Enabled = false;
                btnRefresh.Visible = true;


                ViewState["Status"] = "ALL";
                ViewState["Transport"] = "ALL";
                ViewState["ApplicationName"] = "ALL";
                ViewState["PortName"] = "ALL";
                ViewState["ReceiveHandler"] = "ALL";

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
        
        protected void ddlPortNameChanged(object sender, EventArgs e)
        {
            DropDownList ddlPortNameChanged = (DropDownList)sender;
            ViewState["PortName"] = ddlPortNameChanged.SelectedValue;
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
            ViewState["ReceiveHandler"] = ddlReceiveHandlerChanged.SelectedValue;
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

        private void LoadGrid()
        {
            ArrayList sharedServers = new ArrayList();
            string strcommand = string.Empty;

            sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));
            strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/ReceiveLocationsShared").InnerText.Trim();

            if (sharedServers.Contains(ConfigurationManager.AppSettings["serverNameKey"].ToString()))
            {

                strcommand = String.Format(strcommand, " WHERE APP.nvcName LIKE ''%" + Session["AppDomain"].ToString() + "%'' ", ViewState["Status"].ToString(), ViewState["Transport"].ToString(), ViewState["ApplicationName"].ToString(), ViewState["PortName"].ToString(), ViewState["ReceiveHandler"].ToString());
            }
            else
            {
                strcommand = String.Format(strcommand,"", ViewState["Status"].ToString(), ViewState["Transport"].ToString(), ViewState["ApplicationName"].ToString(), ViewState["PortName"].ToString(), ViewState["ReceiveHandler"].ToString());
            }

            try
            {
                ViewState["MainGridCommand"] = string.Empty;
                ViewState["MainGridCommand"] = strcommand;

                DataTable receiveLocation = BizTalk_Monitor_Helper.MonitorHelper.ExecuteMgmtQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);

                ViewState["ReceiveLocationstable"] = receiveLocation;

                grdViewReceiveLocations.DataSource = receiveLocation;
                grdViewReceiveLocations.DataBind();

                chkAll.Visible = true;
                chkAll.Checked = false;
                hdnCheckBoxChk.Value = "0";
                hdnCheckBoxChkW.Value = "0";
                btnDisable.Visible = true;
                btnEnable.Visible = true;
                btnDisable.Enabled = false;
                btnEnable.Enabled = false;
                btnDisableWindow.Visible = true;
                btnEnableWindow.Visible = true;
                btnDisableWindow.Enabled = false;
                btnEnableWindow.Enabled = false;
                btnRefresh.Visible = true;

                this.BindFilterList();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private void BindFilterList()
        {
            DataSet dt = new DataSet();
            ArrayList sharedServers = new ArrayList();
            string strcommand = string.Empty;

            try
            {
                DropDownList ddlStatus = (DropDownList)grdViewReceiveLocations.HeaderRow.FindControl("ddlStatus");
                DropDownList ddlTransport = (DropDownList)grdViewReceiveLocations.HeaderRow.FindControl("ddlTransport");
                DropDownList ddlApplicationName = (DropDownList)grdViewReceiveLocations.HeaderRow.FindControl("ddlApplicationName");
                DropDownList ddlPortName = (DropDownList)grdViewReceiveLocations.HeaderRow.FindControl("ddlPortName");
                DropDownList ddlReceiveHandler = (DropDownList)grdViewReceiveLocations.HeaderRow.FindControl("ddlReceiveHandler");

                sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/ReceiveLocationFiltersShared").InnerText.Trim();

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
                ddlPortName.DataSource = dt.Tables[3];
                ddlReceiveHandler.DataSource = dt.Tables[4];


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

                ddlPortName.DataTextField = "nvcName";
                ddlPortName.DataValueField = "nvcName";
                ddlPortName.DataBind();
                ddlPortName.Items.FindByValue(ViewState["PortName"].ToString()).Selected = true;

                ddlReceiveHandler.DataTextField = "NAME";
                ddlReceiveHandler.DataValueField = "NAME";
                ddlReceiveHandler.DataBind();
                ddlReceiveHandler.Items.FindByValue(ViewState["ReceiveHandler"].ToString()).Selected = true;
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

        private void BindGrdViewMain(string sortExp, string sortDir)
        {
            DataTable receiveLocation = (DataTable)ViewState["ReceiveLocationstable"];
                
            if (receiveLocation.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = receiveLocation.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdViewReceiveLocations.DataSource = myDataView;
                grdViewReceiveLocations.DataBind();
            }
            else
            {
                grdViewReceiveLocations.DataSource = null;
                grdViewReceiveLocations.DataBind();
            }

            this.BindFilterList();
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

        private void ReturnSelectedLocationList()
        {
            locationNameList = new ArrayList();
            portNameList = new ArrayList();
            foreach (GridViewRow row in grdViewReceiveLocations.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkDelete");

                if (chkBoxRows.Checked)
                {
                    locationNameList.Add(row.Cells[2].Text);
                    portNameList.Add((row.Cells[10].Controls[0] as DataBoundLiteralControl).Text.Replace("\r\n", string.Empty) );
                }
            }
        }

        private void ManageReceiveLocation(ArrayList locationNameList, bool status)
        {
            try
            {
                string message = string.Empty;
                string headerText = string.Empty;

                if (locationNameList != null)
                {
                    int portCount = 0;
                    
                    foreach (string recvLocation in locationNameList)
                    {
                        BizTalk_Monitor_Helper.MonitorHelper.ManageReceiveLocationOM(recvLocation, portNameList[portCount].ToString(), ConfigurationManager.AppSettings["serverNameKey"].ToString(), status);
                        portCount = portCount + 1;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void EnableDisableServiceWindow(ArrayList locationNameList, bool status)
        {
            try
            {
                if (locationNameList != null)
                {
                    int portCount = 0;

                    foreach (string recvLocation in locationNameList)
                    {
                        BizTalk_Monitor_Helper.MonitorHelper.ManageReceiveLocationWindowOM(recvLocation, portNameList[portCount].ToString(), ConfigurationManager.AppSettings["serverNameKey"].ToString(), status);
                        portCount = portCount + 1;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
 
        }
        
        private void Refresh()
        {
            grdViewReceiveLocations.DataSource = null;
            LoadGrid();
        }
        
        private void ResetGlobalVariables()
        {
            locationNameList = null;
            commandDetails = null;
            portNameList = null;
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

        private void LoadReceivePipelineInfo(DataSet pipelineInfo)
        {
            if (pipelineInfo.Tables[0].Rows.Count > 0)
            {
                txtReceivePipeline.Text = HttpUtility.HtmlDecode(" " + pipelineInfo.Tables[0].Rows[0][1].ToString());
                txtFullyQualifiedName.Text = HttpUtility.HtmlDecode(" " + pipelineInfo.Tables[0].Rows[0][2].ToString());
            }
            else
            {
                txtReceivePipeline.Text = HttpUtility.HtmlDecode(" " + pipelineInfo.Tables[1].Rows[0][0].ToString());
                txtFullyQualifiedName.Text = HttpUtility.HtmlDecode(" " + pipelineInfo.Tables[1].Rows[0][1].ToString());
            }
        }

        private void LoadSendPipelineInfo(DataSet sendPipelineInfo)
        {
            if (sendPipelineInfo.Tables[0].Rows.Count > 0)
            {
                menuProperties.Items[3].Enabled = true;
                menuProperties.Items[3].Text  = "SEND PIPELINE";
                txtSendpipeline.Text = HttpUtility.HtmlDecode(" " + sendPipelineInfo.Tables[0].Rows[0][1].ToString());
                txtFullyQualifiedSendName.Text = HttpUtility.HtmlDecode(" " + sendPipelineInfo.Tables[0].Rows[0][2].ToString());
            }
            else if (sendPipelineInfo.Tables[1].Rows.Count > 0)
            {
                menuProperties.Items[3].Enabled = true;
                menuProperties.Items[3].Text = "SEND PIPELINE";
                txtSendpipeline.Text = HttpUtility.HtmlDecode(" " + sendPipelineInfo.Tables[1].Rows[0][0].ToString());
                txtFullyQualifiedSendName.Text = HttpUtility.HtmlDecode(" " + sendPipelineInfo.Tables[1].Rows[0][1].ToString());
            }

        }

        private void ClearPipelineInfo()
        {
            txtReceivePipeline.Text = "";
            txtFullyQualifiedName.Text = "";
        }

        private void Popup(bool isDisplay)
        {
            StringBuilder builder = new StringBuilder();
            if (isDisplay)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowPopup", "javascript:ShowPopup()", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "HidePopup", "javascript:HidePopup();", true);
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

        #endregion
    }
}