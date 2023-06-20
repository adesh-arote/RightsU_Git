using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using RightsU_BLL;
using System.Data.Entity.Core.Objects;
using System.Reflection;
using System.Text;
using System.Globalization;
using UTOFrameWork.FrameworkClasses;
using Microsoft.Reporting.WebForms;
using System.Configuration;

namespace RightsU_Plus.Controllers
{
    public class DM_Master_ImportController : BaseController
    {
        ReportViewer ReportViewer1;
        public List<USP_DM_Music_Title_PI> lstError
        {
            get
            {
                if (Session["lstError_Session"] == null)
                    Session["lstError_Session"] = new List<USP_DM_Music_Title_PI>();
                return (List<USP_DM_Music_Title_PI>)Session["lstError_Session"];
            }
            set { Session["lstError_Session"] = value; }
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
        public DM_Music_Title objDMMusic
        {
            get
            {
                if (Session["objDMMusic"] == null)
                    Session["objDMMusic"] = new DM_Music_Title();
                return (DM_Music_Title)Session["objDMMusic"];
            }
            set { Session["objDMMusic"] = value; }
        }
        public DM_Music_Title_Service objDMMusicService
        {
            get
            {
                if (Session["objDMMusicService"] == null)
                    Session["objDMMusicService"] = new DM_Music_Title_Service(objLoginEntity.ConnectionStringName);
                return (DM_Music_Title_Service)Session["objDMMusicService"];
            }
            set { Session["objDMMusicService"] = value; }
        }
        public DM_Title objDMTitle
        {
            get
            {
                if (Session["objDMTitle"] == null)
                    Session["objDMTitle"] = new DM_Title();
                return (DM_Title)Session["objDMTitle"];
            }
            set { Session["objDMTitle"] = value; }
        }
        public DM_Title_Service objDMTitleService
        {
            get
            {
                if (Session["objDMTitleService"] == null)
                    Session["objDMTitleService"] = new DM_Title_Service(objLoginEntity.ConnectionStringName);
                return (DM_Title_Service)Session["objDMTitleService"];
            }
            set { Session["objDMTitleService"] = value; }
        }
        public List<DM_Master_Import> lst_DM_Master_Import
        {
            get
            {
                if (Session["lst_DM_Master_Import"] == null)
                    Session["lst_DM_Master_Import"] = new List<DM_Master_Import>();
                return (List<DM_Master_Import>)Session["lst_DM_Master_Import"];
            }
            set { Session["lst_DM_Master_Import"] = value; }
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
        public List<DM_Master_Log> lstSystemDMLog
        {
            get
            {
                if (Session["lstSystemDMLog"] == null)
                    Session["lstSystemDMLog"] = new List<DM_Master_Log>();
                return (List<DM_Master_Log>)Session["lstSystemDMLog"];
            }
            set { Session["lstSystemDMLog"] = value; }
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
        public int? DM_Master_Import_CodeMT
        {
            get
            {
                if (Session["DM_Master_Import_CodeMT"] == null)
                    Session["DM_Master_Import_CodeMT"] = 0;
                return (int)Session["DM_Master_Import_CodeMT"];
            }
            set { Session["DM_Master_Import_CodeMT"] = value; }
        }
        public int IpageNo
        {
            get
            {
                if (Session["iPageNo"] == null)
                    Session["iPageNo"] = 1;
                return (int)Session["iPageNo"];
            }
            set { Session["iPageNo"] = value; }
        }
        private int _recordPerPage = 10;
        public int recordPerPage
        {
            get { return _recordPerPage; }
            set { _recordPerPage = value; }
        }
        private TabPaging objTabPaging
        {
            get
            {
                if (Session["objTabPaging"] == null)
                    Session["objTabPaging"] = new TabPaging();
                return (TabPaging)Session["objTabPaging"];
            }
            set { Session["objTabPaging"] = value; }
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
        public List<Talent_Validation> lstobjTV
        {
            get
            {
                if (Session["lstobjTV"] == null)
                    Session["lstobjTV"] = new List<Talent_Validation>();
                return (List<Talent_Validation>)Session["lstobjTV"];
            }
            set { Session["lstobjTV"] = value; }
        }
        private List<RightsU_Entities.USP_List_TitleBulkImport_Result> lstTitleBulkImport
        {
            get
            {
                if (Session["lstTitleBulkImport"] == null)
                    Session["lstTitleBulkImport"] = new List<RightsU_Entities.USP_List_TitleBulkImport_Result>();
                return (List<RightsU_Entities.USP_List_TitleBulkImport_Result>)Session["lstTitleBulkImport"];
            }
            set { Session["lstTitleBulkImport"] = value; }
        }
        private List<RightsU_Entities.USP_List_MusicTrackBulkImport_Result> lstMusicTrackBulkImport
        {
            get
            {
                if (Session["lstMusicTrackBulkImport"] == null)
                    Session["lstMusicTrackBulkImport"] = new List<RightsU_Entities.USP_List_MusicTrackBulkImport_Result>();
                return (List<RightsU_Entities.USP_List_MusicTrackBulkImport_Result>)Session["lstMusicTrackBulkImport"];
            }
            set { Session["lstMusicTrackBulkImport"] = value; }
        }
        private TitleBulkImportSearch objPage_Properties
        {
            get
            {
                if (Session["TitleBulkImportSearch_Page_Properties"] == null)
                    Session["TitleBulkImportSearch_Page_Properties"] = new TitleBulkImportSearch();
                return (TitleBulkImportSearch)Session["TitleBulkImportSearch_Page_Properties"];
            }
            set { Session["TitleBulkImportSearch_Page_Properties"] = value; }
        }
        private MusicTitleBulkImportSearch objPg_Properties
        {
            get
            {
                if (Session["MusicTitleBulkImportSearch_Page_Properties"] == null)
                    Session["MusicTitleBulkImportSearch_Page_Properties"] = new MusicTitleBulkImportSearch();
                return (MusicTitleBulkImportSearch)Session["MusicTitleBulkImportSearch_Page_Properties"];
            }
            set { Session["MusicTitleBulkImportSearch_Page_Properties"] = value; }
        }
        private List<RightsU_Entities.USPListResolveConflict_Result> lstResolveConflict
        {
            get
            {
                if (Session["lstResolveConflict"] == null)
                    Session["lstResolveConflict"] = new List<RightsU_Entities.USPListResolveConflict_Result>();
                return (List<RightsU_Entities.USPListResolveConflict_Result>)Session["lstResolveConflict"];
            }
            set { Session["lstResolveConflict"] = value; }
        }
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), 0);
            return View();
        }
        public PartialViewResult UploadTitle(HttpPostedFileBase InputFile, string txtpageSize, string FilterBy)
        {
            var MusicTitleVersion = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "SPN_Music_Version").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsMuciVersionSPN = MusicTitleVersion;
            string status = "S";
            string Modified_Data = "N";
            Session["SearchedMusicTitle_EDIT"] = null;
            string message = "";
            string sheetName = "MusicTitle$";
            int pageSize = 10;
            int PageNo = 0;
            List<USP_DM_Music_Title_PI> lstRE = new List<USP_DM_Music_Title_PI>();
            List<DM_Master_Import> lst_DM_Master_Import = new List<DM_Master_Import>();
            DM_Master_Import obj_DM_Master_Import = new DM_Master_Import();
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = InputFile;
                //string fullPath = (Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]);
                string fullPath = (Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"]);
                string ext = System.IO.Path.GetExtension(PostedFile.FileName);
                if (ext == ".xlsx" || ext == ".xls")
                {
                    ExcelReader objExcelReader = new ExcelReader();
                    DataSet ds = new DataSet();

                    try
                    {
                        //throw new Exception("Anchal " + fullPath);
                        string errorStr = "";
                        //arrSameSheetDataForDuplicate = new ArrayList();


                        string strActualFileNameWithDate;
                        // string path = senderWebForm.Request.ServerVariables["APPL_PHYSICAL_PATH"];
                        string strFileName = System.IO.Path.GetFileName(PostedFile.FileName);
                        //If excel sheet is of extension other than ".xls" ~or~ path is wrong for file to be uploaded.
                        if ((ext.ToLower() != ".xls" && ext.ToLower() != ".xlsx") || (PostedFile.ContentLength <= 0))
                        {
                            errorStr = "Please upload Excel Sheet named as " + sheetName.Trim() + " only with .xlsx extension.";
                            //return true;
                        }
                        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                        string fullpathname = fullPath + strActualFileNameWithDate; ;

                        // throw new Exception("Anchal " + fullpathname);
                        PostedFile.SaveAs(fullpathname);
                        OleDbConnection cn;
                        ds = new DataSet();
                        try
                        {
                            cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1'");
                            OleDbCommand cmdExcel = new OleDbCommand();
                            OleDbDataAdapter oda = new OleDbDataAdapter();
                            cmdExcel.Connection = cn;
                            //string sheetName = "Sheet1$";

                            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + sheetName + "]", cn);
                            da.Fill(ds);

                            //cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1'");
                            //OleDbCommand cmdExcel = new OleDbCommand();
                            //OleDbDataAdapter oda = new OleDbDataAdapter();
                            //DataTable dt = new DataTable();
                            //cmdExcel.Connection = cn;

                            ////Get the name of First Sheet
                            //cn.Open();
                            //DataTable dtExcelSchema;
                            //dtExcelSchema = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                            //string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                            //cn.Close();
                            //OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + SheetName + "]", cn);
                            //da.Fill(ds);
                        }
                        catch (Exception ex)
                        {
                            //If error in select of sheet data.....
                            errorStr = "Please upload excel sheet named as \\'" + sheetName.Trim() + "\\'";
                        }
                        finally
                        {
                            //Always delete uploaded excel file from folder.
                            System.IO.File.Delete(fullpathname.Trim());
                        }
                        if (status != "E")
                        {
                            var count = ds.Tables.Count;
                            if (count == 0)
                            {
                                message = "'" + sheetName.Trim('$') + "'" + " Sheet name should not be existing in uploaded excel";
                                status = "E";
                            }
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


                            if (MusicTitleVersion == "Y")
                            {
                                if (ds.Tables[0].Columns[0].ColumnName != "Sr. No" || ds.Tables[0].Columns[1].ColumnName != "Music Track" || ds.Tables[0].Columns[2].ColumnName != "Length"
                              || ds.Tables[0].Columns[3].ColumnName != "Movie/Album" || ds.Tables[0].Columns[4].ColumnName != "Singer"
                              || ds.Tables[0].Columns[5].ColumnName != "Lyricist" || ds.Tables[0].Columns[6].ColumnName != "Music Composer"
                              || ds.Tables[0].Columns[7].ColumnName != "Music Language" || ds.Tables[0].Columns[8].ColumnName != "Music Label"
                              || ds.Tables[0].Columns[9].ColumnName != "Year of Release" || ds.Tables[0].Columns[10].ColumnName != "Music Type"
                              || ds.Tables[0].Columns[11].ColumnName != "Genres" || ds.Tables[0].Columns[12].ColumnName != "Song Star Cast"
                              || ds.Tables[0].Columns[13].ColumnName != "Music Version" || ds.Tables[0].Columns[14].ColumnName != "Effective Start Date (DD-MMM-YYYY)"
                              || ds.Tables[0].Columns[15].ColumnName != "Music Theme" || ds.Tables[0].Columns[16].ColumnName != "Music Tag"
                              || ds.Tables[0].Columns[17].ColumnName != "Movie Star Cast" || ds.Tables[0].Columns[18].ColumnName != "Movie/Album Type"
                              || ds.Tables[0].Columns[19].ColumnName != "Public Domain")
                                {
                                    Modified_Data = "Y";
                                }
                            }
                            if (MusicTitleVersion == "N")
                            {
                                if (ds.Tables[0].Columns[0].ColumnName != "Sr. No" || ds.Tables[0].Columns[1].ColumnName != "Music Track" || ds.Tables[0].Columns[2].ColumnName != "Length"
                              || ds.Tables[0].Columns[3].ColumnName != "Movie/Album" || ds.Tables[0].Columns[4].ColumnName != "Singer"
                              || ds.Tables[0].Columns[5].ColumnName != "Lyricist" || ds.Tables[0].Columns[6].ColumnName != "Music Composer"
                              || ds.Tables[0].Columns[7].ColumnName != "Music Language" || ds.Tables[0].Columns[8].ColumnName != "Music Label"
                              || ds.Tables[0].Columns[9].ColumnName != "Year of Release" || ds.Tables[0].Columns[10].ColumnName != "Music Type"
                              || ds.Tables[0].Columns[11].ColumnName != "Genres" || ds.Tables[0].Columns[12].ColumnName != "Song Star Cast"
                              || ds.Tables[0].Columns[13].ColumnName != "Music Version" || ds.Tables[0].Columns[14].ColumnName != "Effective Start Date (DD-MMM-YYYY)"
                              || ds.Tables[0].Columns[15].ColumnName != "Music Theme" || ds.Tables[0].Columns[16].ColumnName != "Music Tag"
                              || ds.Tables[0].Columns[17].ColumnName != "Movie Star Cast" || ds.Tables[0].Columns[18].ColumnName != "Movie/Album Type")
                                {
                                    Modified_Data = "Y";
                                }
                            }
                            if (Modified_Data == "Y")
                            {
                                message = "Please Don't Modify the name of the field in excel File";
                                status = "E";
                            }
                            else
                            {
                                if (ds.Tables[0].Columns.Count >= 16)
                                {
                                    if (ds.Tables[0].Rows.Count > 0)
                                    {
                                        dynamic resultSet;
                                        List<Music_Title_Import_UDT> lst_Title_Import_UDT = new List<Music_Title_Import_UDT>();

                                        obj_DM_Master_Import.File_Name = PostedFile.FileName;
                                        obj_DM_Master_Import.System_File_Name = PostedFile.FileName;
                                        obj_DM_Master_Import.Upoaded_By = Convert.ToInt32(objLoginUser.Users_Code);
                                        obj_DM_Master_Import.Uploaded_Date = DateTime.Now;
                                        obj_DM_Master_Import.Action_By = objLoginUser.Users_Code;
                                        obj_DM_Master_Import.Action_On = DateTime.Now;
                                        obj_DM_Master_Import.Status = "N";
                                        obj_DM_Master_Import.File_Type = "M";
                                        obj_DM_Master_Import.EntityState = State.Added;
                                        lst_DM_Master_Import.Add(obj_DM_Master_Import);
                                        objDMService.Save(obj_DM_Master_Import, out resultSet);

                                        foreach (DataRow row in ds.Tables[0].Rows)
                                        {
                                            Music_Title_Import_UDT obj_Title_Import_UDT = new Music_Title_Import_UDT();

                                            obj_Title_Import_UDT.Music_Title_Name = row["Music Track"].ToString();
                                            obj_Title_Import_UDT.Duration = row["Length"].ToString();
                                            obj_Title_Import_UDT.Movie_Album = row["Movie/Album"].ToString();
                                            obj_Title_Import_UDT.Singers = row["Singer"].ToString();
                                            obj_Title_Import_UDT.Lyricist = row["Lyricist"].ToString();
                                            obj_Title_Import_UDT.Music_Director = row["Music Composer"].ToString();
                                            obj_Title_Import_UDT.Title_Language = row["Music Language"].ToString();
                                            obj_Title_Import_UDT.Music_Label = row["Music Label"].ToString();
                                            obj_Title_Import_UDT.Year_of_Release = row["Year of Release"].ToString();
                                            obj_Title_Import_UDT.Title_Type = row["Music Type"].ToString();
                                            obj_Title_Import_UDT.Genres = row["Genres"].ToString();
                                            obj_Title_Import_UDT.Star_Cast = row["Song Star Cast"].ToString();
                                            obj_Title_Import_UDT.Music_Version = row["Music Version"].ToString();
                                            obj_Title_Import_UDT.Effective_Start_Date = row["Effective Start Date (DD-MMM-YYYY)"].ToString();
                                            obj_Title_Import_UDT.Theme = row["Music Theme"].ToString();
                                            obj_Title_Import_UDT.Music_Tag = row["Music Tag"].ToString();
                                            obj_Title_Import_UDT.Movie_Star_Cast = row["Movie Star Cast"].ToString();
                                            obj_Title_Import_UDT.Music_Album_Type = row["Movie/Album Type"].ToString();
                                            obj_Title_Import_UDT.DM_Master_Import_Code = obj_DM_Master_Import.DM_Master_Import_Code.ToString();
                                            obj_Title_Import_UDT.Excel_Line_No = row["Sr. No"].ToString();
                                            if (MusicTitleVersion == "Y")
                                            {
                                                obj_Title_Import_UDT.Public_Domain = row["Public Domain"].ToString();
                                            }
                                            else
                                                obj_Title_Import_UDT.Public_Domain = "";
                                            lst_Title_Import_UDT.Add(obj_Title_Import_UDT);
                                        }

                                        lstError = new USP_Service(objLoginEntity.ConnectionStringName).USP_DM_Music_Title_PI(lst_Title_Import_UDT, Convert.ToInt32(objLoginUser.Users_Code)).ToList();

                                        if (lstError.Count == 0)
                                        {
                                            message = "File uploaded successfully";
                                            status = "S";
                                        }
                                        //    return PartialView("_TitleImport_List", lstRE);
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
                    message = "Please Select Excel File...";
                    status = "E";
                }

            }
            else
            {
                message = "Please Select Excel File...";
                status = "E";

            }

            ViewBag.File_Type = obj_DM_Master_Import.File_Type;
            ViewBag.Message = message;
            ViewBag.status = status;
            return PopulateMusicGrid(Convert.ToString(PageNo), txtpageSize, FilterBy);
            //return PartialView("_MusicTitleImport_List", lstError);
        }
        public PartialViewResult PopulateMusicGrid(string PgNo = "0", string txtPageSize = "", string FilterBy = "")
        {
            TempData["FilterByStatus"] = FilterBy;
            string search = "";
            string isPaging = "Y";
            int RecordCount = 0;
            if (PgNo == "")
                PgNo = "0";
            pageNo = Convert.ToInt32(PgNo) + 1;
            TempData["PageNoBack"] = pageNo;
            TempData["txtPageSizeBack"] = txtPageSize;
            if (txtPageSize == "")
                recordPerPage = 10;
            else
                recordPerPage = Convert.ToInt32(txtPageSize);
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            List<USP_List_DM_Master_Import_Result> lst = new List<USP_List_DM_Master_Import_Result>();
            string orderByCndition = "T.DM_Master_Import_Code desc";
            if (FilterBy == "A")
                search += " AND DM.File_Type = 'M'";
            else if (FilterBy == "Q")
                search += " AND DM.File_Type = 'M' AND DM.Status IN('I','Q','W')";
            else if (FilterBy == "E")
                search += " AND DM.File_Type = 'M' AND DM.Status IN('E','T')";
            else
                search += " AND DM.File_Type = 'M' AND DM.Status = '" + FilterBy + "'";
            lst = (new USP_Service(objLoginEntity.ConnectionStringName).USP_List_DM_Master_Import(search, pageNo, orderByCndition, isPaging,
                  recordPerPage, objRecordCount, objLoginUser.Users_Code).ToList());
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = pageNo;
            ViewBag.FileType = "M";
            return PartialView("~/Views/DM_Master_Import/_DM_Import_List.cshtml", lst);
        }
        public JsonResult GetMusicFileImportStatus(int dealCode)
        {
            string recordStatus = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.DM_Master_Import_Code == dealCode).Select(s => s.Status).FirstOrDefault();
            double TotalCount = new RightsU_BLL.DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode).Count();
            double SuccessCount = new RightsU_BLL.DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "C").Count();
            double ConflictCount = new RightsU_BLL.DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Is_Ignore == "N" && (x.Record_Status == "R")).Count();
            double IgnoreCount = new RightsU_BLL.DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Is_Ignore == "Y").Count();
            double WaitingCount = new RightsU_BLL.DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "N" && x.Is_Ignore != "Y").Count();

