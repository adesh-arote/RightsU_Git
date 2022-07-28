using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Collections;
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{
    public class Acq_Rights_ListController : BaseController
    {
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            //get { return new Deal_Schema(); }
            set
            {
                Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value;
            }
        }
        public Acq_Deal objAcq_Deal
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
                if (Session["ADS_Acq_Rights"] == null)
                    Session["ADS_Acq_Rights"] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Service)Session["ADS_Acq_Rights"];
            }
            set { Session["ADS_Acq_Rights"] = value; }
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
        public List<Acq_Deal_Rights_Error_Details> lstDupRecordsNew
        {
            get
            {
                if (Session["lstDupRecordsNew"] == null)
                    Session["lstDupRecordsNew"] = new List<Acq_Deal_Rights_Error_Details>();
                return (List<Acq_Deal_Rights_Error_Details>)Session["lstDupRecordsNew"];
            }
            set
            {
                Session["lstDupRecordsNew"] = value;
            }
        }
        public PartialViewResult Index()
        {
            Session["ACQ_DEAL_RIGHTS"] = null;
            Session["RIGHT_SERVICE"] = null;
            ClearSession();
            objDeal_Schema.Page_From = GlobalParams.Page_From_Rights;
            ViewBag.Right_Type = "G";
            if (objDeal_Schema.Rights_View == null)
                objDeal_Schema.Rights_View = "G";
            string Is_Acq_CoExclusive = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Acq_CoExclusive").Select(x => x.Parameter_Value).FirstOrDefault();
            if (Is_Acq_CoExclusive == "Y" && objDeal_Schema.Rights_Exclusive == null)
                objDeal_Schema.Rights_Exclusive = "B";

            ViewBag.Acq_Deal_Code = objDeal_Schema.Deal_Code;
            Platform_Service objPservice = new Platform_Service(objLoginEntity.ConnectionStringName);
            objAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            ViewBag.Remark = (objAcq_Deal.Rights_Remarks == null) ? "" : objAcq_Deal.Rights_Remarks;
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForBulkUpdate) + "~");
            ViewBag.ButtonVisibility = srchaddRights;

            ViewBag.TitleList = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().
                BindSearchList_Rights(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Condition, (objDeal_Schema.Rights_Titles ?? ""), "A");

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;

            int prevAcq_Deal = 0;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_VIEW && TempData["prevAcqDeal"] != null)
            {
                prevAcq_Deal = Convert.ToInt32(TempData["prevAcqDeal"]);
                TempData.Keep("prevAcqDeal");
            }
            ViewBag.prevAcq_Deal = prevAcq_Deal;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            Session["FileName"] = "";
            Session["FileName"] = "acq_Rights";

            return PartialView("~/Views/Acq_Deal/_Acq_Rights_List.cshtml");
        }
        public PartialViewResult BindRightsFilterData(string callFor = "")
        {
            Session["ACQ_DEAL_RIGHTS"] = null;
            Session["RIGHT_SERVICE"] = null;
            //ClearSession();

            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForBulkUpdate) + "~");
            ViewBag.ButtonVisibility = srchaddRights;
            Acq_Deal objAd = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            var titleList = from Adm in objAd.Acq_Deal_Movie
                            from adr in objAd.Acq_Deal_Rights
                            from adrt in adr.Acq_Deal_Rights_Title
                            where Adm.Acq_Deal_Code == adr.Acq_Deal_Code && adr.Acq_Deal_Rights_Code == adrt.Acq_Deal_Rights_Code && adrt.Title_Code == Adm.Title_Code
                            select new { Title_Code = Adm.Acq_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, Adm.Title.Title_Name, Adm.Episode_Starts_From, Adm.Episode_End_To) };
            ViewBag.TitleList = new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name");
            int?[] acqdealrightCode = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Select(x => (int?)x.Acq_Deal_Rights_Code).ToArray();

            ViewBag.RegionId = "ddlRegionn";
            string[] regioncode = new string[] { "" };
            if (objDeal_Schema.Rights_Region != null)
            {

                regioncode = objDeal_Schema.Rights_Region.Split(',');
            }

            string[] arrSelectedCountryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "I").Where(w => regioncode.Contains("C" + "" + w.Country_Code.ToString() + "")).Select(s => "C" + "" + s.Country_Code.ToString() + "").ToArray();
            string[] arrSelectedTerritoryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "G").Where(w => regioncode.Contains("T" + "" + w.Territory_Code.ToString() + "")).Select(s => "T" + "" + s.Territory_Code.ToString() + "").ToArray();
            int?[] countryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();
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
                regionname = Country_Terr_Name.TrimEnd(',').TrimStart(',').Split(',');

            if (regionname.Count() > 3)
                ViewBag.RegionName = " " + regionname.Count() + " Selected";
            else
                ViewBag.RegionName = Country_Terr_Name.TrimStart(',').TrimEnd(',');
            ViewBag.Region = lsts;

            //ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.Deal_Mode = objAcq_Deal.Is_Auto_Push == "Y" ? "V" : objDeal_Schema.Mode;

            ViewBag.RightsFlag = "AR";
            string Is_Acq_CoExclusive = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Acq_CoExclusive").Select(x => x.Parameter_Value).FirstOrDefault();
            if (Is_Acq_CoExclusive == "Y")
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

            ViewBag.FilterPageFrom = "AR";

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
                int?[] acqdealrightCode = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Select(x => (int?)x.Acq_Deal_Rights_Code).ToArray();
                int?[] countryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
                int?[] territoryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
            }
            else
            {
                string[] code = TitleCode.Split(',');

                string[] titlecode = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => code.Contains(x.Acq_Deal_Movie_Code.ToString())).Select(s => s.Title_Code.ToString()).ToArray();
                int?[] rightsCode = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Rights_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Acq_Deal_Rights_Code).ToArray();
                int?[] countryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
                int?[] territoryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
                string strPlatform = string.Join(",", new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Rights_Platform).Select(w => w.Platform_Code).ToArray());
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
            string strPlatform;
            string selectedplatform = "";
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string[] titlecode = TitleCode.Split(',');
            string[] pCode = platformcode.Split(',');
            int?[] rightsCode = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Rights_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Acq_Deal_Rights_Code).ToArray();

            if (TitleCode == "")
            {
                selectedplatform = string.Join(",", new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Rights_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                strPlatform = string.Join(",", new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Rights_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
                if (strPlatform == "")
                    strPlatform = "0";
                //selectedplatform = string.Join(",", new Acq_Deal_Rights_Service().SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Acq_Deal_Rights_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).ToArray());
                objPTV.PlatformCodes_Display = strPlatform;
                objPTV.PlatformCodes_Selected = selectedplatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                selectedplatform = string.Join(",", new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Acq_Deal_Rights_Code)).SelectMany(x => x.Acq_Deal_Rights_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                strPlatform = string.Join(",", new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Acq_Deal_Rights_Code)).SelectMany(s => s.Acq_Deal_Rights_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
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
        public JsonResult ButtonEvents(string MODE, int? RCode, int? PCode, int? TCode, int? Episode_From, int? Episode_To, string IsHB, string Is_Syn_Acq_Mapp = "")
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
            if (MODE == GlobalParams.DEAL_MODE_VIEW || MODE == GlobalParams.DEAL_MODE_APPROVE || MODE == GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
                tabName = GlobalParams.Page_From_Rights_Detail_View;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("TabName", tabName);
            return Json(obj);
        }
        private void ClearSession()
        {
            objAcq_Deal = null;
            objADS = null;
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
            List<USP_List_Rights_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Rights("AR", objDeal_Schema.Rights_View, objDeal_Schema.Deal_Code,
                objDeal_Schema.Rights_Titles, RegionCode, PlatformCode, objDeal_Schema.Rights_Exclusive, objPageNo, txtpageSize, objTotalRecord, "").ToList();

            ViewBag.RecordCount = Convert.ToInt32(objTotalRecord.Value);
            ViewBag.PageNo = Convert.ToInt32(objPageNo.Value);

            //ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.Deal_Mode = objAcq_Deal.Is_Auto_Push == "Y" ? "V" : objDeal_Schema.Mode;
            ViewBag.Page_View = objDeal_Schema.Rights_View;
            objDeal_Schema.Rights_Titles = Selected_Title_Code;
            objDeal_Schema.Rights_Exclusive = ExclusiveRight;

            objDeal_Schema.Rights_Platform = PlatformCode;
            objDeal_Schema.Rights_Exclusive = ExclusiveRight;
            objDeal_Schema.Rights_Region = RegionCode;

            int?[] acqdealrightCode = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == objDeal_Schema.Deal_Code).Select(x => (int?)x.Acq_Deal_Rights_Code).ToArray();
            int?[] countryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();
            string[] regioncode = RegionCode.Split(',');
            string[] arrSelectedCountryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "I").Where(w => regioncode.Contains(w.Country_Code.ToString())).Select(s => s.Country_Code.ToString()).ToArray();
            string[] arrSelectedTerritoryCode = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealrightCode.Contains(x.Acq_Deal_Rights_Code) && x.Territory_Type == "G").Where(w => regioncode.Contains(w.Territory_Code.ToString())).Select(s => s.Territory_Code.ToString()).ToArray();
            List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + "" }).ToList();
            if (arrSelectedCountryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Country" && arrSelectedCountryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + "" }).ToList());
            if (arrSelectedTerritoryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Territory" && arrSelectedTerritoryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            ViewBag.Region = lsts;
            return PartialView("~/Views/Acq_Deal/_List_Rights.cshtml", lst);
        }
        private string Validate_Right_For_Run_Def(int RCode, int TCode, int EP_From, int EP_To, int PCode, int DealCode)
        {
            objADS = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            objAcq_Deal = objADS.GetById(DealCode);
            Acq_Deal_Rights objR = objAcq_Deal.Acq_Deal_Rights.Where(w => w.Acq_Deal_Rights_Code == RCode).FirstOrDefault();
            if (objR != null)
            {
                int count = 0;
                EP_From = EP_From == 0 ? 1 : EP_From;
                EP_To = EP_To == 0 ? 1 : EP_To;
                List<string> lstPlatformCode = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_No_Of_Run == "Y").Where(w => (w.Platform_Code == PCode) || (PCode == 0)).Select(p => p.Platform_Code.ToString()).ToList();
                int platformcount = objR.Acq_Deal_Rights_Platform.Where(w => lstPlatformCode.Contains(w.Platform_Code.ToString()) && w.EntityState != State.Deleted).Count();
                if (platformcount > 0)
                {
                    // COMMENTED BGY AKSHAY TOP PERFORM NEW VALIDATION
                    /*if (TCode > 0 || PCode > 0)
                    {
                        List<int> lstTitlecode = (from objRun in objAcq_Deal.Acq_Deal_Run
                                                  from objRunTitle in objRun.Acq_Deal_Run_Title.Where(w => (w.Title_Code == TCode && w.Episode_From == EP_From && w.Episode_To == EP_To) || (TCode == 0))
                                                  where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code
                                                  select objRunTitle.Title_Code.Value).ToList();
                        count = objR.Acq_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                        if (count > 0)
                            return "run definition";
                    }
                    else
                    {
                        List<int> lstTitlecode = (from objRun in objAcq_Deal.Acq_Deal_Run
                                                  from objRunTitle in objRun.Acq_Deal_Run_Title
                                                  from objRightTitle in objR.Acq_Deal_Rights_Title
                                                  where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code && ((objRunTitle.Title_Code == objRightTitle.Title_Code && objRunTitle.Episode_From == objRightTitle.Episode_From && objRunTitle.Episode_To == objRightTitle.Episode_To))
                                                  select objRunTitle.Title_Code.Value).ToList();
                        count = objR.Acq_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                        if (count > 0)
                            return "run definition";
                    }*/


                    List<int> lstTitlecode = new List<int>();

                    if (TCode > 0 || PCode > 0)
                    {
                        lstTitlecode = (from objRun in objAcq_Deal.Acq_Deal_Run
                                        from objRunTitle in objRun.Acq_Deal_Run_Title.Where(w => (w.Title_Code == TCode && w.Episode_From == EP_From && w.Episode_To == EP_To) || (TCode == 0))
                                        where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code
                                        select objRunTitle.Title_Code.Value).ToList();
                        count = objR.Acq_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();

                    }
                    else
                    {
                        lstTitlecode = (from objRun in objAcq_Deal.Acq_Deal_Run
                                        from objRunTitle in objRun.Acq_Deal_Run_Title
                                        from objRightTitle in objR.Acq_Deal_Rights_Title
                                        where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code && ((objRunTitle.Title_Code == objRightTitle.Title_Code && objRunTitle.Episode_From == objRightTitle.Episode_From && objRunTitle.Episode_To == objRightTitle.Episode_To))
                                        select objRunTitle.Title_Code.Value).ToList();
                        count = objR.Acq_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                    }

                    /*  List<int> lstTitlecodeWithoutYearWise = (from objRun in objAcq_Deal.Acq_Deal_Run
                                                           from objRunTitle in objRun.Acq_Deal_Run_Title
                                                           where objRun.Acq_Deal_Code == objDeal_Schema.Deal_Code
                                                           select objRunTitle.Title_Code.Value).ToList();

                   count = objR.Acq_Deal_Rights_Title.Where(t => lstTitlecodeWithoutYearWise.Contains(t.Title_Code.Value)).Count();*/

                    var lstTitleCodeOfCurrentRight = objR.Acq_Deal_Rights_Title.Select(t => new { t.Title_Code, t.Episode_From, t.Episode_To }).ToList();
                    List<Current_Deal_Right1> lstDealRights = new List<Current_Deal_Right1>();
                    foreach (var item in lstTitleCodeOfCurrentRight)
                    {
                        Current_Deal_Right1 obj = new Current_Deal_Right1();
                        obj.EpsFrom = item.Episode_From;
                        obj.EpsTo = item.Episode_To;
                        obj.TitleCode = item.Title_Code;
                        lstDealRights.Add(obj);
                    }

                    bool IsCableExistInOtherRightWithSameTitle = false;
                    if (PCode > 0)
                    {
                        IsCableExistInOtherRightWithSameTitle = objAcq_Deal.Acq_Deal_Rights.Where(w => w.Acq_Deal_Rights_Code == objR.Acq_Deal_Rights_Code).
                            SelectMany(s => s.Acq_Deal_Rights_Platform).Any(w => w.Platform_Code != PCode && w.Platform.Is_No_Of_Run == "Y");
                    }
                    if (!IsCableExistInOtherRightWithSameTitle)
                    {
                        IsCableExistInOtherRightWithSameTitle = objAcq_Deal.Acq_Deal_Rights.Any(r =>
                             r.Acq_Deal_Rights_Code != objR.Acq_Deal_Rights_Code &&
                             r.Acq_Deal_Rights_Title.Any(t => lstDealRights.Where(l => l.TitleCode == t.Title_Code && l.EpsFrom == t.Episode_From && l.EpsTo == t.Episode_To).Count() > 0)
                             && r.Acq_Deal_Rights_Platform.Any(p => lstPlatformCode.Contains(p.Platform_Code.ToString()))
                             );
                    }
                    if (count > 0 && !IsCableExistInOtherRightWithSameTitle)
                        return "run definition";
                    //return "Please select at least 1 cable right as Run Definition is already added. To deselect cable rights, delete Run Definition first.";

                }
            }

            return "";
        }

        private string Validate_Right_For_Budget(int RCode, int TCode, int EP_From, int EP_To, int PCode)
        {
            Acq_Deal_Rights objR = objAcq_Deal.Acq_Deal_Rights.Where(w => w.Acq_Deal_Rights_Code == RCode).FirstOrDefault();
            if (objR != null)
            {
                int count = 0;
                EP_From = EP_From == 0 ? 1 : EP_From;
                EP_To = EP_To == 0 ? 1 : EP_To;
                List<string> lstPlatformCode = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_No_Of_Run == "Y").Where(w => (w.Platform_Code == PCode) || (PCode == 0)).Select(p => p.Platform_Code.ToString()).ToList();
                int platformcount = objR.Acq_Deal_Rights_Platform.Where(w => lstPlatformCode.Contains(w.Platform_Code.ToString()) && w.EntityState != State.Deleted).Count();
                if (platformcount > 0)
                {
                    List<int> lstTitlecode = (from objBudget in objAcq_Deal.Acq_Deal_Budget
                                              where objBudget.Acq_Deal_Code == objDeal_Schema.Deal_Code && ((objBudget.Title_Code == TCode && objBudget.Episode_From == EP_From && objBudget.Episode_To == EP_To) || (TCode == 0))
                                              select objBudget.Title_Code.Value).ToList();
                    count = objR.Acq_Deal_Rights_Title.Where(t => lstTitlecode.Contains(t.Title_Code.Value)).Count();
                    if (count > 0)
                        return "budget";
                }
            }
            return "";
        }

        private string Validate_Right_For_Ancillary(int RCode, int TCode, int EP_From, int EP_To, int PCode)
        {
            Acq_Deal_Rights objR = objAcq_Deal.Acq_Deal_Rights.Where(w => w.Acq_Deal_Rights_Code == RCode).FirstOrDefault();
            if (objR != null)
            {

                if (objR.Acq_Deal.Deal_Type_Code == 11)
                {
                    string lstTitleCode = "";
                    foreach (var item in objR.Acq_Deal_Rights_Title)
                    {
                        lstTitleCode = lstTitleCode + objR.Acq_Deal.Acq_Deal_Movie.Where(x => x.Title_Code == item.Title_Code
                                                                && x.Episode_Starts_From == item.Episode_From
                                                                && x.Episode_End_To == item.Episode_To)
                                                                .Select(x => x.Acq_Deal_Movie_Code.ToString()).FirstOrDefault() + ",";
                    }

                    lstTitleCode = lstTitleCode.TrimEnd(',');
                    string[] lstTit = lstTitleCode.Split(',');
                    var PCforAncillaryTitle = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_PlatformCodes_For_Ancillary(lstTitleCode, "", "PL", objDeal_Schema.Deal_Code, "D", RCode).FirstOrDefault();

                    return PCforAncillaryTitle.Count() > 0 ? "ancillary" : "";
                }
                else
                {
                    string lstTitleCode = string.Join(",", objR.Acq_Deal_Rights_Title.Select(x => x.Title_Code.ToString()).ToArray());
                    string[] lstTit = objR.Acq_Deal_Rights_Title.Select(x => x.Title_Code.ToString()).ToArray();

                    //GET THE LIST OF PLATFORM CODE WHICH IS SELECTED AS PER TITLE
                    var PCforAncillaryTitle = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_PlatformCodes_For_Ancillary(lstTitleCode, "", "PL", objDeal_Schema.Deal_Code, "D", RCode).FirstOrDefault();

                    return PCforAncillaryTitle.Count() > 0 ? "ancillary" : "";
                }

            }
            return "";
        }
        public string DeleteRight(string RightCode, string DealCode, string TitleCode, string PlatformCode, string EpisodeFrom, string EpisodeTo, string ViewType)
        {
            DPlatformCode = "D";
            string Result = "";
            try
            {
                int Title_Code = Convert.ToInt32(TitleCode);
                int Right_Code = Convert.ToInt32(RightCode);
                int Deal_Code = Convert.ToInt32(DealCode);
                int Episode_From = Convert.ToInt32(EpisodeFrom);
                int Episode_To = Convert.ToInt32(EpisodeTo);
                int Platform_Code = 0;
                string Validate_Msg = "";
                if (ViewType == "D")
                    Platform_Code = Convert.ToInt32(PlatformCode);

                objAcq_Deal = objADS.GetById(Deal_Code);
                Validate_Msg = Validate_Right_For_Run_Def(Right_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Deal_Code);

                if (Validate_Msg == string.Empty)
                    Validate_Msg = Validate_Right_For_Budget(Right_Code, Title_Code, Episode_From, Episode_To, Platform_Code);
                else
                    Validate_Msg = Validate_Msg + "," + Validate_Right_For_Budget(Right_Code, Title_Code, Episode_From, Episode_To, Platform_Code);

                string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
                if (isAdvAncillary == "Y" && Validate_Msg == string.Empty)
                {
                    Validate_Msg = Validate_Right_For_Ancillary(Right_Code, Title_Code, Episode_From, Episode_To, Platform_Code);
                }
                if (Validate_Msg == "")
                {

                    bool IsSameAsGroup = false;
                    if (Title_Code > 0 || Platform_Code > 0)
                    {
                        Acq_Deal objDeal = new Acq_Deal();
                        Acq_Deal_Service objADSNew = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                        objDeal = objADSNew.GetById(Deal_Code);

                        Acq_Deal_Rights objExistingRight = objDeal.Acq_Deal_Rights.Where(t => t.Acq_Deal_Rights_Code == Right_Code).FirstOrDefault();
                        if (objExistingRight.Acq_Deal_Rights_Title.Count == 1 && Title_Code > 0 && objExistingRight.Acq_Deal_Rights_Platform.Count == 1 && Platform_Code > 0)
                            IsSameAsGroup = true;
                        else if (objExistingRight.Acq_Deal_Rights_Title.Count == 1 && Title_Code > 0 && Platform_Code == 0)
                            IsSameAsGroup = true;
                        else
                        {
                            bool isMovieDelete = true;
                            if (objExistingRight.Acq_Deal_Rights_Title.Count > 1)
                                objExistingRight.Acq_Deal_Rights_Title.Where(t => t.Title_Code == Title_Code && t.Episode_From == Episode_From && t.Episode_To == Episode_To).ToList<Acq_Deal_Rights_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                            else
                                isMovieDelete = false;

                            if (Platform_Code > 0)
                            {
                                if (!isMovieDelete)
                                    objExistingRight.Acq_Deal_Rights_Platform.ToList<Acq_Deal_Rights_Platform>().ForEach(t => { if (t.Platform_Code == Platform_Code) t.EntityState = State.Deleted; });
                                else if (objExistingRight.Acq_Deal_Rights_Platform.Count > 1)
                                {
                                    Acq_RightsController objRights = new Acq_RightsController();
                                    Acq_Deal_Rights objSecondRight = objRights.SetNewAcqDealRight(objExistingRight, Title_Code, Episode_From, Episode_To, Platform_Code);
                                    objDeal.Acq_Deal_Rights.Add(objSecondRight);
                                }
                            }
                            objExistingRight.EntityState = State.Modified;
                            objDeal.EntityState = State.Modified;
                            objDeal.SaveGeneralOnly = false;
                            dynamic resultSet;
                            objADSNew.Save(objDeal, out resultSet);
                            //CreateMessageAlert("Rights Deleted Successfully");
                            int[] arr_Syn_Rights_Code = (new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Deal_Rights_Code == Right_Code).Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
                            if (arr_Syn_Rights_Code.Count() > 0)
                            {
                                List<Syn_Deal_Rights> obj_lst_Syn_Rights = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(i => arr_Syn_Rights_Code.Contains(i.Syn_Deal_Rights_Code)).Select(i => i).ToList();
                                if (obj_lst_Syn_Rights.Count() > 0)
                                {
                                    string str_Affected_Acq_Rights_Code = string.Join(",", objDeal.Acq_Deal_Rights.Where(i => i.EntityState == State.Added || i.EntityState == State.Modified).Select(s => s.Acq_Deal_Rights_Code).Distinct().ToArray());
                                    string str_Syn_Rights_Code = string.Join(",", obj_lst_Syn_Rights.Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
                                    new USP_Service(objLoginEntity.ConnectionStringName).USP_Update_Syn_Acq_Mapping(objDeal.Acq_Deal_Code, str_Affected_Acq_Rights_Code, str_Syn_Rights_Code);
                                }
                            }
                        }
                    }
                    else
                        IsSameAsGroup = true;

                    if (IsSameAsGroup)
                    {
                        Acq_Deal_Rights_Service objADRS = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                        Acq_Deal_Rights objRights = objADRS.GetById(Right_Code);
                        objRights.EntityState = State.Deleted;
                        dynamic resultSet;
                        bool isValid = objADRS.Delete(objRights, out resultSet);
                        if (isValid)
                            Result = "Rights Deleted Successfully";
                    }
                    if (Result == "")
                        Result = "Rights Deleted Successfully";

                    Acq_Deal_Service objService = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                    objAcq_Deal = objService.GetById(objDeal_Schema.Deal_Code);

                    string DealCompleteFlag = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Deal_Complete_Flag").Select(x => x.Parameter_Value).FirstOrDefault();

                    List<USP_List_Acq_Linear_Title_Status_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName)
                                                                      .USP_List_Acq_Linear_Title_Status(objDeal_Schema.Deal_Code).ToList();

                    int RunPending = DealCompleteFlag.Replace(" ", "") == "R,R" || DealCompleteFlag.Replace(" ", "") == "R,R,C" ? lst.Where(x => x.Title_Added == "Yes~").Count() : 0;
                    int RightsPending = lst.Where(x => x.Title_Added == "No").Count();

                    if (RunPending > 0 && RightsPending > 0)
                    {
                        objAcq_Deal.Deal_Workflow_Status = "RR";
                    }
                    else if (RunPending > 0 && RightsPending == 0)
                    {
                        objAcq_Deal.Deal_Workflow_Status = "RP";
                    }
                    else
                    {
                        objAcq_Deal.Deal_Workflow_Status = "N";
                    }

                    objAcq_Deal.EntityState = State.Modified;
                    dynamic resultSet1;
                    objService.Save(objAcq_Deal, out resultSet1);

                    objDeal_Schema.List_Rights.Clear();
                }
                else
                {
                    Validate_Msg = "You can not delete this right as this right has " + Validate_Msg + " associated with it.";
                    return Validate_Msg;
                }
            }
            catch (Exception ex)
            {
            }

            return Result;
        }
        public JsonResult ChangeTab(string hdnTabName, string txtAcqRemarks = "", string hdnReopenMode = "", string hdnTabCurrent = "")
        {
            ClearSession();
            string msg = "", mode = "", status = "S";
            //  string mode = objDeal_Schema.Mode;
            if (hdnReopenMode == "RO")
            {
                mode = GlobalParams.DEAL_MODE_EDIT;
                status = "SA";
            }
            else
                mode = objDeal_Schema.Mode;


            if (mode == GlobalParams.DEAL_MODE_REOPEN)
            {
                objDeal_Schema.Deal_Workflow_Flag = objAcq_Deal.Deal_Workflow_Status = Convert.ToString(mode).Trim();
            }
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_APPROVE && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && hdnTabCurrent == "" && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
            {
                Acq_Deal objAcqDeal = objADS.GetById(objDeal_Schema.Deal_Code);
                objAcqDeal.Rights_Remarks = txtAcqRemarks.Replace("\r\n", "\n");
                objAcqDeal.EntityState = State.Modified;
                dynamic resultSet;
                objADS.Save(objAcqDeal, out resultSet);
            }
            if (hdnTabName == "")
            {
                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", objDeal_Schema.PageNo.ToString());
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;

                string Mode = objDeal_Schema.Mode;
                TempData["RedirectAcqDeal"] = objAcq_Deal;
                msg = "Deal saved successfully";
                if (Mode == GlobalParams.DEAL_MODE_EDIT)
                    msg = "Deal updated successfully";

                //  return RedirectToAction("Index", "Acq_List");
            }



            string redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(hdnTabName, objDeal_Schema.PageNo, null, objDeal_Schema.Deal_Type_Code);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Success_Message", msg);
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);

            //  return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }
        public ActionResult Cancel()
        {
            ClearSession();
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            objDeal_Schema = null;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
         
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Acq_List");
            }
            //return RedirectToAction("Index", "Acq_List", new { Page_No = pageNo, ReleaseRecord = "Y" });
        }
        public PartialViewResult BulkUpdate()
        {
            //ViewBag.ChangeDropdown = BindChangeDropdown();
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
            return PartialView("~/Views/Acq_Deal/_Bulk_Update.cshtml");
        }
        public PartialViewResult BindBulkUpdateList(string Selected_Title_Code = "", string RegionCode = "", string PlatformCode = "", string ExclusiveRight = "B", int txtpageSize = 100, int page_index = 0, string IsCallFromPaging = "N", string view_Type = "G")
        {

            //if (objDeal_Schema.Deal_Type_Code == 11)
            //{
            //    view_Type = "G";
            //}

            ViewBag.Mode = "LIST";
            //int PageNo = page_index <= 0 ? 1 : page_index + 1;

            int totalRcord = 0;
            ObjectParameter objPageNo = new ObjectParameter("PageNo", page_index);
            ObjectParameter objTotalRecord = new ObjectParameter("TotalRecord", totalRcord);
            List<USP_List_Rights_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Rights("AR", view_Type, objDeal_Schema.Deal_Code,
                Selected_Title_Code, RegionCode, PlatformCode, ExclusiveRight, objPageNo, txtpageSize, objTotalRecord, "").ToList();

            ViewBag.RecordCount = Convert.ToInt32(objTotalRecord.Value);
            ViewBag.PageNo = Convert.ToInt32(objPageNo.Value);

            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            return PartialView("~/Views/Acq_Deal/_Bulk_Update_List.cshtml", lst);
        }
        private string FillTitleCodes()
        {
            List<USP_Get_Acq_PreReq_Result> lst_USP_Get_Acq_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            lst_USP_Get_Acq_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Rights_PreReq(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, "TIT", "", "", "", "")
                                            .ToList();
            string titlecodes = "";
            foreach (var a in lst_USP_Get_Acq_PreReq_Result)
            {
                if (!titlecodes.Contains(Convert.ToString(a.Display_Value)))
                    titlecodes += ',' + Convert.ToString(a.Display_Value);
            }
            //string objP = new Syn_Deal_Rights_Service().SearchFor(t => t.Syn_Deal_Rights_Code == objDeal_Schema.Deal_Code).Select(t => t.Platform_Codes).FirstOrDefault();
            return titlecodes;
        }
        public JsonResult BindChangeDropdown()
        {
            List<SelectListItem> lst = new SelectList(new[]
                {
                    new { Value = "0", Text = "Please Select" },
                    new { Value = "RP", Text = "Rights Period" },
                    new { Value = "P", Text = "Platforms"},
                    new { Value = "I", Text = "Country"  },
                    new { Value = "T", Text = "Territory" },
                    new { Value = "SL", Text = "Sub-titling language" },
                    new { Value = "SG", Text = "Sub-titling Language group" },
                    new { Value = "DL", Text = "Dubbing language" },
                    new { Value = "DG", Text = "Dubbing Language group" },
                    new { Value = "E", Text = "Exclusive" },
                    new { Value = "S", Text = "Sub-licensing" },
                    new { Value = "TL", Text = "Title Language" }
                },
                 "Value", "Text", 0
             ).ToList();
            var arr = lst;
            return Json(arr, JsonRequestBehavior.AllowGet);
        }
        public JsonResult ChkBxEnableOrDisable(string Right_Code = "0", string Change_For = "")
        {
            Acq_Deal_Rights_Service objADRS = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Rights objRts = objADRS.GetById(Convert.ToInt32(Right_Code));
            string returnStr = "true";
            string message = "";
            if (Change_For == "I" || Change_For == "T")
            {
                string Type = objRts.Acq_Deal_Rights_Territory.Select(i => i.Territory_Type).FirstOrDefault();
                if (Type != "I" && Change_For == "I")
                {
                    returnStr = "false";
                    message = "selected Change Type should be Territory";
                }
                else if (Type != "G" && Change_For == "T")
                {
                    returnStr = "false";
                    message = "selected Change Type should be Country";
                }
                else
                    returnStr = "true";
            }
            if (Change_For == "SL" || Change_For == "SG")
            {
                string Type = objRts.Acq_Deal_Rights_Subtitling.Select(i => i.Language_Type).FirstOrDefault();
                if (Type != null)
                {
                    if (Type != "L" && Change_For == "SL")
                    {
                        returnStr = "false";
                        message = "selected Change Type should be Subtitling Language Group";
                    }
                    else if (Type != "G" && Change_For == "SG")
                    {
                        returnStr = "false";
                        message = "selected Change Type should be Subtitling Language";
                    }
                    else
                        returnStr = "true";
                }
                else
                    returnStr = "true";
            }
            if (Change_For == "DL" || Change_For == "DG")
            {
                string Type = objRts.Acq_Deal_Rights_Dubbing.Select(i => i.Language_Type).FirstOrDefault();
                if (Type != null)
                {
                    if (Type != "L" && Change_For == "DL")
                    {
                        returnStr = "false";
                        message = "selected Change Type should be Dubbing Language Group";
                    }
                    else if (Type != "G" && Change_For == "DG")
                    {
                        returnStr = "false";
                        message = "selected Change Type should be Dubbing Language";
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
        private string Get_PlatForm_Codes(string titles)
        {
            // Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
            //platforms = string.Join(",", platforms.Split(',').Where(p => p != "0"));
            string AllPlatform_Codes = "";
            List<USP_GET_DATA_FOR_APPROVED_TITLES_Result> objList = new List<USP_GET_DATA_FOR_APPROVED_TITLES_Result>();
            if (titles != "" && titles != "0")
                objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_DATA_FOR_APPROVED_TITLES(titles, "", "PL", "", "", "", objDeal_Schema.Deal_Code).ToList();

            AllPlatform_Codes = objList.Select(i => i.RequiredCodes).FirstOrDefault();
            return AllPlatform_Codes;
        }
        public JsonResult BulkSave(string SelectedRightCodes, string ChangeFor, string SelectedCodes = ",0", string SelectedStartDate = "", string RightsType = "",
            string IsTentative = "", string ActionFor = "", string SelectedEndDate = "", string IsExclusive = "", string IsSubLicensing = "", string IsTitleLanguage = "", string Term_MM = "",
            string Term_YY = "", string Term_DD = "", string Milestone_Type_Code = "", string Milestone_No_Of_Unit = "", string Milestone_Unit_Type = ""
            , string SelectedTitleCodes = "", string SelectedTitleNames = "", string Is_Syn_Acq_Mapp = "", string Eps_Frm_To = "", string pageView = "")
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
                else if (RightsType == "M")
                {
                    if (!string.IsNullOrEmpty(SelectedStartDate))
                        objRights_Bulk_Update.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));

                    if (!string.IsNullOrEmpty(SelectedEndDate))
                        objRights_Bulk_Update.End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedEndDate));
                    objRights_Bulk_Update.Milestone_No_Of_Unit = Milestone_No_Of_Unit;
                    objRights_Bulk_Update.Milestone_Type_Code = Milestone_Type_Code;
                    objRights_Bulk_Update.Milestone_Unit_Type = Milestone_Unit_Type;
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
                        objRights_Bulk_Update.Rights_Type = "U";
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
            objRights_Bulk_Update.Is_Syn_Acq_Mapp = '~' + Is_Syn_Acq_Mapp;
            objRights_Bulk_Update.SelectedTitleCodes = SelectedTitleCodes;
            objRights_Bulk_Update.SelectedTitleNames = SelectedTitleNames;

            //new Rights_Bulk_Update_Service(objLoginEntity.ConnectionStringName).Save(objRights_Bulk_Update, out dynamic resultSet);

            #endregion

            #region Adesh Sir
            string[] arrSelectedRightCodes = SelectedRightCodes.Replace(" ", "").Split(',').ToArray();
            string[] arrSelectedTitleNames = SelectedTitleNames.Split(',').ToArray();
            string[] arrSelectedTitleCodes = SelectedTitleCodes.Replace(" ", "").Split(',').ToArray();
            string[] arrIs_Syn_Acq_Mapp = Is_Syn_Acq_Mapp.Replace(" ", "").Split(',').ToArray();
            string[] arrEps_Frm_To = IsProgram == "Y" ? Eps_Frm_To.Replace(" ", "").Split(',').ToArray() : null;

            if (pageView == "S")//&& objDeal_Schema.Deal_Type_Code != 11
            {

                List<Merge_Rights_Title_Map> lstMerge_Rights_Title_Map = new List<Merge_Rights_Title_Map>();
                List<Rights_Title_Code> lstRights_Title_Code = new List<Rights_Title_Code>();
                Acq_Deal_Rights_Title_Service objAcq_Deal_Rights_Title_Service = new Acq_Deal_Rights_Title_Service(objLoginEntity.ConnectionStringName);

                for (int i = 0; i < arrSelectedRightCodes.Count(); i++)
                {
                    Merge_Rights_Title_Map objMRTM = new Merge_Rights_Title_Map();
                    objMRTM.RightsCode = arrSelectedRightCodes.ElementAt(i);
                    objMRTM.TitleName = arrSelectedTitleNames.ElementAt(i);
                    objMRTM.IsSynAcqMap = arrIs_Syn_Acq_Mapp.ElementAt(i);
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
                        int Acq_Deal_Rights_Code = Convert.ToInt32(item.RightsCode);
                        int Title_Code = Convert.ToInt32(item.TitleCode);
                        var objADRNew = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Rights_Code == Acq_Deal_Rights_Code).FirstOrDefault();

                        if (objADRNew.Acq_Deal_Rights_Title.Count() > 1 &&
                            objADRNew.Acq_Deal_Rights_Title.Count() != lstMerge_Rights_Title_Map.Where(x => x.RightsCode == Acq_Deal_Rights_Code.ToString()).Count())
                        {
                            var templst = lstRights_Title_Code.Where(x => x.RightsCode == Acq_Deal_Rights_Code).ToList();
                            Acq_Deal_Rights_Title objADRTitle = new Acq_Deal_Rights_Title();

                            if (IsProgram == "Y")
                            {
                                objADRTitle = objADRNew.Acq_Deal_Rights_Title.Where(x => x.Acq_Deal_Rights_Code == Acq_Deal_Rights_Code && x.Title_Code == Title_Code && x.Episode_From == Convert.ToInt32(item.Esp_From_To.Split('~')[0])
                                 && x.Episode_To == Convert.ToInt32(item.Esp_From_To.Split('~')[1])).FirstOrDefault();
                            }

                            if (templst.Count() == 0)
                            {
                                //change as per program and movie
                                var NewAcq_Deal_Rights_Code = new USP_Service(objLoginEntity.ConnectionStringName)
                                    .USP_Acq_Deal_Right_Clone(objAcq_Deal.Acq_Deal_Code, Acq_Deal_Rights_Code, objADRTitle.Acq_Deal_Rights_Title_Code, Title_Code, IsProgram);

                                item.RightsCode = NewAcq_Deal_Rights_Code.ElementAt(0).ToString();

                                if (item.IsSynAcqMap == "Y")
                                {
                                    int[] arr_Syn_Rights_Code =
                                         new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName)
                                        .SearchFor(i => i.Deal_Rights_Code == Acq_Deal_Rights_Code)
                                        .Select(i => i.Syn_Deal_Rights_Code)
                                        .Distinct()
                                        .ToArray();

                                    var obj_lst_Syn_Rights =
                                        new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName)
                                        .SearchFor(i => arr_Syn_Rights_Code.Contains(i.Syn_Deal_Rights_Code))
                                        .Select(i => i).ToList();

                                    if (obj_lst_Syn_Rights.Count() > 0)
                                    {
                                        string str_Affected_Acq_Rights_Code = item.RightsCode.ToString() + "," + Acq_Deal_Rights_Code.ToString();
                                        string str_Syn_Rights_Code = string.Join(",", obj_lst_Syn_Rights.Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
                                        new USP_Service(objLoginEntity.ConnectionStringName).USP_Update_Syn_Acq_Mapping(objAcq_Deal.Acq_Deal_Code, str_Affected_Acq_Rights_Code, str_Syn_Rights_Code);
                                    }
                                }

                                //this is used to add same title in the diffrent rights code
                                Rights_Title_Code objRights_Title_Code = new Rights_Title_Code();
                                objRights_Title_Code.New_RightsCode = Convert.ToInt32(item.RightsCode);
                                objRights_Title_Code.RightsCode = Acq_Deal_Rights_Code;
                                objRights_Title_Code.TitleCode = Title_Code;
                                lstRights_Title_Code.Add(objRights_Title_Code);
                            }
                            else
                            {
                                Acq_Deal_Rights_Title objADRT = new Acq_Deal_Rights_Title();
                                if (IsProgram == "Y")
                                    objADRT = objAcq_Deal_Rights_Title_Service.SearchFor(x => x.Acq_Deal_Rights_Title_Code == objADRTitle.Acq_Deal_Rights_Title_Code && x.Title_Code == Title_Code).FirstOrDefault();
                                else
                                    objADRT = objAcq_Deal_Rights_Title_Service.SearchFor(x => x.Acq_Deal_Rights_Code == Acq_Deal_Rights_Code && x.Title_Code == Title_Code).FirstOrDefault();
                                objADRT.EntityState = State.Deleted;
                                dynamic resultSet1;
                                objAcq_Deal_Rights_Title_Service.Delete(objADRT, out resultSet1);

                                Acq_Deal_Rights_Title objAcq_Deal_Rights_Title = new Acq_Deal_Rights_Title();

                                objAcq_Deal_Rights_Title.Episode_From = IsProgram == "Y" ? objADRT.Episode_From : 1;
                                objAcq_Deal_Rights_Title.Episode_To = IsProgram == "Y" ? objADRT.Episode_To : 1;
                                objAcq_Deal_Rights_Title.Title_Code = Title_Code;
                                objAcq_Deal_Rights_Title.EntityState = State.Added;
                                objAcq_Deal_Rights_Title.Acq_Deal_Rights_Code = templst.ElementAt(0).New_RightsCode;
                                dynamic resultSet2;
                                objAcq_Deal_Rights_Title_Service.Save(objAcq_Deal_Rights_Title, out resultSet2);

                                item.RightsCode = templst.ElementAt(0).New_RightsCode.ToString();

                                if (item.IsSynAcqMap == "Y")
                                {
                                    int[] arr_SRCode =
                                         new Syn_Acq_Mapping_Service(objLoginEntity.ConnectionStringName)
                                        .SearchFor(i => i.Deal_Rights_Code == Acq_Deal_Rights_Code)
                                        .Select(i => i.Syn_Deal_Rights_Code)
                                        .Distinct()
                                        .ToArray();

                                    var obj_lst_R =
                                        new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName)
                                        .SearchFor(i => arr_SRCode.Contains(i.Syn_Deal_Rights_Code))
                                        .Select(i => i).ToList();

                                    if (obj_lst_R.Count() > 0)
                                    {
                                        string str_Affected_Acq_Rights_Code = item.RightsCode.ToString() + "," + Acq_Deal_Rights_Code.ToString();
                                        string str_Syn_Rights_Code = string.Join(",", obj_lst_R.Select(i => i.Syn_Deal_Rights_Code).Distinct().ToArray());
                                        new USP_Service(objLoginEntity.ConnectionStringName).USP_Update_Syn_Acq_Mapping(objAcq_Deal.Acq_Deal_Code, str_Affected_Acq_Rights_Code, str_Syn_Rights_Code);
                                    }
                                }
                            }
                        }
                    }
                }

                objRights_Bulk_Update.Right_Codes = String.Join(",", lstMerge_Rights_Title_Map.Select(x => x.RightsCode));
            }
            dynamic resultSet;
            new Rights_Bulk_Update_Service(objLoginEntity.ConnectionStringName).Save(objRights_Bulk_Update, out resultSet);
            #endregion

            Rights_Bulk_Update_Service objRBUSer = new Rights_Bulk_Update_Service(objLoginEntity.ConnectionStringName);
            Deal_Rights_Process_Service objService = new Deal_Rights_Process_Service(objLoginEntity.ConnectionStringName);

            Rights_Bulk_Update RBU = objRBUSer.SearchFor(x => true).OrderByDescending(x => x.Rights_Bulk_Update_Code).FirstOrDefault();
            int Count = 0;
            foreach (var item in objRights_Bulk_Update.Right_Codes.Split(',').ToList())
            {
                if (item != "")
                {
                    Deal_Rights_Process objDRP = new Deal_Rights_Process();
                    objDRP.Deal_Code = objDeal_Schema.Deal_Code;
                    objDRP.Module_Code = 30;
                    objDRP.Title_Code = Convert.ToInt32(objRights_Bulk_Update.SelectedTitleCodes.Split(',').ElementAt(Count));
                    objDRP.Deal_Rights_Code = Convert.ToInt32(item);
                    objDRP.Record_Status = "P";
                    objDRP.User_Code = objLoginUser.Users_Code;
                    objDRP.Inserted_On = System.DateTime.Now;
                    objDRP.EntityState = State.Added;
                    objDRP.Rights_Bulk_Update_Code = RBU.Rights_Bulk_Update_Code;
                    dynamic resultSet1;
                    objService.Save(objDRP, out resultSet1);

                    Acq_Deal_Rights_Service objADRSer = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                    Acq_Deal_Rights objADR = objADRSer.GetById(Convert.ToInt32(item));
                    objADR.Right_Status = "P";
                    objADR.EntityState = State.Modified;
                    dynamic resultSet2;
                    objADRSer.Update(objADR, out resultSet2);

                }
                Count++;
            }


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
                else if (RightsType == "M")
                {
                    if (!string.IsNullOrEmpty(SelectedStartDate))
                        objRights_Bulk_Update_UDT.Start_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedStartDate));

                    if (!string.IsNullOrEmpty(SelectedEndDate))
                        objRights_Bulk_Update_UDT.End_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(SelectedEndDate));
                    objRights_Bulk_Update_UDT.Milestone_No_Of_Unit = Milestone_No_Of_Unit;
                    objRights_Bulk_Update_UDT.Milestone_Type_Code = Milestone_Type_Code;
                    objRights_Bulk_Update_UDT.Milestone_Unit_Type = Milestone_Unit_Type;
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
                        objRights_Bulk_Update_UDT.Rights_Type = "U";
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

            //USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            //objRights_Bulk_Update_UDT.Codes = SelectedCodes;
            //lstRights_Bulk_Update_UDT.Add(objRights_Bulk_Update_UDT);
            //List<USP_Acq_Bulk_Update> lstFinal = objUSP.USP_Acq_Bulk_Update(lstRights_Bulk_Update_UDT, objLoginUser.Users_Code).ToList();
            #endregion

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("message", "Rights Updated Successfully");
            return Json(obj);

        }
        public JsonResult RightReprocess(int rightCode = 0)
        {
            Acq_Deal_Rights_Service objADRSer = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
            Acq_Deal_Rights objADR = objADRSer.GetById(Convert.ToInt32(rightCode));

            Rights_Bulk_Update_Service objRBUSer = new Rights_Bulk_Update_Service(objLoginEntity.ConnectionStringName);
            Deal_Rights_Process_Service objDRPSer = new Deal_Rights_Process_Service(objLoginEntity.ConnectionStringName);

            var Rights_Bulk_Update_Code = objDRPSer.SearchFor(x => x.Deal_Code == objAcq_Deal.Acq_Deal_Code && x.Deal_Rights_Code == rightCode && x.Record_Status == "E")
                             .OrderByDescending(x => x.Deal_Rights_Process_Code).Select(x => x.Rights_Bulk_Update_Code).FirstOrDefault();

            //List<Deal_Rights_Process> lstDRP = objDRPSer.SearchFor(x => x.Rights_Bulk_Update_Code == Convert.ToInt32(Rights_Bulk_Update_Code)).ToList();
            if (Rights_Bulk_Update_Code == null)
            {
                Deal_Rights_Process objDRP = objDRPSer.SearchFor(x => x.Deal_Code == objAcq_Deal.Acq_Deal_Code && x.Deal_Rights_Code == rightCode && x.Record_Status == "E")
                     .OrderByDescending(x => x.Deal_Rights_Process_Code).FirstOrDefault();
                objDRP.EntityState = State.Modified;
                objDRP.Record_Status = "P";
                dynamic resultSet;
                objDRPSer.Update(objDRP, out resultSet);
            }
            else
            {
                List<Deal_Rights_Process> lstDRP = objDRPSer.SearchFor(x => x.Rights_Bulk_Update_Code == Rights_Bulk_Update_Code).ToList();
                foreach (Deal_Rights_Process item in lstDRP)
                {
                    item.EntityState = State.Modified;
                    item.Record_Status = "P";
                    dynamic resultSet;
                    objDRPSer.Update(item, out resultSet);
                }

                Rights_Bulk_Update objRBU = objRBUSer.SearchFor(x => x.Rights_Bulk_Update_Code == Rights_Bulk_Update_Code).FirstOrDefault();
                if (objRBU.Action_For.Replace(" ", "") == "D" && objRBU.Change_For.Replace(" ", "") == "P")
                {
                    int ADRError_Count = new Acq_Deal_Rights_Error_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Rights_Code == rightCode).Where(x => x.ErrorMSG == "Rights Should have atleast one Platform").ToList().Count();
                    if (ADRError_Count > 0)
                    {
                        objRBU.Action_For = "A";
                        objRBU.Codes = String.Join(",", objADR.Acq_Deal_Rights_Platform.Select(x => x.Platform_Code).ToList());
                    }
                }

                objRBU.EntityState = State.Modified;
                objRBU.Is_Processed = "N";
                dynamic resultSet1;
                objRBUSer.Update(objRBU, out resultSet1);
            }


            objADR.Right_Status = "P";
            objADR.EntityState = State.Modified;
            dynamic resultSet2;
            objADRSer.Update(objADR, out resultSet2);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("message", "Rights Reprocessed Successfully");
            return Json(obj);
        }
        public List<Acq_Deal_Rights_Error_Details> Acq_Rights_List_Validation_Popup(List<Acq_Deal_Rights_Error_Details> lstDupRecordsNew, string searchForTitles, string PageSize, int PageNo, out int Record_Count, string msg, int RightCode = 0, string Is_Updated = "N")
        {
            if (PageSize == "" || PageSize == "0")
                PageSize = "10";

            int partialPageSize = Convert.ToInt32(PageSize);
            List<string> arrTitleNames;
            List<Acq_Deal_Rights_Error_Details> lstDuplicates_Main;

            if (searchForTitles != "")
            {
                arrTitleNames = searchForTitles.Split(',').ToList();
                lstDuplicates_Main = lstDupRecordsNew.Where(x => arrTitleNames.Contains(x.Title_Name) && x.Is_Updated == Is_Updated && x.ErrorMSG == msg && x.ErrorMSG != null && x.ErrorMSG != "").ToList();
            }
            else if (msg == "")
                lstDuplicates_Main = lstDupRecordsNew.Where(x => x.Is_Updated == Is_Updated && x.ErrorMSG != null && x.ErrorMSG != "").ToList();
            else
                lstDuplicates_Main = lstDupRecordsNew.Where(x => x.Is_Updated == Is_Updated && x.ErrorMSG == msg && x.ErrorMSG != null && x.ErrorMSG != "").ToList();

            Record_Count = lstDuplicates_Main.Count;
            return lstDuplicates_Main.Skip((PageNo - 1) * partialPageSize).Take(partialPageSize).ToList();
        }
        public PartialViewResult BulkSaveError(string searchForTitles, string PageSize, int PageNo, string ErrorMsg = "", int RightCode = 0)
        {
            lstDupRecordsNew = new Acq_Deal_Rights_Error_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Rights_Code == RightCode).ToList();

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
            ViewBag.RightCode = RightCode;
            ViewBag.PageSize = PageSize;
            int Record_Count = 0;
            List<Acq_Deal_Rights_Error_Details> lstDuplicates = Acq_Rights_List_Validation_Popup
                (lstDupRecordsNew, searchForTitles, PageSize, PageNo, out Record_Count, ErrorMsg, RightCode);
            ViewBag.RecordCount = Record_Count;
            List<string> lst = lstDupRecordsNew.Select(s => s.ErrorMSG).Distinct().ToList();
            ViewBag.ErrorRecord = new SelectList(lstDupRecordsNew.Select(s => new { ErrorMSG = s.ErrorMSG }).Distinct().ToList(), "ErrorMSG", "ErrorMSG", ErrorMsg.Trim());
            return PartialView("~/Views/Acq_Deal/_Syn_Error_Bulk.cshtml", lstDuplicates);
        }
        public PartialViewResult BindPlatformTreePopup(int rightCode)
        {
            Acq_Deal_Rights objADR = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).GetById(rightCode);
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string strPlatform = string.Join(",", objADR.Acq_Deal_Rights_Platform.Select(s => s.Platform_Code).ToArray());
            objPTV.PlatformCodes_Display = strPlatform;
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            objPTV.Show_Selected = true;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            ViewBag.TreeId = "Rights_List_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }
        public JsonResult Bind_JSON_ListBox(string str_Type, string Is_Thetrical)
        {
            // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group

            if (str_Type == "I")
            {
                var arr = BindCountry(Is_Thetrical);
                return Json(arr, JsonRequestBehavior.AllowGet);

            }
            else if (str_Type == "T" || str_Type == "G")
            {
                var arr = BindTerritory(Is_Thetrical);
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SL" || str_Type == "DL")
            {
                var arr = BindLanguage();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SG" || str_Type == "DG")
            {
                var arr = BindLanguage_Group();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SBL")
            {
                List<USP_Get_Acq_PreReq_Result> lstUSP_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Rights_PreReq(objDeal_Schema.Deal_Code, "SBL",
                    objDeal_Schema.Deal_Type_Code, "N").ToList();
                var arr = new SelectList(lstUSP_PreReq_Result.Where(x => x.Data_For == "SBL"), "Display_Value", "Display_Text").ToList();
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "RP")
            {
                List<USP_Get_Acq_PreReq_Result> lstUSP_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Acq_Rights_PreReq(objDeal_Schema.Deal_Code, "SBL",
                        objDeal_Schema.Deal_Type_Code, "N").ToList();
                Dictionary<string, object> obj = new Dictionary<string, object>();
                obj.Add("Milestone_Type_List", BindMilestone_List());
                obj.Add("Milestone_Type_Code", 0);
                obj.Add("Milestone_Unit_Type_List", BindMilestone_Unit_List());
                obj.Add("Milestone_Unit_Type", 0);
                return Json(obj);
            }
            return Json("", JsonRequestBehavior.AllowGet);
        }
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
        public JsonResult ValidateRightsTitleWithAcq(int RCode, int? TCode, int? Episode_From, int? Episode_To)
        {
            int count = 0;
            count = objUSP_Service.USP_Validate_Syn_Right_Title_With_Acq_On_Edit(RCode, TCode, Episode_From, Episode_To).ElementAt(0).Value;
            if (count > 0)
                return Json("INVALID");
            else
                return Json("VALID");
        }
        public JsonResult GetSynRightStatus(int rightCode)
        {
            var recordStatus = new Deal_Rights_Process_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Code == objDeal_Schema.Deal_Code
                                && x.Deal_Rights_Code == rightCode).OrderByDescending(x => x.Deal_Rights_Process_Code).Select(x => x.Record_Status).FirstOrDefault();
            var obj = new { RecordStatus = recordStatus };
            return Json(obj);
        }

    }

    public partial class Acq_Rights
    {
        [HttpPost]
        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, 1, 0);
        }
    }

    public class Merge_Rights_Title_Map
    {
        public string RightsCode { get; set; }
        public string TitleName { get; set; }
        public string TitleCode { get; set; }
        public string IsSynAcqMap { get; set; }
        public string Esp_From_To { get; set; }
        public string IsError { get; set; }
    }

    public class Rights_Title_Code
    {
        public int RightsCode { get; set; }
        public int New_RightsCode { get; set; }
        public int TitleCode { get; set; }
    }
    public class Current_Deal_Right1
    {
        public int? TitleCode { get; set; }
        public int? EpsFrom { get; set; }
        public int? EpsTo { get; set; }
    }
}




