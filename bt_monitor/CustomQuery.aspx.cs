using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Drawing;
using Ionic.Zip;

namespace bt_monitor

{
    public partial class CustomQuery : System.Web.UI.Page
    {
        #region GlobalVariables
        string configurationFile = ConfigurationManager.AppSettings["BTConfigFile"];
        ArrayList instanceIDList = null;
        ArrayList bulkInstanceIdList = null;
        ArrayList errorList = null;
        ArrayList hostNameList = null;
        ArrayList servicenamelist = null;
        #endregion

        #region Page Events

        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor |  MessageBox Queries";

            if (Session["AuthenticBTUser"] != null)
            {
                if (Session["BTRole"].Equals("ADMIN") || Session["BTRole"].Equals("USER"))
                {

                    if (ViewState["ApplicationDomain"] == null)
                    {
                        ViewState["ApplicationDomain"] = Session["AppDomain"].ToString();
                        ViewState["HostDomain"] = Session["HostDomain"].ToString();
                    }

                    if (!IsPostBack)
                    {
                        try
                        {
                            GetCustomQueryConditions();
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

        protected void btnExecuteQuery_Click(object sender, EventArgs e)
        {
            try
            {
                if (ViewState["ApplicationDomain"] != null)
                {
                    XmlDocument ConfigFile = new XmlDocument();
                    ConfigFile.Load(Server.MapPath(configurationFile));

                    string[] csvConditions = hdnConditions.Value.Split(';');
                    string[] csvOperators = hdnOperator.Value.Split(';');
                    string[] csvValues = hdnValues.Value.Split(';');

                    int mainArrayNo = Convert.ToInt32(hdnMainArray.Value);
                    int searchLimit = Convert.ToInt32(hdnCount.Value);
                    bool sharedQuery = false;
                    string strcommand = string.Empty;

                    grdViewGroup.DataSource = null;
                    grdViewGroup.Visible = false;

                    gridViewAll.Visible = false;
                    btnTerminateInstance.Visible = false;
                    btnDownloadInstance.Visible = false;
                    btnBulkDownloadInstance.Visible = false;
                    btnSuspendResumeInstance.Visible = false;
                    ChkOAll.Visible = false;
                    chkAll.Visible = false;
                    string displayMessage = string.Empty;

                    hdnOCheckBoxDehydratedChk.Value = "0";
                    hdnOCheckBoxSuspendedChk.Value = "0";
                    hdnCheckBoxDehydratedChk.Value = "0";
                    hdnCheckBoxSuspendedChk.Value = "0";

                    if (!RequiredFieldValidations(csvConditions, csvValues, out displayMessage))
                    {
                        btnBulkSuspendResume.Visible = false;
                        btnBulkSuspendResume.Enabled = false;
                        btnBulkTerminate.Visible = false;
                        btnBulkTerminate.Enabled = false;
                        btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                        btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
                        lblvalidationError.Text = displayMessage;

                        PopupErrorMask(true, sender);

                    }
                    else
                    {
                        grdViewGroup.SelectedIndex = -1;
                        hdnExecutedWithGroup.Value = "0";
                        ArrayList sharedServers = new ArrayList();
                        sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));

                        if (sharedServers.Contains(ConfigurationManager.AppSettings["serverNameKey"].ToString()))
                            sharedQuery = true;

                        if (!isConditionSelected(csvConditions))
                        {
                            strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/AllServiceInstance").InnerText.Trim();

                            switch (mainArrayNo)
                            {
                                case 0:
                                    btnBulkSuspendResume.Text = "Suspend";
                                    if (sharedQuery)
                                        strcommand = String.Format(strcommand, searchLimit, "AND m.nvcName LIKE ''%" + ViewState["ApplicationDomain"].ToString() + "%''", "");
                                    else
                                        strcommand = String.Format(strcommand, searchLimit, "","");

                                    break;
                                case 1:
                                    btnBulkSuspendResume.Text = "Suspend";
                                    if (sharedQuery)
                                        strcommand = String.Format(strcommand, searchLimit, " AND m.nvcName LIKE ''%" + ViewState["ApplicationDomain"].ToString() + "%''", " AND nState IN (2,8)");
                                    else
                                        strcommand = String.Format(strcommand, searchLimit, "", " AND nState IN (2,8)");
                                    break;
                                case 2:
                                    btnBulkSuspendResume.Text = "Resume";
                                    if (sharedQuery)
                                        strcommand = String.Format(strcommand, searchLimit, " AND m.nvcName LIKE ''%" + ViewState["ApplicationDomain"].ToString() + "%''", " AND nState IN (4,32)");
                                    else
                                        strcommand = String.Format(strcommand, searchLimit, "", " AND nState IN (4,32)");
                                    break;
                            }

                            grdViewGroup.DataSource = null;
                            ViewState["MainQuery"] = strcommand;
                            ViewState["MainGridQuery"] = "";
                            ViewState["MainGridQuery"] = strcommand;

                            DataTable noConditiontable = bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
                            ViewState["MainGridDataTable"] = noConditiontable;
                            if (noConditiontable.Rows.Count > 0)
                            {
                                grdViewGroup.Visible = true;
                                grdViewGroup.DataSource = noConditiontable;
                                grdViewGroup.DataBind();
                                btnBulkSuspendResume.Visible = true;
                                btnBulkSuspendResume.Enabled = false;
                                btnBulkTerminate.Visible = true;
                                btnBulkTerminate.Enabled = false;
                                chkAll.Checked = false;
                                chkAll.Visible = true;
                                btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                                btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
                                btnBulkDownloadInstance.Visible = true;
                                btnBulkDownloadInstance.Enabled = false;
                                btnBulkDownloadInstance.BackColor = System.Drawing.Color.Empty;
                            }
                            else
                            {
                                btnBulkSuspendResume.Visible = false;
                                btnBulkSuspendResume.Enabled = false;
                                btnBulkTerminate.Visible = false;
                                btnBulkTerminate.Enabled = false;
                                chkAll.Visible = false;
                                btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                                btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
                                btnBulkDownloadInstance.Visible = false;
                                btnBulkDownloadInstance.Enabled = false;
                                btnBulkDownloadInstance.BackColor = System.Drawing.Color.Empty;
                            }
                        }
                        else
                        {
                            if (csvConditions[2] != "Y")
                            {
                                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/CustomQuery").InnerText.Trim();
                                if (!sharedQuery)
                                    strcommand = String.Format(strcommand, searchLimit,"", GetConditions(csvConditions, csvOperators, csvValues, mainArrayNo));
                                else
                                    strcommand = String.Format(strcommand, searchLimit, " AND m.nvcName LIKE ''%" + ViewState["ApplicationDomain"].ToString() + "%''", GetConditions(csvConditions, csvOperators, csvValues, mainArrayNo));

                                grdViewGroup.DataSource = null;
                                ViewState["MainQuery"] = strcommand;
                                ViewState["MainGridQuery"] = "";
                                ViewState["MainGridQuery"] = strcommand;

                                DataTable noConditiontable = bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
                                ViewState["MainGridDataTable"] = noConditiontable;
                                if (noConditiontable.Rows.Count > 0)
                                {
                                    grdViewGroup.Visible = true;
                                    grdViewGroup.DataSource = noConditiontable;
                                    grdViewGroup.DataBind();
                                    btnBulkSuspendResume.Visible = true;
                                    btnBulkSuspendResume.Enabled = false;
                                    btnBulkTerminate.Visible = true;
                                    btnBulkTerminate.Enabled = false;
                                    btnBulkDownloadInstance.Visible = true;
                                    btnBulkDownloadInstance.Enabled = true;
                                    chkAll.Checked = false;
                                    chkAll.Visible = true;
                                    btnBulkDownloadInstance.BackColor = System.Drawing.Color.Empty;
                                    btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                                    btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
                                }
                                else
                                {
                                    btnBulkSuspendResume.Visible = false;
                                    btnBulkSuspendResume.Enabled = false;
                                    btnBulkTerminate.Visible = false;
                                    btnBulkTerminate.Enabled = false;
                                    chkAll.Visible = false;
                                    btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                                    btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
                                    btnBulkDownloadInstance.Visible = false;
                                    btnBulkDownloadInstance.Enabled = false;
                                    btnBulkDownloadInstance.BackColor = System.Drawing.Color.Empty;
                                }
                            }
                            else
                            {
                                string conditions = GetConditions(csvConditions, csvOperators, csvValues, mainArrayNo);
                                chkAll.Visible = false;
                                hdnExecutedWithGroup.Value = "1";
                                ViewState["groupInternalCondition"] = conditions;
                                ViewState["grpByValues"] = csvValues[2].ToString();
                                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/CustomQueryGroup").InnerText.Trim();

                                if (!sharedQuery)
                                {
                                    if (!string.IsNullOrEmpty(conditions))
                                    {
                                        strcommand = String.Format(strcommand, "", GroupColumnsSelect(csvValues[2]), GroupColumns(csvValues[2]), GroupedSelect(csvValues[2]), GroupedSelectPart(csvValues[2]), conditions);
                                    }
                                    else
                                    {
                                        strcommand = String.Format(strcommand, "", GroupColumnsSelect(csvValues[2]), GroupColumns(csvValues[2]), GroupedSelect(csvValues[2]), GroupedSelectPart(csvValues[2]), conditions);
                                    }
                                }
                                else
                                {
                                    if (!string.IsNullOrEmpty(conditions))
                                    {
                                        strcommand = String.Format(strcommand, " AND m.nvcName LIKE ''%" + ViewState["ApplicationDomain"].ToString() + "%''", GroupColumnsSelect(csvValues[2]), GroupColumns(csvValues[2]), GroupedSelect(csvValues[2]), GroupedSelectPart(csvValues[2]), conditions);
                                    }
                                    else
                                    {
                                        strcommand = String.Format(strcommand, " AND m.nvcName LIKE ''%" + ViewState["ApplicationDomain"].ToString() + "%''", GroupColumnsSelect(csvValues[2]), GroupColumns(csvValues[2]), GroupedSelect(csvValues[2]), GroupedSelectPart(csvValues[2]), conditions);
                                    }
                                }

                                grdViewGroup.DataSource = null;
                                ViewState["MainQuery"] = strcommand;
                                ViewState["MainGridQuery"] = "";
                                ViewState["MainGridQuery"] = strcommand;

                                DataTable noConditiontable = bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
                                ViewState["MainGridDataTable"] = noConditiontable;
                                if (noConditiontable.Rows.Count > 0)
                                {
                                    grdViewGroup.SelectedIndex = -1;
                                    grdViewGroup.Visible = true;
                                    grdViewGroup.DataSource = noConditiontable;
                                    grdViewGroup.DataBind();
                                    btnBulkSuspendResume.Visible = false;
                                    btnBulkSuspendResume.Enabled = false;
                                    btnBulkTerminate.Visible = false;
                                    btnBulkTerminate.Enabled = false;
                                    btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                                    btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
                                }
                                else
                                {
                                    btnBulkSuspendResume.Visible = false;
                                    btnBulkSuspendResume.Enabled = false;
                                    btnBulkTerminate.Visible = false;
                                    btnBulkTerminate.Enabled = false;
                                    chkAll.Checked = false;
                                    btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                                    btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
                                }
                            }
                        }
                    }

                    ConfigFile = null;
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

        protected void grdViewGroup_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            try
            {
                string[] csvConditions = hdnConditions.Value.Split(';');

                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    if (csvConditions[2] == "Y")
                    {
                        e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(grdViewGroup, "Select$" + e.Row.RowIndex);
                        e.Row.Attributes.Add("style", "cursor: pointer");
                        e.Row.ToolTip = "Click to select this row.";
                    }
                    else
                    {
                        //e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                        //e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
                        e.Row.ToolTip = "Click Check box to select this row.";
                    }
                }



                if (csvConditions[2] != "Y")
                {
                    e.Row.Cells[0].Visible = true;
                    e.Row.Cells[1].Visible = true;
                    e.Row.Cells[2].Visible = true;
                }
                else
                {
                    e.Row.Cells[0].Visible = false;
                    e.Row.Cells[1].Visible = false;
                    e.Row.Cells[2].Visible = false;
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void gridViewAll_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    //e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                    //e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void grdViewGroup_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ShowPopup")
                {
                    ClearControls();

                    LinkButton btndetails = (LinkButton)e.CommandSource;
                    GridViewRow gvrow = (GridViewRow)btndetails.NamingContainer;
                    string instanceID = string.Empty;
                    string host = string.Empty;
                    int mainArrayNo = Convert.ToInt32(hdnMainArray.Value);
                    
                    lblSuspendtext.Visible = false;
                    lblSuspendTime.Visible = false;
                    lblErrorDesc.Visible = false;
                    lblErrorCode.Visible = false;
                    lblErrorCodeText.Visible = false;
                    txtErrorDetail.Enabled = false;
                    txtErrorDetail.Text = "";
                    txtDetail.Text = "";
                    lblMessageTypeValue.Text = "";
                    ddlInstanceData.Items.Clear();
                    ddlInstanceData.DataSource = null;
                    ddlInstanceData.DataBind();

                    if (grdViewGroup.Rows.Count > 0)
                    {
                        instanceID = grdViewGroup.Rows[gvrow.RowIndex].Cells[4].Text;
                        host = grdViewGroup.Rows[gvrow.RowIndex].Cells[9].Text;
                    }

                    DataTable viewInstanceDataTable = GetInstanceData(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceID, host);

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

                    Menu1.Items[0].Text = "GENERAL INFORMATION";
                    
                    if (mainArrayNo == 2 || grdViewGroup.Rows[gvrow.RowIndex].Cells[6].Text.Equals("Suspended Resumable") || grdViewGroup.Rows[gvrow.RowIndex].Cells[6].Text.Equals("Suspended Non-Resumable"))
                    {
                        Menu1.Items[0].Text = "ERROR INFORMATION";
                        lblSuspendtext.Visible = true;
                        lblSuspendTime.Visible = true;
                        lblErrorDesc.Visible = true;
                        lblErrorCode.Visible = true;
                        lblErrorCodeText.Visible = true;
                        txtErrorDetail.Enabled = true;
                        lblErrorCode.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[10].Text); ;
                        lblSuspendTime.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[12].Text);
                        lblErrorDesc.Text = HttpUtility.HtmlDecode("Error Description");
                        txtErrorDetail.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[11].Text);
                    }

                    lblServer.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[8].Text);
                    lblAppName.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[2].Text);
                    lblInstanceID.Text = HttpUtility.HtmlDecode(instanceID);
                    lblInstanceStatus.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[6].Text);
                    lblCreationTime.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[7].Text);
                    lblServiceNameValue.Text = "<pre><span style=\"color: gray\">" + grdViewGroup.Rows[gvrow.RowIndex].Cells[3].Text + "</span></pre>";
                    lblHostname.Text = HttpUtility.HtmlDecode(grdViewGroup.Rows[gvrow.RowIndex].Cells[9].Text);
                    