            double ErrorCount = new RightsU_BLL.DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "E").Count();

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
        public PartialViewResult BindDMMasterLog(int DM_Import_Master_Code, string fileType = "")
        {
            ViewBag.Is_Allow_Program_Category = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Allow_Program_Category").ToList().FirstOrDefault().Parameter_Value;
            lstDMCodes = DM_Import_Master_Code.ToString();
            ViewBag.FileType = fileType;
            List<RightsU_Entities.DM_Master_Log> lst = new List<RightsU_Entities.DM_Master_Log>();
            DM_Master_Log lstDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code.Contains(lstDMCodes)).FirstOrDefault();
            ViewBag.FileStatus = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.DM_Master_Import_Code == DM_Import_Master_Code).Select(s => s.Status).FirstOrDefault();
            return PartialView("~/Views/DM_Master_Import/_DM_Master_Log_List.cshtml", lstDMLog);
        }
        public JsonResult BindProceed(int DM_Import_Master_Code, string fileType = "")
        {
            string message = "", status = "";
            ViewBag.FileType = fileType;
            if (fileType == "T")
            {
                List<USP_DM_Title_PIII> lstDMMapping = new List<USP_DM_Title_PIII>();
                lstDMMapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_DM_Title_PIII(DM_Import_Master_Code).ToList();
                if (lstDMMapping.Count == 0)
                {
                    status = "S";
                    message = "Data proceed successfully";
                }
            }
            else
            {
                List<USP_DM_Music_Title_PIII> lstDMMapping = new List<USP_DM_Music_Title_PIII>();
                lstDMMapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_DM_Music_Title_PIII(DM_Import_Master_Code).ToList();
                if (lstDMMapping.Count == 0)
                {
                    status = "S";
                    message = "Data proceed successfully";
                }
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj, JsonRequestBehavior.AllowGet);
        }
        public JsonResult BindTitleProceed(int DM_Import_Master_Code, string fileType = "")
        {
            string message = "", status = "";
            ViewBag.FileType = fileType;
            List<USP_DM_Title_PIII> lstDMMapping = new List<USP_DM_Title_PIII>();
            lstDMMapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_DM_Title_PIII(DM_Import_Master_Code).ToList();
            if (lstDMMapping.Count == 0)
            {
                status = "S";
                message = "Data proceed successfully";
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj, JsonRequestBehavior.AllowGet);
        }
        public PartialViewResult BindMusicError(int DM_Import_Master_Code, int pageNo = 0, int txtpagesize = 10, string File_Type = "")
        {
            List<DM_Music_Title> lst = new List<DM_Music_Title>();
            int PageNo = pageNo + 1;
            int RecordCount = 0;
            ViewBag.File_Type = File_Type;
            ViewBag.DM_Master_Import_Code = DM_Import_Master_Code;
            objDMMusic = null;
            objDMMusicService = null;
            objDMMusic.DM_Master_Import_Code = DM_Import_Master_Code;

            List<DM_Music_Title> lstDMMusicTitle = new DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code == DM_Import_Master_Code && i.Record_Status == "E").ToList();
            RecordCount = lstDMMusicTitle.Count;
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = PageNo;
            int pageSize = txtpagesize;
            ViewBag.txtpageSize = txtpagesize;
            if (PageNo == 1)
                lst = lstDMMusicTitle.Take(pageSize).ToList();
            else
            {
                lst = lstDMMusicTitle.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lstDMMusicTitle.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList().Count == 0)
                {
                    if (PageNo != 1)
                    {
                        //objDeal_Schema.Budget_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst = lstDMMusicTitle.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }
            return PartialView("~/Views/DM_Master_Import/_DM_Music_Error_List.cshtml", lst);
        }
        public PartialViewResult BindTitleError(int DM_Import_Master_Code, int pageNo = 0, int txtpagesize = 10, string File_Type = "")
        {
            var MusicTitleVersion = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "SPN_Music_Version").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsMuciVersionSPN = MusicTitleVersion;
            List<DM_Title> lst = new List<DM_Title>();
            int PageNo = pageNo + 1;
            int RecordCount = 0;
            ViewBag.File_Type = File_Type;
            ViewBag.DM_Master_Import_Code = DM_Import_Master_Code;
            objDMTitle = null;
            objDMTitleService = null;
            objDMTitle.DM_Master_Import_Code = DM_Import_Master_Code;

            List<DM_Title> lstDMTitle = new DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code == DM_Import_Master_Code && i.Record_Status == "E").ToList();
            RecordCount = lstDMTitle.Count;
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = PageNo;
            int pageSize = txtpagesize;
            ViewBag.txtpageSize = txtpagesize;
            if (PageNo == 1)
                lst = lstDMTitle.Take(pageSize).ToList();
            else
            {
                lst = lstDMTitle.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                if (lstDMTitle.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList().Count == 0)
                {
                    if (PageNo != 1)
                    {
                        //objDeal_Schema.Budget_PageNo = PageNo - 1;
                        PageNo = PageNo - 1;
                    }
                    lst = lstDMTitle.Skip((PageNo - 1) * pageSize).Take(pageSize).ToList();
                }
            }
            return PartialView("~/Views/DM_Master_Import/_DM_Title_Error_List.cshtml", lst);
        }
        public PartialViewResult BindConflictError(int DM_Import_Master_Code, string File_Type)
        {
            ViewBag.File_Type = File_Type;
            objDMMusic = null;
            objDMMusicService = null;

            objDMMusic.DM_Master_Import_Code = DM_Import_Master_Code;
            DM_Master_Import lstDMMaster = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code == DM_Import_Master_Code).FirstOrDefault();

            return PartialView("~/Views/DM_Master_Import/_DM_Conflict_Error_List.cshtml", lstDMMaster);
        }
        public PartialViewResult BindMappingPopUp(string masterImportCode = "0", string FileType = "", int Code = 0)
        {
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            lstResolveConflict = new USP_Service(objLoginEntity.ConnectionStringName).USPListResolveConflict(masterImportCode, Code, FileType, 1, 10, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.DM_Master_Import_Code = masterImportCode;
            ViewBag.FileType = FileType;
            ViewBag.Code = Code;
            return PartialView("~/Views/DM_Master_Import/_DM_Resolve_Conflict_Popup.cshtml", lstResolveConflict);
        }
        public PartialViewResult BindMusicView(int DM_Master_Import_Code, string fileType = "")
        {
            ViewBag.DM_Master_Import_Code = DM_Master_Import_Code;
            ViewBag.FileType = fileType;
            return PartialView("~/Views/DM_Master_Import/_DM_View_List.cshtml", lstMusicTrackBulkImport);
        }
        public PartialViewResult BindMusicListView(int DM_Import_Master_Code, string SearchCriteria = "", int pageNo = 0, int txtpagesize = 10, string fileType = "", string Error = "", string IsShowAll = "")
        {
            int pgNo = pageNo + 1;
            int RecordCount = 0;
            if (IsShowAll == "Y")
                ClearAllAdvanceSearchMT();
            string Status = "";
            objPg_Properties.MusicTrack_Search = objPg_Properties.MusicTrack_Search.Replace('﹐', ',');
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            if (Error == "Y" && objPg_Properties.Status_Search == "")
                Status = "E";
            else if (Error == "N" && objPg_Properties.Status_Search == "")
                Status = "C,R,P,N";
            else
                Status = objPg_Properties.Status_Search;
            objPg_Properties.chkStatus_Search = Status;
            lstMusicTrackBulkImport = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_MusicTrackBulkImport(DM_Import_Master_Code, SearchCriteria, objPg_Properties.MusicTrack_Search, objPg_Properties.MovieAlbum_Search, objPg_Properties.MusicLabel_Search, objPg_Properties.TitleLanguage_Search, objPg_Properties.StarCast_Search, objPg_Properties.Singer_Search, Status, objPg_Properties.ErrorMsg_Search, objPg_Properties.MusicAlbumType_Search, objPg_Properties.Genres_Search, pgNo, txtpagesize, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.FileType = fileType;
            ViewBag.DM_Master_Import_Code = DM_Import_Master_Code;
            objDMMusic = null;
            objDMMusicService = null;
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = pgNo;
            ViewBag.txtpageSize = txtpagesize;
            TempData["DM_Import_Master_CodeMT"] = DM_Import_Master_Code;
            return PartialView("~/Views/DM_Master_Import/_Music_View_List.cshtml", lstMusicTrackBulkImport);
        }
        public PartialViewResult BindView(int DM_Master_Import_Code, string fileType = "")
        {
            ViewBag.DM_Master_Import_Code = DM_Master_Import_Code;
            ViewBag.FileType = fileType;
            return PartialView("~/Views/DM_Master_Import/_DM_Title_View_List.cshtml");
        }
        public PartialViewResult BindTitleView(int DM_Import_Master_Code, string SearchCriteria = "", int pageNo = 0, int txtpagesize = 10, string fileType = "", string IsShowAll = "", string Error = "")
        {
            int pgNo = pageNo + 1;
            int RecordCount = 0;
            string Status = "";
            if (IsShowAll == "Y")
                ClearAllAdvanceSearchT();
            objPage_Properties.TitleName_Search = objPage_Properties.TitleName_Search.Replace('﹐', ',');
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            if (Error == "Y" && objPage_Properties.Status_Search == "")
                Status = "E";
            else if (Error == "N" && objPage_Properties.Status_Search == "")
                Status = "C,P,R,N";
            else
                Status = objPage_Properties.Status_Search;
            objPage_Properties.chkStatus_Search = Status;
            lstTitleBulkImport = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_TitleBulkImport(DM_Import_Master_Code, objPage_Properties.TitleName_Search, objPage_Properties.TitleType_Search, objPage_Properties.TitleLanguage_Search, objPage_Properties.KeyStarCast_Search, Status, objPage_Properties.ErrorMsg_Search, objPage_Properties.Director_Search, objPage_Properties.MusicLabel_Search, SearchCriteria, pgNo, txtpagesize, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.FileType = fileType;
            ViewBag.DM_Master_Import_Code = DM_Import_Master_Code;
            objDMTitle = null;
            objDMTitleService = null;
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = pgNo;
            ViewBag.txtpageSize = txtpagesize;
            TempData["DM_Import_Master_CodeT"] = DM_Import_Master_Code;
            return PartialView("~/Views/DM_Master_Import/_Title_View_List.cshtml", lstTitleBulkImport);
        }
        public JsonResult GetTitleName(string Searched_User)
        {
            int DM_Import_Master_Code = 0;
            if (TempData["DM_Import_Master_CodeT"] != null)
                DM_Import_Master_Code = Convert.ToInt32(TempData["DM_Import_Master_CodeT"]);
            TempData.Keep("DM_Import_Master_CodeT");
            List<string> terms = Searched_User.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();

            //Extract the term to be searched from the list
            string searchString = terms.LastOrDefault().ToString().Trim();

            var result = new DM_Title_Service(objLoginEntity.ConnectionStringName)
                          .SearchFor(x => x.DM_Master_Import_Code == DM_Import_Master_Code && x.Original_Title__Tanil_Telugu_.ToUpper().Contains(searchString.ToUpper()))
                          .Select(R => new { Mapping_Name = R.Original_Title__Tanil_Telugu_, Mapping_Code = R.Original_Title__Tanil_Telugu_ }).Distinct().ToList();

            return Json(result);
        }
        public JsonResult GetMusicTitleName(string Searched_User)
        {
            int DM_Import_Master_Code = 0;
            if (TempData["DM_Import_Master_CodeMT"] != null)
                DM_Import_Master_Code = Convert.ToInt32(TempData["DM_Import_Master_CodeMT"]);
            TempData.Keep("DM_Import_Master_CodeMT");
            List<string> terms = Searched_User.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();

            //Extract the term to be searched from the list
            string searchString = terms.LastOrDefault().ToString().Trim();

            var result = new DM_Music_Title_Service(objLoginEntity.ConnectionStringName)
                          .SearchFor(x => x.DM_Master_Import_Code == DM_Import_Master_Code && x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper()))
                          .Select(R => new { Mapping_Name = R.Music_Title_Name, Mapping_Code = R.Music_Title_Name }).Distinct().ToList();

            return Json(result);
        }
        public PartialViewResult BindGrid(string masterImportCode, bool fetchData, bool isTabChanged, string currentTabName, string previousTabName, int pageNo, int recordPerPage, string MappedData)
        {
            //Session["lst_DM_Import_UDT"] = null;
            List<DM_Master_Log> lst = new List<DM_Master_Log>();
            ViewBag.TabName = currentTabName;
            // string[] DMCodes = masterImportCode.Trim('~').Split('~');
            string code = lstDMCodes;
            if (fetchData)
            {
                lstDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code.Contains(code)
                && (i.Master_Code == null || i.Master_Code == 0) && i.Is_Ignore == "N").ToList();

                lstSystemDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.DM_Master_Import_Code.Contains(code)
                && (i.Master_Code != null) && i.Is_Ignore == "N" && i.Mapped_By == "S").ToList();
            }
            if (isTabChanged)
            {
                objTabPaging.SetPropertyValue("PageNo_" + previousTabName, pageNo);
                objTabPaging.SetPropertyValue("PageSize_" + previousTabName, recordPerPage);

                pageNo = (int)objTabPaging.GetPropertyValue("PageNo_" + currentTabName);
                pageNo = (pageNo == 0) ? 1 : pageNo;
                recordPerPage = (int)objTabPaging.GetPropertyValue("PageSize_" + currentTabName);
                recordPerPage = (recordPerPage == 0) ? 10 : recordPerPage;
            }
            else
            {
                objTabPaging.SetPropertyValue("PageNo_" + currentTabName, pageNo);
                objTabPaging.SetPropertyValue("PageSize_" + currentTabName, recordPerPage);
            }
            if (MappedData == "U")
            {
                ViewBag.RecordCount = lstDMLog.Where(i => i.Master_Type == currentTabName).Count();
            }
            else
            {
                ViewBag.RecordCount = lstSystemDMLog.Where(i => i.Master_Type == currentTabName).Count();
            }
            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;

            if (ViewBag.RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, ViewBag.RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (MappedData == "U")
                    lst = lstDMLog.Where(w => w.Master_Type == currentTabName).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstSystemDMLog.Where(w => w.Master_Type == currentTabName).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            if (MappedData == "U")
            {
                return PartialView("~/Views/DM_Master_Import/DM_Import_Log.cshtml", lst);
            }
            else
            {
                return PartialView("~/Views/DM_Master_Import/DM_Import_SystemMapping_Log.cshtml", lst);

            }
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
        public ActionResult PopulateAutoCompleteData(string keyword, string tabName)
        {
            string Is_Allow_Program_Category = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Allow_Program_Category").ToList().FirstOrDefault().Parameter_Value;
            int Deal_type_Code_Other = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Deal_Type_Other").FirstOrDefault().Parameter_Value);
            dynamic result = "";
            if (tabName == "TA")
            {
                result = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name.ToUpper().Contains(keyword.ToUpper())).Distinct()
                            .Select(R => new { Mapping_Name = R.Talent_Name, Mapping_Code = R.Talent_Code }).Take(100).ToList();
            }
            if (tabName == "LB")
            {
                result = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Label_Name.ToUpper().Contains(keyword.ToUpper())).Distinct()
                            .Select(R => new { Mapping_Name = R.Music_Label_Name, Mapping_Code = R.Music_Label_Code }).Take(100).ToList();
            }
            if (tabName == "GE")
            {
                result = new Genre_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Genres_Name.ToUpper().Contains(keyword.ToUpper())).Distinct()
                            .Select(R => new { Mapping_Name = R.Genres_Name, Mapping_Code = R.Genres_Code }).Take(100).ToList();
            }
            if (tabName == "MA")
            {
                result = new Music_Album_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Name.ToUpper().Contains(keyword.ToUpper())).Distinct()
                            .Select(R => new { Mapping_Name = R.Music_Album_Name, Mapping_Code = R.Music_Album_Code }).Take(100).ToList();
            }
            if (tabName == "ML")
            {
                result = new Music_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Language_Name.ToUpper().Contains(keyword.ToUpper())).Distinct()
                            .Select(R => new { Mapping_Name = R.Language_Name, Mapping_Code = R.Music_Language_Code }).Take(100).ToList();
            }
            if (tabName == "MT")
            {
                result = new Music_Theme_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Theme_Name.ToUpper().Contains(keyword.ToUpper())).Distinct()
                            .Select(R => new { Mapping_Name = R.Music_Theme_Name, Mapping_Code = R.Music_Theme_Code }).Take(100).ToList();
            }
            if (tabName == "TT")
            {
                result = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type_Name.ToUpper().Contains(keyword.ToUpper()) && x.Is_Active == "Y" && x.Deal_Or_Title.Contains("T") && x.Deal_Type_Code != Deal_type_Code_Other).Distinct()
                           .Select(R => new { Mapping_Name = R.Deal_Type_Name, Mapping_Code = R.Deal_Type_Code }).Take(100).ToList();
            }
            if (tabName == "TL" || tabName == "OL")
            {
                result = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Language_Name.ToUpper().Contains(keyword.ToUpper())).Distinct()
                           .Select(R => new { Mapping_Name = R.Language_Name, Mapping_Code = R.Language_Code }).Take(100).ToList();
            }
            if (Is_Allow_Program_Category == "Y")
            {
                int Program_Category_Code = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Columns_Name == "Program Category").ToList().FirstOrDefault().Columns_Code;
                if (tabName == "PC")
                {
                    result = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Value.Contains(keyword.ToUpper()) && x.Columns_Code == Program_Category_Code).Distinct()
                                .Select(R => new { Mapping_Name = R.Columns_Value, Mapping_Code = R.Columns_Value_Code }).Take(100).ToList();
                }
            }
            return Json(result);
        }
        public ActionResult ValidateTalent(List<RightsU_Entities.DM_Master_Log> lst)
        {
            int count = 0;
            List<Talent_Validation> lstTalent = new List<Talent_Validation>();
            string talent, role;
            if (lst != null)
            {
                foreach (RightsU_Entities.DM_Master_Log objDMTemp in lst)
                {
                    if (objDMTemp.Is_Create_New)
                    {
                        Talent_Validation objTV = new Talent_Validation();
                        DM_Master_Log objDMLogT = lstDMLog.Where(w => w.DM_Master_Log_Code == objDMTemp.DM_Master_Log_Code).FirstOrDefault();
                        if (objDMLogT.Master_Type == "TA")
                        {
                            talent = objDMLogT.Name;
                            role = objDMLogT.Roles.FirstOrDefault().ToString();
                            objTV.Talent_Name = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name == talent).Select(s => s.Talent_Name).FirstOrDefault();
                            objTV.Role_Name = string.Join(", ", new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name == talent).SelectMany(s => s.Talent_Role).Select(s => s.Role).Select(s => s.Role_Name).ToArray());
                            if (objTV.Talent_Name != null)
                            {
                                count = count + 1;
                                lstobjTV.Add(objTV);
                            }
                        }
                    }
                }
            }
            if (count == 0)
                lstobjTV = null;
            lstTalent = lstobjTV;
            lstobjTV = null;

            return PartialView("~/Views/DM_Master_Import/_Title_Validate.cshtml", lstTalent);
        }
        public ActionResult SaveMappedData(List<RightsU_Entities.DM_Master_Log> lst, List<RightsU_Entities.DM_Master_Log> lstSystemMapLog)
        {
            string status = "", message = "";
            int mappedCount = 0;
            if (lst != null)
            {

                foreach (RightsU_Entities.DM_Master_Log objDMTemp in lst)
                {
                    DM_Master_Log objDMLogT = lstDMLog.Where(w => w.DM_Master_Log_Code == objDMTemp.DM_Master_Log_Code).FirstOrDefault();
                    objDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).GetById(objDMTemp.DM_Master_Log_Code);
                    if (objDMLogT != null)
                    {
                        objDMLogT.Is_Create_New = objDMTemp.Is_Create_New;
                        objDMLogT.IsIgnore = objDMTemp.IsIgnore;
                        if (objDMLogT.Is_Create_New || objDMLogT.IsIgnore)
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

                    if (objDMLogT.Is_Create_New || objDMTemp.Mapped_Code > 0 || objDMLogT.IsIgnore)
                    {
                        objDMUDT.Key = objDMTemp.DM_Master_Log_Code.ToString();
                        objDMUDT.DM_Master_Type = objDMLogT.Master_Type;

                        if (objDMLogT.Is_Create_New)
                            objDMUDT.value = "New";
                        else if (objDMLogT.IsIgnore)
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
                    DM_Master_Log objDMLogT = lstSystemDMLog.Where(w => w.DM_Master_Log_Code == objDMTemp.DM_Master_Log_Code).FirstOrDefault();
                    objDMLog = new DM_Master_Log_Service(objLoginEntity.ConnectionStringName).GetById(objDMTemp.DM_Master_Log_Code);
                    if (objDMLogT != null)
                    {
                        //if (objDMTemp.Mapped_Name == null && objDMTemp.System_Mapped_Name != null)
                        //{
                        //    objDMLogT.Mapped_Name = objDMTemp.System_Mapped_Name;
                        //    objDMLogT.Mapped_Code = objDMTemp.System_Mapped_Code;
                        //}
                        //else
                        //{
                        objDMLogT.Mapped_Name = objDMTemp.Mapped_Name;
                        objDMLogT.Mapped_Code = objDMTemp.Mapped_Code;
                        //}
                    }
                    DM_Import_UDT objDMUDT = lst_DM_Import_UDT.Where(w => w.Key == objDMTemp.DM_Master_Log_Code.ToString()).FirstOrDefault();
                    if (objDMUDT == null)
                    {
                        objDMUDT = new DM_Import_UDT();
                        lst_DM_Import_UDT.Add(objDMUDT);
                    }

                    if (objDMTemp.Mapped_Code > 0 || objDMTemp.System_Mapped_Code > 0)
                    {
                        objDMUDT.Key = objDMTemp.DM_Master_Log_Code.ToString();
                        objDMUDT.DM_Master_Type = objDMLogT.Master_Type;
                        objDMUDT.value = objDMTemp.Mapped_Code > 0 ? objDMTemp.Mapped_Code.ToString() : objDMTemp.System_Mapped_Code.ToString();
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
            //string[] Code = "~2745~~2746~~2747".Trim('~').Split('~');
            string[] DMCodes = objDMLog.DM_Master_Import_Code.Trim('~').Split('~');
            int DMMasterImportCode = Convert.ToInt32(objDMLog.DM_Master_Import_Code);
            dynamic resultSet;
            DM_Master_Import objDMMImport = new DM_Master_Import();
            DM_Master_Import_Service objDMImportService = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName);
            objDMMImport = objDMImportService.GetById(DMMasterImportCode);
            objDMMImport.Mapped_By = "S";
            objDMMImport.EntityState = State.Modified;
            objDMImportService.Save(objDMMImport, out resultSet);
            foreach (string DMMasterCode in DMCodes)
            {
                if (!String.IsNullOrEmpty(DMMasterCode))
                {
                    DM_Master_Import_Code = Convert.ToInt32(DMMasterCode.Trim());
                    //string DM_Master_Import_Codes = DMMasterCode;

                    if (fileType == "M")
                    {
                        List<USP_DM_Music_Title_PII> lstDMMapping = new List<USP_DM_Music_Title_PII>();
                        lstDMMapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_DM_Music_Title_PII(lst_DM_Import_UDT, DM_Master_Import_Code, objLoginUser.Users_Code).ToList();
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
                    else if (fileType == "T")
                    {
                        List<USP_DM_Title_PII> lstDMMapping = new List<USP_DM_Title_PII>();
                        lstDMMapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_DM_Title_PII(lst_DM_Import_UDT, DM_Master_Import_Code, objLoginUser.Users_Code).ToList();
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
            }
            //BindGrid(DM_Master_Import_Code,true, false,)
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public PartialViewResult UploadTitles(HttpPostedFileBase InputFile, string txtpageSize, string FilterBy)
        {
            string Is_allow_Program_Category = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Allow_Program_Category").ToList().FirstOrDefault().Parameter_Value;
            string Modified_Data = "N";
            string message = "";
            string status = "";
            int pageSize = 10;
            int PageNo = 0;
            string sheetName = "Title$";
            List<USP_DM_Title_PI> lstRE = new List<USP_DM_Title_PI>();
            DM_Master_Import obj_DM_Master_Import = new DM_Master_Import();
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = InputFile;
                string fullPath = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"];
                string ext = System.IO.Path.GetExtension(PostedFile.FileName);
                if (ext == ".xlsx" || ext == ".xls")
                {
                    /*Read Excel File*/
                    ExcelReader objExcelReader = new ExcelReader();
                    DataSet ds = new DataSet();

                    try
                    {
                        string strActualFileNameWithDate;
                        string fileExtension = "";
                        string strFileName = System.IO.Path.GetFileName(PostedFile.FileName);
                        fileExtension = System.IO.Path.GetExtension(PostedFile.FileName);
                        strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                        string fullpathname = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadFilePath"] + strActualFileNameWithDate);
                        PostedFile.SaveAs(fullpathname);
                        StringBuilder sb1 = new StringBuilder();
                        string strConn = string.Empty;
                        bool hasHeaders = false;
                        string HDR = hasHeaders ? "Yes" : "No";
                        try
                        {
                            OleDbConnection cn = new OleDbConnection();
                            cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1'");
                            OleDbCommand cmdExcel = new OleDbCommand();
                            OleDbDataAdapter oda = new OleDbDataAdapter();
                            cmdExcel.Connection = cn;
                            //string sheetName = "Sheet1$";

                            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + sheetName + "]", cn);
                            da.Fill(ds);
                        }
                        catch (Exception ex)
                        {
                            message = ex.ToString();
                            status = "E";
                        }
                        finally
                        {
                            //Always delete uploaded excel file from folder.
                            System.IO.File.Delete(fullpathname.Trim());
                        }
                        if (status != "E")
                        {
                            var count = ds.Tables.Count;
                            if (count == 0)
                            {
                                message = "'" + sheetName.Trim('$') + "' " + " Sheet name should not be existing in uploaded excel";
                                status = "E";
                            }
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
                            /*Data Insertion*/
                            if (Is_allow_Program_Category == "Y")
                            {
                                if (ds.Tables[0].Columns[0].ColumnName != "Sr. No" || ds.Tables[0].Columns[1].ColumnName != "Title"
                                 || ds.Tables[0].Columns[2].ColumnName != "Original Title" || ds.Tables[0].Columns[3].ColumnName != "Title Type"
                                 || ds.Tables[0].Columns[4].ColumnName != "Title Language" || ds.Tables[0].Columns[5].ColumnName != "Original Language"
                                 || ds.Tables[0].Columns[6].ColumnName != "Year of Release"
                                 || ds.Tables[0].Columns[7].ColumnName != "Duration (Min)" || ds.Tables[0].Columns[8].ColumnName != "Key Star Cast"
                                 || ds.Tables[0].Columns[9].ColumnName != "Director" || ds.Tables[0].Columns[10].ColumnName != "Music Label" || ds.Tables[0].Columns[11].ColumnName != "Program Category"
                                 || ds.Tables[0].Columns[12].ColumnName != "Synopsis" || ds.Tables[0].Columns.Count != 13)
                                {
                                    Modified_Data = "Y";
                                }
                            }
                            if (Is_allow_Program_Category == "N")
                            {
                                if (ds.Tables[0].Columns[0].ColumnName != "Sr. No" || ds.Tables[0].Columns[1].ColumnName != "Title"
                                 || ds.Tables[0].Columns[2].ColumnName != "Original Title" || ds.Tables[0].Columns[3].ColumnName != "Title Type"
                                 || ds.Tables[0].Columns[4].ColumnName != "Title Language" || ds.Tables[0].Columns[5].ColumnName != "Original Language"
                                 || ds.Tables[0].Columns[6].ColumnName != "Year of Release"
                                 || ds.Tables[0].Columns[7].ColumnName != "Duration (Min)" || ds.Tables[0].Columns[8].ColumnName != "Key Star Cast"
                                 || ds.Tables[0].Columns[9].ColumnName != "Director" || ds.Tables[0].Columns[10].ColumnName != "Music Label"
                                 || ds.Tables[0].Columns[11].ColumnName != "Synopsis" || ds.Tables[0].Columns.Count != 12)
                                {
                                    Modified_Data = "Y";
                                }
                            }
                            if (Modified_Data == "Y")
                            {
                                message = "Please Don't Modify the name of the field in excel File";
                                status = "E";
                            }
                            else
                            {
                                if (ds.Tables[0].Columns.Count == 13 || ds.Tables[0].Columns.Count == 12)
                                {
                                    if (ds.Tables[0].Rows.Count > 0)
                                    {
                                        dynamic resultSet;
                                        obj_DM_Master_Import.File_Name = PostedFile.FileName;
                                        obj_DM_Master_Import.System_File_Name = PostedFile.FileName;
                                        obj_DM_Master_Import.Upoaded_By = objLoginUser.Users_Code;
                                        obj_DM_Master_Import.Uploaded_Date = DateTime.Now;
                                        obj_DM_Master_Import.Action_By = objLoginUser.Users_Code;
                                        obj_DM_Master_Import.Action_On = DateTime.Now;
                                        obj_DM_Master_Import.Status = "N";
                                        obj_DM_Master_Import.File_Type = "T";
                                        obj_DM_Master_Import.EntityState = State.Added;
                                        lst_DM_Master_Import.Add(obj_DM_Master_Import);
                                        objDMService.Save(obj_DM_Master_Import, out resultSet);


                                        List<Title_Import_UDT> lst_Title_Import_UDT = new List<Title_Import_UDT>();
                                        foreach (DataRow row in ds.Tables[0].Rows)
                                        {
                                            Title_Import_UDT obj_Title_Import_UDT = new Title_Import_UDT();
                                            obj_Title_Import_UDT.Title_Name = row["Title"].ToString();
                                            obj_Title_Import_UDT.Original_Title = row["Original Title"].ToString();
                                            obj_Title_Import_UDT.Title_Type = row["Title Type"].ToString();
                                            obj_Title_Import_UDT.Title_Language = row["Title Language"].ToString();
                                            obj_Title_Import_UDT.Original_Language = row["Original Language"].ToString();
                                            obj_Title_Import_UDT.Duration = row["Duration (Min)"].ToString();
                                            obj_Title_Import_UDT.Director = row["Director"].ToString();
                                            obj_Title_Import_UDT.Key_Star_Cast = row["Key Star Cast"].ToString();
                                            obj_Title_Import_UDT.Year_of_Release = row["Year of Release"].ToString();
                                            obj_Title_Import_UDT.Synopsis = row["Synopsis"].ToString();
                                            obj_Title_Import_UDT.Music_Label = row["Music Label"].ToString();
                                            obj_Title_Import_UDT.DM_Master_Import_Code = obj_DM_Master_Import.DM_Master_Import_Code.ToString();
                                            obj_Title_Import_UDT.Excel_Line_No = row["Sr. No"].ToString();
                                            if (Is_allow_Program_Category == "Y")
                                                obj_Title_Import_UDT.Program_Category = row["Program Category"].ToString();
                                            else
                                                obj_Title_Import_UDT.Program_Category = "";
                                            lst_Title_Import_UDT.Add(obj_Title_Import_UDT);
                                        }
                                        lstRE = new USP_Service(objLoginEntity.ConnectionStringName).USP_DM_Title_PI(lst_Title_Import_UDT, objLoginUser.Users_Code).ToList();
                                        List<USP_DM_Title_PI> lstshow = new List<USP_DM_Title_PI>();
                                        if (lstRE.Count == 1)
                                        {
                                            message = "File uploaded successfully";
                                            status = "S";
                                        }
                                        else
                                        {
                                            foreach (USP_DM_Title_PI item in lstRE)
                                                if (item.Error_Messages != "" && item.Error_Messages != null)
                                                    lstshow.Add(item);
                                            lstRE = lstshow;
                                        }
                                        //else
                                        //    return PartialView("_TitleImport_List", lstRE);
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
                        status = "E";

                    }
                }
                else
                {
                    message = "Please select excel file...";
                    status = "E";
                }

            }
            else
            {
                message = "Please select excel file...";
                status = "E";
            }
            //string File_Type = obj_DM_Master_Import.File_Type;
            ViewBag.File_Type = obj_DM_Master_Import.File_Type;
            ViewBag.Message = message;
            ViewBag.status = status;
            //ViewBag.status = Acq_Status_HistoryController;
            return PopulateTitleGrid(Convert.ToString(PageNo), txtpageSize, FilterBy);
        }
        public PartialViewResult PopulateTitleGrid(string PgNo = "0", string txtPageSize = "", string FilterBy = "")
        {
            TempData["FilterByStatusTitle"] = FilterBy;
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
            TempData["PageNoBackTitle"] = pageNo;
            TempData["txtPageSizeBackTitle"] = txtPageSize;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            List<USP_List_DM_Master_Import_Result> lst = new List<USP_List_DM_Master_Import_Result>();
            string orderByCndition = "T.DM_Master_Import_Code desc";
            if (FilterBy == "A")
                search += " AND DM.File_Type = 'T'";
            else if (FilterBy == "Q")
                search += " AND DM.File_Type = 'T' AND DM.Status IN('I','Q')";
            else if (FilterBy == "E")
                search += " AND DM.File_Type = 'T' AND DM.Status IN('E','T')";
            else
                search += " AND DM.File_Type = 'T' AND DM.Status = '" + FilterBy + "'";
            lst = (new USP_Service(objLoginEntity.ConnectionStringName).USP_List_DM_Master_Import(search, pageNo, orderByCndition, isPaging,
                  recordPerPage, objRecordCount, objLoginUser.Users_Code).ToList());
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = pageNo;
            ViewBag.FileType = "T";
            return PartialView("~/Views/DM_Master_Import/_DM_Import_List.cshtml", lst);
        }
        public JsonResult GetTitleFileImportStatus(int dealCode)
        {
            string recordStatus = new DM_Master_Import_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.DM_Master_Import_Code == dealCode).Select(s => s.Status).FirstOrDefault();
            double TotalCount = new RightsU_BLL.DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode).Count();
            double SuccessCount = new RightsU_BLL.DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "C").Count();
            double ConflictCount = new RightsU_BLL.DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Is_Ignore == "N" && (x.Record_Status == "R")).Count();
            double IgnoreCount = new RightsU_BLL.DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Is_Ignore == "Y").Count();
            double WaitingCount = new RightsU_BLL.DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "N" && x.Is_Ignore != "Y").Count();

            double ErrorCount = new RightsU_BLL.DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == dealCode && x.Record_Status == "E").Count();

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

        public JsonResult ClearSession()
        {
            string status = "S";

            objTabPaging = null;
            lstDMLog = null;
            lstSystemDMLog = null;
            lstTitleBulkImport = null;
            lstMusicTrackBulkImport = null;

            object obj = new
            {
                Status = status,
                Message = ""
            };
            return Json(obj);
        }

        public JsonResult BindAdvanced_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            int DM_Import_Master_Code = 0;
            string ErrorMsg = "";
            if (TempData["DM_Import_Master_CodeT"] != null)
                DM_Import_Master_Code = Convert.ToInt32(TempData["DM_Import_Master_CodeT"]);
            TempData.Keep("DM_Import_Master_CodeT");
            List<RightsU_Entities.DM_Title> lstDMTitle = new DM_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == DM_Import_Master_Code).ToList();
            List<SelectListItem> lstDealType = new SelectList(lstDMTitle.Where(i => i.Title_Type != null && i.Title_Type != "").Select(i => new { Display_Value = i.Title_Type, Display_Text = i.Title_Type }).Distinct().ToList(), "Display_Value", "Display_Text").ToList();
            lstDealType.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });
            MultiSelectList lstLanguage = new MultiSelectList(lstDMTitle.Where(x => x.Original_Language__Hindi_ != null && x.DM_Master_Import_Code == DM_Import_Master_Code && x.Original_Language__Hindi_ != "")
               .Select(i => new { Display_Value = i.Original_Language__Hindi_, Display_Text = i.Original_Language__Hindi_ }).Distinct().ToList(), "Display_Value", "Display_Text");
            var lstStarCast = lstDMTitle.Where(x => x.Key_Star_Cast != "" && x.Key_Star_Cast != null).Select(x => x.Key_Star_Cast).Distinct().ToArray();
            string StarCast = String.Join(",", lstStarCast);
            string[] lstTemp = StarCast.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList lstTStarCast = new MultiSelectList(lstTemp.Select(i => new { Display_Value = i, Display_Text = i }).Distinct().ToList(), "Display_Value", "Display_Text");
            var lstDirector = lstDMTitle.Where(x => x.Director_Name != null && x.Director_Name != "").Select(x => x.Director_Name).Distinct().ToArray();
            string Director = String.Join(",", lstDirector);
            string[] lstTempDirector = Director.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList lstTDirector = new MultiSelectList(lstTempDirector.Select(i => new { Display_Value = i, Display_Text = i }).Distinct().ToList(), "Display_Value", "Display_Text");
            var lstMusicLabel = lstDMTitle.Where(x => x.Music_Label != null && x.Music_Label != "").Select(x => x.Music_Label).Distinct().ToArray();
            string MusicLabel = String.Join(",", lstMusicLabel);
            string[] lstTempMusicLabel = MusicLabel.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList lstTMusicLabel = new MultiSelectList(lstTempMusicLabel.Select(i => new { Display_Value = i, Display_Text = i }).Distinct().ToList(), "Display_Value", "Display_Text");
            List<string> lstErrorMsg1 = lstDMTitle.Where(x => x.Error_Message != "" && x.Error_Message != null).Select(x => x.Error_Message).Distinct().ToList();
            foreach (string Msg in lstErrorMsg1)
            {
                ErrorMsg += Msg;
            }
            string[] lstErrMsg = ErrorMsg.Split(new char[] { '~' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList lstErrorMsg = new MultiSelectList(lstErrMsg.Select(i => new { Display_Value = i, Display_Text = i }),
                "Display_Value", "Display_Text");
            List<SelectListItem> lstStatus = new List<SelectListItem>();
            lstStatus.Add(new SelectListItem { Text = "Ignore", Value = "Y" });
            lstStatus.Add(new SelectListItem { Text = "Success", Value = "C" });
            lstStatus.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstStatus.Add(new SelectListItem { Text = "No Error", Value = "N" });
            lstStatus.Add(new SelectListItem { Text = "Proceed", Value = "P" });
            lstStatus.Add(new SelectListItem { Text = "Resolve Conflict", Value = "R" });
            lstStatus.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });

            objJson.Add("lstTStarCast", lstTStarCast);
            objJson.Add("lstLanguage", lstLanguage);
            objJson.Add("lstDealType", lstDealType);
            objJson.Add("lstTDirector", lstTDirector);
            objJson.Add("lstTMusicLabel", lstTMusicLabel);
            objJson.Add("lstStatus", lstStatus);
            objJson.Add("lstErrorMsg", lstErrorMsg);

            if (objPage_Properties.TitleName_Search != "" && objPage_Properties.TitleName_Search != null)
                objPage_Properties.TitleName_Search = objPage_Properties.TitleName_Search;
            else
                objPage_Properties.TitleName_Search = "";

            if (objPage_Properties.TitleLanguage_Search != "" && objPage_Properties.TitleLanguage_Search != null)
                objPage_Properties.TitleLanguage_Search = objPage_Properties.TitleLanguage_Search;
            else
                objPage_Properties.TitleLanguage_Search = "";

            if (objPage_Properties.TitleType_Search != "" && objPage_Properties.TitleType_Search != null)
                objPage_Properties.TitleType_Search = objPage_Properties.TitleType_Search;
            else
                objPage_Properties.TitleType_Search = "";

            if (objPage_Properties.KeyStarCast_Search != "" && objPage_Properties.KeyStarCast_Search != null)
                objPage_Properties.KeyStarCast_Search = objPage_Properties.KeyStarCast_Search;
            else
                objPage_Properties.KeyStarCast_Search = "";

            if (objPage_Properties.Director_Search != "" && objPage_Properties.Director_Search != null)
                objPage_Properties.Director_Search = objPage_Properties.Director_Search;
            else
                objPage_Properties.Director_Search = "";

            if (objPage_Properties.MusicLabel_Search != "" && objPage_Properties.MusicLabel_Search != null)
                objPage_Properties.MusicLabel_Search = objPage_Properties.MusicLabel_Search;
            else
                objPage_Properties.MusicLabel_Search = "";

            if (objPage_Properties.Status_Search != "" && objPage_Properties.Status_Search != null)
                objPage_Properties.Status_Search = objPage_Properties.Status_Search;
            else
                objPage_Properties.Status_Search = "";

            if (objPage_Properties.ErrorMsg_Search != "" && objPage_Properties.ErrorMsg_Search != null)
                objPage_Properties.ErrorMsg_Search = objPage_Properties.ErrorMsg_Search;
            else
                objPage_Properties.ErrorMsg_Search = "";

            objJson.Add("objPage_Properties", objPage_Properties);
            return Json(objJson);
        }
        public JsonResult BindAdvanced_Search_Controls_MusicTrack()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            int DM_Import_Master_Code = 0;
            string ErrorMsg = "";
            if (TempData["DM_Import_Master_CodeMT"] != null)
                DM_Import_Master_Code = Convert.ToInt32(TempData["DM_Import_Master_CodeMT"]);
            TempData.Keep("DM_Import_Master_CodeMT");
            List<RightsU_Entities.DM_Music_Title> lstMusicTitle = new DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.DM_Master_Import_Code == DM_Import_Master_Code).ToList();
            List<SelectListItem> lstMusicTrack = new SelectList(lstMusicTitle, "Music_Title_Name", "Music_Title_Name").ToList();
            List<SelectListItem> lstMovieAlbum = new SelectList(lstMusicTitle.Where(x => x.Movie_Album != "").Select(i => new { Display_Value = i.Movie_Album, Display_Text = i.Movie_Album }).Distinct().ToList(), "Display_Value", "Display_Text").ToList();
            List<SelectListItem> lstMusicLabel = new SelectList(lstMusicTitle.Where(x => x.Music_Label != "").Select(i => new { Display_Value = i.Music_Label, Display_Text = i.Music_Label }).Distinct().ToList(), "Display_Value", "Display_Text").ToList();
            string[] lstTemp = String.Join(",", lstMusicTitle.Where(x => x.Singers != "" && x.Singers != null).Select(x => x.Singers).Distinct().ToArray()).Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList lstSingers = new MultiSelectList(lstTemp.Select(i => new { Display_Value = i, Display_Text = i }).Distinct().ToList(),
             "Display_Value", "Display_Text");
            List<SelectListItem> lstGenres = new SelectList(lstMusicTitle.Where(x => x.Genres != "").Select(i => new { Display_Value = i.Genres, Display_Text = i.Genres }).Distinct().ToList(), "Display_Value", "Display_Text", 0).ToList();
            List<RightsU_Entities.DM_Music_Title> lstMAType = new DM_Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Album_Type != null && x.DM_Master_Import_Code == DM_Import_Master_Code && x.Music_Album_Type != "").ToList();
            List<SelectListItem> lstMusicAlbumType = new SelectList(lstMAType.Select(i => new { Display_Value = i.Music_Album_Type, Display_Text = i.Music_Album_Type }).Distinct().ToList(), "Display_Value", "Display_Text", 0).ToList();
            lstMusicAlbumType.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });
            MultiSelectList lstLanguage = new MultiSelectList(lstMusicTitle.Where(x => x.Title_Language != null && x.DM_Master_Import_Code == DM_Import_Master_Code && x.Title_Language != "")
               .Select(i => new { Display_Value = i.Title_Language, Display_Text = i.Title_Language }).Distinct().ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstTStarCast = new MultiSelectList(lstMusicTitle.Where(x => x.Star_Cast != null && x.DM_Master_Import_Code == DM_Import_Master_Code && x.Star_Cast != "")
                .Select(i => new { Display_Value = i.Star_Cast, Display_Text = i.Star_Cast }).Distinct().ToList(), "Display_Value", "Display_Text");
            List<string> lstErrorMsg1 = lstMusicTitle.Where(x => x.Error_Message != "" && x.Error_Message != null).Select(x => x.Error_Message).Distinct().ToList();
            foreach (string Msg in lstErrorMsg1)
            {
                ErrorMsg += Msg;
            }
            string[] lstErrMsg = ErrorMsg.Split(new char[] { '~' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList lstErrorMsg = new MultiSelectList(lstErrMsg.Select(i => new { Display_Value = i, Display_Text = i }),
                "Display_Value", "Display_Text");

            List<SelectListItem> lstStatus = new List<SelectListItem>();
            lstStatus.Add(new SelectListItem { Text = "Ignore", Value = "Y" });
            lstStatus.Add(new SelectListItem { Text = "Success", Value = "C" });
            lstStatus.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstStatus.Add(new SelectListItem { Text = "No Error", Value = "N" });
            lstStatus.Add(new SelectListItem { Text = "Proceed", Value = "P" });
            lstStatus.Add(new SelectListItem { Text = "Resolve Conflict", Value = "R" });
            lstStatus.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });

            objJson.Add("lstMusicTitle", lstMusicTitle);
            objJson.Add("lstMusicTrack", lstMusicTrack);
            objJson.Add("lstMovieAlbum", lstMovieAlbum);
            objJson.Add("lstMusicLabel", lstMusicLabel);
            objJson.Add("lstSingers", lstSingers);
            objJson.Add("lstGenres", lstGenres);
            objJson.Add("lstTStarCast", lstTStarCast);
            objJson.Add("lstLanguage", lstLanguage);
            objJson.Add("lstMusicAlbumType", lstMusicAlbumType);
            objJson.Add("lstStatus", lstStatus);
            objJson.Add("lstErrorMsg", lstErrorMsg);

            if (objPg_Properties.MusicTrack_Search != "" && objPg_Properties.MusicTrack_Search != null)
                objPg_Properties.MusicTrack_Search = objPg_Properties.MusicTrack_Search;
            else
                objPg_Properties.MusicTrack_Search = "";

            if (objPg_Properties.MusicLabel_Search != "" && objPg_Properties.MusicLabel_Search != null)
                objPg_Properties.MusicLabel_Search = objPg_Properties.MusicLabel_Search;
            else
                objPg_Properties.MusicLabel_Search = "";

            if (objPg_Properties.MovieAlbum_Search != "" && objPg_Properties.MovieAlbum_Search != null)
                objPg_Properties.MovieAlbum_Search = objPg_Properties.MovieAlbum_Search;
            else
                objPg_Properties.MovieAlbum_Search = "";

            if (objPg_Properties.MusicAlbumType_Search != "" && objPg_Properties.MusicAlbumType_Search != null)
                objPg_Properties.MusicAlbumType_Search = objPg_Properties.MusicAlbumType_Search;
            else
                objPg_Properties.MusicAlbumType_Search = "";

            if (objPg_Properties.StarCast_Search != "" && objPg_Properties.StarCast_Search != null)
                objPg_Properties.StarCast_Search = objPg_Properties.StarCast_Search;
            else
                objPg_Properties.StarCast_Search = "";

            if (objPg_Properties.Singer_Search != "" && objPg_Properties.Singer_Search != null)
                objPg_Properties.Singer_Search = objPg_Properties.Singer_Search;
            else
                objPg_Properties.Singer_Search = "";

            if (objPg_Properties.TitleLanguage_Search != "" && objPg_Properties.TitleLanguage_Search != null)
                objPg_Properties.TitleLanguage_Search = objPg_Properties.TitleLanguage_Search;
            else
                objPg_Properties.TitleLanguage_Search = "";

            if (objPg_Properties.Genres_Search != "" && objPg_Properties.Genres_Search != null)
                objPg_Properties.Genres_Search = objPg_Properties.Genres_Search;
            else
                objPg_Properties.Genres_Search = "";

            if (objPg_Properties.ErrorMsg_Search != "" && objPg_Properties.ErrorMsg_Search != null)
                objPg_Properties.ErrorMsg_Search = objPg_Properties.ErrorMsg_Search;
            else
                objPg_Properties.ErrorMsg_Search = "";

            if (objPg_Properties.Status_Search != "" && objPg_Properties.Status_Search != null)
                objPg_Properties.Status_Search = objPg_Properties.Status_Search;
            else
                objPg_Properties.Status_Search = "";

            objJson.Add("objPg_Properties", objPg_Properties);
            return Json(objJson);
        }
        public void AdvanceSearch(string MusicTrackName = "", string MusicAlbumType = "", string TitleLanguage = "", string MovieAlbum = "", string Singers = "", string Genres = "", string StarCast = "", string Status = "", string ErrorMsg = "", string MusicLabel = "")
        {
            objPg_Properties.MusicTrack_Search = MusicTrackName;
            objPg_Properties.MusicAlbumType_Search = MusicAlbumType;
            objPg_Properties.TitleLanguage_Search = TitleLanguage;
            objPg_Properties.MovieAlbum_Search = MovieAlbum;
            objPg_Properties.Singer_Search = Singers;
            objPg_Properties.Genres_Search = Genres;
            objPg_Properties.StarCast_Search = StarCast;
            objPg_Properties.Status_Search = Status;
            objPg_Properties.ErrorMsg_Search = ErrorMsg;
            objPg_Properties.MusicLabel_Search = MusicLabel;
        }
        public void AdvanceSearchT(string TitleName = "", string TitleType = "", string TitleLanguage = "", string KeyStarCast = "", string Director = "", string MusicLabel = "", string Status = "", string ErrorMsg = "")
        {
            objPage_Properties.TitleName_Search = TitleName;
            objPage_Properties.TitleType_Search = TitleType;
            objPage_Properties.TitleLanguage_Search = TitleLanguage;
            objPage_Properties.Status_Search = Status;
            objPage_Properties.Director_Search = Director;
            objPage_Properties.MusicLabel_Search = MusicLabel;
            objPage_Properties.KeyStarCast_Search = KeyStarCast;
            objPage_Properties.ErrorMsg_Search = ErrorMsg;
        }
        public void ClearAllAdvanceSearchMT()
        {
            objPg_Properties.MusicTrack_Search = "";
            objPg_Properties.MovieAlbum_Search = "";
            objPg_Properties.MusicLabel_Search = "";
            objPg_Properties.Singer_Search = "";
            objPg_Properties.StarCast_Search = "";
            objPg_Properties.TitleLanguage_Search = "";
            objPg_Properties.Genres_Search = "";
            objPg_Properties.Status_Search = "";
            objPg_Properties.MusicAlbumType_Search = "";
            objPg_Properties.ErrorMsg_Search = "";
        }
        public void ClearAllAdvanceSearchT()
        {
            objPage_Properties.TitleName_Search = "";
            objPage_Properties.TitleType_Search = "";
            objPage_Properties.TitleLanguage_Search = "";
            objPage_Properties.Status_Search = "";
            objPage_Properties.KeyStarCast_Search = "";
            objPage_Properties.ErrorMsg_Search = "";
            objPage_Properties.Director_Search = "";
            objPage_Properties.MusicLabel_Search = "";
        }
        public void ExportToExcel(int DM_Import_Master_Code = 0, string FileType = "", string SearchCriteria = "")
        {
            ReportViewer1 = new ReportViewer();
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            string sql = "";
            ReportParameter[] parm = new ReportParameter[4];

            if (FileType == "M")
            {
                string searchMTString = objPg_Properties.MusicTrack_Search.Replace(",", "','");
                string searchMATString = objPg_Properties.MusicAlbumType_Search.Replace(",", "','");
                string searchTLString = objPg_Properties.TitleLanguage_Search.Replace(",", "','");
                string searchMAString = objPg_Properties.MovieAlbum_Search.Replace(",", "','");
                string searchSingersString = objPg_Properties.Singer_Search.Replace(",", "','");
                string searchGenreString = objPg_Properties.Genres_Search.Replace(",", "','");
                string searchStarCastString = objPg_Properties.Status_Search.Replace(",", "','");
                string searchStatusString = objPg_Properties.Status_Search.Replace(",", "','");
                string searchErrorMsgString = objPg_Properties.ErrorMsg_Search.Replace(",", "','");
                string searchMLString = objPg_Properties.MusicLabel_Search.Replace(",", "','");
                string searchChkStatusString = objPg_Properties.chkStatus_Search.Replace(",", "','");

                if (objPg_Properties.MusicTrack_Search != "")
                    sql += " AND [Music_Title_Name] IN(" + "'" + searchMTString + "')";
                if (objPg_Properties.MusicAlbumType_Search != "")
                    sql += " AND [Music_Album_Type] IN(" + "'" + searchMATString + "')";
                if (objPg_Properties.TitleLanguage_Search != "")
                    sql += " AND TL.Language IN(" + "'" + searchTLString + "')";
                if (objPg_Properties.MovieAlbum_Search != "")
                    sql += " AND [Movie_Album] IN(" + "'" + searchMAString + "')";
                if (objPg_Properties.Singer_Search != "")
                    sql += " AND TS.Singer IN(" + "'" + searchSingersString + "')";
                if (objPg_Properties.Genres_Search != "")
                    sql += " AND [Genres] IN(" + "'" + searchGenreString + "')";
                if (objPg_Properties.Status_Search != "" && objPg_Properties.Status_Search != "Y")
                    sql += " AND [Record_Status] IN(" + "'" + searchStatusString + "')";
                if (objPg_Properties.Status_Search != "" && objPg_Properties.Status_Search == "Y")
                    sql += " AND [Is_Ignore] =" + "'" + searchStatusString + "'";
                if (objPg_Properties.chkStatus_Search != "" && objPg_Properties.chkStatus_Search != "Y")
                    sql += " AND [Record_Status] IN(" + "'" + searchChkStatusString + "')";
                if (objPg_Properties.ErrorMsg_Search != "")
                    sql += " AND  TEM.ErrorMessage IN (" + "'" + searchErrorMsgString + "')";
                if (objPg_Properties.MusicLabel_Search != "")
                    sql += " AND  [Music_Label] IN (" + "'" + searchMLString + "')";

            }
            if (FileType == "T")
            {
                string SearchTitleName = objPage_Properties.TitleName_Search.Replace(",", "','");
                string SearchTitleType = objPage_Properties.TitleType_Search.Replace(",", "','");
                string searchTLString = objPage_Properties.TitleLanguage_Search.Replace(",", "','");
                string searchStarCast = objPage_Properties.KeyStarCast_Search.Replace(",", "','");
                string searchStatus = objPage_Properties.Status_Search.Replace(",", "','");
                string searchErrorMsg = objPage_Properties.ErrorMsg_Search.Replace(",", "','");
                string searchDirector = objPage_Properties.Director_Search.Replace(",", "','");
                string searchTChkStatusString = objPage_Properties.chkStatus_Search.Replace(",", "','");
                string searchMusicLabel = objPage_Properties.MusicLabel_Search.Replace(",", "','");

                if (objPage_Properties.TitleName_Search != "")
                    sql += " AND [Original Title (Tanil/Telugu)] IN(" + "'" + SearchTitleName + "')";
                if (objPage_Properties.TitleType_Search != "")
                    sql += " AND [Title Type] IN(" + "'" + SearchTitleType + "')";
                if (objPage_Properties.TitleLanguage_Search != "")
                    sql += " AND [Original Language (Hindi)] IN(" + "'" + searchTLString + "')";
                if (objPage_Properties.KeyStarCast_Search != "")
                    sql += " AND TKST.StarCast IN(" + "'" + searchStarCast + "')";
                if (objPage_Properties.Status_Search != "" && objPage_Properties.Status_Search != "Y")
                    sql += " AND [Record_Status] IN(" + "'" + searchStatus + "')";
                if (objPage_Properties.Status_Search != "" && objPage_Properties.Status_Search == "Y")
                    sql += " AND [Is_Ignore] =" + "'" + searchStatus + "'";
                if (objPage_Properties.chkStatus_Search != "" && objPage_Properties.chkStatus_Search != "Y")
                    sql += " AND [Record_Status] IN(" + "'" + searchTChkStatusString + "')";
                if (objPage_Properties.ErrorMsg_Search != "")
                    sql += " AND TCEM.ErrorMessage  IN(" + "'" + searchErrorMsg + "')";
                if (objPage_Properties.Director_Search != "")
                    sql += " AND TD.Director  IN(" + "'" + searchDirector + "')";
                if (objPage_Properties.MusicLabel_Search != "")
                    sql += " AND TML.MusicLabel  IN(" + "'" + searchMusicLabel + "')";
            }

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
            if (FileType == "T")
                Response.AddHeader("Content-disposition", "filename=TitleDetails.xls");
            else
                Response.AddHeader("Content-disposition", "filename=MusicTitleDetails.xls");
            Response.OutputStream.Write(buffer, 0, buffer.Length);
            Response.End();

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
                ReportViewer1.ServerReport.ReportServerUrl = new Uri(ReportingServer);
            }
        }

     
    }
    public class Talent_Validation
    {
        public string Talent_Name;
        public string Role_Name;
    }

    internal class TabPaging
    {
        public int PageNo_TA { get; set; }
        public int PageSize_TA { get; set; }
        public int PageNo_LB { get; set; }
        public int PageSize_LB { get; set; }
        public int PageNo_GE { get; set; }
        public int PageSize_GE { get; set; }
        public int PageNo_MA { get; set; }
        public int PageSize_MA { get; set; }
        public int PageNo_ML { get; set; }
        public int PageSize_ML { get; set; }
        public int PageNo_MT { get; set; }
        public int PageSize_MT { get; set; }
        public int PageNo_TT { get; set; }
        public int PageSize_TT { get; set; }
        public int PageNo_TL { get; set; }
        public int PageSize_TL { get; set; }
        public int PageNo_PC { get; set; }
        public int PageSize_PC { get; set; }
        public int PageNo_OL { get; set; }
        public int PageSize_OL { get; set; }
        public int PageNo_PG { get; set; }
        public int PageSize_PG { get; set; }
        public int PageNo_BA { get; set; }
        public int PageSize_BA { get; set; }
        public int PageNo_LA { get; set; }
        public int PageSize_LA { get; set; }
        public int PageNo_VE { get; set; }
        public int PageSize_VE { get; set; }

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
    public class TitleBulkImportSearch
    {
        public string TitleName_Search { get; set; }
        public string TitleType_Search { get; set; }
        public string TitleLanguage_Search { get; set; }
        public string KeyStarCast_Search { get; set; }
        public string MusicLabel_Search { get; set; }
        public string Director_Search { get; set; }
        public string Status_Search { get; set; }
        public string chkStatus_Search { get; set; }
        public string ErrorMsg_Search { get; set; }
    }
    public class MusicTitleBulkImportSearch
    {
        public string MusicAlbumType_Search { get; set; }
        public string TitleLanguage_Search { get; set; }
        public string StarCast_Search { get; set; }
        public string MusicTrack_Search { get; set; }
        public string MovieAlbum_Search { get; set; }
        public string MusicLabel_Search { get; set; }
        public string Singer_Search { get; set; }
        public string Genres_Search { get; set; }
        public string Status_Search { get; set; }
        public string chkStatus_Search { get; set; }
        public string ErrorMsg_Search { get; set; }
    }

}
