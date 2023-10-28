using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_PushbackController : BaseController
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

        public string AllCountry_Territory_Codes
        {
            get
            {
                if (Session["AllCountry_Territory_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["AllCountry_Territory_Codes"]);
            }
            set { Session["AllCountry_Territory_Codes"] = value; }
        }

        public string AllPlatform_Codes
        {
            get
            {
                if (Session["AllPlatform_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["AllPlatform_Codes"]);
            }
            set { Session["AllPlatform_Codes"] = value; }
        }
        public string SubTitle_Lang_Codes
        {
            get
            {
                if (Session["SubTitle_Lang_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["SubTitle_Lang_Codes"]);
            }
            set { Session["SubTitle_Lang_Codes"] = value; }
        }
        public string Dubb_Lang_Codes
        {
            get
            {
                if (Session["Dubb_Lang_Codes"] == null) return string.Empty;
                return Convert.ToString(Session["Dubb_Lang_Codes"]);
            }
            set { Session["Dubb_Lang_Codes"] = value; }
        }

        public Syn_Deal_Rights objSyn_Deal_Rights
        {
            get
            {
                if (Session["Syn_Deal_Rights"] == null)
                    Session["Syn_Deal_Rights"] = new Syn_Deal_Rights();
                return (Syn_Deal_Rights)Session["Syn_Deal_Rights"];
            }
            set { Session["Syn_Deal_Rights"] = value; }
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
            objDeal_Schema.Page_From = GlobalParams.Page_From_Pushback;
            ViewBag.Right_Type = "G";
            if (objDeal_Schema.Pushback_View == null)
                objDeal_Schema.Pushback_View = "G";
            ViewBag.Acq_Deal_Code = objDeal_Schema.Deal_Code;
            Platform_Service objPservice = new Platform_Service(objLoginEntity.ConnectionStringName);
            objSyn_Deal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            ViewBag.Remark = (objSyn_Deal.Rights_Remarks == null) ? "" : objSyn_Deal.Rights_Remarks;

            ViewBag.TitleList = BindTitle(objDeal_Schema.Pushback_Titles ?? "");

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
           
            return PartialView("~/Views/Syn_Deal/_Syn_Pushback_List.cshtml");
        }
        public PartialViewResult BindRightsFilterData()
        {
        //    ClearSession();
            Syn_Deal objsd = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            var titleList = from sdm in objsd.Syn_Deal_Movie
                            from sdr in objsd.Syn_Deal_Rights
                            from sdrt in sdr.Syn_Deal_Rights_Title
                            where sdm.Syn_Deal_Code == sdr.Syn_Deal_Code && sdr.Syn_Deal_Rights_Code == sdrt.Syn_Deal_Rights_Code && sdrt.Title_Code == sdm.Title_Code && sdr.Is_Pushback == "Y"
                            select new { Title_Code = sdm.Syn_Deal_Movie_Code, Title_Name = DBUtil.GetTitleNameInFormat(objDeal_Schema.Deal_Type_Condition, sdm.Title.Title_Name, sdm.Episode_From, sdm.Episode_End_To) };
            ViewBag.TitleList = new MultiSelectList(titleList.ToList().Distinct(), "Title_Code", "Title_Name");
            string[] regioncode = new string[] { "" };
            if (objDeal_Schema.Pushback_Region != null)
            {
                regioncode = objDeal_Schema.Pushback_Region.Split(',');
            }
            string[] arrSelectedCountryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I" && regioncode.Contains("C" + "" + x.Country_Code.ToString() + "")).Select(s => "C"  + "" + s.Country_Code.ToString() + "").ToArray();
            string[] arrSelectedTerritoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G" && regioncode.Contains("T"  +"" + x.Territory_Code.ToString() + "")).Select(s => "T"  + "" + s.Territory_Code.ToString() + "").ToArray();

            int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

            List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C"  + "" + s.Country_Code.ToString() + ""}).ToList();
            lsts.Where(s => s.GroupName == "Country" && arrSelectedCountryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);

            lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T"  +  "" + s.Territory_Code.ToString() + ""}).ToList());
            lsts.Where(s => s.GroupName == "Territory" && arrSelectedTerritoryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            string[] arrcountryCode = arrSelectedCountryCode.Select(x => x.Replace("C", "")).ToArray();
            string Country_Terr_Name = string.Join(",", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrcountryCode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Name).ToArray());
            string[] arrterritoryCode = arrSelectedTerritoryCode.Select(x => x.Replace("T", "")).ToArray();
            Country_Terr_Name = Country_Terr_Name + "," + string.Join(",", new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrterritoryCode.Contains(s.Territory_Code.ToString())).Select(s => s.Territory_Name).ToArray());
            string[] regionname = new string[] { "" };
            if (Country_Terr_Name != "")
                regionname = Country_Terr_Name.TrimStart(',').TrimEnd(',').Split(',');

            if (regionname.Count() > 3)
                ViewBag.RegionName = " "+regionname.Count()+" Selected";
            else
                 ViewBag.RegionName = Country_Terr_Name.TrimStart(',').TrimEnd(',');
            ViewBag.Region = lsts;
            ViewBag.RegionId = "ddlRegionn";
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
           
            //  ViewBag.RightsFlag = "AR";
            ViewBag.Exclusive_Rights = new SelectList(new[]
                {
                    new { Code = "B", Name =objMessageKey.Both },
                    new { Code = "Y", Name = objMessageKey.Yes },
                    new { Code = "N", Name = objMessageKey.NO }
                }, "Code", "Name");
            ViewBag.FilterPageFrom = "SP";
            return PartialView("~/Views/Shared/_Rights_Filter.cshtml");
        }
        public JsonResult BindRegionList(string TitleCode)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            string htmldata = "";
            string hdntitleCode = "";
            if (TitleCode == "")
            {
                int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
                int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C"  + "" + s.Country_Code.ToString() + ""}).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T"  + "" + s.Territory_Code.ToString() + ""}).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
            }
            else
            {
                string[] code = TitleCode.Split(',');
                string[] titlecode = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => code.Contains(x.Syn_Deal_Movie_Code.ToString())).Select(s => s.Title_Code.ToString()).ToArray();
                int?[] rightsCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Syn_Deal_Rights_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Syn_Deal_Rights_Code).ToArray();
                int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => rightsCode.Contains(s.Syn_Deal_Rights_Code) && s.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(w => w.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();
                int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => rightsCode.Contains(s.Syn_Deal_Rights_Code) && s.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(w => w.Territory_Type == "I").Select(s => s.Country_Code).ToArray();

                List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + ""}).ToList();
                lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + ""}).ToList());
                htmldata = CustomHtmlHelpers.getGroupHtml(lsts);
                string strPlatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code).SelectMany(x => x.Syn_Deal_Rights_Platform).Select(w => w.Platform_Code).ToArray());
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
            int?[] rightsCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "Y").SelectMany(x => x.Syn_Deal_Rights_Title).Where(w => titlecode.Contains(w.Title_Code.ToString())).Select(s => s.Syn_Deal_Rights_Code).ToArray();

            if (TitleCode == "")
            {
                strPlatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "Y").SelectMany(x => x.Syn_Deal_Rights_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
                selectedplatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == objDeal_Schema.Deal_Code && s.Is_Pushback == "Y").SelectMany(x => x.Syn_Deal_Rights_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                if (strPlatform == "")
                    strPlatform = "0";
                objPTV.PlatformCodes_Display = strPlatform;
                objPTV.PlatformCodes_Selected = selectedplatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                selectedplatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Syn_Deal_Rights_Code) && x.Is_Pushback == "Y").SelectMany(x => x.Syn_Deal_Rights_Platform).Where(w => pCode.Contains(w.Platform_Code.ToString())).Select(s => s.Platform_Code).Distinct().ToArray());
                strPlatform = string.Join(",", new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => rightsCode.Contains(x.Syn_Deal_Rights_Code) && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Platform).Select(w => w.Platform_Code).Distinct().ToArray());
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
        public PartialViewResult BindGrid(string Selected_Title_Code, string view_Type, string RegionCode, string PlatformCode, string ExclusiveRight, int txtpageSize = 100, int page_index = 0, string IsCallFromPaging = "N")
        {
            if (DPlatformCode == "D")
                DPlatformCode = PlatformCode;
            ViewBag.Mode = "LIST";
            int PageNo = page_index <= 0 ? 1 : page_index + 1;
            if (IsCallFromPaging == "N" || IsCallFromPaging == "C")            //Here C means Summary and Deatails)                
                objDeal_Schema.List_Rights.Clear();
            Fill_Rights_Schema(view_Type, Selected_Title_Code, txtpageSize, PageNo);

            int totalRcord = 0;
            ObjectParameter objPageNo = new ObjectParameter("PageNo", PageNo);
            ObjectParameter objTotalRecord = new ObjectParameter("TotalRecord", totalRcord);
            List<USP_List_Rights_Result> lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Rights("SP", objDeal_Schema.Pushback_View, objDeal_Schema.Deal_Code,
                objDeal_Schema.Pushback_Titles, RegionCode,PlatformCode, ExclusiveRight, objPageNo, txtpageSize, objTotalRecord, "").ToList();

            ViewBag.RecordCount = Convert.ToInt32(objTotalRecord.Value);
            ViewBag.PageNo = Convert.ToInt32(objPageNo.Value);

            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.Page_View = objDeal_Schema.Pushback_View;
            objDeal_Schema.Pushback_Region = RegionCode;
            objDeal_Schema.Pushback_Platform = PlatformCode;
            objDeal_Schema.Pushback_Title = Selected_Title_Code;
            objDeal_Schema.Pushback_Exclusive = ExclusiveRight;
            string[] regioncode = RegionCode.Split(',');
            string[] arrSelectedCountryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I" && regioncode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Code.ToString()).ToArray();
            string[] arrSelectedTerritoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G" && regioncode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Code.ToString()).ToArray();

            int?[] countryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "I").Select(s => s.Country_Code).ToArray();
            int?[] territoryCode = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Code == objDeal_Schema.Deal_Code && x.Is_Pushback == "Y").SelectMany(s => s.Syn_Deal_Rights_Territory).Where(x => x.Territory_Type == "G").Select(s => s.Territory_Code).ToArray();

            List<GroupItem> lsts = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(s => countryCode.Contains(s.Country_Code)).Select(s => new GroupItem() { GroupName = "Country", Text = s.Country_Name, Value = "C" + "" + s.Country_Code.ToString() + ""}).ToList();
            if (arrSelectedCountryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Country" && arrSelectedCountryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);

            lsts.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => territoryCode.Contains(s.Territory_Code)).Select(s => new GroupItem() { GroupName = "Territory", Text = s.Territory_Name, Value = "T" + "" + s.Territory_Code.ToString() + ""}).ToList());
            if (arrSelectedCountryCode.Count() > 0)
                lsts.Where(s => s.GroupName == "Territory" && arrSelectedTerritoryCode.Contains(s.Value)).ToList().ForEach(f => f.isSelected = true);
            string countryNAme = string.Join(",", new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedCountryCode.Contains(x.Country_Code.ToString())).Select(s => s.Country_Name).ToArray());
            string countryNAmes = string.Join(",", new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(s => arrSelectedTerritoryCode.Contains(s.Territory_Code.ToString())).Select(s => s.Territory_Name).ToArray());

            return PartialView("~/Views/Syn_Deal/_List_Pushback.cshtml", lst);
        }

        private void Fill_Rights_Schema(string view_Type, string Title_Code_Search, int txtpageSize = 100, int pageNo = 0)
        {
            objDeal_Schema.Pushback_View = view_Type;
            objDeal_Schema.Pushback_Titles = Title_Code_Search;
            objDeal_Schema.Rights_PageSize = txtpageSize;
            objDeal_Schema.Rights_PageNo = pageNo;
        }

        private void ClearSession()
        {
            objSyn_Deal = null;
            objSDS = null;
        }
        private MultiSelectList BindTitle(string selectedTitleCode)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().
                BindSearchList_Rights(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Condition, selectedTitleCode, "S");
        }

        private MultiSelectList BindTitle_Popup(string selectedTitleCode)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().
                BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, selectedTitleCode, "S");
        }

        #region=============Add Pushback===============
        [HttpPost]
        public ActionResult Add(string Title_Code_Search, string View_Type_Search)
        {
            ViewBag.Mode = "ADD";
            objSyn_Deal_Rights = new Syn_Deal_Rights();
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objDeal_Schema.Deal_Type_Code);
            #region --- Get Acq Rights Details Code ---
            string strTitle = string.Join(",", objDeal_Schema.Arr_Title_Codes);
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                strTitle = string.Join(",", objDeal_Schema.Title_List.Select(s => s.Acq_Deal_Movie_Code));
            else
                strTitle = string.Join(",", objDeal_Schema.Arr_Title_Codes);
            #endregion

            ViewBag.Title_List_Popup = BindTitle_Popup("");
            ViewBag.Title_Code_Search = Title_Code_Search;
            ViewBag.perpetuity_years = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value;
            ViewBag.View_Type = View_Type_Search;
            BindAllViewBag("", "", "", "", "", "", 0, 0, 'A');
            objSyn_Deal_Rights.Region_Type = "I";
            objSyn_Deal_Rights.Sub_Type = "L";
            objSyn_Deal_Rights.Dub_Type = "L";
            return PartialView("~/Views/Syn_Deal/_Syn_Pushback.cshtml", objSyn_Deal_Rights);
        }
        #endregion

        #region==================Edit Pushback=========
        public PartialViewResult Edit_Pushback(int PushbackCode, int TitleCode, int PlatformCode, int EpisodeFrom, int EpisodeTo, string View_Type, string Title_Code_Search, int? page_index, int? txtpageSize)
        {
            ViewBag.PushbackCode = PushbackCode;
            ViewBag.Mode = "EDIT";
            ViewBag.TCODE = TitleCode;
            ViewBag.Episode_From = EpisodeFrom;
            ViewBag.Episode_To = EpisodeTo;
            ViewBag.PCODE = PlatformCode;
            ViewBag.Title_Code_Search = Title_Code_Search;
            ViewBag.View_Type_Search = View_Type;
            objSyn_Deal_Rights = (new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName)).GetById(PushbackCode);
            string selected_Country_Territory_Code = "";
            string selected_Subtitling_Code = "";
            string selected_Dubbing_Code = "";
            string Territory_Type = "G";
            string SL_Type = "G";
            string DL_Type = "G", selected_Title_Code = "";

            if (TitleCode > 0)
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To && y.Title_Code == TitleCode).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(i => (i.Title_Code == TitleCode)).Select(t => t.Title_Code.ToString()).Distinct());
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }
            string[] arr_Selected_pltcode = objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Where(i => (i.Platform_Code == PlatformCode) || PlatformCode == 0).Select(i => i.Platform_Code.ToString()).ToArray();
            int TCount = 0;
            if (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "G").Count() > 0)
            {
                selected_Country_Territory_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "G").Select(i => i.Territory_Code).ToList()));
                objSyn_Deal_Rights.Region_Type = "G";
                TCount = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "G").ToList().Count;
            }
            else
            {
                selected_Country_Territory_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "I").Select(i => i.Country_Code).ToList()));
                Territory_Type = "I";
                objSyn_Deal_Rights.Region_Type = "I";
                TCount = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "I").ToList().Count;
            }

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.Language_Type == "G").Count() > 0)
            {
                selected_Subtitling_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
                objSyn_Deal_Rights.Sub_Type = "G";
            }
            else
            {
                selected_Subtitling_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                SL_Type = "L";
                objSyn_Deal_Rights.Sub_Type = "L";
            }

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.Language_Type == "G").Count() > 0)
            {
                selected_Dubbing_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
                objSyn_Deal_Rights.Dub_Type = "G";
            }
            else
            {
                selected_Dubbing_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                DL_Type = "L";
                objSyn_Deal_Rights.Dub_Type = "L";
            }
            ViewBag.Title_List_Popup = ViewBag.Title_List_Popup = BindTitle_Popup(selected_Title_Code);

            string Region_Type = "";
            if (Territory_Type == "I")
                Region_Type = (objSyn_Deal_Rights.Is_Theatrical_Right == "N") ? "C" : "THC";
            else
                Region_Type = (objSyn_Deal_Rights.Is_Theatrical_Right == "N") ? "T" : "THT";

            GET_DATA_FOR_APPROVED_TITLES(selected_Title_Code, string.Join(",", arr_Selected_pltcode), "", Region_Type, (SL_Type == "L") ? "SL" : "SG", (DL_Type == "L") ? "DL" : "DG");
            int selected_Milestone_Type_Code = objSyn_Deal_Rights.Right_Type == "M" ? objSyn_Deal_Rights.Milestone_Type_Code ?? 0 : 0;
            int Milestone_Unit_Code = objSyn_Deal_Rights.Right_Type == "M" ? objSyn_Deal_Rights.Milestone_Unit_Type ?? 0 : 0;
            ViewBag.TCount = TCount;
            BindAllViewBag(selected_Country_Territory_Code, Territory_Type, selected_Subtitling_Code, SL_Type, selected_Dubbing_Code, DL_Type, selected_Milestone_Type_Code, Milestone_Unit_Code,'E');
            return PartialView("~/Views/Syn_Deal/_Syn_Pushback.cshtml", objSyn_Deal_Rights);            
        }
        #endregion


        public PartialViewResult Clone_Pushback(int PushbackCode, int TitleCode, int PlatformCode, int EpisodeFrom, int EpisodeTo, string View_Type, string Title_Code_Search, int? page_index, int? txtpageSize)
        {
            ViewBag.PushbackCode = PushbackCode;
            ViewBag.Mode = "CLONE";
            ViewBag.TCODE = TitleCode;
            ViewBag.Episode_From = EpisodeFrom;
            ViewBag.Episode_To = EpisodeTo;
            ViewBag.PCODE = PlatformCode;
            ViewBag.Title_Code_Search = Title_Code_Search;
            ViewBag.View_Type_Search = View_Type;
            objSyn_Deal_Rights = (new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName)).GetById(PushbackCode);
            string selected_Country_Territory_Code = "";
            string selected_Subtitling_Code = "";
            string selected_Dubbing_Code = "";
            string Territory_Type = "G";
            string SL_Type = "G";
            string DL_Type = "G", selected_Title_Code = "";

            if (TitleCode > 0)
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To && y.Title_Code == TitleCode).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(i => (i.Title_Code == TitleCode)).Select(t => t.Title_Code.ToString()).Distinct());
            }
            else
            {
                if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                    selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => objSyn_Deal_Rights.Syn_Deal_Rights_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
                else
                    selected_Title_Code = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Title.Select(t => t.Title_Code.ToString()).Distinct());
            }
            string[] arr_Selected_pltcode = objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Where(i => (i.Platform_Code == PlatformCode) || PlatformCode == 0).Select(i => i.Platform_Code.ToString()).ToArray();
            int TCount = 0;
            if (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "G").Count() > 0)
            {
                selected_Country_Territory_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "G").Select(i => i.Territory_Code).ToList()));
                objSyn_Deal_Rights.Region_Type = "G";
                TCount = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "G").ToList().Count;
            }
            else
            {
                selected_Country_Territory_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "I").Select(i => i.Country_Code).ToList()));
                Territory_Type = "I";
                objSyn_Deal_Rights.Region_Type = "I";
                TCount = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.Territory_Type == "I").ToList().Count;
            }

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.Language_Type == "G").Count() > 0)
            {
                selected_Subtitling_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
                objSyn_Deal_Rights.Sub_Type = "G";
            }
            else
            {
                selected_Subtitling_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                SL_Type = "L";
                objSyn_Deal_Rights.Sub_Type = "L";
            }

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.Language_Type == "G").Count() > 0)
            {
                selected_Dubbing_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.Language_Type == "G").Select(i => i.Language_Group_Code).ToList()));
                objSyn_Deal_Rights.Dub_Type = "G";
            }
            else
            {
                selected_Dubbing_Code = string.Join(",", (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.Language_Type == "L").Select(i => i.Language_Code).ToList()));
                DL_Type = "L";
                objSyn_Deal_Rights.Dub_Type = "L";
            }
            ViewBag.Title_List_Popup = ViewBag.Title_List_Popup = BindTitle_Popup(selected_Title_Code);

            string Region_Type = "";
            if (Territory_Type == "I")
                Region_Type = (objSyn_Deal_Rights.Is_Theatrical_Right == "N") ? "C" : "THC";
            else
                Region_Type = (objSyn_Deal_Rights.Is_Theatrical_Right == "N") ? "T" : "THT";

            GET_DATA_FOR_APPROVED_TITLES(selected_Title_Code, string.Join(",", arr_Selected_pltcode), "", Region_Type, (SL_Type == "L") ? "SL" : "SG", (DL_Type == "L") ? "DL" : "DG");
            int selected_Milestone_Type_Code = objSyn_Deal_Rights.Right_Type == "M" ? objSyn_Deal_Rights.Milestone_Type_Code ?? 0 : 0;
            int Milestone_Unit_Code = objSyn_Deal_Rights.Right_Type == "M" ? objSyn_Deal_Rights.Milestone_Unit_Type ?? 0 : 0;
            ViewBag.TCount = TCount;
            BindAllViewBag(selected_Country_Territory_Code, Territory_Type, selected_Subtitling_Code, SL_Type, selected_Dubbing_Code, DL_Type, selected_Milestone_Type_Code, Milestone_Unit_Code, 'E');
            return PartialView("~/Views/Syn_Deal/_Syn_Pushback.cshtml", objSyn_Deal_Rights);
        }



        public PartialViewResult BindPlatformTreeView(string strPlatform, string strTitles)
        {
            if (!strPlatform.StartsWith("0") && strPlatform != string.Empty)
                strPlatform = "0," + strPlatform;
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            GET_DATA_FOR_APPROVED_TITLES(strTitles, "", "PL", "", "", "");

            if (objSyn_Deal_Rights.Is_Theatrical_Right == "N")
                objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries).Where(p => AllPlatform_Codes.Split(',').Contains(p)).ToArray();

            objPTV.Show_Selected = true;
            objPTV.PlatformCodes_Display = (AllPlatform_Codes == "") ? "0" : AllPlatform_Codes;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("~/Views/Shared/_TV_Platform.cshtml");
        }

        private void BindAllViewBag(string selected_Country_Code, string selected_Territory_Type, string selected_SL_Code, string selected_SL_Type, string selected_DL_Code, string selected_DL_Type, int selected_Milestone_Type_Code, int selected_Milestone_Unit,char Mode)
        {

            ViewBag.Milestone_Type_Popup = BindMilestone_Type(selected_Milestone_Type_Code);
            ViewBag.Milestone_Unit_Popup = BindMilestone_Unit(selected_Milestone_Unit);

            string Region_Type = "I";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Region_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Territory.Where(i => i.EntityState != State.Deleted).ElementAt(0).Territory_Type;

            string Sub_Type = "L";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Sub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Subtitling.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            string Dub_Type = "L";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).Count() > 0)
                Dub_Type = objSyn_Deal_Rights.Syn_Deal_Rights_Dubbing.Where(i => i.EntityState != State.Deleted).ElementAt(0).Language_Type;

            if (Region_Type == "I")
                ViewBag.Territory_List_Popup = BindCountry(objSyn_Deal_Rights.Is_Theatrical_Right, selected_Country_Code);
            else
                ViewBag.Territory_List_Popup = BindTerritory(objSyn_Deal_Rights.Is_Theatrical_Right, selected_Country_Code);

            if (Mode == 'A')
            {
                if (Sub_Type == "L")
                    ViewBag.SL_List_Popup = BindLanguage(selected_SL_Code, "SL","ADD");
                else
                    ViewBag.SL_List_Popup = BindLanguage_Group(selected_SL_Code, "SG");

                if (Dub_Type == "L")
                    ViewBag.DL_List_Popup = BindLanguage(selected_DL_Code, "DL","ADD");
                else
                    ViewBag.DL_List_Popup = BindLanguage_Group(selected_DL_Code, "DG");
            }
            else 
            {
                if (Sub_Type == "L")
                    ViewBag.SL_List_Popup = BindLanguage(selected_SL_Code, "SL","EDIT");
                else
                    ViewBag.SL_List_Popup = BindLanguage_Group(selected_SL_Code, "SG");

                if (Dub_Type == "L")
                    ViewBag.DL_List_Popup = BindLanguage(selected_DL_Code, "DL", "EDIT");
                else
                    ViewBag.DL_List_Popup = BindLanguage_Group(selected_DL_Code, "DG");
            }
          

            objSyn_Deal_Rights.Region_Type = Region_Type;
            objSyn_Deal_Rights.Sub_Type = Sub_Type;
            objSyn_Deal_Rights.Dub_Type = Dub_Type;
        }

        #region=============BindDropDown===============

        private MultiSelectList BindCountry(string Is_Theatrical_Right, string Selected_Country_Code = "")
        {
            string[] CountryCode = AllCountry_Territory_Codes.ToString().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList arr_Title_List = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y" && i.Is_Theatrical_Territory == Is_Theatrical_Right && CountryCode.Contains(i.Country_Code.ToString())).Select(i => new { Country_Code = i.Country_Code, Country_Name = i.Country_Name }).ToList(), "Country_Code", "Country_Name", Selected_Country_Code.Split(','));
            return arr_Title_List;
        }

        private MultiSelectList BindTerritory(string Is_Theatrical_Right, string Selected_Territory_Code = "")
        {
            string[] CountryCode = AllCountry_Territory_Codes.ToString().Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            MultiSelectList arr_Title_List = new MultiSelectList(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y" && i.Is_Thetrical == Is_Theatrical_Right && CountryCode.Contains(i.Territory_Code.ToString())).Select(i => new { Territory_Code = i.Territory_Code, Territory_Name = i.Territory_Name }).ToList(), "Territory_Code", "Territory_Name", Selected_Territory_Code.Split(','));
            return arr_Title_List;
        }

        private MultiSelectList BindLanguage(string Selected_Language_Code = "", string Sub_dubb_LangType = "",string key="")
        {
            string ResultLangCodes = "";
            if (key != "ADD")
            {
                if (Sub_dubb_LangType == "SL")
                    ResultLangCodes = SubTitle_Lang_Codes;
                else if (Sub_dubb_LangType == "DL")
                    ResultLangCodes = Dubb_Lang_Codes;
            }        
            string[] arrLangCodes = ResultLangCodes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);   
            MultiSelectList arr_Title_List = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y" && arrLangCodes.Contains(i.Language_Code.ToString())).Select(i => new { Language_Code = i.Language_Code, Language_Name = i.Language_Name }).ToList(), "Language_Code", "Language_Name", Selected_Language_Code.Split(','));
            return arr_Title_List;
        }
        private MultiSelectList BindLanguage_Group(string Selected_Language_Group_Code = "", string Sub_dubb_LangType = "")
        {
            string ResultLangCodes = "";
            if (Sub_dubb_LangType == "SG")
                ResultLangCodes = SubTitle_Lang_Codes;
            else if (Sub_dubb_LangType == "DG")
                ResultLangCodes = Dubb_Lang_Codes;

            string[] arrLangCodes = ResultLangCodes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            MultiSelectList arr_Title_List = new MultiSelectList(new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y" && arrLangCodes.Contains(i.Language_Group_Code.ToString())).Select(i => new { Language_Group_Code = i.Language_Group_Code, Language_Group_Name = i.Language_Group_Name }).ToList(), "Language_Group_Code", "Language_Group_Name", Selected_Language_Group_Code.Split(','));
            return arr_Title_List;
        }
        private MultiSelectList BindMilestone_Type(int Selected_Milestone_Type_Code = 0)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindMilestone_List(Selected_Milestone_Type_Code);
        }
        private MultiSelectList BindMilestone_Unit(int selected_Milestone_Unit = 0)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindMilestone_Unit_List(selected_Milestone_Unit);
        }

        private bool GET_DATA_FOR_APPROVED_TITLES(string titles, string platforms, string Platform_Type, string Region_Type, string Subtitling_Type, string Dubbing_Type, string CallFrom = "")
        {
            // Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
            platforms = string.Join(",", platforms.Split(',').Where(p => p != "0"));
            bool IsValid = true;
            ObjectResult<USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK_Result> objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK(titles, platforms, Platform_Type, Region_Type, Subtitling_Type, Dubbing_Type, objDeal_Schema.Deal_Code);
            if (Platform_Type == "PL" || Platform_Type == "TPL")
                AllPlatform_Codes = objList.Select(i => i.RequiredCodes).FirstOrDefault();
            else
            {
                foreach (USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK_Result obj in objList)
                {
                    //if (CallFrom != "L")
                    AllCountry_Territory_Codes = obj.RequiredCodes;
                    SubTitle_Lang_Codes = obj.SubTitle_Lang_Code;
                    Dubb_Lang_Codes = obj.Dubb_Lang_Code;
                }
            }
            return true;
        }

        public JsonResult Bind_JSON_ListBox(string str_Type, string Is_Thetrical, string titleCodes, string platformCodes, string Region_Type, string rdbSubtitlingLanguage, string rdbDubbingLanguage)
        {
            // I - Country // G -Territory // SL -Sub Lang // SG - Sub Lang Group // DL -Dub Lang // DG - Dubb Lang Group
            if (Region_Type == "I")
                Region_Type = (Is_Thetrical == "N") ? "C" : "THC";
            else
                Region_Type = (Is_Thetrical == "N") ? "T" : "THT";

            GET_DATA_FOR_APPROVED_TITLES(titleCodes, platformCodes, "", Region_Type, rdbSubtitlingLanguage, rdbDubbingLanguage);
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
                var arr = BindLanguage("", str_Type,"NA");
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            else if (str_Type == "SG" || str_Type == "DG")
            {
                var arr = BindLanguage_Group("", str_Type);
                return Json(arr, JsonRequestBehavior.AllowGet);
            }
            return Json("", JsonRequestBehavior.AllowGet);
        }

        #endregion

        public string Save_Pushback(Syn_Deal_Rights objRights, string[] lbTitle_Popup, string rdoTerritoryType, string[] lbTerritory_Popup, string Right_Type, string Is_Tentative, string Right_Start_Date, string Year, string Month, string Day, string Right_End_Date, string Is_Title_Language_Right, string rdoSubtitlingLanguage, string[] lb_Sub_Language_Popup, string rdoDubbingLanguage, string[] lb_Dubb_Language_Popup, string hdnTVCodes, string View_Type_Search, int? TCODE, int? Episode_From, int? Episode_To, int? PCODE, string Title_Code_Search, string hdnRight_Start_Date, string hdnRight_End_Date,string type, int Milestone_No_Of_Unit = 0, int Milestone_Type_Code = 0, int Milestone_Unit_Type = 0)
        {
            string message = string.Empty;
            //ViewBag.Mode = type;
            var Is_Valid = SaveDealPushback(objRights, lbTitle_Popup, rdoTerritoryType, lbTerritory_Popup, Right_Type, Is_Tentative, Right_Start_Date, Year, Month, Day, Right_End_Date, Milestone_Type_Code, Milestone_Unit_Type, Milestone_No_Of_Unit, Is_Title_Language_Right, rdoSubtitlingLanguage, lb_Sub_Language_Popup, rdoDubbingLanguage, lb_Dubb_Language_Popup, hdnTVCodes, View_Type_Search, TCODE, Episode_From, Episode_To, PCODE, Title_Code_Search, hdnRight_Start_Date, hdnRight_End_Date,type);
            if (!Is_Valid)
                message = "ERROR";
            else
            {
                if (objRights.Syn_Deal_Rights_Code > 0)
                    message = objMessageKey.ReverseHoldbackupdatedsuccessfully;
                else
                    message = objMessageKey.ReverseHoldbacksavedsuccessfully;
            }
            return message;
        }

        private bool SaveDealPushback(Syn_Deal_Rights objRights, string[] lbTitle_Popup, string rdoTerritoryType, string[] lbTerritory_Popup, string Right_Type, string Is_Tentative, string Right_Start_Date, string Year, string Month, string Day, string Right_End_Date, int Milestone_Type_Code, int Milestone_Unit_Type, int Milestone_No_Of_Unit, string Is_Title_Language_Right, string rdoSubtitlingLanguage, string[] lb_Sub_Language_Popup, string rdoDubbingLanguage, string[] lb_Dubb_Language_Popup, string hdnTVCodes, string View_Type_Search, int? TCODE, int? Episode_From, int? Episode_To, int? PCODE, string Title_Code_Search, string hdnRight_Start_Date, string hdnRight_End_Date,string type)
        {
            bool IsValid = true;
            ViewBag.Mode = type;
            if (type == "CLONE")
            {
                objSyn_Deal_Rights = null;
                TCODE = 0;
                PCODE = 0;
            }
            if (IsValid)
            {
                bool IsSameAsGroup = false;
                

                if (TCODE > 0 || PCODE > 0)
                {
                    Syn_Deal objDeal = new Syn_Deal();
                    Syn_Deal_Service objADS = new Syn_Deal_Service(objLoginEntity.ConnectionStringName);
                    objDeal = objADS.GetById(objSyn_Deal_Rights.Syn_Deal_Code);

                    Syn_Deal_Rights objExistingRight = objDeal.Syn_Deal_Rights.Where(t => t.Syn_Deal_Rights_Code == objRights.Syn_Deal_Rights_Code).FirstOrDefault();

                    if (objExistingRight.Syn_Deal_Rights_Title.Count == 1 && TCODE > 0 && objExistingRight.Syn_Deal_Rights_Platform.Count == 1 && PCODE > 0)
                        IsSameAsGroup = true;
                    else if (objExistingRight.Syn_Deal_Rights_Title.Count == 1 && TCODE > 0 && PCODE == 0)
                        IsSameAsGroup = true;
                    else
                    {
                        //This is the new object to be save
                        Syn_Deal_Rights objFirstRight = new Syn_Deal_Rights();
                        objDeal.Syn_Deal_Rights.Add(objFirstRight);

                        #region =========== Assign Platform and Holdback to Second Object ===========

                        objSyn_Deal_Rights.Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t =>
                        {
                            if (t.EntityState != State.Deleted)
                            {
                                Syn_Deal_Rights_Platform objP = new Syn_Deal_Rights_Platform();
                                objP.Platform_Code = t.Platform_Code;
                                objP.EntityState = State.Added;
                                objFirstRight.Syn_Deal_Rights_Platform.Add(objP);
                            }
                        });
                        #endregion

                        objFirstRight = FillObject(objFirstRight, objRights, lbTitle_Popup, rdoTerritoryType, lbTerritory_Popup, Right_Type, Is_Tentative, Right_Start_Date, Year, Month, Day, Right_End_Date, Milestone_Type_Code, Milestone_Unit_Type, Milestone_No_Of_Unit, Is_Title_Language_Right, rdoSubtitlingLanguage, lb_Sub_Language_Popup, rdoDubbingLanguage, lb_Dubb_Language_Popup, hdnTVCodes, hdnRight_Start_Date, hdnRight_End_Date);
                        objFirstRight.EntityState = State.Added;
                        objExistingRight.EntityState = State.Modified;
                        bool isMovieDelete = true;
                        if (objExistingRight.Syn_Deal_Rights_Title.Count > 1)
                            objExistingRight.Syn_Deal_Rights_Title.Where(t => t.Title_Code == TCODE).ToList<Syn_Deal_Rights_Title>().ForEach(x => { x.EntityState = State.Deleted; });
                        else
                            isMovieDelete = false;

                        if (PCODE > 0)
                        {
                            if (!isMovieDelete)
                                objExistingRight.Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t => { if (t.Platform_Code == PCODE) t.EntityState = State.Deleted; });
                            else if (objExistingRight.Syn_Deal_Rights_Platform.Count > 1)
                            {
                                Syn_Deal_Rights objSecondRight = SetNewSynDealRight(objExistingRight, TCODE, Episode_From, Episode_To, PCODE);
                                objDeal.Syn_Deal_Rights.Add(objSecondRight);
                            }
                        }
                        objDeal.SaveGeneralOnly = false;
                        objDeal.EntityState = State.Modified;

                        dynamic resultSet;
                        objADS.Save(objDeal, out resultSet);
                        IEnumerable<string> obj_Mapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Acq_Mapping(objDeal.Syn_Deal_Code, "N");

                        return true;
                    }
                }
                else
                    IsSameAsGroup = true;

                if (IsSameAsGroup || type=="CLONE")
                {
                    if(type == "CLONE")
                    {
                        objSyn_Deal_Rights.Syn_Deal_Rights_Code = 0;
                    }
                    Syn_Deal_Rights_Service objADRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                    if (objSyn_Deal_Rights.Syn_Deal_Rights_Code > 0)
                    {
                        objSyn_Deal_Rights = objADRS.GetById(objSyn_Deal_Rights.Syn_Deal_Rights_Code);
                        objSyn_Deal_Rights.EntityState = State.Modified;
                    }
                    else
                    {
                        objSyn_Deal_Rights.Syn_Deal_Code = objDeal_Schema.Deal_Code;
                        objSyn_Deal_Rights.EntityState = State.Added;
                    }

                    objSyn_Deal_Rights = FillObject(objSyn_Deal_Rights, objRights, lbTitle_Popup, rdoTerritoryType, lbTerritory_Popup, Right_Type, Is_Tentative, Right_Start_Date, Year, Month, Day, Right_End_Date, Milestone_Type_Code, Milestone_Unit_Type, Milestone_No_Of_Unit, Is_Title_Language_Right, rdoSubtitlingLanguage, lb_Sub_Language_Popup, rdoDubbingLanguage, lb_Dubb_Language_Popup, hdnTVCodes, hdnRight_Start_Date, hdnRight_End_Date);
                    if (type == "CLONE")
                    {
                        objSyn_Deal_Rights.Syn_Deal_Rights_Code = 0;
                    }
                    if (objSyn_Deal_Rights.Syn_Deal_Rights_Code > 0)
                    {
                        objSyn_Deal_Rights.EntityState = State.Modified;
                    }
                    else
                        objSyn_Deal_Rights.EntityState = State.Added;

                    dynamic resultSet;

                    objADRS.Save(objSyn_Deal_Rights, out resultSet);
                    IEnumerable<string> obj_Mapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Acq_Mapping(objSyn_Deal_Rights.Syn_Deal_Code, "N");
                    return true;
                }
            }
            else
            {
                return false;
            }
            return true;
        }

        public Syn_Deal_Rights SetNewSynDealRight(Syn_Deal_Rights objExistingRight, int? Title_Code, int? Episode_From, int? Episode_To, int? Platform_Code)
        {
            Syn_Deal_Rights objSecondRight = new Syn_Deal_Rights();
            Syn_Deal_Rights_Title objT = new Syn_Deal_Rights_Title();
            objT.Title_Code = Title_Code;
            objT.Episode_From = Episode_From;
            objT.Episode_To = Episode_To;
            objT.EntityState = State.Added;
            objSecondRight.Right_Status = "P";
            objSecondRight.Syn_Deal_Rights_Title.Add(objT);

            objExistingRight.Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t =>
            {
                if (t.Platform_Code != Platform_Code)
                {
                    Syn_Deal_Rights_Platform objP = new Syn_Deal_Rights_Platform();
                    objP.Platform_Code = t.Platform_Code;
                    objP.EntityState = State.Added;
                    objSecondRight.Syn_Deal_Rights_Platform.Add(objP);
                }
            });
            objExistingRight.Syn_Deal_Rights_Territory.ToList<Syn_Deal_Rights_Territory>().ForEach(t =>
            {
                Syn_Deal_Rights_Territory objTer = new Syn_Deal_Rights_Territory();
                objTer.Territory_Code = t.Territory_Code;
                objTer.Territory_Type = t.Territory_Type;
                objTer.Country_Code = t.Country_Code;
                objTer.EntityState = State.Added;
                objSecondRight.Syn_Deal_Rights_Territory.Add(objTer);
            });
            objExistingRight.Syn_Deal_Rights_Subtitling.ToList<Syn_Deal_Rights_Subtitling>().ForEach(t =>
            {
                Syn_Deal_Rights_Subtitling objS = new Syn_Deal_Rights_Subtitling();
                objS.Language_Code = t.Language_Code;
                objS.Language_Type = t.Language_Type;
                objS.Language_Group_Code = t.Language_Group_Code;
                objS.EntityState = State.Added;
                objSecondRight.Syn_Deal_Rights_Subtitling.Add(objS);
            });
            objExistingRight.Syn_Deal_Rights_Dubbing.ToList<Syn_Deal_Rights_Dubbing>().ForEach(t =>
            {
                Syn_Deal_Rights_Dubbing objD = new Syn_Deal_Rights_Dubbing();
                objD.Language_Code = t.Language_Code;
                objD.Language_Type = t.Language_Type;
                objD.Language_Group_Code = t.Language_Group_Code;
                objD.EntityState = State.Added;
                objSecondRight.Syn_Deal_Rights_Dubbing.Add(objD);
            });

            objSecondRight.Syn_Deal_Code = objExistingRight.Syn_Deal_Code;
            objSecondRight.Is_Exclusive = objExistingRight.Is_Exclusive;
            objSecondRight.Is_Title_Language_Right = objExistingRight.Is_Title_Language_Right;
            objSecondRight.Is_Sub_License = objExistingRight.Is_Sub_License;
            objSecondRight.Sub_License_Code = objExistingRight.Sub_License_Code;
            objSecondRight.Is_Theatrical_Right = objExistingRight.Is_Theatrical_Right;
            objSecondRight.Right_Type = objExistingRight.Right_Type;
            objSecondRight.Is_Pushback = "N";
            objSecondRight.Is_Tentative = objExistingRight.Is_Tentative;
            objSecondRight.Right_Start_Date = objExistingRight.Right_Start_Date;
            objSecondRight.Right_End_Date = objExistingRight.Right_End_Date;
            objSecondRight.Effective_Start_Date = objExistingRight.Effective_Start_Date;
            objSecondRight.Actual_Right_Start_Date = objExistingRight.Actual_Right_Start_Date;
            objSecondRight.Actual_Right_End_Date = objExistingRight.Actual_Right_End_Date;
            objSecondRight.Term = objExistingRight.Term;
            objSecondRight.Milestone_Type_Code = objExistingRight.Milestone_Type_Code;
            objSecondRight.Milestone_No_Of_Unit = objExistingRight.Milestone_No_Of_Unit;
            objSecondRight.Milestone_Unit_Type = objExistingRight.Milestone_Unit_Type;
            objSecondRight.Is_ROFR = objExistingRight.Is_ROFR;
            objSecondRight.ROFR_Date = objExistingRight.ROFR_Date;
            objSecondRight.Restriction_Remarks = objExistingRight.Restriction_Remarks;
            objSecondRight.Inserted_By = objExistingRight.Inserted_By;
            objSecondRight.Inserted_On = objExistingRight.Inserted_On;
            if (objLoginUser != null)
                objSecondRight.Last_Action_By = objLoginUser.Users_Code;
            objSecondRight.Last_Updated_Time = DateTime.Now;
            objSecondRight.EntityState = State.Added;
            return objSecondRight;
        }

        private Syn_Deal_Rights FillObject(Syn_Deal_Rights objExistingRights, Syn_Deal_Rights objRights, string[] lbTitle_Popup, string rdoTerritoryType, string[] lbTerritory_Popup, string Right_Type, string Is_Tentative, string Right_Start_Date, string Year, string Month, string Day, string Right_End_Date, int Milestone_Type_Code, int Milestone_Unit_Type, int Milestone_No_Of_Unit, string Is_Title_Language_Right, string rdoSubtitlingLanguage, string[] lb_Sub_Language_Popup, string rdoDubbingLanguage, string[] lb_Dubb_Language_Popup, string hdnTVCodes, string hdnRight_Start_Date, string hdnRight_End_Date)
        {
            Deal_Rights_UDT objDRUDT = new Deal_Rights_UDT();
            objExistingRights.Syn_Deal_Code = objDeal_Schema.Deal_Code;
            objExistingRights.Is_Exclusive = "Y";
            objExistingRights.Is_Sub_License = "N";
            objExistingRights.Is_Theatrical_Right = "N";
            objExistingRights.Is_ROFR = "N";
            objExistingRights.Right_Status = "P";
            objExistingRights.Syn_Deal_Rights_Code = objRights.Syn_Deal_Rights_Code;
            if (objExistingRights.Syn_Deal_Rights_Code > 0)
                objExistingRights.EntityState = State.Modified;
            else
            {
                objExistingRights.EntityState = State.Added;
                objExistingRights.Inserted_By = objLoginUser.Users_Code;
                objExistingRights.Inserted_On = DateTime.Now;
            }

            objExistingRights.Is_Pushback = "Y";
            objExistingRights.Term = Year + "." + Month + "." + Day;
            objExistingRights.Right_Type = Right_Type;

            objExistingRights.Is_Tentative = null;
            objExistingRights.Right_Start_Date = null;
            objExistingRights.Right_End_Date = null;
            objExistingRights.Milestone_Type_Code = null;
            objExistingRights.Milestone_No_Of_Unit = null;
            objExistingRights.Milestone_Unit_Type = null;
            objExistingRights.Actual_Right_Start_Date = null;
            objExistingRights.Actual_Right_End_Date = null;

            if(objRights.Perpetuity_Date != null && Right_Type == "U")
            {
                hdnRight_Start_Date = objRights.Perpetuity_Date;
            }

            if (hdnRight_Start_Date != "")
            {
                // CultureInfoFunction();
                objRights.Right_Start_Date = Convert.ToDateTime(hdnRight_Start_Date);
                if (hdnRight_End_Date != "" && Is_Tentative != "Y")
                    objRights.Right_End_Date = Convert.ToDateTime(hdnRight_End_Date);
                else
                    objRights.Right_End_Date = null;

                if (objRights.Right_Type == "U")
                {
                    string isEnabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
                    if(isEnabled_Perpetuity == "Y")
                    {
                        string perpetuity_years = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value;
                        objRights.Right_End_Date = Convert.ToDateTime(objRights.Right_Start_Date).AddYears(Convert.ToInt32(perpetuity_years)).AddDays(-1);
                    }
                    
                }
            }
            else
                objRights.Right_Start_Date = null;

            if (Right_Type == "Y")
            {
                objExistingRights.Is_Tentative = Is_Tentative;
                objExistingRights.Actual_Right_Start_Date = objExistingRights.Right_Start_Date = objRights.Right_Start_Date;
                if (Is_Tentative == "Y")
                {
                    DateTime dtSD = Convert.ToDateTime(objExistingRights.Right_Start_Date);
                    if (Year != "")
                        dtSD = dtSD.AddYears(Convert.ToInt32(Year));
                    if (Month != "")
                        dtSD = dtSD.AddMonths(Convert.ToInt32(Month));
                    if (Day != "")
                        dtSD = dtSD.AddDays(Convert.ToInt32(Day));
                    dtSD = dtSD.AddDays(-1);
                    objRights.Right_End_Date = dtSD;
                }
                objExistingRights.Actual_Right_End_Date = objExistingRights.Right_End_Date = objRights.Right_End_Date;
            }
            else if (Right_Type == "M")
            {
                objExistingRights.Milestone_Type_Code = Milestone_Type_Code;
                objExistingRights.Milestone_No_Of_Unit = Milestone_No_Of_Unit;
                objExistingRights.Milestone_Unit_Type = Milestone_Unit_Type;
            }
            else if (Right_Type == "U")
            {
                if (Right_Start_Date != null)
                {
                    objExistingRights.Right_Start_Date = Convert.ToDateTime(objRights.Right_Start_Date);
                    objExistingRights.Actual_Right_Start_Date = objExistingRights.Right_Start_Date;
                }

                string isEnabled_Perpetuity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Enabled_Perpetuity").First().Parameter_Value;
                if(isEnabled_Perpetuity == "Y")
                {
                    Year = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Perpertuity_Term_In_Year").First().Parameter_Value;
                    objExistingRights.Term = Year.ToString() + "." + Month.ToString() + "." + Day.ToString();

                    if (Right_End_Date != null)
                    {
                        objExistingRights.Right_End_Date = Convert.ToDateTime(objRights.Right_End_Date);
                        objExistingRights.Actual_Right_End_Date = objExistingRights.Right_End_Date;
                    }
                }

                
                
                    
                
                    

                objExistingRights.Milestone_Type_Code = null;
                objExistingRights.Milestone_No_Of_Unit = null;
                objExistingRights.Milestone_Unit_Type = null;
            }

            objExistingRights.Is_Title_Language_Right = Is_Title_Language_Right;
            objExistingRights.Restriction_Remarks = objRights.Restriction_Remarks;
            objExistingRights.Inserted_By = objLoginUser.Users_Code;
            objExistingRights.Last_Action_By = objLoginUser.Users_Code;

            string[] arrCodes = lbTitle_Popup;
            string[] arrPlatform = hdnTVCodes.Split(',').Distinct().ToArray();
            string[] arrCountry = (lbTerritory_Popup == null) ? new string[0] : lbTerritory_Popup;
            string[] arrSubtitlingLanguage = (lb_Sub_Language_Popup == null) ? new string[0] : lb_Sub_Language_Popup;
            string[] arrDubbingLanguage = (lb_Dubb_Language_Popup == null) ? new string[0] : lb_Dubb_Language_Popup;

            #region --- Title ---
            ICollection<Syn_Deal_Rights_Title> selectTitleList = new HashSet<Syn_Deal_Rights_Title>();
            foreach (string strCode in arrCodes)
            {
                Syn_Deal_Rights_Title objSyn_Deal_Rights_Title = new Syn_Deal_Rights_Title();
                int code = Convert.ToInt32((string.IsNullOrEmpty(strCode)) ? "0" : strCode);
                if (code > 0)
                {
                    if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program)
                    {
                        Title_List objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                        objSyn_Deal_Rights_Title.Episode_From = objTL.Episode_From;
                        objSyn_Deal_Rights_Title.Episode_To = objTL.Episode_To;
                        objSyn_Deal_Rights_Title.Title_Code = objTL.Title_Code;
                    }
                    else
                    {
                        objSyn_Deal_Rights_Title.Episode_From = 1;
                        objSyn_Deal_Rights_Title.Episode_To = 1;
                        objSyn_Deal_Rights_Title.Title_Code = code;
                    }

                    selectTitleList.Add(objSyn_Deal_Rights_Title);
                }
            }

            IEqualityComparer<Syn_Deal_Rights_Title> comparerTitle = new LambdaComparer<Syn_Deal_Rights_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);

            var Deleted_Syn_Deal_Rights_Title = new List<Syn_Deal_Rights_Title>();
            var Added_Syn_Deal_Rights_Title = CompareLists<Syn_Deal_Rights_Title>(selectTitleList.ToList<Syn_Deal_Rights_Title>(), objExistingRights.Syn_Deal_Rights_Title.ToList<Syn_Deal_Rights_Title>(), comparerTitle, ref Deleted_Syn_Deal_Rights_Title);
            Added_Syn_Deal_Rights_Title.ToList<Syn_Deal_Rights_Title>().ForEach(t => objExistingRights.Syn_Deal_Rights_Title.Add(t));
            Deleted_Syn_Deal_Rights_Title.ToList<Syn_Deal_Rights_Title>().ForEach(t => t.EntityState = State.Deleted);

            #endregion

            #region --- Platform ---
            ICollection<Syn_Deal_Rights_Platform> selectedPlatformList = new HashSet<Syn_Deal_Rights_Platform>();
            foreach (string strPlatformCode in arrPlatform)
            {
                int platformCode = Convert.ToInt32((string.IsNullOrEmpty(strPlatformCode)) ? "0" : strPlatformCode);

                if (platformCode > 0)
                {
                    Syn_Deal_Rights_Platform objSyn_Deal_Rights_Platform = new Syn_Deal_Rights_Platform();
                    objSyn_Deal_Rights_Platform.EntityState = State.Added;
                    objSyn_Deal_Rights_Platform.Platform_Code = platformCode;
                    selectedPlatformList.Add(objSyn_Deal_Rights_Platform);
                }
            }

            IEqualityComparer<Syn_Deal_Rights_Platform> comparerPlatform = new LambdaComparer<Syn_Deal_Rights_Platform>((x, y) => x.Platform_Code == y.Platform_Code && x.EntityState != State.Deleted);

            var Deleted_Syn_Deal_Rights_Platform = new List<Syn_Deal_Rights_Platform>();
            var Added_Syn_Deal_Rights_Platform = CompareLists<Syn_Deal_Rights_Platform>(selectedPlatformList.ToList<Syn_Deal_Rights_Platform>(), objExistingRights.Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>(), comparerPlatform, ref Deleted_Syn_Deal_Rights_Platform);
            Added_Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t => objExistingRights.Syn_Deal_Rights_Platform.Add(t));
            Deleted_Syn_Deal_Rights_Platform.ToList<Syn_Deal_Rights_Platform>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Country ---
            ICollection<Syn_Deal_Rights_Territory> selectedTerritoryList = new HashSet<Syn_Deal_Rights_Territory>();
            foreach (string strCountrCode in arrCountry)
            {
                int countryCode = Convert.ToInt32((string.IsNullOrEmpty(strCountrCode)) ? "0" : strCountrCode);
                if (countryCode > 0)
                {
                    Syn_Deal_Rights_Territory objSyn_Deal_Rights_Territory = new Syn_Deal_Rights_Territory();
                    objSyn_Deal_Rights_Territory.EntityState = State.Added;
                    if (rdoTerritoryType == "I")
                        objSyn_Deal_Rights_Territory.Country_Code = countryCode;
                    else
                        objSyn_Deal_Rights_Territory.Territory_Code = countryCode;

                    objSyn_Deal_Rights_Territory.Territory_Type = rdoTerritoryType;
                    selectedTerritoryList.Add(objSyn_Deal_Rights_Territory);
                }
            }

            IEqualityComparer<Syn_Deal_Rights_Territory> comparerTerritory = new LambdaComparer<Syn_Deal_Rights_Territory>((x, y) => x.Country_Code == y.Country_Code && x.Territory_Type == y.Territory_Type && x.Territory_Code == y.Territory_Code && x.EntityState != State.Deleted);

            var Deleted_Syn_Deal_Rights_Territory = new List<Syn_Deal_Rights_Territory>();
            var Added_Syn_Deal_Rights_Territory = CompareLists<Syn_Deal_Rights_Territory>(selectedTerritoryList.ToList<Syn_Deal_Rights_Territory>(), objExistingRights.Syn_Deal_Rights_Territory.ToList<Syn_Deal_Rights_Territory>(), comparerTerritory, ref Deleted_Syn_Deal_Rights_Territory);
            Added_Syn_Deal_Rights_Territory.ToList<Syn_Deal_Rights_Territory>().ForEach(t => objExistingRights.Syn_Deal_Rights_Territory.Add(t));
            Deleted_Syn_Deal_Rights_Territory.ToList<Syn_Deal_Rights_Territory>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Subtitling ---
            ICollection<Syn_Deal_Rights_Subtitling> selectedSubtitlingList = new HashSet<Syn_Deal_Rights_Subtitling>();
            foreach (string strLanguageCode in arrSubtitlingLanguage)
            {
                int languageCode = Convert.ToInt32((string.IsNullOrEmpty(strLanguageCode)) ? "0" : strLanguageCode);

                if (languageCode > 0)
                {
                    Syn_Deal_Rights_Subtitling objSyn_Deal_Rights_Subtitling = new Syn_Deal_Rights_Subtitling();
                    objSyn_Deal_Rights_Subtitling.EntityState = State.Added;
                    if (rdoSubtitlingLanguage == "L")
                        objSyn_Deal_Rights_Subtitling.Language_Code = languageCode;
                    else
                        objSyn_Deal_Rights_Subtitling.Language_Group_Code = languageCode;

                    objSyn_Deal_Rights_Subtitling.Language_Type = rdoSubtitlingLanguage;

                    selectedSubtitlingList.Add(objSyn_Deal_Rights_Subtitling);
                }
            }

            IEqualityComparer<Syn_Deal_Rights_Subtitling> comparerSubtitling = new LambdaComparer<Syn_Deal_Rights_Subtitling>((x, y) => x.Language_Code == y.Language_Code && x.Language_Type == y.Language_Type && x.Language_Group_Code == y.Language_Group_Code && x.EntityState != State.Deleted);

            var Deleted_Syn_Deal_Rights_Subtitling = new List<Syn_Deal_Rights_Subtitling>();
            var Added_Syn_Deal_Rights_Subtitling = CompareLists<Syn_Deal_Rights_Subtitling>(selectedSubtitlingList.ToList<Syn_Deal_Rights_Subtitling>(), objExistingRights.Syn_Deal_Rights_Subtitling.ToList<Syn_Deal_Rights_Subtitling>(), comparerSubtitling, ref Deleted_Syn_Deal_Rights_Subtitling);
            Added_Syn_Deal_Rights_Subtitling.ToList<Syn_Deal_Rights_Subtitling>().ForEach(t => objExistingRights.Syn_Deal_Rights_Subtitling.Add(t));
            Deleted_Syn_Deal_Rights_Subtitling.ToList<Syn_Deal_Rights_Subtitling>().ForEach(t => t.EntityState = State.Deleted);
            #endregion

            #region --- Dubbing ---
            ICollection<Syn_Deal_Rights_Dubbing> selectedDubbingList = new HashSet<Syn_Deal_Rights_Dubbing>();
            foreach (string strLanguageCode in arrDubbingLanguage)
            {
                int languageCode = Convert.ToInt32((string.IsNullOrEmpty(strLanguageCode)) ? "0" : strLanguageCode);

                if (languageCode > 0)
                {
                    Syn_Deal_Rights_Dubbing objSyn_Deal_Rights_Dubbing = new Syn_Deal_Rights_Dubbing();
                    objSyn_Deal_Rights_Dubbing.EntityState = State.Added;
                    if (rdoDubbingLanguage == "L")
                        objSyn_Deal_Rights_Dubbing.Language_Code = languageCode;
                    else
                        objSyn_Deal_Rights_Dubbing.Language_Group_Code = languageCode;
                    objSyn_Deal_Rights_Dubbing.Language_Type = rdoDubbingLanguage;

                    selectedDubbingList.Add(objSyn_Deal_Rights_Dubbing);
                }
            }
            IEqualityComparer<Syn_Deal_Rights_Dubbing> comparerDubbing = new LambdaComparer<Syn_Deal_Rights_Dubbing>((x, y) => x.Language_Code == y.Language_Code && x.Language_Type == y.Language_Type && x.Language_Group_Code == y.Language_Group_Code && x.EntityState != State.Deleted);

            var Deleted_Syn_Deal_Rights_Dubbing = new List<Syn_Deal_Rights_Dubbing>();
            var Added_Syn_Deal_Rights_Dubbing = CompareLists<Syn_Deal_Rights_Dubbing>(selectedDubbingList.ToList<Syn_Deal_Rights_Dubbing>(), objExistingRights.Syn_Deal_Rights_Dubbing.ToList<Syn_Deal_Rights_Dubbing>(), comparerDubbing, ref Deleted_Syn_Deal_Rights_Dubbing);
            Added_Syn_Deal_Rights_Dubbing.ToList<Syn_Deal_Rights_Dubbing>().ForEach(t => objExistingRights.Syn_Deal_Rights_Dubbing.Add(t));
            Deleted_Syn_Deal_Rights_Dubbing.ToList<Syn_Deal_Rights_Dubbing>().ForEach(t => t.EntityState = State.Deleted);
            #endregion
            return objExistingRights;
        }

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult) where T : class
        {

            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);

            DelResult = DeleteResult.ToList<T>();

            return AddResult.ToList<T>();
        }

        public string DeletePushback(string RightCode, string DealCode, string TitleCode, string PlatformCode, string EpisodeFrom, string EpisodeTo, string ViewType)
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
                if (ViewType == "D")
                    Platform_Code = Convert.ToInt32(PlatformCode);

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
                        IEnumerable<string> obj_Mapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Acq_Mapping(objDeal.Syn_Deal_Code, "N");
                    }
                }
                else
                    IsSameAsGroup = true;

                if (IsSameAsGroup)
                {
                    Syn_Deal_Rights_Service objSDRS = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                    Syn_Deal_Rights objRights = objSDRS.GetById(Right_Code);
                    objRights.EntityState = State.Deleted;
                    dynamic resultSet;
                    bool isValid = objSDRS.Delete(objRights, out resultSet);
                    if (isValid)
                    {
                        IEnumerable<string> obj_Mapping = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Acq_Mapping(objRights.Syn_Deal_Code, "N");
                        Result =objMessageKey.ReverseHoldbackDeletedSuccessfully;
                    }
                }
                if (Result == "")
                    Result = objMessageKey.RecordDeletedsuccessfully;
                objDeal_Schema.List_Rights.Clear();
            }
            catch (Exception ex)
            {
            }

            return Result;
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

        #region=============Cancel Action==============
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
                return RedirectToAction("Index", "Syn_List");
            }
        }
        #endregion

        [HttpPost]
        public ActionResult ChangeTab(string hdnTabName)
        {
            int PageNo = objDeal_Schema.PageNo;
            if (hdnTabName == "")
                objDeal_Schema = null;
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, PageNo, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);
        }
    }
}
