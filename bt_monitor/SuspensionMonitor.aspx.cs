using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using Ionic.Zip;

namespace bt_monitor
{
    public partial class SuspensionMonitor : System.Web.UI.Page
    {
        #region GlobalVariables

        /// <summary>
        /// 
        /// </summary>

        string configurationFile = ConfigurationManager.AppSettings["BTConfigFile"];
        ArrayList instanceIDList = null;
        ArrayList bulkInstanceIdList = null;
        ArrayList errorList = null;

        #endregion

        #region Page & Control Events
       
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor |  Suspensions";

            if (Session["AuthenticBTUser"] != null)
            {

                if (Session["BTRole"].Equals("ADMIN") || Session["BTRole"].Equals("USER") || Session["BTRole"].Equals("SUSPENSION"))
                {

                    if (ViewState["ApplicationDomain"] == null)
                    {
                        ViewState["ApplicationDomain"] = Session["AppDomain"].ToString();
                        ViewState["HostDomain"] = Session["HostDomain"].ToString();
                    }

                    if (!IsPostBack)
                    {
                        LoadAndButtonEvent();
                    }
                }
                else
                {
                    Response.Redirect("ErrorPage.aspx", true);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnDualGetNRefresh_Click(object sender, EventArgs e)
        {
            LoadAndButtonEvent();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdViewMain_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                MainGridSelectedIndexChanged();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }

        }

        /// <summary>
        ///  In the OnRowDataBound event handler, for each GridView Row a JavaScript click event handler is attached using the onclick attribute. 
        ///  The GetPostBackClientHyperlink method accepts the GridView instance as well as the command with the Row Index of the Row. 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdViewMain_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(grdViewMain, "Select$" + e.Row.RowIndex);
                e.Row.Attributes.Add("style", "cursor: pointer");
                e.Row.ToolTip = "Click to select this row.";
                
            }
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[1].Visible = false;
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[1].Visible = false;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdViewMain_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdViewMain.PageIndex = e.NewPageIndex;
            grdViewMain.DataBind();

        }

