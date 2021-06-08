using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Web.UI;
using System.Data;
using System.Web.UI.WebControls;
using System.Runtime.Serialization.Formatters.Binary;
using System.Data.OleDb;
using System.Configuration;
using System.Net;
using Microsoft.Reporting.WebForms;

namespace RightsU_Plus.Controllers
{
    public class Title_ListController : BaseController
    {
        #region---Properties---
        ReportViewer ReportViewer1;

        public RightsU_Entities.Title objTitle
        {
            get
            {
                if (Session["Session_Title_List"] == null)
                    Session["Session_Title_List"] = new RightsU_Entities.Title();
                return (RightsU_Entities.Title)Session["Session_Title_List"];
            }
            set { Session["Session_Title_List"] = value; }
        }

        public USP_Title_List_Result obj_Title_List
        {
            get { return (USP_Title_List_Result)Session["obj_Title_List"]; }
            set { Session["obj_Title_List"] = value; }
        }

        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 0;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }

        public int recordPerPage
        {
            get
            {
                if (Session["recordPerPage"] == null)
                    Session["recordPerPage"] = 10;
                return (int)Session["recordPerPage"];
            }
            set { Session["recordPerPage"] = value; }
        }

        public int moduleCode
        {
            get
            {
                if (TempData["ModuleCode"] == null)
                    TempData["ModuleCode"] = 114;
                return (int)TempData["ModuleCode"];
            }
            set { TempData["ModuleCode"] = value; }
        }
        private string logFileName = "Reshma_Log.txt";

        public Title_Search objPage_Properties
        {
            get
            {
                if (Session["Title_Search_Page_Properties"] == null)
                    Session["Title_Search_Page_Properties"] = new Title_Search();
                return (Title_Search)Session["Title_Search_Page_Properties"];
            }
            set { Session["Title_Search_Page_Properties"] = value; }
        }

        public List<Map_Extended_Columns> lstAddedExtendedColumns
        {
            get
            {
                if (Session["lstAddedExtendedColumns"] == null)
                    Session["lstAddedExtendedColumns"] = new List<Map_Extended_Columns>();
                return (List<Map_Extended_Columns>)Session["lstAddedExtendedColumns"];
            }
            set
            {
                Session["lstAddedExtendedColumns"] = value;
            }

        }
        private List<RightsU_Entities.Title_Milestone> lstTitle_Milestone
        {
            get
            {
                if (Session["lstTitle_Milestone"] == null)
                    Session["lstTitle_Milestone"] = new List<RightsU_Entities.Title_Milestone>();
                return (List<RightsU_Entities.Title_Milestone>)Session["lstTitle_Milestone"];
            }
            set { Session["lstTitle_Milestone"] = value; }
        }
        #endregion

        public JsonResult CheckRecordLock(int Music_Deal_Code, char Deal_Mode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Music_Deal_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Music_Deal_Code, GlobalParams.ModuleCodeForTitle, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }
            if (isLocked)
                objPage_Properties.RecordLockingCode = RLCode;

            if ((Deal_Mode == 'E' || Deal_Mode == 'R' || Deal_Mode == 'M') && isLocked)
                TempData["RecodLockingCode"] = objPage_Properties.RecordLockingCode;


            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult CheckRecordCurrentStatus(int Title_Deal_Code)
        {
            string message = "";
            int RLCode = 0;
            bool isLocked = false;
            //int count = new Music_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Music_Deal_Code == Music_Deal_Code && (s.Deal_Workflow_Status == "A" || s.Deal_Workflow_Status == "W")).Count();
            //if (count > 0)
            //    message = "The deal is already processed by another Approver";
            // else 
            if (Title_Deal_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Title_Deal_Code, GlobalParams.ModuleCodeForTitle, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
            }
            var obj = new
            {
                //BindList = (count > 0) ? "Y" : "N",
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = message,
                Record_Locking_Code = RLCode
                //Title_Deal_Code = Title_Deal_Code
            };

            return Json(obj);
        }
        public ActionResult Index(string TitleName = "", string DealTypeCode = "0", int PageIndex = 0, string CallFrom = "", int Page_No = 0, int PageSize = 10)
        {
            ViewBag.isAdvanced = "N";
            ViewBag.isSearch = "N";
            //CommonUtil.WriteErrorLog("Called Index Action of Title_ListController", logFileName);

            //ViewBag.StarCast_Code = objPage_Properties.StarCastCodes_Search;
            //BindAdvanced_Search_Controls();
            //BindDDL();
            string IsMenu = "";
            Dictionary<string, string> obj_Dic_Layout = new Dictionary<string, string>();
            if (TempData["QS_LayOut"] != null)
            {
                obj_Dic_Layout = TempData["QS_LayOut"] as Dictionary<string, string>;
                IsMenu = obj_Dic_Layout["IsMenu"];
                //TempData.Keep("QS_LayOut");
            }
            int RecordLockingCode = objPage_Properties.RecordLockingCode;
            if (IsMenu == "Y")
            {
                recordPerPage = 10;
                clearAllAdvanceSearch();
                objPage_Properties.PageNo = 1;
                objPage_Properties.genericSearch = "";

            }
            if (CallFrom == "")
                objPage_Properties = null;
            if (Page_No > 0)
                objPage_Properties.PageNo = Page_No;
            ///CommonUtil.WriteErrorLog("Called Before BindTitleType", logFileName);


            if (Page_No != 0)
                ViewBag.Query_String_Page_No = objPage_Properties.PageNo - 1;
            else
                ViewBag.Query_String_Page_No = 0;
            ViewBag.DealTypeCode = DealTypeCode;
            ViewBag.SearchedTitle = TitleName;
            ViewBag.PageSize = PageSize;

            int dTCode = Convert.ToInt32(DealTypeCode);
            if (dTCode == 1)
                dTCode = GlobalParams.Deal_Type_Movie;


            if (RecordLockingCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(RecordLockingCode, objLoginEntity.ConnectionStringName);
            }


            //CommonUtil.WriteErrorLog("Called Before USP_MODULE_RIGHTS", logFileName);
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitle), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            ViewBag.buttonVisibility = addRights.FirstOrDefault();
            //string v = addRights.FirstOrDefault();
            //CommonUtil.WriteErrorLog("Called Before BindTitle", logFileName);
            //ViewBag.TitleList = Bind_Title(dTCode, 0, TitleName, "Y");
            BindTitleType();

