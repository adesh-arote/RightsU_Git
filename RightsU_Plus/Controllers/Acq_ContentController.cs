using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Data.Entity.Core.Objects;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Collections;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using System.Data;
using System.Data.OleDb;
using System.Net;
using Microsoft.Reporting.WebForms;
//using Microsoft.Office.Interop.Excel;


namespace RightsU_Plus.Controllers
{
    public class Acq_ContentController : BaseController
    {
        ReportViewer ReportViewer1;
        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 1;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }

        public Acq_Deal objAD_Session
        {
            get
            {
                if (Session[RightsU_Session.SESS_DEAL] == null)
                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal();

                return (Acq_Deal)Session[RightsU_Session.SESS_DEAL];
            }
            set { Session[RightsU_Session.SESS_DEAL] = value; }
        }

        public Acq_Deal_Service objADS
        {
            get
            {
                if (Session["ADS_Acq_Content"] == null)
                    Session["ADS_Acq_Content"] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Service)Session["ADS_Acq_Content"];
            }
            set { Session["ADS_Acq_Content"] = value; }
        }

        public int Deal_Type_Code
        {
            get;
            set;
        }

        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }

        private List<USP_List_Deal_Title_Content_Result> lstDealTitleContent
        {
            get
            {
                if (Session["USP_List_Deal_Title_Content_Result"] == null)
                    Session["USP_List_Deal_Title_Content_Result"] = new List<USP_List_Deal_Title_Content_Result>();
                return (List<USP_List_Deal_Title_Content_Result>)Session["USP_List_Deal_Title_Content_Result"];
            }
            set { Session["USP_List_Deal_Title_Content_Result"] = value; }
        }


        public int Acq_Deal_code
        {
            set
            {
                Session["Acq_Deal_code"] = value;
            }
            get
            {
                return Convert.ToInt32(Session["Acq_Deal_code"]);
            }
        }

        private string _mode;
        public string Mode
        {
            get { return this._mode; }
            set { this._mode = value; }
        }

        public ActionResult Index(string hdnTitleCode = "")
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString"] != null)
            {
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
                objDeal_Schema = null;
                Acq_Deal_code = Convert.ToInt32(obj_Dictionary["Acq_Deal_Code"]);
                objDeal_Schema.Mode = obj_Dictionary["Mode"];
            }
            else
            {
                Acq_Deal_code = objDeal_Schema.Deal_Code;
            }

            objDeal_Schema.Page_From = GlobalParams.Page_From_General;
            objAD_Session = objADS.GetById(Acq_Deal_code);

            objDeal_Schema.List_Deal_Tag = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Deal_Tag_Code", "Deal_Tag_Description",
                                           objAD_Session.Deal_Tag_Code == 0 ? 1 : objAD_Session.Deal_Tag_Code).ToList();
            objDeal_Schema.Module_Rights_List = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objLoginUser.Security_Group_Code
                                                && i.System_Module_Rights_Code == i.System_Module_Right.Module_Right_Code && i.System_Module_Right.Module_Code == 30)
                                                .Select(i => i.System_Module_Right.Right_Code).Distinct().ToList();

            BindSchemaObject();

            if (objAD_Session.Master_Deal_Movie_Code_ToLink == null)
                objAD_Session.Master_Deal_Movie_Code_ToLink = 0;


            #region --- Bind Title Search DropDownList ---
            ViewBag.TitleList = GetTitleSearchList(hdnTitleCode);
            #endregion

            if (string.IsNullOrEmpty(objDeal_Schema.Content_Search_Titles))
                objDeal_Schema.Content_Search_Titles = "";

            return View();
        }

        private void ClearSession()
        {
            objADS = null;
            objAD_Session = null;
            objDeal_Schema = null;
        }

        private MultiSelectList GetTitleSearchList(string hdnTitleCode = "")
        {
            int[] arrADMCode = objAD_Session.Acq_Deal_Movie.Select(s => s.Acq_Deal_Movie_Code).ToArray();
            List<RightsU_Entities.Title> lstTitleSearch = new Title_Content_Mapping_Service(objLoginEntity.ConnectionStringName).
                SearchFor(x => arrADMCode.Contains((int)x.Acq_Deal_Movie_Code)).
                Select(p => p.Title_Content.Title).ToList().Distinct().OrderBy(o => o.Title_Name).ToList();
            return new MultiSelectList(lstTitleSearch, "Title_Code", "Title_Name", hdnTitleCode.Split(','));
        }

        private void BindSchemaObject(bool BindOnlyTitleList = false)
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString"] != null)
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
            if (!BindOnlyTitleList)
            {
                objDeal_Schema.Agreement_Date = objAD_Session.Agreement_Date;

                if (objAD_Session.Deal_Type_Code != null)
                    objDeal_Schema.Deal_Type_Code = (int)objAD_Session.Deal_Type_Code;

                if (objAD_Session.Acq_Deal_Code > 0)
                {
                    objDeal_Schema.Deal_Code = objAD_Session.Acq_Deal_Code;
                    objDeal_Schema.Agreement_No = objAD_Session.Agreement_No;
                    objDeal_Schema.Deal_Desc = objAD_Session.Deal_Desc;
                    objDeal_Schema.Version = objAD_Session.Version;

                    if (objAD_Session.Deal_Tag != null)
                        objDeal_Schema.Status = objAD_Session.Deal_Tag.Deal_Tag_Description;
                    else
                        objDeal_Schema.Status = new Deal_Tag_Service(objLoginEntity.ConnectionStringName).GetById((int)objAD_Session.Deal_Tag_Code).Deal_Tag_Description;

                    objDeal_Schema.Year_Type = objAD_Session.Year_Type;
                    objDeal_Schema.Deal_Workflow_Flag = objAD_Session.Deal_Workflow_Status;

                    int[] arrTitleCodes = objAD_Session.Acq_Deal_Movie.Select(x => (int)x.Title_Code).Distinct().ToArray();
                    string titleImagePath = ConfigurationManager.AppSettings["TitleImagePath"];
                    if (arrTitleCodes.Length == 1)
                        objDeal_Schema.Title_Image_Path = titleImagePath + new Title_Service(objLoginEntity.ConnectionStringName).GetById(arrTitleCodes[0]).Title_Image;
                    else
                    {
                        objDeal_Schema.Title_Image_Path = titleImagePath + "movieIcon.png";
                    }


                    if (string.IsNullOrEmpty(objAD_Session.Deal_Complete_Flag))
                        objAD_Session.Deal_Complete_Flag = "";

                    if (TempData["QueryString"] != null && obj_Dictionary["RLCode"] != null)
                        objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);
                    if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_ADD && objAD_Session.Acq_Deal_Code > 0)
                        objDeal_Schema.Mode = GlobalParams.DEAL_MODE_EDIT;
                    objDeal_Schema.Deal_Type_Condition = GlobalUtil.GetDealTypeCondition((int)objAD_Session.Deal_Type_Code);
                    objDeal_Schema.Master_Deal_Movie_Code = (objAD_Session.Master_Deal_Movie_Code_ToLink == null) ? 0 : (int)objAD_Session.Master_Deal_Movie_Code_ToLink;
                }
                else
                {
                    objDeal_Schema.Agreement_No = "";
                    objDeal_Schema.Version = "0001";
                    objDeal_Schema.Deal_Workflow_Flag = "O";
                }

                if (TempData["QueryString"] != null && obj_Dictionary["PageNo"] != null)
                    objDeal_Schema.PageNo = Convert.ToInt32(obj_Dictionary["PageNo"].ToString());
                if (TempData["QueryString"] != null && obj_Dictionary["RLCode"] != null)
                    objDeal_Schema.Record_Locking_Code = Convert.ToInt32(obj_Dictionary["RLCode"]);
            }
            objDeal_Schema.Arr_Title_Codes = objAD_Session.Acq_Deal_Movie.Where(x => x.Is_Closed != "X" && x.Is_Closed != "Y").Select(s => Convert.ToInt32(s.Title_Code)).ToArray();
            objDeal_Schema.Title_List.Clear();


            string toolTip;
            GetIconPath(objDeal_Schema.Deal_Type_Code, out toolTip);


            foreach (Acq_Deal_Movie objADM in objAD_Session.Acq_Deal_Movie)
            {
                if (objADM.Is_Closed != "Y" && objADM.Is_Closed != "X")
                {
                    Title_List objTL = new Title_List();

                    objTL.Acq_Deal_Movie_Code = objADM.Acq_Deal_Movie_Code;
                    objTL.Title_Code = (int)objADM.Title_Code;

                    if (objADM.Episode_Starts_From != null)
                        objTL.Episode_From = (int)objADM.Episode_Starts_From;
                    if (objADM.Episode_End_To != null)
                        objTL.Episode_To = (int)objADM.Episode_End_To;

                    objDeal_Schema.Title_List.Add(objTL);
                }
            }
        }

        private string GetIconPath(int dealTypeCode, out string titleIconTooltip)
        {
            dealTypeCode = (dealTypeCode == 0) ? 1 : dealTypeCode;
            string iconPath = ConfigurationManager.AppSettings["TitleImagePath"].TrimStart('~').TrimStart('/');
            string fileName = ConfigurationManager.AppSettings["DefaultTitleIcon"];
            if (objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(i => i.Title_Code).Distinct().Count() == 1)
            {
                int title_Code = (int)objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).First().Title_Code;
                RightsU_Entities.Title objT = new Title_Service(objLoginEntity.ConnectionStringName).GetById(title_Code);

                if (!string.IsNullOrEmpty(objT.Title_Image))
                    fileName = objT.Title_Image;
            }

            iconPath += fileName;
            Deal_Type_Code = dealTypeCode;
            objDeal_Schema.Title_Icon_Path = fileName;
            objDeal_Schema.Title_Icon_Tooltip = "Deal Type - " + GetTitleLabel(Deal_Type_Code);

            titleIconTooltip = objDeal_Schema.Title_Icon_Tooltip;
            return iconPath;
        }

        private string GetTitleLabel(int dealTypeCode)
        {
            Deal_Type_Code = dealTypeCode;
            string Title_Label = "";
            if (Deal_Type_Code == GlobalParams.Deal_Type_Movie)
                Title_Label = "Movie";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Documentary_Film)
                Title_Label = "Documentary Film";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Content)
                Title_Label = "Program";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Event)
                Title_Label = "Event";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Documentary_Show)
                Title_Label = "Deal Documentary Show";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Sports)
                Title_Label = "Sports";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Music)
                Title_Label = "Music";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Format_Program)
                Title_Label = "Format Program";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Performer)
                Title_Label = "Performer";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Writer)
                Title_Label = "Writer";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Music_Composer)
                Title_Label = "Music Composer";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_DOP)
                Title_Label = "DOP";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Choreographer)
                Title_Label = "Choreographer";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Lyricist)
                Title_Label = "Lyricist";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Director)
                Title_Label = "Director";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_VideoMusic)
                Title_Label = "Video Company";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Singer)
                Title_Label = "Singer";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Other_Talent)
                Title_Label = "Other Talent";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Contestant)
                Title_Label = "Contestant Name";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_Producer)
                Title_Label = "Producer";
            else if (Deal_Type_Code == GlobalParams.Deal_Type_ShortFlim)
                Title_Label = "Deal For Short Film";

            return Title_Label;
        }

        public PartialViewResult BindContent(string hdnTitleCode = "", int PageNumber = 0, int PageSize = 50, int RecordCode = 0)
        {
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
            if (hdnTitleCode == null || hdnTitleCode == "")
                hdnTitleCode = "";

            PageNo = PageNumber + 1;
            int RecordCount = 0;

            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            lstDealTitleContent = objUsp.USP_List_Deal_Title_Content(hdnTitleCode, objDeal_Schema.Deal_Code, PageNo, "Y", PageSize, objRecordCount).ToList();

            RecordCount = Convert.ToInt32(objRecordCount.Value);

            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = PageNo;
            ViewBag.EditRecordCode = RecordCode;
            objDeal_Schema.Content_PageNo = PageNumber;
            objDeal_Schema.Content_PageSize = PageSize;
            objDeal_Schema.Content_Search_Titles = hdnTitleCode;
            return PartialView("_List", lstDealTitleContent);
        }

        public JsonResult Save(int Record_Code = 0, string Title_Name = "", string Duration = "")
        {
            int pageNo = objDeal_Schema.Content_PageNo;
            dynamic resultSet;
            Title_Content objTC = new Title_Content();
            Title_Content_Service objTCService = new Title_Content_Service(objLoginEntity.ConnectionStringName);
            objTC = objTCService.GetById(Record_Code);
            objTC.Episode_Title = Title_Name;
            objTC.Duration = Convert.ToDecimal(Duration);
            objTC.EntityState = State.Modified;
            objTCService.Save(objTC, out resultSet);

            Dictionary<string, object> objJson = new Dictionary<string, object>();
            objJson.Add("Message", "Episode Title Updated Successfully");
            objJson.Add("PageNo", objDeal_Schema.Content_PageNo);
            objJson.Add("Error", "");
            return Json(objJson);
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            objDeal_Schema = null;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            return RedirectToAction("Index", "Acq_List");
        }

        public void ResetMessageSession()
        {
            Session["Message"] = string.Empty;
        }

        public void ExportToExcel(string TitleName = " ")
        {
            ReportViewer1 = new ReportViewer();
            if (TitleName == "")
                TitleName = " ";
            int RecordCount = 0;
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            ReportParameter[] parm = new ReportParameter[6];
            parm[0] = new ReportParameter("StrSearch", TitleName);
            parm[1] = new ReportParameter("Acq_Deal_Code", Convert.ToString(objDeal_Schema.Deal_Code));
            parm[2] = new ReportParameter("PageNo", Convert.ToString(1));
            parm[3] = new ReportParameter("IsPaging", "N");
            parm[4] = new ReportParameter("PageSize", "50");
            parm[5] = new ReportParameter("RecordCount", Convert.ToString(RecordCount));
            ReportCredential();
            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptDealContent");
            }
            ReportViewer1.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer1.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename=ContentList.xls");
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
        public string UploadTitle(HttpPostedFileBase InputFile)
        {
            string message = "";
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
                        string fullpathname = Server.MapPath("~") + "\\" + ConfigurationManager.AppSettings["UploadFilePath"] + strActualFileNameWithDate;
                        PostedFile.SaveAs(fullpathname);
                        OleDbConnection cn;
                        ds = new DataSet();
                        try
                        {
                            cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1'");
                            OleDbCommand cmdExcel = new OleDbCommand();
                            OleDbDataAdapter oda = new OleDbDataAdapter();
                            System.Data.DataTable dt = new System.Data.DataTable();
                            cmdExcel.Connection = cn;
                            cn.Open();
                            System.Data.DataTable dtExcelSchema;
                            dtExcelSchema = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                            string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                            cn.Close();
                            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + SheetName + "]", cn);
                            da.Fill(ds);
                        }
                        catch (Exception ex)
                        {
                            message = ex.ToString();
                        }
                        finally
                        {
                            //Always delete uploaded excel file from folder.
                            System.IO.File.Delete(fullpathname.Trim());
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
                        }
                        /*Data Insertion*/
                        if (ds.Tables[0].Columns[0].ColumnName != "Acquisition Deal Movie Content Code" || ds.Tables[0].Columns[1].ColumnName != "Episode Title"
                            || ds.Tables[0].Columns[2].ColumnName != "Episode No" || ds.Tables[0].Columns[3].ColumnName != "Duration")
                        {
                            message = "E~File is not in Proper Format";
                        }
                        else
                        {
                            if (ds.Tables[0].Columns.Count == 4)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    int errCount = 0;
                                    List<Title_Content_UDT> lst_Import_UDT = new List<Title_Content_UDT>();
                                    foreach (DataRow row in ds.Tables[0].Rows)
                                    {
                                        Title_Content_UDT obj_Import_UDT = new Title_Content_UDT();
                                        int i = 0;
                                        decimal j;
                                        int k = 0;
                                        bool iresult = int.TryParse((row["Acquisition Deal Movie Content Code"]).ToString(), out i);
                                        bool dresult = decimal.TryParse((row["Duration"]).ToString(), out j);
                                        bool kresult = int.TryParse((row["Duration"]).ToString(), out k);
                                        if (iresult)
                                        {
                                            if ((row["Acquisition Deal Movie Content Code"]).ToString().Trim() == "")
                                                obj_Import_UDT.Title_Content_Code = null;
                                            else
                                                obj_Import_UDT.Title_Content_Code = Convert.ToInt32(row["Acquisition Deal Movie Content Code"]);
                                        }
                                        else
                                        {
                                            errCount += 1;
                                        }
                                        obj_Import_UDT.Episode_Title = row["Episode Title"].ToString();

                                        if ((row["Duration"]).ToString().Trim() == "")
                                            obj_Import_UDT.Duration = null;
                                        else
                                        {
                                            if (dresult || kresult)
                                                obj_Import_UDT.Duration = Convert.ToDecimal(row["Duration"]);
                                            else
                                                errCount += 1;
                                        }

                                        lst_Import_UDT.Add(obj_Import_UDT);
                                    }
                                    if (errCount > 0)
                                        message = "E~File is not in Proper Format";
                                    else
                                    {
                                        message = Convert.ToString((new USP_Service(objLoginEntity.ConnectionStringName).USP_Import_Title_Content_UDT(lst_Import_UDT, objDeal_Schema.Deal_Code)).FirstOrDefault().Err_Message);
                                    }
                                }
                                else
                                {
                                    message = "E~please Fill the Data in the Excel File";
                                }
                            }
                            else
                            {
                                message = "E~please Fill Correct Data in the Excel File";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        message = "E~Excel File is not in proper format";
                    }
                }
                else
                {
                    message = "E~Please Select Excel File...";
                }

            }
            else
            {
                message = "E~Please Select Excel File...";

            }
            return message;
        }
    }
}
