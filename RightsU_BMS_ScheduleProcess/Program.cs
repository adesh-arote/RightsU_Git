using RightsU_BMS_ScheduleProcess.Entities;
using RightsUMQService;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using static RightsU_BMS_ScheduleProcess.Repository.MasterRepositories;

namespace RightsU_BMS_ScheduleProcess
{

    public class Program
    {
        public static void Main(string[] args)
        {
            
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);

            ChannelRepositories objChannelRepositories = new ChannelRepositories();
            Upload_FilesRepositories objUpload_FilesRepositories = new Upload_FilesRepositories();
            USP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories objUSP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories = new USP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories();
            USP_Music_ScheduleRepositories objUSP_Music_ScheduleRepositories = new USP_Music_ScheduleRepositories();

            var objSrch = new
            {
                Is_Active = "Y",
                IsUseForAsRun = "Y"
            };

            Error.WriteLog_Conditional("STEP 1.1  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Fetching Channel List.");
            List<Channel> lstChannel = new List<Channel>();
            lstChannel = objChannelRepositories.SearchFor(objSrch).ToList();
            Error.WriteLog_Conditional("STEP 1.2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Channel List Count:" + lstChannel.Count());

            string FileExtension = ConfigurationManager.AppSettings["File_Extension"];            

            foreach (var channel in lstChannel)
            {
                DirectoryInfo info = new DirectoryInfo(channel.Schedule_Source_FilePath);
                FileInfo[] files = info.GetFiles().OrderBy(p => p.CreationTime).ToArray();
                foreach (FileInfo file in files)
                {
                    if (file.Extension.ToLower() == FileExtension.ToLower())
                    {
                        Upload_Files objUploadFiles = new Upload_Files();

                        objUploadFiles.File_Name = file.Name;
                        objUploadFiles.Upload_Date = System.DateTime.Now;
                        objUploadFiles.Uploaded_By = 0;
                        objUploadFiles.Upload_Type = "S";
                        objUploadFiles.ChannelCode = channel.Channel_Code;
                        objUploadFiles.Record_Status = "N";
                        objUploadFiles.StartDate = DateTime.Today.AddDays(-7);
                        objUploadFiles.EndDate = DateTime.Today.AddDays(7);
                        objUpload_FilesRepositories.Add(objUploadFiles);

                        var File_Code = Read_UploadedFiles(objUploadFiles, channel.Channel_Code, channel.Schedule_Source_FilePath);
                    }
                }

                //List<Upload_Files> lstUpload_Files = new List<Upload_Files>();

                //var objSrchUploadFiles = new
                //{
                //    Upload_Type = "S",
                //    ChannelCode = channel.Channel_Code,
                //    Record_Status = "P"
                //};

                //var lstUpload_Files_for_Reading = objUpload_FilesRepositories.SearchFor(objSrchUploadFiles).ToList();
                //if (lstUpload_Files_for_Reading.Count() > 0)
                //{
                //    foreach (var item in lstUpload_Files_for_Reading)
                //    {
                //        var File_Code = Read_UploadedFiles(item, channel.Channel_Code);
                //    }
                //}

                //var objSrchUploadFiles_Schedule = new
                //{
                //    Upload_Type = "S",
                //    ChannelCode = channel.Channel_Code,
                //    Record_Status = "D"
                //};

                //lstUpload_Files = objUpload_FilesRepositories.SearchFor(objSrchUploadFiles_Schedule).ToList();

                //foreach (var upload_Files in lstUpload_Files)
                //{
                //    objUSP_BMS_Schedule1_Validate_Temp_BV_ScheduleRepositories.USP_BMS_Schedule1_Validate_Temp_BV_Schedule(upload_Files.File_Code.Value, Convert.ToString(upload_Files.ChannelCode), null, null);
                //}
            }

            Error.WriteLog_Conditional("STEP 1.3  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Calling Procedure USP_Music_Schedule");

            //objUSP_Music_ScheduleRepositories.USP_Music_Schedule();

        }