        /// <summary>
        /// Not In USE
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gridViewInstanceData_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gridViewInstanceData, "Select$" + e.Row.RowIndex);
                e.Row.ToolTip = "Click to select this message.";
                e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
                e.Row.Attributes.Add("style", "cursor: pointer");
                e.Row.Cells[1].Visible = false;

            }

            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[1].Visible = false;
            }
        }

        protected void grdViewContext_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            //if (e.Row.RowType == DataControlRowType.Header)
            //{
            //    e.Row.Cells[0].Width = 80;
            //    e.Row.Cells[1].Width = 80;
            //    e.Row.Cells[2].Width = 30;
            //    e.Row.Cells[3].Width = 80;

            //}
            
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gridViewInstanceData, "Select$" + e.Row.RowIndex);
                //e.Row.ToolTip = "Click to select this message.";
                //e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                //e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
                e.Row.Attributes.Add("style", "cursor: pointer");    

            }

        }

        protected void grdViewContext_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                BindGrdViewContext(e.SortExpression, GetContextSortDirection(e.SortExpression));
                Popup(true, sender);
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Not in USE
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gridViewInstanceData_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //int rowInderx = gridViewInstanceData.SelectedIndex;
                XmlDocument ConfigFile = new XmlDocument();
                ConfigFile.Load(Server.MapPath(configurationFile));

                //string parameter1 = lblMessageID.Text = gridViewInstanceData.Rows[rowInderx].Cells[1].Text;
                string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/READMESSAGEDATA").InnerText.Trim();

                //strNewcommand = String.Format(strNewcommand, parameter1);

                string[] messageDetails = new string[3];

                messageDetails[0] = ConfigurationManager.AppSettings["serverNameKey"].ToString();
                messageDetails[1] = strNewcommand;
                //messageDetails[2] = parameter1;
                lblMsgID.Visible = true;
                lblMessageID.Visible = true;
                
                XmlDocument message = GetMessageContent(messageDetails);

                txtDetail.Text = bt_helper.dbHelper.RichTextBoxFunctionality(message.OuterXml.ToString().Trim());

                ConfigFile = null;
                Popup(true, sender);


            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ddlInstanceData_SelectedIndexChanged(object sender, EventArgs e)
        {

            try
            {
                lblMessageID.Text = "";
                lblMessageTypeValue.Text = "";
                int rowInderx = ddlInstanceData.SelectedIndex;
                Menu1.Items[2].Enabled = false;
                Menu1.Items[2].Text = "";

                if (rowInderx > 0)
                {
                    XmlDocument ConfigFile = new XmlDocument();
                    ConfigFile.Load(Server.MapPath(configurationFile));

                    string parameter1 = lblMessageID.Text = ddlInstanceData.SelectedValue;
                    string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/READMESSAGEDATA").InnerText.Trim();

                    strNewcommand = String.Format(strNewcommand, parameter1);

                    string[] messageDetails = new string[3];

                    messageDetails[0] = ConfigurationManager.AppSettings["serverNameKey"].ToString();
                    messageDetails[1] = strNewcommand;
                    messageDetails[2] = parameter1;
                    lblMsgID.Visible = true;
                    lblMessageID.Visible = true;
                    lblMsgTypetext.Visible = true;
                    lblMessageTypeValue.Visible = true;

                    if (!ddlInstanceData.SelectedItem.Text.Equals("NS#RootNode"))
                    {
                        lblMessageTypeValue.Text = ddlInstanceData.SelectedItem.Text;
                    }

                    XmlDocument message = GetMessageContent(messageDetails);
                    txtDetail.Wrap = true;
                    txtDetail.Text = ReturnStringAsFormattedXML(message);


                    Menu1.Items[2].Enabled = true;
                    Menu1.Items[2].Text = "MESSAGE CONTEXT";
                    ViewState["MsgChanged"] = "YES";
                    //txtDetail.Text = bt_helper.dbHelper.RichTextBoxFunctionality(message.OuterXml.ToString().Trim());
                    ConfigFile = null;
                }
                else
                {
                    lblMsgID.Visible = false;
                    lblMessageID.Visible = false;
                    lblMsgTypetext.Visible = false;
                    lblMessageTypeValue.Visible = false;
                    txtDetail.Text = "";
                }
                
                Popup(true, sender);


            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdViewInstancesDetails_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.ToolTip = "Click check box to select this row.";
                //e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                //e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdViewInstancesDetails_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ShowPopup")
                {

                    lblServer.Text = "";
                    lblInstanceID.Text = "";
                    lblSuspendTime.Text = "";
                    lblCreationTime.Text = "";
                    lblServiceNameValue.Text = "";
                    lblMessageTypeValue.Text = "";
                    
                    ddlInstanceData.Items.Clear();
                    ddlInstanceData.DataSource = null;
                    ddlInstanceData.DataBind();

                    Menu1.Items[2].Enabled = false;
                    Menu1.Items[2].Text = "";

                    LinkButton btndetails = (LinkButton)e.CommandSource;
                    GridViewRow gvrow = (GridViewRow)btndetails.NamingContainer;
                    DataTable viewInstanceDataTable = GetSuspendedInstanceData(ConfigurationManager.AppSettings["serverNameKey"].ToString(), grdViewInstancesDetails.DataKeys[gvrow.RowIndex].Value.ToString());

                    if (viewInstanceDataTable.Rows.Count > 0)
                    {

                        List<KeyValuePair<string, string>> comboDataSource = bt_helper.dbHelper.GetDropDownDataSource(viewInstanceDataTable);
                        ddlInstanceData.DataTextField = "Value";
                        ddlInstanceData.DataValueField = "Key";
                        ddlInstanceData.DataSource = comboDataSource;
                        ddlInstanceData.DataBind();
                        ddlInstanceData.SelectedIndex = 0;
                        
                    }
                    else
                    {
                        ddlInstanceData.Items.Clear();
                        ddlInstanceData.DataSource = null;
                        ddlInstanceData.DataBind();
                    }

                    //string message = GetErrorDescription(ConfigurationManager.AppSettings["serverNameKey"].ToString(), grdViewInstancesDetails.DataKeys[gvrow.RowIndex].Value.ToString());

                    lblServer.Text = HttpUtility.HtmlDecode(gvrow.Cells[7].Text);
                    lblInstanceID.Text = HttpUtility.HtmlDecode(gvrow.Cells[2].Text);
                    lblSuspendTime.Text = HttpUtility.HtmlDecode(gvrow.Cells[5].Text);
                    lblCreationTime.Text = HttpUtility.HtmlDecode(gvrow.Cells[6].Text);

                    //lblErrorDesc.Text = HttpUtility.HtmlDecode("Error Description");
                    lblErrorCode.Text = HttpUtility.HtmlDecode(gvrow.Cells[3].Text);
                    lblServiceNameValue.Text = "<pre><span style=\"color: gray\">" + ViewState["ServiceName"].ToString() + "</span></pre>";
                    lblMsgID.Visible = false;
                    lblMessageID.Visible = false;
                    lblMessageTypeValue.Visible = false;
                    lblMsgTypetext.Visible = false;

                    txtDetail.Text = "";
                    txtErrorDetail.Text = HttpUtility.HtmlDecode(gvrow.Cells[8].Text);
                    //txtErrorDetail.Text = HttpUtility.HtmlDecode(message);
                    Menu1.Items[0].Selected = true;
                    MultiView1.ActiveViewIndex = 0;
                    //DisplayRichTextBoxError(message);
                    Popup(true, sender);
                    ChangeDetailColor(gvrow, grdViewInstancesDetails);
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Not in USE
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void gridViewInstanceData_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            //gridViewInstanceData.PageIndex = e.NewPageIndex;
            //gridViewInstanceData.DataBind();

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdViewInstancesDetails_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdViewInstancesDetails.PageIndex = e.NewPageIndex;
            grdViewInstancesDetails.DataBind();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void grdViewInstancesDetails_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                hdnCheckBoxChk.Value = "0";
                chkAll.Checked = false;
                BindGrdViewInstanceDetail(e.SortExpression, GetSortDirection(e.SortExpression));
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void grdViewMain_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                BindGrdViewMain(e.SortExpression, GetMainSortDirection(e.SortExpression));
                
                if (grdViewMain.SelectedIndex > -1)
                {
                    MainGridSelectedIndexChanged();
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnResumeInstance_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedInstanceIDList();
                PerformResumeOperation(instanceIDList, "SELECTED");
                ResetGlobalVariables();
                RefreshPage();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnResume_Click(object sender, EventArgs e)
        {
            try
            {
                BulkInstanceIDToMemory();
                PerformResumeOperation(bulkInstanceIdList, "BULK");
                ResetGlobalVariables();
                RefreshPage();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Bulk Message DownLoad
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnServiceMessage_Click(object sender, EventArgs e)
        {
            try
            {
                BulkInstanceIDToMemory();
                DownLoadMessages(bulkInstanceIdList);
                ResetGlobalVariables();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Instance message download
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnDownloadInstance_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedInstanceIDList();
                DownLoadMessages(instanceIDList);
                ResetGlobalVariables();

            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Not in use
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnTerminateInstance_Click(object sender, EventArgs e)
        {
            //ScriptManager.RegisterStartupScript((sender as Control), this.GetType(), "ShowErrorMask", "javascript:ShowInstanceConfirmationMask();", true);
        }
        
        /// <summary>
        /// Client click implemented, which will show confirmation message, and on confirm btnConfirm_Click will execute
        /// Server side method is not in use
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnTerminate_Click(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnConfirmInstance_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedInstanceIDList();
                PerformTermination(instanceIDList, "SELECTED");
                ResetGlobalVariables();
                RefreshPage();

                lblConfirmationInstance.Text = "";
                btnConfrimInstance.BackColor = System.Drawing.Color.Empty;
                btnCancelInstance.BackColor = System.Drawing.Color.Empty;
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            try
            {
                BulkInstanceIDToMemory();
                PerformTermination(bulkInstanceIdList, "BULK");
                ResetGlobalVariables();
                RefreshPage();

                lblConfirmation.Text = "";
                btnConfirm.BackColor = System.Drawing.Color.Empty;
                btnCancelRequest.BackColor = System.Drawing.Color.Empty;
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }
        
        /// <summary>
        /// Method not in use, functionality implemented in javascript
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void SingleCheckedChanged(object sender, EventArgs e)
        {
            instanceIDList = new ArrayList();
            bool isAllChecked = true;

            CheckBox chkAll = (CheckBox)grdViewInstancesDetails.HeaderRow.FindControl("chkAll");

            foreach (GridViewRow row in grdViewInstancesDetails.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkDelete");
                if (chkBoxRows.Checked)
                {
                    instanceIDList.Add(row.Cells[1].Text);
                }
                else
                {
                    isAllChecked = false;
                }
            }
            
            if (instanceIDList.Count > 0)
            {  
                btnDownloadInstance.Enabled = true;
                btnResumeInstance.Enabled = true;
                btnTerminateInstance.Enabled = true;
            }
            else
            {
                btnDownloadInstance.Enabled = false;
                btnResumeInstance.Enabled = false;
                btnTerminateInstance.Enabled = false;
            }

            if (isAllChecked)
            {
                chkAll.Checked = true;
            }
            else
            {
                chkAll.Checked = false;
            }

        }

        /// <summary>
        /// Method not in use, functionality implemented in javascript
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void HeaderCheckedChanged(object sender, EventArgs e)
        {
            CheckBox chkBoxHeader = (CheckBox)sender;
            instanceIDList = null;
            instanceIDList = new ArrayList();

            if (chkBoxHeader.Checked)
            {
                foreach (GridViewRow row in grdViewInstancesDetails.Rows)
                {
                    CheckBox chkBoxRows = (CheckBox)row.FindControl("chkDelete");

                    chkBoxRows.Checked = true;
                    instanceIDList.Add(row.Cells[1].Text);
                }

                btnDownloadInstance.Enabled = true;
                btnResumeInstance.Enabled = true;
                btnTerminateInstance.Enabled = true;
            }
            else
            {
                foreach (GridViewRow row in grdViewInstancesDetails.Rows)
                {
                    CheckBox chkBoxRows = (CheckBox)row.FindControl("chkDelete");
                    chkBoxRows.Checked = false;
                }

                btnDownloadInstance.Enabled = false;
                btnResumeInstance.Enabled = false;
                btnTerminateInstance.Enabled = false;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Menu1_MenuItemClick(object sender, MenuEventArgs e)
        {
            try
            {
                int index = Int32.Parse(e.Item.Value);
                lblConexterror.Visible = false;
                MultiView1.ActiveViewIndex = index;
                if (index == 2)
                {
                    if (ViewState["MsgChanged"].ToString() == "YES")
                    {
                        grdViewContext.DataSource = null;
                        grdViewContext.DataBind();

                        string error;
                        DataTable contexts = bt_helper.dbHelper.GetMessageConetxt(ConfigurationManager.AppSettings["serverNameKey"].ToString(), lblInstanceID.Text, lblMessageID.Text, out error);
                        ViewState["ContextTable"] = contexts;
                        if (string.IsNullOrEmpty(error))
                        {
                            grdViewContext.DataSource = contexts;
                            grdViewContext.DataBind();
                        }
                        else
                        {
                            lblConexterror.Visible = true;
                            lblConexterror.Text = error;
                        }
                        ViewState["MsgChanged"] = "NO";
                    }
                }
                Popup(true, sender);
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        #endregion
        
        #region PrivateMethods

        private void LoadAndButtonEvent()
        {
            try
            {

                if (ViewState["ApplicationDomain"] != null)
                {
                    DataTable mainGridDataTable = GetMainGridData(ConfigurationManager.AppSettings["serverNameKey"].ToString());

                    ViewState["MainGridTableData"] = mainGridDataTable;

                    if (mainGridDataTable.Rows.Count > 0)
                    {
                        grdViewMain.DataSource = mainGridDataTable;
                        grdViewMain.DataBind();
                        grdViewMain.SelectedIndex = -1;
                        grdViewMain.AllowSorting = true;
                        grdViewMain.Visible = true;
                        hdnCheckBoxChk.Value = "0";

                        if (btnDualGetNRefresh.Text == "Refresh")
                        {
                            btnResume.Visible = true;
                            btnServiceMessage.Visible = true;
                            btnTerminate.Visible = true;
                            btnResume.Enabled = false;
                            btnServiceMessage.Enabled = false;
                            btnTerminate.Enabled = false;
                            btnDualGetNRefresh.Visible = true;
                            btnDualGetNRefresh.Enabled = true;
                            btnDualGetNRefresh.BackColor = ColorTranslator.FromHtml("#F88017");
                            btnDualGetNRefresh.ForeColor = System.Drawing.Color.White;

                            grdViewInstancesDetails.DataSource = null;
                            grdViewInstancesDetails.DataBind();
                            grdViewInstancesDetails.Visible = false;
                            btnDownloadInstance.Visible = false;
                            btnResumeInstance.Visible = false;
                            btnTerminateInstance.Visible = false;

                            chkAll.Visible = false;
                            lblServiceName.Text = "";

                            grdViewMain.SelectedIndex = -1;
                            btnResume.BackColor = System.Drawing.Color.Empty;
                            btnTerminate.BackColor = System.Drawing.Color.Empty;
                            btnResumeInstance.BackColor = System.Drawing.Color.Empty;
                            btnTerminateInstance.BackColor = System.Drawing.Color.Empty;
                            btnServiceMessage.BackColor = System.Drawing.Color.Empty;
                            btnResume.ForeColor = System.Drawing.Color.Gray;
                            btnTerminate.ForeColor = System.Drawing.Color.Gray;
                            btnResumeInstance.ForeColor = System.Drawing.Color.Gray;
                            btnTerminateInstance.ForeColor = System.Drawing.Color.Gray;
                            btnServiceMessage.ForeColor = System.Drawing.Color.Gray;
                        }
                    }
                    else
                    {
                        //show no suspension information
                        RefreshPageOnNoSuspensions();
                        DisplayWebInfo();
                    }
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

        private void RefreshPageOnNoSuspensions()
        {
            grdViewInstancesDetails.DataSource = null;
            grdViewInstancesDetails.DataBind();
            grdViewInstancesDetails.Visible = false;
            grdViewMain.DataSource = null;
            grdViewMain.DataBind();
            grdViewMain.Visible = false;

            btnResume.Visible = false;
            btnServiceMessage.Visible = false;
            btnTerminate.Visible = false;
            btnResumeInstance.Visible = false;
            btnDownloadInstance.Visible = false;
            btnTerminateInstance.Visible = false;

            btnResume.Enabled = false;
            btnServiceMessage.Enabled = false;
            btnTerminate.Enabled = false;
            btnResumeInstance.Enabled = false;
            btnDownloadInstance.Enabled = false;
            btnTerminateInstance.Enabled = false;


            btnResume.BackColor = System.Drawing.Color.Empty;
            btnTerminate.BackColor = System.Drawing.Color.Empty;
            btnResumeInstance.BackColor = System.Drawing.Color.Empty;
            btnTerminateInstance.BackColor = System.Drawing.Color.Empty;
            btnServiceMessage.BackColor = System.Drawing.Color.Empty;
            btnDownloadInstance.BackColor = System.Drawing.Color.Empty;
            btnResume.ForeColor = System.Drawing.Color.Gray;
            btnTerminate.ForeColor = System.Drawing.Color.Gray;
            btnResumeInstance.ForeColor = System.Drawing.Color.Gray;
            btnTerminateInstance.ForeColor = System.Drawing.Color.Gray;
            btnServiceMessage.ForeColor = System.Drawing.Color.Gray;
            btnDownloadInstance.ForeColor = System.Drawing.Color.Gray;

            chkAll.Visible = false;
            chkAll.Checked = false;
            
            btnDualGetNRefresh.BackColor = ColorTranslator.FromHtml("#F88017");
            btnDualGetNRefresh.ForeColor = System.Drawing.Color.White;
            lblServiceName.Text = "";
        }
        
        private string replaceInvalidCharacter(string input)
        {
            string temp = input.Replace("'", "&apos;");
            temp = temp.Replace("/", " ");
            temp = temp.Replace("\r\n", "@");
            return temp;
        }

        private void DisplayWebMessage(Exception ex)
        {
            string errorLogFile = ConfigurationManager.AppSettings["ErrorLogs"];
            string logFile = HttpContext.Current.Server.MapPath(errorLogFile);
            bt_helper.dbHelper.DisplayMessageLogError(ex, logFile);

            lblErrorMask.Text = "<pre><span style=\"color: gray\"><b>" + " Error while processing the request, Please check with support." + "</b></span></pre>";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowErrorMask", "javascript:ShowErrorMask()", true);
            
        }

        private void DisplayWebInfo()
        {
            lblInfoMask.Text = "<pre><span style=\"color: gray\"><b>" + " There is no suspended instance." + "</b></span></pre>";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "ShowPanelMask", "javascript:ShowPanelMask()", true);
        }

        /// <summary>
        /// Not in use
        /// </summary>
        /// <param name="message"></param>
        private void DisplayRichTextBox(string message)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<script language=JavaScript> RichTextMessage('" + message + "'); </script>\n");
            Page.ClientScript.RegisterStartupScript(this.GetType(), "RichTextMessage", sb.ToString());
        }

        /// <summary>
        /// Not in use
        /// </summary>
        /// <param name="message"></param>
        private void DisplayRichTextBoxError(string message)
        {          
            StringBuilder sb = new StringBuilder();
            sb.Append("<script language=JavaScript> RichTextError('" + message + "'); </script>\n");
            Page.ClientScript.RegisterStartupScript(this.GetType(), "RichTextError", sb.ToString());
        }
        
        /// <summary>
        /// Populates main grid
        /// </summary>
        /// <param name="serverName">BizTalk SQl Server</param>
        /// <returns></returns>
        private DataTable GetMainGridData(string serverName)
        {
            ArrayList sharedServers = new ArrayList();
            string strcommand = string.Empty;

            sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));

            StringBuilder sbUniqueServiceid = new StringBuilder();
            StringBuilder sbInstanceCount = new StringBuilder();
            StringBuilder sbHostCondition = new StringBuilder();
            
            XmlDocument ConfigFile = new XmlDocument();
            ConfigFile.Load(Server.MapPath(configurationFile));

            strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/SUSPENDEDINSTANCE").InnerText.Trim();

            if (sharedServers.Contains(serverName))
            {
                strcommand = String.Format(strcommand,"AND m.nvcName LIKE ''%"+ ViewState["ApplicationDomain"].ToString()+"%''");
            }
            else
            {
                strcommand = String.Format(strcommand, "");
            }

            ViewState["MainGridCommand"] = "";
            ViewState["MainGridCommand"] = strcommand;


            DataTable suspendtable = bt_helper.dbHelper.ExecuteMsgBoxQuery(serverName, strcommand);
            ConfigFile = null;
            return suspendtable;
        }

        private void MainGridSelectedIndexChanged()
        {
            chkAll.Checked = false;
            chkAll.Visible = false;
            hdnCheckBoxChk.Value = "0";
            int rowInderx = grdViewMain.SelectedIndex;
            lblServiceName.Text = "Service Name: " + grdViewMain.Rows[rowInderx].Cells[0].Text;

            btnResume.Enabled = true;
            btnServiceMessage.Enabled = true;
            btnTerminate.Enabled = true;
            DisableAndHideControls();
            ChangeDetailColor(grdViewMain.SelectedRow, grdViewMain);

            XmlDocument ConfigFile = new XmlDocument();
            ConfigFile.Load(Server.MapPath(configurationFile));

            string strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/INSTANCEDETAILFROMSERVICEID").InnerText.Trim();
            string serviceID = grdViewMain.Rows[rowInderx].Cells[1].Text;

            strcommand = String.Format(strcommand, serviceID, grdViewMain.Rows[rowInderx].Cells[2].Text);
            ViewState["MainGridSelectIndexChanged"] = "";
            ViewState["MainGridSelectIndexChanged"] = strcommand;

            DataTable suspendtable = bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), ViewState["MainGridSelectIndexChanged"].ToString());
            ViewState["MainGridSelectIndexChangedTable"] = suspendtable;

            if (suspendtable.Rows.Count > 0)
            {
                grdViewInstancesDetails.DataSource = suspendtable;
                grdViewInstancesDetails.DataBind();

                btnResume.BackColor = ColorTranslator.FromHtml("#F88017");
                btnResume.ForeColor = System.Drawing.Color.White;
                btnTerminate.BackColor = ColorTranslator.FromHtml("#F88017");
                btnTerminate.ForeColor = System.Drawing.Color.White;
                btnServiceMessage.BackColor = ColorTranslator.FromHtml("#F88017");
                btnServiceMessage.ForeColor = System.Drawing.Color.White;
                grdViewInstancesDetails.Visible = true;
                btnDownloadInstance.Visible = true;
                btnResumeInstance.Visible = true;
                btnTerminateInstance.Visible = true;
                btnIndividualInstance.Enabled = true;
                chkAll.Visible = true;
            }
            else
            {
                grdViewInstancesDetails.DataSource = null;
                grdViewInstancesDetails.DataBind();
            }

            ViewState["Host"] = grdViewMain.Rows[rowInderx].Cells[4].Text;
            ViewState["ServiceName"] = grdViewMain.Rows[rowInderx].Cells[0].Text;

            ConfigFile = null;
        }

        private void BindGrdViewContext(string sortExp, string sortDir)
        {
            DataTable contexts = (DataTable)ViewState["ContextTable"];
            if (contexts.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = contexts.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdViewContext.DataSource = myDataView;
                grdViewContext.DataBind();
            }
            else
            {
                grdViewContext.DataSource = null;
                grdViewContext.DataBind();
            }
        }

        private void BindGrdViewInstanceDetail(string sortExp, string sortDir)
        {
            DataTable suspendtable = (DataTable)ViewState["MainGridSelectIndexChangedTable"];
            //bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), ViewState["MainGridSelectIndexChanged"].ToString());

            if (suspendtable.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = suspendtable.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdViewInstancesDetails.DataSource = myDataView;
                grdViewInstancesDetails.DataBind();

                btnResume.BackColor = ColorTranslator.FromHtml("#F88017");
                btnResume.ForeColor = System.Drawing.Color.White;
                btnTerminate.BackColor = ColorTranslator.FromHtml("#F88017");
                btnTerminate.ForeColor = System.Drawing.Color.White;
                btnServiceMessage.BackColor = ColorTranslator.FromHtml("#F88017");
                btnServiceMessage.ForeColor = System.Drawing.Color.White;
                grdViewInstancesDetails.Visible = true;
                btnDownloadInstance.Visible = true;
                btnResumeInstance.Visible = true;
                btnTerminateInstance.Visible = true;
                btnIndividualInstance.Enabled = true;
                chkAll.Visible = true;
            }
            else
            {
                grdViewInstancesDetails.DataSource = null;
                grdViewInstancesDetails.DataBind();
            }
        }

        private void BindGrdViewMain(string sortExp, string sortDir)
        {
            DataTable suspendtable = (DataTable)ViewState["MainGridTableData"];
            //bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), ViewState["MainGridCommand"].ToString());

            if (suspendtable.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = suspendtable.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdViewMain.DataSource = myDataView;
                grdViewMain.DataBind();
            }
            else
            {
                grdViewMain.DataSource = null;
                grdViewMain.DataBind();
            }
        }

        private DataTable DataTable(object p)
        {
            throw new NotImplementedException();
        }

        private string GetSortDirection(string column)
        {
            string sortDirection = "ASC";
            string sortExpression = ViewState["SortExpression"] as string;

            if (sortExpression != null)
            {
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["SortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                }
            }

            ViewState["SortDirection"] = sortDirection;
            ViewState["SortExpression"] = column;

            return sortDirection;
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

        private string GetContextSortDirection(string column)
        {
            string sortDirection = "ASC";
            string sortExpression = ViewState["ContextSortExpression"] as string;

            if (sortExpression != null)
            {
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["ContextSortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                }
            }

            ViewState["ContextSortDirection"] = sortDirection;
            ViewState["ContextSortExpression"] = column;

            return sortDirection;
        }
        
        private DataTable GetSuspendedInstanceData(string serverName, string instanceID)
        {
            XmlDocument ConfigFile = new XmlDocument();
            ConfigFile.Load(Server.MapPath(configurationFile));

            string strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/MESSAGETYPEFORSUSPENDEDINSTANCE").InnerText.Trim();
            string parameter1 = ViewState["Host"].ToString() + "Q_Suspended";
            string parameter2 = "InstanceStateMessageReferences_" + ViewState["Host"].ToString();

            strcommand = String.Format(strcommand, parameter1, "''" + instanceID + "''", parameter2);
            DataTable suspendtable = bt_helper.dbHelper.ExecuteMsgBoxQuery(serverName, strcommand);
            ConfigFile = null;
            return suspendtable;
        }

        //private string GetErrorDescription(string serverName, string instanceID)
        //{
        //    XmlDocument ConfigFile = new XmlDocument();
        //    ConfigFile.Load(Server.MapPath(configurationFile));

        //    string strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/INSTANCEERRORDESCRIPTION").InnerText.Trim();
        //    strcommand = String.Format(strcommand, instanceID);
        //    DataTable errorDescription = bt_helper.dbHelper.ExecuteMsgBoxQuery(serverName, strcommand);
        //    ConfigFile = null;

        //    if (errorDescription.Rows.Count > 0)
        //    {
        //        return errorDescription.Rows[0][0].ToString();
        //    }
        //    else
        //    {
        //        return "";
        //    }
        //}

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

        private void ResetGlobalVariables()
        {
           instanceIDList = null;
           bulkInstanceIdList = null;
           errorList = null;
        }

        private void DisableAndHideControls()
        {
            btnTerminateInstance.Enabled = false;
            btnResumeInstance.Enabled = false;
            btnDownloadInstance.Enabled = false;

            btnTerminateInstance.Visible = false;
            btnResumeInstance.Visible = false;
            btnDownloadInstance.Visible = false;
        }

        private void PerformResumeOperation(ArrayList instanceList, string level)
        {
            try
            {
                if (instanceList != null)
                {
                    ResumeInstances(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                }
            }
            catch (Exception ex)
            {

                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Read message from spool and provide download option
        /// </summary>
        /// <param name="instanceList"></param>
        private void DownLoadMessages(ArrayList instanceList)
        {
            try
            {
                if (instanceList != null)
                {
                    ZipFile zip = new ZipFile();
                    zip.AlternateEncodingUsage = ZipOption.Default;

                    XmlDocument ConfigFile = new XmlDocument();
                    ConfigFile.Load(Server.MapPath(configurationFile));

                    int instanceErrorCount = 0; 
                    foreach (object instanceID in instanceList)
                    {
                        DataTable instanceMessageDataTable = GetSuspendedInstanceData(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceID.ToString());

                        if (instanceMessageDataTable.Rows.Count > 0)
                        {
                            //ArrayList messageIDList = new ArrayList();
                            Dictionary<string, string> msgID_Type = new Dictionary<string, string>();

                            for (int rowCount = 0; rowCount < instanceMessageDataTable.Rows.Count; rowCount++)
                            {
                                //messageIDList.Add(instanceMessageDataTable.Rows[rowCount][1]);
                                msgID_Type.Add(instanceMessageDataTable.Rows[rowCount][1].ToString(), instanceMessageDataTable.Rows[rowCount][0].ToString());

                            }

                            if (msgID_Type.Count>0)
                            {
                                if (!string.IsNullOrEmpty(errorList[instanceErrorCount].ToString())) 
                                    zip.AddEntry(instanceID + "_ErrorDescription.txt", errorList[instanceErrorCount].ToString());
                                //foreach (object msgID in messageIDList)
                                foreach (KeyValuePair<string, string> pair in msgID_Type)
                                {
                                    string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/READMESSAGEDATA").InnerText.Trim();

                                    strNewcommand = String.Format(strNewcommand, pair.Key.ToString());

                                    string[] messageInfo = null;
                                    messageInfo= new string[3];

                                    messageInfo[0] = ConfigurationManager.AppSettings["serverNameKey"].ToString();
                                    messageInfo[1]=strNewcommand;
                                    messageInfo[2] = pair.Key.ToString();

                                    string xmlName = pair.Value.ToString().Substring(pair.Value.ToString().LastIndexOf("/") + 1);

                                    XmlDocument message = bt_helper.dbHelper.GetMessageFromBtsMsgBox(messageInfo);
                                    zip.AddEntry(instanceID + "_" + pair.Key.ToString() + "_" + xmlName + ".xml", message.OuterXml.ToString());
                                }
                            }
                            msgID_Type = null;
                        }
                        instanceErrorCount = instanceErrorCount + 1;
                        instanceMessageDataTable = null;
                        
                    }

                    ConfigFile = null;
                    Response.Clear();
                    Response.BufferOutput = false;
                    string zipName = String.Format("{0}_{1}.zip", ViewState["ServiceName"].ToString(), DateTime.Now.ToString("yyyy-MMM-dd-HHmmss"));

                    Response.AppendHeader("Content-Disposition", "attachment; filename=" + zipName);
                    Response.ContentType = "application/x-zip-compressed";
                    zip.Save(Response.OutputStream);
                    Response.End();

                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        private void PerformTermination(ArrayList instanceList, string level)
        {
            try
            {
                if (instanceList != null)
                {
                    TerminateInstance(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        private void ResumeInstances(string servreName, ArrayList instanceUniqueIDList)
        {
            bt_helper.dbHelper.ResumeInstance(servreName, instanceUniqueIDList);
        }

        private void TerminateInstance(string serverName, ArrayList instanceUniqueIDList)
        {
            bt_helper.dbHelper.TerminateInstance(serverName, instanceUniqueIDList);
        }

        private void ReturnSelectedInstanceIDList()
        {
            instanceIDList = new ArrayList();
            errorList = new ArrayList();
            foreach (GridViewRow row in grdViewInstancesDetails.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkDelete");

                if (chkBoxRows.Checked)
                {
                    instanceIDList.Add(row.Cells[2].Text);
                    errorList.Add(row.Cells[8].Text);
                }
            }
        }

        private void BulkInstanceIDToMemory()
        {
            bulkInstanceIdList = new ArrayList();
            errorList = new ArrayList();

            foreach (GridViewRow row in grdViewInstancesDetails.Rows)
            {
                bulkInstanceIdList.Add(row.Cells[2].Text);
                errorList.Add(row.Cells[8].Text);
            }
        }

        private void RefreshPage()
        {
            btnResume.BackColor = System.Drawing.Color.Empty;
            btnTerminate.BackColor = System.Drawing.Color.Empty;
            btnResumeInstance.BackColor = System.Drawing.Color.Empty;
            btnTerminateInstance.BackColor = System.Drawing.Color.Empty;
            btnServiceMessage.BackColor = System.Drawing.Color.Empty;

            btnResume.ForeColor = System.Drawing.Color.Gray;
            btnTerminate.ForeColor = System.Drawing.Color.Gray;
            btnResumeInstance.ForeColor = System.Drawing.Color.Gray;
            btnTerminateInstance.ForeColor = System.Drawing.Color.Gray;
            btnServiceMessage.ForeColor = System.Drawing.Color.Gray;
            
            grdViewInstancesDetails.Visible = false;
            btnDownloadInstance.Visible = false;
            btnResumeInstance.Visible = false;
            btnTerminateInstance.Visible = false;
            
            chkAll.Visible = false;
            chkAll.Checked = false;

            btnResume.Enabled = false;
            btnServiceMessage.Enabled = false;
            btnTerminate.Enabled = false;
            lblServiceName.Text = "";
            hdnCheckBoxChk.Value = "0";
            grdViewMain.DataSource = null;
            
            DataTable mainGridtable = GetMainGridData(ConfigurationManager.AppSettings["serverNameKey"].ToString());

            if (mainGridtable.Rows.Count > 0)
            {
                grdViewMain.DataSource = mainGridtable;
                grdViewMain.DataBind();
                grdViewMain.SelectedIndex = -1;
            }
            else
            {
                RefreshPageOnNoSuspensions();
                DisplayWebInfo();
            }
            
        }

        //To show message after performing operations
        private void Popup(bool isDisplay, object sender)
        {
            StringBuilder builder = new StringBuilder();
            if (isDisplay)
            {
                ScriptManager.RegisterStartupScript((sender as Control), this.GetType(), "ShowPopup", "javascript:ShowPopup();", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript((sender as Control), this.GetType(), "HidePopup", "javascript:HidePopup();", true);
            }
        }

        private string ReturnStringAsFormattedXML(XmlDocument xmlFile)
        {
            StringBuilder sb = new StringBuilder();

            using (StringWriter stringWriter = new StringWriter(sb))
            {
                using (XmlTextWriter xmlTextWriter = new XmlTextWriter(stringWriter))
                {
                    xmlTextWriter.Formatting = Formatting.Indented;
                    xmlFile.WriteTo(xmlTextWriter);
                }
            }

            return sb.ToString();

        }

        private XmlDocument GetMessageContent(string[] messageDetails)
        {
            XmlDocument message = bt_helper.dbHelper.GetMessageFromBtsMsgBox(messageDetails);
            return message;
        }

        private XmlDocument RemoveXMLDeclarationTag(XmlDocument inDoc)
        {
            StringBuilder sb = new StringBuilder();

            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = true;
            XmlWriter xWriter = XmlWriter.Create(sb, settings);
            inDoc.Save(xWriter);
            xWriter.Close();

            XmlDocument outDoc = new XmlDocument();
            outDoc.LoadXml(sb.ToString());

            return outDoc;
        }

               
        #endregion
    }
}