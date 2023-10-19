using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_Rights_ListController : BaseController
    {
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            set
            {
                Session[RightsU_Session.Syn_DEAL_SCHEMA] = value;
            }
        }

        public Syn_Deal objSyn_Deal
        {
            get
            {
                if (Session[RightsU_Session.SESS_DEAL] == null)
                    Session[RightsU_Session.SESS_DEAL] = new Syn_Deal();
                return (Syn_Deal)Session[RightsU_Session.SESS_DEAL];
            }
            set { Session[RightsU_Session.SESS_DEAL] = value; }
        }

        public Syn_Deal_Service objSDS
        {
            get
            {
                if (Session["SDS_Syn_Rights"] == null)
                    Session["SDS_Syn_Rights"] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Syn_Deal_Service)Session["SDS_Syn_Rights"];
            }
            set { Session["SDS_Syn_Rights"] = value; }
        }

        private List<USP_Get_Syn_Rights_Errors_Result> lstErrorRecords
        {
            get
            {
                if (Session["lstErrorRecords_SynList"] == null)
                    Session["lstErrorRecords_SynList"] = new List<USP_Get_Syn_Rights_Errors_Result>();
                return (List<USP_Get_Syn_Rights_Errors_Result>)Session["lstErrorRecords_SynList"];
            }
            set
            {
                Session["lstErrorRecords_SynList"] = value;
            }
        }
        private List<USP_Get_Syn_Rights_Errors_Result> lstErrorRecords_Titles
        {
            get
            {
                if (Session["lstErrorRecords_Titles_SynList"] == null)
                    Session["lstErrorRecords_Titles_SynList"] = new List<USP_Get_Syn_Rights_Errors_Result>();
                return (List<USP_Get_Syn_Rights_Errors_Result>)Session["lstErrorRecords_Titles_SynList"];
            }
            set
            {
                Session["lstErrorRecords_Titles_SynList"] = value;
            }
        }
        public List<USP_Bulk_Update> lstDupRecordsNew
        {
            get
            {
                if (Session["lstDupRecordsNew"] == null)
                    Session["lstDupRecordsNew"] = new List<USP_Bulk_Update>();
                return (List<USP_Bulk_Update>)Session["lstDupRecordsNew"];
            }
            set
            {
                Session["lstDupRecordsNew"] = value;
            }
        }
        public string DPlatformCode
        {
            get
            {
                if (Session["DPlatformCode"] == null)
                    Session["DPlatformCode"] = "";
                return (string)Session["DPlatformCode"];
            }
            set { Session["DPlatformCode"] = value; }
        }
        public PartialViewResult Index()
        {
            ClearSession();
            objDeal_Schema.Page_From = GlobalParams.Page_From_Rights;

            ViewBag.Right_Type = "G";
            if (objDeal_Schema.Rights_View == null)
                objDeal_Schema.Rights_View = "G";

            string Is_Syn_CoExclusive = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Syn_CoExclusive").Select(x => x.Parameter_Value).FirstOrDefault();
            if (Is_Syn_CoExclusive == "Y" && objDeal_Schema.Rights_Exclusive == null)
                objDeal_Schema.Rights_Exclusive = "B";

            ViewBag.Acq_Deal_Code = objDeal_Schema.Deal_Code;
            Platform_Service objPservice = new Platform_Service(objLoginEntity.ConnectionStringName);
            objSyn_Deal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            ViewBag.Remark = (objSyn_Deal.Rights_Remarks == null) ? "" : objSyn_Deal.Rights_Remarks;
            //Anchal Changes//
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForSynDeal, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForBulkUpdate) + "~");
            ViewBag.ButtonVisibility = srchaddRights;

            ViewBag.TitleList = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().
                BindSearchList_Rights(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Condition, (objDeal_Schema.Rights_Titles ?? ""), "S");

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_List.cshtml");
        }
        public PartialViewResult BindRightsFilterData(string callFor = "")
        {
            //    ClearSession();
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForSynDeal, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForBulkUpdate) + "~");
            ViewBag.ButtonVisibility = srchaddRights;
            Syn_Deal objsd = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            var titleList = from sdm in objsd.Syn_Deal_Movie
                            from sdr in objsd.Syn_Deal_Rights
                            from sdrt in sdr.Syn_Deal_Rights_Title
                            where sdm.Syn_Deal_Code == sdr.Syn_Deal_Code && sdr.Syn_Deal_Rights_Code == sdrt.Syn_Deal_Rights_Code && sdrt.Title_Code == sdm.Title_Code && sdr.Is_Pushback == "N"
                            select new { Title_Code = sdm.Syn_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, sdm.Title.Title_Name, sdm.Episode_From, sdm.Episode_End_To) };
            ViewBag.TitleList = new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name");
            string[] regioncode = new string[] { "" };
            if (objDeal_Schema.Rights_Region != null)
            {
                regioncode = objDeal_Schema.Rights_Region.Split(',');
            }
            string[] arrSelectedCountryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I" && regioncode.Contains("C" + "" + x.Country_Code.ToString() + "")).Select(s => "C" + "" + s.Country_Code.ToString() + "").ToArray();
            string[] arrSelectedTerritoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G" && regioncode.Contains("T" + "" + x.Territory_Code.ToString() + "")).Select(s => "T" + "" + s.Territory_Code.ToString() + "").ToArray();
            int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

            List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
            lsts.Where(s => s.GroupName == "Country" && arrSelectedCountryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
            lsts.Where(s => s.GroupName == "Territory" && arrSelectedTerritoryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            string[] arrcountryCode = arrSelectedCountryCode.Select(x => x.Replace("C", "")).ToArray();
            string Country_Terr_Name = string.Join(",", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrcountryCode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Name).ToArray());
            string[] arrterritoryCode = arrSelectedTerritoryCode.Select(x => x.Replace("T", "")).ToArray();
            Country_Terr_Name = Country_Terr_Name + "," + string.Join(",", new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrterritoryCode.Contains(s.Territory_Code.ToString())).Select(s => s.Territory_Name).ToArray());
            string[] regionname = new string[] { "" };
            if (Country_Terr_Name != "")
                regionname = Country_Terr_Name.TrimStart(',').TrimEnd(',').Split(',');

            if (regionname.Count() > 3)
                ViewBag.RegionName = " " + regionname.Count() + " Selected";
            else
                ViewBag.RegionName = Country_Terr_Name.TrimStart(',').TrimEnd(',');

            ViewBag.Region = lsts;
            ViewBag.RegionId = "ddlRegionn";
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            string Is_Syn_CoExclusive = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Syn_CoExclusive").Select(x => x.Parameter_Value).FirstOrDefault();
            if (Is_Syn_CoExclusive == "Y")
            {
                ViewBag.Exclusive_Rights = new SelectList(new[]
                {
                    new { Code = "B", Name = "Please Select" },
                    new { Code = "Y", Name = "Exclusive" },
                    new { Code = "N", Name = "Non-Exclusive" },
                    new { Code = "C", Name = "Co-Exclusive" }
                }, "Code", "Name");
            }
            else
            {
                ViewBag.Exclusive_Rights = new SelectList(new[]
                {
                    new { Code = "B", Name = "Both" },
                    new { Code = "Y", Name = "Yes" },
                    new { Code = "N", Name = "No" }
                }, "Code", "Name");
            }

            ViewBag.FilterPageFrom = "SR";

            if (callFor == "")
                return PartialView("~/Views/Shared/_Rights_Filter.cshtml");
            else
                return PartialView("~/Views/Shared/_Rights_Filter_Bulk.cshtml");
        }
        public JsonResult BindRegionList(string TitleCode)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            string htmldata = "";
            string hdntitleCode = "";
            if (TitleCode == "")
            {
                int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
                int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
            }
            else
            {
                string[] code = TitleCode.Split(',');
                string[] titlecode = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => code.Contains(x.Syn_Deal_Movie_Code.ToString())).Select(s => s.Title_Code.ToString()).ToArray();
                int?[] rightsCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "N").SelectMany(x => x.Syn_Deal_Rights_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Syn_Deal_Rights_Code).ToArray();
                int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => rightsCode.Contains(s.Syn_Deal_Rights_Code) && s.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(w => w.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();
                int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => rightsCode.Contains(s.Syn_Deal_Rights_Code) && s.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(w => w.Territory_Type == "I").Select(s => s.Country_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
                string strPlatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "N").SelectMany(x => x.Syn_Deal_Rights_Platform).Select(w => w.Platform_Code).ToArray());
                hdntitleCode = string.Join(",", titlecode);
            }

            obj.Add("htmldata", htmldata);
            obj.Add("TitleCode", hdntitleCode);
            //obj.Add("ddlRegionn", new SelectList(lsts, "Text", "Value"));
            //obj.Add("SelectedCode", selectedCountryCodes);
            return Json(obj);
        }
        public PartialViewResult BindRightsPlatformTreePopup(string TitleCode, string platformcode)
        {
            if (DPlatformCode != "")
                platformcode = DPlatformCode;
            DPlatformCode = null;
            string selectedplatform = "";
            string strPlatform;
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string[] titlecode = TitleCode.Split(',');
            string[] pCode = platformcode.Split(',');
            int?[] rightsCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "N").SelectMany(x => x.Syn_Deal_Rights_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Syn_Deal_Rights_Code).ToArray();

            if (TitleCode == "")
            {
                strPlatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "N").SelectMany(x => x.Syn_Deal_Rights_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
                selectedplatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "N").SelectMany(x => x.Syn_Deal_Rights_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                if (strPlatform == "")
                    strPlatform = "0";
                objPTV.PlatformCodes_Display = strPlatform;
                objPTV.PlatformCodes_Selected = selectedplatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                selectedplatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Syn_Deal_Rights_Code) && x.Is_Pushback == "N").SelectMany(x => x.Syn_Deal_Rights_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                strPlatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Syn_Deal_Rights_Code) && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
                if (strPlatform == "")
                    strPlatform = "0";
                objPTV.PlatformCodes_Display = strPlatform;
                objPTV.PlatformCodes_Selected = selectedplatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            objPTV.Show_Selected = false;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform_Filter";
            ViewBag.TreeValueId = "hdnTVCode";
            return PartialView("_TV_Platform");
        }
        private void ClearSession()
        {
            objSyn_Deal = null;
            objSDS = null;
        }
        private void Fill_Rights_Schema(string view_Type, string Title_Code_Search, int txtpageSize = 100, int pageNo = 0, string ExclusiveRight = "B")
        {
            objDeal_Schema.Rights_View = view_Type;
            objDeal_Schema.Rights_Titles = Title_Code_Search;
            objDeal_Schema.Rights_PageSize = txtpageSize;
            objDeal_Schema.Rights_PageNo = pageNo;
            objDeal_Schema.Rights_Exclusive = ExclusiveRight;
        }
        public PartialViewResult BindGrid(string Selected_Title_Code, string view_Type, string RegionCode, string PlatformCode, string ExclusiveRight, int txtpageSize = 100, int page_index = 0, string IsCallFromPaging = "N")
        {
            if (DPlatformCode == "D")
                DPlatformCode = PlatformCode;
            ViewBag.Mode = "LIST";
            int PageNo = page_index <= 0 ? 1 : page_index + 1;
            if (IsCallFromPaging == "N" || IsCallFromPaging == "C")            //Here C means Summary and Deatails)                
                objDeal_Schema.List_Rights.Clear();
            Fill_Rights_Schema(view_Type, Selected_Title_Code, txtpageSize, PageNo, ExclusiveRight);

            int totalRcord = 0;
            ObjectParameter objPageNo = new ObjectParameter("PageNo", PageNo);
            ObjectParameter objTotalRecord = new ObjectParameter("TotalRecord", totalRcord);
            List<USP_List_Rights_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Rights("SR", objDeal_Schema.Rights_View, objDeal_Schema.Deal_Code,
                objDeal_Schema.Rights_Titles, RegionCode, PlatformCode, objDeal_Schema.Rights_Exclusive, objPageNo, txtpageSize, objTotalRecord, "").ToList();

            ViewBag.RecordCount = Convert.ToInt32(objTotalRecord.Value);
            ViewBag.PageNo = Convert.ToInt32(objPageNo.Value);

            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.Page_View = objDeal_Schema.Rights_View;
            objDeal_Schema.Rights_Titles = Selected_Title_Code;
            objDeal_Schema.Rights_Region = RegionCode;
            objDeal_Schema.Rights_Platform = PlatformCode;
            objDeal_Schema.Rights_Exclusive = ExclusiveRight;

            string[] regioncode = RegionCode.Split(',');
            string[] arrSelectedCountryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I" && regioncode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Code.ToString()).ToArray();
            string[] arrSelectedTerritoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G" && regioncode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Code.ToString()).ToArray();
            int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "N").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

            List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
            if (arrSelectedCountryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Country" && arrSelectedCountryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
            if (arrSelectedTerritoryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Territory" && arrSelectedTerritoryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            ViewBag.Region = lsts;
            return PartialView("~/Views/Syn_Deal/_List_Rights.cshtml", lst);
        }
        public PartialViewResult BindPlatformTreePopup(int rightCode)
        {
            Syn_Deal_Rights objSDR = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).GetById(rightCode);
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string strPlatform = string.Join(",", objSDR.Syn_Deal_Rights_Platform.Select(s => s.Platform_Code).ToArray());
            objPTV.PlatformCodes_Display = strPlatform;
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            objPTV.Show_Selected = true;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }
        public ActionResult ButtonEvents(string MODE, int? RCode, int? PCode, int? TCode, int? Episode_From, int? Episode_To, string IsHB, string Is_Syn_Acq_Mapp = "")
        {
            Dictionary<string, string> obj_Dictionary_RList = new Dictionary<string, string>();
            obj_Dictionary_RList.Add("MODE", MODE);
            obj_Dictionary_RList.Add("RCode", RCode == null ? "0" : RCode.ToString());
            obj_Dictionary_RList.Add("PCode", PCode == null ? "0" : PCode.ToString());
            obj_Dictionary_RList.Add("TCode", TCode == null ? "0" : TCode.ToString());
            obj_Dictionary_RList.Add("Episode_From", Episode_From == null ? "0" : Episode_From.ToString());
            obj_Dictionary_RList.Add("Episode_To", Episode_To == null ? "0" : Episode_To.ToString());
            obj_Dictionary_RList.Add("IsHB", IsHB);
            obj_Dictionary_RList.Add("Is_Syn_Acq_Mapp", Is_Syn_Acq_Mapp);
            TempData["QueryString_Rights"] = obj_Dictionary_RList;
            string tabName = GlobalParams.Page_From_Rights_Detail_AddEdit;
            if (MODE == GlobalParams.DEAL_MODE_VIEW || MODE == GlobalParams.DEAL_MODE_APPROVE)
                tabName = GlobalParams.Page_From_Rights_Detail_View;
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("TabName", tabName);
            return Json(obj);
        }
        private List<USP_Get_Acq_PreReq_Result> Get_Acq_PreReq_Result(string titles, string platforms, string Platform_Type = "", string Region_Type = "", string Subtitling_Type = "", string Dubbing_Type = "", string CallFrom = "", string Data_For = "", string str_Type = "")
        {
            string AllCountry_Territory_Codes = "";
            string AllPlatform_Codes = "";
            string SubTitle_Lang_Codes = "";
            string Dubb_Lang_Codes = "";
            // Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
            platforms = string.Join(",", platforms.Split(',').Where(p => p != "0"));
            List<USP_GET_DATA_FOR_APPROVED_TITLES_Result> objList = new List<USP_GET_DATA_FOR_APPROVED_TITLES_Result>();
            if (titles != "" && titles != "0")
                objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_DATA_FOR_APPROVED_TITLES(titles, platforms, Platform_Type, Region_Type, Subtitling_Type, Dubbing_Type, objDeal_Schema.Deal_Code).ToList();
            else
                AllCountry_Territory_Codes = AllPlatform_Codes = SubTitle_Lang_Codes = Dubb_Lang_Codes = "";
            if (Platform_Type == "PL" || Platform_Type == "TPL")
                AllPlatform_Codes = objList.Select(i => i.RequiredCodes).FirstOrDefault();
            else
            {
                foreach (USP_GET_DATA_FOR_APPROVED_TITLES_Result obj in objList)
                {
                    AllCountry_Territory_Codes = obj.RequiredCodes;
                    SubTitle_Lang_Codes = obj.SubTitle_Lang_Code;
                    Dubb_Lang_Codes = obj.Dubb_Lang_Code;
                }
            }
            List<USP_Get_Acq_PreReq_Result> lst_USP_Get_Acq_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            lst_USP_Get_Acq_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Rights_PreReq(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, Data_For, str_Type,
                AllCountry_Territory_Codes, SubTitle_Lang_Codes, Dubb_Lang_Codes).ToList();
            return lst_USP_Get_Acq_PreReq_Result;
            //return true;
        }
        public JsonResult ValidateRightsTitleWithAcq(int RCode, int? TCode, int? Episode_From, int? Episode_To)
        {
            int count = 0;
            count = objUSP_Service.USP_Validate_Syn_Right_Title_With_Acq_On_Edit(RCode, TCode, Episode_From, Episode_To).ElementAt(0).Value;
            if (count > 0)
                return Json("INVALID");
            else
                return Json("VALID");
        }
        private string Validate_Right_For_Run_Def(int RCode, int TCode, int EP_From, int EP_To, int PCode)
        {
            Syn_Deal_Rights objR = objSyn_Deal.Syn_Deal_Rights.Where(w => w.Syn_Deal_Rights_Code == RCode).FirstOrDefault();
            if (objR != null)
            {
                int count = 0;
                EP_From = EP_From == 0 ? 1 : EP_From;
                EP_To = EP_To == 0 ? 1 : EP_To;
                List<string> lstPlatformCode = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_No_Of_Run == "Y").Where(w => (w.Platform_Code == PCode) || (PCode == 0)).Select(p => p.Platform_Code.ToString()).ToList();
                int platformcount = objR.Syn_Deal_Rights_Platform.Where(w => lstPlatformCode.Contains(w.Platform_Code.ToString()) && w.EntityState != State.Deleted).Count();
                if (platformcount > 0)
                {
                    if (TCode > 0 || PCode > 0)
                    {
                        List<int> lstTitlecode = (from objRun in objSyn_Deal.Syn_Deal_Run
                                                  where objRun.Syn_Deal_Code == objDeal_Schema.Deal_Code && ((objRun.Title_Code == TCode && objRun.Episode_From == EP_From && objRun.Episode_To == EP_To) || (TCode == 0))
                                                  select objRun.Title_Code.Value).ToList();
                        count = objR.Syn_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                        if (count > 0)
                            return objMessageKey.Youcannotdeletethisrightasthisrighthasrundefinitionassociatedwithit;
                    }
                    else
                    {
                        List<int> lstTitlecode = (from objRun in objSyn_Deal.Syn_Deal_Run
                                                  from objRightTitle in objR.Syn_Deal_Rights_Title
                                                  where objRun.Syn_Deal_Code == objDeal_Schema.Deal_Code && ((objRun.Title_Code == objRightTitle.Title_Code && objRun.Episode_From == objRightTitle.Episode_From && objRun.Episode_To == objRightTitle.Episode_To))
                                                  select objRun.Title_Code.Value).ToList();
                        count = objR.Syn_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                        if (count > 0)
                            return objMessageKey.Youcannotdeletethisrightasthisrighthasrundefinitionassociatedwithit;
                    }
                }
            }
            return "";
        }
        private string Validate_Right_For_Music(int RCode, int TCode, int EP_From, int EP_To, int PCode)
        {
            Syn_Deal_Rights objR = objSyn_Deal.Syn_Deal_Rights.Where(w => w.Syn_Deal_Rights_Code == RCode).FirstOrDefault();
            if (objR != null)
            {
                int count = 0;
                EP_From = EP_From == 0 ? 1 : EP_From;
                EP_To = EP_To == 0 ? 1 : EP_To;

                string strMusicPlatform = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Platform_RightsInSongs_Codes").Select(x => x.Parameter_Value).FirstOrDefault();
                var arrMusic = strMusicPlatform.Split(',');

                List<string> lstPlatformCode = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => arrMusic.Contains(p.Platform_Code.ToString())).Where(w => (w.Platform_Code == PCode) || (PCode == 0)).Select(p => p.Platform_Code.ToString()).ToList();
                int platformcount = objR.Syn_Deal_Rights_Platform.Where(w => lstPlatformCode.Contains(w.Platform_Code.ToString()) && w.EntityState != State.Deleted).Count();
                if (platformcount > 0)
                {
                    if (TCode > 0 || PCode > 0)
                    {
                        List<int> lstTitlecode = (from objMusic in objSyn_Deal.Syn_Deal_Digital
                                                  where objMusic.Syn_Deal_Code == objDeal_Schema.Deal_Code && ((objMusic.Title_code == TCode && objMusic.Episode_From == EP_From && objMusic.Episode_To == EP_To) || (TCode == 0))
                                                  select objMusic.Title_code.Value).ToList();
                        count = objR.Syn_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                        if (count > 0)
                            return objMessageKey.Youcannotdeletethisrightasthisrighthasmusicassociatedwithit;
                    }
                    else
                    {
                        List<int> lstTitlecode = (from objMusic in objSyn_Deal.Syn_Deal_Digital
                                                  from objRightTitle in objR.Syn_Deal_Rights_Title
                                                  where objMusic.Syn_Deal_Code == objDeal_Schema.Deal_Code && ((objMusic.Title_code == objRightTitle.Title_Code && objMusic.Episode_From == objRightTitle.Episode_From && objMusic.Episode_To == objRightTitle.Episode_To))
                                                  select objMusic.Title_code.Value).ToList();
                        count = objR.Syn_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                        if (count > 0)
                            return objMessageKey.Youcannotdeletethisrightasthisrighthasmusicassociatedwithit;
                    }
                }
            }
            return "";
        }
        public JsonResult DeleteRight(string RightCode, string DealCode, string TitleCode, string PlatformCode, string EpisodeFrom, string EpisodeTo, string ViewType)
        {
            DPlatformCode = "D";
            string Result = "", IS_Syn_Autopush = "", ShowErrorFlag = "";
            string strMessageAutoPush = "You can not delete this rights as it is already syndicated in V18";

            try
            {
                var BuybackRights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Buyback_Syn_Rights_Code == RightCode).ToList();

                if(BuybackRights.Count() > 0)
                {
                    var objReturn = new
                    {
                        ShowError = "E",
                        RightMsg = "Cannot delete Syndication Rights as it is in Buyback."
                    };
                    return Json(objReturn);

                }

                int Title_Code = Convert.ToInt32(TitleCode);
                int Right_Code = Convert.ToInt32(RightCode);
                int Deal_Code = Convert.ToInt32(DealCode);
                int Episode_From = Convert.ToInt32(EpisodeFrom);
                int Episode_To = Convert.ToInt32(EpisodeTo);
                int Platform_Code = 0;
                IS_Syn_Autopush = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Rights_Autopush_Delete_Validation(Right_Code).FirstOrDefault();
                string Validate_Msg = "", Validate_Music_Msg = "";
                if (ViewType == "D")
                    Platform_Code = Convert.ToInt32(PlatformCode);
                Validate_Msg = Validate_Right_For_Run_Def(Right_Code, Title_Code, Episode_From, Episode_To, Platform_Code);
                Validate_Music_Msg = Validate_Right_For_Music(Right_Code, Title_Code, Episode_From, Episode_To, Platform_Code);
                if (Validate_Msg == "" && Validate_Music_Msg == "")
                {

                    bool IsSameAsGroup = false;
                    if (Title_Code > 0 || Platform_Code > 0)
                    {
                        Syn_Deal objDeal = new Syn_Deal();
                        Syn_Deal_Service objADS = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
                        objDeal = objADS.GetById(Deal_Code);

                        Syn_Deal_Rights objExistingRight = objDeal.Syn_Deal_Rights.Where(t => t.Syn_Deal_Rights_Code == Right_Code).FirstOrDefault();
                        if (objExistingRight.Syn_Deal_Rights_Title.Count == 1 && Title_Code > 0 && objExistingRight.Syn_Deal_Rights_Platform.Count == 1 && Platform_Code > 0)
                            IsSameAsGroup = true;
                        else if (objExistingRight.Syn_Deal_Rights_Title.Count == 1 && Title_Code > 0 && Platform_Code == 0)
                            IsSameAsGroup = true;
                        else
                        {
                            bool isMovieDelete = true;
                            if (objExistingRight.Syn_Deal_Rights_Title.Count > 1)
                                objExistingRight.Syn_Deal_Rights_Title.Where(t => t.Title_Code == Title_Code && t.Episode_From == Episode_From && t.Episode_To == Episode_To).ToList<Syn_Deal_Rights_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                            else
                                isMovieDelete = false;

                            if (Platform_Code > 0)
                            {
                                if (!isMovieDelete)
                                    objExistingRight.Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t => { if (t.Platform_Code == Platform_Code) t.EntityState = State.Deleted; });
                                else if (objExistingRight.Syn_Deal_Rights_Platform.Count > 1)
                                {
                                    Syn_RightsController objRights = new Syn_RightsController();
                                    Syn_Deal_Rights objSecondRight = objRights.SetNewSynDealRight(objExistingRight, Title_Code, Episode_From, Episode_To, Platform_Code);
                                    objDeal.Syn_Deal_Rights.Add(objSecondRight);
                                }
                            }
                            objExistingRight.EntityState = State.Modified;
                            objDeal.EntityState = State.Modified;
                            objDeal.SaveGeneralOnly = false;
                            dynamic resultSet;
                            objADS.Save(objDeal, out resultSet);
                            Syn_Acq_Mapping(objDeal.Syn_Deal_Code);
                        }
                    }
                    else
                        IsSameAsGroup = true;

                    if (IS_Syn_Autopush == "Y")
                    {
                        Result = strMessageAutoPush;
                        ShowErrorFlag = "E";
                    }
                    else
                    {
                        if (IsSameAsGroup)
                        {
                            Syn_Deal_Rights_Service objSDRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                            Syn_Deal_Rights objRights = objSDRS.GetById(Right_Code);
                            objRights.EntityState = State.Deleted;
                            dynamic resultSet;
                            bool isValid = objSDRS.Delete(objRights, out resultSet);
                            if (isValid)
                            {
                                Syn_Acq_Mapping(objRights.Syn_Deal_Code);
                                Result = objMessageKey.RightsDeletedSuccessfully;
                                ShowErrorFlag = "S";
                            }
                        }
                        if (Result == "")
                        {
                            Result = objMessageKey.RightsDeletedSuccessfully;
                            ShowErrorFlag = "S";
                        }
                        objDeal_Schema.List_Rights.Clear();
                    }

                }
                else
                {
                    if (!string.IsNullOrEmpty(Validate_Msg))
                    {
                        Result = Validate_Msg;
                    }
                    else if (!string.IsNullOrEmpty(Validate_Music_Msg))
                    {
                        Result = Validate_Music_Msg;
                    }
                    ShowErrorFlag = "E";
                }
            }
            catch (Exception ex)
            {
            }
            var obj = new
            {
                ShowError = ShowErrorFlag,
                RightMsg = Result
            };
            return Json(obj);
        }
        public JsonResult ChangeTab(string hdnTabName, string txtAcqRemarks = "", string hdnReopenMode = "", string hdnTabCurrent = "")
        {
            ClearSession();
            string msg = "", mode = "", status = "S";

            if (hdnReopenMode == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_APPROVE && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && hdnTabCurrent == "")
            {
                Syn_Deal objSynDeal = objSDS.GetById(objDeal_Schema.Deal_Code);
                objSynDeal.Rights_Remarks = txtAcqRemarks.Replace("\r\n", "\n");
                objSynDeal.EntityState = State.Modified;
                dynamic resultSet;
                objSDS.Save(objSynDeal, out resultSet);
                TempData["RedirectSynDeal"] = objSynDeal;
            }
            if (hdnTabName == "")
            {
                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", objDeal_Schema.PageNo.ToString());
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                // return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl("", objDeal_Schema.PageNo, 0, GlobalParams.ModuleCodeForSynDeal);
                string Mode = objDeal_Schema.Mode;
                msg = "Deal saved successfully";
                //TempData["RedirectSynDeal"] = objSyn_Deal;
                if (Mode == GlobalParams.DEAL_MODE_EDIT)
                    msg = "Deal updated successfully";
            }
            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(hdnTabName, objDeal_Schema.PageNo, null, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);
        }
        private void Syn_Acq_Mapping(int Syn_Deal_Code)
        {
            IEnumerable<string> obj_Mapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Acq_Mapping(Syn_Deal_Code, "N");
        }
        public ActionResult Cancel()
        {
            ClearSession();
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            objDeal_Schema = null;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", pageNo.ToString());
                obj_Dic.Add("ReleaseRecord", "Y");
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl("", objDeal_Schema.PageNo, 0, GlobalParams.ModuleCodeForSynDeal);
            }
        }
        public JsonResult GetSynRightsStatus(int RightsCode)
        {
            Syn_Deal_Rights objSynRighs = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).GetById(RightsCode);
            return Json(objSynRighs.Right_Status);
        }
        public PartialViewResult Show_Error_Popup(string searchForTitles, string PageSize, int PageNo, int RightsCode, string ErrorMsg = "")
        {
            List<string> arrTitleNames = new List<string>();
            List<string> arrErrorNames = new List<string>();
            PageNo += 1;
            ViewBag.PageNo = PageNo;
            int Record_Count = 0;
            if (PageSize == "" || PageSize == "0" || PageSize == null)
                PageSize = "10";
            int partialPageSize = Convert.ToInt32(PageSize);
            lstErrorRecords = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Syn_Rights_Errors(RightsCode, "").ToList();
            if (searchForTitles != string.Empty)
                arrTitleNames = searchForTitles.Split(',').ToList();
            if (ErrorMsg != string.Empty)
                arrErrorNames = ErrorMsg.Split(',').ToList();
            if (ErrorMsg.TrimEnd() == string.Empty)
                ErrorMsg = lstErrorRecords[0].ErrorMsg.Trim();
            lstErrorRecords_Titles = lstErrorRecords.Where(w => (arrTitleNames.Contains(w.Title_Name) || arrTitleNames.Count <= 0) && w.ErrorMsg.Trim().Equals(ErrorMsg)).ToList();
            ViewBag.SearchTitles = new MultiSelectList(lstErrorRecords.Where(w => w.ErrorMsg.Trim().Equals(ErrorMsg)).ToList().Select(s => new { Title_Name = s.Title_Name }).Distinct(), "Title_Name", "Title_Name", arrTitleNames);
            Record_Count = lstErrorRecords_Titles.Count;
            ViewBag.RecordCount = Record_Count;
            ViewBag.PageSize = PageSize;
            ViewBag.ErrorRecord = new MultiSelectList(lstErrorRecords.Select(s => new { ErrorMsg = s.ErrorMsg.Trim() }).Distinct(), "ErrorMsg", "ErrorMsg", arrErrorNames);
            return PartialView("~/Views/Shared/_Syn_Error_Popup.cshtml", lstErrorRecords_Titles.Skip((PageNo - 1) * partialPageSize).Take(partialPageSize).ToList());
        }
        public JsonResult Reprocess(int Rights_Code)
        {
            new USP_Service(objLoginEntity.ConnectionStringName).USP_Reprocess_Rights(Rights_Code, "");

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", objMessageKey.RightsReprocessedSuccessfully);
            obj.Add("RedirectTo", "Index");
            return Json(obj);
        }
        public JsonResult ShowRestriction_Remarks_Popup(int RightsCode, int Title_Code, int Episode_From, int Episode_To, int Platform_Code)
        {
            Syn_Deal_Rights objSyn_Deal_Rights = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).GetById(RightsCode);
            USP_Service objUSP_Service = new USP_Service(objLoginEntity.ConnectionStringName);
            objSyn_Deal_Rights.Fill_All_UDT(Title_Code, Episode_From, Episode_To, Platform_Code);
            IEnumerable<USP_Get_Data_Restriction_Remark_UDT> objResult = objUSP_Service.USP_Get_Data_Restriction_Remark_UDT(
               objSyn_Deal_Rights.LstDeal_Rights_UDT,
               objSyn_Deal_Rights.LstDeal_Rights_Title_UDT,
               objSyn_Deal_Rights.LstDeal_Rights_Platform_UDT,
               objSyn_Deal_Rights.LstDeal_Rights_Territory_UDT,
               objSyn_Deal_Rights.LstDeal_Rights_Subtitling_UDT,
               objSyn_Deal_Rights.LstDeal_Rights_Dubbing_UDT);

            if (objResult.Count() > 0)
            {
                var q = objResult.Select(i => new
                {
                    Title_Name = i.Title_Name,
                    Platform_Name = i.Platform_Name,
                    Country_Name = i.Country_Name,
                    Restriction_Remarks = i.Restriction_Remarks,
                    Is_Title_Language_Right = i.Is_Title_Language_Right,
                    SubTitle_Lang_Name = i.SubTitle_Lang_Name,
                    Dubb_Lang_Name = i.Dubb_Lang_Name
                }).Distinct().ToList();
                return Json(q);
            }
            return Json("");
        }
        #region========================Changes For Bulk Update================
        public PartialViewResult BulkUpdate()
        {
            string TitleCodes = FillTitleCodes();
            ViewBag.TitleCode = TitleCodes;
            ViewBag.PlatformCodes = Get_PlatForm_Codes(TitleCodes);
            ViewBag.SynDealCode = objDeal_Schema.Deal_Code;
            objDeal_Schema.Mode = GlobalParams.DEAL_MODE_EDIT;
            try
            {
                ViewBag.Term_Perputity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value;
                ViewBag.Enabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
            }
            catch (Exception)
            {
                ViewBag.Term_Perputity = 0;
                ViewBag.Enabled_Perpetuity = "N";
            }
            return PartialView("~/Views/Syn_Deal/_Bulk_Update.cshtml");
        }
        public PartialViewResult BindBulkUpdateList(string Selected_Title_Code = "", string RegionCode = "", string PlatformCode = "", string ExclusiveRight = "B", int txtpageSize = 100, int page_index = 0, string IsCallFromPaging = "N", string view_Type = "G")
        {
            //if (objDeal_Schema.Deal_Type_Code == 11)
            //{
            //    view_Type = "G";
            //}
            ViewBag.Mode = "LIST";

            int totalRcord = 0;
            ObjectParameter objPageNo = new ObjectParameter("PageNo", page_index);
            ObjectParameter objTotalRecord = new ObjectParameter("TotalRecord", totalRcord);

            List<USP_List_Rights_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Rights("SR", view_Type, objDeal_Schema.Deal_Code,
              Selected_Title_Code, RegionCode, PlatformCode, ExclusiveRight, objPageNo, txtpageSize, objTotalRecord, "").ToList();

            ViewBag.RecordCount = Convert.ToInt32(objTotalRecord.Value);
            ViewBag.PageNo = Convert.ToInt32(objPageNo.Value);
            ViewBag.Deal_Mode = objDeal_Schema.Mode;

            return PartialView("~/Views/Syn_Deal/_Bulk_Update_List.cshtml", lst);
        }
        public string FillTitleCodes(string RightsCode = "")
        {
            string[] rightCode = RightsCode.Split(',');
            List<int> lst = new List<int>();

            Syn_Acq_Mapping_Service objSynAcq = new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName);
            List<Syn_Acq_Mapping> lstsynAcq = new List<Syn_Acq_Mapping>();
            string titlecodes = "";
            if (RightsCode != "")
                foreach (var item in rightCode)
                {
                    if (item != "")
                    {
                        int rcode = Convert.ToInt32(item);
                        List<Syn_Deal_Rights_Title> lst_title = new Syn_Deal_Rights_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Rights_Code == rcode).ToList();
                        foreach (var a in lst_title)
                        {
                            if (!titlecodes.Contains(Convert.ToString(a.Title_Code)))
                                titlecodes += ',' + Convert.ToString(a.Title_Code);
                        }
                    }
                }
            return titlecodes;
        }
        public JsonResult BindChangeDropdown()
        {
            List<SelectListItem> lst = new SelectList(new[]
                {
                    new { Value = "0", Text = objMessageKey.PleaseSelect },
                    new { Value = "RP", Text = objMessageKey.RightsPeriod },
                    new { Value = "P", Text = objMessageKey.Platforms},
                    new { Value = "I", Text = objMessageKey.Country },
                    new { Value = "T", Text = objMessageKey.Territory },
                    new { Value = "SL", Text = objMessageKey.Subtitlinglanguage },
                    new { Value = "SG", Text = "Sub-titling Language group" },
                    new { Value = "DL", Text = objMessageKey.Dubbinglanguage },
                    new { Value = "DG", Text = objMessageKey.DubbingLanguagegroup },
                    new { Value = "E", Text = objMessageKey.Exclusive },
                    new { Value = "S", Text = objMessageKey.Sublicensing },
                    new { Value = "TL", Text = objMessageKey.TitleLanguage }
                },
                 "Value", "Text", 0
             ).ToList();
            var arr = lst;
            return Json(arr, JsonRequestBehavior.AllowGet);
        }
        public JsonResult ChkBxEnableOrDisable(string Right_Code = "0", string Change_For = "")
        {
            Syn_Deal_Rights_Service objADRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Rights objRts = objADRS.GetById(Convert.ToInt32(Right_Code));
            string returnStr = "true";
            string message = "";
            if (Change_For == "I" || Change_For == "T")
            {
                string Type = objRts.Syn_Deal_Rights_Territory.Select(i => i.Territory_Type).FirstOrDefault();
                if (Type != "I" && Change_For == "I")
                {
                    returnStr = "false";
                    message = objMessageKey.selectedChangeTypeshouldbeTerritory;
                }
                else if (Type != "G" && Change_For == "T")
                {
                    returnStr = "false";
                    message = objMessageKey.selectedChangeTypeshouldbeCountry;
                }
                else
                    returnStr = "true";
            }
            if (Change_For == "SL" || Change_For == "SG")
            {
                string Type = objRts.Syn_Deal_Rights_Subtitling.Select(i => i.Language_Type).FirstOrDefault();
                if (Type != null)
                {
                    if (Type != "L" && Change_For == "SL")
                    {
                        returnStr = "false";
                        message = objMessageKey.selectedChangeTypeshouldbeSubtitlingLanguageGroup;
                    }
                    else if (Type != "G" && Change_For == "SG")
                    {
                        returnStr = "false";
                        message = objMessageKey.selectedChangeTypeshouldbeSubtitlingLanguage;
                    }
                    else
                        returnStr = "true";
                }
                else
                    returnStr = "true";
            }
            if (Change_For == "DL" || Change_For == "DG")
            {
                string Type = objRts.Syn_Deal_Rights_Dubbing.Select(i => i.Language_Type).FirstOrDefault();
                if (Type != null)
                {
                    if (Type != "L" && Change_For == "DL")
                    {
                        returnStr = "false";
                        message = objMessageKey.selectedChangeTypeshouldbeDubbingLanguageGroup;
                    }
                    else if (Type != "G" && Change_For == "DG")
                    {
                        returnStr = "false";
                        message = objMessageKey.selectedChangeTypeshouldbeDubbingLanguage;
                    }
                    else
                        returnStr = "true";
                }
                else
                    returnStr = "true";
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("flag", returnStr);
            obj.Add("Message", message);
            return Json(obj);
        }
        public string Get_PlatForm_Codes(string titles)
        {
            // Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
            string AllPlatform_Codes = "";
            List<USP_GET_DATA_FOR_APPROVED_TITLES_Result> objList = new List<USP_GET_DATA_FOR_APPROVED_TITLES_Result>();
            if (titles != "" && titles != "0")
                objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_DATA_FOR_APPROVED_TITLES(titles, "", "PL", "", "", "", objDeal_Schema.Deal_Code).ToList();

            AllPlatform_Codes = objList.Select(i => i.RequiredCodes).FirstOrDefault();
            return AllPlatform_Codes;
        }
        public JsonResult BulkSave(string SelectedRightCodes, string ChangeFor, string SelectedCodes = "0", string SelectedStartDate = "", string RightsType = "",
            string IsTentative = "", string ActionFor = "", string SelectedEndDate = "", string IsExclusive = "", string IsTitleLanguage = "", string Term_MM = "",
            string Term_YY = "", string Term_DD = ""
            , string SelectedTitleCodes = "", string SelectedTitleNames = "", string Eps_Frm_To = "", string pageView = "")
        {

            #region Optimization loading
            string Right_Codes = SelectedRightCodes.Replace(" ", "");
            string IsProgram = objDeal_Schema.Deal_Type_Code == 11 ? "Y" : "N";

            Rights_Bulk_Update objRights_Bulk_Update = new Rights_Bulk_Update();
            objRights_Bulk_Update.Right_Codes = Right_Codes;
            objRights_Bulk_Update.Action_For = ActionFor;
            objRights_Bulk_Update.Change_For = ChangeFor;

            if (ChangeFor == "RP")
            {
                if (RightsType == "Y")
                {
                    objRights_Bulk_Update.Is_Tentative = IsTentative.ToUpper() == "TRUE" ? "Y" : "N";
                    objRights_Bulk_Update.Term = Term_YY + "." + Term_MM + "." + Term_DD;
                    if (!string.IsNullOrEmpty(SelectedStartDate))
                        objRights_Bulk_Update.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));
                    if (!string.IsNullOrEmpty(SelectedEndDate))
                        objRights_Bulk_Update.End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedEndDate));
                }
                else if (RightsType == "U")
                {
                    int termYear = 0;
                    string Enabled_Perpetuity = "";
                    try
                    {
                        Enabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
                        termYear = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value);
                    }
                    catch (Exception)
                    {
                        termYear = 0;
                        Enabled_Perpetuity = "";
                    }
                    objRights_Bulk_Update.Is_Tentative = "N";
                    if (Enabled_Perpetuity == "Y")
                    {
                        objRights_Bulk_Update.Term = termYear + ".0";
                        objRights_Bulk_Update.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));
                        objRights_Bulk_Update.End_Date = ((DateTime)objRights_Bulk_Update.Start_Date).AddYears(termYear).AddDays(-1);
                    }
                    else
                    {
                        objRights_Bulk_Update.Term = "0";
                        objRights_Bulk_Update.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));
                        objRights_Bulk_Update.End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat("30/09/9999"));
                    }
                }
                objRights_Bulk_Update.Rights_Type = RightsType;
            }
            else if (ChangeFor == "E")
            {
                objRights_Bulk_Update.Is_Exclusive = IsExclusive;
            }
            else if (ChangeFor == "TL")
            {
                objRights_Bulk_Update.Is_Title_Language = IsTitleLanguage;
            }

            objRights_Bulk_Update.Codes = SelectedCodes;
            objRights_Bulk_Update.Page_View = pageView;
            objRights_Bulk_Update.EntityState = State.Added;
            objRights_Bulk_Update.Deal_Code = objDeal_Schema.Deal_Code;
            objRights_Bulk_Update.Inserted_On = System.DateTime.Now;
            objRights_Bulk_Update.Is_Processed = "N";
            //objRights_Bulk_Update.Is_Syn_Acq_Mapp = '~' + Is_Syn_Acq_Mapp;
            objRights_Bulk_Update.SelectedTitleCodes = SelectedTitleCodes;
            objRights_Bulk_Update.SelectedTitleNames = SelectedTitleNames;

            #endregion

            #region Adesh Sir
            string[] arrSelectedRightCodes = SelectedRightCodes.Replace(" ", "").Split(',').ToArray();
            string[] arrSelectedTitleNames = SelectedTitleNames.Split(',').ToArray();
            string[] arrSelectedTitleCodes = SelectedTitleCodes.Replace(" ", "").Split(',').ToArray();
            //string[] arrIs_Syn_Acq_Mapp = Is_Syn_Acq_Mapp.Replace(" ", "").Split(',').ToArray();
            string[] arrEps_Frm_To = IsProgram == "Y" ? Eps_Frm_To.Replace(" ", "").Split(',').ToArray() : null;

            if (pageView == "S")//&& objDeal_Schema.Deal_Type_Code != 11
            {

                List<Merge_Rights_Title_Map> lstMerge_Rights_Title_Map = new List<Merge_Rights_Title_Map>();
                List<Rights_Title_Code> lstRights_Title_Code = new List<Rights_Title_Code>();
                Syn_Deal_Rights_Title_Service objSyn_Deal_Rights_Title_Service = new Syn_Deal_Rights_Title_Service(objLoginEntity.ConnectionStringName);

                for (int i = 0; i < arrSelectedRightCodes.Count(); i++)
                {
                    Merge_Rights_Title_Map objMRTM = new Merge_Rights_Title_Map();
                    objMRTM.RightsCode = arrSelectedRightCodes.ElementAt(i);
                    objMRTM.TitleName = arrSelectedTitleNames.ElementAt(i);
                    //objMRTM.IsSynSynMap = arrIs_Syn_Syn_Mapp.ElementAt(i);
                    objMRTM.TitleCode = arrSelectedTitleCodes.ElementAt(i);
                    if (IsProgram == "Y")
                        objMRTM.Esp_From_To = arrEps_Frm_To.ElementAt(i);
                    objMRTM.IsError = "N";
                    lstMerge_Rights_Title_Map.Add(objMRTM);
                }

                foreach (var item in lstMerge_Rights_Title_Map)
                {
                    if (item.RightsCode != "" && item.IsError != "Y")
                    {
                        int Syn_Deal_Rights_Code = Convert.ToInt32(item.RightsCode);
                        int Title_Code = Convert.ToInt32(item.TitleCode);
                        var objADRNew = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Rights_Code == Syn_Deal_Rights_Code).FirstOrDefault();

                        if (objADRNew.Syn_Deal_Rights_Title.Count() > 1 &&
                            objADRNew.Syn_Deal_Rights_Title.Count() != lstMerge_Rights_Title_Map.Where(x => x.RightsCode == Syn_Deal_Rights_Code.ToString()).Count())
                        {
                            var templst = lstRights_Title_Code.Where(x => x.RightsCode == Syn_Deal_Rights_Code).ToList();
                            Syn_Deal_Rights_Title objADRTitle = new Syn_Deal_Rights_Title();

                            if (IsProgram == "Y")
                            {
                                objADRTitle = objADRNew.Syn_Deal_Rights_Title.Where(x => x.Syn_Deal_Rights_Code == Syn_Deal_Rights_Code && x.Title_Code == Title_Code && x.Episode_From == Convert.ToInt32(item.Esp_From_To.Split('~')[0])
                                 && x.Episode_To == Convert.ToInt32(item.Esp_From_To.Split('~')[1])).FirstOrDefault();
                            }

                            if (templst.Count() == 0)
                            {
                                //change as per program and movie
                                var NewSyn_Deal_Rights_Code = new USP_Service(objLoginEntity.ConnectionStringName)
                                    .USP_Syn_Deal_Right_Clone(objSyn_Deal.Syn_Deal_Code, Syn_Deal_Rights_Code, objADRTitle.Syn_Deal_Rights_Title_Code, Title_Code, IsProgram);

                                item.RightsCode = NewSyn_Deal_Rights_Code.ElementAt(0).ToString();



                                //this is used to add same title in the diffrent rights code
                                Rights_Title_Code objRights_Title_Code = new Rights_Title_Code();
                                objRights_Title_Code.New_RightsCode = Convert.ToInt32(item.RightsCode);
                                objRights_Title_Code.RightsCode = Syn_Deal_Rights_Code;
                                objRights_Title_Code.TitleCode = Title_Code;
                                lstRights_Title_Code.Add(objRights_Title_Code);
                            }
                            else
                            {
                                Syn_Deal_Rights_Title objADRT = new Syn_Deal_Rights_Title();
                                if (IsProgram == "Y")
                                    objADRT = objSyn_Deal_Rights_Title_Service.SearchFor(x => x.Syn_Deal_Rights_Title_Code == objADRTitle.Syn_Deal_Rights_Title_Code && x.Title_Code == Title_Code).FirstOrDefault();
                                else
                                    objADRT = objSyn_Deal_Rights_Title_Service.SearchFor(x => x.Syn_Deal_Rights_Code == Syn_Deal_Rights_Code && x.Title_Code == Title_Code).FirstOrDefault();
                                objADRT.EntityState = State.Deleted;
                                dynamic resultSet1;
                                objSyn_Deal_Rights_Title_Service.Delete(objADRT, out resultSet1);

                                Syn_Deal_Rights_Title objSyn_Deal_Rights_Title = new Syn_Deal_Rights_Title();

                                objSyn_Deal_Rights_Title.Episode_From = IsProgram == "Y" ? objADRT.Episode_From : 1;
                                objSyn_Deal_Rights_Title.Episode_To = IsProgram == "Y" ? objADRT.Episode_To : 1;
                                objSyn_Deal_Rights_Title.Title_Code = Title_Code;
                                objSyn_Deal_Rights_Title.EntityState = State.Added;
                                objSyn_Deal_Rights_Title.Syn_Deal_Rights_Code = templst.ElementAt(0).New_RightsCode;
                                dynamic resultSet2;
                                // objSyn_Deal_Rights_Title_Service.Save(objSyn_Deal_Rights_Title, out resultSet2);

                                item.RightsCode = templst.ElementAt(0).New_RightsCode.ToString();

                            }
                        }
                    }
                }

                objRights_Bulk_Update.Right_Codes = String.Join(",", lstMerge_Rights_Title_Map.Select(x => x.RightsCode));
            }
            //dynamic resultSet;
            //new Rights_Bulk_Update_Service(objLoginEntity.ConnectionStringName).Save(objRights_Bulk_Update, out resultSet);
            #endregion

            //------------------------------------
            /*if (SelectedCodes == "")
                SelectedCodes = ",0";
            List<string> SelectedRightCodeList = SelectedRightCodes.Split(',').ToList();
            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            string Right_Codes = SelectedRightCodes.Replace(" ", "");*/

            #region Update Rights As it is 
            Right_Codes = objRights_Bulk_Update.Right_Codes;

            List<Rights_Bulk_Update_UDT> lstRights_Bulk_Update_UDT = new List<Rights_Bulk_Update_UDT>();
            Rights_Bulk_Update_UDT objRights_Bulk_Update_UDT = new Rights_Bulk_Update_UDT();
            objRights_Bulk_Update_UDT.Right_Codes = Right_Codes;
            objRights_Bulk_Update_UDT.Action_For = ActionFor;
            objRights_Bulk_Update_UDT.Change_For = ChangeFor;


            if (ChangeFor == "RP")
            {
                if (RightsType == "Y")
                {
                    objRights_Bulk_Update_UDT.Is_Tentative = IsTentative.ToUpper() == "TRUE" ? "Y" : "N";
                    objRights_Bulk_Update_UDT.Term = Term_YY + "." + Term_MM + "." + Term_DD;
                    if (!string.IsNullOrEmpty(SelectedStartDate))
                        objRights_Bulk_Update_UDT.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));
                    if (!string.IsNullOrEmpty(SelectedEndDate))
                        objRights_Bulk_Update_UDT.End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedEndDate));
                }
                else if (RightsType == "U")
                {
                    int termYear = 0;
                    string Enabled_Perpetuity = "";
                    try
                    {
                        Enabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
                        termYear = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value);
                    }
                    catch (Exception)
                    {
                        termYear = 0;
                        Enabled_Perpetuity = "";
                    }
                    objRights_Bulk_Update_UDT.Is_Tentative = "N";
                    if (Enabled_Perpetuity == "Y")
                    {
                        objRights_Bulk_Update_UDT.Term = termYear + ".0";
                        objRights_Bulk_Update_UDT.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));
                        objRights_Bulk_Update_UDT.End_Date = ((DateTime)objRights_Bulk_Update_UDT.Start_Date).AddYears(termYear).AddDays(-1);
                    }
                    else
                    {
                        objRights_Bulk_Update_UDT.Term = "0";
                        objRights_Bulk_Update_UDT.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));
                        objRights_Bulk_Update_UDT.End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat("30/09/9999"));
                    }
                }
                objRights_Bulk_Update_UDT.Rights_Type = RightsType;
            }
            else if (ChangeFor == "E")
            {
                objRights_Bulk_Update_UDT.Is_Exclusive = IsExclusive;
            }
            else if (ChangeFor == "TL")
            {
                objRights_Bulk_Update_UDT.Is_Title_Language = IsTitleLanguage;
            }


            USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            objRights_Bulk_Update_UDT.Codes = SelectedCodes;
            lstRights_Bulk_Update_UDT.Add(objRights_Bulk_Update_UDT);
            List<USP_Bulk_Update> lstFinal = objUSP.USP_Bulk_Update(lstRights_Bulk_Update_UDT, objLoginUser.Users_Code).ToList();

            string RightsCodes = "";
            foreach (var item in lstFinal)
            {
                string msg = "";
                if (item.ErrorMSG == "")
                {
                    if (ChangeFor == "P")
                        item.ErrorMSG = objMessageKey.RightsShouldhaveatleastonePlatform;
                    else if (ChangeFor == "I" || ChangeFor == "T")
                    {
                        item.ErrorMSG = objMessageKey.RightsShouldhaveatleastoneTerritoryOrCountry;
                        if (ActionFor == "A")
                            item.ErrorMSG = objMessageKey.DuplicateCountriesarenotallowedacrossgroups;
                    }
                    else if (((ChangeFor == "SL" || ChangeFor == "SG" || ChangeFor == "DL" || ChangeFor == "DG" || ChangeFor == "TL") && ActionFor == "D") || IsTitleLanguage == "N")
                        item.ErrorMSG = objMessageKey.RightsShouldhaveatleastoneLanguage;
                    else if ((ChangeFor == "SG" || ChangeFor == "DG") && ActionFor == "A")
                        item.ErrorMSG = objMessageKey.DuplicateLanguagesarenotallowedacrossgroups;
                }

                else if (item.ErrorMSG == "HB")
                {
                    if (ChangeFor == "TL")
                        item.ErrorMSG = objMessageKey.HoldbackisalreadyaddedforTitleLanguage;
                    if (ChangeFor == "P")
                        item.ErrorMSG = objMessageKey.CannotremovePlatformasHoldbackisalreadyadded;
                    else if (ChangeFor == "I" || ChangeFor == "T")
                        item.ErrorMSG = objMessageKey.CannotremoveregionasHoldbackisalreadyadded;
                    else if (ChangeFor == "DL" || ChangeFor == "DG")
                        item.ErrorMSG = objMessageKey.CannotremovedubbingasHoldbackisalreadyadded;
                    else if (ChangeFor == "SL" || ChangeFor == "SG")
                        item.ErrorMSG = objMessageKey.CannotremovesubtitlingasHoldbackisalreadyadded;
                }
                else if (item.ErrorMSG == "RD")
                    item.ErrorMSG = objMessageKey.CannotChangeRightPeriodAsYearWiseRunDefinitionAlreadyExist;
                else if (item.ErrorMSG == "RDP")
                    item.ErrorMSG = objMessageKey.CannotDeletePlatformAsRunDefinitionAlreadyExist;
            }
            if (lstFinal.Count == 0 || lstFinal.Where(x => x.ErrorMSG == "" || x.ErrorMSG == null).ToList().Count == lstFinal.Count)
            {
                obj.Add("message", objMessageKey.RightsUpdatedSuccessfully);
            }
            else
            {
                obj.Add("message", "ERROR");
                lstDupRecordsNew = lstFinal;
            }
            #endregion
            return Json(obj);
        }
        public PartialViewResult BulkSaveError(string searchForTitles, string PageSize, int PageNo, string ErrorMsg = "")
        {
            List<string> arrErrorNames = new List<string>();
            MultiSelectList arr_Title_List = new MultiSelectList(lstDupRecordsNew.Select(s => new { Title_Name = s.Title_Name }).Distinct().ToList(), "Title_Name", "Title_Name", searchForTitles.Split(','));
            ViewBag.SearchTitles = arr_Title_List;
            if (ErrorMsg.TrimEnd() == string.Empty)
                foreach (var item in lstDupRecordsNew)
                {
                    if (item.ErrorMSG != null && item.ErrorMSG != "" && ErrorMsg.TrimEnd() == string.Empty)
                        ErrorMsg = item.ErrorMSG.Trim();
                }

            PageNo += 1;
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = PageSize;
            int Record_Count = 0;
            List<USP_Bulk_Update> lstDuplicates = Syn_Rights_List_Validation_Popup(lstDupRecordsNew, searchForTitles, PageSize, PageNo, out Record_Count, ErrorMsg);
            ViewBag.RecordCount = Record_Count;
            List<string> lst = lstDupRecordsNew.Select(s => s.ErrorMSG).Distinct().ToList();
            ViewBag.ErrorRecord = new SelectList(lstDupRecordsNew.Select(s => new { ErrorMSG = s.ErrorMSG }).Distinct().ToList(), "ErrorMSG", "ErrorMSG", ErrorMsg.Trim());
            return PartialView("~/Views/Syn_Deal/_Syn_Error_Bulk.cshtml", lstDuplicates);
        }
        public List<USP_Bulk_Update> Syn_Rights_List_Validation_Popup(List<USP_Bulk_Update> lstDupRecordsNew, string searchForTitles, string PageSize, int PageNo, out int Record_Count, string msg, string Is_Updated = "N")
        {
            if (PageSize == "" || PageSize == "0")
                PageSize = "10";

            int partialPageSize = Convert.ToInt32(PageSize);
            List<string> arrTitleNames;
            List<USP_Bulk_Update> lstDuplicates_Main;

            if (searchForTitles != "")
            {
                arrTitleNames = searchForTitles.Split(',').ToList();
                lstDuplicates_Main = lstDupRecordsNew.Where(x => arrTitleNames.Contains(x.Title_Name) && x.Is_Updated == Is_Updated && x.ErrorMSG == msg && x.ErrorMSG != null && x.ErrorMSG != "").ToList();
            }
            else
                lstDuplicates_Main = lstDupRecordsNew.Where(x => x.Is_Updated == Is_Updated && x.ErrorMSG == msg && x.ErrorMSG != null && x.ErrorMSG != "").ToList();

            Record_Count = lstDuplicates_Main.Count;
            return lstDuplicates_Main.Skip((PageNo - 1) * partialPageSize).Take(partialPageSize).ToList();
        }
        public PartialViewResult BindPlatformTreeView(string Action_For = "", string Right_Code = "")
        {
            string AllPlatform_Codes = "";
            if (Right_Code != "" && Right_Code != "")
            {
                USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
                AllPlatform_Codes = objUsp.USP_Syn_Bulk_Populate(Right_Code, "P", Action_For).FirstOrDefault().PlatformCodes;
            }
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            objPTV.PlatformCodes_Display = (AllPlatform_Codes == null || AllPlatform_Codes == "") ? "0" : AllPlatform_Codes;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("~/Views/Shared/_TV_Platform.cshtml");
        }
        public JsonResult Bind_JSON_ListBox(string str_Type, string Action_For = "", string Right_Code = "")
        {
           


            if ((Right_Code != "" && str_Type != "" && Right_Code != "") || str_Type == "S")
            {
                USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
                List<USP_Syn_Bulk_Populate_Result> lstSBP = objUsp.USP_Syn_Bulk_Populate(Right_Code, str_Type, Action_For).ToList();
                var arr = new MultiSelectList(lstSBP, "DisplayValue", "DisplayText").ToList();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            return Json("", JsonRequestBehavior.AllowGet);
        }
        #endregion

        private MultiSelectList BindCountry(string Is_Theatrical_Right, string Selected_Country_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindCountry_List(Is_Theatrical_Right, Selected_Country_Code);
        }
        private MultiSelectList BindTerritory(string Is_Theatrical_Right, string Selected_Territory_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTerritory_List(Is_Theatrical_Right, Selected_Territory_Code);
        }
        private MultiSelectList BindLanguage(string Selected_Language_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_List(Selected_Language_Code);
        }
        private MultiSelectList BindLanguage_Group(string Selected_Language_Group_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindLanguage_Group_List(Selected_Language_Group_Code);
        }
        private MultiSelectList BindMilestone_List(string Selected_Language_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindMilestone_List();
        }
        private MultiSelectList BindMilestone_Unit_List(int Milestone_Unit = 1)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindMilestone_Unit_List(Milestone_Unit);
        }
    }
}