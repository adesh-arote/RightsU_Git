using RightsU_HealthCheckup.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Reflection;
using System.ServiceProcess;
using System.Text;

namespace RightsU_HealthCheckup
{
    class System_Machine
    {
        public static string Services(string serviceName)
        {
            try
            {
                ServiceController sc = new ServiceController(serviceName);
                switch (sc.Status)
                {
                    case ServiceControllerStatus.Running:
                        return "Running";
                    case ServiceControllerStatus.Stopped:
                        return "Stopped";
                    case ServiceControllerStatus.Paused:
                        return "Paused";
                    case ServiceControllerStatus.StopPending:
                        return "Stopping";
                    case ServiceControllerStatus.StartPending:
                        return "Starting";
                    default:
                        return "Status Changing";
                }
            }
            catch (Exception ex)
            {
                //return ex.Message;
                return "The specified service does not exist as an installed service.";
            }
        }
        public static List<HardDisk> CPU_Utlization()
        {

            List<HardDisk> lsthardDisks = new List<HardDisk>();
            foreach (System.IO.DriveInfo label in System.IO.DriveInfo.GetDrives())
            {
                
                if (label.IsReady == true)
                {
                    HardDisk objHardDisk = new HardDisk();
                    objHardDisk.DriveName = label.Name;
                    objHardDisk.TotalSize = FileSizeFormatter.FormatSize(label.TotalSize);
                    objHardDisk.AvailableFreeSpace = FileSizeFormatter.FormatSize(label.AvailableFreeSpace);
                    objHardDisk.TotalFreeSpace = FileSizeFormatter.FormatSize(label.TotalSize - label.AvailableFreeSpace);
                    lsthardDisks.Add(objHardDisk);
                }
            }
            return lsthardDisks;
        }
        public static List<App_Details> ApplicationDetails(string AppDetails)
        {
            List<App_Details> lstApp_Details = new List<App_Details>();
            string[] arrAD = AppDetails.Split('|');

            foreach (string AD in arrAD)
            {
                if (Directory.Exists(AD.Split('~')[1]))
                {
                    long size_in_Bytes = DirSize(new DirectoryInfo(AD.Split('~')[1]));
                    double size_in_MegaBytes = (size_in_Bytes / 1024) / 1024;
                    App_Details objAD = new App_Details();
                    objAD.App_Name = AD.Split('~')[0];
                    objAD.App_Path = AD.Split('~')[1];
                    objAD.App_Size = Convert.ToString(size_in_MegaBytes) + "MB";
                    lstApp_Details.Add(objAD);
                }
            }
            return lstApp_Details;
        }
        public static List<T> USP_StoreProcedure<T>(string connectionStringName, string procedureName, int CS_Curr_Count)
        {
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString))
            using (SqlCommand command = new SqlCommand(procedureName, connection))
            {
                SqlDataAdapter adapt = new SqlDataAdapter(command);
                adapt.SelectCommand.CommandType = CommandType.StoredProcedure;
                adapt.SelectCommand.Parameters.Add("@CS_Curr_Count", SqlDbType.Int).Value = CS_Curr_Count;

                DataTable dt = new DataTable();
                adapt.Fill(dt);
                List<T> lst = ConvertDataTable<T>(dt);
                return lst;
            }
        }

        public static void SendEmail(string connectionStringName, string Body, string Subject, string toMailId, string ccMailId)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString))
                using (SqlCommand cmd = new SqlCommand())
                {
                    connection.Open();
                    cmd.Connection = connection;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "msdb.dbo.[sp_send_dbmail]";

                    cmd.Parameters.Add("@profile_name", SqlDbType.VarChar).Value = Convert.ToString(ConfigurationSettings.AppSettings["Sql_Profile_Name"]); //"RightsU";
                    cmd.Parameters.Add("@recipients", SqlDbType.VarChar).Value = toMailId;
                    cmd.Parameters.Add("@copy_recipients", SqlDbType.VarChar).Value = ccMailId;
                    cmd.Parameters.Add("@subject", SqlDbType.VarChar).Value = Subject;
                    cmd.Parameters.Add("@body", SqlDbType.NVarChar).Value = Body;
                    cmd.Parameters.Add("@body_format", SqlDbType.VarChar).Value = "HTML";

                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                StringBuilder sb = new StringBuilder("Found Exception While Sending Email : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                    sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                }
                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
            }
        }

        private static List<T> ConvertDataTable<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }
        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }
        public static bool GetSQLServerAgentStatus(string connectionStringName)
        {
            bool isAgentRunning = false;
            string sqlAgentCount = "SELECT COUNT(*) FROM master.sys.sysprocesses WHERE UPPER(LEFT(program_name, 8)) = 'SQLAGENT'";
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString))
            using (SqlCommand command = new SqlCommand(sqlAgentCount, connection))
            {
                connection.Open();
                SqlDataReader reader = command.ExecuteReader();
                try
                {
                    while (reader.Read())
                    {
                        if (Convert.ToInt32(reader.GetValue(0)) > 0)
                            isAgentRunning = true;
                    }
                }
                finally
                {
                    reader.Close();
                }
            }
            return isAgentRunning;
        }
        public static string ServiceSection_Two(string WindowsService, string WindowsService_Display_Name)
        {
            string result = "";
            string[] arrWS = WindowsService.Split('~');
            string[] arrWS_DN = WindowsService_Display_Name.Split('~');
            string TempResult = "";

            for (int i = 0; i < arrWS.Length; i++)
            {
                TempResult = System_Machine.Services(arrWS[i]);
                if (i == 0)
                    result = result + (TempResult.StartsWith("The") ? "<br>" + (i + 1).ToString() + ".<span style=\"color: red;\"> " + arrWS_DN[i] + " - " + TempResult + " </span> <br> " : "<br>" + (i + 1).ToString() + ".<span> " + arrWS_DN[i] + " - " + TempResult + " </span><br> ");
                else
                    result = result + (TempResult.StartsWith("The") ? (i + 1).ToString() + ".<span style=\"color: red;\"> " + arrWS_DN[i] + " - " + TempResult + " </span> <br> " : (i + 1).ToString() + ".<span> " + arrWS_DN[i] + " - " + TempResult + " </span><br>");
            }
            result = result + "<br>";
            return result;
        }
        public static long DirSize(DirectoryInfo d)
        {
            long size = 0;
            // Add file sizes.
            FileInfo[] fis = d.GetFiles();
            foreach (FileInfo fi in fis)
            {
                size += fi.Length;
            }
            // Add subdirectory sizes.
            DirectoryInfo[] dis = d.GetDirectories();
            foreach (DirectoryInfo di in dis)
            {
                size += DirSize(di);
            }

            return size;
        }
    }
    public static class FileSizeFormatter
    {
        static readonly string[] suffixes =
        { "Bytes", "KB", "MB", "GB", "TB", "PB" };
        public static string FormatSize(Int64 bytes)
        {
            int counter = 0;
            decimal number = (decimal)bytes;
            while (Math.Round(number / 1024) >= 1)
            {
                number = number / 1024;
                counter++;
            }
            return string.Format("{0:n1}{1}", number, suffixes[counter]);
        }
    }

}
