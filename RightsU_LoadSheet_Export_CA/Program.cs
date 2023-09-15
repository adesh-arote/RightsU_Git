using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsU_LoadSheet_Export_CA.Entities;
using RightsU_LoadSheet_Export_CA.Repository;
using Newtonsoft.Json;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using static RightsU_LoadSheet_Export_CA.Repository.ExportToExcelRepositories;

namespace RightsU_LoadSheet_Export_CA
{
    public class Program
    {
        static void Main(string[] args)
        {
            ExportLoadSheet();
        }

        public static void ExportLoadSheet()
        {

            AL_Load_SheetRepositories objAL_Load_SheetRepositories = new AL_Load_SheetRepositories();
            USPAL_GenerateLoadsheetRepositories objUSPAL_GenerateLoadsheetRepositories = new USPAL_GenerateLoadsheetRepositories();
            AL_Booking_Sheet_DetailsRepositories objAL_Booking_Sheet_DetailsRepositories = new AL_Booking_Sheet_DetailsRepositories();

            List<AL_Load_Sheet> lstAL_Load_Sheet = new List<AL_Load_Sheet>();
            lstAL_Load_Sheet = objAL_Load_SheetRepositories.GetALLAL_Load_Sheet().Where(x => x.Status == "P" && String.IsNullOrEmpty(x.Download_File_Name)).ToList();

            DataSet dataSet = new DataSet();
            List<string> lstLabs = new List<string>();

            foreach (var item in lstAL_Load_Sheet)
            {
                string sqlGenData = "EXEC USPAL_Gnerate_Material_Tracking " + item.AL_Load_Sheet_Code.ToString();
                objAL_Load_SheetRepositories.GetDataWithSQLStmt(sqlGenData);

                foreach (var AL_Load_Sheet_Details in item.AL_Load_Sheet_Details)
                {
                    var obj = new
                    {
                        AL_Booking_Sheet_Code = AL_Load_Sheet_Details.AL_Booking_Sheet_Code,
                        Columns_Code = 70
                    };

                    lstLabs.AddRange(objAL_Booking_Sheet_DetailsRepositories.SearchFor(obj).Where(x => !String.IsNullOrEmpty(x.Columns_Value)).Select(x => x.Columns_Value.ToUpper()).Distinct().ToList());
                    //GetALLAL_Booking_Sheet_Details().Where(x => x.AL_Booking_Sheet_Code == AL_Load_Sheet_Details.AL_Booking_Sheet_Code && x.Columns_Code == 70).Select(x=>x.Columns_Value).Distinct().ToList());
                }

                string Debugger = "";
                string zipPath = ConfigurationManager.AppSettings["UploadFilePath"] + item.Load_Sheet_No + ".zip";
                File.Delete(zipPath);

                List<dynamic> lstDynamicLoadsheet = new List<dynamic>();
                foreach (var Lab in lstLabs.Distinct())
                {
                    dataSet = new DataSet();  //Added by sachin shelar
                    lstDynamicLoadsheet = objUSPAL_GenerateLoadsheetRepositories.USPAL_GenerateLoadsheet(item.AL_Load_Sheet_Code ?? 0, Lab).ToList();
                    string json = JsonConvert.SerializeObject(lstDynamicLoadsheet);
                    DataTable dataTable = new DataTable(Lab);
                    dataTable = (DataTable)JsonConvert.DeserializeObject(json, (typeof(DataTable)));
                    dataTable.TableName = Lab;

                    dataSet.Tables.Add(dataTable);

                    ExportToExcel(dataSet, Lab + ".xlsx", out string BookingSheetName, item.Load_Sheet_No);     //Added by sachin shelar
                }

                CreateZipFile(item.Load_Sheet_No);

                string query = "UPDATE AL_Load_Sheet SET Status = 'D', Download_File_Name ='" + item.Load_Sheet_No + ".zip' WHERE AL_Load_Sheet_Code = " + item.AL_Load_Sheet_Code;       //Added by sachin shelar
                objAL_Load_SheetRepositories.GetDataWithSQLStmt(query);                                                                                                                   //

                //ExportToExcel(dataSet, item.Load_Sheet_No+".xlsx", out string BookingSheetName);       //comment by sachin shelar

                //string query = "UPDATE AL_Load_Sheet SET Status = 'D', Download_File_Name ='"+ item.Load_Sheet_No+".xlsx' WHERE AL_Load_Sheet_Code = "+ item.AL_Load_Sheet_Code;
                //objAL_Load_SheetRepositories.GetDataWithSQLStmt(query);
            }
        }