                    Menu1.Items[0].Selected = true;
                    MultiView1.ActiveViewIndex = 0;

                    lblMsgID.Visible = false;
                    lblMessageID.Visible = false;
                    lblMessageTypeValue.Visible = false;
                    lblMsgTypetext.Visible = false;

                    Popup(true, sender);
                    ChangeDetailColor(gvrow, grdViewGroup);
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void Menu1_MenuItemClick(object sender, MenuEventArgs e)
        {
            try
            {
                int index = Int32.Parse(e.Item.Value);

                MultiView1.ActiveViewIndex = index;
                Popup(true, sender);
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void Menu2_MenuItemClick(object sender, MenuEventArgs e)
        {
            try
            {
                int index = Int32.Parse(e.Item.Value);

                MultiView2.ActiveViewIndex = index;
                PopupOuter(true, sender);
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        //protected void gridViewInstanceData_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        //{
        //    try
        //    {
        //        if (e.Row.RowType == DataControlRowType.DataRow)
        //        {
        //            e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gridViewInstanceData, "Select$" + e.Row.RowIndex);
        //            e.Row.ToolTip = "Click to select this row.";
        //            e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
        //            e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
        //            e.Row.Attributes.Add("style", "cursor: pointer");
        //            e.Row.Cells[1].Visible = false;

        //        }

        //        if (e.Row.RowType == DataControlRowType.Header)
        //        {
        //            e.Row.Cells[1].Visible = false;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        DisplayWebMessage(ex);
        //    }
        //}

        //protected void gridViewOuterInstanceData_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        //{
        //    try
        //    {
        //        if (e.Row.RowType == DataControlRowType.DataRow)
        //        {
        //            e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(gridViewOuterInstanceData, "Select$" + e.Row.RowIndex);
        //            e.Row.ToolTip = "Click to select this row.";
        //            e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
        //            e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");
        //            e.Row.Attributes.Add("style", "cursor: pointer");
        //            e.Row.Cells[1].Visible = false;

        //        }

        //        if (e.Row.RowType == DataControlRowType.Header)
        //        {
        //            e.Row.Cells[1].Visible = false;
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        DisplayWebMessage(ex);
        //    }
        //}

        protected void grdViewGroup_SelectedIndexChanged(object sender, EventArgs e)
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

        protected void grdViewGroup_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                BindGrdViewMain(e.SortExpression, GetMainSortDirection(e.SortExpression));

                if (grdViewGroup.SelectedIndex > -1)
                {
                    MainGridSelectedIndexChanged();
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }
        
        //protected void gridViewInstanceData_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        XmlDocument ConfigFile = new XmlDocument();
        //        ConfigFile.Load(Server.MapPath(configurationFile));

        //        int rowInderx = gridViewInstanceData.SelectedIndex;

        //        string parameter1 = lblMessageID.Text = gridViewInstanceData.Rows[rowInderx].Cells[1].Text;
        //        string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/READMESSAGEDATA").InnerText.Trim();

        //        strNewcommand = String.Format(strNewcommand, parameter1);

        //        string[] messageDetails = new string[3];

        //        messageDetails[0] = ConfigurationManager.AppSettings["serverNameKey"].ToString();
        //        messageDetails[1] = strNewcommand;
        //        messageDetails[2] = parameter1;
        //        lblMsgID.Visible = true;
        //        lblMessageID.Visible = true;

        //        XmlDocument message = GetMessageContent(messageDetails);
        //        txtDetail.Text = bt_helper.dbHelper.RichTextBoxFunctionality(message.OuterXml.ToString().Trim());
        //        ConfigFile = null;
        //        Popup(true, sender);

        //    }
        //    catch (Exception ex)
        //    {
        //        DisplayWebMessage(ex);
        //    }

        //}

        protected void ddlInstanceData_SelectedIndexChanged(object sender, EventArgs e)
        {

            try
            {
                int rowInderx = ddlInstanceData.SelectedIndex;

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
                    txtDetail.Text = ReturnStringAsFormattedXML(message);
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
        
        //protected void gridViewOuterInstanceData_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        XmlDocument ConfigFile = new XmlDocument();
        //        ConfigFile.Load(Server.MapPath(configurationFile));

        //        int rowInderx = gridViewOuterInstanceData.SelectedIndex;

        //        string parameter1 = lblOMessageID.Text = gridViewOuterInstanceData.Rows[rowInderx].Cells[1].Text;
        //        string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/READMESSAGEDATA").InnerText.Trim();

        //        strNewcommand = String.Format(strNewcommand, parameter1);

        //        string[] messageDetails = new string[3];

        //        messageDetails[0] = ConfigurationManager.AppSettings["serverNameKey"].ToString();
        //        messageDetails[1] = strNewcommand;
        //        messageDetails[2] = parameter1;
        //        lblOMsgID.Visible = true;
        //        lblOMessageID.Visible = true;

        //        XmlDocument message = GetMessageContent(messageDetails);
        //        txtODetail.Text = bt_helper.dbHelper.RichTextBoxFunctionality(message.OuterXml.ToString().Trim());
        //        lblOErrorDesc.Text = HttpUtility.HtmlDecode("Message Content");
        //        ConfigFile = null;
        //        PopupOuter(true, sender);

        //    }
        //    catch (Exception ex)
        //    {
        //        DisplayWebMessage(ex);
        //    }

        //}

        protected void ddlOInstanceData_SelectedIndexChanged(object sender, EventArgs e)
        {

            try
            {
                int rowInderx = ddlOInstanceData.SelectedIndex;

                if (rowInderx > 0)
                {
                    XmlDocument ConfigFile = new XmlDocument();
                    ConfigFile.Load(Server.MapPath(configurationFile));

                    string parameter1 = lblOMessageID.Text = ddlOInstanceData.SelectedValue;
                    string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/READMESSAGEDATA").InnerText.Trim();

                    strNewcommand = String.Format(strNewcommand, parameter1);

                    string[] messageDetails = new string[3];

                    messageDetails[0] = ConfigurationManager.AppSettings["serverNameKey"].ToString();
                    messageDetails[1] = strNewcommand;
                    messageDetails[2] = parameter1;
                    lblOMsgID.Visible = true;
                    lblOMessageID.Visible = true;
                    lblMsgOTypetext.Visible = true;
                    lblMessageOTypeValue.Visible = true;

                    if (!ddlOInstanceData.SelectedItem.Text.Equals("NS#RootNode"))
                    {
                        lblMessageOTypeValue.Text = ddlOInstanceData.SelectedItem.Text;
                    }

                    XmlDocument message = GetMessageContent(messageDetails);
                    txtODetail.Text = ReturnStringAsFormattedXML(message);
                    ConfigFile = null;
                }
                else
                {
                    lblOMsgID.Visible = false;
                    lblOMessageID.Visible = false;
                    lblMsgOTypetext.Visible = false;
                    lblMessageOTypeValue.Visible = false;
                    txtODetail.Text = "";
                }

                PopupOuter(true, sender);


            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void gridViewAll_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "ShowPopup")
                {
                    ClearControlsOuter();

                    LinkButton btndetails = (LinkButton)e.CommandSource;
                    GridViewRow gvrow = (GridViewRow)btndetails.NamingContainer;
                    string instanceID = string.Empty;
                    string host = string.Empty;
                    int mainArrayNo = Convert.ToInt32(hdnMainArray.Value);

                    lblOSuspendtext.Visible = false;
                    lblOSuspendTime.Visible = false;
                    lblOSuspendTime.Visible = false;
                    lblOErrorDesc.Visible = false;
                    txtOErrorDetail.Text = "";
                    txtOErrorDetail.Enabled = false;
                    txtODetail.Text = "";
                    lblErrorOCode.Visible = false;
                    lblErrorOCodeText.Visible = false;
                    lblMessageOTypeValue.Text = "";
                    lblMsgOTypetext.Visible = false;
                    lblMessageOTypeValue.Visible = false;
                    lblOMsgID.Visible = false;
                    lblOMessageID.Visible = false;
                    ddlOInstanceData.Items.Clear();
                    ddlOInstanceData.DataSource = null;
                    ddlOInstanceData.DataBind();

                    if (gridViewAll.Rows.Count > 0)
                    {
                        instanceID = gridViewAll.Rows[gvrow.RowIndex].Cells[4].Text;
                        host = gridViewAll.Rows[gvrow.RowIndex].Cells[9].Text;
                    }

                    DataTable viewInstanceDataTable = GetInstanceData(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceID, host);

                    if (viewInstanceDataTable.Rows.Count > 0)
                    {
                        List<KeyValuePair<string, string>> comboDataSource = bt_helper.dbHelper.GetDropDownDataSource(viewInstanceDataTable);
                        ddlOInstanceData.DataTextField = "Value";
                        ddlOInstanceData.DataValueField = "Key";
                        ddlOInstanceData.DataSource = comboDataSource;
                        ddlOInstanceData.DataBind();
                        ddlOInstanceData.SelectedIndex = 0;
                    }
                    else
                    {
                        ddlOInstanceData.Items.Clear();
                    }

                    Menu2.Items[0].Text = "GENERAL INFORMATION";

                    if (mainArrayNo == 2 || gridViewAll.Rows[gvrow.RowIndex].Cells[6].Text.Equals("Suspended Resumable") || gridViewAll.Rows[gvrow.RowIndex].Cells[6].Text.Equals("Suspended Non-Resumable"))
                    {
                        Menu2.Items[0].Text = "ERROR INFORMATION";
                        lblOSuspendtext.Visible = true;
                        lblOSuspendTime.Visible = true;
                        lblOSuspendTime.Visible = true;
                        lblOErrorDesc.Visible = true;
                        txtOErrorDetail.Enabled = true;
                        lblErrorOCode.Visible = true;
                        lblErrorOCodeText.Visible = true;
                        lblOSuspendTime.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[13].Text);
                        lblErrorOCode.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[11].Text);
                        lblOErrorDesc.Text = HttpUtility.HtmlDecode("Error Description");
                        txtOErrorDetail.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[12].Text);
                    }

                    lblOServer.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[8].Text);
                    lblOAppName.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[2].Text);
                    lblOInstanceID.Text = HttpUtility.HtmlDecode(instanceID);
                    lblOInstanceStatus.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[6].Text);
                    lblOCreationTime.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[7].Text);
                    lblOServiceNameValue.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[3].Text);
                    lblOHostname.Text = HttpUtility.HtmlDecode(gridViewAll.Rows[gvrow.RowIndex].Cells[9].Text);