        public static Int32 Read_UploadedFiles(Upload_Files objUpload_Files, Int32 ChannelCode, string filePath = "")
        {
            string FolderPath = filePath;

            BMS_Schedule_Import_ConfigRepositories objBMS_Schedule_Import_ConfigRepositories = new BMS_Schedule_Import_ConfigRepositories();
            BMSUploadData_Repositories objBMSUploadData_Repositories = new BMSUploadData_Repositories();
            Upload_FilesRepositories objUpload_FilesRepositories = new Upload_FilesRepositories();
            Int32 File_Code = 0;

            DataTable datatable = new DataTable();

            #region Get File and Read

            string extension = System.IO.Path.GetExtension(objUpload_Files.File_Name);
            if (extension.ToLower() == ".txt")
            {
                #region TXT File

                Error.WriteLog_Conditional("STEP 1 :Txt File reading process start.");

                //var filePath = ConfigurationManager.AppSettings["TXT_Url"] + objUpload_Files.File_Name;
                filePath = filePath+"\\" + objUpload_Files.File_Name;

                if (!File.Exists(filePath))
                {
                    Error.WriteLog_Conditional(string.Format("File : '{0}' File Not Found..!", objUpload_Files.File_Name));
                    return 0;
                }

                StreamReader streamreader = new StreamReader(filePath);
                char[] delimiter = new char[] { '\t' };
                string[] columnheaders = streamreader.ReadLine().Split(delimiter);
                foreach (string columnheader in columnheaders)
                {
                    datatable.Columns.Add(columnheader);
                }

                Error.WriteLog_Conditional("STEP 1.1 : Column headers are filled into datatable.");

                while (streamreader.Peek() > 0)
                {
                    DataRow datarow = datatable.NewRow();
                    datarow.ItemArray = streamreader.ReadLine().Split(delimiter);
                    datatable.Rows.Add(datarow);
                }

                streamreader.Close();

                if (datatable.Rows.Count > 0)
                {
                    Error.WriteLog_Conditional("STEP 1.2 : Data rows are filled into datatable.");

                    File_Code = objUpload_Files.File_Code.Value;

                    Error.WriteLog_Conditional("STEP 1.3 : File detail added into file upload table : File_Code = " + Convert.ToString(File_Code));

                    List<BMS_Schedule_Import_Config> objBMSScheduleImportConfig = new List<BMS_Schedule_Import_Config>();
                    objBMSScheduleImportConfig = objBMS_Schedule_Import_ConfigRepositories.SearchFor(new { File_Format = "txt" }).ToList();

                    Error.WriteLog_Conditional("STEP 1.4 : Checked columns detail into schedule config. ");

                    if (objBMSScheduleImportConfig.Count > 0)
                    {
                        List<Schedule_Data_UDT> ScheduleDataUDT = new List<Schedule_Data_UDT>();
                        foreach (DataRow row in datatable.Rows)
                        {
                            Schedule_Data_UDT ScheduleData = new Schedule_Data_UDT();
                            foreach (DataColumn column in datatable.Columns)
                            {
                                string Input_Column_Name = objBMSScheduleImportConfig.Where(w => w.Input_Column_Name == column.ColumnName.Replace("\"", "")).Select(l => l.Input_Column_Name).FirstOrDefault();
                                if (!string.IsNullOrEmpty(Input_Column_Name))
                                {

                                    if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                        ScheduleData.Program_Episode_ID = row["\"Program Episode ID\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Title")
                                        ScheduleData.Program_Episode_Title = row["\"Program Title\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Episode Number")
                                        ScheduleData.Program_Episode_Number = row["\"Program Episode Number\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Category")
                                        ScheduleData.Program_Category = row["\"Program Category\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Version ID")
                                        ScheduleData.Program_Version_ID = row["\"Program Version ID\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Date")
                                        ScheduleData.Schedule_Item_Log_Date = row["\"Schedule Item Log Date\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Time")
                                        ScheduleData.Schedule_Item_Log_Time = row["\"Schedule Item Log Time\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Schedule Item Duration")
                                        ScheduleData.Schedule_Item_Duration = row["\"Schedule Item Duration\""].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Scheduled Version House Number List")
                                        ScheduleData.Scheduled_Version_House_Number_List = row["\"Scheduled Version House Number List\""].ToString().Replace("\"", "");
                                }
                            }

                            ScheduleData.File_Code = Convert.ToString(File_Code);
                            ScheduleDataUDT.Add(ScheduleData);
                        }

                        if (ScheduleDataUDT.Count > 0)
                        {
                            Error.WriteLog_Conditional("STEP 1.5 : Schedule UDT filled.");

                            ListtoDataTable lstToDataTable = new ListtoDataTable();
                            DataTable dt = lstToDataTable.ToDataTable(ScheduleDataUDT);
                            if (dt.Rows.Count > 0)
                            {
                                int id = objBMSUploadData_Repositories.BMSUploadData(dt, "txt", Convert.ToInt32(ChannelCode));
                                if (id > 0)
                                {                                    
                                    Error.WriteLog_Conditional("STEP 1.6 : File detail uploaded into Temp_BV_Scheduler table with ID : " + Convert.ToString(id));

                                    Upload_Files objUploadFiles = new Upload_Files();                                    
                                    objUploadFiles = objUpload_FilesRepositories.GetUpload_FilesById(File_Code);
                                    objUploadFiles.Err_YN = "N";
                                    objUploadFiles.Record_Status = "P";
                                    objUpload_FilesRepositories.Update(objUploadFiles);    
                                    
                                    File.Move(filePath, FolderPath + ConfigurationManager.AppSettings["Success_File"] + objUpload_Files.File_Name);                            
                                }
                                else
                                {
                                    Error.WriteLog_Conditional("STEP 1.7 : File detail processing Unsuccessful");

                                    Upload_Files objUploadFiles = new Upload_Files();
                                    objUploadFiles = objUpload_FilesRepositories.GetUpload_FilesById(File_Code);
                                    objUploadFiles.Err_YN = "Y";
                                    objUploadFiles.Record_Status = "E";
                                    objUpload_FilesRepositories.Update(objUploadFiles);

                                    File.Move(filePath, FolderPath + ConfigurationManager.AppSettings["Failed_File"] + objUpload_Files.File_Name);

                                    return 0;
                                }
                            }
                        }
                    }
                }

                #endregion
            }
            else if (extension.ToLower() == ".csv")
            {
                #region CSV File

                Error.WriteLog_Conditional("STEP 2 :Csv File reading process start.");

                //var filePath = ConfigurationManager.AppSettings["CSV_Url"] + objUpload_Files.File_Name;
                filePath = filePath + "/" + objUpload_Files.File_Name;

                if (!File.Exists(filePath))
                {
                    Error.WriteLog_Conditional(string.Format("File : '{0}' File Not Found..!", objUpload_Files.File_Name));
                    return 0;
                }

                StreamReader streamreader = new StreamReader(filePath);
                char[] delimiter = new char[] { ',' };
                string[] columnheaders = streamreader.ReadLine().Split(delimiter);
                foreach (string columnheader in columnheaders)
                {
                    datatable.Columns.Add(columnheader);
                }

                Error.WriteLog_Conditional("STEP 2.1 : Column headers are filled into datatable.");

                while (streamreader.Peek() > 0)
                {
                    DataRow datarow = datatable.NewRow();
                    datarow.ItemArray = streamreader.ReadLine().Split(delimiter);
                    datatable.Rows.Add(datarow);
                }

                streamreader.Close();

                if (datatable.Rows.Count > 0)
                {
                    Error.WriteLog_Conditional("STEP 2.2 : Data rows are filled into datatable.");

                    File_Code = objUpload_Files.File_Code.Value;

                    Error.WriteLog_Conditional("STEP 2.3 : File detail added into file upload table : File_Code = " + Convert.ToString(File_Code));

                    List<BMS_Schedule_Import_Config> objBMSScheduleImportConfig = new List<BMS_Schedule_Import_Config>();
                    objBMSScheduleImportConfig = objBMS_Schedule_Import_ConfigRepositories.SearchFor(new { File_Format = "csv" }).ToList();

                    if (objBMSScheduleImportConfig.Count > 0)
                    {
                        Error.WriteLog_Conditional("STEP 2.4 : Checked columns detail into schedule config. ");

                        List<Schedule_Data_UDT> ScheduleDataUDT = new List<Schedule_Data_UDT>();
                        foreach (DataRow row in datatable.Rows)
                        {
                            Schedule_Data_UDT ScheduleData = new Schedule_Data_UDT();
                            foreach (DataColumn column in datatable.Columns)
                            {
                                string Input_Column_Name = objBMSScheduleImportConfig.Where(w => w.Input_Column_Name == column.ColumnName.Replace("\"", "")).Select(l => l.Input_Column_Name).FirstOrDefault();
                                if (!string.IsNullOrEmpty(Input_Column_Name))
                                {
                                    if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                        ScheduleData.Program_Episode_ID = row["Program Episode ID"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Title")
                                        ScheduleData.Program_Episode_Title = row["Program Title"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Episode Number")
                                        ScheduleData.Program_Episode_Number = row["Program Episode Number"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Category")
                                        ScheduleData.Program_Category = row["Program Category"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Program Version ID")
                                        ScheduleData.Program_Version_ID = row["Program Version ID"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Date")
                                        ScheduleData.Schedule_Item_Log_Date = row["Schedule Item Log Date"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Time")
                                        ScheduleData.Schedule_Item_Log_Time = row["Schedule Item Log Time"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Schedule Item Duration")
                                        ScheduleData.Schedule_Item_Duration = row["Schedule Item Duration"].ToString().Replace("\"", "");
                                    if (column.ColumnName.Replace("\"", "") == "Scheduled Version House Number List")
                                        ScheduleData.Scheduled_Version_House_Number_List = row["Scheduled Version House Number List"].ToString().Replace("\"", "");                                    
                                }
                            }

                            ScheduleData.File_Code = Convert.ToString(File_Code);
                            ScheduleDataUDT.Add(ScheduleData);
                        }

                        if (ScheduleDataUDT.Count > 0)
                        {
                            Error.WriteLog_Conditional("STEP 2.5 : Schedule UDT filled.");

                            ListtoDataTable lstToDataTable = new ListtoDataTable();
                            DataTable dt = lstToDataTable.ToDataTable(ScheduleDataUDT);
                            if (dt.Rows.Count > 0)
                            {
                                int id = objBMSUploadData_Repositories.BMSUploadData(dt, "csv", Convert.ToInt32(ChannelCode));
                                if (id > 0)
                                {
                                    Error.WriteLog_Conditional("STEP 2.6 : File detail uploaded into Temp_BV_Scheduler table with ID : " + Convert.ToString(id));

                                    Upload_Files objUploadFiles = new Upload_Files();
                                    objUploadFiles = objUpload_FilesRepositories.GetUpload_FilesById(File_Code);
                                    objUploadFiles.Err_YN = "N";
                                    objUploadFiles.Record_Status = "P";
                                    objUpload_FilesRepositories.Update(objUploadFiles);

                                    File.Move(filePath, FolderPath + ConfigurationManager.AppSettings["Success_File"] + objUpload_Files.File_Name);
                                }
                                else
                                {
                                    Error.WriteLog_Conditional("STEP 2.7 : File detail processing Unsuccessful");

                                    Upload_Files objUploadFiles = new Upload_Files();
                                    objUploadFiles = objUpload_FilesRepositories.GetUpload_FilesById(File_Code);
                                    objUploadFiles.Err_YN = "Y";
                                    objUploadFiles.Record_Status = "E";
                                    objUpload_FilesRepositories.Update(objUploadFiles);

                                    File.Move(filePath, FolderPath + ConfigurationManager.AppSettings["Failed_File"] + objUpload_Files.File_Name);

                                    return 0;
                                }
                            }
                        }
                    }
                }

                #endregion
            }
            #endregion


            return File_Code;
        }
    }

    public class ListtoDataTable
    {
        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties by using reflection   
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names  
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {

                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }

            return dataTable;
        }
    }
}