        public static void ExportToExcel(System.Data.DataSet ds, string FileName, out string BookingSheetName, string LoadSheetNo)
        {
            var file = new FileInfo(ConfigurationManager.AppSettings["UploadFilePath"] + "Sample1.xlsx");
            //string Destination = ConfigurationManager.AppSettings["UploadFilePath"] + FileName;   //       
            //FileInfo newFile = new FileInfo(Destination);                                         //
            //string Name = newFile.Name.ToString();                                                //
            //if (newFile.Exists)                                                                   //comment by sachin shelar 
            //{                                                                                     //
            //    newFile.Delete();                                                                 //
            //}                                                                                     //

            string Destination = ConfigurationManager.AppSettings["UploadFilePath"] + LoadSheetNo;          //          
                                                                                                            //
            if (!Directory.Exists(Destination))                                                             //Added by sachin shelar  
            {                                                                                               //
                Directory.CreateDirectory(Destination);                                                     //
            }

            using (ExcelPackage excel = new ExcelPackage(file))
            {
                if (ds != null && ds.Tables.Count > 0)
                {
                    for (int i = 0; i <= ds.Tables.Count - 1; i++)
                    {
                        if (i == 0)
                        {
                            ExcelWorksheet sheet = excel.Workbook.Worksheets["Sheet1"];
                            sheet.Name = ds.Tables[i].TableName;
                            sheet.Cells.LoadFromDataTable(ds.Tables[i], true);
                            for (int j = 1; j <= ds.Tables[i].Columns.Count; j++)
                            {
                                Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                                sheet.Cells[1, j].Style.Font.Bold = true;
                                sheet.Cells[1, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                                sheet.Cells[1, j].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                                sheet.Cells[1, j].Style.Font.Size = 11;
                                sheet.Cells[1, j].Style.Font.Name = "Calibri";
                                sheet.Cells[1, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colFromHex);
                                sheet.Cells[1, j].AutoFitColumns();
                            }
                        }
                        else
                        {
                            ExcelWorksheet sheet = excel.Workbook.Worksheets.Add(ds.Tables[i].TableName);
                            for (int j = 1; j <= ds.Tables[i].Columns.Count; j++)
                            {
                                Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                                sheet.Cells[1, j].Style.Font.Bold = true;
                                sheet.Cells[1, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                                sheet.Cells[1, j].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                                sheet.Cells[1, j].Style.Font.Size = 11;
                                sheet.Cells[1, j].Style.Font.Name = "Calibri";
                                sheet.Cells[1, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colFromHex);
                                sheet.Cells[1, j].AutoFitColumns();
                            }
                            sheet.Cells.LoadFromDataTable(ds.Tables[i], true);
                        }

                    }
                    FileInfo excelFile = new FileInfo(Destination + "\\" + FileName);

                    //using (var memoryStream = new MemoryStream())
                    //{
                    //    using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
                    //    {
                    //        var demoFile = archive.CreateEntry("foo.txt");

                    //        using (var entryStream = demoFile.Open())
                    //        using (var streamWriter = new StreamWriter(entryStream))
                    //        {
                    //            streamWriter.Write("Bar!");
                    //        }
                    //    }

                    //    using (var fileStream = new FileStream(@"D:\Aeroplay\test.zip", FileMode.Create))
                    //    {
                    //        memoryStream.Seek(0, SeekOrigin.Begin);
                    //        memoryStream.CopyTo(fileStream);
                    //    }
                    //}

                    excel.SaveAs(excelFile);
                }
            }
            BookingSheetName = "";
        }

        public static void CreateZipFile(string LoadSheetNo)
        {
            string Destination = ConfigurationManager.AppSettings["UploadFilePath"] + LoadSheetNo;
            string zipPath = ConfigurationManager.AppSettings["UploadFilePath"] + LoadSheetNo + ".zip";

            ZipFile.CreateFromDirectory(Destination, zipPath);

            if (Directory.Exists(Destination))
            {
                Directory.Delete(Destination, true);
            }
        }
    }
}