            List<USP_Title_List_Result> TitleList = new List<USP_Title_List_Result>();
            //CommonUtil.WriteErrorLog("Called After BindTitle", logFileName);
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTitle);
            Session["FileName"] = "";
            Session["FileName"] = "TitleList";
            return View(TitleList);

        }

        //public List<USP_Title_List_Result> BindGrid(string TitleName = "", string DealTypeCode = "1",int PageIndex=0)
        //public JsonResult BindGrid(string TitleName = "", string DealTypeCode = "1", int PageIndex = 0)
        public PartialViewResult BindGrid(string TitleName = "", string DealTypeCode = "0", int PageIndex = 0, int Selected_BU = 1, string IsShowAll = "", int PageSize = 0, string isSearch = "", string isTAdvanced = "", string GenericSearch = "")
        {

            string[] searchString;
            string ExactMatchStr = GenericSearch;
            GenericSearch = !string.IsNullOrEmpty(GenericSearch.Trim()) ? GenericSearch.Trim().Replace("'", "''") : "";
            var Is_AcqSyn_Type_Of_Film = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").First().Parameter_Value;

            if (GenericSearch == "" && objPage_Properties.isSearch == "Y")
                searchString = objPage_Properties.genericSearch.Split(new string[] { ",", ";", "/", " " }, StringSplitOptions.RemoveEmptyEntries);
            else
                searchString = GenericSearch.Split(new string[] { ",", ";", "/", " " }, StringSplitOptions.RemoveEmptyEntries);

            string newString = "";
            string newLanguage = "";
            string newLProgram = "";
            string newOrigtitleString = "";
            string newTyopOfFilm = "";

            for (int i = 1; i <= searchString.Length; i++)
            {
                if (searchString.Length > 0)
                {
                    if (i == searchString.Length)
                    {
                        newLanguage += "Language_Name Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + "";
                        newString += "T.Title_Name Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + "";
                        if (Is_AcqSyn_Type_Of_Film == "Y")
                        {
                            newTyopOfFilm += "ECV.Columns_Value Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + "";
                        }
                        newLProgram += "P.Program_Name Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + "";
                        newOrigtitleString += "T.Original_Title Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + "";
                    }
                    else
                    {
                        newLanguage += "Language_Name Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + " OR ";
                        newString += "T.Title_Name Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + " OR ";
                        newLProgram += "P.Program_Name Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + " OR ";
                        newOrigtitleString += "T.Original_Title Like N" + "'" + "%" + (searchString[i - 1]) + "%" + "'" + " OR ";
                    }
                }
            }

            //if (a.EndsWith("OR"))
            //{
            //    a = a.Substring(0, a.Length - 1);
            //}
            // TitleName.Replace("/", " ");
            ViewBag.Is_AcqSyn_Type_Of_Film = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").First().Parameter_Value;
            TitleName.Trim(' ');
            TitleName.TrimEnd(',');
            string sql = "";
            if (isSearch != "")
                objPage_Properties.isSearch = isSearch;
            if (isTAdvanced != "")
                objPage_Properties.isAdvanced = isTAdvanced;
            if (IsShowAll != "")
                objPage_Properties.isShowAll = IsShowAll;
            if (PageSize != 0)
                recordPerPage = PageSize;
            if (isSearch == "Y" || isTAdvanced == "Y")
            {
                if (isSearch == "Y")
                {
                    if (GenericSearch != "")
                        objPage_Properties.genericSearch = GenericSearch;
                    objPage_Properties.isSearch = "Y";
                    ViewBag.isSearch = objPage_Properties.isSearch;
                    ViewBag.isAdvanced = "N";
                    clearAllAdvanceSearch();
                }
                else
                {
                    //objPage_Properties.TitleName = TitleName;
                    if (objPage_Properties.DealTypeCode == "0")
                        objPage_Properties.DealTypeCode = DealTypeCode;
                    //objPage_Properties.DealTypeCode = Convert.ToInt32(DealTypeCode);
                    objPage_Properties.DealTypeCode = DealTypeCode;
                    ViewBag.isAdvanced = "Y";
                    ViewBag.isSearch = "N";
                }
            }
            else if (objPage_Properties.isShowAll == "Y")
            {
                // objPage_Properties.DealTypeCode = Convert.ToInt32(DealTypeCode);
                objPage_Properties.DealTypeCode = DealTypeCode;
                isTAdvanced = "N";
                objPage_Properties.isAdvanced = "N";
                objPage_Properties.isSearch = "N";
                isSearch = "N";
                objPage_Properties.genericSearch = "";
                clearAllAdvanceSearch();
            }


            //if (TitleName == "" && IsShowAll == "N")
            //    TitleName = objPage_Properties.TitleName;
            //if (Convert.ToInt32(DealTypeCode) >= 1 && IsShowAll == "N")
            //    DealTypeCode = Convert.ToString(objPage_Properties.DealTypeCode);

            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            objPage_Properties.DealTypeCode = DealTypeCode;
            objPage_Properties.PageNo = PageIndex + 1;

            List<USP_Title_List_Result> TitleList;
            if (objPage_Properties.isAdvanced == "Y")
            {
                if (objPage_Properties.LanguagesCodes_Search != "")
                    sql += " AND Title_Language_Code IN(" + objPage_Properties.LanguagesCodes_Search + ")";
                if (objPage_Properties.OrigLangCodes_Search != "")
                    sql += " AND Original_Language_Code IN(" + objPage_Properties.OrigLangCodes_Search + ")";
                if (objPage_Properties.YearOfRelease != "")
                    sql += " AND  Year_Of_Production like " + "'" + objPage_Properties.YearOfRelease + "%'";
                if (objPage_Properties.CountryCodes_Search != "")
                    sql += " AND T.Title_Code in (select TC.Title_Code from Title_Country TC where Country_Code in (" + objPage_Properties.CountryCodes_Search + "))";
                if (objPage_Properties.DirectorCodes_Search != "")
                    sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT where Talent_Code in (" + objPage_Properties.DirectorCodes_Search + ") AND Role_Code = " + GlobalParams.RoleCode_Director + ")";
                if (objPage_Properties.StarCastCodes_Search != "")
                    sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT  where Talent_Code in (" + objPage_Properties.StarCastCodes_Search + ") AND Role_Code = " + GlobalParams.RoleCode_StarCast + ")";
                if (objPage_Properties.ProgramCode_Search != "")
                    sql += " AND T.Program_Code IN(" + objPage_Properties.ProgramCode_Search + ")";
                if (objPage_Properties.Column_Name != "")
                    sql += " AND MEC.Columns_Value_Code IN(" + objPage_Properties.Column_Name + ")";
                //if (objPage_Properties.TitleName != "")
                //    sql += " AND T.Title_Name ='" + objPage_Properties.TitleName + "'";
                //    TitleList = objUSP.USP_Title_List(objPage_Properties.TitleName, PageNo, objRecordCount, "Y", PageSize,
                //        objPage_Properties.StarCastCodes_Search, objPage_Properties.LanguagesCodes_Search, objPage_Properties.GenresCodes_Search,
                //        objPage_Properties.MusicLabelCodes_Search, objPage_Properties.YearOfRelease, objPage_Properties.SingerCodes_Search,
                //        objPage_Properties.ComposerCodes_Search, objPage_Properties.LyricistCodes_Search, objPage_Properties.MusicTitleName_Search, objPage_Properties.ThemeCodes_Search, objPage_Properties.Music_Tag_Search).ToList();
                TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), objPage_Properties.TitleName.Replace("'", "''"), objPage_Properties.OrigTitleName.Replace("'", "''"), Selected_BU, objPage_Properties.PageNo, objRecordCount, "Y", recordPerPage, sql).ToList();
            }
            else if (objPage_Properties.isSearch == "Y")
            {
                sql = "AND (T.Deal_Type_Code In(select DT.Deal_Type_Code from Deal_Type DT where Deal_Type_Name like N'" + objPage_Properties.genericSearch + "%') or T.Title_Language_Code IN(select L.Language_Code from [Language] L where " + newLanguage + " ) or " + newString + " OR T.Program_Code IN(select P.Program_Code from [Program] P where " + newLProgram + ") OR " + newOrigtitleString + " OR " + newTyopOfFilm + " )";
                TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), "", "", Selected_BU, objPage_Properties.PageNo, objRecordCount, "Y", recordPerPage, sql, ExactMatchStr).ToList();
            }
            else
                TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), "", "", Selected_BU, objPage_Properties.PageNo, objRecordCount, "Y", recordPerPage, sql).ToList();
            //TitleList = objUSP.USP_Title_List(objPage_Properties.TitleName, PageNo, objRecordCount, "Y", PageSize, "", "", "", "", "", "", "", "", "", "", "").ToList();
            // or T.Program_Code IN(select P.Program_Code from [Program] P where Program_Name like N'" + objPage_Properties.genericSearch + "%')
            RecordCount = Convert.ToInt32(objRecordCount.Value);

            ViewBag.RecordCount = RecordCount;

            if (objPage_Properties.PageNo <= 0)
                ViewBag.PageNo = 1;
            else
                ViewBag.PageNo = objPage_Properties.PageNo;

            ViewBag.PageSize = recordPerPage;
            ViewBag.DealTypeCode = DealTypeCode;
            ViewBag.SearchedTitle = TitleName;

            int dTCode = Convert.ToInt32(DealTypeCode);
            if (dTCode == 1)
                dTCode = GlobalParams.Deal_Type_Movie;
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitle), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            ViewBag.buttonsVisibility = addRights.FirstOrDefault();
            BindTitleType();
            return PartialView("_List_Title", TitleList);

            //return Json(TitleList, JsonRequestBehavior.AllowGet);
        }
        private void clearAllAdvanceSearch()
        {
            objPage_Properties.StarCastCodes_Search = "";
            objPage_Properties.DirectorCodes_Search = "";
            objPage_Properties.YearOfRelease = "";
            objPage_Properties.LanguagesCodes_Search = "";
            objPage_Properties.OrigLangCodes_Search = "";
            objPage_Properties.CountryCodes_Search = "";
            objPage_Properties.DealTypeCode = "";
            objPage_Properties.TitleName = "";
            objPage_Properties.OrigTitleName = "";
            objPage_Properties.ProgramCode_Search = "";
            objPage_Properties.Column_Name = "";
        }
        public PartialViewResult BindLanguage()
        {
            objTitle = new RightsU_Entities.Title();

            int Original_Language_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_OriginalLanguage").Select(i => i.Parameter_Value).FirstOrDefault());

            List<SelectListItem> lstLanguageList = new List<SelectListItem>();
            List<SelectListItem> lstDealType = new List<SelectListItem>();
            List<SelectListItem> lstExtendedColumns = new List<SelectListItem>();
            lstLanguageList = new SelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Language_Code", "Language_Name", Original_Language_code).ToList();
            lstLanguageList.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            string IsTitleProgramCategoryMandatory = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "IsTitleProgramCategoryMandatory").FirstOrDefault().Parameter_Value;
            if (IsTitleProgramCategoryMandatory == "Y")
            {
                //Program Category column code is defined in System Param, make sure System Param has value
                int str_Program_Category_Value = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Parameter_Name == "Program_Category_Value" && i.IsActive == "Y").Select(s => s.Parameter_Value).FirstOrDefault());
                if (str_Program_Category_Value != null)
                {
                    lstExtendedColumns = new SelectList(new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == str_Program_Category_Value).Select(y => new { Text = y.Columns_Value, Value = y.Columns_Value_Code }).Distinct(), "Value", "Text").ToList();
                }
                lstExtendedColumns.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            }
            var IsTitleDurationMandatory = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "IsTitleDurationMandatory").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsTitleDurationMandatory = IsTitleDurationMandatory;
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT", 1, 0, "").ToList();
            lstDealType = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DT"), "Display_Value", "Display_Text").ToList();
            ViewBag.LstExtendedColumns = lstExtendedColumns;
            ViewBag.Language = lstLanguageList;
            ViewBag.DealType = lstDealType;
            ViewBag.PageNo = objPage_Properties.PageNo;
            ViewBag.MusicLabelList = BindMusicLabel();
            if (objPage_Properties.TitleName != "")
                ViewBag.SearchedTitle = objPage_Properties.TitleName;
            if (objPage_Properties.DealTypeCode != "0")
                ViewBag.DealTypeCodeSearch = objPage_Properties.DealTypeCode;
            else
                ViewBag.DealTypeCodeSearch = "0";
            ViewBag.PageSizeCreate = recordPerPage;
            ViewBag.CodeForEmbeddedMusic = GlobalParams.CodeForEmbeddedMusic;
            return PartialView("_Create", objTitle);
        }
        private List<SelectListItem> BindMusicLabel()
        {
            int Label_code = 0;
            List<SelectListItem> lstMusicLabel = new List<SelectListItem>();
            if (objTitle.Music_Label_Code != null)
                Label_code = Convert.ToInt32(objTitle.Music_Label_Code);
            lstMusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name", Label_code).ToList();
            //lstMusicLabel.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });
            return lstMusicLabel;
        }

        private void BindTitleType(string DealTypeCode = "0")
        {
            int a = Convert.ToInt32(DealTypeCode);
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq;
            lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT", Convert.ToInt32(DealTypeCode), 0, "").ToList();
            if (objPage_Properties.DealTypeCode != "0")
            {
                if (objPage_Properties.DealTypeCode == null)
                {
                    ViewBag.DealTypeList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DT"), "Display_Value", "Display_Text", 0).ToList();
                }
                else
                {
                    ViewBag.DealTypeList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DT"), "Display_Value", "Display_Text", objPage_Properties.DealTypeCode).ToList();
                }
            }
            else
            {
                ViewBag.DealTypeList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DT"), "Display_Value", "Display_Text", a).ToList();
            }
        }

        public JsonResult BindTitle_List(int Selected_deal_type_Code, int Selected_BUCode, string Selected_Title_Codes = "")
        {
            var arr = BindTitle(Selected_deal_type_Code, Selected_BUCode, Selected_Title_Codes);
            return Json(arr, JsonRequestBehavior.AllowGet);
        }

        private MultiSelectList BindTitle(int Selected_deal_type_Code, int Selected_BUCode, string Selected_Title_Codes = "")
        {
            //if (objPage_Properties.TitleName != "" && objPage_Properties.DealTypeCode != 0)
            //    return Bind_Title(objPage_Properties.DealTypeCode, Selected_BUCode, objPage_Properties.TitleName);
            //else
            return Bind_Title(Selected_deal_type_Code, Selected_BUCode, Selected_Title_Codes);
        }

        public MultiSelectList Bind_Title(int Selected_deal_type_Code, int Selected_BUCode, string Selected_Title_Codes = "", string strBindTitleType = "N", string Searched_Title = "")
        {
            string strFlag = "TT";

            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            MultiSelectList arr_Title_List;
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq;

            if (objPage_Properties.TitleName != null)
            {
                lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq(strFlag, Selected_deal_type_Code, 0, Searched_Title).ToList();
                arr_Title_List = new MultiSelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "TT"), "Display_Value", "Display_Text", objPage_Properties.TitleName.Split(','));
            }
            if (Selected_BUCode <= 0)
            {
                lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq(strFlag, Selected_deal_type_Code, 0, Searched_Title).ToList();
                arr_Title_List = new MultiSelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "TT"), "Display_Value", "Display_Text", Selected_Title_Codes.Split(','));
            }
            else
            {
                lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq(strFlag, Selected_deal_type_Code, Selected_BUCode, Searched_Title).ToList();
                arr_Title_List = new MultiSelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "TT"), "Display_Value", "Display_Text", Selected_Title_Codes.Split(','));
            }

            return arr_Title_List;
        }

        public JsonResult GetTitle(int Selected_deal_type_Code, int Selected_BUCode, string Selected_Title_Codes = "", string strBindTitleType = "N",
            string Searched_Title = "", string isOriginal = "N")
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();

            //Extract the term to be searched from the list
            string searchString = terms.LastOrDefault().ToString().Trim();
            string strFlag = isOriginal == "N" ? "TTA" : "TTO";
            if (Selected_BUCode <= 0)
            {
                var result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq(strFlag, Selected_deal_type_Code, 0, searchString).Where(x => x.Data_For == strFlag && !terms.Contains(x.Display_Text)).ToList().Distinct();
                //var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x=>x.Deal_Type_Code= Selected_deal_type_Code && x.Title_Audio_Details.Contains( searchString )&& x.Reference_Flag=="" && 
                return Json(result);
            }
            else
            {
                var result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq(strFlag, Selected_deal_type_Code, Selected_BUCode, searchString).Where(x => x.Data_For == strFlag && !terms.Contains(x.Display_Text)).ToList().Distinct();
                //arr_Title_List = new MultiSelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "TT"), "Display_Value", "Display_Text", Selected_Title_Codes.Split(','));

                return Json(result);
            }
        }
        public JsonResult BindTitle_Ajax(int Selected_deal_type_Code, int Selected_BUCode, string Selected_Title_Codes = "")
        {
            MultiSelectList arr_Title_List = Bind_Title(Selected_deal_type_Code, Selected_BUCode, Selected_Title_Codes);
            return Json(arr_Title_List);
        }

        public JsonResult SaveTitle(string hdnTxtTitleName, string hdnddlLanguage, string hdnddlDealType, string hdnProgramCategory, string hdnTxtDuration, string Type, string hdnMusicLabel)
        {
            dynamic resultSet;
            objTitle.Title_Name = hdnTxtTitleName;
            objTitle.EntityState = State.Added;
            objTitle.Title_Language_Code = Convert.ToInt32(hdnddlLanguage);
            objTitle.Deal_Type_Code = Convert.ToInt32(hdnddlDealType);
            objTitle.Music_Label_Code = Convert.ToInt32(hdnMusicLabel);
            objTitle.Inserted_By = objLoginUser.Users_Code;
            objTitle.Inserted_On = DateTime.Now;
            objTitle.Last_UpDated_Time = DateTime.Now;
            objTitle.Duration_In_Min = Convert.ToDecimal(hdnTxtDuration);
            objTitle.Is_Active = "Y";
            //if (Type.Equals("S"))
            //{
            try
            {
                int Original_Country_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_CountryOfOrigin").Select(i => i.Parameter_Value).FirstOrDefault());

                Title_Country objTC = new Title_Country();
                objTC.EntityState = State.Added;
                objTC.Country_Code = Original_Country_code;
                objTitle.Title_Country.Add(objTC);

                Music_Title_Label objMusicLabel = new Music_Title_Label();

                objMusicLabel.Music_Title_Code = objTitle.Title_Code;
                objMusicLabel.EntityState = State.Added;
                new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).Save(objMusicLabel);
            }
            catch (Exception)
            {
            }
            //}
            new Title_Service(objLoginEntity.ConnectionStringName).Save(objTitle, out resultSet);

            string str_Program_Category_Required = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Parameter_Name == "Is_Program_Category_Required" && i.IsActive == "Y").Select(s => s.Parameter_Value).FirstOrDefault();
            if (str_Program_Category_Required == "Y")
            {
                string str_Program_Category_Code = hdnProgramCategory;
                string str_Program_Category_Value = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Parameter_Name == "Program_Category_Value" && i.IsActive == "Y").Select(s => s.Parameter_Value).FirstOrDefault();

                if (str_Program_Category_Code == "")
                    str_Program_Category_Code = "0";
                int program_Category_Code = Convert.ToInt32(str_Program_Category_Code);
                int program_Category_value_Code = Convert.ToInt32(str_Program_Category_Value);
                Map_Extended_Columns objMapExtendedColumns = new Map_Extended_Columns();
                objMapExtendedColumns.Columns_Code = program_Category_value_Code;
                objMapExtendedColumns.Columns_Value_Code = Convert.ToInt32(str_Program_Category_Code);
                objMapExtendedColumns.Table_Name = "TITLE";
                objMapExtendedColumns.Record_Code = objTitle.Title_Code;
                objMapExtendedColumns.Is_Multiple_Select = "N";
                objMapExtendedColumns.EntityState = State.Added;
                dynamic resultSet1;
                new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName).Save(objMapExtendedColumns, out resultSet1);
            }
            string Message = "";
            Message = objMessageKey.RecordAddedSuccessfully;
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            objJson.Add("Message", Message);
            objJson.Add("TitleCode", objTitle.Title_Code);
            return Json(objJson);
        }

        public JsonResult ValidateIsDuplicate(string TitleName, string DealTypeCode, string ProgramCategoryCode)
        {
            TitleName = TitleName.Trim(' ');
            int Count = 0;
            int Deal_Type_Code = Convert.ToInt32(DealTypeCode);
            Count = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == TitleName && x.Deal_Type_Code == Deal_Type_Code).Distinct().Count();
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (Count > 0)
                objJson.Add("Message", objMessageKey.TitleWithSameNameAlreadyExists);
            else
                objJson.Add("Message", "");

            return Json(objJson);
        }

        public JsonResult OnChangeBindTitle(int? DealTypeCode)
        {
            return Json(Bind_Tiitle(DealTypeCode), JsonRequestBehavior.AllowGet);
        }
        private MultiSelectList Bind_Tiitle(int? DealTypeCode)
        {
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            MultiSelectList lstTitle = new MultiSelectList(objTS.SearchFor(T => T.Is_Active == "Y" &&
                                                 T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == DealTypeCode && AM.Title_Code == T.Title_Code)
        )
                                     .Select(R => new { Title_Name = R.Title_Name, Title_Code = R.Title_Code }), "Title_Code", "Title_Name");//, obj_Title_List.Title_Code.Split(','));
            return lstTitle;
        }
        public JsonResult Bind_Title_List(string Searched_Title = "", string DealTypeCode = "")
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            //string[] arrsearchString = searchString.ToUpper().Split(',');

            var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code.ToString() == DealTypeCode && AM.Title_Code == x.Title_Code)).Where(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()))
               .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
            return Json(result);
        }

        public JsonResult DeactivateTitle(string TitleCode, string Type)
        {
            int Count = 0;
            int Title_Code = Convert.ToInt32(TitleCode);
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Title objTitle = objTS.SearchFor(x => x.Title_Code == Title_Code).Distinct().FirstOrDefault();

            if (Type == "N")
                Count = (from Acq_Deal_Movie obj in objTitle.Acq_Deal_Movie where obj.Title_Code == Title_Code && (obj.Is_Closed != "X" || obj.Is_Closed != "Y") select obj).ToList().Distinct().Count();

            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (Count > 0)
                //objJson.Add("Error", objMessageKey.CanNotDeactivateThisTitleAsTitleIsUsedInDeal);
                objJson.Add("Error", "Title can not be deactivated due to active association with Deal");
            else
            {
                dynamic resultSet;
                objTitle.EntityState = State.Modified;
                objTitle.Is_Active = Type;
                objTS.Save(objTitle, out resultSet);

                if (Type == "N")
                    objJson.Add("Message", objMessageKey.DeactivateSuccessMessage);
                else
                    objJson.Add("Message", objMessageKey.ActivateSuccessMessage);

                objJson.Add("Error", "");
            }

            return Json(objJson);
        }



        public void ResetMessageSession()
        {
            Session["Message"] = string.Empty;
        }


        //public void ExportToExcel(FormCollection objFormCollection, string TitleName = "", string DealTypeCode = "0", int PageIndex = 0)
        //{
        //    int a = 0;
        //    if (objFormCollection["DealTypeC"] != "")
        //    {
        //        a = Convert.ToInt32(objFormCollection["DealTypeC"]);
        //    }


        //    int pageSize = 10;
        //    USP_Service objUSP = new USP_Service();
        //    int RecordCount = 0;
        //    ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
        //    string sql = "";
        //    //objPage_Properties.PageNo = Convert.ToInt32(Request.QueryString["Page_No"] != null ? Request.QueryString["Page_No"].ToString() : "1");
        //    //objPage_Properties.PageNo = PageIndex + 1;
        //    List<USP_Title_List_Result> USP_Title_List = new List<USP_Title_List_Result>();
        //    var TitleList = USP_Title_List
        //                    .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active })
        //                    .ToList();

        //    if (objPage_Properties.isAdvanced == "Y")
        //    {
        //        if (objPage_Properties.LanguagesCodes_Search != "")
        //            sql += " AND Title_Language_Code IN(" + objPage_Properties.LanguagesCodes_Search + ")";
        //        if (objPage_Properties.YearOfRelease != "")
        //            sql += " AND  Year_Of_Production like " + "'" + objPage_Properties.YearOfRelease + "%'";
        //        if (objPage_Properties.CountryCodes_Search != "")
        //            sql += " AND T.Title_Code in (select TC.Title_Code from Title_Country TC where Country_Code in (" + objPage_Properties.CountryCodes_Search + "))";
        //        if (objPage_Properties.DirectorCodes_Search != "")
        //            sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT where Talent_Code in (" + objPage_Properties.DirectorCodes_Search + "))";
        //        if (objPage_Properties.StarCastCodes_Search != "")
        //            sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT  where Talent_Code in (" + objPage_Properties.StarCastCodes_Search + "))";
        //        //if(objPage_Properties.TitleName!="")
        //        //    sql += " AND T.Title_Name ='" + objPage_Properties.TitleName + "'";
        //        //    TitleList = objUSP.USP_Title_List(objPage_Properties.TitleName, PageNo, objRecordCount, "Y", PageSize,
        //        //        objPage_Properties.StarCastCodes_Search, objPage_Properties.LanguagesCodes_Search, objPage_Properties.GenresCodes_Search,
        //        //        objPage_Properties.MusicLabelCodes_Search, objPage_Properties.YearOfRelease, objPage_Properties.SingerCodes_Search,
        //        //        objPage_Properties.ComposerCodes_Search, objPage_Properties.LyricistCodes_Search, objPage_Properties.MusicTitleName_Search, objPage_Properties.ThemeCodes_Search, objPage_Properties.Music_Tag_Search).ToList();
        //        TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), objPage_Properties.TitleName, 0, 1, objRecordCount, "N", recordPerPage, sql)
        //            .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active }).ToList();
        //    }
        //    else if (objPage_Properties.isSearch == "Y")
        //    {
        //        sql = "AND (T.Deal_Type_Code In(select DT.Deal_Type_Code from Deal_Type DT where Deal_Type_Name like '" + objPage_Properties.genericSearch + "%') or T.Title_Language_Code IN(select L.Language_Code from [Language] L where Language_Name like '" + objPage_Properties.genericSearch + "%') or Title_Name like '" + objPage_Properties.genericSearch + "%')";
        //        TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), "", 0, 1, objRecordCount, "N", recordPerPage, sql)
        //            .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active }).ToList();
        //    }
        //    else
        //        TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), "", 0, 1, objRecordCount, "N", recordPerPage, sql)
        //            .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active }).ToList();

        //    System.Web.UI.WebControls.GridView gridvw = new System.Web.UI.WebControls.GridView();
        //    gridvw.AutoGenerateColumns = false;
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Title", DataField = "Title_Name" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Original Title", DataField = "Original_Title" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Title Language", DataField = "Language_Name" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Key Star Cast", DataField = "TalentName" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Producer", DataField = "Producer" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Director", DataField = "Director" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Country of Origin", DataField = "CountryName" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Genre", DataField = "Genre" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Year Of Release", DataField = "Year_Of_Production" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Synopsis", DataField = "Synopsis" });
        //    gridvw.Columns.Add(new BoundField { HeaderText = "Status", DataField = "Is_Active" });
        //    gridvw.DataSource = TitleList.ToList(); //bind the datatable to the gridview
        //    gridvw.DataBind();
        //    Response.ClearContent();
        //    Response.AddHeader("content-disposition", "attachment;filename=TitleList.xlsx");
        //    Response.ContentType = "application/excel";
        //    StringWriter swr = new StringWriter();
        //    HtmlTextWriter tw = new HtmlTextWriter(swr);
        //    gridvw.RenderControl(tw);
        //    Response.Write("<b>Title List</b><br/>");
        //    Response.Write("<b>Total Records: " + TitleList.Count.ToString() + "</b>");
        //    Response.Write(swr.ToString());

        //    Response.End();
        //}


        public void ExportToExcel(FormCollection objFormCollection, string TitleName = "", string DealTypeCode = "0", int PageIndex = 0)
        {

            string newString = "";
            string newLanguage = "";
            string newLProgram = "";
            string newOrigtitleString = "";
            string[] searchStrings;
            if (objPage_Properties.isSearch == "Y")
            {
                string ExactMatchStr = objPage_Properties.genericSearch;
                searchStrings = objPage_Properties.genericSearch.Split(new string[] { ",", ";", "/", " " }, StringSplitOptions.RemoveEmptyEntries);
                //string newString = "";
                //string newLanguage = "";


                for (int i = 1; i <= searchStrings.Length; i++)
                {
                    if (searchStrings.Length > 0)
                    {
                        if (i == searchStrings.Length)
                        {
                            newLanguage += "Language_Name Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + "";
                            newString += "T.Title_Name Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + "";
                            newLProgram += "P.Program_Name Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + "";
                            newOrigtitleString += "T.Original_Title Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + "";
                        }
                        else
                        {
                            newLanguage += "Language_Name Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + " OR ";
                            newString += "T.Title_Name Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + " OR ";
                            newLProgram += "P.Program_Name Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + " OR ";
                            newOrigtitleString += "T.Original_Title Like N" + "'" + "%" + (searchStrings[i - 1]) + "%" + "'" + " OR ";
                        }
                    }
                }

            }
            ReportViewer1 = new ReportViewer();
            if (TitleName == "")
                TitleName = " ";
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            ReportParameter[] parm = new ReportParameter[8];
            int a = 0;
            if (objFormCollection["DealTypeC"] != "")
            {
                a = Convert.ToInt32(objFormCollection["DealTypeC"]);
            }
            int pageSize = 10;
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            string sql = "";
            List<USP_Title_List_Result> USP_Title_List = new List<USP_Title_List_Result>();
            var TitleList = USP_Title_List
                            .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active })
                            .ToList();

            if (objPage_Properties.isAdvanced == "Y")
            {
                if (objPage_Properties.LanguagesCodes_Search != "")
                    sql += " AND Title_Language_Code IN(" + objPage_Properties.LanguagesCodes_Search + ")";
                if (objPage_Properties.OrigLangCodes_Search != "")
                    sql += " AND Original_Language_Code IN(" + objPage_Properties.OrigLangCodes_Search + ")";
                if (objPage_Properties.YearOfRelease != "")
                    sql += " AND  Year_Of_Production like " + "'" + objPage_Properties.YearOfRelease + "%'";
                if (objPage_Properties.CountryCodes_Search != "")
                    sql += " AND T.Title_Code in (select TC.Title_Code from Title_Country TC where Country_Code in (" + objPage_Properties.CountryCodes_Search + "))";
                if (objPage_Properties.DirectorCodes_Search != "")
                    sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT where Talent_Code in (" + objPage_Properties.DirectorCodes_Search + ") AND Role_Code = " + GlobalParams.RoleCode_Director + ")";
                if (objPage_Properties.StarCastCodes_Search != "")
                    sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT  where Talent_Code in (" + objPage_Properties.StarCastCodes_Search + ") AND Role_Code = " + GlobalParams.RoleCode_StarCast + ")";
                if (objPage_Properties.ProgramCode_Search != "")
                    sql += " AND Program_Code IN(" + objPage_Properties.ProgramCode_Search + ")";

                parm[0] = new ReportParameter("Deal_Type_code", Convert.ToString(objPage_Properties.DealTypeCode));
                parm[1] = new ReportParameter("TitleName", objPage_Properties.TitleName);
                parm[1] = new ReportParameter("OriginalTitleName", objPage_Properties.OrigTitleName == "" ? " " : objPage_Properties.OrigTitleName);
                parm[2] = new ReportParameter("BUCode", Convert.ToString(0));
                parm[3] = new ReportParameter("PageNo", Convert.ToString(1));
                parm[4] = new ReportParameter("RecordCount", Convert.ToString(0));
                parm[5] = new ReportParameter("IsPaging", "N");
                parm[6] = new ReportParameter("PageSize", Convert.ToString(recordPerPage));
                parm[7] = new ReportParameter("AdvanceSearch", Convert.ToString(sql));

                //TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), objPage_Properties.TitleName, 0, 1, objRecordCount, "N", recordPerPage, sql)
                //    .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active }).ToList();
            }
            else if (objPage_Properties.isSearch == "Y")
            {
                sql = "AND (T.Deal_Type_Code In(select DT.Deal_Type_Code from Deal_Type DT where Deal_Type_Name like N'" + objPage_Properties.genericSearch + "%') or T.Title_Language_Code IN(select L.Language_Code from [Language] L where " + newLanguage + " ) or " + newString + " OR T.Program_Code IN(select P.Program_Code from [Program] P where " + newLProgram + ") OR " + newOrigtitleString + " )";

                //sql = "AND (T.Deal_Type_Code In(select DT.Deal_Type_Code from Deal_Type DT where Deal_Type_Name like '" + objPage_Properties.genericSearch + "%') or T.Title_Language_Code IN(select L.Language_Code from [Language] L where Language_Name like '%" + objPage_Properties.genericSearch + "%') or Title_Name like '%" + objPage_Properties.genericSearch + "%')";
                parm[0] = new ReportParameter("Deal_Type_code", Convert.ToString(objPage_Properties.DealTypeCode));
                parm[1] = new ReportParameter("TitleName", "");
                parm[1] = new ReportParameter("OriginalTitleName", " ");
                parm[2] = new ReportParameter("BUCode", Convert.ToString(0));
                parm[3] = new ReportParameter("PageNo", Convert.ToString(1));
                parm[4] = new ReportParameter("RecordCount", Convert.ToString(0));
                parm[5] = new ReportParameter("IsPaging", "N");
                parm[6] = new ReportParameter("PageSize", Convert.ToString(recordPerPage));
                parm[7] = new ReportParameter("AdvanceSearch", Convert.ToString(sql));
                //TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), "", 0, 1, objRecordCount, "N", recordPerPage, sql)
                //    .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active }).ToList();

            }
            else
            {
                parm[0] = new ReportParameter("Deal_Type_code", Convert.ToString(objPage_Properties.DealTypeCode));
                parm[1] = new ReportParameter("TitleName", "");
                parm[1] = new ReportParameter("OriginalTitleName", " ");
                parm[2] = new ReportParameter("BUCode", Convert.ToString(0));
                parm[3] = new ReportParameter("PageNo", Convert.ToString(1));
                parm[4] = new ReportParameter("RecordCount", Convert.ToString(0));
                parm[5] = new ReportParameter("IsPaging", "N");
                parm[6] = new ReportParameter("PageSize", Convert.ToString(recordPerPage));
                parm[7] = new ReportParameter("AdvanceSearch", Convert.ToString(sql));

                //TitleList = objUSP.USP_Title_List(Convert.ToInt32(objPage_Properties.DealTypeCode), "", 0, 1, objRecordCount, "N", recordPerPage, sql)
                //    .Select(t => new { t.Title_Name, t.Original_Title, t.Language_Name, t.TalentName, t.Producer, t.Director, t.CountryName, t.Genre, t.Year_Of_Production, t.Synopsis, t.Is_Active }).ToList();

            }
            ReportCredential();
            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptTitleList");
            }
            ReportViewer1.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer1.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename=TitleList.xls");
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

        public byte[] SerializeData(Object o)
        {
            MemoryStream ms = new MemoryStream();
            BinaryFormatter bf1 = new BinaryFormatter();
            bf1.Serialize(ms, o);
            return ms.ToArray();
        }
        private void BindDDL()
        {

            // ViewBag.Director = BindDirector();
            ViewBag.Language = BindLanguages();
            //ViewBag.StarCast = BindStarCast();
            ViewBag.Country = BindCountry();
            ViewBag.Deal = BindDealType();
            BindDirectorNStarCast();
        }

        public List<SelectListItem> BindDealType()
        {
            List<SelectListItem> lstDealType = new List<SelectListItem>();
            lstDealType = new SelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Deal_Type_Code", "Deal_Type_Name", ViewBag.DealTypeSearch).ToList();
            return lstDealType;
        }
        //public MultiSelectList BindDirector()
        //{
        //    if (objPage_Properties.DirectorCodes_Search != null)
        //    {
        //        return new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Talent_Role.FirstOrDefault().Role_Code == GlobalParams.RoleCode_Director)
        //       .Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).ToList(),
        //       "Display_Value", "Display_Text", objPage_Properties.DirectorCodes_Search.Split(','));
        //    }
        //    else
        //    {
        //        return new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Talent_Role.FirstOrDefault().Role_Code == GlobalParams.RoleCode_Director)
        //            .Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).ToList(),
        //            "Display_Value", "Display_Text");
        //    }
        //}
        public MultiSelectList BindLanguages()
        {
            if (objPage_Properties.LanguagesCodes_Search != null)
            {
                return new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                  .Select(i => new { Display_Value = i.Language_Code, Display_Text = i.Language_Name }).ToList(),
                  "Display_Value", "Display_Text", objPage_Properties.LanguagesCodes_Search.Split(','));
            }
            else
            {
                return new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                 .Select(i => new { Display_Value = i.Language_Code, Display_Text = i.Language_Name }).ToList(),
                 "Display_Value", "Display_Text");
            }
        }

        private void BindDirectorNStarCast()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);
            ViewBag.StarCast = new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
                "Display_Value", "Display_Text", Convert.ToString(objPage_Properties.StarCastCodes_Search == null ? "" : objPage_Properties.StarCastCodes_Search).Split(','));

            var lstDirector = lstTalent.Where(x => x.Role_Code == GlobalParams.RoleCode_Director);
            ViewBag.Director = new MultiSelectList(lstDirector.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
                "Display_Value", "Display_Text", Convert.ToString(objPage_Properties.DirectorCodes_Search == null ? "" : objPage_Properties.DirectorCodes_Search).Split(','));
        }

        //public MultiSelectList BindStarCast()
        //{
        //    var lstTalent = new USP_Service().USP_Get_Talent_Name().ToList();


        //    var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);


        //    Talent_Role_Service objTRS = new Talent_Role_Service(objLoginEntity.ConnectionStringName);
        //    if (objPage_Properties.StarCastCodes_Search != null)
        //    {
        //        //return new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && objTRS.SearchFor(y=>y.Talent_Code==x.Talent_Code).Select(z=>z.Role_Code).Contains(GlobalParams.RoleCode_StarCast))
        //        //    .Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).ToList(),
        //        //     "Display_Value", "Display_Text", objPage_Properties.StarCastCodes_Search.Split(','));
        //        return new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
        //       "Display_Value", "Display_Text", objPage_Properties.StarCastCodes_Search.Split(','));
        //    }
        //    else
        //    {
        //        //return new MultiSelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" 
        //        //&& (objTRS.SearchFor(y => y.Talent_Code == x.Talent_Code).Select(z => z.Role_Code).Contains(GlobalParams.RoleCode_StarCast))
        //        //)
        //        //   .Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }).ToList(),
        //        //    "Display_Value", "Display_Text");
        //        return new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
        //       "Display_Value", "Display_Text");
        //    }
        //}
        public MultiSelectList BindCountry()
        {
            if (objPage_Properties.CountryCodes_Search != null)
            {
                return new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                   .Select(i => new { Display_Value = i.Country_Code, Display_Text = i.Country_Name }).ToList(),
                    "Display_Value", "Display_Text", objPage_Properties.CountryCodes_Search.Split(','));
            }
            else
            {
                return new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                  .Select(i => new { Display_Value = i.Country_Code, Display_Text = i.Country_Name }).ToList(),
                   "Display_Value", "Display_Text");
            }
        }
        public void AdvanceSearch(string SrchStarCast = "", string SrchLanguage = "",
        string SrchYearOfRelease = "", string SrchTitle = "", string SrchCountry = "", string SrchDirector = "",
        string SrhDealTypeCode = "", string srchProgram = "", string SrchOrigLang = "", string SrchOrigTitle = "", string sechTypeofFilm = "")
        {
            objPage_Properties.StarCastCodes_Search = SrchStarCast;
            objPage_Properties.LanguagesCodes_Search = SrchLanguage;
            objPage_Properties.OrigLangCodes_Search = SrchOrigLang;
            objPage_Properties.YearOfRelease = SrchYearOfRelease;
            objPage_Properties.TitleName = SrchTitle;
            objPage_Properties.OrigTitleName = SrchOrigTitle;
            objPage_Properties.CountryCodes_Search = SrchCountry;
            objPage_Properties.DirectorCodes_Search = SrchDirector;
            objPage_Properties.genericSearch = "";
            ViewBag.TitleName = SrchTitle;
            ViewBag.OrigTitleName = SrchOrigTitle;
            objPage_Properties.isAdvanced = "Y";
            objPage_Properties.DealTypeCode = SrhDealTypeCode;
            objPage_Properties.ProgramCode_Search = srchProgram;
            objPage_Properties.Column_Name = sechTypeofFilm;


        }
        //public JsonResult BindAdvanced_Search_Controls()
        //{
        //    Dictionary<string, object> objJson = new Dictionary<string, object>();
        //    BindDDL();
        //    var lstTalent = new USP_Service().USP_Get_Talent_Name().ToList();
        //    string StarCast_code = "";

        //    var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);

        //    MultiSelectList lstMStarCast = new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
        //        "Display_Value", "Display_Text", StarCast_code.Split(','));

        //    objJson.Add("lstMStarCast", lstMStarCast);
        //    objJson.Add("objPage_Properties", objPage_Properties);

        //    return Json(objJson);
        //}
        public JsonResult BindAdvanced_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);
            var lstDirector = lstTalent.Where(x => x.Role_Code == GlobalParams.RoleCode_Director);

            MultiSelectList lstLanguage = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Language_Code, Display_Text = i.Language_Name }).ToList(), "Display_Value", "Display_Text");

            var lst_title = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Original_Language_Code != null).Select(x => x.Original_Language_Code).Distinct().ToList();
            var lst_Lang = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();

            var lstOgLang = (from t1 in lst_title
                             join t2 in lst_Lang on t1.Value equals t2.Language_Code
                             select new { t1.Value, t2.Language_Name }).ToList();

            MultiSelectList lstOrigLang = new MultiSelectList(lstOgLang
               .Select(i => new { Display_Value = i.Value, Display_Text = i.Language_Name }).ToList(), "Display_Value", "Display_Text");


            MultiSelectList lstCountry = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Country_Code, Display_Text = i.Country_Name }).ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstDealType = new MultiSelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Deal_Type_Code, Display_Text = i.Deal_Type_Name }).ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstTStarCast = new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
                "Display_Value", "Display_Text");
            MultiSelectList lstTDirector = new MultiSelectList(lstDirector.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
                "Display_Value", "Display_Text");
            SelectList lstProgram = new SelectList(new Program_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
            .Select(i => new { Display_Value = i.Program_Code, Display_Text = i.Program_Name }).ToList(), "Display_Value", "Display_Text");
            //lstDealType = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DT"), "Display_Value", "Display_Text").ToList();
            var lst = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Name == "Type of Film").First().Columns_Code;
            SelectList lstTypeOfFilm = new SelectList(new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == lst)
           .Select(i => new { Display_Value = i.Columns_Value_Code, Display_Text = i.Columns_Value }).ToList(), "Display_Value", "Display_Text");


            objJson.Add("lstTStarCast", lstTStarCast);
            objJson.Add("lstTDirector", lstTDirector);
            objJson.Add("lstLanguage", lstLanguage);

            objJson.Add("lstOrigLang", lstOrigLang);

            objJson.Add("lstCountry", lstCountry);
            objJson.Add("lstDealType", lstDealType);
            objJson.Add("lstProgram", lstProgram);
            objJson.Add("lstTypeOfFilm", lstTypeOfFilm);
            //ViewData["hdnFlag"] = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").First().Parameter_Value;

            if (objPage_Properties.LanguagesCodes_Search != "" && objPage_Properties.LanguagesCodes_Search != null)
                objPage_Properties.LanguagesCodes_Search = objPage_Properties.LanguagesCodes_Search;
            else
                objPage_Properties.LanguagesCodes_Search = "";

            if (objPage_Properties.OrigLangCodes_Search != "" && objPage_Properties.OrigLangCodes_Search != null)
                objPage_Properties.OrigLangCodes_Search = objPage_Properties.OrigLangCodes_Search;
            else
                objPage_Properties.OrigLangCodes_Search = "";

            if (objPage_Properties.StarCastCodes_Search != "" && objPage_Properties.StarCastCodes_Search != null)
                objPage_Properties.StarCastCodes_Search = objPage_Properties.StarCastCodes_Search;
            else
                objPage_Properties.StarCastCodes_Search = "";
            if (objPage_Properties.DirectorCodes_Search != "" && objPage_Properties.DirectorCodes_Search != null)
                objPage_Properties.DirectorCodes_Search = objPage_Properties.DirectorCodes_Search;
            else
                objPage_Properties.DirectorCodes_Search = "";
            if (objPage_Properties.CountryCodes_Search != "" && objPage_Properties.CountryCodes_Search != null)
                objPage_Properties.CountryCodes_Search = objPage_Properties.CountryCodes_Search;
            else
                objPage_Properties.CountryCodes_Search = "";
            if (objPage_Properties.DealTypeCode != null)
                objPage_Properties.DealTypeCode = objPage_Properties.DealTypeCode;
            else
                objPage_Properties.DealTypeCode = "";

            if (objPage_Properties.ProgramCode_Search != null)
                objPage_Properties.ProgramCode_Search = objPage_Properties.ProgramCode_Search;
            else
                objPage_Properties.ProgramCode_Search = "";

            if (objPage_Properties.Column_Name != null)
                objPage_Properties.Column_Name = objPage_Properties.Column_Name;
            else
                objPage_Properties.Column_Name = "";

            objJson.Add("objPage_Properties", objPage_Properties);
            return Json(objJson);
        }
        public ActionResult List(string CallFrom = "", int Page_No = 0, int Record_Locking_Code = 0)
        {

            string IsMenu = "";
            if (Request.QueryString["IsMenu"] != null)
                IsMenu = Request.QueryString["IsMenu"];
            Dictionary<string, string> obj_Dic_Layout = new Dictionary<string, string>();
            if (TempData["QS_LayOut"] != null)
            {
                obj_Dic_Layout = TempData["QS_LayOut"] as Dictionary<string, string>;
                IsMenu = obj_Dic_Layout["IsMenu"];
                //TempData.Keep("QS_LayOut");
            }


            int Page_Size = 0;
            //Page_No = Convert.ToInt32(TempData["Page_No"]);
            Page_Size = Convert.ToInt32(TempData["Page_Size"]);

            if (Page_No > 0)
                objPage_Properties.PageNo = Page_No;
            //ViewBag.DealTypeList = BindTitleType(DealTypeCode);
            if (objPage_Properties.PageNo != 0)
                ViewBag.Query_String_Page_No = objPage_Properties.PageNo - 1;
            else
                ViewBag.Query_String_Page_No = 0;
            if (Page_Size != 0)
                ViewBag.PageSize = Page_Size;
            else
            {
                Page_Size = Page_Size;
                ViewBag.PageSize = Page_Size;
            }
            if (CallFrom != "T" && CallFrom != "")
            {
                objPage_Properties.isAdvanced = "N";
            }
            if (CallFrom == "T")
            {
                if (Record_Locking_Code > 0)
                {
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(Record_Locking_Code, objLoginEntity.ConnectionStringName);
                }
            }
            //ViewBag.DealTypeCode = DealTypeCode;
            //ViewBag.SearchedTitle = SearchedTitle;//Convert.ToString(TempData["SearchedTitle"]);
            //objPage_Properties.TitleName = SearchedTitle;
            //objPage_Properties.MusicLabelCodes_Search = SearchedTitle;
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitle), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.buttonVisibility = c;
            // ViewBag.TitleList = Bind_Title(0, ViewBag.SearchedTitle);
            ViewBag.StarCast_Code = objPage_Properties.StarCastCodes_Search;
            ViewBag.Director_Code = objPage_Properties.DirectorCodes_Search;
            ViewBag.isAdvanced = objPage_Properties.isAdvanced;
            ViewBag.YearOfRelease = objPage_Properties.YearOfRelease;
            ViewBag.Language_Code = objPage_Properties.LanguagesCodes_Search;
            ViewBag.OrigLang_Code = objPage_Properties.OrigLangCodes_Search;
            ViewBag.Country_Code = objPage_Properties.CountryCodes_Search;
            ViewBag.genericSearch = objPage_Properties.genericSearch;
            ViewBag.DealTypeSearch = objPage_Properties.DealTypeCode;
            ViewBag.isSearch = objPage_Properties.isSearch;
            ViewBag.isShowAll = objPage_Properties.isShowAll;
            ViewBag.SrchTitle = objPage_Properties.TitleName;
            ViewBag.SrchOrigTitle = objPage_Properties.OrigTitleName;
            ViewBag.Program_Code = objPage_Properties.ProgramCode_Search;
            ViewBag.Is_AcqSyn_Type_Of_Film = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").First().Parameter_Value;
            BindDDL();
            BindTitleType();

            string MusicThemeVisibility = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "MusicThemeVisibility").Select(i => i.Parameter_Value).FirstOrDefault();
            ViewBag.MusicThemeVisibility = MusicThemeVisibility;
            //ViewBag.DealTypeList = new SelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Deal_Or_Title != "D"), "Deal_Type_Code", "Deal_Type_Name", DealTypeCode).ToList();
            return View("Index");
        }
        public ActionResult Cancel(int Page_No, int Record_Locking_Code = 0)
        {
            if (Record_Locking_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(Record_Locking_Code, objLoginEntity.ConnectionStringName);
            }

            Session["Message"] = "";
            return RedirectToAction("List", "Title_List", new { @CallFrom = "T", @Page_No = Page_No });
        }
        public partial class Title_Search
        {

            public Title_Search() { }

            #region ========== PAGE PROPERTIES ==========

            private string _TitleName = "";
            public string TitleName
            {
                get { return _TitleName; }
                set { _TitleName = value; }
            }
            //private int? _DealTypeCode;
            //public int? DealTypeCode
            //{
            //    get { return _DealTypeCode; }
            //    set { _DealTypeCode = value; }
            //}

            private string _OrigTitleName = "";
            public string OrigTitleName
            {
                get { return _OrigTitleName; }
                set { _OrigTitleName = value; }
            }
            public string DealTypeCode { get; set; }
            public string Column_Name { get; set; }
            public string StarCastCodes_Search { get; set; }
            public string LanguagesCodes_Search { get; set; }
            public string OrigLangCodes_Search { get; set; }
            public string YearOfRelease { get; set; }
            public string isSearch { get; set; }
            public string CountryCodes_Search { get; set; }
            public string DirectorCodes_Search { get; set; }
            public string isAdvanced { get; set; }
            public string genericSearch { get; set; }
            public int PageNo { get; set; }
            public string isShowAll { get; set; }
            public string ProgramCode_Search { get; set; }
            public int RecordLockingCode { get; set; }

            #endregion
        }

        //public JsonResult SampleDownload()
        //{
        //    string message = "";
        //    Dictionary<string, object> objJson = new Dictionary<string, object>();
        //    string filePath = Server.MapPath("~") + "\\Download\\Title_Import_Sample.xlsx";
        //    try
        //    {
        //        if (System.IO.File.Exists(filePath))
        //        {
        //            FileInfo objFileInfo = new FileInfo(filePath);
        //            WebClient client = new WebClient();
        //            Byte[] buffer = client.DownloadData(filePath);
        //            Response.Clear();
        //            Response.ContentType = "application/ms-excel";
        //            Response.AddHeader("content-disposition", "Attachment;filename=" + objFileInfo.Name);
        //            Response.BinaryWrite(buffer);
        //            Response.End();
        //        }
        //        else
        //        {
        //            message= "File does not exist.";
        //            throw new FileNotFoundException();
        //        }
        //    }
        //    catch (FileNotFoundException)
        //    {
        //        message="File not found";
        //    }
        //    catch (InvalidOperationException)
        //    {
        //        message="Cannot access file";
        //    }
        //    objJson.Add("Message", message);
        //        objJson.Add("Error", "");
        //    return Json(objJson);
        //}

    }
}