                    Menu2.Items[0].Selected = true;
                    MultiView2.ActiveViewIndex = 0;


                    lblOMsgID.Visible = false;
                    lblOMessageID.Visible = false;

                    PopupOuter(true, sender);

                    ChangeDetailColor(gvrow, gridViewAll);
                }
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void gridViewAll_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {

                BindGrdViewInstanceDetail(e.SortExpression, GetSortDirection(e.SortExpression));
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Asks for confirmation to perform Resume/Suspend operation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnBulkSuspendResume_Click(object sender, EventArgs e)
        {
            ArrayList statusList = new ArrayList();

            foreach (GridViewRow row in grdViewGroup.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkGridBox");

                if (chkBoxRows.Checked)
                {
                    statusList.Add(row.Cells[6].Text);
                }
            }

            string operation = SuspendORResume(statusList).ToUpper();
            
            statusList = null;
            
            btnSuspendConfirm.BackColor = System.Drawing.Color.LightSteelBlue;
            btnSuspendCancelRequest.BackColor = System.Drawing.Color.LightSteelBlue;
            lblSuspendConfirmation.Text = "<pre><span style=\"color: gray\"><b>" + "  Are you sure you want to " + "</span><span style=\"color: red\">" + operation + "</span><span style=\"color: gray\">" + " service instance(s) ?  " + "</b></span></pre>";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Confirmation", "javascript:ShowSuspendConfirmationMask()", true);   
        }

        /// <summary>
        /// Resume or Suspend instances based on status on confirmation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSuspendConfirm_Click(object sender, EventArgs e)
        {
            try
            {
                ArrayList instanceList = new ArrayList();
                ArrayList statusList = new ArrayList();

                foreach (GridViewRow row in grdViewGroup.Rows)
                {
                    CheckBox chkBoxRows = (CheckBox)row.FindControl("chkGridBox");

                    if (chkBoxRows.Checked)
                    {
                        instanceList.Add(row.Cells[4].Text);
                        statusList.Add(row.Cells[6].Text);
                    }
                }
                if (instanceList != null)
                {
                    string operation = SuspendORResume(statusList);

                    if (operation.Equals("Resume"))
                    {
                        bt_helper.dbHelper.ResumeInstance(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                    }
                    else
                    {
                        bt_helper.dbHelper.SuspendInstance(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                    }
                }

                instanceList = null;
                statusList = null;
                ClearControlsOnBulkOperation();
                RefreshMainGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Asks for confirmation to perform terminate operation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnBulkTerminate_Click(object sender, EventArgs e)
        {
            btnConfirm.BackColor = System.Drawing.Color.LightSteelBlue;
            btnCancelRequest.BackColor = System.Drawing.Color.LightSteelBlue;
            lblConfirmation.Text = "<pre><span style=\"color: gray\"><b>" + "  Are you sure you want to" + "</span><span style=\"color: red\">" + " TERMINATE " + "</span><span style=\"color: gray\">" + "service instance(s) ?  " + "</b></span></pre>";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Confirmation", "javascript:ShowConfirmationMask()", true);
            
        }

        /// <summary>
        /// Performs termination on confirmation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            try
            {
                ArrayList instanceList = new ArrayList();
                foreach (GridViewRow row in grdViewGroup.Rows)
                {
                    CheckBox chkBoxRows = (CheckBox)row.FindControl("chkGridBox");

                    if (chkBoxRows.Checked)
                    {
                        instanceList.Add(row.Cells[4].Text);
                    }
                }

                if (instanceList != null)
                {
                    bt_helper.dbHelper.TerminateInstance(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                }

                instanceList = null;
                ClearControlsOnBulkOperation();
                RefreshMainGrid();

               
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        ///  Asks for confirmation to perform Resume/Suspend operation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSuspendResumeInstance_Click(object sender, EventArgs e)
        {
            ArrayList statusList = new ArrayList();

            foreach (GridViewRow row in gridViewAll.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkSingleBox");

                if (chkBoxRows.Checked)
                {
                    statusList.Add(row.Cells[6].Text);
                }
            }

            string operation = SuspendORResume(statusList).ToUpper();

            statusList = null;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Confirmation", "javascript:ShowInstanceSuspendConfirmationMask('"+ operation +"')", true); 
        }

        /// <summary>
        /// Suspend or Resume instances based on status on confirmation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnInstanceSuspendConfirm_Click(object sender, EventArgs e)
        {
            try
            {
                ArrayList instanceList = new ArrayList();
                ArrayList statusList = new ArrayList();

                foreach (GridViewRow row in gridViewAll.Rows)
                {
                    CheckBox chkBoxRows = (CheckBox)row.FindControl("chkSingleBox");

                    if (chkBoxRows.Checked)
                    {
                        instanceList.Add(row.Cells[4].Text);
                        statusList.Add(row.Cells[6].Text);
                    }
                }
                if (instanceList != null)
                {
                    string operation = SuspendORResume(statusList);

                    if (operation.Equals("Resume"))
                    {
                        bt_helper.dbHelper.ResumeInstance(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                    }
                    else
                    {
                        bt_helper.dbHelper.SuspendInstance(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                    }
                }

                instanceList = null;
                statusList = null;
                ClearControlsOnOperation();
                RefreshAllGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        /// <summary>
        /// Asks for confirmation to perform terminate operation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnTerminateInstance_Click(object sender, EventArgs e)
        {
            lblConfirmationInstance.Visible = true;
            
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Confirmation", "javascript:ShowInstanceConfirmationMask()", true);
        }

        /// <summary>
        /// Performs termination on confirmation
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnConfirmInstance_Click(object sender, EventArgs e)
        {
            try
            {
                ArrayList instanceList = new ArrayList();
                foreach (GridViewRow row in gridViewAll.Rows)
                {
                    CheckBox chkBoxRows = (CheckBox)row.FindControl("chkSingleBox");

                    if (chkBoxRows.Checked)
                    {
                        instanceList.Add(row.Cells[4].Text);
                    }
                }

                if (instanceList != null)
                {
                    bt_helper.dbHelper.TerminateInstance(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceList);
                }

                instanceList = null;
                ClearControlsOnOperation();
                RefreshAllGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }


        protected void btnBulkDownloadInstance_Click(object sender, EventArgs e)
        {
            try
            {
                BulkInstanceIDToMemory();
                DownLoadMessages(bulkInstanceIdList,false);
                ResetGlobalVariables();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        protected void btnDownloadInstance_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedInstanceIDList();
                DownLoadMessages(instanceIDList,true);
                ResetGlobalVariables();

            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        #endregion

        #region Private Methods

        private void BulkInstanceIDToMemory()
        {
            bulkInstanceIdList = new ArrayList();
            hostNameList = new ArrayList();
            servicenamelist = new ArrayList();
            errorList = new ArrayList();
            foreach (GridViewRow row in grdViewGroup.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkGridBox");

                if (chkBoxRows.Checked)
                {
                    servicenamelist.Add(row.Cells[3].Text);
                    bulkInstanceIdList.Add(row.Cells[4].Text);
                    hostNameList.Add(row.Cells[9].Text);
                    errorList.Add(row.Cells[11].Text);
                }
            }
        }

        private void ReturnSelectedInstanceIDList()
        {
            instanceIDList = new ArrayList();
            hostNameList = new ArrayList();
            errorList = new ArrayList();
            ViewState["ServiceName"] = gridViewAll.Rows[0].Cells[3].Text;
            foreach (GridViewRow row in gridViewAll.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkSingleBox");

                if (chkBoxRows.Checked)
                {
                    instanceIDList.Add(row.Cells[4].Text);
                    hostNameList.Add(row.Cells[9].Text);
                    errorList.Add(row.Cells[12].Text);
                }
            }
        }

        private void ResetGlobalVariables()
        {
            instanceIDList = null;
            bulkInstanceIdList = null;
            hostNameList = null;
            servicenamelist = null;
            errorList = null;
        }

        private void DownLoadMessages(ArrayList instanceList,bool isGrouped)
        {
            try
            {
                if (instanceList != null)
                {
                    ZipFile zip = new ZipFile();
                    zip.AlternateEncodingUsage = ZipOption.Default;

                    XmlDocument ConfigFile = new XmlDocument();
                    ConfigFile.Load(Server.MapPath(configurationFile));
                    int instanceCount =0;
                    foreach (object instanceID in instanceList)
                    {
                        DataTable instanceMessageDataTable = GetInstanceData(ConfigurationManager.AppSettings["serverNameKey"].ToString(), instanceID.ToString(), hostNameList[instanceCount].ToString());

                        if (instanceMessageDataTable.Rows.Count > 0)
                        {
                            //ArrayList messageIDList = new ArrayList();
                            Dictionary<string, string> msgID_Type = new Dictionary<string, string>();

                            for (int rowCount = 0; rowCount < instanceMessageDataTable.Rows.Count; rowCount++)
                            {
                                //messageIDList.Add(instanceMessageDataTable.Rows[rowCount][1]);
                                msgID_Type.Add(instanceMessageDataTable.Rows[rowCount][1].ToString(), instanceMessageDataTable.Rows[rowCount][0].ToString());

                            }

                            if (msgID_Type.Count > 0)
                            {
                                if (isGrouped)
                                {
                                    if (!string.IsNullOrEmpty(errorList[instanceCount].ToString()))
                                        zip.AddEntry(instanceID + "_ErrorDescription.txt", errorList[instanceCount].ToString());
                                }
                                else
                                {
                                    if (!string.IsNullOrEmpty(errorList[instanceCount].ToString()))
                                        zip.AddEntry(servicenamelist[instanceCount].ToString() + "_" + instanceID + "_ErrorDescription.txt", errorList[instanceCount].ToString());
                                }
                                //foreach (object msgID in messageIDList)
                                foreach (KeyValuePair<string, string> pair in msgID_Type)
                                {
                                    string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/READMESSAGEDATA").InnerText.Trim();

                                    strNewcommand = String.Format(strNewcommand, pair.Key.ToString());

                                    string[] messageInfo = null;
                                    messageInfo = new string[3];

                                    messageInfo[0] = ConfigurationManager.AppSettings["serverNameKey"].ToString();
                                    messageInfo[1] = strNewcommand;
                                    messageInfo[2] = pair.Key.ToString();

                                    string xmlName = pair.Value.ToString().Substring(pair.Value.ToString().LastIndexOf("/") + 1);

                                    XmlDocument message = bt_helper.dbHelper.GetMessageFromBtsMsgBox(messageInfo);
                                    if(isGrouped)
                                        zip.AddEntry(instanceID + "_" + pair.Key.ToString() + "_" + xmlName + ".xml", message.OuterXml.ToString());
                                    else
                                        zip.AddEntry(servicenamelist[instanceCount].ToString() + "_" + instanceID + "_" + pair.Key.ToString() + "_" + xmlName + ".xml", message.OuterXml.ToString());
                                }
                            }
                            msgID_Type = null;
                        }
                        instanceMessageDataTable = null;
                        instanceCount = instanceCount + 1;

                    }

                    ConfigFile = null;
                    Response.Clear();
                    Response.BufferOutput = false;
                    string zipName = string.Empty;
                    if(isGrouped)
                        zipName = String.Format("{0}_{1}.zip", ViewState["ServiceName"].ToString(), DateTime.Now.ToString("yyyy-MMM-dd-HHmmss"));
                    else
                        zipName = String.Format("{0}_{1}.zip", "BTMonitorDownload", DateTime.Now.ToString("yyyy-MMM-dd-HHmmss"));

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

        private void ClearControlsOnOperation()
        {
            btnSuspendResumeInstance.Visible = false;
            btnTerminateInstance.Visible = false;
            btnTerminateInstance.Enabled = false;
            btnSuspendResumeInstance.Enabled = false;
            btnDownloadInstance.Enabled = false;
            btnDownloadInstance.Visible = false;
            gridViewAll.DataSource = null;
            gridViewAll.DataBind();
            gridViewAll.Visible = false;
            ChkOAll.Checked = false;
            ChkOAll.Visible = false;
        }

        private void ClearControlsOnBulkOperation()
        {
            chkAll.Checked = false;
            btnBulkSuspendResume.Enabled = false;
            btnBulkTerminate.Enabled = false;
            btnBulkTerminate.Visible = false;
            btnBulkSuspendResume.Visible = false;
            chkAll.Visible = false;
            
            grdViewGroup.DataSource = null;
            grdViewGroup.DataBind();

            grdViewGroup.Visible = false;
        }

        private void ClearControlsOuter()
        {
            lblOServer.Text = "";
            lblOAppName.Text = "";
            lblOInstanceID.Text = "";
            lblOInstanceStatus.Text = "";
            lblOCreationTime.Text = "";
            lblOServiceNameValue.Text = "";
            lblOHostname.Text = "";
            lblOSuspendTime.Text = "";
            lblOErrorDesc.Text = "";
            txtODetail.Text = "";
            ddlOInstanceData.DataSource = null;
            ddlOInstanceData.DataBind();
            lblOSuspendtext.Visible = false;
            lblOSuspendTime.Visible = false;
        }

        private void BindGrdViewMain(string sortExp, string sortDir)
        {
            hdnOCheckBoxDehydratedChk.Value = "0";
            hdnOCheckBoxSuspendedChk.Value = "0";
            hdnCheckBoxDehydratedChk.Value = "0";
            hdnCheckBoxSuspendedChk.Value = "0";

            DataTable suspendtable = (DataTable)ViewState["MainGridDataTable"];
                //bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), ViewState["MainGridQuery"].ToString());

            if (suspendtable.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = suspendtable.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdViewGroup.DataSource = myDataView;
                grdViewGroup.DataBind();
            }
            else
            {
                grdViewGroup.DataSource = null;
                grdViewGroup.DataBind();
            }
        }

        private void BindGrdViewInstanceDetail(string sortExp, string sortDir)
        {
            hdnOCheckBoxDehydratedChk.Value = "0";
            hdnOCheckBoxSuspendedChk.Value = "0";
            DataTable suspendtable = (DataTable)ViewState["AllGridDataTable"];
                //bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), ViewState["AllGridQuery"].ToString());

            if (suspendtable.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = suspendtable.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                gridViewAll.DataSource = myDataView;
                gridViewAll.DataBind();

                btnTerminateInstance.Visible = true;
                //btnDownloadInstance.Visible = true;
                btnSuspendResumeInstance.Visible = true;
                ChkOAll.Visible = true;
                ChkOAll.Checked = false;
                btnTerminateInstance.BackColor = System.Drawing.Color.Empty;
                btnDownloadInstance.BackColor = System.Drawing.Color.Empty;
                btnSuspendResumeInstance.BackColor = System.Drawing.Color.Empty;
            }
            else
            {
                gridViewAll.DataSource = null;
                gridViewAll.DataBind();
            }
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

        private void MainGridSelectedIndexChanged()
        {
            
            hdnOCheckBoxDehydratedChk.Value = "0";
            hdnOCheckBoxSuspendedChk.Value = "0";
            bool sharedQuery = false;
            XmlDocument ConfigFile = new XmlDocument();
            ConfigFile.Load(Server.MapPath(configurationFile));
            int rowInderx = grdViewGroup.SelectedIndex;
            StringBuilder grpConditions = new StringBuilder();
            int searchLimit = Convert.ToInt32(hdnCount.Value);
            int mainArrayNo = Convert.ToInt32(hdnMainArray.Value);
            ArrayList sharedServers = new ArrayList();
            sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));

            if (sharedServers.Contains(ConfigurationManager.AppSettings["serverNameKey"].ToString()))
                sharedQuery = true;

            ChangeDetailColor(grdViewGroup.SelectedRow, grdViewGroup);

            string[] groupOrder = ViewState["grpByValues"].ToString().Split(',');
            string grpInternalConditions = ViewState["groupInternalCondition"].ToString();

            for (int grpCount = 0; grpCount < groupOrder.Length; grpCount++)
            {
                grpConditions.Append(" AND ");

                switch (groupOrder[grpCount].Trim())
                {
                    case "Application":
                        grpConditions.Append("m.nvcName =''" + grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "''");
                        break;
                    case "Host Name":
                        grpConditions.Append("app.nvcApplicationName  =''");
                        grpConditions.Append(grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "''");
                        break;
                    case "Service Class":
                        if (grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text.Equals("Routing Failure Report"))
                        {
                            grpConditions.Append("i.nvcErrorID = ''0xC0C01B4e''");
                        }
                        else
                        {
                            grpConditions.Append("sc.nvcName=''");
                            grpConditions.Append(grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "''");
                        }
                        break;
                    case "Service Instance Status":
                        grpConditions.Append("i.nState = ");
                        switch (grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text)
                        {
                            case "Active":
                                grpConditions.Append("2");
                                break;
                            case "Dehydrated":
                                grpConditions.Append("8");
                                break;
                            case "Suspended Resumable":
                                grpConditions.Append("4");
                                break;
                            case "Suspended Non-Resumable":
                                grpConditions.Append("32");
                                break;
                            case "Ready To Run":
                                grpConditions.Append("1");
                                break;
                            case "Completed With Discarded Messages":
                                grpConditions.Append("16");
                                break;
                        }
                        break;
                    case "Service Name":
                        grpConditions.Append(" (");
                        grpConditions.Append("item.FULLNAME  =''");
                        grpConditions.Append(grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "'' OR  ");
                        grpConditions.Append("rp.nvcName=''");
                        grpConditions.Append(grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "'' OR ");
                        grpConditions.Append("sp.nvcName=''");
                        grpConditions.Append(grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "'')");
                        break;
                    case "Error Code":
                        grpConditions.Append("i.nvcErrorID =''" + grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "''");
                        break;
                    case "Error Description":
                        grpConditions.Append("i.nvcErrorDescription LIKE ''%" + grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text + "%''");
                        break;
                    case "Pending Operation Type":
                        grpConditions.Append("i.uidInstanceID IN (");

                        switch (grdViewGroup.Rows[rowInderx].Cells[grpCount + 3].Text)
                        {
                            case "Suspend":
                                grpConditions.Append("SELECT uidInstanceID FROM [' + @messageBoxName + '].dbo.[InstancesPendingOperations] WHERE nPendingOperation = 4");
                                break;
                            case "Terminate":
                                grpConditions.Append("SELECT uidInstanceID FROM [' + @messageBoxName + '].dbo.[InstancesPendingOperations] WHERE nPendingOperation = 8");
                                break;
                            case "None":
                                grpConditions.Append("SELECT uidInstanceID FROM [' + @messageBoxName + '].dbo.[InstancesPendingOperations] WHERE nPendingOperation  NOT IN(4,8)");
                                break;
                        }
                        break;
                }
            }

            string strNewcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/ExpandQuery").InnerText.Trim();
            string fullGroupCondition = grpInternalConditions + grpConditions.ToString();

            if(sharedQuery)
                strNewcommand = String.Format(strNewcommand, fullGroupCondition, searchLimit, " AND m.nvcName LIKE ''%" + ViewState["ApplicationDomain"].ToString() + "%''");
            else
                strNewcommand = String.Format(strNewcommand, fullGroupCondition, searchLimit,"");

            ViewState["AllGridQuery"] = "";
            ViewState["AllGridQuery"] = strNewcommand;

            DataTable expandTable = bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strNewcommand);
            ViewState["AllGridDataTable"] = expandTable;
            if (expandTable.Rows.Count > 0)
            {
                gridViewAll.SelectedIndex = -1;
                gridViewAll.Visible = true;
                gridViewAll.DataSource = expandTable;
                gridViewAll.DataBind();

                if (mainArrayNo == 2)
                {
                    btnSuspendResumeInstance.Text = "Resume";
                }
                else
                {
                    btnSuspendResumeInstance.Text = "Suspend";
                }

                btnTerminateInstance.Visible = true;
                //btnDownloadInstance.Visible = true;
                btnSuspendResumeInstance.Visible = true;
                btnDownloadInstance.Visible = true;
                ChkOAll.Visible = true;
                ChkOAll.Checked = false;
                grpConditions = null;
                btnTerminateInstance.BackColor = System.Drawing.Color.Empty;
                btnDownloadInstance.BackColor = System.Drawing.Color.Empty;
                btnSuspendResumeInstance.BackColor = System.Drawing.Color.Empty;
                btnDownloadInstance.BackColor = System.Drawing.Color.Empty;
            }
            else
            {
                gridViewAll.DataSource = null;
                gridViewAll.DataBind();
            }
            //ViewState["Host"] = grdViewGroup.Rows[rowInderx].Cells[9].Text;
            ConfigFile = null;
        }

        private void GetCustomQueryConditions()
        {
            ArrayList sharedServers = new ArrayList();
            sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));
            XmlDocument ConfigFile = new XmlDocument();
            
            try
            {
                ConfigFile.Load(Server.MapPath(configurationFile));

                string strcommand = string.Empty;
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/CustomQueryConditiondata").InnerText.Trim();

                if (sharedServers.Contains(ConfigurationManager.AppSettings["serverNameKey"].ToString()))
                    strcommand = String.Format(strcommand, "WHERE nvcName LIKE '%" + ViewState["ApplicationDomain"].ToString() + "%'", "WHERE Name LIKE '%" + ViewState["HostDomain"].ToString() + "%'");
                else
                    strcommand = String.Format(strcommand, "", "");

                DataSet customQueryDS = new DataSet();
                
                customQueryDS = bt_helper.dbHelper.ExecuteMgmtQueryDataSet(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
                AddConditionsToList(customQueryDS);
                ConfigFile = null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void AddConditionsToList(DataSet conditions)
        {
            bool appExists = false;
            bool hostExists = false;
            try
            {
                for (int app = 0; app < conditions.Tables[0].Rows.Count; app++)
                {
                    appExists = true;
                    hdnAppName.Value = hdnAppName.Value + conditions.Tables[0].Rows[app][0].ToString() + ";";
                }

                for (int host = 0; host < conditions.Tables[1].Rows.Count; host++)
                {
                    hostExists = true;
                    hdnHostName.Value = hdnHostName.Value + conditions.Tables[1].Rows[host][0].ToString() + ";";
                }
                if (appExists)
                    hdnAppName.Value = hdnAppName.Value.Substring(0, (hdnAppName.Value.Length - 1));
                if(hostExists)
                    hdnHostName.Value = hdnHostName.Value.Substring(0, (hdnHostName.Value.Length - 1));

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Logs exception in log file. Shows generic error message to User
        /// </summary>
        /// <param name="ex"></param>
        private void DisplayWebMessage(Exception ex)
        {
            string errorLogFile = ConfigurationManager.AppSettings["ErrorLogs"];
            string logFile = HttpContext.Current.Server.MapPath(errorLogFile);
            bt_helper.dbHelper.DisplayMessageLogError(ex, logFile);

            lblErrorMask.Text = "<pre><span style=\"color: gray\"><b>" + " Error while processing the request, Please check with support." + "</b></span></pre>";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Error", "javascript:ShowErrorMask()", true);
            
        }

        private bool isConditionSelected(string[] conditionArray)
        {
            bool conditionSelected = false;

            foreach (string condition in conditionArray)
            {
                if (condition.Equals("Y"))
                {
                    conditionSelected = true;
                    break;
                }
            }

            return conditionSelected;
        }

        private bool RequiredFieldValidations(string[] conditionArray, string[] conditionValues, out string displayMessage)
        {
            bool conditionsValidated = true;
            
            StringBuilder errorMessage = new StringBuilder();
            errorMessage.Append("<pre>");
            errorMessage.Append("<span style=\"color: green\">");
            errorMessage.Append("Either remove the filter(s) OR provide valid value(s). ");
            errorMessage.Append("Below filter(s) have EMPTY or INVALID value(s):\n\n");
            errorMessage.Append("</span>");
            displayMessage = "";

            for (int conditionCount = 0; conditionCount < conditionArray.Length; conditionCount++)
            {
                if (conditionArray[conditionCount].Equals("Y"))
                {
                    if (string.IsNullOrEmpty(conditionValues[conditionCount]))
                    {
                        conditionsValidated = false;
                        errorMessage.Append("<span style=\"color: red\">");
                        errorMessage.Append("<b>");
                        errorMessage.Append("\n");

                        switch (conditionCount)
                        {
                            case 0:
                                errorMessage.Append("Application Name");
                                break;
                            case 1:
                                errorMessage.Append("Creation Time");
                                break;
                            case 2:
                                errorMessage.Append("Group Results By");
                                break;
                            case 3:
                                errorMessage.Append("Host Name");
                                break;
                            case 4:
                                errorMessage.Append("Instance Status");
                                break;
                            case 5:
                                errorMessage.Append("Service Instance ID");
                                break;
                            case 6:
                                errorMessage.Append("Pending Operations");
                                break;
                            case 7:
                                errorMessage.Append("Error Code");
                                break;
                            case 8:
                                errorMessage.Append("Error Description");
                                break;
                            case 9:
                                errorMessage.Append("Suspension Time");
                                break;
                        }
                        errorMessage.Append("<span style=\"color: gray\">");
                        errorMessage.Append(" : Empty");
                        errorMessage.Append("</span>");

                        errorMessage.Append("</b>");
                        errorMessage.Append("</span>");
                    }
                    else
                    {
                        if (conditionCount == 5)
                        {
                            Guid guidOutput;
                            
                            bool isValid = Guid.TryParse(conditionValues[conditionCount], out guidOutput);

                            if (!isValid)
                            {
                                conditionsValidated = false;
                                errorMessage.Append("<span style=\"color: red\">");
                                errorMessage.Append("<b>");
                                errorMessage.Append("\n");
                                errorMessage.Append("Service Instance ID");
                                errorMessage.Append("<span style=\"color: gray\">");
                                errorMessage.Append(" : Invalid GUID");
                                errorMessage.Append("</span>");
                                errorMessage.Append("</b>");
                                errorMessage.Append("</span>");
                            }
                        }
                        else if (conditionCount == 1 || conditionCount == 9)
                        {
                            DateTime value;
                            bool isValid = DateTime.TryParse(conditionValues[conditionCount], out value);

                            if (!isValid)
                            {
                                conditionsValidated = false;
                                errorMessage.Append("<span style=\"color: red\">");
                                errorMessage.Append("<b>");
                                errorMessage.Append("\n");
                                if(conditionCount==1)
                                    errorMessage.Append("Creation Time");
                                else
                                    errorMessage.Append("Suspension Time");

                                errorMessage.Append("<span style=\"color: gray\">");
                                errorMessage.Append(" : Invalid Date Time");
                                errorMessage.Append("</span>");

                                errorMessage.Append("</b>");
                                errorMessage.Append("</span>");
                            }
                        }
                    }
                }
            }
            errorMessage.Append("</pre>");
            displayMessage = errorMessage.ToString();
            return conditionsValidated;
        }

        private DataTable GetMainGridData(string serverName)
        {
            ArrayList sharedServers = new ArrayList();
            string strcommand = string.Empty;
            XmlDocument ConfigFile = new XmlDocument();
            ConfigFile.Load(Server.MapPath(configurationFile));

            sharedServers.AddRange(ConfigurationManager.AppSettings["SharedServer"].Split(','));

            if (sharedServers.Contains(serverName))
            {
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/SUSPENDEDCOUNTPERSERVICETYPEIDSHARED").InnerText.Trim();
                strcommand = String.Format(strcommand, Session["AppDomain"] .ToString());
            }
            else
            {
                strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/SUSPENDEDCOUNTPERSERVICETYPEID").InnerText.Trim();
            }

            DataTable suspendtable = bt_helper.dbHelper.ExecuteMsgBoxQuery(serverName, strcommand);
            ConfigFile = null;
            return suspendtable;
        }

        private string GetConditions(string[] conitions, string[] operators, string[] values, int arraySelected)
        {
            StringBuilder whereCondition = new StringBuilder();
            int count = 0;
            for(int conditionCount =0; conditionCount<conitions.Length; conditionCount++)
            {
                if (conitions[conditionCount].Equals("Y"))
                {
                    if (conditionCount!=2)
                    {
                        whereCondition.Append(" AND ");
                    }
                    switch (conditionCount)
                    {
                        case 0:
                            whereCondition.Append("m.nvcName ");
                            whereCondition.Append("IN (");
                            whereCondition.Append(MultipleStringValue(values[conditionCount]));
                            whereCondition.Append(")");
                            break;
                        case 1:
                            whereCondition.Append("dtCreated ");
                            whereCondition.Append(operators[conditionCount]);
                            whereCondition.Append("''" + values[conditionCount] + "''");
                            break;
                        case 3:
                            whereCondition.Append("app.nvcApplicationName ");
                            whereCondition.Append("IN (");
                            whereCondition.Append(MultipleStringValue(values[conditionCount]));
                            whereCondition.Append(")");
                            break;
                        case 4:
                            whereCondition.Append("nState ");
                            whereCondition.Append("IN (");
                            whereCondition.Append(GetInstanceStatus(values[conditionCount]));
                            whereCondition.Append(")");
                            break;
                        case 5:
                            whereCondition.Append("uidInstanceID ");
                            whereCondition.Append(operators[conditionCount]);
                            whereCondition.Append("''" + values[conditionCount] + "''");
                            break;
                        case 6:
                            whereCondition.Append("uidInstanceID ");
                            whereCondition.Append("IN (");
                            whereCondition.Append("SELECT uidInstanceID FROM [' + @messageBoxName + '].dbo.[InstancesPendingOperations] WHERE nPendingOperation  =");

                            switch (values[conditionCount])
                            {
                                case "Suspend":
                                    whereCondition.Append("''4''");
                                    break;
                                case "Terminate":
                                    whereCondition.Append("''8''");
                                    break;

                            }
                            whereCondition.Append(")");
                            break;
                        case 7:
                            whereCondition.Append("nvcErrorID ");
                            whereCondition.Append(operators[conditionCount]);
                            whereCondition.Append("''" + values[conditionCount] + "''");
                            break;
                        case 8:
                            whereCondition.Append("nvcErrorDescription ");
                            whereCondition.Append("LIKE ");
                            whereCondition.Append("''%" + values[conditionCount] + "%''");
                            break;
                        case 9:
                            whereCondition.Append("dtSuspendTimeStamp ");
                            whereCondition.Append(operators[conditionCount]);
                            whereCondition.Append("''" + values[conditionCount] + "''");
                            break;
                    }
                    count = count + 1;
                }
            }

            switch (arraySelected)
            {
                case 1:
                    whereCondition.Append(" AND nState IN (2,8) ");
                    break;
                case 2:
                    whereCondition.Append(" AND nState IN (4,32) ");
                    break;

            }
            

            return whereCondition.ToString();
        }

        private string MultipleStringValue(string value)
        {
            string[] multipleValue = value.Split(',');
            StringBuilder sb = new StringBuilder();

            foreach (string val in multipleValue)
            {
                sb.Append("''" + val.Trim() + "'',");
            }

            return sb.ToString().Substring(0,sb.ToString().Length-1);

        }

        private string GetInstanceStatus(string value)
        {
            string[] multipleValue = value.Split(',');
            StringBuilder sb = new StringBuilder();

            foreach (string val in multipleValue)
            {
                switch (val.Trim())
                {
                    case "All Runnung":
                        sb.Append("2, 8");
                        break;
                    case "All Suspended":
                        sb.Append("4, 32");
                        break;
                    case "Active":
                        sb.Append("2");
                        break;
                    case "Dehydrated":
                        sb.Append("8");
                        break;
                    case "Ready to Run":
                        sb.Append("1");
                        break;
                    case "Scheduled":
                        sb.Append("1");
                        break;
                    case "Suspended Resumable":
                        sb.Append("4");
                        break;
                    case "Suspended Non Resumable":
                        sb.Append("32");
                        break;
                }
                sb.Append(",");
            }

            return sb.ToString().Substring(0, sb.ToString().Length - 1);
        }

        private string GroupColumns(string value)
        {
            string[] groupValues = value.Split(',');
            StringBuilder groupQuery = new StringBuilder();
            int count = 0;

            foreach (string val in groupValues)
            {
                if (count > 0)
                {
                    groupQuery.Append(" , ");
                }
                switch (val.Trim())
                {
                    case "Application":
                        groupQuery.Append("m.nvcName");
                        break;
                    case "Host Name":
                        groupQuery.Append("app.nvcApplicationName ");
                        break;
                    case "Service Class":
                        groupQuery.Append("ISNULL(sc.nvcName,CASE WHEN i.nvcErrorID=''0xC0C01B4e'' THEN ''Routing Failure Report'' END)");
                        break;
                    case "Service Instance Status":
                        groupQuery.Append("i.nState");
                        break;
                    case "Service Name":
                        groupQuery.Append("ISNULL(ISNULL(item.FULLNAME,rp.nvcName),sp.nvcName)");
                        break;
                    case "Error Code":
                        groupQuery.Append("i.nvcErrorID");
                        break;
                    case "Error Description":
                        groupQuery.Append("i.nvcErrorDescription");
                        break;
                   //case "Pending Operation Type":
                       // groupQuery.Append("[Pending Job]");
                       // break;
                }
                count = count + 1;
            }

            return groupQuery.ToString();
        }

        private string GroupColumnsSelect(string value)
        {
            string[] groupValues = value.Split(',');
            StringBuilder groupQuery = new StringBuilder();
            int count = 0;

            foreach (string val in groupValues)
            {
                if (count > 0)
                {
                    groupQuery.Append(" , ");
                }
                switch (val.Trim())
                {
                    case "Application":
                        groupQuery.Append("m.nvcName AS [ApplicationName]");
                        break;
                    case "Host Name":
                        groupQuery.Append("app.nvcApplicationName AS [Host] ");
                        break;
                    case "Service Class":
                        groupQuery.Append("ISNULL(sc.nvcName,CASE WHEN i.nvcErrorID=''0xC0C01B4e'' THEN ''Routing Failure Report'' END) AS [ServiceClass]");
                        break;
                    case "Service Instance Status":
                        groupQuery.Append("i.nState AS [Status] ");
                        break;
                    case "Service Name":
                        groupQuery.Append("ISNULL(ISNULL(item.FULLNAME,rp.nvcName),sp.nvcName) AS [ServiceName]");
                        break;
                    case "Error Code":
                        groupQuery.Append("i.nvcErrorID AS [ErrorCode]");
                        break;
                    case "Error Description":
                        groupQuery.Append("i.nvcErrorDescription AS [ErrorDescription]");
                        break;
                    //case "Pending Operation Type":
                    // groupQuery.Append("[Pending Job]");
                    // break;
                }
                count = count + 1;
            }

            return groupQuery.ToString();
        }

        private string GroupedSelect(string value)
        {
            string[] groupValues = value.Split(',');
            StringBuilder groupQuery = new StringBuilder();
            int count = 0;

            foreach (string val in groupValues)
            {
                if (count > 0)
                {
                    groupQuery.Append(" , ");
                }
                switch (val.Trim())
                {
                    case "Application":
                        groupQuery.Append("[ApplicationName] ");
                        break;
                    case "Host Name":
                        groupQuery.Append("[Host] ");
                        break;
                    case "Service Class":
                        groupQuery.Append("[ServiceClass] ");
                        break;
                    case "Service Instance Status":
                        groupQuery.Append("[Status] ");
                        break;
                    case "Service Name":
                        groupQuery.Append("[ServiceName] ");
                        break;
                    case "Error Code":
                        groupQuery.Append("[ErrorCode] ");
                        break;
                    case "Error Description":
                        groupQuery.Append("[ErrorDescription] ");
                        break;
                    //case "Pending Operation Type":
                    // groupQuery.Append("[Pending Job]");
                    // break;
                }
                count = count + 1;
            }

            return groupQuery.ToString();
        }

        private string GroupedSelectPart(string value)
        {
            string[] groupValues = value.Split(',');
            StringBuilder groupQuery = new StringBuilder();
            int count = 0;

            foreach (string val in groupValues)
            {
                if (count > 0)
                {
                    groupQuery.Append(" , ");
                }
                switch (val.Trim())
                {
                    case "Application":
                        groupQuery.Append("[ApplicationName] ");
                        break;
                    case "Host Name":
                        groupQuery.Append("[Host] ");
                        break;
                    case "Service Class":
                        groupQuery.Append("[ServiceClass] ");
                        break;
                    case "Service Instance Status":
                        groupQuery.Append(" CASE [Status] WHEN 1 THEN ''Ready To Run'' WHEN 2 THEN ''Active'' WHEN 4 THEN ''Suspended Resumable'' WHEN 8 THEN ''Dehydrated'' WHEN 16 THEN ''Completed With Discarded Messages'' WHEN 32 THEN ''Suspended Non-Resumable'' END AS [Status]");
                        break;
                    case "Service Name":
                        groupQuery.Append("[ServiceName] ");
                        break;
                    case "Error Code":
                        groupQuery.Append("[ErrorCode] ");
                        break;
                    case "Error Description":
                        groupQuery.Append("[ErrorDescription] ");
                        break;
                    //case "Pending Operation Type":
                    // groupQuery.Append("[Pending Job]");
                    // break;
                }
                count = count + 1;
            }

            return groupQuery.ToString();
        }

        private void Popup(bool isDisplay, object sender)
        {
            ScriptManager.RegisterStartupScript((sender as Control), this.GetType(), "ShowPopup", "javascript:ShowPopup()", true);
        }

        private void PopupOuter(bool isDisplay, object sender)
        {
            ScriptManager.RegisterStartupScript((sender as Control), this.GetType(), "ShowPopup", "javascript:ShowPopup1()", true);

        }

        private void PopupErrorMask(bool isDisplay, object sender)
        {
            ScriptManager.RegisterStartupScript((sender as Control), this.GetType(), "Validation Error", "javascript:ShowValidationError()", true);

        }

        private DataTable GetInstanceData(string serverName, string instanceID, string host)
        {
            XmlDocument ConfigFile = new XmlDocument();
            ConfigFile.Load(Server.MapPath(configurationFile));

            string strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/MESSAGETYPEFORSUSPENDEDINSTANCE").InnerText.Trim();
            string parameter1 = host + "Q_Suspended";
            string parameter2 = "InstanceStateMessageReferences_" + host;

            strcommand = String.Format(strcommand, parameter1, "''" + instanceID + "''", parameter2);

            DataTable instanceTable = bt_helper.dbHelper.ExecuteMsgBoxQuery(serverName, strcommand);
            ConfigFile = null;
            return instanceTable;
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
        
        private string GetErrorDescription(string serverName, string instanceID)
        {
            XmlDocument ConfigFile = new XmlDocument();
            ConfigFile.Load(Server.MapPath(configurationFile));

            string strcommand = ConfigFile.SelectSingleNode(@"/ConfigurationValues/INSTANCEERRORDESCRIPTION").InnerText.Trim();
            strcommand = String.Format(strcommand, instanceID);
            DataTable errorDescription = bt_helper.dbHelper.ExecuteMsgBoxQuery(serverName, strcommand);
            
            ConfigFile = null;
            
            if (errorDescription.Rows.Count > 0)
            {
                return errorDescription.Rows[0][0].ToString();
            }
            else
            {
                return "";
            }
            
        }

        private string SuspendORResume(ArrayList statusList)
        {
            if (statusList[0].ToString().Trim().Equals("Suspended Resumable") || statusList[0].ToString().Trim().Equals("Suspended Non-Resumable"))
            {
                return "Resume";
            }
            else
            {
                return "Suspend";
            }
        }

        private void RefreshMainGrid()
        {
            string strcommand = ViewState["MainQuery"].ToString();
            DataTable refreshtable = bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
            if (refreshtable.Rows.Count > 0)
            {
                grdViewGroup.Visible = true;
                grdViewGroup.DataSource = refreshtable;
                grdViewGroup.DataBind();
                grdViewGroup.SelectedIndex = -1;
                btnBulkSuspendResume.Visible = true;
                btnBulkSuspendResume.Enabled = false;
                btnBulkTerminate.Visible = true;
                btnBulkTerminate.Enabled = false;
                chkAll.Visible = true;
                chkAll.Checked = false;
                btnBulkTerminate.BackColor = System.Drawing.Color.Empty;
                btnBulkSuspendResume.BackColor = System.Drawing.Color.Empty;
            }
        }

        private void RefreshAllGrid()
        {
            string strcommand = ViewState["AllGridQuery"].ToString();
            DataTable refreshtable = bt_helper.dbHelper.ExecuteMsgBoxQuery(ConfigurationManager.AppSettings["serverNameKey"].ToString(), strcommand);
            int mainArrayNo = Convert.ToInt32(hdnMainArray.Value);
            hdnOCheckBoxDehydratedChk.Value = "0";
            hdnOCheckBoxSuspendedChk.Value = "0";

            if (refreshtable.Rows.Count > 0)
            {
                gridViewAll.SelectedIndex = -1;
                gridViewAll.Visible = true;
                gridViewAll.DataSource = refreshtable;
                gridViewAll.DataBind();

                if (mainArrayNo == 2)
                {
                    btnSuspendResumeInstance.Text = "Resume";
                }
                else
                {
                    btnSuspendResumeInstance.Text = "Suspend";
                }

                btnTerminateInstance.Visible = true;
                //btnDownloadInstance.Visible = true;
                btnSuspendResumeInstance.Visible = true;
                ChkOAll.Visible = true;
                ChkOAll.Checked = false;
                btnTerminateInstance.BackColor = System.Drawing.Color.Empty;
                btnDownloadInstance.BackColor = System.Drawing.Color.Empty;
                btnSuspendResumeInstance.BackColor = System.Drawing.Color.Empty;
            }
            else
            {
                gridViewAll.DataSource = null;
                gridViewAll.DataBind();
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

        private void ClearControls()
        {
            lblServer.Text = "";
            lblAppName.Text = "";
            lblInstanceID.Text = "";
            lblInstanceStatus.Text = "";
            lblCreationTime.Text = "";
            lblServiceNameValue.Text = "";
            lblHostname.Text = "";
            lblSuspendTime.Text = "";
            lblErrorDesc.Text = "";
            txtDetail.Text = "";
            ddlInstanceData.DataSource = null;
            ddlInstanceData.DataBind();
            lblSuspendtext.Visible = false;
            lblSuspendTime.Visible = false;
        }
        #endregion 


    }
}