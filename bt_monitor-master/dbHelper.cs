using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Management;
using System.Reflection;
using System.Text;
using System.Xml;
using System.Linq;
using Microsoft.BizTalk.Operations;
using Microsoft.BizTalk.Message.Interop;
using Microsoft.BizTalk.ExplorerOM;
namespace bt_helper
{
    public class dbHelper
    {
        static int commandTimeOut = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["CommandTimeout"].ToString());

        public static string GetSplittedMessageBoxNames(string serverName)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MessageBox"].ConnectionString;
            StringBuilder msgBoxList = new StringBuilder();
            connectionString = String.Format(connectionString, serverName);

            string command = "SELECT [NAME] FROM sys.databases WHERE [Name] LIKE 'BizTalkMsgBoxDb%'";
            DataTable msgBoxNames = ExecuteDataBaseQuery(connectionString, command).Tables[0];

            foreach (DataRow dr in msgBoxNames.Rows)
            {
                msgBoxList.Append(dr[0].ToString() + ",");
            }

            return msgBoxList.ToString().Substring(0, msgBoxList.ToString().Length - 1);
        }

        public static DataSet ExecuteDataBaseQuery(string connectionString, string strCommand)
        {
            DataSet dsDb = null;
            SqlConnection thisConnection = null;

            try
            {
                thisConnection = new SqlConnection(connectionString);
                thisConnection.Open();
                SqlCommand thisCommand = new SqlCommand(strCommand, thisConnection);
                thisCommand.CommandTimeout = commandTimeOut;

                SqlDataAdapter daAdapter = new SqlDataAdapter(thisCommand);
                dsDb = new DataSet();
                daAdapter.Fill(dsDb);

            }
            catch (Exception ex)
            {
                throw ex;

            }
            finally
            {
                thisConnection.Close();

            }

            return dsDb;


        }

        /// <summary>
        /// Performs retreival on MessageBox
        /// </summary>
        /// <param name="serverName">BizTalk SQL Server</param>
        /// <param name="sqlQuery">Select query</param>
        /// <returns>Data table</returns>
        public static DataTable ExecuteMsgBoxQuery(string serverName, string sqlQuery)
        {
            DataTable dt = new DataTable();
            SqlConnection sqlConnection = null;
            SqlDataAdapter sqlAdaptor = null;

            try
            {
                sqlConnection = GetSqlConnection(serverName, "BizTalkMsgBoxDb");
                sqlAdaptor = new SqlDataAdapter(sqlQuery, sqlConnection);
                sqlAdaptor.SelectCommand.CommandTimeout = commandTimeOut;
                sqlAdaptor.Fill(dt);
            }
            catch (Exception excption)
            {
                throw excption;
            }
            finally
            {
                sqlAdaptor = null;
                if (sqlConnection != null)
                {
                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }
            }
            return dt;
        }

        public static DataTable ExecuteMsgBoxQuery(string serverName, string sqlQuery, string[] splitMsgBox)
        {
            DataTable dt;
            DataTable dTnew = new DataTable();
            DataSet ds = new DataSet();
            SqlConnection sqlConnection = null;
            SqlDataAdapter sqlAdaptor = null;

            foreach (string msgBox in splitMsgBox)
            {
                dt = new DataTable(msgBox);
                try
                {
                    sqlConnection = GetSqlConnection(serverName, msgBox);
                    sqlAdaptor = new SqlDataAdapter(sqlQuery, sqlConnection);
                    sqlAdaptor.SelectCommand.CommandTimeout = commandTimeOut;
                    sqlAdaptor.Fill(dt);
                    ds.Tables.Add(dt);
                }
                catch (Exception excption)
                {
                    throw excption;
                }
                finally
                {
                    sqlAdaptor = null;
                    if (sqlConnection != null)
                    {
                        if (sqlConnection.State == ConnectionState.Open)
                            sqlConnection.Close();
                    }
                }
            }
            return dTnew;
        }

        /// <summary>
        /// Performs retreival on Management DB
        /// </summary>
        /// <param name="serverName">BizTalk SQL Server</param>
        /// <param name="sqlQuery">Select query</param>
        /// <returns>Data table</returns>
        public static DataTable ExecuteMgmtQuery(string serverName, string sqlQuery)
        {
            DataTable dt = new DataTable();
            SqlConnection sqlConnection = null;
            SqlDataAdapter sqlAdaptor = null;

            try
            {
                sqlConnection = GetSqlConnection(serverName, "BizTalkMgmtDb");
                sqlAdaptor = new SqlDataAdapter(sqlQuery, sqlConnection);
                sqlAdaptor.SelectCommand.CommandTimeout = commandTimeOut;
                sqlAdaptor.Fill(dt);
            }
            catch (Exception excption)
            {
                throw excption;
            }
            finally
            {
                sqlAdaptor = null;
                if (sqlConnection != null)
                {
                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }
            }
            return dt;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="serverName"></param>
        /// <param name="sqlQuery"></param>
        /// <returns></returns>
        public static DataSet ExecuteMgmtQueryDataSet(string serverName, string sqlQuery)
        {
            DataSet dt = new DataSet();
            SqlConnection sqlConnection = null;
            SqlDataAdapter sqlAdaptor = null;

            try
            {
                sqlConnection = GetSqlConnection(serverName, "BizTalkMgmtDb");
                sqlAdaptor = new SqlDataAdapter(sqlQuery, sqlConnection);
                sqlAdaptor.SelectCommand.CommandTimeout = commandTimeOut;
                sqlAdaptor.Fill(dt);
            }
            catch (Exception excption)
            {
                throw excption;
            }
            finally
            {
                sqlAdaptor = null;
                if (sqlConnection != null)
                {
                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }
            }
            return dt;
        }

        /// <summary>
        /// Establish and opens SQL connection
        /// </summary>
        /// <param name="ServerName">SQL server</param>
        /// <param name="DatabaseName">Database name</param>
        /// <returns>SQL connect</returns>
        public static SqlConnection GetSqlConnection(string ServerName, string DatabaseName)
        {
            try
            {
                if (!string.IsNullOrEmpty(ServerName))
                {
                    string ConncString = "Server=" + ServerName + ";Database=" + DatabaseName + ";Trusted_Connection=True;";
                    SqlConnection Connec = new SqlConnection(ConncString);
                    Connec.Open();
                    return Connec;
                }
                else
                {
                    return null;
                }

            }
            catch (SqlException ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Resumes instance using BizTalk operations
        /// </summary>
        /// <param name="instanceId">instance GUUID</param>
        /// <param name="serverName">BizTalk SQL server</param>
        public static void ResumeInstance(string serverName, ArrayList instanceIDList)
        {
            BizTalkOperations operations = null;

            try
            {
                operations = new BizTalkOperations(serverName, "BizTalkMgmtDb");

                foreach (string instanceID in instanceIDList)
                {
                    Guid tempInstanceId = new Guid(instanceID);
                    operations.ResumeInstance(tempInstanceId);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (operations != null)
                    operations.Dispose();
            }
        }

        /// <summary>
        /// Suspend instance using BizTalk operations
        /// </summary>
        /// <param name="instanceId"></param>
        /// <param name="serverName"></param>
        public static void SuspendInstance(string serverName, ArrayList instanceIDList)
        {
            BizTalkOperations operations = null;
            try
            {
                operations = new BizTalkOperations(serverName, "BizTalkMgmtDb");

                foreach (string instanceID in instanceIDList)
                {
                    Guid tempInstanceId = new Guid(instanceID);
                    operations.SuspendInstance(tempInstanceId);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (operations != null)
                    operations.Dispose();
            }
        }

        /// <summary>
        /// Terminates instance using BizTalk operations
        /// </summary>
        /// <param name="instanceId">instance GUUID</param>
        /// <param name="serverName">BizTalk SQL server</param>
        public static void TerminateInstance(string serverName, ArrayList instanceIDList)
        {
            BizTalkOperations operations = null;
            try
            {
                operations = new BizTalkOperations(serverName, "BizTalkMgmtDb");

                foreach (string instanceID in instanceIDList)
                {
                    Guid tempInstanceId = new Guid(instanceID);
                    operations.TerminateInstance(tempInstanceId);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (operations != null)
                    operations.Dispose();
            }
        }

        public static DataTable GetMessageConetxt(string serverName, string instanceId, string msgInstanceId, out string error)
        {
            DataTable contextProp = new DataTable();

            contextProp.Columns.Add("Name");
            contextProp.Columns.Add("PropertyValue");
            contextProp.Columns.Add("Type");
            contextProp.Columns.Add("Namespace");

            Guid instanceUid = new Guid(instanceId);
            Guid msgId = new Guid(msgInstanceId);

            try
            {
                using (BizTalkOperations operations = new BizTalkOperations(ConfigurationManager.AppSettings["serverNameKey"].ToString(), "BizTalkMgmtDb"))
                {
                    IBaseMessageContext msgContext = operations.GetMessage(msgId, instanceUid).Context;

                    for (int i = 0; i < msgContext.CountProperties; ++i)
                    {
                        DataRow newRow = contextProp.NewRow();

                        string propName;
                        string propNamespace;

                        object propValue = msgContext.ReadAt(i, out propName, out propNamespace);
                        bool isPromoted = msgContext.IsPromoted(propName, propNamespace);

                        newRow["Name"] = propName;
                        newRow["PropertyValue"] = propValue.ToString();

                        if (isPromoted)
                            newRow["Type"] = "Promoted";
                        else
                            newRow["Type"] = "Not Promoted";

                        newRow["Namespace"] = propNamespace;

                        contextProp.Rows.Add(newRow);

                    }
                    error = string.Empty;
                }
            }
            catch (Exception exOp)
            {
                error = "Failed to get context properties for message with id " + msgInstanceId.ToString() + " from database. " + exOp.Message;
            }

            return contextProp;
        }

        public static XmlDocument GetMessageFromBtsMsgBox(string[] messageDetails)
        {
            XmlDocument xmlDoc = new XmlDocument();
            string pipelineAssemblyPath = ConfigurationManager.AppSettings["PipelineAssemblyPath"].ToString();
            string compressionType = ConfigurationManager.AppSettings["CompressionType"].ToString();
            string message = string.Empty;

            try
            {
                DataTable imgPartDT = ExecuteMsgBoxQuery(messageDetails[0].ToString(), messageDetails[1].ToString());
                SqlBinary binData = new SqlBinary((byte[])imgPartDT.Rows[0]["imgPart"]);
                MemoryStream stream = new MemoryStream(binData.Value);
                Assembly pipelineAssembly = Assembly.LoadFrom(pipelineAssemblyPath);
                Type compressionStreamsType = pipelineAssembly.GetType(compressionType, true);
                StreamReader st = new StreamReader((Stream)compressionStreamsType.InvokeMember("Decompress", BindingFlags.Public | BindingFlags.InvokeMethod | BindingFlags.Static, null, null, new object[] { (object)stream }));
                message = st.ReadToEnd();

                if (message != null)
                {
                    xmlDoc.LoadXml(message);
                }
            }
            catch (Exception exOp)
            {
                string strErrorMsg = string.Empty;
                if (message != null && !string.IsNullOrEmpty(message))
                {
                    strErrorMsg = "<?xml version='1.0' encoding='utf-8'?><TextMessage><Information>" + "Failed to get xml message with id " + messageDetails[2].ToString() + " from database</Information></TextMessage>";
                    xmlDoc.LoadXml(strErrorMsg);
                    XmlElement elem = xmlDoc.CreateElement("Message");
                    XmlText text = xmlDoc.CreateTextNode(message);
                    xmlDoc.DocumentElement.AppendChild(elem);
                    xmlDoc.DocumentElement.LastChild.AppendChild(text);
                    return xmlDoc;
                }
                else
                {
                    strErrorMsg = "<?xml version='1.0' encoding='utf-8'?><Error><ErrorMessage>" + "Failed to get message with id " + messageDetails[2].ToString() + " from database</ErrorMessage><InnerException>" + exOp.Message + "</InnerException></Error>";
                    xmlDoc.LoadXml(strErrorMsg);
                    return xmlDoc;
                }

            }

            return xmlDoc;
        }

        public static XmlDocument GetMessageFromBtsMsgBoxSP(string[] messageDetails)
        {
            XmlDocument xmlDoc = new XmlDocument();

            try
            {
                string pipelineAssemblyPath = ConfigurationManager.AppSettings["PipelineAssemblyPath"].ToString();
                string compressionType = ConfigurationManager.AppSettings["CompressionType"].ToString();
                SqlConnection con = new SqlConnection("Data Source=" + messageDetails[0].ToString() + ";Initial Catalog=" + "BizTalkMsgBoxDb" + ";Integrated Security=True");

                string message = "";

                try
                {
                    SqlCommand cmd = new SqlCommand();
                    SqlDataReader reader;

                    //Build execution of stored procedure bts_GetTrackedMessageParts

                    cmd.CommandText = "bts_GetTrackedMessageParts";
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlParameter guidParameter = new SqlParameter("@uidMsgID", SqlDbType.UniqueIdentifier);
                    guidParameter.Value = new Guid(messageDetails[2]);
                    cmd.Parameters.Add(guidParameter);
                    cmd.Connection = con;
                    con.Open();
                    reader = cmd.ExecuteReader();

                    //Get the reader to retrieve the data

                    while (reader.Read())
                    {
                        SqlBinary binData = new SqlBinary((byte[])reader["imgPart"]);
                        MemoryStream stream = new MemoryStream(binData.Value);
                        Assembly pipelineAssembly = Assembly.LoadFrom(pipelineAssemblyPath);
                        Type compressionStreamsType = pipelineAssembly.GetType(compressionType, true);
                        StreamReader st = new StreamReader((Stream)compressionStreamsType.InvokeMember("Decompress", BindingFlags.Public | BindingFlags.InvokeMethod | BindingFlags.Static, null, null, new object[] { (object)stream }));
                        message = st.ReadToEnd();
                    }
                }
                finally
                {
                    con.Close();
                }

                if (!string.IsNullOrEmpty(message))
                {
                    xmlDoc.LoadXml(message);
                }

                return xmlDoc;
            }
            catch (Exception exSQL)
            {
                string strErrorMsg = string.Empty;
                strErrorMsg = "<?xml version='1.0' encoding='utf-8'?><ErrorMessage>" + "Failed to get message with id " + messageDetails[2].ToString() + " from tracking database: " + exSQL.Message + "</ErrorMessage>";
                xmlDoc.LoadXml(strErrorMsg);
                return xmlDoc;
            }
        }

        public static XmlDocument GetPipelineStages(string[] messageDetails)
        {
            XmlDocument xmlDoc = new XmlDocument();

            try
            {
                DataTable imgPartDT = ExecuteMgmtQuery(messageDetails[0].ToString(), messageDetails[1].ToString());

                string message = string.Empty;

                SqlBinary binData = new SqlBinary((byte[])imgPartDT.Rows[0]["imgPart"]);
                MemoryStream stream = new MemoryStream(binData.Value);


                if (message != null)
                {
                    xmlDoc.LoadXml(message);
                }
            }
            catch (Exception exOp)
            {
                string strErrorMsg = string.Empty;

                strErrorMsg = "<?xml version='1.0' encoding='utf-8'?><Error><ErrorMessage>" + "Failed to get message with id " + messageDetails[2].ToString() + " from database</ErrorMessage><InnerException>" + exOp.Message + "</InnerException></Error>";

                xmlDoc.LoadXml(strErrorMsg);
                return xmlDoc;
            }

            return xmlDoc;
        }

        public static List<KeyValuePair<string, string>> GetComboDataSource(string[] key, string[] value)
        {
            List<KeyValuePair<string, string>> combodataSource = new List<KeyValuePair<string, string>>();

            for (int i = 0; i < key.Length; i++)
            {
                combodataSource.Add(new KeyValuePair<string, string>(key[i].ToString(), value[i].ToString()));
            }

            return combodataSource;
        }

        public static List<KeyValuePair<string, string>> GetDropDownDataSource(DataTable dt)
        {
            List<KeyValuePair<string, string>> combodataSource = new List<KeyValuePair<string, string>>();

            combodataSource.Add(new KeyValuePair<string, string>("Select Message Type", "Select Message Type"));

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                combodataSource.Add(new KeyValuePair<string, string>(dt.Rows[i][1].ToString(), dt.Rows[i][0].ToString()));
            }

            return combodataSource;
        }

        /// <summary>
        /// Retreives host instances information using WMI
        /// </summary>
        /// <returns>Data table</returns>
        public static DataTable HostInstancesWMI()
        {
            DataTable hostInstances = new DataTable();

            hostInstances.Columns.Add("Host Name");
            hostInstances.Columns.Add("Host Type");
            hostInstances.Columns.Add("Server Name");
            hostInstances.Columns.Add("Status");
            hostInstances.Columns.Add("Disabled", System.Type.GetType("System.Boolean"));

            DataRow newRow;

            try
            {
                ManagementObjectSearcher searchObject = GetmanagementObject("Select * from MSBTS_HostInstance");

                foreach (ManagementObject inst in searchObject.Get())
                {
                    newRow = hostInstances.NewRow();

                    newRow["Host Name"] = inst["HostName"].ToString();

                    string hostType = string.Empty;
                    hostType = inst["HostType"].ToString();

                    if (hostType.Equals("1"))
                    {
                        newRow["Host Type"] = "In-Process";
                    }
                    else
                    {
                        newRow["Host Type"] = "Isolated";
                    }

                    int index = inst["Name"].ToString().LastIndexOf(" ");
                    int length = inst["Name"].ToString().Length;

                    newRow["Server Name"] = inst["RunningServer"].ToString();

                    string instanceStatus = string.Empty;

                    instanceStatus = inst["ServiceState"].ToString();

                    switch (instanceStatus)
                    {
                        case "1":
                            newRow["Status"] = "Stopped";
                            break;
                        case "2":
                            newRow["Status"] = "Start pending";
                            break;
                        case "3":
                            newRow["Status"] = "Stop pending";
                            break;
                        case "4":
                            newRow["Status"] = "Running";
                            break;
                        case "5":
                            newRow["Status"] = "Continue pending";
                            break;
                        case "6":
                            newRow["Status"] = "Pause pending";
                            break;
                        case "7":
                            newRow["Status"] = "Paused";
                            break;
                        case "8":
                            if (hostType.Equals("1"))
                                newRow["Status"] = "Unknown";
                            else
                                newRow["Status"] = "Not Applicable";
                            break;
                    }

                    if (inst["IsDisabled"].ToString().Equals("False"))
                    {
                        newRow["Disabled"] = false;
                    }
                    else
                    {
                        newRow["Disabled"] = true;
                    }

                    hostInstances.Rows.Add(newRow);
                }
            }
            catch (Exception excep)
            {
                throw excep;
            }

            return hostInstances;

        }

        /// <summary>
        /// Creates and initailise WMI MOS
        /// </summary>
        /// <param name="wmiQuery">WMI SQL query</param>
        /// <returns>Management Object Searcher</returns>
        private static ManagementObjectSearcher GetmanagementObject(string wmiQuery)
        {
            EnumerationOptions enumOptions = new EnumerationOptions();
            enumOptions.ReturnImmediately = false;

            ConnectionOptions connOpt = new ConnectionOptions();
            connOpt.Username = ConfigurationManager.AppSettings["Username"].ToString();
            connOpt.Password = ConfigurationManager.AppSettings["Password"].ToString();

            string wmiServer = ConfigurationManager.AppSettings["wmiServer"].ToString();

            ManagementScope mScope = new ManagementScope("\\\\" + wmiServer + "\\root\\MicrosoftBizTalkServer", connOpt);
            //ManagementScope mScope = new ManagementScope("\\\\"+wmiServer+"\\root\\MicrosoftBizTalkServer");
            ObjectQuery query = new ObjectQuery(wmiQuery);
            ManagementObjectSearcher searchObject = new ManagementObjectSearcher(mScope, query, enumOptions);

            return searchObject;

        }

        public static void EnableHostInstances(string hostInstanceName)
        {
            EnableDisableHostInstance("Enable", hostInstanceName);
        }

        public static void DisableHostInstances(string hostInstanceName)
        {
            EnableDisableHostInstance("Disable", hostInstanceName);
        }

        public static void StartHostInstances(ArrayList hostInstanceList)
        {
            ManageHostInstance("Start", hostInstanceList);
        }

        public static void StopHostInstances(ArrayList hostInstanceList)
        {
            ManageHostInstance("Stop", hostInstanceList);
        }

        private static void ManageHostInstance(string action, ArrayList hostInstanceList)
        {
            try
            {
                string csHostinstances = string.Empty;
                csHostinstances = ReturnCommaSeparatedWMIString(hostInstanceList);

                ManagementObjectSearcher searchObject = GetmanagementObject("Select * from MSBTS_HostInstance where HostType=1 AND " + csHostinstances);

                foreach (ManagementObject inst in searchObject.Get())
                {
                    inst.InvokeMethod(action, null);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static void EnableDisableHostInstance(string action, string hostInstanceName)
        {
            try
            {
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataSet UserAccessDetails(string connection, string storedProcedure, string userID, bool isConfig)
        {
            if (!isConfig)
            {
                SqlConnection Connection = new SqlConnection(connection);

                SqlParameter param = new SqlParameter("@UserId", SqlDbType.NVarChar, 50);
                param.Direction = ParameterDirection.Input;
                param.Value = userID;

                SqlDataAdapter adapter = new SqlDataAdapter(storedProcedure, connection);
                adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                adapter.SelectCommand.Parameters.Add(param);

                DataSet ds = new DataSet();
                try
                {
                    Connection.Open();
                    adapter.Fill(ds);
                    return ds;
                }

                catch (Exception ex)
                {
                    throw ex;
                }

                finally
                {
                    adapter = null;
                    Connection.Close();
                }
            }
            else
            {
                bool authUser = false;
                DataSet configDs = new DataSet();
                DataTable dtUrls = new DataTable();
                DataTable dtUser = new DataTable();

                dtUser.Columns.Add("Role");
                dtUser.Columns.Add("UserName");
                dtUser.Columns.Add("AppDomain");
                dtUser.Columns.Add("hostDomain");

                dtUrls.Columns.Add("MenuItems");
                dtUrls.Columns.Add("MenuURLs");
                dtUrls.Columns.Add("imgURLs");


                string[] menuitems = ConfigurationManager.AppSettings["MenuItems"].ToString().Split(',');
                string[] menuURL = ConfigurationManager.AppSettings["MenuURLS"].ToString().Split(',');
                string[] imgURL = ConfigurationManager.AppSettings["ImageURLS"].ToString().Split(',');
                string[] bpmAuthorisedUsers = ConfigurationManager.AppSettings["FIL.RET.BPM"].ToString().Split(',');
                string[] dcAuthorisedUsers = ConfigurationManager.AppSettings["FIL.DC"].ToString().Split(',');
                string[] AuthorisedAdmins = ConfigurationManager.AppSettings["Admins"].ToString().Split(',');

                DataRow newUserRow = dtUser.NewRow();
                DataRow newUrlRow;

                if (bpmAuthorisedUsers.Contains(userID))
                {
                    newUserRow["AppDomain"] = "FIL.RET.BPM";
                    newUserRow["hostDomain"] = "FIL_BPM";
                    newUserRow["UserName"] = " ";
                    authUser = true;
                }
                else if (dcAuthorisedUsers.Contains(userID))
                {
                    newUserRow["AppDomain"] = "FIL.DC";
                    newUserRow["hostDomain"] = "FIL_DC";
                    newUserRow["UserName"] = " ";
                    authUser = true;
                }

                if (AuthorisedAdmins.Contains(userID))
                {
                    authUser = true;
                    newUserRow["Role"] = "ADMIN";
                    for (int i = 0; i < menuitems.Length; i++)
                    {
                        newUrlRow = dtUrls.NewRow();
                        newUrlRow["MenuItems"] = menuitems[i].ToString();
                        newUrlRow["MenuURLs"] = menuURL[i].ToString();
                        newUrlRow["imgURLs"] = imgURL[i].ToString();
                        dtUrls.Rows.Add(newUrlRow);
                    }
                }
                else
                {
                    if (authUser)
                    {
                        newUserRow["Role"] = "USER";
                        for (int i = 0; i < menuitems.Length - 1; i++)
                        {
                            newUrlRow = dtUrls.NewRow();
                            newUrlRow["MenuItems"] = menuitems[i].ToString();
                            newUrlRow["MenuURLs"] = menuURL[i].ToString();
                            newUrlRow["imgURLs"] = imgURL[i].ToString();
                            dtUrls.Rows.Add(newUrlRow);
                        }
                    }
                }

                if (authUser)
                {
                    dtUser.Rows.Add(newUserRow);

                    configDs.Tables.Add(dtUrls);
                    configDs.Tables.Add(dtUser);
                }

                return configDs;
            }
        }

        public static int ExecuteNonQuery(string serverName, string sqlQuery)
        {
            int rowsEffected = 0;
            SqlConnection sqlConnection = null;
            try
            {
                sqlConnection = GetSqlConnection(serverName, "BizTalkMgmtDb");

                using (SqlCommand command = sqlConnection.CreateCommand())
                {
                    command.CommandText = sqlQuery;
                    rowsEffected = command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (sqlConnection != null)
                {
                    if (sqlConnection.State == ConnectionState.Open)
                        sqlConnection.Close();
                }
            }

            return rowsEffected;
        }

        public static void DisplayMessageLogError(Exception ex, string errorLogFile)
        {
            StreamWriter errorText = new StreamWriter(errorLogFile, true);
            errorText.WriteLine();
            errorText.WriteLine("================================================================================================================");
            errorText.WriteLine(System.DateTime.Now);
            errorText.WriteLine("________________________________________________________________________________________________________________");
            errorText.WriteLine("Exception Message : ");
            errorText.WriteLine(ex.Message);
            errorText.WriteLine();
            errorText.WriteLine("________________________________________________________________________________________________________________");
            errorText.WriteLine("Exception Source : ");
            errorText.WriteLine(ex.Source);
            errorText.WriteLine();
            errorText.WriteLine("________________________________________________________________________________________________________________");
            errorText.WriteLine("Exception Stack Trace : ");
            errorText.WriteLine(ex.StackTrace);
            errorText.WriteLine();
            errorText.WriteLine("================================================================================================================");
            errorText.Close();
        }

        public static string ReadFilters(string filters)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<pre>");
            XmlReader xmlReader = XmlReader.Create(new StringReader(filters));
            int groupCount = 0;
            while (xmlReader.Read())
            {
                if ((xmlReader.NodeType == XmlNodeType.Element) && (xmlReader.LocalName.Equals("Group")))
                {
                    groupCount = groupCount + 1;

                    sb.Append(ReturnANDedFilters(filters, groupCount));
                    sb.Append("\nOR\n\n");
                }
            }

            sb.Remove((sb.ToString().Length - 4), 4);
            sb.Append("</pre>");
            return sb.ToString();
        }

        public static string ReturnANDedFilters(string innerXML, int count)
        {
            StringBuilder sb = new StringBuilder();
            XmlReader xmlReader = XmlReader.Create(new StringReader(innerXML));

            int nodeCount = 0;

            while (xmlReader.Read())
            {
                if ((xmlReader.NodeType == XmlNodeType.Element) && (xmlReader.LocalName.Equals("Group")))
                {
                    nodeCount = nodeCount + 1;
                }

                if (nodeCount == count)
                {
                    if ((xmlReader.NodeType == XmlNodeType.Element) && (xmlReader.LocalName.Equals("Statement")))
                    {

                        if (xmlReader.HasAttributes)
                        {
                            while (xmlReader.MoveToNextAttribute())
                            {
                                switch (xmlReader.LocalName)
                                {
                                    case "Property":
                                        sb.Append(xmlReader.Value);
                                        sb.Append(" ");
                                        break;
                                    case "Operator":
                                        sb.Append(ReturnOperator(xmlReader.Value));
                                        sb.Append(" ");
                                        break;
                                    case "Value":
                                        sb.Append(xmlReader.Value);
                                        sb.Append(" ");
                                        break;
                                }
                            }
                        }
                        sb.Append("\nAND\n");
                    }
                }
            }

            return sb.ToString().Substring(0, (sb.ToString().Length - 4));

        }

        public static string ReturnOperator(string value)
        {
            string operatorName = "==";

            switch (value)
            {
                case "0":
                    operatorName = "==";
                    break;
                case "1":
                    operatorName = "<";
                    break;
                case "2":
                    operatorName = "<=";
                    break;
                case "3":
                    operatorName = ">";
                    break;
                case "4":
                    operatorName = ">=";
                    break;
                case "5":
                    operatorName = "!=";
                    break;
                case "6":
                    operatorName = "Exists";
                    break;
            }

            return operatorName;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="message"></param>
        /// <returns></returns>
        public static string RichTextBoxFunctionality(string message)
        {
            StringBuilder sb = new StringBuilder();
            string outString = string.Empty;
            int count = 0;
            bool isEndElement = false;
            bool isEmptyElement = false;

            sb.Append("<pre>");
            XmlReader xmlReader = XmlReader.Create(new StringReader(message));

            while (xmlReader.Read())
            {
                switch (xmlReader.NodeType)
                {
                    case XmlNodeType.Element:
                        //The node is an element.
                        if (count > 0)
                        {
                            sb.Append("\n");
                        }
                        sb.Append("<span style=\"color: green\">");

                        if (xmlReader.IsEmptyElement)
                        {
                            sb.Append("&lt;");
                            sb.Append(xmlReader.Name);

                            if (xmlReader.HasAttributes)
                            {
                                while (xmlReader.MoveToNextAttribute())
                                {
                                    sb.Append(" ");
                                    sb.Append("<span style=\"color: gray\">");
                                    sb.Append(xmlReader.Name);
                                    sb.Append("</span>");
                                    sb.Append("<span style=\"color: red\">");
                                    sb.Append("=\"");
                                    sb.Append(xmlReader.Value);
                                    sb.Append("\"");
                                    sb.Append("</span>");
                                }
                            }

                            sb.Append("/&gt;");
                            isEmptyElement = true;
                        }
                        else
                        {
                            sb.Append("&lt;");
                            sb.Append(xmlReader.Name);

                            if (xmlReader.HasAttributes)
                            {
                                while (xmlReader.MoveToNextAttribute())
                                {
                                    sb.Append(" ");
                                    sb.Append("<span style=\"color: gray\">");
                                    sb.Append(xmlReader.Name);
                                    sb.Append("</span>");
                                    sb.Append("<span style=\"color: red\">");
                                    sb.Append("=\"");
                                    sb.Append(xmlReader.Value);
                                    sb.Append("\"");
                                    sb.Append("</span>");
                                }
                            }

                            sb.Append("&gt;");
                            isEmptyElement = false;
                        }

                        sb.Append("</span>");
                        count = count + 1;
                        isEndElement = false;

                        break;
                    case XmlNodeType.CDATA:
                        sb.Append("<span style=\"color: orange\">");
                        sb.Append("\n");
                        sb.Append("&lt;![CDATA[");
                        sb.Append(HandleCDATA(xmlReader.Value));
                        sb.Append("]]&gt;");
                        sb.Append("\n");
                        sb.Append("</span>");
                        break;
                    case XmlNodeType.Text:
                        //Display the text in each element.
                        sb.Append("<span style=\"color: black\">");
                        sb.Append("<b>");
                        sb.Append(RemoveAmpersand(xmlReader.Value));
                        sb.Append("</b>");
                        sb.Append("</span>");
                        isEndElement = false;
                        isEmptyElement = false;

                        break;
                    case XmlNodeType.EndElement:
                        if (isEndElement || isEmptyElement)
                        {
                            sb.Append("\n");
                        }

                        sb.Append("<span style=\"color: green\">");
                        sb.Append("&lt;/");
                        sb.Append(xmlReader.Name);
                        sb.Append("&gt;");
                        sb.Append("</span>");
                        isEndElement = true;
                        break;
                }
            }
            sb.Append("</pre>");
            xmlReader.Close();
            outString = sb.ToString();
            return outString;
        }

        public static string HandleCDATA(string message)
        {
            StringBuilder sb = new StringBuilder();
            string outString = string.Empty;
            int count = 0;
            bool isEndElement = false;
            bool isEmptyElement = false;

            //sb.Append("<pre>");
            XmlReader xmlReader = XmlReader.Create(new StringReader(message));

            while (xmlReader.Read())
            {
                switch (xmlReader.NodeType)
                {
                    case XmlNodeType.Element:
                        //The node is an element.
                        if (count > 0)
                        {
                            sb.Append("\n");
                        }
                        //sb.Append("<span style=\"color: green\">");

                        if (xmlReader.IsEmptyElement)
                        {
                            sb.Append("&lt;");
                            sb.Append(xmlReader.Name);

                            if (xmlReader.HasAttributes)
                            {
                                while (xmlReader.MoveToNextAttribute())
                                {
                                    sb.Append(" ");
                                    //sb.Append("<span style=\"color: gray\">");
                                    sb.Append(xmlReader.Name);
                                    //sb.Append("</span>");
                                    //sb.Append("<span style=\"color: red\">");
                                    sb.Append("=\"");
                                    sb.Append(xmlReader.Value);
                                    sb.Append("\"");
                                    //sb.Append("</span>");
                                }
                            }
                            sb.Append("/&gt;");
                            isEmptyElement = true;
                        }
                        else
                        {
                            sb.Append("&lt;");
                            sb.Append(xmlReader.Name);

                            if (xmlReader.HasAttributes)
                            {

                                while (xmlReader.MoveToNextAttribute())
                                {
                                    sb.Append(" ");
                                    //sb.Append("<span style=\"color: gray\">");
                                    sb.Append(xmlReader.Name);
                                    //sb.Append("</span>");
                                    //sb.Append("<span style=\"color: red\">");
                                    sb.Append("=\"");
                                    sb.Append(xmlReader.Value);
                                    sb.Append("\"");
                                    //sb.Append("</span>");
                                }
                            }
                            sb.Append("&gt;");
                            isEmptyElement = false;
                        }

                        //sb.Append("</span>");
                        count = count + 1;
                        isEndElement = false;

                        break;
                    case XmlNodeType.Text:
                        //Display the text in each element.
                        sb.Append("<span style=\"color: blue\">");
                        sb.Append("<b>");
                        sb.Append(RemoveAmpersand(xmlReader.Value));
                        sb.Append("</b>");
                        sb.Append("</span>");
                        isEndElement = false;
                        isEmptyElement = false;

                        break;
                    case XmlNodeType.EndElement:
                        if (isEndElement || isEmptyElement)
                        {
                            sb.Append("\n");
                        }

                        //sb.Append("<span style=\"color: green\">");
                        sb.Append("&lt;/");
                        sb.Append(xmlReader.Name);
                        sb.Append("&gt;");
                        //sb.Append("</span>");
                        isEndElement = true;
                        break;
                }
            }
            //sb.Append("</pre>");
            xmlReader.Close();
            outString = sb.ToString();
            return outString;
        }

        public static string RemoveAmpersand(string value)
        {
            string returnStr = string.Empty;
            returnStr = value.Replace("&", "&amp;");

            return returnStr;
        }

        public static string ReturnCommaSeparatedString(ArrayList hostInstanceList)
        {
            StringBuilder sb = new StringBuilder();

            foreach (string hostInstance in hostInstanceList)
            {
                sb.Append("'");
                sb.Append(hostInstance);
                sb.Append("'");
                sb.Append(",");
            }

            return sb.ToString().Substring(0, sb.ToString().Length - 1);
        }

        public static string ReturnCommaSeparatedWMIString(ArrayList hostInstanceList)
        {
            StringBuilder sb = new StringBuilder();

            foreach (string hostInstance in hostInstanceList)
            {
                sb.Append("(");
                sb.Append("HostName = '");
                sb.Append(hostInstance);
                sb.Append("')");
                sb.Append(" OR ");
            }

            return sb.ToString().Substring(0, sb.ToString().Length - 3);
        }

        /// <summary>
        /// Start/Stop/Enlist send port
        /// </summary>
        /// <param name="locationName">Send port name</param>
        /// <param name="server">SQL server where BizTalkMgmtDb is present</param>
        /// <param name="status">1- Enlist, 2- Stop, 2- Start</param>
        public static void ManageSendPortOM(string portName, string server, int status)
        {
            BtsCatalogExplorer catalog = new BtsCatalogExplorer();
            try
            {
                catalog.ConnectionString = "Server=" + server + ";Initial Catalog=BizTalkMgmtDb;Integrated Security=SSPI;";
                SendPort sendport = catalog.SendPorts[portName];

                if (status == 3)
                    sendport.Status = PortStatus.Started;
                else if (status == 2)
                    sendport.Status = PortStatus.Stopped;
                else
                    sendport.Status = PortStatus.Bound;

                catalog.SaveChanges();
            }
            catch (Exception e)
            {
                catalog.DiscardChanges();
                throw e;
            }
            finally
            {
                if (catalog != null) { catalog.Dispose(); }
            }
        }

        /// <summary>
        /// Enable/Disable receive location 
        /// </summary>
        /// <param name="locationName">Receive location name</param>
        /// <param name="portName">Receive port name</param>
        /// <param name="server">SQL server where BizTalkMgmtDb is present</param>
        /// <param name="status">true for enabling, false for disabling</param>
        public static void ManageReceiveLocationOM(string locationName, string portName, string server, bool status)
        {
            BtsCatalogExplorer catalog = new BtsCatalogExplorer();
            try
            {
                catalog.ConnectionString = "Server=" + server + ";Initial Catalog=BizTalkMgmtDb;Integrated Security=SSPI;";

                foreach (ReceivePort receivePort in catalog.ReceivePorts)
                {
                    if (receivePort.Name.Equals(portName))
                    {
                        foreach (ReceiveLocation location in receivePort.ReceiveLocations)
                        {
                            if (location.Name.Equals(locationName))
                            {
                                location.Enable = status;
                                break;
                            }
                        }
                        break;
                    }
                }
                catalog.SaveChanges();
            }
            catch (Exception ex)
            {
                catalog.DiscardChanges();
                throw ex;
            }
            finally
            {
                if (catalog != null) { catalog.Dispose(); }
            }
        }

        /// <summary>
        /// Enable/Disable service window 
        /// </summary>
        /// <param name="locationName">Receive location name</param>
        /// <param name="portName">Receive port name</param>
        /// <param name="server">SQL server where BizTalkMgmtDb is present</param>
        /// <param name="status">true for enabling, false for disabling</param>
        public static void ManageReceiveLocationWindowOM(string locationName, string portName, string server, bool status)
        {
            BtsCatalogExplorer catalog = new BtsCatalogExplorer();
            try
            {
                catalog.ConnectionString = "Server=" + server + ";Initial Catalog=BizTalkMgmtDb;Integrated Security=SSPI;";

                foreach (ReceivePort receivePort in catalog.ReceivePorts)
                {
                    if (receivePort.Name.Equals(portName))
                    {
                        foreach (ReceiveLocation location in receivePort.ReceiveLocations)
                        {
                            if (location.Name.Equals(locationName))
                            {
                                location.ServiceWindowEnabled = status;
                                break;
                            }
                        }
                        break;
                    }
                }
                catalog.SaveChanges();
            }
            catch (Exception ex)
            {
                catalog.DiscardChanges();
                throw ex;
            }
            finally
            {
                if (catalog != null) { catalog.Dispose(); }
            }
        }
    }

}
