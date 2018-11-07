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
    public partial class HostInstances : System.Web.UI.Page
    {
        #region GlobalVariables
        string configurationFile = ConfigurationManager.AppSettings["BTConfigFile"];
        XmlDocument ConfigFile = new XmlDocument();
        ArrayList selectedHostInstances;
        #endregion
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Label lblPage = this.Master.FindControl("lblPage") as Label;
            lblPage.Text = "BizTalk Monitor |  Host Instances";

            if (Session["AuthenticBTUser"] != null)
            {
                if (Session["BTRole"].Equals("ADMIN") || Session["BTRole"].Equals("USER"))
                {
                    
                    ConfigFile.Load(Server.MapPath(configurationFile));
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

        protected void btnHostinstances_Click(object sender, EventArgs e)
        {
            try
            {
                LoadGrid();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }

        private void ReturnSelectedHostInstanceIDList()
        {
            selectedHostInstances = new ArrayList();
            foreach (GridViewRow row in grdViewHostInstancesMain.Rows)
            {
                CheckBox chkBoxRows = (CheckBox)row.FindControl("chkDelete");

                if (chkBoxRows.Checked)
                {
                    selectedHostInstances.Add(row.Cells[1].Text);
                }
            }
        }

        protected void btnStart_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedHostInstanceIDList();

                BizTalk_Monitor_Helper.MonitorHelper.StartHostInstances(selectedHostInstances);

                ResetGlobalVariables();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
            finally
            {
                LoadGrid();
            }
        }

        protected void btnRestart_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedHostInstanceIDList();
                
                BizTalk_Monitor_Helper.MonitorHelper.StopHostInstances(selectedHostInstances);
                BizTalk_Monitor_Helper.MonitorHelper.StartHostInstances(selectedHostInstances);
                
                ResetGlobalVariables();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
            finally
            {
                LoadGrid();
            }
        }

        protected void btnStop_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedHostInstanceIDList();

                BizTalk_Monitor_Helper.MonitorHelper.StopHostInstances(selectedHostInstances);
                ResetGlobalVariables();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
            finally
            {
                LoadGrid();
            }
        }

        protected void btnEnable_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedHostInstanceIDList();

                foreach (string instanceName in selectedHostInstances)
                {
                    BizTalk_Monitor_Helper.MonitorHelper.EnableHostInstances(instanceName);
                }

                ResetGlobalVariables();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
            finally
            {
                LoadGrid();
            }
        }

        protected void btnDisable_Click(object sender, EventArgs e)
        {
            try
            {
                ReturnSelectedHostInstanceIDList();

                foreach (string instanceName in selectedHostInstances)
                {
                    BizTalk_Monitor_Helper.MonitorHelper.DisableHostInstances(instanceName);
                }

                ResetGlobalVariables();
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
            finally 
            {
                LoadGrid();
            }
        }

        protected void grdViewHostInstancesMain_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes.Add("onmouseover", "NoCheckMouseEvents(this, event)");
                e.Row.Attributes.Add("onmouseout", "NoCheckMouseEvents(this, event)");

                CheckBox chk = (CheckBox)e.Row.Cells[5].Controls[0]; 


                //if (chk.Checked)
                //    e.Row.Cells[5].BackColor = System.Drawing.Color.Red;


            }
        }

        protected void grdViewHostInstancesMain_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                chkAll.Checked = false;
                BindGrdViewMain(e.SortExpression, GetMainSortDirection(e.SortExpression));
            }
            catch (Exception ex)
            {
                DisplayWebMessage(ex);
            }
        }
        
        private void ResetGlobalVariables()
        {
            selectedHostInstances = null;
            grdViewHostInstancesMain.DataSource = null;
        }

        private void LoadGrid()
        {
            DataTable hostTable = BizTalk_Monitor_Helper.MonitorHelper.HostInstancesWMI();
            ViewState["HostInstanceTable"] = hostTable;
            grdViewHostInstancesMain.DataSource = hostTable;
            grdViewHostInstancesMain.DataBind();

            grdViewHostInstancesMain.UseAccessibleHeader = true;
            grdViewHostInstancesMain.HeaderRow.TableSection = TableRowSection.TableHeader;

            btnHostinstances.Visible = false;
            chkAll.Visible = true;
            chkAll.Checked = false;
            btnDisable.Visible = true;
            btnEnable.Visible = true;
            btnStart.Visible = true;
            btnRestart.Visible = true;
            btnStop.Visible = true;
            btnDisable.Enabled = false;
            btnEnable.Enabled = false;
            btnStart.Enabled = false;
            btnStop.Enabled = false;
            btnRestart.Enabled = false;
        }

        private void BindGrdViewMain(string sortExp, string sortDir)
        {
            DataTable hostTable = (DataTable)ViewState["HostInstanceTable"];
                //BizTalk_Monitor_Helper.MonitorHelper.HostInstancesWMI();

            if (hostTable.Rows.Count > 0)
            {
                DataView myDataView = new DataView();
                myDataView = hostTable.DefaultView;

                if (!string.IsNullOrEmpty(sortExp))
                {
                    myDataView.Sort = string.Format("{0} {1}", sortExp, sortDir);
                }

                grdViewHostInstancesMain.DataSource = myDataView;
                grdViewHostInstancesMain.DataBind();
            }
            else
            {
                grdViewHostInstancesMain.DataSource = null;
                grdViewHostInstancesMain.DataBind();
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

        private void DisplayWebMessage(Exception ex)
        {
            string errorLogFile = ConfigurationManager.AppSettings["ErrorLogs"];
            string logFile = HttpContext.Current.Server.MapPath(errorLogFile);
            BizTalk_Monitor_Helper.MonitorHelper.DisplayMessageLogError(ex, logFile);

            lblErrorMask.Text = "<pre><span style=\"color: gray\"><b>" + " Error while processing the request, Please check with support." + "</b></span></pre>";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Error", "javascript:ShowErrorMask()", true);
        }

        
    }
}