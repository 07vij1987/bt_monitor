using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;

namespace bt_monitor
{
    public partial class BTMaster : System.Web.UI.MasterPage
    {

        protected void Page_Load(object sender, EventArgs e)
        {

            string connection = System.Configuration.ConfigurationManager.ConnectionStrings["BizTalkMonitor"].ConnectionString;
            string storedProc = System.Configuration.ConfigurationManager.AppSettings["UserAuthorization"];
            string userName = HttpContext.Current.User.Identity.Name.ToString();
            int charcount = userName.IndexOf(@"\");
            DataSet userAuthorization = null;

            userName = userName.Substring(charcount + 1);

            try
            {
                bool useConfig = false;
                if (Convert.ToBoolean(Convert.ToInt32(ConfigurationManager.AppSettings["UseConfig"].ToString())))
                {
                    useConfig = true;
                }
                userAuthorization = bt_helper.dbHelper.UserAccessDetails(connection, storedProc, userName, useConfig);

                if (!IsPostBack)
                {
                    if (userAuthorization.Tables.Count > 1)
                    {
                        if (Session["AppDomain"] == null)
                        {
                            Session["AuthenticBTUser"] = "Yes";
                            Session["BTRole"] = userAuthorization.Tables[1].Rows[0][0].ToString();
                            //Session["BTUSER"] = userAuthorization.Tables[1].Rows[0][1].ToString();
                            Session["BTUSER"] = userName;
                            Session["AppDomain"] = userAuthorization.Tables[1].Rows[0][2].ToString();
                            Session["HostDomain"] = userAuthorization.Tables[1].Rows[0][3].ToString();
                        }

                        int count = 0;

                        foreach (DataRow row in userAuthorization.Tables[0].Rows)
                        {
                            string image = "~/Images/" + row[2];
                           // menuDashBoard.Items.Add(new MenuItem(" " + " | " + row[0].ToString(), row[0].ToString(), image, row[1].ToString() + ".aspx"));
                            count++;
                        }

                        string[] serverNameListKey = ConfigurationManager.AppSettings["serverNameKey"].Split(',');
                        //string[] serverNameListvalue = ConfigurationManager.AppSettings["serverNameValue"].Split(',');
                        //lblServers.Text = serverNameListvalue[0].ToString();

                        Label lblUesrInfoText = (Label)ContentPlaceHolder1.FindControl("lblUesrInfoText");
                        Label lblDatabase = (Label)ContentPlaceHolder1.FindControl("lblDatabase");
                        Label lblBTServers = (Label)ContentPlaceHolder1.FindControl("lblBTServers");
                        Label lblDBServers = (Label)ContentPlaceHolder1.FindControl("lblDBServers");
                        Label lblBTDRServers = (Label)ContentPlaceHolder1.FindControl("lblBTDRServers");
                        Label lblDBDRServers = (Label)ContentPlaceHolder1.FindControl("lblDBDRServers");
                        if (lblUesrInfoText != null)
                        {
                            lblUesrInfoText.Text = "<pre><span style=\"color: gray\">WELCOME, <span style=\"color: green\"><b>" + Session["BTUSER"] + "</b></span></span></pre>";
                            lblDatabase.Text = "<pre><span style=\"color: gray\"><b>" + " BizTalkMgmtDb" + "</b></span></pre>";
                            lblBTServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["BizTalkServers"].ToString() + "</b></span></pre>";
                            lblDBServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["DatabaseServers"].ToString() + "</b></span></pre>";
                            lblBTDRServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["DRServers"].ToString() + "</b></span></pre>";
                            lblDBDRServers.Text = "<pre><span style=\"color: gray\"><b> " + ConfigurationManager.AppSettings["DRDBServers"].ToString() + "</b></span></pre>";
                        }

                    }
                    else
                    {
                        Response.Redirect("ErrorPage.aspx", true);
                       // lblPage.Text = "122";
                    }

                }
            }
            catch (Exception ex)
            {
               lblPage.Text = ex.Message + "\n" + ex.InnerException;
            }
        }

        public static bool IsSessionExpired()
        {
            bool sessionExpired = false;

            if (HttpContext.Current.Session != null)
            {
                if (HttpContext.Current.Session.IsNewSession)
                {
                    string CookieHeaders = HttpContext.Current.Request.Headers["Cookie"];

                    if ((null != CookieHeaders) && (CookieHeaders.IndexOf("ASP.NET_SessionId") >= 0))
                    {
                        // IsNewSession is true, but session cookie exists,so, ASP.NET session is expired
                        sessionExpired = true;
                    }
                }

            }
            return sessionExpired;
        }
    }
}
