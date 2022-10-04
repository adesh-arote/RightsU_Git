using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Collections;
using UTOFrameWork.FrameworkClasses;
using System.Globalization;
using System.Threading;
using System.Web.UI;

namespace RightsU_Plus.Controllers
{
    public class Syn_AncillaryController : BaseController
    {
        #region --- Properties ---
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.Syn_DEAL_SCHEMA] = value; }
        }
        public IQueryable<Ancillary_Platform_Medium> obj_Ancillary_Platform_Medium
        {
            get
            {
                if (Session["Ancillary_Platform_Medium"] == null)
                    Session["Ancillary_Platform_Medium"] = new Ancillary_Platform_Medium();
                return (IQueryable<Ancillary_Platform_Medium>)Session["Ancillary_Platform_Medium"];
            }
            set
            { Session["Ancillary_Platform_Medium"] = value; }
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
        #endregion
        #region --- Page Load ---
        public PartialViewResult Index()
        {
            AllPlatform_Codes = null;
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSynDeal);
            ViewBag.Mode = "LIST";
            ClearSession();
            objDeal_Schema.Page_From = GlobalParams.Page_From_Ancillary;
            Set_Ancillary_Platform_Medium();
            List<USP_List_Syn_Ancillary_Result> lst = new List<USP_List_Syn_Ancillary_Result>();
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.IsCatchUpRights = GetCatchUpConfig();
            Session["FileName"] = "";
            Session["FileName"] = "syn_Ancillary";

            int prevAcq_Deal = 0;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_VIEW && TempData["prevAcqDeal"] != null)
            {
                prevAcq_Deal = Convert.ToInt32(TempData["prevAcqDeal"]);
                TempData.Keep("prevAcqDeal");
            }
            ViewBag.prevAcq_Deal = prevAcq_Deal;
            return PartialView("~/Views/Syn_Deal/_Syn_Ancillary_List.cshtml");
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
        private void Fill_Session(int txtpageSize = 10, int pageNo = 0)
        {

            objDeal_Schema.Ancillary_PageSize = txtpageSize;
            objDeal_Schema.Ancillary_PageNo = pageNo;
        }
        private void Set_Ancillary_Platform_Medium()
        {
            obj_Ancillary_Platform_Medium = new Ancillary_Platform_Medium_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Ancillary_Platform_code > 0);
        }
        [HttpPost]
        public PartialViewResult Bind_Grid_List(int txtpageSize = 1, int page_index = 0, string IsCallFromPaging = "N")
        {
            ViewBag.Mode = "LIST";
            int PageNo = page_index <= 0 ? 1 : page_index + 1;
            if (IsCallFromPaging == "N")
                objDeal_Schema.List_Ancillary_Syn.Clear();
            Fill_Session(txtpageSize, PageNo);
            if (objDeal_Schema.List_Ancillary_Syn.Count == 0 || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                objDeal_Schema.List_Ancillary_Syn = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Syn_Ancillary(objDeal_Schema.Deal_Code).OrderBy(a => a.TitleName).ToList();
            AssignPaging(txtpageSize);
            List<USP_List_Syn_Ancillary_Result> lst = Get_Paging_List(txtpageSize, PageNo);
            if (PageNo > 1 && lst.Count == 0 && objDeal_Schema.List_Ancillary_Syn.Count > 0)
            {
                PageNo = 1;
                lst = Get_Paging_List(txtpageSize, PageNo);
            }
            ViewBag.RecordCount = objDeal_Schema.List_Ancillary_Syn.Where(r => r.PageNo == PageNo).Count();
            ViewBag.RecordCount_Display = objDeal_Schema.List_Ancillary_Syn.Select(i => i.Syn_Deal_Ancillary_Code).Distinct().Count();
            ViewBag.PageCount = PageNo;
            ViewBag.Deal_Mode = objDeal_Schema.Mode;
            ViewBag.IsCatchUpRights = GetCatchUpConfig();
            ViewBag.IsAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
            return PartialView("~/Views/Syn_Deal/_List_Ancillary_Syn.cshtml", lst);
        }
        private MultiSelectList BindTitle(string selected_Title_Code = "")
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, selected_Title_Code, "S");
        }
        #endregion
        #region --- Create / Edit / Delete ---
        private void BindAllViewBag(string selected_Title_Code, int selected_Type_Code, string selected_Syn_Deal_Ancillary_Code, string selected_Medium_Code)
        {
            ViewBag.Title_List_Popup = BindTitle(selected_Title_Code);
            ViewBag.Type_List_Popup = BindAncillaryType(selected_Type_Code);
            if (selected_Syn_Deal_Ancillary_Code != "")
                ViewBag.Rights_List_Popup = Bindddl_Right(selected_Type_Code, selected_Syn_Deal_Ancillary_Code);
            else
                ViewBag.Rights_List_Popup = new MultiSelectList(new[]
                {
                    new { Ancillary_Platform_code = "0", Platform_Name = "" }
                },
            "Ancillary_Platform_code", "Platform_Name", "");
            if (selected_Medium_Code != "")
                ViewBag.Medium_List_Popup = Bindddl_Medium(selected_Syn_Deal_Ancillary_Code, selected_Medium_Code);
            else
            {

                ViewBag.Medium_List_Popup = new MultiSelectList(new[]
                {
                    new { Ancillary_Platform_Medium_Code = "0", Ancillary_Medium_Name = "" }
                },
            "Ancillary_Platform_Medium_Code", "Ancillary_Medium_Name", "");
            }
        }
        private List<SelectListItem> BindAncillaryType(int Selected_Ancillary_Type_Code)
        {
            List<SelectListItem> arr_Type_List = new SelectList(new Ancillary_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Ancillary_Type_Code > 0).Select(i => new { Ancillary_Type_Code = i.Ancillary_Type_Code, Ancillary_Type_Name = i.Ancillary_Type_Name }), "Ancillary_Type_Code", "Ancillary_Type_Name", Selected_Ancillary_Type_Code).OrderBy(o => o.Text).ToList();
            arr_Type_List.Insert(0, new SelectListItem() { Value = "0", Text = objMessageKey.PleaseSelect });
            //SelectList arr_Type_List = new SelectList(new Ancillary_Type_Service().SearchFor(i => i.Ancillary_Type_Code > 0).Select(i => new { Ancillary_Type_Code = i.Ancillary_Type_Code, Ancillary_Type_Name = i.Ancillary_Type_Name }).ToList(), "Ancillary_Type_Code", "Ancillary_Type_Name", Selected_Ancillary_Type_Code);            
            return arr_Type_List;
        }
        public JsonResult BindAncillary_Right(int? selected_Ancillary_Type_Code, string selected_Ancillary_Right_Code = "0")
        {
            MultiSelectList arr_Title_List = Bindddl_Right(selected_Ancillary_Type_Code, selected_Ancillary_Right_Code);
            return Json(arr_Title_List, JsonRequestBehavior.AllowGet);
        }
        public JsonResult BindAncillary_Medium(string Selected_Ancillary_Right_Code, string Selected_Ancillary_Platform_Medium_Code = "0")
        {
            MultiSelectList arr_Medium_List = Bindddl_Medium(Selected_Ancillary_Right_Code, Selected_Ancillary_Platform_Medium_Code);
            return Json(arr_Medium_List, JsonRequestBehavior.AllowGet);
        }
        private MultiSelectList Bindddl_Right(int? selected_Ancillary_Type_Code, string selected_Ancillary_Right_Code = "0")
        {
            MultiSelectList arr_Title_List = new MultiSelectList
                                               (new Ancillary_Platform_Service(objLoginEntity.ConnectionStringName)
                                                    .SearchFor(i => i.Ancillary_Platform_code > 0 && i.Ancillary_Type_code == selected_Ancillary_Type_Code.Value)
                                                    .Select(i => new { Ancillary_Platform_code = i.Ancillary_Platform_code, Platform_Name = i.Platform_Name })
                                                    .OrderBy(o => o.Platform_Name).ToList(), "Ancillary_Platform_code", "Platform_Name", selected_Ancillary_Right_Code.Split(',')
                                                );
            return arr_Title_List;
        }
        private MultiSelectList Bindddl_Medium(string Selected_Ancillary_Right_Code, string Selected_Ancillary_Platform_Medium_Code = "0")
        {
            string isCatchUp = GetCatchUpConfig();
            if (isCatchUp != "Y")
            {
                string[] arr = Selected_Ancillary_Right_Code.Trim(',').Split(',');
                MultiSelectList arr_Medium_List = new MultiSelectList(new Ancillary_Platform_Medium_Service(objLoginEntity.ConnectionStringName).
                                                    SearchFor(i => arr.Contains(i.Ancillary_Platform_code.ToString()))
                                                    .Select(i => new
                                                    {
                                                        Ancillary_Medium_Name = i.Ancillary_Medium.Ancillary_Medium_Name,
                                                        Ancillary_Platform_Medium_Code = i.Ancillary_Platform_Medium_Code
                                                    }
                                                            ).ToList(),
                                                            "Ancillary_Platform_Medium_Code", "Ancillary_Medium_Name", Selected_Ancillary_Platform_Medium_Code.Split(','));
                return arr_Medium_List;
            }
            else
            {
                List<Ancillary_Platform_Medium> lst = new List<Ancillary_Platform_Medium>();
                return new MultiSelectList(lst);
            }
        }
        [HttpPost]
        public ActionResult Add_Ancillary()
        {
            ViewBag.Mode = "ADD";
            ViewBag.Header = "Add " + objMessageKey.AncillaryRights;
            BindAllViewBag("", 0, "", "");
            ViewBag.IsCatchUpRights = GetCatchUpConfig();
            string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
            if (isAdvAncillary == "Y")
            {
                ViewBag.PlatFormCodes = "";
                return View("~/Views/Syn_Deal/_Syn_Ancillary_Adv.cshtml", new Syn_Deal_Ancillary());
            }
            else
                return View("~/Views/Syn_Deal/_Syn_Ancillary.cshtml", new Syn_Deal_Ancillary());
        }
        public ActionResult Edit_Ancillary(int selected_Syn_Deal_Ancillary_Code, string Mode = "EDIT")
        {
            ViewBag.Mode = Mode;
            ViewBag.Header = "Edit " + objMessageKey.AncillaryRights;
            Syn_Deal_Ancillary obj = new Syn_Deal_Ancillary_Service(objLoginEntity.ConnectionStringName).GetById(selected_Syn_Deal_Ancillary_Code);
            string selected_Title_Code = "";
            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                selected_Title_Code = string.Join(",", objDeal_Schema.Title_List.Where(x => obj.Syn_Deal_Ancillary_Title.Where(y => y.Title_Code == x.Title_Code && y.Episode_From == x.Episode_From && y.Episode_To == x.Episode_To).Count() > 0).Select(s => s.Acq_Deal_Movie_Code).ToArray());
            else
                selected_Title_Code = string.Join(",", obj.Syn_Deal_Ancillary_Title.Select(i => i.Title_Code).ToArray());
            int selected_Type_Code = obj.Ancillary_Type_code ?? 0;
            string selected_Platform_Code = string.Join(",", obj.Syn_Deal_Ancillary_Platform.Select(i => i.Ancillary_Platform_code).Distinct().ToArray());
            string selected_Medium_Code = "";
            if (obj.Syn_Deal_Ancillary_Platform.Select(i => i.Syn_Deal_Ancillary_Platform_Medium).Count() > 0)
                selected_Medium_Code = string.Join(",", obj.Syn_Deal_Ancillary_Platform.SelectMany(i => i.Syn_Deal_Ancillary_Platform_Medium).Select(i => i.Ancillary_Platform_Medium_Code).Distinct().ToArray());
            BindAllViewBag(selected_Title_Code, selected_Type_Code, selected_Platform_Code, selected_Medium_Code);
            ViewBag.IsCatchUpRights = GetCatchUpConfig();

            string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
            if (isAdvAncillary == "Y")
            {
                ViewBag.PlatFormCodes = string.Join(",", obj.Syn_Deal_Ancillary_Platform.Select(x => x.Ancillary_Platform_code).ToArray());
                return View("~/Views/Syn_Deal/_Syn_Ancillary_Adv.cshtml", obj);
            }
            else
                return View("~/Views/Syn_Deal/_Syn_Ancillary.cshtml", obj);
        }
        public JsonResult Delete_Ancillary(int? Syn_Deal_Ancillary_Code)
        {
            Syn_Deal_Ancillary_Service objAcq_Deal_Ancillary_Service = new Syn_Deal_Ancillary_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Ancillary objAcq_Deal_Ancillary = objAcq_Deal_Ancillary_Service.GetById(Syn_Deal_Ancillary_Code ?? 0);
            try
            {
                Save(objAcq_Deal_Ancillary, ref objAcq_Deal_Ancillary_Service, true);
            }
            catch (Exception)
            {
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            return Json(obj, JsonRequestBehavior.AllowGet);
        }
        private string Save(Syn_Deal_Ancillary objAcqDeal_AncillaryTemp, ref Syn_Deal_Ancillary_Service objAcq_Deal_Ancillary_Service, bool isDelete)//Final Save
        {
            dynamic resultSet;
            string msg = "E";
            string strMode = objAcqDeal_AncillaryTemp.Syn_Deal_Ancillary_Code > 0 ? "U" : "A";
            if (!isDelete)
                objAcq_Deal_Ancillary_Service.Save(objAcqDeal_AncillaryTemp, out resultSet);
            else
            {
                objAcq_Deal_Ancillary_Service.Delete(objAcqDeal_AncillaryTemp, out resultSet);
                msg = objMessageKey.Ancillaryrightsdeletedsuccessfully;
            }
            string strResult = resultSet;
            if (strResult.ToUpper() == "DUPLICATE")
                return "D";
            else
            {
                if (strMode == "A")
                    return "A";
                else
                    return "U";
            }
            return msg;
        }
        public JsonResult Save_Ancillary(Syn_Deal_Ancillary objAcq_Deal_Ancillary_Temp, string Ancillary_Mode, string CatchUp, string hdnTitles, string hdnTVCodes, string hdnAncillaryRightCode, string hdnMedium, int? page_index, int? txtpageSize)//
        {
            Syn_Deal_Ancillary_Service objAcq_Deal_Ancillary_Service = new Syn_Deal_Ancillary_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Ancillary objAcq_Deal_Ancillary = new Syn_Deal_Ancillary();
            string msg = "";
            Dictionary<string, object> obj_Dictionary = new Dictionary<string, object>();
            objAcq_Deal_Ancillary.LstDeal_Ancillary_Title_UDT.Clear();
            objAcq_Deal_Ancillary.LstDeal_Ancillary_Platform_UDT.Clear();
            objAcq_Deal_Ancillary.LstDeal_Ancillary_Platform_Medium_UDT.Clear();
            try
            {
                if (hdnTitles != "")
                {
                    string[] arrCodes = hdnTitles.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (objAcq_Deal_Ancillary_Temp.Syn_Deal_Ancillary_Code > 0 && Ancillary_Mode == "EDIT")
                    {
                        objAcq_Deal_Ancillary = objAcq_Deal_Ancillary_Service.GetById(objAcq_Deal_Ancillary_Temp.Syn_Deal_Ancillary_Code);
                        objAcq_Deal_Ancillary.EntityState = State.Modified;
                    }
                    else
                        objAcq_Deal_Ancillary.EntityState = State.Added;
                    objAcq_Deal_Ancillary.Syn_Deal_Code = objDeal_Schema.Deal_Code;
                    objAcq_Deal_Ancillary.Ancillary_Type_code = objAcq_Deal_Ancillary_Temp.Ancillary_Type_code;
                    objAcq_Deal_Ancillary.Duration = objAcq_Deal_Ancillary_Temp.Duration;
                    objAcq_Deal_Ancillary.Day = objAcq_Deal_Ancillary_Temp.Day;
                    objAcq_Deal_Ancillary.Remarks = objAcq_Deal_Ancillary_Temp.Remarks;
                    objAcq_Deal_Ancillary.Catch_Up_From = CatchUp;
                    #region --- Title ---
                    if (objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Title == null)
                        objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Title = new HashSet<Syn_Deal_Ancillary_Title>();
                    objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Title.ToList<Syn_Deal_Ancillary_Title>().ForEach(x => x.EntityState = State.Deleted);
                    foreach (string strCode in arrCodes)
                    {
                        Syn_Deal_Ancillary_Title objAcq_Deal_Ancillary_Title = new Syn_Deal_Ancillary_Title();
                        int code = Convert.ToInt32((string.IsNullOrEmpty(strCode)) ? "0" : strCode);
                        if (code > 0)
                        {
                            if (objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Program || objDeal_Schema.Deal_Type_Condition == GlobalParams.Deal_Music)
                            {
                                Title_List objTL = null;
                                objTL = objDeal_Schema.Title_List.Where(x => x.Acq_Deal_Movie_Code == code).FirstOrDefault();
                                if (objTL != null)
                                {
                                    objAcq_Deal_Ancillary_Title.Episode_From = objTL.Episode_From;
                                    objAcq_Deal_Ancillary_Title.Episode_To = objTL.Episode_To;
                                    objAcq_Deal_Ancillary_Title.Title_Code = objTL.Title_Code;
                                }
                            }
                            else
                            {
                                objAcq_Deal_Ancillary_Title.Episode_From = 1;
                                objAcq_Deal_Ancillary_Title.Episode_To = 1;
                                objAcq_Deal_Ancillary_Title.Title_Code = code;
                            }
                            objAcq_Deal_Ancillary_Title.EntityState = State.Added;
                            objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Title.Add(objAcq_Deal_Ancillary_Title);
                        }
                        Deal_Ancillary_Title_UDT objATUDT = new Deal_Ancillary_Title_UDT();
                        objATUDT.Deal_Ancillary_Code = objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code;
                        objATUDT.Title_Code = objAcq_Deal_Ancillary_Title.Title_Code;
                        objATUDT.Episode_From = objAcq_Deal_Ancillary_Title.Episode_From;
                        objATUDT.Episode_To = objAcq_Deal_Ancillary_Title.Episode_To;
                        objAcq_Deal_Ancillary.LstDeal_Ancillary_Title_UDT.Add(objATUDT);
                    }
                    #endregion
                    string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
                    if (isAdvAncillary == "N")
                    {
                        #region --- AncillaryRight ---
                        if (hdnAncillaryRightCode.Trim() != "")
                        {
                            int Ancillary_PlatformCode = 0;
                            string[] arrAncillaryPlafrom = hdnAncillaryRightCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Platform.ToList<Syn_Deal_Ancillary_Platform>().ForEach(x => x.EntityState = State.Deleted);
                            objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Platform.SelectMany(i => i.Syn_Deal_Ancillary_Platform_Medium).ToList<Syn_Deal_Ancillary_Platform_Medium>().ForEach(x => x.EntityState = State.Deleted);
                            foreach (string strPlatformCode in arrAncillaryPlafrom)
                            {
                                Ancillary_PlatformCode = strPlatformCode.Trim() == "" ? 0 : Convert.ToInt32(strPlatformCode.Trim());
                                Syn_Deal_Ancillary_Platform objAcqDealAncillary_Platform = null;
                                if (objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code > 0)
                                    objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Platform.Select(i => i.Ancillary_Platform_code == Ancillary_PlatformCode).FirstOrDefault();
                                if (objAcqDealAncillary_Platform == null)
                                {
                                    objAcqDealAncillary_Platform = new Syn_Deal_Ancillary_Platform();
                                    objAcqDealAncillary_Platform.EntityState = State.Added;//Set Entity State Added
                                    objAcqDealAncillary_Platform.Syn_Deal_Ancillary_Code = objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code;
                                    objAcqDealAncillary_Platform.Ancillary_Platform_code = Ancillary_PlatformCode;
                                }
                                else
                                    objAcqDealAncillary_Platform.EntityState = State.Unchanged;
                                Deal_Ancillary_Platform_UDT objAPUDT = new Deal_Ancillary_Platform_UDT();
                                objAPUDT.Deal_Ancillary_Code = objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code;
                                objAPUDT.Ancillary_Platform_Code = Convert.ToInt32(strPlatformCode);
                                objAcq_Deal_Ancillary.LstDeal_Ancillary_Platform_UDT.Add(objAPUDT);

                                if (hdnMedium.Trim() != "")
                                {
                                    string[] arrGet_Ancillary_Platform_Medium_Code = (from Ancillary_Platform_Medium objAPM in obj_Ancillary_Platform_Medium
                                                                                      where objAPM.Ancillary_Platform_code == Ancillary_PlatformCode
                                                                                    && ("," + hdnMedium.Trim() + ",").Contains("," + objAPM.Ancillary_Platform_Medium_Code.ToString() + ",")
                                                                                      select objAPM.Ancillary_Platform_Medium_Code.ToString()).Distinct().ToArray();
                                    if (arrGet_Ancillary_Platform_Medium_Code != null && arrGet_Ancillary_Platform_Medium_Code.Count() > 0)
                                        if (arrGet_Ancillary_Platform_Medium_Code != null && arrGet_Ancillary_Platform_Medium_Code.Count() > 0)
                                            foreach (string strPlatformMedium_Code in arrGet_Ancillary_Platform_Medium_Code)
                                            {
                                                int Ancillary_Platform_MediumCode = strPlatformMedium_Code.Trim() == "" ? 0 : Convert.ToInt32(strPlatformMedium_Code.Trim());
                                                Syn_Deal_Ancillary_Platform_Medium objAcqDealAncillaryPlatform_Medium = null;
                                                if (objAcqDealAncillary_Platform != null && objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code > 0)
                                                    objAcqDealAncillaryPlatform_Medium = objAcqDealAncillary_Platform.Syn_Deal_Ancillary_Platform_Medium.Where(i => i.Ancillary_Platform_Medium_Code == Ancillary_Platform_MediumCode).Select(i => i).FirstOrDefault();
                                                if (objAcqDealAncillaryPlatform_Medium == null)
                                                {
                                                    objAcqDealAncillaryPlatform_Medium = new Syn_Deal_Ancillary_Platform_Medium();
                                                    objAcqDealAncillaryPlatform_Medium.EntityState = State.Added;
                                                    objAcqDealAncillaryPlatform_Medium.Syn_Deal_Ancillary_Platform_Code = objAcqDealAncillary_Platform.Syn_Deal_Ancillary_Platform_Code;
                                                    objAcqDealAncillaryPlatform_Medium.Ancillary_Platform_Medium_Code = Ancillary_Platform_MediumCode;
                                                    objAcqDealAncillary_Platform.Syn_Deal_Ancillary_Platform_Medium.Add(objAcqDealAncillaryPlatform_Medium);
                                                }
                                                else
                                                    objAcqDealAncillaryPlatform_Medium.EntityState = State.Unchanged;
                                                Deal_Ancillary_Platform_Medium_UDT objAPMUDT = new Deal_Ancillary_Platform_Medium_UDT();
                                                objAPMUDT.Deal_Ancillary_Code = objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code;
                                                objAPMUDT.Ancillary_Platform_Medium_Code = Ancillary_Platform_MediumCode;
                                                objAPMUDT.Ancillary_Platform_Code = Ancillary_PlatformCode;
                                                objAcq_Deal_Ancillary.LstDeal_Ancillary_Platform_Medium_UDT.Add(objAPMUDT);
                                            }
                                }
                                objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Platform.Add(objAcqDealAncillary_Platform);
                            }
                        }
                        #endregion
                    }
                    else
                    {
                        #region------------------ Platform -----------------------
                        if (hdnTVCodes == null)
                            hdnTVCodes = "";

                        if (hdnTVCodes.Trim() != "")
                        {
                            objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Platform.ToList<Syn_Deal_Ancillary_Platform>().ForEach(x => x.EntityState = State.Deleted);

                            hdnTVCodes = hdnTVCodes.Replace("_", "").Trim().Replace("_", "").Replace(" ", "").Replace("_0", "").Trim();
                            string[] PTitle_Codes = hdnTVCodes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Distinct().ToArray();
                            foreach (string platformCode in PTitle_Codes)
                            {
                                if (platformCode != "" && platformCode != "0")
                                {
                                    Syn_Deal_Ancillary_Platform objAcqDealAncillary_Platform = null;
                                    if (objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code > 0)
                                        objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Platform.Where(t => t.Ancillary_Platform_code == Convert.ToInt32(platformCode)).Select(i => i).FirstOrDefault();
                                    if (objAcqDealAncillary_Platform == null)
                                    {
                                        objAcqDealAncillary_Platform = new Syn_Deal_Ancillary_Platform();
                                        objAcqDealAncillary_Platform.EntityState = State.Added;//Set Entity State Added
                                        objAcqDealAncillary_Platform.Syn_Deal_Ancillary_Code = objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code;
                                        objAcqDealAncillary_Platform.Ancillary_Platform_code = Convert.ToInt32(platformCode);
                                    }
                                    else
                                        objAcqDealAncillary_Platform.EntityState = State.Unchanged;

                                    Deal_Ancillary_Platform_UDT objAPUDT = new Deal_Ancillary_Platform_UDT();
                                    objAPUDT.Deal_Ancillary_Code = objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Code;
                                    objAPUDT.Platform_Code = Convert.ToInt32(platformCode);
                                    objAcq_Deal_Ancillary.LstDeal_Ancillary_Platform_UDT.Add(objAPUDT);

                                    objAcq_Deal_Ancillary.Syn_Deal_Ancillary_Platform.Add(objAcqDealAncillary_Platform);
                                }
                            }
                        }
                        #endregion
                    }

                    if (page_index > 0)
                        page_index = page_index - 1;
                    msg = Save(objAcq_Deal_Ancillary, ref objAcq_Deal_Ancillary_Service, false);
                    string status = msg;
                    obj_Dictionary.Add("Status", status);
                    obj_Dictionary.Add("page_index", page_index);
                    obj_Dictionary.Add("txtpageSize", txtpageSize);
                }
            }
            catch (Exception ex)
            {
            }
            return Json(obj_Dictionary, JsonRequestBehavior.AllowGet);
        }
        private bool GET_DATA_FOR_APPROVED_TITLES(string titles, string platforms, string Platform_Type, string CallFrom = "")
        {
            platforms = string.Join(",", platforms.Split(',').Where(p => p != "0"));
            string objList = "";
            if (titles != "" && titles != "0")
                objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_PlatformCodes_For_Ancillary(titles, "", "PL", objDeal_Schema.Deal_Code, "N", 0).FirstOrDefault();

            AllPlatform_Codes = objList;

            return true;
        }
        public PartialViewResult BindPlatformTreeView(string strPlatform, string strTitles, string IsBulk = "N")
        {
            if (!strPlatform.StartsWith("0") && strPlatform != string.Empty)
                strPlatform = "0," + strPlatform;
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            GET_DATA_FOR_APPROVED_TITLES(strTitles, "", "PL", "");

            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

            objPTV.PlatformCodes_Display = (AllPlatform_Codes == "") ? "0" : AllPlatform_Codes;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");

            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("~/Views/Shared/_TV_Platform.cshtml");
        }
        public PartialViewResult BindPlatformTreePopup(int acqDealAncillaryCode)
        {
            Syn_Deal_Ancillary objADR = new Syn_Deal_Ancillary_Service(objLoginEntity.ConnectionStringName).GetById(acqDealAncillaryCode);
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string strPlatform = string.Join(",", objADR.Syn_Deal_Ancillary_Platform.Select(s => s.Ancillary_Platform_code).ToArray());
            objPTV.PlatformCodes_Display = strPlatform;
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            objPTV.Show_Selected = true;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            ViewBag.TreeId = "Rights_List_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }
        #endregion
        #region --- Paging ---
        private List<USP_List_Syn_Ancillary_Result> Get_Paging_List(int txtpageSize, int PageNo)
        {
            List<USP_List_Syn_Ancillary_Result> lst = objDeal_Schema.List_Ancillary_Syn.SkipWhile(r => r.PageNo <= (PageNo - 1) * txtpageSize).ToList();
            var Count_Take = lst.GroupBy(i => i.Syn_Deal_Ancillary_Code).Select(Group => new { Count = Group.Count() });
            int[] arr = Count_Take.Select(i => i.Count).ToArray();
            int Count_Acq_Ancillary_Code = 0;
            int End_Index = arr.Count() < txtpageSize ? arr.Count() : txtpageSize;
            for (int i = 0; i < End_Index; i++) Count_Acq_Ancillary_Code = Count_Acq_Ancillary_Code + arr[i];
            return lst.Take(Count_Acq_Ancillary_Code).ToList();
        }
        private bool AssignPaging(int txtPageSize)
        {
            objDeal_Schema.Ancillary_PageSize = Convert.ToInt32(txtPageSize);
            int PageSize = Convert.ToInt32(txtPageSize);
            int Acq_Ancillary_Code = 0;
            int pNo = 0;
            objDeal_Schema.List_Ancillary_Syn.ForEach(r =>
            {
                if (Acq_Ancillary_Code != r.Syn_Deal_Ancillary_Code)
                {
                    Acq_Ancillary_Code = r.Syn_Deal_Ancillary_Code;
                    r.PageNo = pNo + 1;
                    pNo = r.PageNo ?? 0;
                }
                else
                    r.PageNo = pNo;
            });
            return true;
        }
        public int TotalPages { get; set; }
        #endregion
        #region --- Other Actions ---
        [HttpPost]
        public ActionResult ChangeTab(string hdnTabName)
        {
            ClearSession();
            obj_Ancillary_Platform_Medium = null;
            int PageNo = objDeal_Schema.PageNo;
            if (hdnTabName == "")
                objDeal_Schema = null;
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, PageNo, objDeal_Schema.Deal_Type_Code);
        }
        #endregion
        #region --- Other Methods ---
        private void ClearSession()
        {
            objDeal_Schema.List_Ancillary_Syn.Clear();
            objDeal_Schema.Ancillary_PageNo = 1;
            objDeal_Schema.Ancillary_PageSize = 10;
        }

        private string GetCatchUpConfig()
        {
            string isCatchUpRight = "N";
            System_Parameter_New objSPN = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Catch_UP_Rights").FirstOrDefault();
            if (objSPN != null)
                isCatchUpRight = objSPN.Parameter_Value;

            return isCatchUpRight;
        }
        #endregion
    }
}