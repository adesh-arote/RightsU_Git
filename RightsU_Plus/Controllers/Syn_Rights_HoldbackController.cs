using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_Rights_HoldbackController : BaseController
    {
        #region ============= SESSION DECLARATION ============
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
        public Rights_Page_Properties objPage_Properties
        {
            get
            {
                if (Session["Rights_Page_Properties"] == null)
                    Session["Rights_Page_Properties"] = new Rights_Page_Properties();
                return (Rights_Page_Properties)Session["Rights_Page_Properties"];
            }
            set { Session["Rights_Page_Properties"] = value; }
        }
        public string Title_Code
        {
            get
            {
                if (Session["Title_Code"] == null)
                    Session["Title_Code"] = "";
                return (string)Session["Title_Code"];
            }
            set { Session["Title_Code"] = value; }
        }
        #endregion
        public PartialViewResult Index()
        {
            //return View();
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Holdback.cshtml");
        }
        public JsonResult Bind_Ddl_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            var lst_HoldbackOnPlatform = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList();
            MultiSelectList HoldbackOnPlatform = new MultiSelectList(lst_HoldbackOnPlatform.Select(i => new { Display_Value = i.Platform_Code, Display_Text = i.Platform_Name + '~' + i.Platform_Hiearachy }),
                "Display_Value", "Display_Text");
            objJson.Add("HoldbackOnPlatform", HoldbackOnPlatform);
            return Json(objJson);
        }
        #region =============Validate Holdback ============
        private bool ValidateduplicateHoldback(string strSelectedPlatformCode, string strSelectedCountryTerritory_HBCode, string strTitleLanguage, string strSelectedSubTitling, string strSelectedubbing, Syn_Deal_Rights_Holdback objRHB)
        {
            bool IsValidate = true;
            string IsBreak = "N";
            int count = 0;
            string SynRightsHoldbackCode = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.EntityState == State.Deleted).Select(s => s.Syn_Deal_Rights_Holdback_Code));
            if (SynRightsHoldbackCode != "")
            {
                SynRightsHoldbackCode = SynRightsHoldbackCode + "," + objRHB.Syn_Deal_Rights_Holdback_Code.ToString();
            }
            else
            {
                SynRightsHoldbackCode = objRHB.Syn_Deal_Rights_Holdback_Code.ToString();
            }

            count = new USP_Service(objLoginEntity.ConnectionStringName).USP_Syn_Deal_Rights_Holdback_Validation(SynRightsHoldbackCode, strSelectedPlatformCode, strSelectedCountryTerritory_HBCode, Title_Code, objDeal_Schema.Deal_Type_Code, strTitleLanguage, strSelectedubbing, strSelectedSubTitling, objDeal_Schema.Rights_Is_Exclusive).FirstOrDefault().Rec_Count;
            if (count > 0)
            {
                IsBreak = "Y";
            }

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted).Count() > 0)
            {
                try
                {
                    var vHoldback = from Syn_Deal_Rights_Holdback objHB in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback
                                    where objHB != objRHB && objHB.EntityState != State.Deleted
                                    select objHB;

                    string[] arrSelectedPlatformCode = strSelectedPlatformCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    string[] arrSelectedCountryTerritoryCode = strSelectedCountryTerritory_HBCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    string[] arrSelectedSubTitling = strSelectedSubTitling.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    string[] arrSelectedDubbingCodes = strSelectedubbing.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);


                    foreach (Syn_Deal_Rights_Holdback objHB in vHoldback)
                    {
                        var arrWrapperPlatform = (from Syn_Deal_Rights_Holdback_Platform objPlatform in objHB.Syn_Deal_Rights_Holdback_Platform
                                                  where objPlatform.EntityState != State.Deleted
                                                  select objPlatform.Platform_Code.ToString()).ToArray();

                        var listCommon = arrWrapperPlatform.Where(arrSelectedPlatformCode.Contains);

                        if (listCommon.Count() > 0)
                        {
                            var arrWrapperCountryTerritory = (from Syn_Deal_Rights_Holdback_Territory objTerritory in objHB.Syn_Deal_Rights_Holdback_Territory where objTerritory.EntityState != State.Deleted select objTerritory.Country_Code.ToString()).ToArray();
                            var listCommonCountry = arrWrapperCountryTerritory.Where(arrSelectedCountryTerritoryCode.Contains);

                            if (listCommonCountry.Count() > 0)
                            {
                                if (strTitleLanguage == "Y" && objHB.Is_Original_Language == "Y")
                                {
                                    IsBreak = "Y";
                                    break;
                                }

                                if (arrSelectedSubTitling.Length > 0)
                                {
                                    var arrWrapperSubtitlingCodes = (from Syn_Deal_Rights_Holdback_Subtitling objSubTitling in objHB.Syn_Deal_Rights_Holdback_Subtitling where objSubTitling.EntityState != State.Deleted select objSubTitling.Language_Code.ToString()).ToArray();
                                    var listCommonSubtitling = arrWrapperSubtitlingCodes.Where(arrSelectedSubTitling.Contains);

                                    if (listCommonSubtitling.Count() > 0)
                                    {
                                        IsBreak = "Y";
                                        break;
                                    }
                                }

                                if (arrSelectedDubbingCodes.Length > 0)
                                {
                                    var arrWrapperDubbingCodes = (from Syn_Deal_Rights_Holdback_Dubbing objDubbing in objHB.Syn_Deal_Rights_Holdback_Dubbing where objDubbing.EntityState != State.Deleted select objDubbing.Language_Code.ToString()).ToArray();
                                    var listCommonDubbing = arrWrapperDubbingCodes.Where(arrSelectedDubbingCodes.Contains);
                                    if (listCommonDubbing.Count() > 0)
                                    {
                                        IsBreak = "Y";
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    if (IsBreak == "Y")
                        IsValidate = false;
                }
                catch (Exception e)
                { }

            }
            if (IsBreak == "Y")
                IsValidate = false;
            return IsValidate;
        }
        #endregion
        #region==================Edit Holdback=======================
        public PartialViewResult Edit_Holdback(string R_Type, string SL_Type, string DL_Type, string R_Code, string SL_Code, string DL_Code, string DummyProperty, string Titles, string Period, string IsTentative, string PeriodTerm, string strPlatform, string title_Code, string Is_Exclusive)
        {
            Title_Code = title_Code;
            ViewBag.CommandName_HB = GlobalParams.DEAL_MODE_EDIT;
            ViewBag.DummyProperty = DummyProperty;
            ViewBag.IsAddEditMode = "Y";
            objDeal_Schema.Rights_Is_Exclusive = Is_Exclusive;

            Syn_Deal_Rights_Holdback objSyn_Deal_Rights_Holdback = objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
            if (objSyn_Deal_Rights_Holdback != null)
            {
                objSyn_Deal_Rights_Holdback.Acq_Deal_Rights_Holdback_Code = 0;
                objSyn_Deal_Rights_Holdback.EntityState = State.Modified;
            }

            Syn_Deal_Rights_Holdback obj = objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
            if (obj != null)
            {
                Set_AllViewBag(obj, R_Type, SL_Type, DL_Type, R_Code, SL_Code, DL_Code, DummyProperty);
            }
            if (obj.Holdback_On_Platform_Code != null)
                ViewBag.HoldbackOnPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList(), "Platform_Code", "Platform_Name", obj.Holdback_On_Platform_Code.Value.ToString().Split(','));
            else
                ViewBag.HoldbackOnPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList(), "Platform_Code", "Platform_Name");

            if (obj.Holdback_On_Platform_Code != null)
            {
                ViewBag.Holdback_On_Platform_Code = obj.Holdback_On_Platform_Code.Value.ToString();
            }
            else
            {
                ViewBag.Holdback_On_Platform_Code = 0;
            }
            ViewBag.Title = Titles;
            ViewBag.Period = Period;
            ViewBag.IsTentative = IsTentative;
            ViewBag.PeriodTerm = PeriodTerm;
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string[] strSelectedPlatform = obj.Syn_Deal_Rights_Holdback_Platform.Where(t => t.EntityState != State.Deleted).Select(t => t.Platform_Code.ToString()).ToArray();
            objPTV.PlatformCodes_Display = strPlatform;
            objPTV.PlatformCodes_Selected = strSelectedPlatform;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");

            ViewBag.Key = "U";
            ViewBag.TreeId = "Rights_HB_Platform";
            ViewBag.TreeValueId = "hdnPlatform_Codes_HB";
            ViewBag.SelectedPlatForm = string.Join(",", strSelectedPlatform);
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Holdback_Popup.cshtml", obj);
        }
        #region==================Delete Holdback=======================
        public JsonResult Delete_Holdback(string DummyProperty)
        {
            string msg = "D";
            Syn_Deal_Rights_Holdback objRHB = objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
            objRHB.EntityState = State.Deleted;
            if (objRHB.Syn_Deal_Rights_Holdback_Code > 0)
                SetDeleteObject_HB(objRHB);
            else
                objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Remove(objRHB);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("status", msg);
            return Json(obj);
        }
        #endregion
        private void SetDeleteObject_HB(Syn_Deal_Rights_Holdback objRHB)
        {
            foreach (Syn_Deal_Rights_Holdback_Platform objADRHP in objRHB.Syn_Deal_Rights_Holdback_Platform) objADRHP.EntityState = State.Deleted;
            foreach (Syn_Deal_Rights_Holdback_Subtitling objADRS in objRHB.Syn_Deal_Rights_Holdback_Subtitling) objADRS.EntityState = State.Deleted;
            foreach (Syn_Deal_Rights_Holdback_Dubbing objADRHD in objRHB.Syn_Deal_Rights_Holdback_Dubbing) objADRHD.EntityState = State.Deleted;
            foreach (Syn_Deal_Rights_Holdback_Territory objADRHT in objRHB.Syn_Deal_Rights_Holdback_Territory) objADRHT.EntityState = State.Deleted;
        }
        #endregion
        #region==================Add Holdback=======================
        private void Set_AllViewBag(Syn_Deal_Rights_Holdback obj, string R_Type, string SL_Type, string DL_Type, string R_Code, string SL_Code, string DL_Code, string DummyProperty)
        {
            ViewBag.Territory_List_HB = R_Type == "G" || R_Type == "T" ? BindCountry_UsingTerritoryCodes_List(objSyn_Deal_Rights.Is_Theatrical_Right, obj.strCountryCodes, R_Code) : BindCountry_List(objSyn_Deal_Rights.Is_Theatrical_Right, obj.strCountryCodes, R_Code);
            int RCount = 0;
            if (obj.strCountryCodes.TrimEnd() != "")
                RCount = obj.strCountryCodes.Split(',').Count();
            ViewBag.RCount = RCount;
            int Selected_HB_Run_After_Release_Unit = (obj.HB_Run_After_Release_Units == null || obj.HB_Run_After_Release_Units == "") ? 0 : Convert.ToInt32(obj.HB_Run_After_Release_Units);
            ViewBag.HB_Run_After_Release_Unit = Bind_HB_Run_After_Release_Unit(Selected_HB_Run_After_Release_Unit);
            ViewBag.SL_List_HB = SL_Type == "SG" || SL_Type == "G" ? BindLang_UsingLangGroupCodes_List(obj.strSubtitlingCodes, SL_Code) : BindLanguage_List(obj.strSubtitlingCodes, SL_Code);
            ViewBag.DL_List_HB = DL_Type == "DG" || DL_Type == "G" ? BindLang_UsingLangGroupCodes_List(obj.strDubbingCodes, DL_Code) : BindLanguage_List(obj.strDubbingCodes, DL_Code);
        }
        public PartialViewResult Add_Holdback(string R_Type, string SL_Type, string DL_Type, string R_Code, string SL_Code, string DL_Code, string Titles, string Period, string IsTentative, string PeriodTerm, string strPlatform, string title_Code, string Is_Exclusive)
        {
            Title_Code = title_Code;
            ViewBag.CommandName_HB = "ADD";
            ViewBag.IsAddEditMode = "Y";
            Set_AllViewBag(new Syn_Deal_Rights_Holdback(), R_Type, SL_Type, DL_Type, R_Code, SL_Code, DL_Code, "");
            ViewBag.HoldbackOnPlatform = new MultiSelectList(new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Applicable_For_Holdback == "Y").ToList(), "Platform_Code", "Platform_Name");
            ViewBag.Title = Titles;
            ViewBag.Period = Period;
            ViewBag.IsTentative = IsTentative;
            ViewBag.PeriodTerm = PeriodTerm;
            ViewBag.Key = "A";
            ViewBag.Holdback_On_Platform_Code = "";
            objDeal_Schema.Rights_Is_Exclusive = Is_Exclusive;
            if (!string.IsNullOrEmpty(strPlatform))
            {
                Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
                objPTV.PlatformCodes_Display = strPlatform;
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
                ViewBag.DummyProperty = "0";
                ViewBag.TreeId = "Rights_HB_Platform";
                ViewBag.TreeValueId = "hdnPlatform_Codes_HB";
            }
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Holdback_Popup.cshtml", new Syn_Deal_Rights_Holdback());
        }
        #endregion
        #region==================Save Holdback=======================
        public JsonResult Save_Holdback(string hdnCounter, string hdnHoldback_Platform_Code, string Regions, string chk_Is_Title_Language_Right, string hdn_Sub_LanguageList, string hdn_Dubb_LanguageList, string HoldbackType, string HB_Run_After_Release_No, string lstReleaseUnit, string hdnHoldBackOnPlatform, string Holdback_Release_Date, string Holdback_Comment, int Acq_Deal_Rights_Holdback_Code = 0)
        {
            string msg = string.Empty;
            Syn_Deal_Rights_Holdback objRHB = null;
            if (hdnCounter != "0")
            {
                msg = "U";
                objRHB = objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.strDummyProp == hdnCounter).FirstOrDefault();
                if (objRHB.Syn_Deal_Rights_Holdback_Code > 0)
                    objRHB.EntityState = State.Modified;
            }
            else
            {
                objRHB = new Syn_Deal_Rights_Holdback();
                objRHB.EntityState = State.Added;
                msg = "A";
            }
            if (ValidateduplicateHoldback(hdnHoldback_Platform_Code, Regions, chk_Is_Title_Language_Right, hdn_Sub_LanguageList, hdn_Dubb_LanguageList, objRHB))
            {
                if (hdnHoldback_Platform_Code != "")
                {
                    hdnHoldback_Platform_Code = hdnHoldback_Platform_Code.Trim().Replace("_", "").Replace(" ", "").Replace("_0", "").Trim();
                    string[] PtCodes = hdnHoldback_Platform_Code.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Distinct().ToArray();
                    ICollection<Syn_Deal_Rights_Holdback_Platform> selectPlatformList = new HashSet<Syn_Deal_Rights_Holdback_Platform>();
                    foreach (string platformCode in PtCodes)
                    {
                        int pltCode = Convert.ToInt32(platformCode);
                        if (pltCode > 0)
                        {
                            Syn_Deal_Rights_Holdback_Platform objP = new Syn_Deal_Rights_Holdback_Platform();
                            objP.Platform_Code = Convert.ToInt32(platformCode);
                            objP.EntityState = State.Added;
                            selectPlatformList.Add(objP);
                        }
                    }

                    IEqualityComparer<Syn_Deal_Rights_Holdback_Platform> comparerSub = new LambdaComparer<Syn_Deal_Rights_Holdback_Platform>((x, y) => x.Platform_Code == y.Platform_Code && x.EntityState != State.Deleted);
                    var Deleted_Syn_Deal_Rights_Holdback_Platform = new List<Syn_Deal_Rights_Holdback_Platform>();
                    var Updated_Syn_Deal_Rights_Holdback_Platform = new List<Syn_Deal_Rights_Holdback_Platform>();
                    var Added_Syn_Deal_Rights_Holdback_Platform = CompareLists<Syn_Deal_Rights_Holdback_Platform>(selectPlatformList.ToList<Syn_Deal_Rights_Holdback_Platform>(), objRHB.Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>(), comparerSub, ref Deleted_Syn_Deal_Rights_Holdback_Platform, ref Updated_Syn_Deal_Rights_Holdback_Platform);
                    Added_Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(t => objRHB.Syn_Deal_Rights_Holdback_Platform.Add(t));
                    Deleted_Syn_Deal_Rights_Holdback_Platform.ToList<Syn_Deal_Rights_Holdback_Platform>().ForEach(t => t.EntityState = State.Deleted);
                }
                if (Regions != "")
                {
                    ICollection<Syn_Deal_Rights_Holdback_Territory> selectTerritoryList = new HashSet<Syn_Deal_Rights_Holdback_Territory>();
                    string[] countryCodes = Regions.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string platformCode in countryCodes)
                    {
                        Syn_Deal_Rights_Holdback_Territory objT = new Syn_Deal_Rights_Holdback_Territory();
                        objT.Country_Code = Convert.ToInt32(platformCode);
                        objT.Territory_Type = "I";
                        objT.EntityState = State.Added;
                        selectTerritoryList.Add(objT);
                    }

                    IEqualityComparer<Syn_Deal_Rights_Holdback_Territory> comparer_Territory = new LambdaComparer<Syn_Deal_Rights_Holdback_Territory>((x, y) => x.Country_Code == y.Country_Code && x.Territory_Type == y.Territory_Type && x.EntityState != State.Deleted);
                    var Deleted_Syn_Deal_Rights_Holdback_Territory = new List<Syn_Deal_Rights_Holdback_Territory>();
                    var Updated_Syn_Deal_Rights_Holdback_Territory = new List<Syn_Deal_Rights_Holdback_Territory>();
                    var Added_Syn_Deal_Rights_Holdback_Territory = CompareLists<Syn_Deal_Rights_Holdback_Territory>(selectTerritoryList.ToList<Syn_Deal_Rights_Holdback_Territory>(), objRHB.Syn_Deal_Rights_Holdback_Territory.ToList<Syn_Deal_Rights_Holdback_Territory>(), comparer_Territory, ref Deleted_Syn_Deal_Rights_Holdback_Territory, ref Updated_Syn_Deal_Rights_Holdback_Territory);
                    Added_Syn_Deal_Rights_Holdback_Territory.ToList<Syn_Deal_Rights_Holdback_Territory>().ForEach(t => objRHB.Syn_Deal_Rights_Holdback_Territory.Add(t));
                    Deleted_Syn_Deal_Rights_Holdback_Territory.ToList<Syn_Deal_Rights_Holdback_Territory>().ForEach(t => t.EntityState = State.Deleted);
                }


                ICollection<Syn_Deal_Rights_Holdback_Subtitling> selectSubtitlingList = new HashSet<Syn_Deal_Rights_Holdback_Subtitling>();
                if (!string.IsNullOrEmpty(hdn_Sub_LanguageList))
                {
                    string[] subtitlingCodes = hdn_Sub_LanguageList.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string languageCode in subtitlingCodes)
                    {
                        Syn_Deal_Rights_Holdback_Subtitling objSL = new Syn_Deal_Rights_Holdback_Subtitling();
                        objSL.Language_Code = Convert.ToInt32(languageCode);
                        objSL.EntityState = State.Added;
                        selectSubtitlingList.Add(objSL);
                    }
                }

                IEqualityComparer<Syn_Deal_Rights_Holdback_Subtitling> comparer_Subtitling = new LambdaComparer<Syn_Deal_Rights_Holdback_Subtitling>((x, y) => x.Language_Code == y.Language_Code && x.EntityState != State.Deleted);
                var Deleted_Syn_Deal_Rights_Holdback_Subtitling = new List<Syn_Deal_Rights_Holdback_Subtitling>();
                var Updated_Syn_Deal_Rights_Holdback_Subtitling = new List<Syn_Deal_Rights_Holdback_Subtitling>();
                var Added_Syn_Deal_Rights_Holdback_Subtitling = CompareLists<Syn_Deal_Rights_Holdback_Subtitling>(selectSubtitlingList.ToList<Syn_Deal_Rights_Holdback_Subtitling>(), objRHB.Syn_Deal_Rights_Holdback_Subtitling.ToList<Syn_Deal_Rights_Holdback_Subtitling>(), comparer_Subtitling, ref Deleted_Syn_Deal_Rights_Holdback_Subtitling, ref Updated_Syn_Deal_Rights_Holdback_Subtitling);
                Added_Syn_Deal_Rights_Holdback_Subtitling.ToList<Syn_Deal_Rights_Holdback_Subtitling>().ForEach(t => objRHB.Syn_Deal_Rights_Holdback_Subtitling.Add(t));
                Deleted_Syn_Deal_Rights_Holdback_Subtitling.ToList<Syn_Deal_Rights_Holdback_Subtitling>().ForEach(t => t.EntityState = State.Deleted);

                ICollection<Syn_Deal_Rights_Holdback_Dubbing> selectDubbingList = new HashSet<Syn_Deal_Rights_Holdback_Dubbing>();
                if (!string.IsNullOrEmpty(hdn_Dubb_LanguageList))
                {
                    string[] dubbingCodes = hdn_Dubb_LanguageList.Trim(',').Split(new char[] { ',' }, StringSplitOptions.None);
                    foreach (string languageCode in dubbingCodes)
                    {
                        Syn_Deal_Rights_Holdback_Dubbing objDL = new Syn_Deal_Rights_Holdback_Dubbing();
                        objDL.Language_Code = Convert.ToInt32(languageCode);
                        objDL.EntityState = State.Added;
                        selectDubbingList.Add(objDL);
                    }
                }
                IEqualityComparer<Syn_Deal_Rights_Holdback_Dubbing> comparerDub = new LambdaComparer<Syn_Deal_Rights_Holdback_Dubbing>((x, y) => x.Language_Code == y.Language_Code && x.EntityState != State.Deleted);
                var Deleted_Syn_Deal_Rights_Holdback_Dubbing = new List<Syn_Deal_Rights_Holdback_Dubbing>();
                var Updated_Syn_Deal_Rights_Holdback_Dubbing = new List<Syn_Deal_Rights_Holdback_Dubbing>();
                var Added_Syn_Deal_Rights_Holdback_Dubbing = CompareLists<Syn_Deal_Rights_Holdback_Dubbing>(selectDubbingList.ToList<Syn_Deal_Rights_Holdback_Dubbing>(), objRHB.Syn_Deal_Rights_Holdback_Dubbing.ToList<Syn_Deal_Rights_Holdback_Dubbing>(), comparerDub, ref Deleted_Syn_Deal_Rights_Holdback_Dubbing, ref Updated_Syn_Deal_Rights_Holdback_Dubbing);
                Added_Syn_Deal_Rights_Holdback_Dubbing.ToList<Syn_Deal_Rights_Holdback_Dubbing>().ForEach(t => objRHB.Syn_Deal_Rights_Holdback_Dubbing.Add(t));
                Deleted_Syn_Deal_Rights_Holdback_Dubbing.ToList<Syn_Deal_Rights_Holdback_Dubbing>().ForEach(t => t.EntityState = State.Deleted);



                objRHB.Is_Original_Language = chk_Is_Title_Language_Right;
                objRHB.Holdback_Type = HoldbackType;
                objRHB.HB_Run_After_Release_No = null;
                objRHB.HB_Run_After_Release_Units = null;
                objRHB.Holdback_On_Platform_Code = null;
                objRHB.Holdback_Release_Date = null;
                if (Acq_Deal_Rights_Holdback_Code > 0)
                {
                    objRHB.Acq_Deal_Rights_Holdback_Code = Acq_Deal_Rights_Holdback_Code;
                }

                if (HoldbackType == "R")
                {
                    if (!string.IsNullOrEmpty(HB_Run_After_Release_No))
                        objRHB.HB_Run_After_Release_No = Convert.ToInt32(HB_Run_After_Release_No);
                    objRHB.HB_Run_After_Release_Units = lstReleaseUnit;
                    if (!string.IsNullOrEmpty(hdnHoldBackOnPlatform))
                        objRHB.Holdback_On_Platform_Code = Convert.ToInt32(hdnHoldBackOnPlatform);
                }
                else
                {
                    if (Holdback_Release_Date != "")
                        objRHB.Holdback_Release_Date = Convert.ToDateTime(Holdback_Release_Date);
                }
                objRHB.Holdback_Comment = Holdback_Comment;
                objRHB.Syn_Deal_Rights_Code = objSyn_Deal_Rights.Syn_Deal_Rights_Code;
                if (hdnCounter == "0")
                    objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Add(objRHB);
            }
            else
                msg = "D";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", msg);
            return Json(obj);
        }

        public JsonResult CopyHoldbackFromAcq(string HoldbackCode)
        {
            string[] arrHBCode = HoldbackCode.Split(',');
            List<Acq_Deal_Rights_Holdback> objAcq_Deal_Rights_Holdback = new Acq_Deal_Rights_Holdback_Service(objLoginEntity.ConnectionStringName).SearchFor(i => arrHBCode.Contains(i.Acq_Deal_Rights_Holdback_Code.ToString())).ToList();
            JsonResult j = new JsonResult();
            string Region_Type = Convert.ToString(Session["Region_Type"]);
            string Sub_Type = Convert.ToString(Session["Sub_Type"]);
            string Dub_Type = Convert.ToString(Session["Dub_Type"]);
            string Title_Codes = Convert.ToString(Session["Title_Codes"]);
            string Platform_Codes = Convert.ToString(Session["Platform_Codes"]);
            string Region_Codes = Convert.ToString(Session["Region_Codes"]);

            string Sub_Codes = Convert.ToString(Session["Sub_Codes"]);
            string Dub_Codes = Convert.ToString(Session["Dub_Codes"]);
            string Start_Date = Convert.ToString(Session["Start_Date"]);
            string End_Date = Convert.ToString(Session["End_Date"]);
            bool IsExclusive = Convert.ToBoolean(Session["IsExclusive"]);
            bool IsTitleLanguageRight = Convert.ToBoolean(Session["IsTitleLanguageRight"]);

            if (Region_Type == "G") // Territory type
                Region_Codes = string.Join(",", new Territory_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(p => Region_Codes.Contains(p.Territory_Code.ToString())).Select(p => p.Country_Code));

            if (Sub_Type == "G")
                Sub_Codes = string.Join(",", new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(i => Sub_Codes.Contains(i.Language_Group_Code.ToString()))
                                                                         .SelectMany(s => s.Language_Group_Details.Select(R => R.Language_Code)).Distinct().ToArray());
            if (Dub_Type == "G")
                Dub_Codes = string.Join(",", new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Language_Group_Details.Any(a => Dub_Codes.Contains(a.Language_Group_Code.ToString())))
                    .SelectMany(s => s.Language_Group_Details.Select(R => R.Language_Code)).Distinct().ToArray());

            for (int i = 0; i < objAcq_Deal_Rights_Holdback.Count; i++)
            {
                string acq_HB_Platform_Code = string.Join(",", objAcq_Deal_Rights_Holdback[i].Acq_Deal_Rights_Holdback_Platform.Where(p => Platform_Codes.Split(',').Contains(p.Platform_Code.ToString())).Select(p => p.Platform_Code.ToString()));
                string acq_HB_Region_Code = string.Join(",", objAcq_Deal_Rights_Holdback[i].Acq_Deal_Rights_Holdback_Territory.Where(p => Region_Codes.Split(',').Contains(p.Country_Code.ToString())).Select(p => p.Country_Code.ToString()));
                string acq_HB_SubTitle_Code = string.Join(",", objAcq_Deal_Rights_Holdback[i].Acq_Deal_Rights_Holdback_Subtitling.Where(p => Sub_Codes.Split(',').Contains(p.Language_Code.ToString())).Select(p => p.Language_Code.ToString()));
                string acq_HB_Dubbing_Code = string.Join(",", objAcq_Deal_Rights_Holdback[i].Acq_Deal_Rights_Holdback_Dubbing.Where(p => Dub_Codes.Split(',').Contains(p.Language_Code.ToString())).Select(p => p.Language_Code.ToString()));

                j = Save_Holdback("0",
                    acq_HB_Platform_Code,
                    acq_HB_Region_Code,
                    objAcq_Deal_Rights_Holdback[i].Is_Title_Language_Right,
                    acq_HB_SubTitle_Code,
                    acq_HB_Dubbing_Code,
                    objAcq_Deal_Rights_Holdback[i].Holdback_Type,
                    Convert.ToString(objAcq_Deal_Rights_Holdback[i].HB_Run_After_Release_No), objAcq_Deal_Rights_Holdback[i].HB_Run_After_Release_Units,
                    Convert.ToString(objAcq_Deal_Rights_Holdback[i].Holdback_On_Platform_Code),
                    Convert.ToString(objAcq_Deal_Rights_Holdback[i].Holdback_Release_Date), objAcq_Deal_Rights_Holdback[i].Holdback_Comment, Convert.ToInt32(objAcq_Deal_Rights_Holdback[i].Acq_Deal_Rights_Holdback_Code));
            }

            Session["HoldbackAdded"] = "Y";

            return Json(j, JsonRequestBehavior.AllowGet);
        }
        #endregion
        #region===============Bind Dropdown==============
        public PartialViewResult BindPlatform_HB(string hdnPlatform_Codes_HB = "", string dummyProperty = "0", string CallFrom = "")
        {
            SetPlatform_HB(hdnPlatform_Codes_HB, dummyProperty, CallFrom);
            return PartialView("~/Views/Shared/_TV_Platform.cshtml");
        }
        private void SetPlatform_HB(string hdnPlatform_Codes_HB, string dummyProperty, string CallFrom)
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            string strPlatform = "";
            if (CallFrom != "LIST")
            {
                strPlatform = string.Join(",", objSyn_Deal_Rights.Syn_Deal_Rights_Platform.Where(t => t.EntityState != State.Deleted).Select(t => t.Platform_Code.ToString()));
                objPTV.PlatformCodes_Selected = hdnPlatform_Codes_HB.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                objPTV.PlatformCodes_Display = strPlatform;
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            }
            else
            {
                objPTV.PlatformCodes_Selected = hdnPlatform_Codes_HB.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                objPTV.Show_Selected = true;
                objPTV.PlatformCodes_Display = hdnPlatform_Codes_HB;
                ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
            }

            ViewBag.TreeId = "Rights_HB_Platform_View";
            ViewBag.TreeValueId = "hdnPlatform_Codes_HB_View";
        }

        public PartialViewResult BindHoldback()
        {
            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_VIEW || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.CommandName_HB = objPage_Properties.RMODE;
            else
                ViewBag.CommandName_HB = "LIST";

            if (objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted && t.Is_Original_Language == "Y").Count() > 0)
                ViewBag.Title_Language_Added_For_Holdback = "Y";
            else
                ViewBag.Title_Language_Added_For_Holdback = "N";

            objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(t => t.EntityState != State.Deleted);
            ViewBag.HoldbackCount = objSyn_Deal_Rights.Syn_Deal_Rights_Holdback.Where(w => w.EntityState != State.Deleted).Count();
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Holdback.cshtml", new Syn_Deal_Rights_Holdback());
        }

        private MultiSelectList BindCountry_List(string Is_Thetrical = "N", string Selected_Country_Code = "", string Search_Country_Code = "")
        {
            string[] arr = new string[] { "" };
            if (Search_Country_Code != null && Search_Country_Code.Trim() != "")
                arr = Search_Country_Code.Split(',');
            MultiSelectList arr_Title_List = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(i => (i.Is_Active == "Y" && i.Is_Theatrical_Territory == Is_Thetrical) && (arr.Contains(i.Country_Code.ToString())))
                .Select(i => new { Country_Code = i.Country_Code, Country_Name = i.Country_Name }).ToList(), "Country_Code", "Country_Name", Selected_Country_Code.Split(','));
            return arr_Title_List;
        }
        private MultiSelectList BindCountry_UsingTerritoryCodes_List(string Is_Thetrical = "N", string Selected_Country_Code = "", string Search_Territory_Code = "")
        {
            string[] arr_Terr = new string[] { "" };
            if (Search_Territory_Code != null && Search_Territory_Code.Trim() != "")
                arr_Terr = Search_Territory_Code.Split(',');
            MultiSelectList arr_country = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName)
                                                                .SearchFor(x =>
                                                                            x.Territory_Details
                                                                            .Any(y => y.Country_Code == x.Country_Code && arr_Terr
                                                                            .Contains(y.Territory_Code.ToString()))
                                                                            && x.Is_Theatrical_Territory == Is_Thetrical
                                                                           )
                                                                .Select(i => new { Country_Code = i.Country_Code, Country_Name = i.Country_Name })
                                                                .OrderBy(t => t.Country_Name).ToList(), "Country_Code", "Country_Name", Selected_Country_Code.Split(',')
                                                                );
            return arr_country;
        }
        private MultiSelectList BindLang_UsingLangGroupCodes_List(string Selected_Language_Code = "", string Search_Lang_Code = "")
        {
            string[] arr_Language_Group_Code = new string[] { "" };
            if (Search_Lang_Code != null && Search_Lang_Code.Trim() != "")
                arr_Language_Group_Code = Search_Lang_Code.Split(',');
            MultiSelectList arr_lang = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName)
                                 .SearchFor(x => x.Language_Group_Details
                                             .Any(y => y.Language_Code == x.Language_Code && arr_Language_Group_Code.Contains(y.Language_Group_Code.ToString()))
                                           )
                                 .Select(i => new { Language_Code = i.Language_Code, Language_Name = i.Language_Name })
                                 .OrderBy(t => t.Language_Name).ToList(), "Language_Code", "Language_Name", Selected_Language_Code.Split(',')
                                 );
            return arr_lang;
        }
        private MultiSelectList BindLanguage_List(string Selected_Language_Code = "", string Search_Lang_Code = "")
        {
            string[] arr = new string[] { "" };
            if (Search_Lang_Code != null && Search_Lang_Code.Trim() != "")
                arr = Search_Lang_Code.Split(',');
            MultiSelectList arr_Title_List = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(i => (i.Is_Active == "Y") &&
                (arr.Contains(i.Language_Code.ToString()))).
                Select(i => new { Language_Code = i.Language_Code, Language_Name = i.Language_Name }).ToList(), "Language_Code", "Language_Name", Selected_Language_Code.Split(','));
            return arr_Title_List;
        }
        private SelectList Bind_HB_Run_After_Release_Unit(int selected_HB_Run_After_Release_Unit)
        {
            return new SelectList(new[]
                {
                    new { ID = "0", Name = "--Select--" },
                    new { ID = "1", Name = "Days" },
                    new { ID = "2", Name = "Weeks" },
                    new { ID = "3", Name = "Months"},
                    new { ID = "4", Name = "Years"}
                },
           "ID", "Name", selected_HB_Run_After_Release_Unit);
        }

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult, ref List<T> UPResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            var UpdateResult = FirstList.Except(DeleteResult, comparer);
            var Modified_Result = UpdateResult.Except(AddResult);

            DelResult = DeleteResult.ToList<T>();
            UPResult = Modified_Result.ToList<T>();

            return AddResult.ToList<T>();
        }
        #endregion
        public void ClearHoldbackGrid(string Is_Theatrical)
        {
            objSyn_Deal_Rights.Is_Theatrical_Right = Is_Theatrical;
            foreach (Syn_Deal_Rights_Holdback objADRH in objSyn_Deal_Rights.Syn_Deal_Rights_Holdback)
            {
                SetDeleteObject_HB(objADRH);
                objADRH.EntityState = State.Deleted;
            }
        }


    }
}
