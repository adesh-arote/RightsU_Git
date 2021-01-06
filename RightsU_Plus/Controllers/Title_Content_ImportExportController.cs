using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Data;
using System.Reflection;
using OfficeOpenXml;
using System.IO;
using System.Data.OleDb;
using UTOFrameWork.FrameworkClasses;
using System.Data.Entity.Core.Objects;
using System.Text.RegularExpressions;
using Microsoft.Reporting.WebForms;
using System.Runtime.Serialization.Formatters.Binary;
using System.Configuration;

namespace RightsU_Plus.Controllers
{
    public class Title_Content_ImportExportController : BaseController
    {
        ReportViewer ReportViewer1;
        public List<USP_Content_Music_PI> lstError
        {
            get
            {
                if (Session["lstError"] == null)
                    Session["lstError"] = new List<USP_Content_Music_PI>();
                return (List<USP_Content_Music_PI>)Session["lstError"];
            }
            set { Session["lstError"] = value; }
        }
        List<USP_Content_Music_Link_Bulk_Insert_UDT> lstExcelErrorList
        {
            get
            {
                if (Session["lstExcelErrorList"] == null)
                    Session["lstExcelErrorList"] = new List<USP_Content_Music_Link_Bulk_Insert_UDT>();
                return (List<USP_Content_Music_Link_Bulk_Insert_UDT>)Session["lstExcelErrorList"];
            }
            set { Session["lstExcelErrorList"] = value; }
        }
        public DM_Master_Import_Service objDMService
        {
            get
            {
                if (Session["objDMService"] == null)
                    Session["objDMService"] = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName);
                return (DM_Master_Import_Service)Session["objDMService"];
            }
            set { Session["objDMService"] = value; }
        }
        public int pageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 0;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }
        private int _recordPerPage = 10;
        public int recordPerPage
        {
            get { return _recordPerPage; }
            set { _recordPerPage = value; }
        }
        public DM_Content_Music objDMContent
        {
            get
            {
                if (Session["objDMContent"] == null)
                    Session["objDMContent"] = new DM_Content_Music();
                return (DM_Content_Music)Session["objDMContent"];
            }
            set { Session["objDMContent"] = value; }
        }
        public List<DM_Import_UDT> lst_DM_Import_UDT
        {
            get
            {
                if (Session["lst_DM_Import_UDT"] == null)
                    Session["lst_DM_Import_UDT"] = new List<DM_Import_UDT>();
                return (List<DM_Import_UDT>)Session["lst_DM_Import_UDT"];
            }
            set { Session["lst_DM_Import_UDT"] = value; }
        }
        public DM_Content_Music_Service objDMContentService
        {
            get
            {
                if (Session["objDMContentService"] == null)
                    Session["objDMContentService"] = new DM_Content_Music_Service(objLoginEntity.ConnectionStringName);
                return (DM_Content_Music_Service)Session["objDMContentService"];
            }
            set { Session["objDMContentService"] = value; }
        }
        public DM_Master_Log objDMLog
        {
            get
            {
                if (Session["objDMLog"] == null)
                    Session["objDMLog"] = new DM_Master_Log();
                return (DM_Master_Log)Session["objDMLog"];
            }
            set { Session["objDMLog"] = value; }
        }
        public string lstDMCodes
        {
            get
            {
                if (Session["lstDMCodes"] == null)
                    Session["lstDMCodes"] = "";
                return (string)Session["lstDMCodes"];
            }
            set { Session["lstDMCodes"] = value; }
        }
        public List<DM_Master_Log> lstDMLog
        {
            get
            {
                if (Session["lstDMLog"] == null)
                    Session["lstDMLog"] = new List<DM_Master_Log>();
                return (List<DM_Master_Log>)Session["lstDMLog"];
            }
            set { Session["lstDMLog"] = value; }
        }
        public List<DM_Master_Log> SMDMLog
        {
            get
            {
                if (Session["SMDMLog"] == null)
                    Session["SMDMLog"] = new List<DM_Master_Log>();
                return (List<DM_Master_Log>)Session["SMDMLog"];
            }
            set { Session["SMDMLog"] = value; }
        }
        public List<DM_Content_Music> lstDMContent
        {
            get
            {
                if (Session["lstDMContent"] == null)
                    Session["lstDMContent"] = new List<DM_Content_Music>();
                return (List<DM_Content_Music>)Session["lstDMContent"];
            }
            set { Session["lstDMContent"] = value; }
        }
        public List<DM_Content_Music> finallstDMContent
        {
            get
            {
                if (Session["finallstDMContent"] == null)
                    Session["finallstDMContent"] = new List<DM_Content_Music>();
                return (List<DM_Content_Music>)Session["finallstDMContent"];
            }
            set { Session["finallstDMContent"] = value; }
        }
        private ConflictTabPaging objConflictTabPaging
        {
            get
            {
                if (Session["objConflictTabPaging"] == null)
                    Session["objConflictTabPaging"] = new ConflictTabPaging();
                return (ConflictTabPaging)Session["objConflictTabPaging"];
            }
            set { Session["objConflictTabPaging"] = value; }
        }
        public int? DM_Master_Import_Code
        {
            get
            {
                if (Session["DM_Master_Import_Code"] == null)
                    Session["DM_Master_Import_Code"] = 0;
                return (int)Session["DM_Master_Import_Code"];
            }
            set { Session["DM_Master_Import_Code"] = value; }
        }
        public string FilterByStatus
        {
            get
            {
                if (Session["FilterByStatus"] == null)
                    Session["FilterByStatus"] = "A";
                return (string)Session["FilterByStatus"];
            }
            set { Session["FilterByStatus"] = value; }
        }
        private List<RightsU_Entities.USP_List_ContentBulkImport_Result> lstContentBulkImport
        {
            get
            {
                if (Session["lstContentBulkImport"] == null)
                    Session["lstContentBulkImport"] = new List<RightsU_Entities.USP_List_ContentBulkImport_Result>();
                return (List<RightsU_Entities.USP_List_ContentBulkImport_Result>)Session["lstContentBulkImport"];
            }
            set { Session["lstContentBulkImport"] = value; }
        }
        private ContentBulkImportSearch objPage_Properties
        {
            get
            {
                if (Session["ContentBulkImportSearch_Page_Properties"] == null)
                    Session["ContentBulkImportSearch_Page_Properties"] = new ContentBulkImportSearch();
                return (ContentBulkImportSearch)Session["ContentBulkImportSearch_Page_Properties"];
            }
            set { Session["ContentBulImportSearch_Page_Properties"] = value; }
        }
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForContent);
            return View();
        }
        public ActionResult Music_Program_Import()
        {
            objDMLog = null;
            objDMService = null;
            objDMContent = null;
            objDMContentService = null;
            finallstDMContent = null;
            lstDMContent = null;
            lst_DM_Import_UDT = null;
            List<SelectListItem> lstFliter = new List<SelectListItem>();
            lstFliter.Add(new SelectListItem { Text = "All", Value = "A", Selected = true });
            lstFliter.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstFliter.Add(new SelectListItem { Text = "In Process", Value = "Q" });
            lstFliter.Add(new SelectListItem { Text = "Resolve Conflict", Value = "R" });
            lstFliter.Add(new SelectListItem { Text = "Success", Value = "S" });
            ViewBag.FilterBy = lstFliter;
            ViewBag.FilterbyStatus = FilterByStatus;
            ViewBag.PageNoBack = pageNo == 0 ? 0 : pageNo - 1;
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForContent);
            return View("~/Views/Title_Content_ImportExport/Music_Program_Import.cshtml");
        }
        public PartialViewResult UploadTitle(HttpPostedFileBase InputFile, string txtpageSize, string FilterBy)
        {
            string message = "";
            string isError = "N";
            string status = "";
            int PageNo = 0;
            string sheetName = "ContentMusic$";
            List<DM_Master_Import> lst_DM_Master_Import = new List<DM_Master_Import>();
            DM_Master_Import obj_DM_Master_Import = new DM_Master_Import();
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = InputFile;
                string fullPath = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadFilePath"]);
                string ext = System.IO.Path.GetExtension(PostedFile.FileName);
                if (ext == ".xlsx" || ext == ".xls")
                {
                    ExcelReader objExcelReader = new ExcelReader();
                    DataSet ds = new DataSet();
                    try
                    {

                        string strFileName = System.IO.Path.GetFileName(PostedFile.FileName);
                        if ((ext.ToLower() != ".xls" && ext.ToLower() != ".xlsx") || (PostedFile.ContentLength <= 0))
                        {
                            isError = "Y";
                            message = "Please upload Excel Sheet named as " + sheetName.Trim() + " only with .xlsx extension.";
                        }
                        string strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                        string fullpathname = fullPath + strActualFileNameWithDate; ;
                        PostedFile.SaveAs(fullpathname);
                        OleDbConnection cn;
                        ds = new DataSet();
                        try
                        {
                            cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1'");
                            OleDbCommand cmdExcel = new OleDbCommand();
                            OleDbDataAdapter oda = new OleDbDataAdapter();
                            DataTable dt = new DataTable();
                            cmdExcel.Connection = cn;
                            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + sheetName + "]", cn);
                            da.Fill(ds);
                        }
                        catch (Exception ex)
                        {
                            status = "E";
                            isError = "Y";
                            message = "Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
                        }
                        finally
                        {
                            //Always delete uploaded excel file from folder.
                            System.IO.File.Delete(fullpathname.Trim());
                        }
                        var count = ds.Tables.Count;
                        if (count == 0)
                        {
                            message = "'" + sheetName.Trim('$') + "'" + " Sheet name should not be existing in uploaded excel";
                            status = "E";
                        }
                        if (ds.Tables.Count > 0)
                        {
                            for (int j = 0; j < ds.Tables[0].Columns.Count; j++)
                            {
                                string ss = Convert.ToString(ds.Tables[0].Rows[0][j]);
                                if (Convert.ToString(ds.Tables[0].Rows[0][j]) != "")
                                    ds.Tables[0].Columns[j].ColumnName = Convert.ToString(ds.Tables[0].Rows[0][j]);
                            }
                            ds.Tables[0].Rows.RemoveAt(0);
                            for (int i = ds.Tables[0].Rows.Count; i >= 1; i--)
                            {
                                int cnt = 0;
                                DataRow currentRow = ds.Tables[0].Rows[i - 1];
                                foreach (var colValue in currentRow.ItemArray)
                                {
                                    if (string.IsNullOrEmpty(colValue.ToString()))
                                        cnt++;
                                    if (ds.Tables[0].Columns.Count == cnt)
                                    {
                                        ds.Tables[0].Rows.RemoveAt(i - 1);
                                        break;
                                    }
                                }
                            }

                            if (ds.Tables[0].Columns[0].ColumnName.Trim() != "Sr. No"
                             || ds.Tables[0].Columns[1].ColumnName.Trim() != "Content"
                             || ds.Tables[0].Columns[2].ColumnName.Trim() != "Episode"
                             || ds.Tables[0].Columns[3].ColumnName.Trim() != "Duration (Min)"
                             || ds.Tables[0].Columns[4].ColumnName.Trim() != "Version"
                             || ds.Tables[0].Columns[5].ColumnName.Trim() != "Music Track"
                             || ds.Tables[0].Columns[6].ColumnName.Trim() != "TC IN"
                             || ds.Tables[0].Columns[7].ColumnName.Trim() != "TC OUT"
                             || ds.Tables[0].Columns[8].ColumnName.Trim() != "From Frame"
                             || ds.Tables[0].Columns[9].ColumnName.Trim() != "To Frame"
                             || ds.Tables[0].Columns[10].ColumnName.Trim() != "Duration"
                             || ds.Tables[0].Columns[11].ColumnName.Trim() != "Duration Frame"
                             || ds.Tables[0].Columns[12].ColumnName.Trim() != "Title_Content_Code"
                             )
                            {
                                status = "E";
                                isError = "Y";
                                message = "Please Don't Modify the name of the field in excel File";
                            }
                            else
                            {
                                if (ds.Tables[0].Columns.Count >= 12)
                                {
                                    if (ds.Tables[0].Rows.Count > 0)
                                    {
                                        dynamic resultSet;
                                        List<Content_Music_Link_UDT> lst_Content_Music_Link_UDT = new List<Content_Music_Link_UDT>();
                                        obj_DM_Master_Import.File_Name = PostedFile.FileName;
                                        obj_DM_Master_Import.System_File_Name = PostedFile.FileName;
                                        obj_DM_Master_Import.Upoaded_By = Convert.ToInt32(objLoginUser.Users_Code);
                                        obj_DM_Master_Import.Uploaded_Date = DateTime.Now;
                                        obj_DM_Master_Import.Action_By = objLoginUser.Users_Code;
                                        obj_DM_Master_Import.Action_On = DateTime.Now;
                                        obj_DM_Master_Import.Status = "N";
                                        obj_DM_Master_Import.File_Type = "C";
                                        obj_DM_Master_Import.EntityState = State.Added;
                                        lst_DM_Master_Import.Add(obj_DM_Master_Import);
                                        objDMService.Save(obj_DM_Master_Import, out resultSet);

                                        foreach (DataRow row in ds.Tables[0].Rows)
                                        {
                                            Content_Music_Link_UDT obj_Content_Music_Link_UDT = new Content_Music_Link_UDT();
                                            Regex pattern = new Regex("^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9]):([0-5]?[0-9])(:([0-5]?[0-9]))?$");

                                            // string pattern = "[0-9]{2}:[0-9]{2}:[0-9]{2}";
                                            if (Convert.ToString(row["TC IN"]) != "")
                                            {
                                                bool CheckTCIN = pattern.IsMatch(Convert.ToString(row["TC IN"]));
                                                //bool CheckTCIN = Regex.IsMatch(Convert.ToString(row["TC IN"]), pattern);
                                                if (!CheckTCIN)
                                                    row["TC IN"] = "00:00:00";
                                            }
                                            else
                                                row["TC IN"] = "";
                                            obj_Content_Music_Link_UDT.From = Convert.ToString(row["TC IN"]).Trim();
                                            if (Convert.ToString(row["TC OUT"]) != "")
                                            {
                                                bool CheckTCOUT = pattern.IsMatch(Convert.ToString(row["TC OUT"]));
                                                //Regex.IsMatch(Convert.ToString(row["TC OUT"]), pattern);
                                                if (!CheckTCOUT)
                                                    row["TC OUT"] = "00:00:00";
                                            }
                                            else
                                                row["TC OUT"] = "";
                                            obj_Content_Music_Link_UDT.To = Convert.ToString(row["TC OUT"]).Trim();
                                            obj_Content_Music_Link_UDT.Music_Track = Convert.ToString(row["Music Track"]).Trim();
                                            if (Convert.ToString(row["Duration"]) != "")
                                            {
                                                bool CheckDuration = pattern.IsMatch(Convert.ToString(row["Duration"]));
                                                //Regex.IsMatch(Convert.ToString(row["Duration"]), pattern);
                                                if (!CheckDuration)
                                                    row["Duration"] = "00:00:00";
                                            }
                                            else
                                                row["Duration"] = "";
                                            obj_Content_Music_Link_UDT.Duration = Convert.ToString(row["Duration"]);
                                            obj_Content_Music_Link_UDT.Title_Content_Code = Convert.ToString(row["Title_Content_Code"]);
                                            string FrameLimit = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "FrameLimit").Select(s => s.Parameter_Value).FirstOrDefault();
                                            if (Convert.ToString(row["From Frame"]) != "")
                                            {
                                                if (Convert.ToInt32(row["From Frame"]) > (Convert.ToInt32(FrameLimit) - 1))
                                                    obj_Content_Music_Link_UDT.From_Frame = "00";
                                                else
                                                    obj_Content_Music_Link_UDT.From_Frame = Convert.ToString(row["From Frame"]);
                                            }
                                            else
                                                obj_Content_Music_Link_UDT.From_Frame = Convert.ToString(row["From Frame"]);
                                            if (Convert.ToString(row["To Frame"]) != "")
                                            {
                                                if (Convert.ToInt32(row["To Frame"]) > (Convert.ToInt32(FrameLimit) - 1))
                                                    obj_Content_Music_Link_UDT.To_Frame = "00";
                                                else
                                                    obj_Content_Music_Link_UDT.To_Frame = Convert.ToString(row["To Frame"]);
                                            }
                                            else
                                                obj_Content_Music_Link_UDT.To_Frame = Convert.ToString(row["To Frame"]);

                                            if (Convert.ToString(row["Duration Frame"]) != "")
                                            {
                                                if (Convert.ToInt32(row["Duration Frame"]) > (Convert.ToInt32(FrameLimit) - 1))
                                                    obj_Content_Music_Link_UDT.Duration_Frame = "00";
                                                else
                                                    obj_Content_Music_Link_UDT.Duration_Frame = Convert.ToString(row["Duration Frame"]);
                                            }
                                            else
                                                obj_Content_Music_Link_UDT.Duration_Frame = Convert.ToString(row["Duration Frame"]);
                                            obj_Content_Music_Link_UDT.Version_Name = Convert.ToString(row["Version"]);
                                            obj_Content_Music_Link_UDT.DM_Master_Import_Code = obj_DM_Master_Import.DM_Master_Import_Code.ToString();
                                            obj_Content_Music_Link_UDT.Excel_Line_No = row["Sr. No"].ToString();
                                            lst_Content_Music_Link_UDT.Add(obj_Content_Music_Link_UDT);
                                        }
                                        lstError = new USP_Service(objLoginEntity.ConnectionStringName).USP_Content_Music_PI(lst_Content_Music_Link_UDT, 1219).ToList();

                                        if (lstError.Count == 0)
                                        {
                                            message = "Data saved successfully";
                                            status = "S";
                                        }
                                        //if (lst_Content_Music_Link_UDT != null && lst_Content_Music_Link_UDT.Count() > 0)
                                        //{
                                        //    lstExcelErrorList = null;
                                        //    lstExcelErrorList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Content_Music_Link_Bulk_Insert_UDT(
                                        //        lst_Content_Music_Link_UDT, objLoginUser.Users_Code).ToList();

                                        //    if (lstExcelErrorList.Count > 0)
                                        //    {
                                        //        lstExcelErrorList.ForEach(s => { s.Error_Message = s.Error_Message.Trim().Trim('^').Trim().Replace("^", "<br />"); });
                                        //        isError = "X";
                                        //    }
                                        //    else
                                        //    {
                                        //        status = "S";
                                        //        message = "Data Saved successfully";
                                        //    }
                                        //}
                                    }
                                    else
                                    {
                                        message = "Please fill the data in the excel file";
                                        status = "E";
                                    }
                                }
                                else
                                {
                                    message = "Please fill correct data in the excel file";
                                    status = "E";
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        message = ex.Message;
                    }
                }
                else
                {
                    message = "Please Select Excel File";
                    status = "E";
                }

            }
            else
            {
                message = "Please Select Excel File";
                status = "E";

            }

            ViewBag.File_Type = obj_DM_Master_Import.File_Type;
            ViewBag.Message = message;
            ViewBag.status = status;
            return PopulateContentGrid(Convert.ToString(PageNo), txtpageSize, FilterBy);
        }
        //    //else
        //    //{
        //    //    status = "E";
        //    //    isError = "Y";
        //    //    message = "please Fill the Data in the Excel File";
        //    //}
        //}
        //                    else
        //                    {
        //                        status = "E";
        //                        isError = "Y";
        //                        message = "please Fill Correct Data in the Excel File";
        //                    }
        //                }
        //            }
        //            catch (Exception ex)
        //            {
        //                status = "E";
        //                isError = "Y";
        //                message = ex.Message;
        //            }
        //        }
        //        else
        //        {
        //            status = "E";
        //            isError = "Y";
        //            message = "Please Select Excel File...";
        //        }

        //    }
        //    else
        //    {
        //        status = "E";
        //        isError = "Y";
        //        message = "Please Select Excel File...";
        //    }
        //    ViewBag.File_Type = obj_DM_Master_Import.File_Type;
        //    ViewBag.Message = message;
        //    ViewBag.status = status;
        //    //ViewBag.status = Acq_Status_HistoryController;
        //    return PopulateContentGrid(Convert.ToString(PageNo));
        //    //ViewBag.Message = message;
        //    //Dictionary<string, object> obj_Dictionary = new Dictionary<string, object>();
        //    //obj_Dictionary.Add("IsError", isError);
        //    //obj_Dictionary.Add("Message", message);
        //    //return Json(obj_Dictionary);
        //}
        public PartialViewResult PopulateContentGrid(string PgNo = "0", string txtPageSize = "", string FilterBy = "")

        {
            FilterByStatus = FilterBy;
            string search = "";
            string isPaging = "Y";
            int RecordCount = 0;
            if (PgNo == "")
                PgNo = "0";
            pageNo = Convert.ToInt32(PgNo) + 1;
            if (txtPageSize == "")
                recordPerPage = 10;
            else
                recordPerPage = Convert.ToInt32(txtPageSize);
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            List<USP_List_DM_Master_Import_Result> lst = new List<USP_List_DM_Master_Import_Result>();
            string orderByCndition = "T.DM_Master_Import_Code desc";
            if (FilterBy == "A")
                search += " AND DM.File_Type = 'C'";
            else if (FilterBy == "Q")
                search += " AND DM.File_Type = 'C' AND DM.Status IN('I','N','W')";
            else if (FilterBy == "E")
                search += " AND DM.File_Type = 'C' AND DM.Status IN('E','T')";
            else
                search += " AND DM.File_Type = 'C' AND DM.Status = '" + FilterBy + "'";

            lst = (new USP_Service(objLoginEntity.ConnectionStringName).USP_List_DM_Master_Import(search, pageNo, orderByCndition, isPaging,
                  recordPerPage, objRecordCount, objLoginUser.Users_Code).ToList());
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.FileType = "C";
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = pageNo;

            return PartialView("~/Views/Title_Content_ImportExport/Content_Import_List.cshtml", lst);
        }
        public JsonResult GetFileImportStatus(int dealCode)
        {
            string recordStatus = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.DM_Master_Import_Code == dealCode).Select(s => s.Status).FirstOrDefault();
            double TotalCount = new RightsU_BLL.DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode).Count();
            double SuccessCount = new RightsU_BLL.DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "C").Count();
            double ConflictCount = new RightsU_BLL.DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Is_Ignore == "N" && (x.Record_Status == "OR" || x.Record_Status == "MR" || x.Record_Status == "SM" || x.Record_Status == "MO" || x.Record_Status == "SO")).Count();
            double IgnoreCount = new RightsU_BLL.DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Is_Ignore == "Y").Count();
            double WaitingCount = new RightsU_BLL.DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "N" && x.Is_Ignore != "Y").Count();

            double ErrorCount = new RightsU_BLL.DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "E").Count();

            //double div = @MessageCount / @totalMessageCount;
            //double quotient = Convert.ToDouble(div);
            double Completion = (SuccessCount / TotalCount) * 100;
            double ErrorCompletion = (ErrorCount / TotalCount) * 100;
            double ConflictCompletion = (ConflictCount / TotalCount) * 100;
            double IgnoreCompletion = (IgnoreCount / TotalCount) * 100;
            double WaitingCompletion = (WaitingCount / TotalCount) * 100;
            var obj = new
            {
                RecordStatus = recordStatus,
                TotalCount = TotalCount,
                SuccessCount = SuccessCount,
                ConflictCount = ConflictCount,
                IgnoreCount = IgnoreCount,
                WaitingCount = WaitingCount,
                ErrorCount = ErrorCount,
                Completion = Convert.ToInt32(Completion),
                ErrorCompletion = Convert.ToInt32(ErrorCompletion),
                ConflictCompletion = Convert.ToInt32(ConflictCompletion),
                IgnoreCompletion = Convert.ToInt32(IgnoreCompletion),
                WaitingCompletion = Convert.ToInt32(WaitingCompletion)
            };
            return Json(obj);


        }
        public PartialViewResult BindContentError(int DM_Import_Master_Code, int pageNo = 0, int txtpagesize = 10, string File_Type = "")
        {
            List<DM_Content_Music> lst = new List<DM_Content_Music>();
            int PageNo = pageNo + 1;
            int RecordCount = 0;
            ViewBag.File_Type = File_Type;
            ViewBag.DM_Master_Import_Code = DM_Import_Master_Code;
            objDMContent = null;
            objDMContentService = null;
            objDMContent.DM_Master_Import_Code = DM_Import_Master_Code;

            List<DM_Content_Music> lstDMContent = new DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code == DM_Import_Master_Code && i.Record_Status == "E").ToList();
            RecordCount = lstDMContent.Count;
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = PageNo;
            int pageSize = txtpagesize;
            ViewBag.txtpageSize = txtpagesize;
            if (PageNo == 1)
                lst = lstDMContent.Take(pageSize).ToList();
            else
            {
                lst = lstDMContent.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lstDMContent.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList().Count == 0)
                {
                    if (PageNo != 1)
                    {
                        //objDeal_Schema.Budget_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst = lstDMContent.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }
            return PartialView("~/Views/Title_Content_ImportExport/_DM_Content_Error_List.cshtml", lst);
        }
        public JsonResult GetContentName(string Searched_User)
        {
            int DM_Import_Master_Code = 0;
            if (TempData["DM_Import_Master_Code"] != null)
                DM_Import_Master_Code = Convert.ToInt32(TempData["DM_Import_Master_Code"]);
            TempData.Keep("DM_Import_Master_Code");
            List<string> terms = Searched_User.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();

            //Extract the term to be searched from the list
            string searchString = terms.LastOrDefault().ToString().Trim();

            var result = new DM_Content_Music_Service(objLoginEntity.ConnectionStringName)
                          .SearchFor(x => x.DM_Master_Import_Code == DM_Import_Master_Code && x.Content_Name.ToUpper().Contains(searchString.ToUpper()))
                          .Select(R => new { Mapping_Name = R.Content_Name, Mapping_Code = R.Content_Name }).Distinct().ToList();

            return Json(result);
        }
        public PartialViewResult BindContentView(int DM_Master_Import_Code, string fileType = "")
        {
            ViewBag.DM_Master_Import_Code = DM_Master_Import_Code;
            ViewBag.FileType = fileType;
            return PartialView("~/Views/Title_Content_ImportExport/_DM_Content_View_List.cshtml");
        }
        public PartialViewResult BindContentViewList(int DM_Import_Master_Code, string SearchCriteria = "", string File_Type = "", string IsShowAll = "", string Error = "", int pageNo = 0, int txtpagesize = 10)
        {
            int pgNo = pageNo + 1;
            int RecordCount = 0;
            if (IsShowAll == "Y")
                clearAllAdvanceSearch();
            string Status = "";
            objPage_Properties.ContentName_Search = objPage_Properties.ContentName_Search.Replace('﹐', ',');
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            if (Error == "Y" && objPage_Properties.Status_Search == "")
                Status = "E";
            else if (Error == "N" && objPage_Properties.Status_Search == "")
                Status = "OR,MR,SM,MO,SO,C,P,N";
            else
                Status = objPage_Properties.Status_Search;
            objPage_Properties.chkStatus_Search = Status;
            lstContentBulkImport = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_ContentBulkImport(DM_Import_Master_Code, SearchCriteria, objPage_Properties.ContentName_Search, objPage_Properties.MusicTrack_Search, Status, objPage_Properties.ErrorMsg_Search, objPage_Properties.EpisodeNo_Search, pgNo, txtpagesize, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.FileType = File_Type;
            ViewBag.DM_Master_Import_Code = DM_Import_Master_Code;
            objDMContent = null;
            objDMContentService = null;
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = pgNo;
            ViewBag.txtpageSize = txtpagesize;
            TempData["DM_Import_Master_Code"] = DM_Import_Master_Code;
            return PartialView("~/Views/Title_Content_ImportExport/_Content_View_List.cshtml", lstContentBulkImport);
        }
        public void AdvanceSearch(string ContentName = "", string MusicTrackName = "", string EpisodeNo = "", string Status = "", string ErrorMsg = "")
        {
            objPage_Properties.ContentName_Search = ContentName;
            objPage_Properties.MusicTrack_Search = MusicTrackName;
            objPage_Properties.EpisodeNo_Search = EpisodeNo;
            objPage_Properties.Status_Search = Status;
            objPage_Properties.ErrorMsg_Search = ErrorMsg;
        }
        public PartialViewResult BindDMMasterLog(int DM_Import_Master_Code, string fileType = "")
        {
            lstDMCodes = "~" + DM_Import_Master_Code + "~";
            ViewBag.FileType = fileType;
            List<RightsU_Entities.DM_Master_Log> lst = new List<RightsU_Entities.DM_Master_Log>();
            DM_Master_Log lstDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code.Contains(lstDMCodes)).FirstOrDefault();
            DM_Content_Music lstDMContent = new DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code == DM_Import_Master_Code).FirstOrDefault();
            return PartialView("~/Views/Title_Content_ImportExport/_DM_Resolve_Conflict_List.cshtml", lstDMContent);
        }
        public PartialViewResult BindGrid(string masterImportCode, bool fetchData, bool isTabChanged, string currentTabName, string previousTabName, int pageNo, int recordPerPage)
        {
            // Session["lst_DM_Import_UDT"] = null;
            List<DM_Master_Log> lst = new List<DM_Master_Log>();
            List<DM_Content_Music> lstDM = new List<DM_Content_Music>();
            ViewBag.TabName = currentTabName;
            // string[] DMCodes = masterImportCode.Trim('~').Split('~');
            string code = lstDMCodes;
            int DMMasterCode = Convert.ToInt32(code.Trim('~'));
            string DMMasterLogCode = code.Trim('~');

            if (fetchData)
            {
                string status = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == DMMasterCode).Select(s => s.Status).First().ToString();
                if (status != "S")
                {
                    lstDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code == DMMasterLogCode
                    && (i.Master_Code == null || i.Master_Code == 0) && i.Is_Ignore == "N").ToList();
                }
                else
                {
                    lstDMLog = null;
                }

            }
            if (isTabChanged)
            {
                objConflictTabPaging.SetPropertyValue("PageNo_" + previousTabName, pageNo);
                objConflictTabPaging.SetPropertyValue("PageSize_" + previousTabName, recordPerPage);

                pageNo = (int)objConflictTabPaging.GetPropertyValue("PageNo_" + currentTabName);
                pageNo = (pageNo == 0) ? 1 : pageNo;
                recordPerPage = (int)objConflictTabPaging.GetPropertyValue("PageSize_" + currentTabName);
                recordPerPage = (recordPerPage == 0) ? 10 : recordPerPage;
            }
            else
            {
                objConflictTabPaging.SetPropertyValue("PageNo_" + currentTabName, pageNo);
                objConflictTabPaging.SetPropertyValue("PageSize_" + currentTabName, recordPerPage);
            }


            if (currentTabName == "CM")
            {

                ViewBag.RecordCount = lstDMLog.Where(i => i.Master_Type == "CM").Count();
                ViewBag.PageNo = pageNo;
                ViewBag.PageSize = recordPerPage;
                if (ViewBag.RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, ViewBag.RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    lst = lstDMLog.Where(w => w.Master_Type == "CM").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                return PartialView("~/Views/Title_Content_ImportExport/_DM_Resolve_Conflict.cshtml", lst);
            }
            else if (currentTabName == "SM")
            {
                string status = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == DMMasterCode).Select(s => s.Status).First().ToString();
                if (status != "I")
                {
                    SMDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code == DMMasterLogCode
                   && (i.Master_Code != null) && i.Is_Ignore == "N" && i.Mapped_By == "S").ToList();
                }
                else
                {
                    SMDMLog = null;
                }
                ViewBag.RecordCount = SMDMLog.Where(i => i.Master_Type == "CM").Count();
                ViewBag.PageNo = pageNo;
                ViewBag.PageSize = recordPerPage;

                if (ViewBag.RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, ViewBag.RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    lst = SMDMLog.Where(w => w.Master_Type == "CM").Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                return PartialView("~/Views/Title_Content_ImportExport/_DM_Resolve_Conflict_SystemMapping.cshtml", lst);
            }
            else
            {
                if (lstDMContent.Count == 0)
                {
                    string strcode = code.Trim('~');
                    lstDMContent = new DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code.ToString().Contains(strcode)
                     && (i.Record_Status == "OR" || i.Record_Status == "SO" || i.Record_Status == "MO") && i.Error_Tags != "").ToList();
                    //  pagelstDMContent = lstDMContent;
                }
                ViewBag.RecordCount = lstDMContent.Count();
                // ViewBag.RecordCount = pagelstDMContent.Count();
                ViewBag.PageNo = pageNo;
                ViewBag.PageSize = recordPerPage;
                //if (ViewBag.RecordCount > 0)
                //{
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, ViewBag.RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lstDM = lstDMContent.OrderBy(x => x.IntCode).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                // }
                return PartialView("~/Views/Title_Content_ImportExport/_DM_Resolve_Conflict_OtherTab.cshtml", lstDM);
            }
        }
        public ActionResult PopulateAutoCompleteData(string keyword)
        {
            dynamic result = "";
            result = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.ToUpper().Contains(keyword.ToUpper())).Where(y => y.Is_Active == "Y").Distinct()
                            .Select(R => new { Mapping_Name = R.Music_Title_Name, Mapping_Code = R.Music_Title_Code }).ToList();

            return Json(result);
        }
        public JsonResult BindMusicData(int MusicTitleCode, int MasterLogCode)
        {
            int? moviealbumCode = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Title_Code == MusicTitleCode).Select(s => s.Music_Album_Code).FirstOrDefault();
            string MovieAlbum = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Album_Code == moviealbumCode).Select(s => s.Music_Album_Name).FirstOrDefault();
            string MusicLanguage = new Music_Title_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Title_Code == MusicTitleCode).Select(s => s.Music_Language.Language_Name).FirstOrDefault();
            string MusicLabel = new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Title_Code == MusicTitleCode).Select(s => s.Music_Label.Music_Label_Name).FirstOrDefault();
            var obj = new
            {
                MovieAlbum = MovieAlbum,
                MusicLanguage = MusicLanguage,
                MusicLabel = MusicLabel
            };
            return Json(obj);
        }
        public ActionResult SaveMappedData(List<RightsU_Entities.DM_Master_Log> lst, List<RightsU_Entities.DM_Content_Music> lstOther, List<RightsU_Entities.DM_Master_Log> lstSystemMapLog)
        {
            string status = "", message = "";
            int mappedCount = 0;
            if (lstOther != null)
            {
                // lstDMContent = null;
                finallstDMContent = null;
                foreach (RightsU_Entities.DM_Content_Music objDMCM in lstOther)
                {
                    DM_Content_Music objDMContentMusic = lstDMContent.Where(w => w.IntCode == objDMCM.IntCode).FirstOrDefault();
                    objDMContent = new DM_Content_Music_Service(objLoginEntity.ConnectionStringName).GetById(objDMCM.IntCode);
                    lstDMContent.RemoveAll(x => x.IntCode == objDMContent.IntCode);
                    lstDMContent.Remove(objDMContent);
                    if (objDMCM.Is_Ignore == "True")
                        objDMContent.Is_Ignore = "Y";
                    else
                        objDMContent.Is_Ignore = "N";
                    if (objDMCM.From.Length >= 8)
                        objDMContent.From = objDMCM.From;
                    else
                        objDMContent.From = objDMCM.From += ":00";
                    if (objDMCM.To.Length >= 8)
                        objDMContent.To = objDMCM.To;
                    else
                        objDMContent.To = objDMCM.To += ":00";
                    if (objDMCM.Duration.Length >= 8)
                        objDMContent.Duration = objDMCM.Duration;
                    else
                        objDMContent.Duration = objDMCM.Duration += ":00";

                    objDMContent.From_Frame = objDMCM.From_Frame;
                    objDMContent.To_Frame = objDMCM.To_Frame;
                    objDMContent.Duration_Frame = objDMCM.Duration_Frame;
                    //objDMContent.EntityState = State.Modified;
                    // objDMContent.Record_Status = "S";
                    //objDMContentService.Save(objDMContent);
                    lstDMContent.Add(objDMContent);
                    finallstDMContent.Add(objDMContent);
                }
                mappedCount = finallstDMContent.Count;

            }
            if (lst != null)
            {

                foreach (RightsU_Entities.DM_Master_Log objDMTemp in lst)
                {
                    DM_Master_Log objDMLogT = lstDMLog.Where(w => w.DM_Master_Log_Code == objDMTemp.DM_Master_Log_Code).FirstOrDefault();
                    objDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).GetById(objDMTemp.DM_Master_Log_Code);
                    if (objDMLogT != null)
                    {
                        objDMLogT.IsIgnore = objDMTemp.IsIgnore;
                        if (objDMLogT.IsIgnore)
                        {
                            objDMLogT.Mapped_Name = null;
                            objDMLogT.Mapped_Code = null;
                        }
                        else
                        {
                            objDMLogT.Mapped_Name = objDMTemp.Mapped_Name;
                            objDMLogT.Mapped_Code = objDMTemp.Mapped_Code;
                        }
                    }
                    DM_Import_UDT objDMUDT = lst_DM_Import_UDT.Where(w => w.Key == objDMTemp.DM_Master_Log_Code.ToString()).FirstOrDefault();
                    if (objDMUDT == null)
                    {
                        objDMUDT = new DM_Import_UDT();
                        lst_DM_Import_UDT.Add(objDMUDT);
                    }

                    if (objDMLogT.IsIgnore || objDMTemp.Mapped_Code > 0)
                    {
                        objDMUDT.Key = objDMTemp.DM_Master_Log_Code.ToString();
                        objDMUDT.DM_Master_Type = objDMLogT.Master_Type;

                        if (objDMLogT.IsIgnore)
                            objDMUDT.value = "Y";
                        else
                            objDMUDT.value = objDMTemp.Mapped_Code.ToString();
                    }
                    else
                    {
                        lst_DM_Import_UDT.Remove(objDMUDT);
                    }
                }
                mappedCount = lst_DM_Import_UDT.Count;
            }
            if (lstSystemMapLog != null)
            {

                foreach (RightsU_Entities.DM_Master_Log objDMTemp in lstSystemMapLog)
                {
                    DM_Master_Log objDMLogT = SMDMLog.Where(w => w.DM_Master_Log_Code == objDMTemp.DM_Master_Log_Code).FirstOrDefault();
                    objDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).GetById(objDMTemp.DM_Master_Log_Code);
                    if (objDMLogT != null)
                    {
                        objDMLogT.Mapped_Name = objDMTemp.Mapped_Name;
                        objDMLogT.Mapped_Code = objDMTemp.Mapped_Code;
                    }
                    DM_Import_UDT objDMUDT = lst_DM_Import_UDT.Where(w => w.Key == objDMTemp.DM_Master_Log_Code.ToString()).FirstOrDefault();
                    if (objDMUDT == null)
                    {
                        objDMUDT = new DM_Import_UDT();
                        lst_DM_Import_UDT.Add(objDMUDT);
                    }

                    if (objDMTemp.Mapped_Code > 0)
                    {
                        objDMUDT.Key = objDMTemp.DM_Master_Log_Code.ToString();
                        objDMUDT.DM_Master_Type = objDMLogT.Master_Type;
                        objDMUDT.value = objDMTemp.Mapped_Code.ToString();
                    }
                    else
                    {
                        lst_DM_Import_UDT.Remove(objDMUDT);
                    }
                }
                mappedCount = lst_DM_Import_UDT.Count;
                if (mappedCount == 0)
                    mappedCount = 1;
            }
            var obj = new
            {
                Status = status,
                Message = message,
                MappedCount = mappedCount
            };
            return Json(obj);

        }
        public ActionResult MapData(string fileType)
        {
            string status = "", message = "";
            string DMCodes = "";
            if (objDMLog.DM_Master_Import_Code != null)
            {
                //string[] Code = "~2745~~2746~~2747".Trim('~').Split('~');
                DMCodes = objDMLog.DM_Master_Import_Code;
            }

            if (finallstDMContent != null)
            {
                DM_Master_Import_Code = finallstDMContent.Select(s => s.DM_Master_Import_Code).FirstOrDefault();
                foreach (RightsU_Entities.DM_Content_Music objDMCM in finallstDMContent)
                {
                    objDMCM.EntityState = State.Modified;
                    if (objDMCM.Record_Status == "OR")
                        objDMCM.Record_Status = "N";
                    else if (objDMCM.Record_Status == "MO")
                        objDMCM.Record_Status = "MR";
                    else if (objDMCM.Record_Status == "SO")
                        objDMCM.Record_Status = "SM";
                    //objDMCM.Record_Status = "C";
                    objDMContentService.Save(objDMCM);
                }
                lstDMContent = null;
                finallstDMContent = null;
                if (objDMLog.DM_Master_Import_Code == null)
                {
                    List<USP_Content_Music_PII> lstDMMapping = new List<USP_Content_Music_PII>();
                    lstDMMapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Content_Music_PII(lst_DM_Import_UDT, DM_Master_Import_Code, objLoginUser.Users_Code).ToList();
                    Session["lst_DM_Import_UDT"] = null;
                    if (lstDMMapping.Count == 0)
                    {
                        message = "Data Mapped successfully";
                        status = "S";

                    }
                    else
                    {
                        status = "E";
                        message = "Please Map atleast one Record";
                    }
                }
            }
            //foreach (string DMMasterCode in DMCodes)
            //{
            if (!String.IsNullOrEmpty(DMCodes))
            {
                DM_Master_Import_Code = Convert.ToInt32(DMCodes.Trim());
                //string DM_Master_Import_Codes = DMMasterCode;

                //int ContentCount = 0;
                //ContentCount = new USP_Service(objLoginEntity.ConnectionStringName).USP_Content_Music_PII(lst_DM_Import_UDT, DM_Master_Import_Code).First();
                List<USP_Content_Music_PII> lstDMMapping = new List<USP_Content_Music_PII>();
                lstDMMapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Content_Music_PII(lst_DM_Import_UDT, DM_Master_Import_Code, objLoginUser.Users_Code).ToList();
                Session["lst_DM_Import_UDT"] = null;
                if (lstDMMapping.Count == 0)
                {
                    message = "Data Mapped successfully";
                    status = "S";

                }
                else
                {
                    status = "E";
                    message = "Please Map atleast one Record";
                }
            }
            //}

            //BindGrid(DM_Master_Import_Code,true, false,)
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public ActionResult BackTitleContent()
        {
            lstExcelErrorList = null;
            return RedirectToAction("Index", "Title_Content");
        }

        public JsonResult ExportData(List<USP_List_Content_Result> lst)
        {
            string status = "S", message = "Export successfully";
            string filename = "", host = "";
            try
            {

                List<ExportList> lstExportList = new List<ExportList>();

                foreach (var item in lst)
                {
                    ExportList objExportList = new ExportList();
                    objExportList.Channel_Name = item.Channel_Name;
                    objExportList.Duration_In_Min = item.Duration_In_Min;
                    objExportList.Episode = item.Episode;
                    objExportList.Episode_No = Convert.ToInt32(item.Episode.Substring(8));
                    objExportList.Last_Updated_Time = item.Last_Updated_Time;
                    objExportList.NumberOfSongs = item.NumberOfSongs;
                    objExportList.Title_Content_Code = item.Title_Content_Code;
                    objExportList.Title_Name = item.Title_Name;

                    lstExportList.Add(objExportList);
                }

                FileInfo flInfo = new FileInfo(HttpContext.Server.MapPath("~/UploadFolder/Music_Content_" + DateTime.Now.ToString("ddMMyyyyhhmmss.fff") + ".xlsx"));
                filename = flInfo.Name.ToString();
                FileInfo fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Music_Content_Sample.xlsx"));

                DataTable dt = new DataTable();
                dt = ToDataTable(lstExportList.Where(i => i.Title_Content_Code > 0));
                dt.Columns.Add("Int_Episode");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dt.Rows[i][7] = Convert.ToInt32(dt.Rows[i][1].ToString().Substring(8));
                }
                dt.DefaultView.Sort = "Title_Name ASC, Episode_No asc";
                dt = dt.DefaultView.ToTable();
                using (ExcelPackage package = new ExcelPackage(flInfo, fliTemplate))
                {
                    ExcelWorksheet worksheet = package.Workbook.Worksheets[1];
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        worksheet.Cells[i + 2, 2].Value = dt.Rows[i][0];//Content
                        worksheet.Cells[i + 2, 3].Value = dt.Rows[i][1];//Episode
                        worksheet.Cells[i + 2, 4].Value = dt.Rows[i][2];//Duration
                        worksheet.Cells[i + 2, 5].Value = "Standard";
                        worksheet.Cells[i + 2, 13].Value = dt.Rows[i][4];//Title Content Code                     
                    }
                    package.Save();
                }
                host = Request.Url.Host;
                status = "S";
            }
            catch (Exception ex)
            {
                status = "E";
                message = ex.Message;
            }

            var obj = new
            {
                Status = status,
                Message = message,
                FileName = filename,
                Host = host
            };
            return Json(obj);
        }
        public void DeleteUploadFile(string fileName)
        {
            try
            {
                FileInfo flInfo = new FileInfo(HttpContext.Server.MapPath("~/UploadFolder/" + fileName));
                flInfo.Delete();
            }
            catch
            {

            }
        }

        public DataTable ToDataTable<T>(IEnumerable<T> collection)
        {
            DataTable dt = new DataTable("DataTable");
            System.Type t = typeof(T);
            PropertyInfo[] pia = t.GetProperties();

            //Inspect the properties and create the columns in the DataTable
            foreach (PropertyInfo pi in pia)
            {
                System.Type ColumnType = pi.PropertyType;
                if ((ColumnType.IsGenericType))
                {
                    ColumnType = ColumnType.GetGenericArguments()[0];
                }
                dt.Columns.Add(pi.Name, ColumnType);
            }

            //Populate the data table
            foreach (T item in collection)
            {
                DataRow dr = dt.NewRow();
                dr.BeginEdit();
                foreach (PropertyInfo pi in pia)
                {
                    if (pi.GetValue(item, null) != null)
                    {
                        dr[pi.Name] = pi.GetValue(item, null);
                    }
                }
                dr.EndEdit();
                dt.Rows.Add(dr);
            }
            return dt;
        }

        public PartialViewResult BindExcelErrorList(int pageNo, int recordPerPage)
        {
            int newPageNo = 0;
            List<USP_Content_Music_Link_Bulk_Insert_UDT> lst = GetExcelErrorList(pageNo, recordPerPage, out newPageNo);
            ViewBag.RecordCount = lstExcelErrorList.Count;
            return PartialView("~/Views/Title_Content_ImportExport/_Excel_Error_List.cshtml", lst);
        }

        private List<USP_Content_Music_Link_Bulk_Insert_UDT> GetExcelErrorList(int pageNo, int recordPerPage, out int newPageNo)
        {
            List<USP_Content_Music_Link_Bulk_Insert_UDT> lst = new List<USP_Content_Music_Link_Bulk_Insert_UDT>();
            int RecordCount = 0;
            RecordCount = lstExcelErrorList.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstExcelErrorList.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            newPageNo = pageNo;
            return lst;
        }

        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }
        public JsonResult ShowError(string ErrorCode = "")
        {
            string ErrorDes = new Error_Code_Master_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Upload_Error_Code == ErrorCode.Trim() && x.Error_For == "MCBI").FirstOrDefault().Error_Description;

            //if (Mode == "V")
            //{
            //    return PartialView("_List_Aired_Status_History", LSTMSH);
            //}
            //else
            //    return PartialView("_ApproveOrReject", LSTMSH);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Error_Description", ErrorDes);
            return Json(obj);
        }
        public JsonResult BindAdvanced_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            int DM_Import_Master_Code = 0;
            string ErrorMsg = "";
            if (TempData["DM_Import_Master_Code"] != null)
                DM_Import_Master_Code = Convert.ToInt32(TempData["DM_Import_Master_Code"]);
            TempData.Keep("DM_Import_Master_Code");
            List<RightsU_Entities.DM_Content_Music> lstDMContent = new DM_Content_Music_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            MultiSelectList lstContent = new MultiSelectList(lstDMContent.Where(x => x.DM_Master_Import_Code == DM_Import_Master_Code)
                .Select(i => new { Display_Value = i.Content_Name, Display_Text = i.Content_Name }).Distinct().ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstMusicTrack = new MultiSelectList(lstDMContent.Where(x => x.DM_Master_Import_Code == DM_Import_Master_Code && x.Music_Track != "" && x.Music_Track != null)
                .Select(i => new { Display_Value = i.Music_Track, Display_Text = i.Music_Track }).Distinct().ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstEpisodeNos = new MultiSelectList(lstDMContent.Where(x => x.DM_Master_Import_Code == DM_Import_Master_Code && x.Episode_No != null)
                .Select(i => new { Display_Value = i.Episode_No, Display_Text = i.Episode_No }).Distinct().ToList(), "Display_Value", "Display_Text");
            List<string> lstErrorMsg1 = lstDMContent.Where(x => x.DM_Master_Import_Code == DM_Import_Master_Code && x.Error_Message != "" && x.Error_Message != null).Select(x => x.Error_Message).Distinct().ToList();
            foreach (string Msg in lstErrorMsg1)
            {
                ErrorMsg += Msg;
            }
            string[] lstErrMsg = ErrorMsg.Split(new char[] { '~' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList lstErrorMsg = new MultiSelectList(lstErrMsg.Select(i => new { Display_Value = i, Display_Text = i }),
                "Display_Value", "Display_Text");
            List<SelectListItem> lstStatus = new List<SelectListItem>();
            //lstStatus.Add(new SelectListItem { Text = "Select", Value = " "});
            lstStatus.Add(new SelectListItem { Text = "Ignore", Value = "Y" });
            lstStatus.Add(new SelectListItem { Text = "Success", Value = "C" });
            lstStatus.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstStatus.Add(new SelectListItem { Text = "No Error", Value = "N" });
            lstStatus.Add(new SelectListItem { Text = "Proceed", Value = "P" });
            lstStatus.Add(new SelectListItem { Text = "Resolve Conflict", Value = "OR,MR,SM,MO,SO" });
            lstStatus.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });

            objJson.Add("lstContent", lstContent);
            objJson.Add("lstMusicTrack", lstMusicTrack);
            objJson.Add("lstStatus", lstStatus);
            objJson.Add("lstErrorMsg", lstErrorMsg);
            objJson.Add("lstEpisodeNos", lstEpisodeNos);

            if (objPage_Properties.ContentName_Search != "" && objPage_Properties.ContentName_Search != null)
                objPage_Properties.ContentName_Search = objPage_Properties.ContentName_Search;
            else
                objPage_Properties.ContentName_Search = "";

            if (objPage_Properties.MusicTrack_Search != "" && objPage_Properties.MusicTrack_Search != null)
                objPage_Properties.MusicTrack_Search = objPage_Properties.MusicTrack_Search;
            else
                objPage_Properties.MusicTrack_Search = "";

            if (objPage_Properties.Status_Search != "" && objPage_Properties.Status_Search != null)
                objPage_Properties.Status_Search = objPage_Properties.Status_Search;
            else
                objPage_Properties.Status_Search = "";

            if (objPage_Properties.ErrorMsg_Search != "" && objPage_Properties.ErrorMsg_Search != null)
                objPage_Properties.ErrorMsg_Search = objPage_Properties.ErrorMsg_Search;
            else
                objPage_Properties.ErrorMsg_Search = "";

            if (objPage_Properties.EpisodeNo_Search != "" && objPage_Properties.EpisodeNo_Search != null)
                objPage_Properties.EpisodeNo_Search = objPage_Properties.EpisodeNo_Search;
            else
                objPage_Properties.EpisodeNo_Search = "";

            objJson.Add("objPage_Properties", objPage_Properties);
            return Json(objJson);
        }

        public void ExportToExcel(int DM_Import_Master_Code = 0, string FileType = "", string SearchCriteria = "")
        {
            string sql = "";

            string searchContentName = objPage_Properties.ContentName_Search.Replace(",", "','");
            string searchMTString = objPage_Properties.MusicTrack_Search.Replace(",", "','");
            string searchStatus = objPage_Properties.Status_Search.Replace(",", "','");
            string searchChkStatus = objPage_Properties.chkStatus_Search.Replace(",", "','");
            string searchErrorMsg = objPage_Properties.ErrorMsg_Search.Replace(",", "','");
            string searchEpisodeNos = objPage_Properties.EpisodeNo_Search.Replace(",", "','");

            if (objPage_Properties.ContentName_Search != "")
                sql += " AND [Content_Name] IN(" + "'" + searchContentName + "')";
            if (objPage_Properties.MusicTrack_Search != "")
                sql += " AND [Music_Track] IN(" + "'" + searchMTString + "')";
            if (objPage_Properties.Status_Search != "" && objPage_Properties.Status_Search != "Y")
                sql += " AND [Record_Status] IN(" + "'" + searchStatus + "')";
            if (objPage_Properties.Status_Search != "" && objPage_Properties.Status_Search == "Y")
                sql += " AND [Is_Ignore] IN(" + "'" + searchStatus + "')";
            if (objPage_Properties.chkStatus_Search != "" && objPage_Properties.chkStatus_Search != "Y")
                sql += " AND [Record_Status] IN(" + "'" + searchChkStatus + "')";
            if (objPage_Properties.ErrorMsg_Search != "")
                sql += " AND TCEM.ErrorMsg IN(" + "'" + searchErrorMsg + "')";
            if (objPage_Properties.EpisodeNo_Search != "")
                sql += " AND Episode_No IN(" + "'" + searchEpisodeNos + "')";

            ReportViewer1 = new ReportViewer();
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            ReportParameter[] parm = new ReportParameter[4];

            parm[0] = new ReportParameter("DM_Master_Import_Code", Convert.ToString(DM_Import_Master_Code));
            parm[1] = new ReportParameter("SearchCriteria", SearchCriteria);
            parm[2] = new ReportParameter("File_Type", FileType);
            parm[3] = new ReportParameter("AdvanceSearch", Convert.ToString(sql));

            ReportCredential();
            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptExportToExcelBulkImport");
            }
            ReportViewer1.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer1.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename=ContentMusicDetails.xls");
            Response.OutputStream.Write(buffer, 0, buffer.Length);
            Response.End();

        }
        public byte[] SerializeData(Object o)
        {
            MemoryStream ms = new MemoryStream();
            BinaryFormatter bf1 = new BinaryFormatter();
            bf1.Serialize(ms, o);
            return ms.ToArray();
        }
        public void ReportCredential()
        {
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

            string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
            string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];

                ReportViewer1.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
            }

            ReportViewer1.Visible = true;
            ReportViewer1.ServerReport.Refresh();
            ReportViewer1.ProcessingMode = ProcessingMode.Remote;
            if (ReportViewer1.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
            {
                ReportViewer1.ServerReport.ReportServerUrl = new Uri(ConfigurationManager.AppSettings["ReportingServer"]);
            }
        }
        public void clearAllAdvanceSearch()
        {
            objPage_Properties.ContentName_Search = "";
            objPage_Properties.MusicTrack_Search = "";
            objPage_Properties.Status_Search = "";
            objPage_Properties.ErrorMsg_Search = "";
            objPage_Properties.EpisodeNo_Search = "";
        }
    }

    public class ExportList
    {
        public string Title_Name { get; set; }
        public string Episode { get; set; }
        public decimal Duration_In_Min { get; set; }
        public Nullable<int> NumberOfSongs { get; set; }
        public int Title_Content_Code { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public string Channel_Name { get; set; }
        public int Episode_No { get; set; }
    }
    internal class ConflictTabPaging
    {
        public int PageNo_CM { get; set; }
        public int PageSize_CM { get; set; }
        public int PageNo_OT { get; set; }
        public int PageSize_OT { get; set; }
        public int PageNo_SM { get; set; }
        public int PageSize_SM { get; set; }

        public object GetPropertyValue(string propertyName)
        {
            object value = this.GetType().GetProperty(propertyName).GetValue(this, null);
            return value;
        }
        public void SetPropertyValue(string propertyName, object value)
        {
            PropertyInfo propertyInfo = this.GetType().GetProperty(propertyName);
            propertyInfo.SetValue(this, Convert.ChangeType(value, propertyInfo.PropertyType), null);

        }
    }
    public class ContentBulkImportSearch
    {
        public string ContentName_Search { get; set; }
        public string MusicTrack_Search { get; set; }
        public string Status_Search { get; set; }
        public string ErrorMsg_Search { get; set; }
        public string EpisodeNo_Search { get; set; }
        public string chkStatus_Search { get; set; }
    }
}
