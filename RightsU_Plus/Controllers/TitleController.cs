﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Text.RegularExpressions;
using OfficeOpenXml;
using System.Data.Entity.Core.Objects;
using System.Drawing;

namespace RightsU_Plus.Controllers
{
    public class TitleController : BaseController
    {
        string _fieldList = "";
        #region --- Properties ---
        // GET: /Title/
        public List<Map_Extended_Columns> lstMapExtendedColumns
        {
            get
            {
                if (Session["lstMapExtendedColumns"] == null)
                    Session["lstMapExtendedColumns"] = new List<Map_Extended_Columns>();
                return (List<Map_Extended_Columns>)Session["lstMapExtendedColumns"];
            }
            set
            {
                Session["lstMapExtendedColumns"] = value;
            }

        }

        public List<Map_Extended_Columns> lstDeletedExtendedColumns
        {
            get
            {
                if (Session["lstDeletedExtendedColumns"] == null)
                    Session["lstDeletedExtendedColumns"] = new List<Map_Extended_Columns>();
                return (List<Map_Extended_Columns>)Session["lstDeletedExtendedColumns"];
            }
            set
            {
                Session["lstDeletedExtendedColumns"] = value;
            }

        }

        public List<USP_Title_Deal_Info_Result> lst_Deal_Info
        {
            get
            {
                if (Session["lst_Deal_Info"] == null)
                    Session["lst_Deal_Info"] = new List<USP_Title_Deal_Info_Result>();
                return (List<USP_Title_Deal_Info_Result>)Session["lst_Deal_Info"];
            }
            set
            {
                Session["lst_Deal_Info"] = value;
            }
        }

        //USP_Title_Deal_Info_Result
        public string Message
        {
            get
            {
                if (Session["Message"] == null)
                    Session["Message"] = string.Empty;
                return (string)Session["Message"];
            }
            set { Session["Message"] = value; }
        }

        public int? ExtendedColumnsCode
        {
            get
            {
                if (Session["ExtendedColumnCode"] == null)
                    Session["ExtendedColumnCode"] = 0;
                return (int)Session["ExtendedColumnCode"];
            }
            set { Session["ExtendedColumnCode"] = value; }
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

        public List<Map_Extended_Columns> lstDBExtendedColumns
        {
            get
            {
                if (Session["lstDBExtendedColumns"] == null)
                    Session["lstDBExtendedColumns"] = new List<Map_Extended_Columns>();
                return (List<Map_Extended_Columns>)Session["lstDBExtendedColumns"];
            }
            set
            {
                Session["lstDBExtendedColumns"] = value;
            }

        }

        List<USP_Bind_Extend_Column_Grid_Result> gvExtended
        {
            get
            {
                if (Session["gvExtended"] == null)
                    Session["gvExtended"] = new List<USP_Bind_Extend_Column_Grid_Result>();
                return (List<USP_Bind_Extend_Column_Grid_Result>)Session["gvExtended"];
            }
            set
            {
                Session["gvExtended"] = value;
            }

        }

        public RightsU_Entities.Title objTitle
        {
            get
            {
                if (Session["Session_Title"] == null)
                    Session["Session_Title"] = new RightsU_Entities.Title();
                return (RightsU_Entities.Title)Session["Session_Title"];
            }
            set { Session["Session_Title"] = value; }
        }


        public Title_Service objTitleS
        {
            get
            {
                if (Session["objTitleS_Service"] == null)
                    Session["objTitleS_Service"] = new Title_Service(objLoginEntity.ConnectionStringName);
                return (Title_Service)Session["objTitleS_Service"];
            }
            set { Session["objTitleS_Service"] = value; }
        }

        public Map_Extended_Columns_Service objMapExtCol_Service
        {
            get
            {
                if (Session["objMapExtCol_Service"] == null)
                    Session["objMapExtCol_Service"] = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName);
                return (Map_Extended_Columns_Service)Session["objMapExtCol_Service"];
            }
            set { Session["objMapExtCol_Service"] = value; }
        }
        public RightsU_Entities.Title_Alternate objTitleAlternate
        {
            get
            {
                if (Session["Session_Title_Alternate"] == null)
                    Session["Session_Title_Alternate"] = new RightsU_Entities.Title_Alternate();
                return (RightsU_Entities.Title_Alternate)Session["Session_Title_Alternate"];
            }
            set { Session["Session_Title_Alternate"] = value; }
        }
        public Title_Alternate_Service objTitleS_Alternate
        {
            get
            {
                if (Session["objTitleS_Alternate_Service"] == null)
                    Session["objTitleS_Alternate_Service"] = new Title_Alternate_Service(objLoginEntity.ConnectionStringName);
                return (Title_Alternate_Service)Session["objTitleS_Alternate_Service"];
            }
            set { Session["objTitleS_Alternate_Service"] = value; }
        }

        public string mode
        {
            get
            {
                if (Session["mode"] == null || Session["mode"] == "E")
                    mode = "E";
                return (string)Session["mode"];
            }
            set { Session["mode"] = value; }
        }

        public string Deal_Type_Code_EDIT
        {
            get
            {
                if (Session["Deal_Type_Code_EDIT"] == null || Session["Deal_Type_Code_EDIT"] == "")
                    Deal_Type_Code_EDIT = "0";
                return (string)Session["Deal_Type_Code_EDIT"];
            }
            set { Session["Deal_Type_Code_EDIT"] = value; }
        }

        public string SearchedTitle_EDIT
        {
            get
            {
                if (Session["SearchedTitle_EDIT"] == null)
                    Session["SearchedTitle_EDIT"] = "";
                return (string)Session["SearchedTitle_EDIT"];
            }
            set { Session["SearchedTitle_EDIT"] = value; }
        }

        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = "1";
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }
        public int? ConfigCode
        {
            get
            {
                if (Session["ConfigCode"] == null)
                    Session["ConfigCode"] = "1";
                return (int)Session["ConfigCode"];
            }
            set { Session["ConfigCode"] = value; }
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

        private List<RightsU_Entities.Title_Episode_Details> lstEpisodeDetails
        {
            get
            {
                if (Session["lstEpisodeDetails"] == null)
                    Session["lstEpisodeDetails"] = new List<RightsU_Entities.Title_Episode_Details>();
                return (List<RightsU_Entities.Title_Episode_Details>)Session["lstEpisodeDetails"];
            }
            set { Session["lstEpisodeDetails"] = value; }
        }
        #endregion

        public ActionResult Index(int id = 0, string Type = "", int Page_No = 0, string DealTypeCode = "0", string SearchedTitle = "", int PageSize = 10)
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTitle);
            var IsTitleDurationMandatory = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "IsTitleDurationMandatory").Select(w => w.Parameter_Value).SingleOrDefault();
            ViewBag.IsTitleDurationMandatory = IsTitleDurationMandatory;
            if (id == 0)
            {
                id = Convert.ToInt32(TempData["id"]);
                Type = TempData["Type"].ToString();
                Page_No = Convert.ToInt32(TempData["PageNo"]);
            }
            Message = string.Empty;
            Session["gvExtended"] = null;
            Session["lstMapExtendedColumns"] = null;
            Session["lstAddedExtendedColumns"] = null;
            Session["lstDBExtendedColumns"] = null;
            Session["Session_Title"] = null;
            Session["objMapExtCol_Service"] = null;
            Session["mode"] = null;
            lst_Deal_Info = null;
            recordPerPage = PageSize;

            mode = "E";
            PageNo = Page_No;
            ViewBag.PageNo = PageNo;
            ViewBag.DealTypeCode = DealTypeCode;
            Deal_Type_Code_EDIT = DealTypeCode;
            ViewBag.SearchedTitle = SearchedTitle;
            ViewBag.PageSize = PageSize;
            ViewBag.TitleReleaseCount = 10;
            ViewBag.TitleReleasePageNo = 1;
            if (TempData["RecodLockingCode"] == "" || TempData["RecodLockingCode"] == null)
                ViewBag.RecordLockingCode = 0;
            else
                ViewBag.RecordLockingCode = TempData["RecodLockingCode"];
            TempData.Keep("RecodLockingCode");
            if (TempData["TabName"] != null)
            {
                ViewBag.Tabname = TempData["TabName"];
                ViewBag.AlternateCode = TempData["AlternateConfigCode"];
            }
            else
            {
                ViewBag.Tabname = "";
                ViewBag.AlternateCode = "";

            }

            SearchedTitle_EDIT = SearchedTitle;
            objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(id);
            lstEpisodeDetails = objTitle.Title_Episode_Details.ToList();
            Binddl();
            ViewBag.CommandName = Type;
            if (Type == "E")
            {
                int[] alternateConfigCode = new Alternate_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Display_Order).Select(x => x.Alternate_Config_Code).ToArray();
                ViewBag.PartialTabList = alternateConfigCode;
            }
            else
            {
                ViewBag.PartialTabList = null;
            }
            // ViewBag.IsFirstTime = "Y";
            Fillddl();
            return View(objTitle);
        }

        //[HttpPost]
        public ActionResult View(int id = 0, string Type = "", int Page_No = 0, string DealTypeCode = "0", string SearchedTitle = "", string key = "", int PageSize = 10)
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTitle);
            ViewBag.IsCalculatePublicDomain = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "IsCalculatePublicDomain").Select(w => w.Parameter_Value).FirstOrDefault();
            if (key != "fromTitle")
            {
                Session["gvExtended"] = null;
                Session["lstMapExtendedColumns"] = null;
                Session["lstAddedExtendedColumns"] = null;
                Session["lstDBExtendedColumns"] = null;
                Session["Session_Title"] = null;
                Session["objMapExtCol_Service"] = null;
                Session["mode"] = null;
                lst_Deal_Info = null;
            }

            if (TempData["TitleData"] != null)
            {
                Dictionary<string, string> obj_Dictionary_Title = new Dictionary<string, string>();
                obj_Dictionary_Title = TempData["TitleData"] as Dictionary<string, string>;

                id = Convert.ToInt32(obj_Dictionary_Title["id"]);
                Type = "V";
                Page_No = Convert.ToInt32(obj_Dictionary_Title["TitlePage_No"]);
                DealTypeCode = obj_Dictionary_Title["DealTypeCode"];
                SearchedTitle = obj_Dictionary_Title["SearchedTitle"];
                PageSize = Convert.ToInt32(obj_Dictionary_Title["TitlePageSize"]);
                ViewBag.DealListPageNo = Convert.ToInt32(obj_Dictionary_Title["DealListPageNo"]);
                ViewBag.DealListPageSize = Convert.ToInt32(obj_Dictionary_Title["DealListPageSize"]);
                TempData["TitleData"] = null;
            }

            Fillddl();
            if (Type == "R")
            {
                ViewBag.RecordLockingCode_View = TempData["RecodLockingCode"];
                TempData.Keep("RecodLockingCode");
                //Fillddl();
            }
            else
                ViewBag.RecordLockingCode_View = 0;
            objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(id);
            lstEpisodeDetails = objTitle.Title_Episode_Details.ToList();
            mode = "V";
            PageNo = Page_No;
            ViewBag.PageNo = PageNo;
            ViewBag.DealTypeCode = DealTypeCode;
            ViewBag.SearchedTitle = SearchedTitle;
            TempData["Page_No"] = PageNo;
            TempData["SearchedTitle"] = SearchedTitle;
            ViewBag.PageSize = PageSize;
            ViewBag.Mode = Type;
            Binddl();
            int?[] alternateConfigCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objTitle.Title_Code).OrderBy(x => x.Alternate_Config.Display_Order).Select(x => x.Alternate_Config_Code).ToArray();

            int titleAlternateCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objTitle.Title_Code).Select(x => x.Title_Alternate_Code).FirstOrDefault();
            if (titleAlternateCode != 0)
            {
                ViewBag.PartialTabList = alternateConfigCode;
                ViewBag.IsFirstTime = "Y";
            }
            else
            {
                ViewBag.PartialTabList = null;
                ViewBag.IsFirstTime = "Y";
            }
            ViewBag.TheatricalPlatformCode = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "THEATRICAL_PLATFORM_CODE")
                .First().Parameter_Value;

            if (objTitle.Original_Language_Code > 0)
                ViewBag.OriginalLanguage = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(e => e.Language_Code == objTitle.Original_Language_Code).Select(i => new { i.Language_Name });
            else
                ViewBag.OriginalLanguage = "No Original Langauge";

            string Per_Logic = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Allow_Perpetual_Date_Logic_Title").FirstOrDefault().Parameter_Value;

            ViewBag.TitleTypeEpisodeTab = objTitle.Deal_Type_Code;
            ViewBag.IsView = "Y";
            if (Per_Logic == "Y")
            {
                return View("~/Views/Title/View_Release.cshtml", objTitle);
            }
            return View(objTitle);
        }

        public void Binddl()
        {
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT,LA,C,G,P,DR,S,RL,O", 0, 0, "").ToList();

            //Title Type
            ViewBag.DealTypeList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DT"), "Display_Value", "Display_Text").ToList();

            //Title Language

            ViewBag.LanguageList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "LA"), "Display_Value", "Display_Text", objTitle.Title_Code).ToList();

            //Original Language
            ViewBag.OriginalLanguageList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "LA"), "Display_Value", "Display_Text").ToList();

            //Role Language
            ViewBag.RolesList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "RL"), "Display_Value", "Display_Text").ToList();

            //Country
            var Country_codes = string.Join(",", (objTitle.Title_Country.Where(i => i.Title_Code == objTitle.Title_Code).Select(i => i.Country_Code).ToList()));
            if (Country_codes == "" || Country_codes == null)
            {
                int Original_Country_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_CountryOfOrigin").Select(i => i.Parameter_Value).FirstOrDefault());
                Country_codes = Original_Country_code + "";
            }
            var lstCountry = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "C"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();

            //Producer 
            var lstProducer = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "P"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var producer_code = string.Join(",", (objTitle.Title_Talent.Where(i => i.Title_Code == objTitle.Title_Code && i.Role_Code == GlobalParams.Role_code_Producer).Select(i => i.Talent_Code).ToList()));

            //Director 
            var lstDirector = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DR"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var Director_code = string.Join(",", (objTitle.Title_Talent.Where(i => i.Title_Code == objTitle.Title_Code && i.Role_Code == GlobalParams.RoleCode_Director).Select(i => i.Talent_Code).ToList()));

            //StarCast
            var lstStarCast = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "S"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var StarCast_code = string.Join(",", (objTitle.Title_Talent.Where(i => i.Title_Code == objTitle.Title_Code && i.Role_Code == GlobalParams.RoleCode_StarCast).Select(i => i.Talent_Code).ToList()));

            //Program
            RightsU_Entities.Title obj = objTitleS.GetById(objTitle.Title_Code);
            if (obj.Program_Code > 0)
                ViewBag.ProgramList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "O"), "Display_Value", "Display_Text", obj.Program_Code).ToList();
            else
                ViewBag.ProgramList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "O"), "Display_Value", "Display_Text").ToList();

            if (mode == "V")
            {
                if (producer_code != "")
                {
                    var producernames = string.Join(", ", (lstProducer.Where(y => producer_code.Split(',').Contains(y.Value.ToString())).Distinct().Select(i => i.Text)));
                    ViewBag.ProduceList = producernames.Trim(',');
                }
                else
                    ViewBag.ProduceList = "";

                if (Director_code != "")
                {
                    var Directornames = string.Join(", ", (lstDirector.Where(y => Director_code.Split(',').Contains(y.Value.ToString())).Distinct().Select(i => i.Text)));
                    ViewBag.DirectorList = Directornames.Trim(',');
                }
                else
                    ViewBag.DirectorList = "";

                if (StarCast_code != "")
                {
                    var StarCastnames = string.Join(", ", (lstStarCast.Where(y => StarCast_code.Split(',').Contains(y.Value.ToString())).Distinct().Select(i => i.Text)));
                    ViewBag.StarCastList = StarCastnames.Trim(',');
                }
                else
                    ViewBag.StarCastList = "";


                if (Country_codes != "")
                {
                    string[] arrCountryCodes = Country_codes.Split(',');
                    ViewBag.CountryList = string.Join(",", lstCountry.Where(y => arrCountryCodes.Contains(y.Value.ToString())).Distinct().OrderBy(x => x.Text).Select(i => i.Text)).Trim(',');
                }
                else
                    ViewBag.CountryList = "";

                var Label_code = objTitle.Music_Label_Code;
                if (Label_code != 0 && Label_code != null)
                {
                    ViewBag.MusicLabelList = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Music_Label_Code == Label_code)
                        .FirstOrDefault().Music_Label_Name;
                }
                else
                    ViewBag.MusicLabelList = "";

                var Geners_code = string.Join(",", (objTitle.Title_Geners.Where(i => i.Title_Code == objTitle.Title_Code).Select(i => i.Genres_Code).ToList()));
                if (Geners_code != "")
                {
                    var lstGenere = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G"), "Display_Value", "Display_Text", Geners_code.Split(',')).ToList();
                    var lstGenersNames = string.Join(", ", (lstGenere.Where(y => Geners_code.Split(',').Contains(y.Value.ToString())).Distinct().OrderBy(x => x.Text).Select(i => i.Text)));
                    ViewBag.GenresList = lstGenersNames.ToString().Trim(',');
                }
                else
                    ViewBag.GenresList = "";
            }
            else
            {
                ViewBag.ProduceList = new MultiSelectList(lstProducer, "Value", "Text", producer_code.Split(','));
                ViewBag.DirectorList = new MultiSelectList(lstDirector, "Value", "Text", Director_code.Split(','));
                ViewBag.StarCastList = new MultiSelectList(lstStarCast, "Value", "Text", StarCast_code.Split(','));
                ViewBag.CountryList = new MultiSelectList(lstCountry, "Value", "Text", Country_codes.Split(','));

                var Geners_code = string.Join(",", (objTitle.Title_Geners.Where(i => i.Title_Code == objTitle.Title_Code).Select(i => i.Genres_Code).ToList()));
                var lstGenres = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
                ViewBag.GenresList = new MultiSelectList(lstGenres, "Value", "Text", Geners_code.Split(','));
                ViewBag.MusicLabelList = BindMusicLabel();
            }
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
        public JsonResult fillUDT(string hdnDirector, string hdnKeyStarCast, string hdnProducer)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            bool IsValid = true;
            List<Title_Talent_Role_UDT> lst = new List<Title_Talent_Role_UDT>();

            if (hdnKeyStarCast != "")
            {
                string[] arrStarCast = hdnKeyStarCast.Trim().Replace('~', ',').Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string Talent_Code in arrStarCast)
                {
                    Title_Talent_Role_UDT objUDT = new Title_Talent_Role_UDT();
                    objUDT.Title_Code = objTitle.Title_Code;
                    objUDT.Talent_Code = Convert.ToInt32(Talent_Code);
                    objUDT.Role_Code = GlobalParams.RoleCode_StarCast;
                    lst.Add(objUDT);
                }
            }
            else
                lst.Add(SetUDT(objTitle.Title_Code, GlobalParams.RoleCode_StarCast));
            if (hdnProducer != "")
            {
                string[] arrProducer = hdnProducer.Trim().Replace('~', ',').Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string Talent_Code in arrProducer)
                {
                    Title_Talent_Role_UDT objUDT = new Title_Talent_Role_UDT();
                    objUDT.Title_Code = objTitle.Title_Code;
                    objUDT.Talent_Code = Convert.ToInt32(Talent_Code);
                    objUDT.Role_Code = GlobalParams.Role_code_Producer;
                    lst.Add(objUDT);
                }
            }
            else
                lst.Add(SetUDT(objTitle.Title_Code, GlobalParams.Role_code_Producer));

            if (hdnDirector != "")
            {
                string[] arrhdnDirector = hdnDirector.Trim().Replace('~', ',').Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string Talent_Code in arrhdnDirector)
                {
                    Title_Talent_Role_UDT objUDT = new Title_Talent_Role_UDT();
                    objUDT.Title_Code = objTitle.Title_Code;
                    objUDT.Talent_Code = Convert.ToInt32(Talent_Code);
                    objUDT.Role_Code = GlobalParams.RoleCode_Director;
                    lst.Add(objUDT);
                }
            }
            else
                lst.Add(SetUDT(objTitle.Title_Code, GlobalParams.RoleCode_Director));

            IsValid = ValidateTalent(lst, "S");

            if (!IsValid)
                objJson.Add("Error", "Cannot delete talent as already referenced in deal");
            return Json(objJson);
        }

        private Title_Talent_Role_UDT SetUDT(int titleCode, int RoleCode)
        {
            Title_Talent_Role_UDT objUDT = new Title_Talent_Role_UDT();
            objUDT.Title_Code = titleCode;
            objUDT.Talent_Code = 0;
            objUDT.Role_Code = RoleCode;
            return objUDT;
        }
        public string SaveFile()
        {
            string ReturnMessage = "Y";
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var file = System.Web.HttpContext.Current.Request.Files["InputFile"];
                string filename = DateTime.Now.Ticks.ToString() + "_";

                //file = Regex.Replace(file, @"[^0-9a-zA-Z]+", "_");
                filename += file.FileName.Replace(" ", "_");
                filename = Regex.Replace(filename, @"[~#'%&*:<>?/\{|}\n]", "_");
                if (filename != "" && file.FileName != "")
                {
                    file.SaveAs(Server.MapPath(ConfigurationManager.AppSettings["TitleImagePath"] + filename));
                    TempData["Title_Image"] = filename.Replace(" ", "_");
                }
                return ReturnMessage = "Y";
            }
            else
                return ReturnMessage = "N";
        }

        public JsonResult Save(RightsU_Entities.Title objTitleModel, FormCollection objForm, string Deal_Type_Code, string Title_Language_Code
            , string Original_Language_Code, string ddlCountry, string hdnProducer, string hdnDirector, string hdnGenres, string hdnStarCast, string hdnCountry,
            string hdnmode, int? hdnTitleCode, string hdnDealTypeCode, string hdnAlternateTabName, string hdnAlternateConfigCode, string hdnOriginalTitle, string hdnOriginalTitleCode, string Music_Label_Code = "0")
        //public string Save(RightsU_Entities.Title objTitleModel, string Deal_Type_Code, string Title_Language_Code
        //    , string Original_Language_Code, string ddlCountry, string hdnProducer, string hdnDirector, string hdnGenres, string hdnStarCast, string hdnCountry)
        {
            System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
            List<string> lstShowCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();
            int DealShowType = lstShowCode.Where(w => w == Deal_Type_Code).Count();
            string AllowSeasonAddition = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Parameter_Name == "AddSeasonForTitleTypeProgram" && i.IsActive == "Y").Select(s => s.Parameter_Value).FirstOrDefault();

            if (AllowSeasonAddition == "Y" && DealShowType == 1)
            {
                bool IsSeasonAdded = true;
                List<Map_Extended_Columns> CheckSeasonList = new List<Map_Extended_Columns>();
                CheckSeasonList.AddRange(lstDBExtendedColumns);
                CheckSeasonList.AddRange(lstAddedExtendedColumns);

                //if (lstDBExtendedColumns.Count > 0)
                //{
                //    if (lstDBExtendedColumns.Where(w => w.Columns_Code == 31).Count() < 1)
                //    {
                //        IsSeasonAdded = false;
                //    }
                //}

                //if (lstAddedExtendedColumns.Count > 0)
                //{
                //    if (lstAddedExtendedColumns.Where(w => w.Columns_Code == 31).Count() < 1)
                //    {
                //        IsSeasonAdded = false;
                //    }
                //}

                if (CheckSeasonList.Count > 0)
                {
                    if (CheckSeasonList.Where(w => w.Columns_Code == 31).Count() < 1)
                    {
                        IsSeasonAdded = false;
                    }
                }

                if (lstAddedExtendedColumns.Count == 0 && lstDBExtendedColumns.Where(w => w.EntityState != State.Deleted).ToList().Count == 0)
                {
                    IsSeasonAdded = false;
                }

                if (!IsSeasonAdded)
                {
                    var SeasonCheckObj = new
                    {
                        Status = "E",
                        Message = "Season is mandatory for selected Title type",
                        HideLoading = "Y",
                        TabNAme = hdnAlternateTabName,
                        ConfigCode = hdnAlternateConfigCode
                    };
                    return Json(SeasonCheckObj);
                }
            }

            dynamic resultSet;

            int TitleCode = 0;

            string message = "";
            int OriginalTitle_Code = 0;
            if (hdnmode != "C")
            {
                TitleCode = Convert.ToInt32(objTitleModel.Title_Code);
                objTitle = objTitleS.GetById(objTitleModel.Title_Code);
            }
            if (hdnOriginalTitleCode != "" && hdnOriginalTitleCode != null)
            {
                OriginalTitle_Code = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == hdnOriginalTitleCode).Select(x => x.Title_Code).First();
            }
            int contains = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == TitleCode).Count();
            objTitle = objTitleS.GetById(TitleCode);

            string newTitleImage = "", oldFileName = "";
            if (TempData["Title_Image"] != null)
                newTitleImage = TempData["Title_Image"].ToString();

            if (!string.IsNullOrEmpty(newTitleImage))
            {
                oldFileName = objTitle.Title_Image;
                objTitle.Title_Image = newTitleImage;
            }

            objTitle.Title_Name = objTitleModel.Title_Name.Trim();
            objTitle.Original_Title = objTitleModel.Original_Title;
            objTitle.Year_Of_Production = objTitleModel.Year_Of_Production;
            if (hdnOriginalTitleCode != null)
            {
                objTitle.Original_Title = hdnOriginalTitleCode;
            }
            objTitle.Original_Title_Code = OriginalTitle_Code;
            if (objTitleModel.Synopsis == null)
                objTitle.Synopsis = "";
            else
                objTitle.Synopsis = objTitleModel.Synopsis.Replace("\r\n", "\n");
            objTitle.Duration_In_Min = objTitleModel.Duration_In_Min;
            objTitle.Music_Label_Code = Convert.ToInt32(objForm["Music_Label_Code"]);
            if (hdnmode == "E")
            {
                objTitle.Last_UpDated_Time = DateTime.Now;
                objTitle.Last_Action_By = objLoginUser.Users_Code;
                if (contains == 0)
                {
                    objTitle.Deal_Type_Code = Convert.ToInt32(Deal_Type_Code);
                }
                //objTitle.Deal_Type_Code = Convert.ToInt32(Deal_Type_Code);
            }
            if (hdnmode == "C")
            {
                objTitle.Inserted_By = objLoginUser.Users_Code;
                objTitle.Inserted_On = DateTime.Now;
                objTitle.Last_UpDated_Time = DateTime.Now;
                objTitle.Last_Action_By = objLoginUser.Users_Code;
                objTitle.Deal_Type_Code = Convert.ToInt32(hdnDealTypeCode);
            }
            if (objTitleModel.Program_Code == 0)
                objTitle.Program_Code = null;
            else
                objTitle.Program_Code = objTitleModel.Program_Code;


            if (Title_Language_Code != "0")
            {
                objTitle.Title_Language_Code = Convert.ToInt32(objForm["Title_Language_Code"]);
            }
            else
                objTitle.Title_Language_Code = null;

            if (Original_Language_Code != "" && Original_Language_Code != "0")
                objTitle.Original_Language_Code = Convert.ToInt32(objForm["Original_Language_Code"]);
            else
                objTitle.Original_Language_Code = null;

            //objTitle.Title_Country.ToList().ForEach(x => x.Country_Code = Convert.ToInt32(ddlCountry));

            //if (objTitle.Title_Code > 0)
            //{
            //    objTitle.Title_Country.ToList().ForEach(x => x.EntityState = State.Modified);
            //}

            #region ========= Genre creation =========
            objTitle.Title_Geners.ToList().ForEach(i => i.EntityState = State.Deleted);

            string[] Genres_Codes = objForm["hdnGenres"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string genreCode in Genres_Codes)
            {
                if (genreCode != "")
                {
                    Title_Geners objT = (Title_Geners)objTitle.Title_Geners.Where(t => t.Genres_Code == Convert.ToInt32(genreCode)).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Geners();
                    if (objT.Title_Geners_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = TitleCode;
                        objT.Genres_Code = Convert.ToInt32(genreCode);
                        objTitle.Title_Geners.Add(objT);
                    }
                }
            }
            #endregion


            objTitle.Title_Talent.ToList().ForEach(i => i.EntityState = State.Deleted);



            #region ========= Director creation =========
            string[] Director_Codes = objForm["hdnDirector"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string directorCode in Director_Codes)
            {
                if (directorCode != "")
                {
                    Title_Talent objT = (Title_Talent)objTitle.Title_Talent.Where(t => t.Talent_Code == Convert.ToInt32(directorCode) && t.Role_Code == GlobalParams.RoleCode_Director).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Talent();
                    if (objT.Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = TitleCode;
                        objT.Talent_Code = Convert.ToInt32(directorCode);
                        objT.Role_Code = GlobalParams.RoleCode_Director;
                        objTitle.Title_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= producer creation =========
            string[] Producer_Codes = objForm["hdnProducer"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string producerCode in Producer_Codes)
            {
                if (producerCode != "")
                {
                    Title_Talent objT = (Title_Talent)objTitle.Title_Talent.Where(t => t.Talent_Code == Convert.ToInt32(producerCode) && t.Role_Code == GlobalParams.Role_code_Producer).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Talent();
                    if (objT.Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Talent_Code = Convert.ToInt32(producerCode);
                        objT.Title_Code = TitleCode;
                        objT.Role_Code = GlobalParams.Role_code_Producer;
                        objTitle.Title_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Star Cast creation =========
            string[] StarCast_Codes = objForm["hdnStarCast"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string starcastCode in StarCast_Codes)
            {
                if (starcastCode != "")
                {
                    Title_Talent objT = (Title_Talent)objTitle.Title_Talent.Where(t => t.Talent_Code == Convert.ToInt32(starcastCode) && t.Role_Code == GlobalParams.RoleCode_StarCast).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Talent();
                    if (objT.Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = TitleCode;
                        objT.Talent_Code = Convert.ToInt32(starcastCode);
                        objT.Role_Code = GlobalParams.RoleCode_StarCast;
                        objTitle.Title_Talent.Add(objT);
                    }
                }
            }
            #endregion



            #region ========= Country of Origin creation =========
            objTitle.Title_Country.ToList().ForEach(i => i.EntityState = State.Deleted);

            string[] Title_Country_Codes = objForm["hdnCountry"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string CountryCodes in Title_Country_Codes)
            {
                if (CountryCodes != "")
                {
                    Title_Country objT = (Title_Country)objTitle.Title_Country.Where(t => t.Country_Code == Convert.ToInt32(CountryCodes)).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Country();
                    if (objT.Title_Country_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = TitleCode;
                        objT.Country_Code = Convert.ToInt32(CountryCodes);
                        objTitle.Title_Country.Add(objT);
                    }
                }
            }
            #endregion
            #region ========= Insert Episode  =========
            System_Parameter_New Content_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "Allow_Generate_Content_From_Title_Import").FirstOrDefault();
            if (Content_system_Parameter.Parameter_Value == "Y")
            {
                System_Parameter_New Movies_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Movies").FirstOrDefault();
                List<string> lstMovieCode = Movies_system_Parameter.Parameter_Value.Split(',').ToList();
                int DealTypeIncluded = lstMovieCode.Where(w => w == objTitle.Deal_Type_Code.ToString()).Count();

                if (DealTypeIncluded == 1)
                {
                    if (objTitle.Title_Episode_Details.Count() < 1)
                    {
                        Title_Episode_Details objNewTED = new Title_Episode_Details();
                        objNewTED.EntityState = State.Added;
                        objNewTED.Episode_Nos = 1;
                        objNewTED.Remarks = objTitle.Title_Name;
                        objNewTED.Status = "P";
                        objNewTED.Inserted_On = DateTime.Now;
                        objNewTED.Inserted_By = objLoginUser.Users_Code;
                        objTitle.Title_Episode_Details.Add(objNewTED);
                    }
                }

                //if (objTitle.Title_Code > 0)
                //    objTitle.EntityState = State.Modified;
                //else
                //    objTitle.EntityState = State.Added;

                objTitle.Title_Code = TitleCode;
                if (objTitle.Title_Code > 0)
                    objTitle.EntityState = State.Modified;
                else
                {
                    objTitle.EntityState = State.Added;
                    objTitle.Is_Active = "Y";
                }

                objTitle = DBSaveEpisodeDetails(objTitle);
            }
            else
            {
                if (objTitle.Title_Code > 0)
                    objTitle.EntityState = State.Modified;
                else
                {
                    objTitle.EntityState = State.Added;
                    objTitle.Is_Active = "Y";
                }                    
            }
            #endregion

            dynamic resultset;
            bool isValid = objTitleS.Save(objTitle, out resultset);



            objTitleS = null;
            objMapExtCol_Service = null;

            if (lstAddedExtendedColumns.Count > 0)
            {
                foreach (Map_Extended_Columns obj in lstAddedExtendedColumns)
                {
                    obj.Record_Code = objTitle.Title_Code;
                    obj.EntityState = State.Added;
                    objMapExtCol_Service.Save(obj, out resultSet);
                }
            }
            if (lstDBExtendedColumns.Count > 0)
            {

                foreach (Map_Extended_Columns obj in lstDBExtendedColumns)
                {
                    Map_Extended_Columns objExtendedColumn = objMapExtCol_Service.GetById(obj.Map_Extended_Columns_Code);

                    objExtendedColumn.Record_Code = objTitle.Title_Code;
                    objExtendedColumn.Table_Name = obj.Table_Name;
                    objExtendedColumn.Is_Multiple_Select = obj.Is_Multiple_Select;
                    objExtendedColumn.Columns_Code = obj.Columns_Code;
                    objExtendedColumn.Columns_Value_Code = obj.Columns_Value_Code;
                    objExtendedColumn.Column_Value = obj.Column_Value;

                    //var b = objExtendedColumn.Map_Extended_Columns_Details.Except(obj.Map_Extended_Columns_Details);
                    //var b = obj.Map_Extended_Columns_Details.Except(objExtendedColumn.Map_Extended_Columns_Details);
                    var FirstList = objExtendedColumn.Map_Extended_Columns_Details.Select(y => y.Columns_Value_Code.ToString()).Distinct().ToList();
                    var SecondList = obj.Map_Extended_Columns_Details.Where(y => y.EntityState != State.Deleted).Select(y => y.Columns_Value_Code.ToString()).Distinct().ToList();

                    var Diff = FirstList.Except(SecondList);

                    foreach (string str in Diff)
                    {
                        if (str != "" && str != " ")
                        {
                            int ColumnValCode = Convert.ToInt32(str);
                            objExtendedColumn.Map_Extended_Columns_Details.Where(y => y.Columns_Value_Code == ColumnValCode).ToList().ForEach(x => x.EntityState = State.Deleted);
                        }
                    }


                    foreach (Map_Extended_Columns_Details objMED in obj.Map_Extended_Columns_Details)
                    {
                        Map_Extended_Columns_Details objMED_Exts = objExtendedColumn.Map_Extended_Columns_Details.Where(x => x.Map_Extended_Columns_Details_Code == objMED.Map_Extended_Columns_Details_Code).Where(y => y.Map_Extended_Columns_Details_Code > 0).FirstOrDefault();
                        int MECD_Code = 0;
                        //if (objMED_Exts != null && objMED_Exts.Map_Extended_Columns_Code != null)
                        //{
                        //MECD_Code = (int)objExtendedColumn.Map_Extended_Columns_Details.Where(y => y.Map_Extended_Columns_Code == objMED_Exts.Map_Extended_Columns_Code).Select(x => x.Map_Extended_Columns_Code).Distinct().FirstOrDefault();

                        MECD_Code = (from Map_Extended_Columns_Details onj in objExtendedColumn.Map_Extended_Columns_Details where objExtendedColumn.Columns_Code == obj.Columns_Code select objExtendedColumn.Map_Extended_Columns_Code).Distinct().SingleOrDefault();
                        //}
                        if (objMED_Exts == null)
                        {
                            objMED_Exts = new Map_Extended_Columns_Details();
                            objMED_Exts.EntityState = objMED.EntityState;
                            objMED_Exts.Columns_Value_Code = objMED.Columns_Value_Code;
                            if (MECD_Code > 0)
                                objMED_Exts.Map_Extended_Columns_Code = MECD_Code;
                            else
                                objMED_Exts.Map_Extended_Columns_Code = null;
                            objExtendedColumn.Map_Extended_Columns_Details.Add(objMED_Exts);
                        }
                        else
                        {
                            if (objMED_Exts.EntityState == State.Unchanged)
                                objMED_Exts.EntityState = State.Modified;
                            else if (objMED_Exts.EntityState == State.Added)
                                objExtendedColumn.Map_Extended_Columns_Details.Add(objMED_Exts);
                        }
                        objExtendedColumn.Columns_Value_Code = null;
                    }

                    //if (obj.EntityState != State.Deleted && obj.EntityState != State.Added)
                    //    objExtendedColumn.EntityState = State.Modified;
                    //else
                    //    objExtendedColumn.EntityState = State.Deleted;

                    if (objExtendedColumn.EntityState != State.Unchanged)
                        objExtendedColumn.EntityState = obj.EntityState;
                    if (objExtendedColumn.EntityState == State.Unchanged && obj.EntityState == State.Deleted)
                        objExtendedColumn.EntityState = State.Deleted;
                    if (objExtendedColumn.EntityState != State.Deleted)
                    {
                        if ((objExtendedColumn.EntityState.ToString() == "" || objExtendedColumn.EntityState == State.Unchanged) && hdnmode == "C")
                            objExtendedColumn.EntityState = State.Added;
                        else
                            objExtendedColumn.EntityState = State.Modified;
                    }

                    objMapExtCol_Service.Save(objExtendedColumn, out resultSet);
                }
            }
            Session["gvExtended"] = null;
            Session["lstMapExtendedColumns"] = null;
            Session["lstAddedExtendedColumns"] = null;
            Session["lstDBExtendedColumns"] = null;
            Session["lstEpisodeDetails"] = null;
            TempData["id"] = objTitle.Title_Code;
            TempData["Type"] = "E";
            TempData["PageNo"] = PageNo;
            TempData["TabName"] = hdnAlternateTabName;
            TempData["AlternateConfigCode"] = hdnAlternateConfigCode;
            TempData["Title_Code"] = objTitle.Title_Code;
            if (objTitle.EntityState == State.Added)
            {
                Message = objMessageKey.Titleaddedsuccessfully;
            }
            else
            {
                Message = objMessageKey.TitleUpdateMessage;
            }
            if (isValid)
            {

                int recordLockingCode = Convert.ToInt32(objForm["_hdnRecordLockingCode"]);
                if (recordLockingCode > 0)
                {
                    TempData["RecodLockingCode"] = "";
                    DBUtil.Release_Record(recordLockingCode);
                }
                if (!string.IsNullOrEmpty(newTitleImage) && !string.IsNullOrEmpty(oldFileName))
                {
                    string filepath = ConfigurationManager.AppSettings["TitleImagePath"].Trim('~');
                    string fullPath = (Server.MapPath("~") + "\\" + filepath);
                    string strActualFileNameWithDate;
                    string strFileName = oldFileName;
                    strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                    string fullpathname = fullPath + oldFileName; ;
                    System.IO.File.Delete(fullpathname.Trim());
                }
                objTitle = null;
            }
            PageNo = (PageNo == 0) ? 1 : PageNo;
            var objs = new
            {
                Status = isValid ? "S" : "E",
                Message = isValid ? Message : resultset,
                TabNAme = hdnAlternateTabName,
                ConfigCode = hdnAlternateConfigCode
            };
            #region ========= Insert Content  =========
            if (Content_system_Parameter.Parameter_Value == "Y")
            {
                int SentTitleCodeToProc = TitleCode;
                var SentTitleObj = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_Title_Content_Gen_From_Title(SentTitleCodeToProc);
            }
            #endregion
            return Json(objs);
        }

        public PartialViewResult BindPlatformTreeView(string strPlatform, string selectedPlatform)
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);

            //if (Is_HoldBack == 0)
            //{
            //    //objPTV.PlatformCodes_Selected = ("1").Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //    //objPTV.PlatformCodes_Display = "0,1";
            //}
            //else
            //{
            //    objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //    objPTV.PlatformCodes_Display = strPlatform;
            //}
            ViewBag.Title_Release_Platform_Codes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Title_Release_Platform_Codes").First().Parameter_Value;
            objPTV.PlatformCodes_Selected = selectedPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            objPTV.PlatformCodes_Display = strPlatform;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

        public JsonResult CheckIfHoldBack(long Title_Code = 0)
        {
            int[] Is_HoldBack = new USP_Service(objLoginEntity.ConnectionStringName).USP_Check_HoldBack(Title_Code).Select(p => p.Is_HoldBack).ToArray();

            return Json(Is_HoldBack, JsonRequestBehavior.AllowGet);
        }

        public void Fillddl()
        {
            ViewBag.CountryList_TitleRel = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y").ToList(), "Country_Code", "Country_Name");
            ViewBag.TerritoryList_TitleRel = new SelectList(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y").ToList(), "Territory_Code", "Territory_Name");
        }

        public JsonResult SaveTitleRelease(long Title_Code, string Release_Type, string Release_Date, string platForm_Code, string Territory_Code, string Country_Code, string World_Code, long Title_Release_Code = 0)
        {
            int Territory_World_Code;
            if (Release_Type == "W")
            {
                System_Parameter_New_Service objSystemParamservice = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
                Territory_World_Code = Convert.ToInt32(objSystemParamservice.SearchFor(s => s.Parameter_Name == "Territory_World_Code").ToList().FirstOrDefault().Parameter_Value);
                Territory_Code = Territory_World_Code.ToString();
            }

            //DateTime dt = DateTime.ParseExact(Release_Date, "MM/dd/yyyy hh:mm:ss tt", CultureInfo.InvariantCulture);
            string Rel_Date = GlobalUtil.MakedateFormat(Release_Date);
            int? i = new USP_Service(objLoginEntity.ConnectionStringName).USP_Save_TitleRelease(Title_Code, Release_Type, Rel_Date, platForm_Code, Territory_Code, Country_Code, World_Code, Title_Release_Code).FirstOrDefault();
            return Json(i, JsonRequestBehavior.AllowGet);
        }

        public JsonResult DeleteTitleRelease(int Title_Release_Code)
        {
            string status = "S", message = "Record deleted successfully";

            Title_Release_Service objTitle_Release_Service = new Title_Release_Service(objLoginEntity.ConnectionStringName);
            Title_Release objTitle_Release = objTitle_Release_Service.GetById(Title_Release_Code);
            if (objTitle_Release != null)
            {
                objTitle_Release.Title_Release_Platforms.ToList().ForEach(p => { p.EntityState = State.Deleted; });
                objTitle_Release.Title_Release_Region.ToList().ForEach(r => { r.EntityState = State.Deleted; });

                dynamic resultSet;
                objTitle_Release.EntityState = State.Deleted;
                bool returnVal = objTitle_Release_Service.Delete(objTitle_Release, out resultSet);
                if (!returnVal)
                {
                    status = "E";
                    message = "Record could not be Deleted";
                }
            }
            else
            {
                status = "E";
                message = "Record Not Found";
            }


            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", status);
            obj.Add("Message", message);
            return Json(obj, JsonRequestBehavior.AllowGet);
        }

        public PartialViewResult GetTitle_Release_List(int Title_Code, int PageNo = 1, int PageSize = 10, string cmdName = "")
        {
            //new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(p => true).Select(p => p)
            //    .Join(new Title_Release_Platform_Service().SearchFor(p => true).Select(p => p), x => x.Title_Release_Code, y => y.Title_Release_Code, (x, y) => new { Title_Release = x, Title_Release_Platforms = y })
            //    .ToList();
            int skip = PageSize * (PageNo - 1);
            ViewBag.TitleReleasePageNo = PageNo;
            ViewBag.TitleReleaseCount = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Title_Code == Title_Code).Count();
            var title_List = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Title_Code == Title_Code).OrderBy(p => p.Title_Release_Code).Skip(skip).Take(PageSize).ToList();
            if (cmdName == "C")
            {
                title_List.Clear();
            }
            ViewBag.Title_Release_Platform_Codes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Title_Release_Platform_Codes").First().Parameter_Value;
            return PartialView("_List_Title_Release", title_List);
        }

        public JsonResult GetTitleRelease(int Title_Release_Code = 0)
        {
            var objTitle_Service = new Title_Release_Service(objLoginEntity.ConnectionStringName)
                .SearchFor(p => p.Title_Release_Code == Title_Release_Code).ToList();
            //.Select(p => new { p.Title_Code, p.Title_Release_Code, p.Release_Type, Release_Date = Convert.ToDateTime(p.Release_Date).ToString("dd/MM/yyyy") });


            Dictionary<string, object> objDict = new Dictionary<string, object>();
            objDict.Add("TitleList", objTitle_Service.Select(p => new { p.Title_Code, p.Title_Release_Code, p.Release_Type, Release_Date = Convert.ToDateTime(p.Release_Date).ToString("dd/MM/yyyy") }));
            objDict.Add("PlatformList", objTitle_Service.Select(p => new { items = p.Title_Release_Platforms.Select(item => new { item.Platform_Code }) }));
            objDict.Add("TerritoryList", objTitle_Service.Select(p => new { items = p.Title_Release_Region.Select(item => new { item.Territory_Code, item.Country_Code }) }));
            //objDict.Add("CountryList", objTitle_Service.Select(p => new { items = p.Title_Release_Region.Select(item => new { item.Country_Code }) }));
            return Json(objDict, JsonRequestBehavior.AllowGet);
        }

        public PartialViewResult BindFieldNameddl(int TitleCode, string mode = "")
        {
            if (lstMapExtendedColumns == null)
                lstMapExtendedColumns = objMapExtCol_Service.SearchFor(x => x.Record_Code == TitleCode).ToList();


            if (gvExtended == null || gvExtended.Count == 0)
            {
                gvExtended = new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Extend_Column_Grid(TitleCode).ToList();
                if (gvExtended.Count != 0)
                {
                    lstDBExtendedColumns = objMapExtCol_Service.SearchFor(y => y.Record_Code == TitleCode).ToList();
                }
            }
            if (ExtendedColumnsCode != 0)
            {
                ViewBag.Data = new List<ExtendedMethod>();
                ViewBag.Data = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == ExtendedColumnsCode).Select(y => new { ColumnCode = y.Columns_Code, Is_Add_OnScreen = y.Is_Add_OnScreen }).ToList();
            }

            //List<SelectListItem> lstGetTitleType = new List<SelectListItem>();
            //lstGetTitleType = new SelectList(new Extended_Columns_Service().SearchFor(x => 1 == 1), "Control_Type", "Columns_Name").ToList();
            //lstGetTitleType.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

            //ViewBag.FieldNameList = lstGetTitleType;
            //HiddenField hdnColumnsValue = (HiddenField)gvExtended.Rows[e.RowIndex].FindControl("hdnColumnsValue");
            foreach (USP_Bind_Extend_Column_Grid_Result obj in gvExtended)
            {
                if (obj.Is_Multiple_Select.Trim().ToUpper() == "Y") //&& lblAdditionalCondition.Text != "")
                {
                    if (ValidateTalent(obj.Columns_Value_Code1, obj.Columns_Code, "R") == "N")
                    {
                        obj.IsDelete = "N";
                    }
                }

                string isAeroplay = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Allow_Import_Movies_Shows").Select(x => x.Parameter_Value).FirstOrDefault();

                //int Extended_Group_Code;
                int? TabCode = 0;

                if (isAeroplay == "N")
                {
                    //int[] arrExtendedGroupCodes = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(x => x.Extended_Group_Code).ToArray();
                    //TabCode = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == obj.Columns_Code && x.Extended_Group.Module_Code == GlobalParams.ModuleCodeForTitle && arrExtendedGroupCodes.Any(a=> x.Extended_Group_Code == a)).Select(x => x.Extended_Group_Code).FirstOrDefault();
                    TabCode = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(x => x.Columns_Code == obj.Columns_Code && x.Is_Active == "Y").Select(x => x.Extended_Group_Code).FirstOrDefault().Value;
                    //Extended_Group_Code = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Group_Name == "Additional Metadata").Select(x => x.Extended_Group_Code).FirstOrDefault();
                }
                else
                {
                    TabCode = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == obj.Columns_Code && x.Extended_Group.Module_Code == GlobalParams.ModuleCodeForTitle).Select(x => x.Extended_Group_Code).FirstOrDefault();
                }

                int? Row_No = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == obj.Columns_Code && x.Map_Extended_Columns_Code == obj.Map_Extended_Columns_Code).Select(x => x.Row_No).FirstOrDefault();
                obj.Extended_Group_Code = TabCode;
                obj.Row_No = Row_No;
            }
            ViewBag.mode = mode;
            return PartialView("_Extended_Columns", gvExtended);
        }

        public string ValidateTalent(string Columns_Value_Code1, int Columns_Code, string type)
        {
            string Result = "";
            string ColumnsValueCode = Columns_Value_Code1 ?? "";
            string[] arrColumnsValueCode = ColumnsValueCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (arrColumnsValueCode.Count() > 0)
            {
                List<Title_Talent_Role_UDT> lst = new List<Title_Talent_Role_UDT>();
                string Code = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(t => t.Columns_Code == Columns_Code).Select(i => i.Additional_Condition).FirstOrDefault();
                if (Code == "")
                    Code = "0";
                int Additional_Condition_code = Convert.ToInt32(Code);
                if (Additional_Condition_code != 0)
                {
                    foreach (string Talent_Codes in arrColumnsValueCode)
                    {
                        Title_Talent_Role_UDT objUDT = new Title_Talent_Role_UDT();
                        objUDT.Title_Code = objTitle.Title_Code;
                        objUDT.Talent_Code = Convert.ToInt32(Talent_Codes);
                        objUDT.Role_Code = Convert.ToInt32(Additional_Condition_code);
                        lst.Add(objUDT);
                    }
                    bool IsValid = ValidateTalent(lst, type);
                    if (!IsValid)
                    {
                        Result = "N";
                    }
                }
            }
            return Result;
        }

        private bool ValidateTalent(List<Title_Talent_Role_UDT> lst, string CallFrom)
        {
            try
            {
                IEnumerable<USP_Validate_Title_Talent_UDT> objResult = new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Title_Talent_UDT(lst, CallFrom);
                int Count = objResult.Select(i => i.Talent_Code).Count();
                if (Count > 0)
                    return false;
            }
            catch (Exception e)
            {

            }
            return true;
        }

        public string BindNewRowDdl(int ColumnCode, int RowNum, string IsExists, int Ext_Grp_Code = 0)
        {
            int Column_Code = Convert.ToInt32(ColumnCode);
            //var lstextCol = new Extended_Columns_Service().SearchFor(x => 1 == 1).Select(y => new { Columns_Name = y.Columns_Name, Control_Type = y.Control_Type }).ToList();
            string str_Program_Category_Value = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Parameter_Name == "Program_Category_Value" && i.IsActive == "Y").Select(s => s.Parameter_Value).FirstOrDefault();

            List<int> ColumnNotInCode;
            if (IsExists != "A")
                ColumnNotInCode = gvExtended.Where(y => y.Columns_Code != ColumnCode).Select(x => x.Columns_Code).Distinct().ToList();
            else
                ColumnNotInCode = gvExtended.Select(x => x.Columns_Code).Distinct().ToList();
            //List<int> ColumnNotInCode = gvExtended.Select(x => x.Columns_Code).Distinct().ToList();

            // Commented for mapping etended_group and Extended_Group_Config table
            //var lstextCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => !ColumnNotInCode.Contains(x.Columns_Code) && x.Columns_Name != "Program Category").ToList();
            var lstextCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => !ColumnNotInCode.Contains(x.Columns_Code) && x.Columns_Name != "Program Category").ToList();
            var lstextGrpConfig = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code == Ext_Grp_Code && x.Is_Active == "Y").ToList();
            lstextCol = lstextCol.Where(w => lstextGrpConfig.Any(a => w.Columns_Code == a.Columns_Code)).ToList();

            if (ColumnCode == Convert.ToInt32(str_Program_Category_Value))
                lstextCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => !ColumnNotInCode.Contains(x.Columns_Code) && x.Columns_Name == "Program Category").ToList();

            string FieldNameDDL = "";

            //if(IsExists != "Y")
            //{
            //if (Column_Code == 0)
            //{
            //    FieldNameDDL = "<select id='1_ddlFieldNameList' class='form_input chosen-select' onchange='ControlType(0)'> ";
            //    FieldNameDDL += " <option value=0 selected>Please Select</option> ";
            //}
            //else
            if (RowNum != 0)
                FieldNameDDL = "<select id='" + RowNum + "_ddlFieldNameList' class='form_input chosen-select' onchange='ControlType(0,$(this).val())'> ";

            FieldNameDDL += " <option value='0' selected>Please Select</option> ";

            if (ColumnCode == Convert.ToInt32(str_Program_Category_Value))
            {
                FieldNameDDL = "<select id='" + RowNum + "_ddlFieldNameList' class='form_input chosen-select' onchange='ControlType(" + str_Program_Category_Value + ",$(this).val())' disabled> ";
                FieldNameDDL += "<option value='17' selected>Program Category";
            }

            for (int i = 0; i < lstextCol.Count; i++)
            {
                if (lstextCol[i].Columns_Code == Column_Code)
                    FieldNameDDL += " <option value='" + lstextCol[i].Control_Type + "~" + lstextCol[i].Columns_Code + "~" + lstextCol[i].Is_Ref + "~" + lstextCol[i].Is_Defined_Values + "~" + lstextCol[i].Is_Multiple_Select + "~" + lstextCol[i].Ref_Table + "~" + lstextCol[i].Ref_Display_Field + "~" + lstextCol[i].Ref_Value_Field + "~" + lstextCol[i].Additional_Condition + "~" + lstextCol[i].Is_Add_OnScreen + "~" + lstextCol[i].Columns_Name + "' selected>" + lstextCol[i].Columns_Name + "</option> ";
                else
                    FieldNameDDL += " <option value='" + lstextCol[i].Control_Type + "~" + lstextCol[i].Columns_Code + "~" + lstextCol[i].Is_Ref + "~" + lstextCol[i].Is_Defined_Values + "~" + lstextCol[i].Is_Multiple_Select + "~" + lstextCol[i].Ref_Table + "~" + lstextCol[i].Ref_Display_Field + "~" + lstextCol[i].Ref_Value_Field + "~" + lstextCol[i].Additional_Condition + "~" + lstextCol[i].Is_Add_OnScreen + "~" + lstextCol[i].Columns_Name + "'>" + lstextCol[i].Columns_Name + "</option> ";
            }
            //return Json(lstextCol, JsonRequestBehavior.AllowGet);
            if (RowNum != 0)
                FieldNameDDL += "</select>";
            //}
            return FieldNameDDL;
        }

        public JsonResult BindFooterRowDdl(int ColumnCode, int RowNum, string IsExists)
        {
            int Column_Code = Convert.ToInt32(ColumnCode);
            //var lstextCol = new Extended_Columns_Service().SearchFor(x => 1 == 1).Select(y => new { Columns_Name = y.Columns_Name, Control_Type = y.Control_Type }).ToList();

            List<int> ColumnNotInCode;
            if (IsExists != "A")
                ColumnNotInCode = gvExtended.Where(y => y.Columns_Code != ColumnCode).Select(x => x.Columns_Code).Distinct().ToList();
            else
                ColumnNotInCode = gvExtended.Select(x => x.Columns_Code).Distinct().ToList();
            //List<int> ColumnNotInCode = gvExtended.Select(x => x.Columns_Code).Distinct().ToList();

            var lstextCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => !ColumnNotInCode.Contains(x.Columns_Code)).ToList();

            return Json(lstextCol, JsonRequestBehavior.AllowGet);
        }

        public JsonResult BinddlColumnsValue(string ColumnsCode, string AdditionalCondition)
        {
            int Column_Code = Convert.ToInt32(ColumnsCode);
            var lstextCol = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Column_Code)
                .Select(y => new { ColumnsValue = y.Columns_Value, Columns_Value_Code = y.Columns_Value_Code }).ToList();
            ExtendedColumnsCode = Column_Code;
            //var ValueType = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Column_Code).Select(y =>y.Ref_Table).ToList();
            //try
            //{
            //    Objddl.Attributes.Remove("multiple");
            //    Objddl.Items.FindByText(defaultItem).Selected = true;
            //}
            //catch (Exception ex) { }

            //if (IsMultipleSelect.Trim().ToUpper() == "Y")
            //    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ECV", "AddMultiSelect('" + Objddl.ClientID + "','" + Objhdn.ClientID + "');SetMultiSelect('" + Objddl.ClientID + "','" + Objhdn.ClientID + "')", true);
            return Json(lstextCol, JsonRequestBehavior.AllowGet);
        }
        public JsonResult BindddlExtendedTalent(string ColumnsCode, string AdditionalCondition)
        {
            int RoleCode = 0;

            if (AdditionalCondition != "")
                RoleCode = Convert.ToInt32(AdditionalCondition);
            var lstextCol = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Role.Any(TR => TR.Role_Code == RoleCode)).Where(y => y.Is_Active == "Y")
                .Select(i => new { ColumnsValue = i.Talent_Name, Columns_Value_Code = i.Talent_Code }).ToList();
            return Json(lstextCol, JsonRequestBehavior.AllowGet);
        }

        public JsonResult BindddlExtendedColumns(string ColumnsCode, string AdditionalCondition)
        {
            //int RoleCode = 0;

            //if (AdditionalCondition != "")
            //    RoleCode = Convert.ToInt32(AdditionalCondition);
            //var lstextCol = new Banner_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(i => new { ColumnsValue = i.Banner_Name, Columns_Value_Code = i.Banner_Code }).ToList();
            //return Json(lstextCol, JsonRequestBehavior.AllowGet);
            List<RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result> lstextCol = new List<RightsU_Entities.USPGet_DDLValues_For_ExtendedColumns_Result>();
            lstextCol = new USP_Service(objLoginEntity.ConnectionStringName).USPGet_DDLValues_For_ExtendedColumns(Convert.ToInt32(ColumnsCode)).ToList();

            return Json(lstextCol, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveTalent(string Roles, string TalentName, string Gender)
        {
            int ccount = 0;
            string msgType = "";
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            try
            {

                int count = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name == TalentName).ToList().Count();
                string[] selectedRoleTemp1 = Roles.Split(new string[] { "," }, StringSplitOptions.None);
                if (count > 0)
                    foreach (string role in selectedRoleTemp1)
                    {
                        RightsU_Entities.Talent_Role objTalentRole = new RightsU_Entities.Talent_Role();
                        //RightsU_Entities.Role objRole = new RightsU_Entities.Role();
                        if (role != "")
                        {
                            int r1 = Convert.ToInt32(role);
                            ccount += (new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name == TalentName).FirstOrDefault()).Talent_Role.Where(y => y.Role_Code == r1).ToList().Count();
                        }
                    }


                if (selectedRoleTemp1.Count() - 1 == ccount)
                {
                    msgType = "R";
                    throw new DuplicateRecordException("All Records Already Exist");
                }
                else if (ccount > 0 || count > 0)
                {
                    msgType = "C";
                    throw new DuplicateRecordException("Talent Already Exists, Do You want to add more roles with this talent");
                }
                RightsU_Entities.Talent objTalent = new RightsU_Entities.Talent();
                dynamic resultSet;

                objTalent.Talent_Name = TalentName;
                string[] selectedRoleTemp = Roles.Split(new string[] { "," }, StringSplitOptions.None);
                objTalent.Gender = Gender;
                objTalent.Inserted_By = objLoginUser.Users_Code;
                objTalent.Inserted_On = DateTime.Now;
                objTalent.Is_Active = "Y";
                foreach (string role in selectedRoleTemp)
                {
                    RightsU_Entities.Talent_Role objTalentRole = new RightsU_Entities.Talent_Role();
                    //RightsU_Entities.Role objRole = new RightsU_Entities.Role();
                    if (role != "")
                    {
                        objTalentRole.Role_Code = Convert.ToInt32(role);
                        objTalent.Talent_Role.Add(objTalentRole);
                    }
                }

                if (objTalent.Talent_Code > 0)
                    objTalent.EntityState = State.Modified;
                else
                    objTalent.EntityState = State.Added;

                new Talent_Service(objLoginEntity.ConnectionStringName).Save(objTalent, out resultSet);
                objJson.Add("Value", objTalent.Talent_Code);
                objJson.Add("Text", objTalent.Talent_Name);
                //objTalent = null;
            }
            catch (DuplicateRecordException)
            {
                //resposeText = "duplicate";
                if (msgType == "R")
                    objJson.Add("TalentError", objMessageKey.RecordAlreadyExists);
                else
                    objJson.Add("TalentConfirmation", "Talent Already Exists, Do You want to add more roles with this talent");
            }
            catch (Exception)
            {
                objJson.Add("TalentError", "Error");
            }

            return Json(objJson);
        }
        public JsonResult SaveExtendedMetadata(string ExtendedColumnValue)
        {
            int ccount = 0;
            // ExtendedColumnCode ;
            string msgType = "";
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            try
            {
                int count = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Value == ExtendedColumnValue).ToList().Count();
                if (count >= 1)
                {
                    msgType = "R";
                    throw new DuplicateRecordException("Record Already Exist");
                }

                RightsU_Entities.Extended_Columns_Value objTalent = new RightsU_Entities.Extended_Columns_Value();
                dynamic resultSet;

                objTalent.Columns_Code = ExtendedColumnsCode;
                objTalent.Columns_Value = ExtendedColumnValue;
                objTalent.EntityState = State.Added;
                //ExtendedColumnsCode = 0;
                new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).Save(objTalent, out resultSet);
                objJson.Add("Value", objTalent.Columns_Code);
                objJson.Add("Text", objTalent.Columns_Value);
            }
            catch (DuplicateRecordException)
            {
                //resposeText = "duplicate";
                if (msgType == "R")
                    objJson.Add("ExtendedColumnError", objMessageKey.RecordAlreadyExists);
                //else
                //    objJson.Add("ExtendedColumnConfirmation", "Extended Column Already Exists, Do You want to add more roles with this talent");
            }
            catch (Exception)
            {
                objJson.Add("ExtendedColumnError", "Error");
            }
            //objTalent = null;


            return Json(objJson);
        }
        public JsonResult Save_Talent(string Roles, string TalentName, string Gender)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            RightsU_Entities.Talent objTalent = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name == TalentName).FirstOrDefault();
            dynamic resultSet;

            objTalent.Talent_Name = TalentName;
            string[] selectedRoleTemp = Roles.Split(new string[] { "," }, StringSplitOptions.None);
            objTalent.Gender = Gender;
            objTalent.Inserted_By = objLoginUser.Users_Code;
            objTalent.Inserted_On = DateTime.Now;
            objTalent.Is_Active = "Y";
            foreach (string role in selectedRoleTemp)
            {
                if (role != "")
                {
                    int r1 = Convert.ToInt32(role);
                    RightsU_Entities.Talent_Role objTalentRole = new Talent_Role_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Code == objTalent.Talent_Code
                        && x.Role_Code == r1).FirstOrDefault();
                    //RightsU_Entities.Role objRole = new Role_Service(objLoginEntity.ConnectionStringName).GetById(r1);
                    if (objTalentRole == null)
                    {
                        objTalentRole = new RightsU_Entities.Talent_Role();
                        //RightsU_Entities.Role objRole = new RightsU_Entities.Role();
                        //if (role != "")
                        //{

                        //    int ccount = (new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name == TalentName).FirstOrDefault()).Talent_Role.Where(y => y.Role_Code == r1)
                        //        .ToList().Count();
                        //if (ccount == 0)
                        //{
                        objTalentRole.Role_Code = Convert.ToInt32(role);
                        objTalentRole.Talent_Code = objTalent.Talent_Code;
                        objTalentRole.EntityState = State.Added;
                        new Talent_Role_Service(objLoginEntity.ConnectionStringName).Save(objTalentRole, out resultSet);
                        //objTalentRole.Talent = objTalent;
                        //}
                        //}
                    }
                    //else
                    //{
                    //    objTalentRole.EntityState = State.Unchanged;
                    //}
                    //objTalent.Talent_Role.Add(objTalentRole);

                    //if (objTalent.Talent_Code > 0)
                    //    objTalent.EntityState = State.Modified;
                    //else
                    //    objTalent.EntityState = State.Added;
                    //new Talent_Service(objLoginEntity.ConnectionStringName).Save(objTalent, out resultSet);
                }
            }
            objJson.Add("Value", objTalent.Talent_Code);
            objJson.Add("Text", objTalent.Talent_Name);
            return Json(objJson);
        }
        public JsonResult Save_Program(string Program_Name)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            string status = "S", message = "Record saved successfully";
            Program_Service objService = new Program_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Program objProgram = new RightsU_Entities.Program();
            objProgram.EntityState = State.Added;
            objProgram.Inserted_On = DateTime.Now;
            objProgram.Inserted_By = objLoginUser.Users_Code;
            objProgram.Last_UpDated_Time = DateTime.Now;
            objProgram.Last_Action_By = objLoginUser.Users_Code;
            objProgram.Is_Active = "Y";
            objProgram.Program_Name = Program_Name;
            dynamic resultSet;
            bool isValid = objService.Save(objProgram, out resultSet);
            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {

                Status = status,
                Message = message,
                Value = objProgram.Program_Code,
                Text = objProgram.Program_Name
            };

            return Json(obj);
        }
        public ActionResult SaveImage(HttpPostedFileBase file)
        {
            try
            {
                string filename = System.IO.Path.GetFileName(file.FileName);
                filename = DateTime.Now.Ticks.ToString();
                file.SaveAs(Server.MapPath(ConfigurationManager.AppSettings["TitleImagePath"] + filename));
                objTitle.Title_Image = filename;
                ViewBag.Message = objMessageKey.FileUploadedSuccessfully;
            }
            catch
            {
                ViewBag.Message = objMessageKey.ErrorWhileUploadingTheFiles;
            }
            return RedirectToAction("Index", new { id = objTitle.Title_Code });
        }

        public ActionResult CancelPage()
        {
            lst_Deal_Info = null;
            return RedirectToAction("List", "Title_List", new { @CallFrom = "T", @Page_No = PageNo });
        }

        public JsonResult SaveExtendedRecord(string hdnExtendedColumnsCode, string hdnColumnValueCode, string hdnControlType, string hdnIsRef, string hdnIsDefined_Values, string hdnIsMultipleSelect,
            string hdnRefTable, string hdnRefDisplayField, string hdnRefValueField, string AdditionalCondition, string hdnExtendedColumnName, string hdnName, string hdnType, string hdnRowNum, string hdnMEColumnCode, string hdnExtendedColumnValue)
        {
            USP_Bind_Extend_Column_Grid_Result obj;
            string Message = "";
            if (hdnColumnValueCode == null || hdnColumnValueCode == "")
                hdnColumnValueCode = "0";
            string[] arrColumnsValueCode = hdnColumnValueCode.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            int ColumnCode = Convert.ToInt32(hdnExtendedColumnsCode);
            if (hdnType == "A" || hdnType == "")
            {
                obj = new USP_Bind_Extend_Column_Grid_Result();
                obj.Columns_Code = ColumnCode;
                if (hdnColumnValueCode.Split(',').Count() <= 1)
                    obj.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                obj.Is_Ref = hdnIsRef;
                obj.Is_Defined_Values = hdnIsDefined_Values;
                obj.Is_Multiple_Select = hdnIsMultipleSelect;
                obj.Ref_Table = hdnRefTable;
                obj.Ref_Display_Field = hdnRefDisplayField;
                obj.Ref_Value_Field = hdnRefValueField;
                obj.Columns_Name = hdnExtendedColumnName;
                obj.Name = hdnName;

                gvExtended.Add(obj);


                Map_Extended_Columns objMapExtendedColumns = new Map_Extended_Columns();
                objMapExtendedColumns.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                objMapExtendedColumns.Table_Name = "TITLE";
                objMapExtendedColumns.Is_Multiple_Select = hdnIsMultipleSelect;

                if (hdnRefTable.Trim().ToUpper() == "TALENT" && hdnIsMultipleSelect.Trim().ToUpper() == "Y")
                {
                    foreach (string str in arrColumnsValueCode)
                    {
                        Map_Extended_Columns_Details objMapExtDet = new Map_Extended_Columns_Details();
                        objMapExtDet.Columns_Value_Code = Convert.ToInt32(str);
                        objMapExtendedColumns.Map_Extended_Columns_Details.Add(objMapExtDet);
                    }
                }
                else if (hdnIsDefined_Values.Trim().ToUpper() == "N" && hdnControlType.Trim().ToUpper() == "TXT")
                {
                    objMapExtendedColumns.Column_Value = hdnName;

                    objMapExtendedColumns.Columns_Value_Code = null;
                }
                else if (hdnIsDefined_Values.Trim().ToUpper() == "N" && (hdnControlType.Trim().ToUpper() == "DATE" || hdnControlType.Trim().ToUpper() == "INT"))
                {
                    objMapExtendedColumns.Column_Value = hdnName;

                    objMapExtendedColumns.Columns_Value_Code = null;
                }
                else if ((hdnRefTable.Trim().ToUpper() == "TITLE" || hdnRefTable.Trim().ToUpper() == "") && hdnIsMultipleSelect.Trim().ToUpper() == "N")
                {
                    objMapExtendedColumns.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                }
                if (hdnRefTable.Trim().ToUpper() == "CBFC" && hdnIsMultipleSelect.Trim().ToUpper() == "Y")
                {
                    foreach (string str in arrColumnsValueCode)
                    {
                        Map_Extended_Columns_Details objMapExtDet = new Map_Extended_Columns_Details();
                        objMapExtDet.Columns_Value_Code = Convert.ToInt32(str);
                        objMapExtendedColumns.Map_Extended_Columns_Details.Add(objMapExtDet);
                    }
                }
                if (hdnControlType == "DDL" && hdnIsMultipleSelect == "N" && string.IsNullOrEmpty(hdnRefTable.Trim()))
                {
                    objMapExtendedColumns.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                }
                else if (hdnControlType == "DDL" && hdnRefTable.Trim().ToUpper() != "TALENT")
                {
                    foreach (string str in arrColumnsValueCode)
                    {
                        Map_Extended_Columns_Details objMapExtDet = new Map_Extended_Columns_Details();
                        objMapExtDet.Columns_Value_Code = Convert.ToInt32(str);
                        objMapExtendedColumns.Map_Extended_Columns_Details.Add(objMapExtDet);
                    }
                }

                lstAddedExtendedColumns.Add(objMapExtendedColumns);
            }
            else
            {
                int OldColumnCode = 0;

                int RowNum = Convert.ToInt32(hdnRowNum);
                obj = gvExtended[RowNum - 1];

                OldColumnCode = obj.Columns_Code;

                if (hdnExtendedColumnsCode != "")
                    obj.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                if (hdnColumnValueCode != "")
                {
                    if (hdnColumnValueCode.Split(',').Count() <= 1)
                        obj.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                }
                obj.Is_Ref = hdnIsRef;
                obj.Is_Defined_Values = hdnIsDefined_Values;
                obj.Is_Multiple_Select = hdnIsMultipleSelect;
                obj.Ref_Table = hdnRefTable;
                obj.Ref_Display_Field = hdnRefDisplayField;
                obj.Ref_Value_Field = hdnRefValueField;
                obj.Columns_Name = hdnExtendedColumnName;
                obj.Name = hdnName;

                //if(hdnType == "D")
                //{
                //    gvExtended.Remove(obj);
                //}


                int MapExtendedColumnCode = 0;

                if (hdnMEColumnCode != "")
                    MapExtendedColumnCode = Convert.ToInt32(hdnMEColumnCode);

                Map_Extended_Columns objMEc;
                try
                {
                    //if (hdnMEColumnCode != "")
                    objMEc = lstDBExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState != State.Added).FirstOrDefault();



                    if (objMEc != null)
                    {

                        if (ValidateTalent(hdnColumnValueCode.ToString().Trim(' ').Trim(','), ColumnCode, "S") != "N")
                        {
                            objMEc.EntityState = State.Modified;
                            objMEc.Columns_Code = ColumnCode;
                            if (hdnColumnValueCode.Split(',').Count() <= 0)
                                objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);

                            var FirstList = objMEc.Map_Extended_Columns_Details.Select(y => y.Columns_Value_Code.ToString()).Distinct().ToList();
                            var SecondList = arrColumnsValueCode.Distinct().ToList();
                            var Diff = FirstList.Except(SecondList);




                            foreach (string str in Diff)
                            {
                                if (str != "" && str != " ")
                                {
                                    int ColumnValCode = Convert.ToInt32(str);
                                    objMEc.Map_Extended_Columns_Details.Where(y => y.Columns_Value_Code == ColumnValCode).ToList().ForEach(x => x.EntityState = State.Deleted);
                                }
                            }

                            foreach (string str in arrColumnsValueCode)
                            {
                                if (str != "" && str != "0" && str != " ")
                                {
                                    Map_Extended_Columns_Details objMECD;

                                    objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str) && p.EntityState != State.Added).FirstOrDefault();
                                    if (objMECD != null)
                                    {
                                        if (hdnType == "D")
                                            objMECD.EntityState = State.Deleted;
                                        else
                                            objMECD.EntityState = State.Modified;

                                        objMECD.Columns_Value_Code = Convert.ToInt32(str);
                                    }
                                    else
                                    {
                                        objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str) && p.EntityState == State.Added).FirstOrDefault();
                                        if (objMECD == null)
                                        {
                                            if ((hdnRefTable.Trim().ToUpper() == "TITLE" || hdnRefTable.Trim().ToUpper() == "") && hdnIsMultipleSelect.Trim().ToUpper() == "N")
                                            {
                                                if (hdnControlType.Trim().ToUpper() != "TXT")
                                                {
                                                    objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                                                    objMEc.Columns_Code = ColumnCode;
                                                    objMEc.Column_Value = "";
                                                }
                                                else
                                                {
                                                    objMEc.Columns_Value_Code = null;
                                                    objMEc.Column_Value = hdnExtendedColumnValue;
                                                }
                                                objMEc.EntityState = State.Modified;
                                                if (objMEc.Map_Extended_Columns_Details.Count > 0)
                                                {
                                                    foreach (Map_Extended_Columns_Details objMECD_inner in objMEc.Map_Extended_Columns_Details)
                                                    {
                                                        objMECD_inner.EntityState = State.Deleted;
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                objMECD = new Map_Extended_Columns_Details();
                                                objMECD.Columns_Value_Code = Convert.ToInt32(str);

                                                int MapExtCode;
                                                if (objMEc.Map_Extended_Columns_Details.Count > 0)
                                                {
                                                    //MapExtCode =(int) objMEc.Map_Extended_Columns_Details.Select(x => x.Map_Extended_Columns_Code).Distinct().SingleOrDefault();
                                                    if (hdnMEColumnCode != "")
                                                        objMECD.Map_Extended_Columns_Code = Convert.ToInt32(hdnMEColumnCode);
                                                }
                                                else
                                                {
                                                    objMECD.Map_Extended_Columns_Code = null;
                                                }
                                                if (hdnType == "D")
                                                {
                                                    objMECD.EntityState = State.Deleted;
                                                }
                                                else
                                                    objMECD.EntityState = State.Added;
                                                objMEc.Map_Extended_Columns_Details.Add(objMECD);
                                            }
                                        }
                                    }
                                }
                            }
                            if (hdnControlType.Trim().ToUpper() == "TXT" || hdnControlType.Trim().ToUpper() == "DATE" || hdnControlType.Trim().ToUpper() == "INT" || hdnControlType.Trim().ToUpper() == "DT")
                            {
                                objMEc.Columns_Value_Code = null;
                                objMEc.Column_Value = hdnExtendedColumnValue;
                                objMEc.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                            }
                            if (hdnType == "D")
                            {
                                USP_Bind_Extend_Column_Grid_Result objDeleteUBECD = gvExtended.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
                                //gvExtended.Remove(objDeleteUBECD);
                                try
                                {

                                    int code = Convert.ToInt32(objDeleteUBECD.Map_Extended_Columns_Code);
                                    if (code > 0)
                                    {
                                        lstDBExtendedColumns.ForEach(t => { if (t.Map_Extended_Columns_Code == code) t.EntityState = State.Deleted; });
                                    }
                                    //Object removed from gvExtended to re-populate dropdowns (check BindNewRowDdl method)
                                    gvExtended.Remove(obj);
                                }
                                catch { }
                            }
                        }
                        else
                            Message = "Cannot delete talent as already referenced in deal";
                    }
                    else
                    {

                        //objMEc = lstDBExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState == State.Added).FirstOrDefault();
                        //if (objMEc == null)
                        //{
                        objMEc = lstAddedExtendedColumns.Where(y => y.Columns_Code == OldColumnCode).FirstOrDefault();
                        objMEc.Columns_Code = ColumnCode;
                        if (hdnColumnValueCode.Split(',').Count() <= 0)
                            objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);


                        if (objMEc.Map_Extended_Columns_Details.Count > 0)
                        {
                            if (arrColumnsValueCode.Length < 1)
                            {
                                foreach (Map_Extended_Columns_Details objMECD in objMEc.Map_Extended_Columns_Details)
                                {
                                    objMECD.Columns_Value_Code = 0;
                                }
                            }
                            else
                            {
                                foreach (string str in arrColumnsValueCode)
                                {
                                    int ColumnValueCode = Convert.ToInt32(str);
                                    Map_Extended_Columns_Details objMECD;
                                    if (hdnIsMultipleSelect == "N")
                                    {
                                        objMECD = objMEc.Map_Extended_Columns_Details.FirstOrDefault();
                                        if (objMECD != null)
                                        {
                                            objMECD.Columns_Value_Code = Convert.ToInt32(str);
                                        }
                                    }
                                    else
                                    {
                                        objMECD = objMEc.Map_Extended_Columns_Details.Where(x => x.Columns_Value_Code == ColumnValueCode).FirstOrDefault();
                                    }

                                    if (objMECD == null)
                                    {
                                        objMECD = new Map_Extended_Columns_Details();
                                        objMECD.Columns_Value_Code = Convert.ToInt32(str);
                                        objMEc.Map_Extended_Columns_Details.Add(objMECD);
                                    }
                                }
                            }
                        }

                        if (hdnType == "D")
                        {
                            lstAddedExtendedColumns.Remove(objMEc);
                            gvExtended.Remove(obj);
                        }
                    }
                    //}
                }
                catch
                {
                    objMEc = lstAddedExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
                    if (objMEc != null)
                    {
                        if (hdnType == "D")
                            objMEc.EntityState = State.Deleted;
                        else
                            objMEc.EntityState = State.Modified;
                    }
                }

            }


            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (Message == "")
            {
                if (hdnType == "A" || hdnType == "")
                    Message = "Record added successfully";
                else if (hdnType == "D")
                    Message = "Record deleted successfully";
                else if (hdnType == "E")
                    Message = "Record updated successfully";
                objJson.Add("Message", Message);
                objJson.Add("Error", "");
            }
            else
            {
                objJson.Add("Error", Message);
                objJson.Add("Message", "");
            }



            return Json(objJson);
        }

        public JsonResult ValidateIsDuplicate(string TitleName, string DealTypeCode, string Mode)
        {

            Dictionary<string, object> objJson = new Dictionary<string, object>();
            TitleName = TitleName.Trim(' ');
            int Count = 0, Title_Code = 0;
            int Deal_Type_Code = Convert.ToInt32(DealTypeCode);
            Count = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == TitleName && x.Deal_Type_Code == Deal_Type_Code).Distinct().Count();
            Title_Code = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == TitleName && x.Deal_Type_Code == Deal_Type_Code).Select(s => s.Title_Code).Distinct().FirstOrDefault();
            if (Mode == "E")
            {
                if (Count > 0 && Title_Code != objTitle.Title_Code)
                    objJson.Add("Message", "Title with same name already exists");
                else
                    objJson.Add("Message", "");
            }
            else
            {
                if (Count > 0)
                    objJson.Add("Message", "Title with same name already exists");
                else
                    objJson.Add("Message", "");
            }

            return Json(objJson);
        }
        public ActionResult BindAlternateTab(int? configCode, int? titleCode, string tabName, string mode)
        {
            int contains = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == titleCode).Count();
            ViewBag.AvailTitleCode = contains;
            if (configCode == null && titleCode == null)
            {
                configCode = Convert.ToInt32(TempData["AlternateConfigCode"]);
                titleCode = Convert.ToInt32(TempData["Title_Code"]);
            }
            ViewBag.IsCalculatePublicDomain = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "IsCalculatePublicDomain").Select(w => w.Parameter_Value).FirstOrDefault();
            if (mode != "C")
            {
                var isPublicDomain = calculateReleaseDate(titleCode);
                if (isPublicDomain == true)
                    ViewBag.PublicDomain = "Yes";
            }
            objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(titleCode));
            int titleAlternateCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Alternate_Config_Code == configCode && x.Title_Code == titleCode).Select(x => x.Title_Alternate_Code).FirstOrDefault();
            objTitleAlternate = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).GetById(titleAlternateCode);
            ViewBag.DealType_Code = objTitle.Deal_Type_Code;
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT,LA,C,G,P,DR,S,RL,O", 0, 0, "").ToList();
            //RightsU_Entities.Title obj = objTitleS.GetById(objTitle.Title_Code);
            if (tabName == "TA")
            {
                Binddl();
            }
            else
            {
                BindAlternateTabddl();
            }
            int[] alternateConfigCode = new Alternate_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "N").OrderBy(x => x.Display_Order).Select(x => x.Alternate_Config_Code).ToArray();
            ViewBag.PartialTabList = alternateConfigCode;
            ViewBag.Title_Code = objTitle.Title_Code;
            ViewBag.Direction = new Alternate_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Alternate_Config_Code == configCode).Select(s => s.Direction).FirstOrDefault();
            ViewBag.CommandName = mode;
            ViewBag.TabName = tabName;
            ViewBag.AlternateConfigCode = configCode;
            ConfigCode = configCode;
            ViewBag.Title_Release_Platform_Codes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "Title_Release_Platform_Codes").First().Parameter_Value;
            if (tabName == "TA")
            {
                ViewBag.Direction = "LTR";
                ViewBag.IsFirstTime = "N";
                ViewBag.Is_AcqSyn_Type_Of_Film = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").FirstOrDefault().Parameter_Value;
                //return PartialView("~/Views/Title/Index.cshtml", objTitle);

                string Per_Logic = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Allow_Perpetual_Date_Logic_Title").FirstOrDefault().Parameter_Value;

                if (Per_Logic == "Y")
                {
                    return PartialView("~/Views/Title/_Title_Main_Release.cshtml", objTitle);
                }

                return PartialView("~/Views/Title/_Title_Main.cshtml", objTitle);
            }
            else
                return PartialView("~/Views/Title/_Title_Alternate.cshtml", objTitleAlternate);
        }
        public ActionResult BindViewAlternateTab(int? configCode, int? titleCode, string tabName, string mode)
        {
            objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(titleCode));
            int titleAlternateCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Alternate_Config_Code == configCode && x.Title_Code == titleCode).Select(x => x.Title_Alternate_Code).FirstOrDefault();
            objTitleAlternate = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).GetById(titleAlternateCode);
            ViewBag.DealType_Code = objTitle.Deal_Type_Code;
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT,LA,C,G,P,DR,S,RL,O", 0, 0, "").ToList();
            //RightsU_Entities.Title obj = objTitleS.GetById(objTitle.Title_Code);
            if (tabName == "TA")
            {
                Binddl();
            }
            else
            {
                BindAlternateTabddl();
            }
            int[] alternateConfigCode = new Alternate_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "N").OrderBy(x => x.Display_Order).Select(x => x.Alternate_Config_Code).ToArray();
            ViewBag.PartialTabList = alternateConfigCode;
            ViewBag.IsFirstTime = "N";
            ViewBag.Title_Code = objTitle.Title_Code;
            ViewBag.Direction = new Alternate_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Alternate_Config_Code == configCode).Select(s => s.Direction).FirstOrDefault();
            ViewBag.CommandName = mode;
            ViewBag.TabName = tabName;
            ViewBag.AlternateConfigCode = configCode;
            ViewBag.PageNo = TempData["Page_No"];
            ViewBag.SearchedTitle = TempData["SearchedTitle"];
            if (tabName == "TA")
            {
                ViewBag.IsFirstTime = "N";
                return PartialView("~/Views/Title/View.cshtml", objTitle);
            }
            else
                return PartialView("~/Views/Title/_View_Title_Alternate.cshtml", objTitleAlternate);
        }
        public void BindAlternateTabddl()
        {
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT,LA,C,G,P,DR,S,RL,O", 0, 0, "").ToList();

            //Title Language
            ViewBag.LanguageList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "LA"), "Display_Value", "Display_Text", objTitleAlternate.Title_Language_Code).ToList();

            //Original Language
            ViewBag.OriginalLanguageList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "LA"), "Display_Value", "Display_Text", objTitleAlternate.Original_Language_Code).ToList();

            //Role Language
            ViewBag.RolesList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "RL"), "Display_Value", "Display_Text").ToList();

            //Country
            var Country_codes = string.Join(",", (objTitleAlternate.Title_Alternate_Country.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code).Select(i => i.Country_Code).ToList()));
            //if (Country_codes == "" || Country_codes == null)
            //{
            //    int Original_Country_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_CountryOfOrigin").Select(i => i.Parameter_Value).FirstOrDefault());
            //    Country_codes = Original_Country_code + "";
            //}
            var lstCountry = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "C"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();

            //Producer 
            var lstProducer = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "P"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var producer_code = string.Join(",", (objTitleAlternate.Title_Alternate_Talent.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code && i.Role_Code == GlobalParams.Role_code_Producer).Select(i => i.Talent_Code).ToList()));

            //Director 
            var lstDirector = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DR"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var Director_code = string.Join(",", (objTitleAlternate.Title_Alternate_Talent.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code && i.Role_Code == GlobalParams.RoleCode_Director).Select(i => i.Talent_Code).ToList()));

            //StarCast
            var lstStarCast = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "S"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var StarCast_code = string.Join(",", (objTitleAlternate.Title_Alternate_Talent.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code && i.Role_Code == GlobalParams.RoleCode_StarCast).Select(i => i.Talent_Code).ToList()));

            ////Program
            //RightsU_Entities.Title obj = objTitleS.GetById(objTitle.Title_Code);
            //if (obj.Program_Code > 0)
            //    ViewBag.ProgramList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "O"), "Display_Value", "Display_Text", obj.Program_Code).ToList();
            //else
            ViewBag.AlternateProgramList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "O"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();

            if (mode == "V")
            {
                if (producer_code != "")
                {
                    var producernames = string.Join(", ", (lstProducer.Where(y => producer_code.Split(',').Contains(y.Value.ToString())).Distinct().Select(i => i.Text)));
                    ViewBag.ProduceList = producernames.Trim(',');
                }
                else
                    ViewBag.ProduceList = "";

                if (Director_code != "")
                {
                    var Directornames = string.Join(", ", (lstDirector.Where(y => Director_code.Split(',').Contains(y.Value.ToString())).Distinct().Select(i => i.Text)));
                    ViewBag.DirectorList = Directornames.Trim(',');
                }
                else
                    ViewBag.DirectorList = "";

                if (StarCast_code != "")
                {
                    var StarCastnames = string.Join(", ", (lstStarCast.Where(y => StarCast_code.Split(',').Contains(y.Value.ToString())).Distinct().Select(i => i.Text)));
                    ViewBag.StarCastList = StarCastnames.Trim(',');
                }
                else
                    ViewBag.StarCastList = "";


                if (Country_codes != "")
                {
                    string[] arrCountryCodes = Country_codes.Split(',');
                    ViewBag.CountryList = string.Join(",", lstCountry.Where(y => arrCountryCodes.Contains(y.Value.ToString())).Distinct().OrderBy(x => x.Text).Select(i => i.Text)).Trim(',');
                }
                else
                    ViewBag.CountryList = "";



                var Geners_code = string.Join(",", (objTitleAlternate.Title_Alternate_Genres.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code).Select(i => i.Genres_Code).ToList()));
                if (Geners_code != "")
                {
                    var lstGenere = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G"), "Display_Value", "Display_Text", Geners_code.Split(',')).ToList();
                    var lstGenersNames = string.Join(", ", (lstGenere.Where(y => Geners_code.Split(',').Contains(y.Value.ToString())).OrderBy(x => x.Text).Distinct().Select(i => i.Text)));
                    ViewBag.GenresList = lstGenersNames.ToString().Trim(',');
                }
                else
                    ViewBag.GenresList = "";
            }
            else
            {
                ViewBag.ProduceList = new MultiSelectList(lstProducer, "Value", "Text", producer_code.Split(','));
                ViewBag.DirectorList = new MultiSelectList(lstDirector, "Value", "Text", Director_code.Split(','));
                ViewBag.StarCastList = new MultiSelectList(lstStarCast, "Value", "Text", StarCast_code.Split(','));
                ViewBag.CountryList = new MultiSelectList(lstCountry, "Value", "Text", Country_codes.Split(','));

                var Geners_code = string.Join(",", (objTitleAlternate.Title_Alternate_Genres.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code).Select(i => i.Genres_Code).ToList()));
                var lstGenres = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
                ViewBag.GenresList = new MultiSelectList(lstGenres, "Value", "Text", Geners_code.Split(','));
            }
        }
        public JsonResult ValidateAlternateIsDuplicate(string TitleName, int? alternateCode, string DealTypeCode)
        {

            TitleName = TitleName.Trim(' ');
            int Count = 0;
            int Deal_Type_Code = Convert.ToInt32(DealTypeCode);
            Count = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name == TitleName && x.Deal_Type_Code == Deal_Type_Code && x.Alternate_Config_Code == ConfigCode && x.Title_Alternate_Code != alternateCode).Distinct().Count();
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            if (Count > 0)
                objJson.Add("Message", "Title with same name already exists");
            else
                objJson.Add("Message", "");

            return Json(objJson);
        }
        public string SaveAlternateFile()
        {
            string ReturnMessage = "Y";
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var file = System.Web.HttpContext.Current.Request.Files["InputFile"];
                string filename = DateTime.Now.Ticks.ToString() + "_";
                filename += file.FileName;
                if (filename != "" && file.FileName != "")
                {
                    file.SaveAs(Server.MapPath(ConfigurationManager.AppSettings["TitleImagePath"] + filename));
                    TempData["TitleAlternate_Image"] = filename;
                }
                return ReturnMessage = "Y";
            }
            else
                return ReturnMessage = "N";
        }
        public JsonResult BindRoles()
        {
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT,LA,C,G,P,DR,S,RL,O", 0, 0, "").ToList();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("RoleList", new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "RL"), "Display_Value", "Display_Text").ToList());
            return Json(obj);
        }

        public bool calculateReleaseDate(int? titleCode)
        {
            bool release = false;
            DateTime parsedDate;

            var releaseDate = new Title_Release_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == titleCode).Select(s => s.Release_Date).Min();
            if (releaseDate != null)
            {
                parsedDate = Convert.ToDateTime(releaseDate).AddYears(1);

                DateTime firstDay = new DateTime(parsedDate.Year, 1, 1);
                DateTime ReleaseDate = firstDay.AddYears(60);
                if (DateTime.Now >= ReleaseDate)
                    release = true;
            }

            return release;
        }

        public JsonResult onSaveChange(int titleCode)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            var YEsOrNo = calculateReleaseDate(titleCode);
            objJson.Add("PDOMAIN", YEsOrNo);

            return Json(objJson);
        }
        public JsonResult SaveAlternate(RightsU_Entities.Title_Alternate objTitleModel, FormCollection objForm, string Deal_Type_Code, string Alternate_Title_Language_Code
           , string Alternate_Original_Language_Code, string ddlCountry, string hdnAlternateProducer, string hdnAlternateDirector, string hdnAlternateGenres, string hdnAlternateStarCast, string hdnAlternateCountry,
           string hdnmode, int? hdnTitleCodes, string Deal_type_Name, string hdnAlternateDealTypeCode, int? hdnTitleAlternateConfigCode, string hdnTitleTabName)
        {
            int TitleAlternateCode = 0;

            TitleAlternateCode = Convert.ToInt32(objTitleModel.Title_Alternate_Code);
            objTitleAlternate = objTitleS_Alternate.GetById(TitleAlternateCode);

            string newTitleImage = "", oldFileName = "";
            if (TempData["TitleAlternate_Image"] != null)
                newTitleImage = TempData["TitleAlternate_Image"].ToString();

            if (!string.IsNullOrEmpty(newTitleImage))
            {
                oldFileName = objTitleAlternate.Title_Image;
                objTitleAlternate.Title_Image = newTitleImage;
            }

            objTitleAlternate.Title_Name = objTitleModel.Title_Name;
            objTitleAlternate.Original_Title = objTitleModel.Original_Title;
            if (objForm["Year_Of_Release"] != "")
                objTitleAlternate.Year_Of_Production = Convert.ToInt32(objForm["Year_Of_Release"]);
            else
                objTitleAlternate.Year_Of_Production = null;

            if (objTitleModel.Synopsis == null)
                objTitleAlternate.Synopsis = "";
            else
                objTitleAlternate.Synopsis = objTitleModel.Synopsis.Replace("\r\n", "\n");

            objTitleAlternate.Last_UpDated_Time = DateTime.Now;
            objTitleAlternate.Last_Action_By = objLoginUser.Users_Code;
            objTitleAlternate.Inserted_By = objLoginUser.Users_Code;
            objTitleAlternate.Inserted_On = DateTime.Now;
            objTitleAlternate.Deal_Type_Code = objTitle.Deal_Type_Code;
            objTitleAlternate.Alternate_Config_Code = ConfigCode;
            objTitleAlternate.Title_Code = Convert.ToInt32(objForm["hdnTitleCodes"]);

            if (Alternate_Title_Language_Code != "0")
                objTitleAlternate.Title_Language_Code = Convert.ToInt32(objForm["Alternate_Title_Language_Code"]);
            else
                objTitleAlternate.Title_Language_Code = null;

            if (Alternate_Original_Language_Code != "" && Alternate_Original_Language_Code != "0")
                objTitleAlternate.Original_Language_Code = Convert.ToInt32(objForm["Alternate_Original_Language_Code"]);
            else
                objTitleAlternate.Original_Language_Code = null;

            #region ========= Genre creation =========
            objTitleAlternate.Title_Alternate_Genres.ToList().ForEach(i => i.EntityState = State.Deleted);

            string[] Genres_Codes = objForm["hdnAlternateGenres"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string genreCode in Genres_Codes)
            {
                if (genreCode != "")
                {
                    Title_Alternate_Genres objT = (Title_Alternate_Genres)objTitleAlternate.Title_Alternate_Genres.Where(t => t.Genres_Code == Convert.ToInt32(genreCode)).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Alternate_Genres();
                    if (objT.Title_Alternate_Genres_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Alternate_Code = TitleAlternateCode;
                        objT.Genres_Code = Convert.ToInt32(genreCode);
                        objTitleAlternate.Title_Alternate_Genres.Add(objT);
                    }
                }
            }
            #endregion

            objTitleAlternate.Title_Alternate_Talent.ToList().ForEach(i => i.EntityState = State.Deleted);

            #region ========= Director creation =========
            string[] Director_Codes = objForm["hdnAlternateDirector"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string directorCode in Director_Codes)
            {
                if (directorCode != "")
                {
                    Title_Alternate_Talent objT = (Title_Alternate_Talent)objTitleAlternate.Title_Alternate_Talent.Where(t => t.Talent_Code == Convert.ToInt32(directorCode) && t.Role_Code == GlobalParams.RoleCode_Director).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Alternate_Talent();
                    if (objT.Title_Alternate_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Alternate_Code = TitleAlternateCode;
                        objT.Talent_Code = Convert.ToInt32(directorCode);
                        objT.Role_Code = GlobalParams.RoleCode_Director;
                        objTitleAlternate.Title_Alternate_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= producer creation =========
            string[] Producer_Codes = objForm["hdnAlternateProducer"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string producerCode in Producer_Codes)
            {
                if (producerCode != "")
                {
                    Title_Alternate_Talent objT = (Title_Alternate_Talent)objTitleAlternate.Title_Alternate_Talent.Where(t => t.Talent_Code == Convert.ToInt32(producerCode) && t.Role_Code == GlobalParams.Role_code_Producer).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Alternate_Talent();
                    if (objT.Title_Alternate_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Talent_Code = Convert.ToInt32(producerCode);
                        objT.Title_Alternate_Code = TitleAlternateCode;
                        objT.Role_Code = GlobalParams.Role_code_Producer;
                        objTitleAlternate.Title_Alternate_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Star Cast creation =========
            string[] StarCast_Codes = objForm["hdnAlternateStarCast"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string starcastCode in StarCast_Codes)
            {
                if (starcastCode != "")
                {
                    Title_Alternate_Talent objT = (Title_Alternate_Talent)objTitleAlternate.Title_Alternate_Talent.Where(t => t.Talent_Code == Convert.ToInt32(starcastCode) && t.Role_Code == GlobalParams.RoleCode_StarCast).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Alternate_Talent();
                    if (objT.Title_Alternate_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Alternate_Code = TitleAlternateCode;
                        objT.Talent_Code = Convert.ToInt32(starcastCode);
                        objT.Role_Code = GlobalParams.RoleCode_StarCast;
                        objTitleAlternate.Title_Alternate_Talent.Add(objT);
                    }
                }
            }
            #endregion

            #region ========= Country of Origin creation =========
            objTitleAlternate.Title_Alternate_Country.ToList().ForEach(i => i.EntityState = State.Deleted);

            string[] Title_Alternate_Country_Codes = objForm["hdnAlternateCountry"].Split(new char[] { ',' }, StringSplitOptions.None);
            foreach (string CountryCodes in Title_Alternate_Country_Codes)
            {
                if (CountryCodes != "")
                {
                    Title_Alternate_Country objT = (Title_Alternate_Country)objTitleAlternate.Title_Alternate_Country.Where(t => t.Country_Code == Convert.ToInt32(CountryCodes)).Select(i => i).FirstOrDefault();
                    if (objT == null)
                        objT = new Title_Alternate_Country();
                    if (objT.Title_Alternate_Country_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Alternate_Code = TitleAlternateCode;
                        objT.Country_Code = Convert.ToInt32(CountryCodes);
                        objTitleAlternate.Title_Alternate_Country.Add(objT);
                    }
                }
            }
            #endregion

            objTitleAlternate.Title_Alternate_Code = TitleAlternateCode;
            if (objTitleAlternate.Title_Alternate_Code > 0)
                objTitleAlternate.EntityState = State.Modified;
            else
            {
                objTitleAlternate.EntityState = State.Added;
                objTitleAlternate.Is_Active = "Y";
            }
            dynamic resultset;
            bool isValid = objTitleS_Alternate.Save(objTitleAlternate, out resultset);

            objTitleS = null;

            if (objTitleAlternate.EntityState == State.Added)
            {
                Message = objMessageKey.AlternateTitleaddedsuccessfully;
            }
            else
            {
                Message = objMessageKey.AlternateTitleupdatedsuccessfully;
            }
            if (isValid)
            {
                if (!string.IsNullOrEmpty(newTitleImage) && !string.IsNullOrEmpty(oldFileName))
                {
                    string filepath = ConfigurationManager.AppSettings["TitleImagePath"].Trim('~');
                    string fullPath = (Server.MapPath("~") + "\\" + filepath);
                    string strActualFileNameWithDate;
                    string strFileName = oldFileName;
                    strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                    string fullpathname = fullPath + oldFileName; ;
                    System.IO.File.Delete(fullpathname.Trim());
                }
                objTitleAlternate = null;
            }
            PageNo = (PageNo == 0) ? 1 : PageNo;
            var objs = new
            {
                Status = isValid ? "S" : "E",
                Message = isValid ? Message : resultset,
                TabNAme = hdnTitleTabName,
                ConfigCode = hdnTitleAlternateConfigCode
            };

            return Json(objs);
        }

        #region---Title Import - from List Page---
        public ActionResult titleImport()
        {
            List<SelectListItem> lstFliter = new List<SelectListItem>();
            lstFliter.Add(new SelectListItem { Text = "All", Value = "A", Selected = true });
            lstFliter.Add(new SelectListItem { Text = "Error", Value = "E" });
            lstFliter.Add(new SelectListItem { Text = "In Process", Value = "Q" });
            lstFliter.Add(new SelectListItem { Text = "Resolve Conflict", Value = "R" });
            lstFliter.Add(new SelectListItem { Text = "Success", Value = "S" });
            ViewBag.FilterBy = lstFliter;
            ViewBag.FilterbyStatus = TempData["FilterByStatusTitle"] == null ? "A" : TempData["FilterByStatusTitle"];
            int PageNo = Convert.ToInt32(TempData["PageNoBackTitle"]);
            ViewBag.PageNoBack = PageNo == 0 ? 0 : PageNo - 1;
            ViewBag.txtPageSizeBack = TempData["txtPageSizeBackTitle"] == null ? 10 : TempData["txtPageSizeBackTitle"];

            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTitle);

            string ReturnViewName = "Title_Import";
            string Is_New_DM_TitleImport = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Advance_Title_Import").Select(x => x.Parameter_Value).FirstOrDefault();
            if (Is_New_DM_TitleImport == "Y")
            {
                ReturnViewName = "Title_Import_New";
            }
            return View(ReturnViewName);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitle), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
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
        public ActionResult Title_Milestone(int id = 0, int Page_No = 0, int PageSize = 10)
        {
            PageNo = Page_No;
            ViewBag.PageNo = PageNo;
            string moduleCode = GlobalParams.ModuleCodeForTitle.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(id);
            if (TempData["RecodLockingCode"] == "" || TempData["RecodLockingCode"] == null)
                ViewBag.RecordLockingCode = 0;
            else
                ViewBag.RecordLockingCode = TempData["RecodLockingCode"];
            int RecordLockingCode = Convert.ToInt32(TempData["RecodLockingCode"]);

            //if (RecordLockingCode > 0)
            //{
            //    CommonUtil objCommonUtil = new CommonUtil();
            //    objCommonUtil.Release_Record(RecordLockingCode, objLoginEntity.ConnectionStringName);
            //}
            lstTitle_Milestone = new Title_Milestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTitle);
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Title/Title_Milestone.cshtml");
        }
        public PartialViewResult BindTitleMilestoneList(int pageNo, int recordPerPage)
        {
            int RecordCount = 0;
            //List<RightsU_Entities.Title_Milestone> lst = new List<RightsU_Entities.Title_Milestone>();
            List<RightsU_Entities.USP_List_Title_Milestone_Result> lst = new List<RightsU_Entities.USP_List_Title_Milestone_Result>();
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            //lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Title_Milestone(pageNo, objRecordCount, "Y", recordPerPage, objTitle.Title_Code).ToList();


            // pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);

            lst = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Title_Milestone(pageNo, objRecordCount, "Y", recordPerPage, objTitle.Title_Code).ToList();

            ViewBag.UserModuleRights = GetUserModuleRights();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;

            return PartialView("~/Views/Title/_Title_Milestone.cshtml", lst);
        }

        public PartialViewResult AddEditTitle_Milestone(int Title_Milestone_Code, string Type = "")
        {

            Title_Milestone_Service objTM_Service = new Title_Milestone_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Title_Milestone objTM = null;

            if (Title_Milestone_Code > 0)
            {
                objTM = objTM_Service.GetById(Title_Milestone_Code);
            }
            else
                objTM = new RightsU_Entities.Title_Milestone();

            var TitleName = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Code == objTitle.Title_Code).Select(x => x.Title_Name).SingleOrDefault();
            int TitleCode = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Code == objTitle.Title_Code).Select(x => x.Title_Code).SingleOrDefault();
            ViewBag.TitleMilestonename = TitleName;
            ViewBag.TitleMilestoneCode = TitleCode;

            var lstTalent = new SelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Talent_Code", "Talent_Name");
            ViewBag.TalentList = lstTalent;
            ViewBag.Mode = Type;
            var lstMilestoneNature = new SelectList(new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList(), "Milestone_Nature_Code", "Milestone_Nature_Name");
            ViewBag.MilestoneNatureList = lstMilestoneNature;
            if (Type == "V")
            {
                ViewBag.TalentName = new Title_Milestone_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Title_Milestone_Code == Title_Milestone_Code).Select(s => s.Talent.Talent_Name).FirstOrDefault();
                ViewBag.MilestoneNatureName = new Title_Milestone_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Title_Milestone_Code == Title_Milestone_Code).Select(s => s.Milestone_Nature.Milestone_Nature_Name).FirstOrDefault();
            }
            return PartialView("~/Views/Title/_AddEditTitle_Milestone.cshtml", objTM);
        }


        public ActionResult SaveTitleMilestone(RightsU_Entities.Title_Milestone objTM_MVC, FormCollection objFormCollection)
        {
            //string TalentCode = objFormCollection["divddlTalent"];
            //string TitleNAme = objFormCollection["lblTitleMilestoneName"];
            string Expiry_Date = objFormCollection["Expiry_Date"];
            objTM_MVC.Expiry_Date = Convert.ToDateTime(GlobalUtil.MakedateFormat(Expiry_Date));


            Title_Milestone objTM = new Title_Milestone();
            Title_Milestone_Service ObjTMService = new Title_Milestone_Service(objLoginEntity.ConnectionStringName);
            if (objTM_MVC.Title_Milestone_Code > 0)
            {
                objTM = ObjTMService.GetById(objTM_MVC.Title_Milestone_Code);
                objTM.Last_Action_By = objLoginUser.Users_Code;
                objTM.EntityState = State.Modified;
            }
            else
            {
                objTM.EntityState = State.Added;
                objTM.Is_Active = "Y";
            }
            objTM.Title_Code = Convert.ToInt32(objFormCollection["hdnTitleMilestoneCode"]);
            //objTM.Talent_Code = Convert.ToInt32(objFormCollection["divddlTalent"]);
            //objTM.Milestone_Nature_Code = Convert.ToInt32(objFormCollection["divddlMilestoneNature"]);
            objTM.Talent_Code = objTM_MVC.Talent_Code;
            objTM.Milestone_Nature_Code = objTM_MVC.Milestone_Nature_Code;
            objTM.Expiry_Date = objTM_MVC.Expiry_Date;
            objTM.Milestone = objFormCollection["txtMilestone"];
            objTM.Action_Item = objFormCollection["txtAction"];
            //objTM.Is_Abandoned = objTM_MVC.Is_Abandoned;
            objTM.Is_Abandoned = objFormCollection["Abandoned"];
            objTM.Remarks = objTM_MVC.Remarks;
            objTM.Inserted_On = DateTime.Now;
            objTM.Inserted_by = objLoginUser.Users_Code;
            objTM.Last_Updated_Time = DateTime.Now;
            objTM.Last_Action_By = objLoginUser.Users_Code;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully";

            bool valid = ObjTMService.Save(objTM, out resultSet);

            if (valid)
            {
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                if (objTM_MVC.Title_Milestone_Code > 0)
                {
                    message = "Title Milestone updated successfully";
                    //message = message.Replace("{ACTION}", "updated");
                }
                else
                {
                    //message = message.Replace("{ACTION}", "added");
                    message = "Title Milestone added successfully";
                    //Mail(objU);
                }
                //FetchData();
            }
            else
            {
                status = "E";
                if (objTM_MVC.Title_Milestone_Code > 0)
                    message = message.Replace("Record {ACTION} successfully", resultSet);
                else
                    message = message.Replace("Record {ACTION} successfully", resultSet);
            };

            var obj = new
            {
                RecordCount = lstTitle_Milestone.Count(),
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public void Delete(int Title_Milestone_Code)
        {
            if (Title_Milestone_Code > 0)
            {
                Title_Milestone_Service objTitle_Milestone_Service = new Title_Milestone_Service(objLoginEntity.ConnectionStringName);
                Title_Milestone objTitle_Milestone = objTitle_Milestone_Service.GetById(Title_Milestone_Code);
                objTitle_Milestone.EntityState = State.Deleted;
                dynamic resultSet;
                objTitle_Milestone_Service.Save(objTitle_Milestone, out resultSet);
            }

        }

        public PartialViewResult UploadTitle(HttpPostedFileBase InputFile)
        {
            string message = "";
            List<USP_Insert_Title_Import_UDT> lstRE = new List<USP_Insert_Title_Import_UDT>();
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
                            DataTable dt = new DataTable();
                            cmdExcel.Connection = cn;
                            cn.Open();
                            DataTable dtExcelSchema;
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

                        if (ds.Tables[0].Columns[0].ColumnName != "Title" || ds.Tables[0].Columns[1].ColumnName != "Title Type"
                            || ds.Tables[0].Columns[2].ColumnName != "Title Language" || ds.Tables[0].Columns[3].ColumnName != "Year of Release"
                            || ds.Tables[0].Columns[4].ColumnName != "Duration (Min)" || ds.Tables[0].Columns[5].ColumnName != "Key Star Cast"
                            || ds.Tables[0].Columns[6].ColumnName != "Director" || ds.Tables[0].Columns[7].ColumnName != "Music Label"
                            || ds.Tables[0].Columns[8].ColumnName != "Synopsis" || ds.Tables[0].Columns.Count != 9)
                        {
                            message = "Please Don't Modify the name of the field in excel File";
                        }
                        else
                        {
                            if (ds.Tables[0].Columns.Count == 9)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    List<Title_Import_UDT> lst_Title_Import_UDT = new List<Title_Import_UDT>();
                                    foreach (DataRow row in ds.Tables[0].Rows)
                                    {
                                        Title_Import_UDT obj_Title_Import_UDT = new Title_Import_UDT();
                                        obj_Title_Import_UDT.Title_Name = row["Title"].ToString();
                                        obj_Title_Import_UDT.Title_Type = row["Title Type"].ToString();
                                        obj_Title_Import_UDT.Title_Language = row["Title Language"].ToString();
                                        obj_Title_Import_UDT.Duration = row["Duration (Min)"].ToString();
                                        obj_Title_Import_UDT.Director = row["Director"].ToString();
                                        obj_Title_Import_UDT.Key_Star_Cast = row["Key Star Cast"].ToString();
                                        obj_Title_Import_UDT.Year_of_Release = row["Year of Release"].ToString();
                                        obj_Title_Import_UDT.Synopsis = row["Synopsis"].ToString();
                                        obj_Title_Import_UDT.Music_Label = row["Music Label"].ToString();
                                        lst_Title_Import_UDT.Add(obj_Title_Import_UDT);
                                    }
                                    lstRE = new USP_Service(objLoginEntity.ConnectionStringName).USP_Insert_Title_Import_UDT(lst_Title_Import_UDT, objLoginUser.Users_Code).ToList();
                                    List<USP_Insert_Title_Import_UDT> lstshow = new List<USP_Insert_Title_Import_UDT>();
                                    if (lstRE.Count == 0)
                                    {
                                        message = objMessageKey.Savedsuccessfully;
                                    }
                                    else
                                    {
                                        foreach (USP_Insert_Title_Import_UDT item in lstRE)
                                            if (item.Error_Messages != "" && item.Error_Messages != null)
                                                lstshow.Add(item);
                                        lstRE = lstshow;
                                    }
                                    //else
                                    //    return PartialView("_TitleImport_List", lstRE);
                                }
                                else
                                {
                                    message = objMessageKey.PleaseFillTheDataIntheExcelFile;
                                }
                            }
                            else
                            {
                                message = objMessageKey.PleaseFillCorrectDataInTheExcelFile;
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
                    message = objMessageKey.PleaseSelectExcelFile;
                }

            }
            else
            {
                message = objMessageKey.PleaseSelectExcelFile;

            }
            ViewBag.Message = message;
            return PartialView("_TitleImport_List", lstRE);
        }

        public void SampleDownload()
        {
            string Is_New_DM_TitleImport = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Advance_Title_Import").Select(x => x.Parameter_Value).FirstOrDefault();
            string filePath;
            string Is_Allow_Program_Category = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Allow_Program_Category").ToList().FirstOrDefault().Parameter_Value;
            filePath = HttpContext.Server.MapPath("~/UploadFolder/Title_Import_" + DateTime.Now.ToString("ddMMyyyyhhmmss.fff") + ".xlsx");
            FileInfo flInfo = new FileInfo(filePath);
            FileInfo fliTemplate;

            if (Is_New_DM_TitleImport == "Y")
            {
                fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Title_Import_Utility_Sample.xlsx"));
                using (ExcelPackage package = new ExcelPackage(flInfo, fliTemplate))
                {
                    List<DM_Title_Import_Utility> lstTIU = new DM_Title_Import_Utility_Service(objLoginEntity.ConnectionStringName)
                                                            .SearchFor(x => x.Is_Active == "Y")
                                                            .OrderBy(y => y.Order_No)
                                                            .ToList();

                    ExcelWorksheet worksheet = package.Workbook.Worksheets[1];
                    int ColNo = 1, RowNo = 1;
                    Color colRed = System.Drawing.ColorTranslator.FromHtml("#F73131");
                    Color colGreen = System.Drawing.ColorTranslator.FromHtml("#8FD64B");

                    worksheet.Cells[RowNo, ColNo].Value = "Excel Sr. No";
                    worksheet.Cells[RowNo, ColNo].Style.Font.Bold = true;
                    worksheet.Cells[RowNo, ColNo].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    worksheet.Cells[RowNo, ColNo].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells[RowNo, ColNo].Style.Fill.BackgroundColor.SetColor(colRed);

                    foreach (DM_Title_Import_Utility item in lstTIU)
                    {
                        ColNo++;
                        worksheet.Cells[RowNo, ColNo].Value = item.Display_Name;
                        worksheet.Cells[RowNo, ColNo].Style.Font.Bold = true;
                        worksheet.Cells[RowNo, ColNo].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                        worksheet.Cells[RowNo, ColNo].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;

                        if (item.validation.Contains("man"))
                            worksheet.Cells[RowNo, ColNo].Style.Fill.BackgroundColor.SetColor(colRed);
                        else
                            worksheet.Cells[RowNo, ColNo].Style.Fill.BackgroundColor.SetColor(colGreen);
                    }

                    ColNo = 1;
                    for (int i = 1; i <= 2; i++)
                    {
                        RowNo = i + 1;
                        worksheet.Cells[RowNo, ColNo].Value = i;
                    }
                    package.Save();
                }
            }
            else
            {
                if (Is_Allow_Program_Category == "Y")
                {
                    fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Title_Import.xlsx"));
                }
                else
                {
                    fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Title_Import_Sample.xlsx"));

                }
                using (ExcelPackage package = new ExcelPackage(flInfo, fliTemplate))
                {
                    ExcelWorksheet worksheet = package.Workbook.Worksheets[1];
                    worksheet.Cells[1, 1].Value = objMessageKey.Srno;
                    worksheet.Cells[1, 2].Value = objMessageKey.Title;
                    worksheet.Cells[1, 3].Value = objMessageKey.OriginalTitle;
                    worksheet.Cells[1, 4].Value = objMessageKey.TitleType;
                    worksheet.Cells[1, 5].Value = objMessageKey.TitleLanguage;
                    worksheet.Cells[1, 6].Value = objMessageKey.OriginalLanguage;
                    worksheet.Cells[1, 7].Value = objMessageKey.YearOfRelease;
                    worksheet.Cells[1, 8].Value = objMessageKey.DurationInMin;
                    worksheet.Cells[1, 9].Value = objMessageKey.KeyStarCast;
                    worksheet.Cells[1, 10].Value = objMessageKey.Director;
                    worksheet.Cells[1, 11].Value = objMessageKey.MusicLabel;
                    if (Is_Allow_Program_Category == "Y")
                    {
                        worksheet.Cells[1, 12].Value = objMessageKey.TitleProgramCategory;
                        worksheet.Cells[1, 13].Value = objMessageKey.Synopsis;
                    }
                    else
                        worksheet.Cells[1, 12].Value = objMessageKey.Synopsis;
                    package.Save();
                }
            }
            WebClient client = new WebClient();
            Byte[] buffer = client.DownloadData(filePath);
            Response.Clear();
            Response.ContentType = "application/ms-excel";
            Response.AddHeader("content-disposition", "Attachment;filename=" + flInfo.Name);
            Response.BinaryWrite(buffer);

            Response.End();
        }

        public void DummySampleDownload(string TitleType)
        {
            string Is_New_DM_TitleImport = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Advance_Title_Import").Select(x => x.Parameter_Value).FirstOrDefault();
            string filePath;
            filePath = HttpContext.Server.MapPath("~/UploadFolder/Title_Import_" + DateTime.Now.ToString("ddMMyyyyhhmmss.fff") + ".xlsx");
            FileInfo fileInfo = new FileInfo(filePath);
            FileInfo fileTemplate;

            fileTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Title_Import_Utility_Sample.xlsx"));
            using (ExcelPackage exlPackage = new ExcelPackage(fileInfo, fileTemplate))
            {
                List<DM_Title_Import_Utility> lstDMtIU = new DM_Title_Import_Utility_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").OrderBy(o => o.Order_No).ToList();
                //List<DM_Title_Import_Utility_Test> lstDMtIU = new List<DM_Title_Import_Utility_Test>();
                //lstDMtIU = GenericListData();
                ExcelWorksheet exlWorksheet = exlPackage.Workbook.Worksheets[1];
                int ColNo = 1, RowNo = 1;
                Color colRed = System.Drawing.ColorTranslator.FromHtml("#F73131");
                Color colGreen = System.Drawing.ColorTranslator.FromHtml("#8FD64B");

                exlWorksheet.Cells[RowNo, ColNo].Value = "Excel Sr. No";
                exlWorksheet.Cells[RowNo, ColNo].Style.Font.Bold = true;
                exlWorksheet.Cells[RowNo, ColNo].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                exlWorksheet.Cells[RowNo, ColNo].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                exlWorksheet.Cells[RowNo, ColNo].Style.Fill.BackgroundColor.SetColor(colRed);

                if (TitleType == "M")
                {
                    lstDMtIU = lstDMtIU.Where(w => w.Import_Type == "M").ToList();
                }
                else if (TitleType == "S")
                {
                    lstDMtIU = lstDMtIU.Where(w => w.Import_Type == "S").ToList();
                }
                else
                {
                    lstDMtIU = lstDMtIU.Where(w => w.Import_Type == null).ToList();
                }
                foreach (var item in lstDMtIU)
                {
                    ColNo++;
                    exlWorksheet.Cells[RowNo, ColNo].Value = item.Display_Name;
                    exlWorksheet.Cells[RowNo, ColNo].Style.Font.Bold = true;
                    exlWorksheet.Cells[RowNo, ColNo].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    exlWorksheet.Cells[RowNo, ColNo].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;

                    if (item.validation.Contains("man"))
                    {
                        exlWorksheet.Cells[RowNo, ColNo].Style.Fill.BackgroundColor.SetColor(colRed);
                    }
                    else
                    {
                        exlWorksheet.Cells[RowNo, ColNo].Style.Fill.BackgroundColor.SetColor(colGreen);
                    }
                }

                ColNo = 1;
                for (int i = 1; i <= 2; i++)
                {
                    RowNo = i + 1;
                    exlWorksheet.Cells[RowNo, ColNo].Value = i;
                }
                exlPackage.Save();
            }

            WebClient client = new WebClient();
            Byte[] buffer = client.DownloadData(filePath);
            Response.Clear();
            Response.ContentType = "application/ms-excel";
            Response.AddHeader("content-disposition", "Attachment;filename=" + fileInfo.Name);
            Response.BinaryWrite(buffer);

            Response.End();
        }

        //public List<DM_Title_Import_Utility_Test> GenericListData()
        //{
        //    List<DM_Title_Import_Utility_Test> lst = new List<DM_Title_Import_Utility_Test>()
        //    {
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Movie Name", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "man", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "M" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Movie Type", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "M" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Language", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "M" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Release Year", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "M" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Movie Desc", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "M" },

        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Show Name", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "man", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "S" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Show Type", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "S" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Language", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "S" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Release Year", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "S" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Show Desc", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "S" },
        //        new DM_Title_Import_Utility_Test(){ DM_Title_Import_Utility_Code = 1, Display_Name = "Episode No", Order_No = 1, Target_Table = "Title", Target_Column = "Title_Name", Colum_Type = "TEXT", Is_Multiple = "N", Reference_Table = "NULL", Reference_Text_Field = "Null_txt", Reference_Value_Field = "NUll", Reference_Whr_Criteria = "", Is_Active = "Y", validation = "man", Is_Allowed_For_Resolve_Conflict = "N", ShortName = "Null", Import_Type = "S" }
        //    };

        //    return lst;
        //}

        /*
        public void SampleDownload()
        {
            string filePath;
            string Is_Allow_Program_Category = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "Is_Allow_Program_Category").ToList().FirstOrDefault().Parameter_Value;
            filePath = HttpContext.Server.MapPath("~/UploadFolder/Title_Import_" + DateTime.Now.ToString("ddMMyyyyhhmmss.fff") + ".xlsx");
            FileInfo flInfo = new FileInfo(filePath);
            FileInfo fliTemplate;
            if (Is_Allow_Program_Category == "Y")
            {
                fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Title_Import.xlsx"));
            }
            else
            {
                fliTemplate = new FileInfo(HttpContext.Server.MapPath("~/Download/Title_Import_Sample.xlsx"));

            }
            using (ExcelPackage package = new ExcelPackage(flInfo, fliTemplate))
            {
                ExcelWorksheet worksheet = package.Workbook.Worksheets[1];
                worksheet.Cells[1, 1].Value = objMessageKey.Srno;
                worksheet.Cells[1, 2].Value = objMessageKey.Title;
                worksheet.Cells[1, 3].Value = objMessageKey.OriginalTitle;
                worksheet.Cells[1, 4].Value = objMessageKey.TitleType;
                worksheet.Cells[1, 5].Value = objMessageKey.TitleLanguage;
                worksheet.Cells[1, 6].Value = objMessageKey.OriginalLanguage;
                worksheet.Cells[1, 7].Value = objMessageKey.YearOfRelease;
                worksheet.Cells[1, 8].Value = objMessageKey.DurationInMin;
                worksheet.Cells[1, 9].Value = objMessageKey.KeyStarCast;
                worksheet.Cells[1, 10].Value = objMessageKey.Director;
                worksheet.Cells[1, 11].Value = objMessageKey.MusicLabel;
                if (Is_Allow_Program_Category == "Y")
                {
                    worksheet.Cells[1, 12].Value = objMessageKey.TitleProgramCategory;
                    worksheet.Cells[1, 13].Value = objMessageKey.Synopsis;
                }
                else
                    worksheet.Cells[1, 12].Value = objMessageKey.Synopsis;
                package.Save();
            }

            WebClient client = new WebClient();
            Byte[] buffer = client.DownloadData(filePath);
            Response.Clear();
            Response.ContentType = "application/ms-excel";
            Response.AddHeader("content-disposition", "Attachment;filename=" + flInfo.Name);
            Response.BinaryWrite(buffer);

            Response.End();
        }
        */
        #endregion

        #region---Deal Details - Title View ---
        [HttpPost]
        public PartialViewResult Bind_Deal_List(int txtpageSize = 1, int page_index = 0, string IsCallFromPaging = "N", int id = 0, int Page_No = 0, string DealTypeCode = "0",
            string SearchedTitle = "", int TitlePageSize = 10)
        {
            ViewBag.Mode = "LIST";
            int PageNo = page_index <= 0 ? 1 : page_index + 1;
            List<USP_Title_Deal_Info_Result> lst = new List<USP_Title_Deal_Info_Result>();
            if (objTitle != null && lst_Deal_Info.Count == 0)
                lst_Deal_Info = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Deal_Info(objTitle.Title_Code, objLoginUser.Users_Code).ToList();
            List<USP_Title_Deal_Info_Result> list;
            PageNo = page_index + 1;
            list = lst_Deal_Info.SkipWhile(s => s.Group_No <= (PageNo - 1) * txtpageSize)
                                .TakeWhile(s => s.Group_No > (PageNo - 1) * txtpageSize && s.Group_No <= PageNo * txtpageSize).ToList();
            //list.ForEach(
            //    x =>
            //    {
            //        x.Current_Page_No = PageNo;
            //        x.Total_Record_Count = lst_Deal_Info.Count;
            //    });
            //list = lst_Deal_Info.SkipWhile(s => s.Group_No <= 0)
            //                    .TakeWhile(s => s.Group_No > 0  && s.Group_No <= 1).ToList();
            if (lst_Deal_Info.Count > 0)
            {
                ViewBag.RecordCount = lst_Deal_Info.Count;
                ViewBag.RecordCount_paging = lst_Deal_Info.Select(i => i.Group_No).Max();
            }
            else
            {
                ViewBag.RecordCount = 0;
                ViewBag.RecordCount_paging = 0;
            }
            ViewBag.TitlePage_No = Page_No;
            ViewBag.Title_Code = id;
            ViewBag.DealTypeCode = DealTypeCode;
            ViewBag.SearchedTitle = SearchedTitle;
            ViewBag.PageNo = PageNo;
            ViewBag.PageSize = TitlePageSize;
            ViewBag.DealListPageNo = page_index;
            ViewBag.DealListPageSize = txtpageSize;
            return PartialView("_Title_Deal_Info", list);
        }
        #endregion

        #region Aeroplay Catelog
        public ActionResult BindTitleMetadataHeader()
        {
            List<Extended_Group> objExt_Grp = new List<Extended_Group>();
            objExt_Grp = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == GlobalParams.ModuleCodeForTitle && x.IsActive == "Y").OrderBy(x => x.Group_Order).ToList();
            ViewBag.ExtendedGroup = objExt_Grp;
            return PartialView("~/Views/Title/_Title_Metadata_Header.cshtml", objExt_Grp);
        }

        public string BindTabwisePopup(int Ext_Grp_Code, int rowno = 0, int num = 0, int Title_Code = 0)
        {
            string Operation = "A";
            if (rowno > 0) Operation = "E";
            string TabShortName = "";

            var lstextCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Name != "Program Category").ToList();
            var lstextGrpConfig = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code == Ext_Grp_Code).ToList();
            var objExt_Grp = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == GlobalParams.ModuleCodeForTitle && x.Add_Edit_Type == "grid").OrderBy(x => x.Group_Order).ToList();
            lstextGrpConfig = lstextGrpConfig.Where(w => objExt_Grp.Any(a => w.Extended_Group_Code == a.Extended_Group_Code)).ToList();
            lstextCol = lstextCol.Where(w => lstextGrpConfig.Any(a => w.Columns_Code == a.Columns_Code)).ToList();
            TabShortName = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code == Ext_Grp_Code).Select(x => x.Short_Name).FirstOrDefault();
            ViewBag.TabwiseName = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code == Ext_Grp_Code).FirstOrDefault();
            ViewBag.ExtendedColums = lstextCol;
            var lstEditRecord = lstAddedExtendedColumns;
            var lstEditRecordDB = gvExtended;

            if (Operation == "E")
            {
                if (lstAddedExtendedColumns.Count != 0 && lstAddedExtendedColumns.Count(x => x.Record_Code == Title_Code && x.Row_No == rowno) != 0 && gvExtended.Count != 0)
                {
                    lstEditRecord = lstAddedExtendedColumns.Where(x => x.Record_Code == Title_Code && x.Row_No == rowno).ToList();
                    var lstColumnRowNo = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Row_No != null).Where(x => x.Record_Code == Title_Code && x.Row_No == rowno).Distinct().ToList();
                    lstEditRecordDB = gvExtended.Where(w => lstColumnRowNo.Any(a => w.Map_Extended_Columns_Code == a.Map_Extended_Columns_Code)).ToList();
                }
                else if (lstAddedExtendedColumns.Count != 0 && lstAddedExtendedColumns.Count(x => x.Record_Code == Title_Code && x.Row_No == rowno) != 0)
                {
                    lstEditRecord = lstAddedExtendedColumns.Where(x => x.Record_Code == Title_Code && x.Row_No == rowno).ToList();
                }
                else if (gvExtended.Count != 0)
                {
                    var lstColumnRowNo = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Row_No != null).Where(x => x.Record_Code == Title_Code && x.Row_No == rowno).Distinct().ToList();
                    lstEditRecordDB = gvExtended.Where(w => lstColumnRowNo.Any(a => w.Map_Extended_Columns_Code == a.Map_Extended_Columns_Code)).ToList();
                }
            }

            string strAddRow = "";

            strAddRow = "<style>input:invalid {background-color: white;border-color: #bbb;} .RequiredClass{background-color: rgba(155,0,0,0.1) !important;border-color: red !important;} </style><Table class=\"table table-bordered table-hover\" style=\"padding:10px;\">";

            string prevRowTitle = "";
            int i = 1, j = 1, k = 1, l = 1, m = 1;

            foreach (var TabControls in lstextCol)
            {
                string SelectedValues = null ?? "";
                strAddRow = strAddRow.Replace("utospltag", "");
                strAddRow = strAddRow + "<tr>";
                strAddRow = strAddRow + "<td style=\"width: 40%;\">";
                strAddRow = strAddRow + TabControls.Columns_Name;
                strAddRow = strAddRow + "</td>";
                strAddRow = strAddRow + "<td>";
                prevRowTitle = TabControls.Columns_Name;
                ConfigCode = TabControls.Columns_Code;

                if (Operation == "E")
                {
                    if (TabControls.Control_Type == "DDL" && TabControls.Is_Multiple_Select == "N")
                    {
                        if (lstEditRecord.Count(x => x.Record_Code == Title_Code && x.Row_No == rowno && x.Columns_Code == TabControls.Columns_Code) > 0)
                        {
                            SelectedValues = Convert.ToString(lstEditRecord.Where(x => x.Row_No == rowno && x.Columns_Code == TabControls.Columns_Code).Select(x => x.Columns_Value_Code).FirstOrDefault());
                        }
                        else
                        {
                            SelectedValues = Convert.ToString(lstEditRecordDB.Where(w => lstextCol.Any(a => w.Columns_Code == a.Columns_Code) && w.Columns_Code == TabControls.Columns_Code).Select(w => w.Columns_Value_Code).FirstOrDefault());
                        }
                    }
                    else if (TabControls.Control_Type == "DDL" && TabControls.Is_Multiple_Select == "Y")
                    {
                        if (lstEditRecord.Count(x => x.Record_Code == Title_Code && x.Row_No == rowno && x.Columns_Code == TabControls.Columns_Code) > 0)
                        {
                            var EditRecordObj = lstEditRecord.Where(x => x.Row_No == rowno && x.Columns_Code == TabControls.Columns_Code).FirstOrDefault();
                            string a = string.Join(",", EditRecordObj.Map_Extended_Columns_Details.Select(s => s.Columns_Value_Code).ToList());
                            SelectedValues = Convert.ToString(a);
                        }
                        else
                        {
                            SelectedValues = Convert.ToString(lstEditRecordDB.Where(w => lstextCol.Any(a => w.Columns_Code == a.Columns_Code) && w.Columns_Code == TabControls.Columns_Code).Select(w => w.Columns_Value_Code1).FirstOrDefault());
                        }
                    }
                    else if (TabControls.Control_Type == "TXT" || TabControls.Control_Type == "INT" || TabControls.Control_Type == "DBL" || TabControls.Control_Type == "DATE" || TabControls.Control_Type == "CHK")
                    {
                        if (lstEditRecord.Count(x => x.Record_Code == Title_Code && x.Row_No == rowno && x.Columns_Code == TabControls.Columns_Code) > 0)
                        {
                            SelectedValues = Convert.ToString(lstEditRecord.Where(x => x.Row_No == rowno && x.Columns_Code == TabControls.Columns_Code).Select(x => x.Column_Value).FirstOrDefault());
                        }
                        else
                        {
                            SelectedValues = Convert.ToString(lstEditRecordDB.Where(w => lstextCol.Any(a => w.Columns_Code == a.Columns_Code) && w.Columns_Code == TabControls.Columns_Code).Select(w => w.Name).FirstOrDefault());
                        }
                    }

                }

                string required = "";
                string CustomDataDuplicateAttr = "";
                var objExtGrpConfig = lstextGrpConfig.Where(w => w.Columns_Code == TabControls.Columns_Code).FirstOrDefault();
                if (objExtGrpConfig.Validations != null && objExtGrpConfig.Validations.Contains("man"))
                {
                    required = "required";
                }
                if (objExtGrpConfig.Validations != null && objExtGrpConfig.Validations.Contains("dup"))
                {
                    CustomDataDuplicateAttr = "data-validate-duplicate = \"Y\"";
                }

                if (TabControls.Control_Type == "DDL" && TabControls.Is_Multiple_Select == "N")
                {
                    strAddRow = strAddRow + getDDL(lstextCol, TabControls.Columns_Code, i, Operation, "", Ext_Grp_Code, TabShortName, SelectedValues, required, CustomDataDuplicateAttr);
                    i++;
                }
                else if (TabControls.Control_Type == "DDL" && TabControls.Is_Multiple_Select == "Y")
                {
                    strAddRow = strAddRow + getDDL(lstextCol, TabControls.Columns_Code, i, Operation, "multiple", Ext_Grp_Code, TabShortName, SelectedValues, required, CustomDataDuplicateAttr);
                    i++;
                }
                else if (TabControls.Control_Type == "TXT")
                {
                    strAddRow = strAddRow + getTXT(TabControls.Columns_Code, j, Operation, "", Ext_Grp_Code, TabShortName, SelectedValues, required, CustomDataDuplicateAttr);
                    j++;
                }
                else if (TabControls.Control_Type == "DATE")
                {
                    strAddRow = strAddRow + getDATE(TabControls.Columns_Code, k, Operation, "", Ext_Grp_Code, TabShortName, SelectedValues, required, CustomDataDuplicateAttr);
                    k++;
                }
                else if (TabControls.Control_Type == "INT")
                {
                    strAddRow = strAddRow + getNumber(TabControls.Columns_Code, l, Operation, "", Ext_Grp_Code, TabShortName, SelectedValues, required, CustomDataDuplicateAttr);
                    l++;
                }
                else if (TabControls.Control_Type == "DBL")
                {
                    strAddRow = strAddRow + getDBL(TabControls.Columns_Code, l, Operation, "", Ext_Grp_Code, TabShortName, SelectedValues, required, CustomDataDuplicateAttr);
                    l++;
                }
                else if (TabControls.Control_Type == "CHK")
                {
                    strAddRow = strAddRow + getCheckbox(TabControls.Columns_Code, m, Operation, "", Ext_Grp_Code, TabShortName, SelectedValues, required, CustomDataDuplicateAttr);
                    m++;
                }

                strAddRow = strAddRow + " utospltag </td></tr>";
            }
            strAddRow = strAddRow.Replace("utospltag", "");
            strAddRow = strAddRow + "<TR style=\"background-color: #EEEEEE;\"><td style=\"text-align: left;\" colspan=2><input type=\"submit\" id=\"btnSaveDeal\" class=\"btn btn-primary\" value=\"Save\" style=\"margin-right: 4px;\" onclick=\"return SavePopup(this,'" + rowno.ToString() + "'); \"><input type=\"submit\" id=\"btnSaveDeal\" class=\"btn btn-primary\" value=\"Cancel\" onclick=\"closeEdit(" + num + "); \"></td></TR>";

            strAddRow = strAddRow + "</Table>";

            return strAddRow;
        }

        public PartialViewResult BindFieldGrid(int TitleCode, string operation = "")
        {
            ViewBag.hdnTitleCode = TitleCode;
            ViewBag.mode = operation;
            return PartialView("_Title_Popup_Grid_Result");
        }

        public JsonResult URL_BindDynamicGrid(int title_code = 0, int Ext_Grp_Code = 0, string operation = "")
        {
            string strtableHeader = "";
            string tabNames = "";
            string tabTable = "";
            string[] arrStr;
            int i = 1;
            int j = 1;

            var lstextCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Name != "Program Category").ToList();
            var lstextGrpConfig = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code != null).ToList();
            var objExt_Grp = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == GlobalParams.ModuleCodeForTitle && x.Add_Edit_Type == "grid").OrderBy(x => x.Group_Order).ToList();
            lstextGrpConfig = lstextGrpConfig.Where(w => objExt_Grp.Any(a => w.Extended_Group_Code == a.Extended_Group_Code)).ToList();
            lstextCol = lstextCol.Where(w => lstextGrpConfig.Any(a => w.Columns_Code == a.Columns_Code)).ToList();

            Dictionary<string, object> obj = new Dictionary<string, object>();           
                foreach (Extended_Group EG in objExt_Grp)
                {
                    tabNames = tabNames + EG.Short_Name + ",";
                    if (i != 1)
                    {
                        tabTable = tabTable + "<div class=\"tab - pane active\" style=\"display:none;\" id=\"tblMain" + EG.Short_Name + "\">";
                    }
                    else
                    {
                        tabTable = tabTable + "<div class=\"tab - pane active\" id=\"tblMain" + EG.Short_Name + "\">";
                        obj.Add("TabName", EG.Short_Name);
                    }

                    var extGrpConfigLst = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code == EG.Extended_Group_Code).Select(x => x.Columns_Code).ToList();
                    var extColLst = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => extGrpConfigLst.Contains((x.Columns_Code))).ToList();

                    strtableHeader = GetTableHeader(EG.Extended_Group_Code, EG.Short_Name, extColLst, "grid", operation);
                    //List<USP_SUPP_Create_Table_Result> rowList = objUspService.USP_SUPP_Create_Table_Result(ST.Supplementary_Tab_Code, objDeal_Schema.Deal_Code, supplementary_Code.ToString(), ViewOperation).ToList(); //string.Join(",", titleList.Select(a => a.Title_Code).ToList())
                    string str = BindPopupGridResult(extColLst, EG.Short_Name, operation, title_code, EG.Extended_Group_Code);

                    arrStr = strtableHeader.Split('~');

                    tabTable = tabTable + "<div class=\"scale_table_block\">";
                    tabTable = tabTable + "<table class=\"table table-bordered table-hover tblGridBind\"  id=\"tbl" + EG.Short_Name + "\">" + arrStr[0] + str + "</table>";

                    tabTable = tabTable + "<input type=\"hidden\" name=\"hdn" + EG.Short_Name + "\" id=\"hdn" + EG.Short_Name + "\" Value='" + arrStr[1] + "'/>";
                    tabTable = tabTable + "<input type=\"hidden\" name=\"hdnwt" + EG.Short_Name + "\" id=\"hdnwt" + EG.Short_Name + "\" Value='" + EG.Add_Edit_Type + "'/>";

                    tabTable = tabTable + "</div></div>";
                    i++;
                }

                tabNames = tabNames.Substring(0, tabNames.Length - 1);
                    
            obj.Add("FieldList", _fieldList.TrimEnd(','));
            obj.Add("tabNames", tabNames);
            obj.Add("Divs", tabTable);

            return Json(obj);
        }

        public string GetTableHeader(int tabCode, string Short_Name, List<Extended_Columns> ListExtended_Columns_Data, string WindowType, string ViewOperation)
        {
            string strPrevHeader = "";
            string strtableHeader = "<tr>";
            string strAddRow = "<tr id = \"add" + Short_Name + "\" style=\"display:none;\">";

            //List<USP_Acq_SUPP_Tab_Result> columnList = objUspService.USP_Acq_SUPP_Tab_Result(tabCode).ToList();
            List<Extended_Columns> columnList = ListExtended_Columns_Data.ToList();
            int i = 1, j = 1, k = 1, l = 1, m = 1;
            double width = 0, viewWidth = 5;
            if (ViewOperation != "VIEW")
                width = 100 / columnList.Count() - 10;
            else
            {
                viewWidth = columnList.Count > 5 ? 5 : 10;
                width = (100 - viewWidth) / columnList.Count();
            }

            width = Math.Round(width);

            //var extGrpConfigLst = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code == tabCode).Select(x => x.Columns_Code).ToList();
            //var extColLst = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => extGrpConfigLst.Contains((x.Columns_Code))).ToList();

            foreach (Extended_Columns EC in columnList)
            {
                var lstextGrpConfig = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Extended_Group_Code != null).ToList();
                var objExt_Grp = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == GlobalParams.ModuleCodeForTitle && x.Add_Edit_Type == "grid").OrderBy(x => x.Group_Order).ToList();
                lstextGrpConfig = lstextGrpConfig.Where(w => objExt_Grp.Any(a => w.Extended_Group_Code == a.Extended_Group_Code)).ToList();
                int? TabCodeGrid = 0;
                TabCodeGrid = lstextGrpConfig.Where(w => w.Columns_Code == EC.Columns_Code).Select(w => w.Extended_Group_Code).FirstOrDefault();
                if (strPrevHeader != "" && strPrevHeader == EC.Columns_Name)
                {
                    strtableHeader = strtableHeader.Replace("UTOsplTag", " colspan=2 ");
                }
                else
                {
                    strtableHeader = strtableHeader.Replace("UTOsplTag", "");
                    strtableHeader = strtableHeader + "<th style=\"width:" + width + "%\" data-configitem =\"" + TabCodeGrid + "\" UTOsplTag> " + EC.Columns_Name + "</th>";
                    strPrevHeader = EC.Columns_Name;
                }

                if (WindowType == "grid")
                {
                    if (EC.Control_Type == "DDL")
                    {
                        _fieldList = _fieldList + Short_Name + "ddPopup" + i.ToString() + "~" + EC.Columns_Code.ToString() + ",";
                        i++;
                    }
                    else if (EC.Control_Type == "TXT")
                    {
                        _fieldList = _fieldList + Short_Name + "txtPopup" + j.ToString() + "~" + EC.Columns_Code.ToString() + ",";
                        j++;
                    }
                    else if (EC.Control_Type == "DATE")
                    {
                        _fieldList = _fieldList + Short_Name + "dtPopup" + k.ToString() + "~" + EC.Columns_Code.ToString().ToString() + ",";
                        k++;
                    }
                    else if (EC.Control_Type == "INT")
                    {
                        _fieldList = _fieldList + Short_Name + "numPopup" + l.ToString() + "~" + EC.Columns_Code.ToString() + ",";
                        l++;
                    }
                    else if (EC.Control_Type == "DBL")
                    {
                        _fieldList = _fieldList + Short_Name + "numPopup" + l.ToString() + "~" + EC.Columns_Code.ToString() + ",";
                        l++;
                    }
                    else if (EC.Control_Type == "CHK")
                    {
                        _fieldList = _fieldList + Short_Name + "chkPopup" + m.ToString() + "~" + EC.Columns_Code.ToString() + ",";
                        m++;
                    }
                }

            }
            strtableHeader = strtableHeader.Replace("UTOsplTag", "");
            if (ViewOperation != "VIEW")
            {
                strtableHeader = strtableHeader + "<th style=\"width:" + viewWidth + "%\"> Action </th>";
            }
            strtableHeader = strtableHeader + "</tr>";

            if (WindowType == "inLine")
            {
                strAddRow = strAddRow + "<td style=\"text-align: center;\"><a class=\"glyphicon glyphicon-ok-circle\" onclick = \"SavePopup(this,0);\" style=\"padding: 3px;\"></a><a class=\"glyphicon glyphicon-remove-circle\" onclick = \"hideaddPopup();\"></a></td>";
                strAddRow = strAddRow + "</tr>";
                strtableHeader = strtableHeader + strAddRow;
            }
            else
            {
                i = columnList.Count(a => a.Control_Type == "TXTDDL") + 1;
            }

            return strtableHeader + "~" + (i - 1).ToString();
        }
        public string getDDL(List<Extended_Columns> ExtendedColumns, int Columns_Code, int i, string Operation, string multiple, int Ext_Grp_Code, string TabShortName, string SelectedValues, string required, string ValDuplicate)
        {
            string strDDL;
            int RoleCode = 0;
            if (SelectedValues == null)
                SelectedValues = "";

            string[] SelectedList = SelectedValues.Split(',');

            if (multiple == "")
            {
                strDDL = "<select class=\"sumoUnder form_input chosen-select\" placeholder=\"Please Select\" id=\"" + Operation + TabShortName + "ddPopup" + i.ToString() + "\" name=\"" + Operation + TabShortName + "ddPopup" + i.ToString() + "\" " + required + " " + ValDuplicate + ">";
                strDDL = strDDL + "<option value=\"''\" disabled selected style=\"display: none !important;\">Please Select</option>";
            }
            else
            {
                strDDL = "<select class=\"sumoUnder form_input chosen-select\" placeholder=\"Please Select\" id=\"" + Operation + TabShortName + "ddPopup" + i.ToString() + "\" name=\"" + Operation + TabShortName + "ddPopup" + i.ToString() + "\" " + multiple + " " + required + " " + ValDuplicate + ">";
            }

            var ExtendedColumn = ExtendedColumns.Where(x => x.Columns_Code == Columns_Code).FirstOrDefault();
            if (ExtendedColumn.Is_Ref == "Y" && ExtendedColumn.Is_Defined_Values == "N" && ExtendedColumn.Ref_Table == "TALENT")
            {
                if (ExtendedColumn.Additional_Condition != "" && ExtendedColumn.Additional_Condition != null)
                    RoleCode = Convert.ToInt32(ExtendedColumn.Additional_Condition);
                var lstTalentCol = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Role.Any(TR => TR.Role_Code == RoleCode)).Where(y => y.Is_Active == "Y").ToList();

                foreach (var T in lstTalentCol)
                {
                    if (SelectedList.Contains(T.Talent_Code.ToString()))
                    {
                        strDDL = strDDL + "<option value=" + T.Talent_Code + " selected>" + T.Talent_Name + "</option>";
                    }
                    else
                    {
                        strDDL = strDDL + "<option value=" + T.Talent_Code + ">" + T.Talent_Name + "</option>";
                    }
                }
            }
            else
            {
                var lstextColVal = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Columns_Code).ToList();
                foreach (Extended_Columns_Value ECV in lstextColVal)
                {
                    if (SelectedList.Contains(ECV.Columns_Value_Code.ToString()))
                    {
                        strDDL = strDDL + "<option value=" + ECV.Columns_Value_Code + " selected>" + ECV.Columns_Value + "</option>";
                    }
                    else
                    {
                        strDDL = strDDL + "<option value=" + ECV.Columns_Value_Code + ">" + ECV.Columns_Value + "</option>";
                    }
                }
            }

            strDDL = strDDL + "</select>";

            _fieldList = _fieldList + Columns_Code + "ddPopup" + i.ToString() + "~" + ConfigCode.ToString() + ",";

            return strDDL;
        }
        public string getTXT(int Columns_Code, int i, string Operation, string multiple, int Ext_Grp_Code, string TabShortName, string SelectedValues, string required, string ValDuplicate)
        {
            string getText = "<input type=\"text\" id=\"" + Operation + TabShortName + "txtPopup" + i.ToString() + "\" name=\"" + Operation + TabShortName + "txtPopup" + i.ToString() + "\" value=\"" + SelectedValues + "\"" + required + " " + ValDuplicate + " style=\"width:100%\" maxlength=\"1000\" >";
            _fieldList = _fieldList + Columns_Code + "txtPopup" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getText;
        }
        public string getDATE(int Columns_Code, int i, string Operation, string multiple, int Ext_Grp_Code, string TabShortName, string SelectedValues, string required, string ValDuplicate)
        {
            string getDATE = "<input type=\"text\" class=\"datepicker\" id =\"" + Operation + TabShortName + "dtPopup" + i.ToString() + "\" name=\"" + Operation + TabShortName + "dtPopup" + i.ToString() + "\" placeholder=\"DD / MM / YYYY\" style=\"height: 30px width:125px; \" value=\"" + SelectedValues + "\"" + required + " " + ValDuplicate + ">";
            _fieldList = _fieldList + TabShortName + "dtPopup" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getDATE;
        }
        public string getNumber(int Columns_Code, int i, string Operation, string multiple, int Ext_Grp_Code, string TabShortName, string SelectedValues, string required, string ValDuplicate)
        {
            string getNumber = "<input type=\"number\" min=\"0\" onkeypress=\"return !(event.charCode == 46)\" value=\"" + "" + "\" id=\"" + Operation + TabShortName + "numPopup" + i.ToString() + "\" name=\"" + Operation + TabShortName + "numPopup" + i.ToString() + "\"" + required + " " + ValDuplicate + ">";
            _fieldList = _fieldList + TabShortName + "numPopup" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getNumber;
        }
        public string getDBL(int Columns_Code, int i, string Operation, string multiple, int Ext_Grp_Code, string TabShortName, string SelectedValues, string required, string ValDuplicate)
        {
            string getNumber = "<input type=\"number\" value=\"" + "" + "\" placeholder=\"0.00\" step=\"0.01\" min=\"0\" value=\"" + "" + "\" id=\"" + Operation + TabShortName + "numPopup" + i.ToString() + "\" name=\"" + Operation + TabShortName + "numPopup" + i.ToString() + "\"" + required + " " + ValDuplicate + ">";
            _fieldList = _fieldList + TabShortName + "numPopup" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getNumber;
        }
        public string getCheckbox(int Columns_Code, int i, string Operation, string multiple, int Ext_Grp_Code, string TabShortName, string SelectedValues, string required, string ValDuplicate)
        {
            string strChecked = "";
            string User_Value = "";
            if (User_Value == "" || User_Value.ToUpper() == "NO")
            {
                strChecked = "";
            }
            else
                strChecked = " checked ";

            if (User_Value == "") User_Value = "YES";

            string getCheckbox = "<input type=\"checkbox\" value=\"" + User_Value + "\" id=\"" + Operation + TabShortName + "chkPopup" + i.ToString() + "\" name=\"" + Operation + TabShortName + "chkPopup" + i.ToString() + "\" style=\"margin-left: 4px;\"" + strChecked + " " + required + " " + ValDuplicate + ">";
            _fieldList = _fieldList + TabShortName + "chkPopup" + i.ToString() + "~" + ConfigCode.ToString() + ",";
            return getCheckbox;
        }

        public string PopupSaveInSession(string Value_list, string Short_Name, string Operation, int Row_No, string rwIndex, int Title_Code = 0)
        {
            if (Operation == "D" && Value_list == "")
            {
                foreach (USP_Bind_Extend_Column_Grid_Result objAddInValueList in gvExtended.Where(w => w.Row_No == Row_No))
                {
                    Extended_Columns ExtendedColumns = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == objAddInValueList.Columns_Code).FirstOrDefault();

                    if (ExtendedColumns.Control_Type == "DDL")
                    {
                        if (ExtendedColumns.Is_Multiple_Select.Trim().ToUpper() == "Y")
                        {
                            Value_list = Value_list + objAddInValueList.Columns_Value_Code1.Replace(',', '-') + "ï¿" + objAddInValueList.Columns_Code + "¿ï";
                        }
                        else
                        {
                            Value_list = Value_list + objAddInValueList.Columns_Value_Code + "ï¿" + objAddInValueList.Columns_Code + "¿ï";
                        }
                    }
                    else if (ExtendedColumns.Control_Type == "TXT" || ExtendedColumns.Control_Type == "INT" || ExtendedColumns.Control_Type == "DBL" || ExtendedColumns.Control_Type == "DATE" || ExtendedColumns.Control_Type == "CHK")
                    {
                        Value_list = Value_list + objAddInValueList.Name + "ï¿" + objAddInValueList.Columns_Code + "¿ï";
                    }
                }
            }
            else
            {
                string isDuplicate = ValidateDuplicate(Value_list, Short_Name, Operation, Row_No, rwIndex, Title_Code);
                if (isDuplicate == "Y")
                {
                    return "Duplicate";
                }
            }

            int TabCode = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == GlobalParams.ModuleCodeForTitle && x.Add_Edit_Type == "grid" && x.Short_Name == Short_Name).Select(b => b.Extended_Group_Code).FirstOrDefault();

            int rowNum = 0;
            var MapExtDetail = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Row_No != null).Where(x => x.Record_Code == Title_Code).ToList();

            if (lstAddedExtendedColumns.Count(b => b.Record_Code == Title_Code) != 0 && Operation == "A")
            {
                rowNum = (int)lstAddedExtendedColumns.Where(b => b.Record_Code == Title_Code).Max(a => a.Row_No).Value;
            }
            else if (MapExtDetail.Count > 0 && Operation == "A")
            {
                rowNum = (int)MapExtDetail.Where(b => b.Record_Code == Title_Code).Max(a => a.Row_No).Value;
            }
            else
            {
                rowNum = Row_No;
            }

            Value_list = Value_list.Substring(0, Value_list.Length - 2);
            string[] columnValueList = Value_list.Split(new string[] { "¿ï" }, StringSplitOptions.None);

            string Output = "";
            if (rowNum == 0)
            {
                Output = "<tr id=\"" + Short_Name + (1).ToString() + "\"data-configitem =\"" + TabCode + "\"> ";
            }
            else
            {
                Output = "<tr id=\"" + Short_Name + (rowNum).ToString() + "\"data-configitem =\"" + TabCode + "\"> ";
            }
            foreach (string str in columnValueList)
            {
                string hdnExtendedColumnsCode = "";
                string hdnColumnValueCode = "0";
                USP_Bind_Extend_Column_Grid_Result obj = new USP_Bind_Extend_Column_Grid_Result();
                Map_Extended_Columns objMapExtCol = new Map_Extended_Columns();
                string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
                int config_Code = Convert.ToInt32(vals[1]);
                string[] arrColumnsValueCode = null;
                string hdnExtendedColumnValue = "0";
                string ControlType = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == config_Code).Select(b => b.Control_Type).FirstOrDefault();
                var ExtendedColumns = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == config_Code).FirstOrDefault();
                //if (Operation == "E")
                //    obj = lstDetailObj.Where(a => a.Supplementary_Config_Code == config_Code && a.Supplementary_Tab_Code == TabCode && a.Row_Num == rowNum).FirstOrDefault();
                int RoleCode = 0;
                if (ControlType == "DDL")
                {
                    if (vals[0] != "")
                    {
                        string t = "";
                        int[] dtextval = Array.ConvertAll(vals[0].Split('-'), x => int.Parse(x));
                        var ExtendedColumn = ExtendedColumns;
                        if (ExtendedColumn.Is_Ref == "Y" && ExtendedColumn.Is_Defined_Values == "N" && ExtendedColumn.Ref_Table == "TALENT")
                        {
                            if (ExtendedColumn.Additional_Condition != "" && ExtendedColumn.Additional_Condition != null)
                                RoleCode = Convert.ToInt32(ExtendedColumn.Additional_Condition);
                            t = string.Join(",", new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Role.Any(TR => TR.Role_Code == RoleCode) && dtextval.Contains(x.Talent_Code)).Where(y => y.Is_Active == "Y").Select(b => b.Talent_Name).ToList());
                        }
                        else
                        {
                            t = string.Join(",", new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => dtextval.Contains(x.Columns_Value_Code)).Select(b => b.Columns_Value).ToList());
                        }

                        Output = Output + "<td data-configitem =\"" + TabCode + "\">" + t + "</td>";
                        obj.Name = t;
                    }
                    else
                    {
                        Output = Output + "<td>&nbsp;</td>";
                    }
                    //obj.Columns_Value_Code = vals[0].Replace('-', ',');
                    //obj.Columns_Value_Code = Convert.ToInt32(vals[0]);
                    arrColumnsValueCode = vals[0].Replace('-', ',').Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (ExtendedColumns.Is_Multiple_Select.Trim().ToUpper() == "Y")
                    {
                        foreach (string strColumnCode in arrColumnsValueCode)
                        {
                            Map_Extended_Columns_Details objMapExtDet = new Map_Extended_Columns_Details();
                            objMapExtDet.Columns_Value_Code = Convert.ToInt32(strColumnCode);
                            objMapExtCol.Map_Extended_Columns_Details.Add(objMapExtDet);
                        }
                        obj.Columns_Value_Code1 = vals[0].Replace('-', ',');
                        hdnColumnValueCode = vals[0].Replace('-', ',');
                    }
                    else
                    {
                        foreach (string strColumnCode in arrColumnsValueCode)
                        {
                            objMapExtCol.Columns_Value_Code = Convert.ToInt32(strColumnCode);
                            obj.Columns_Value_Code = Convert.ToInt32(strColumnCode);
                            hdnColumnValueCode = vals[0].Replace('-', ',');
                            hdnExtendedColumnValue = vals[0].Replace('-', ',');
                        }
                    }

                }
                if (ControlType == "TXT" || ControlType == "INT" || ControlType == "DBL" || ControlType == "DATE" || ControlType == "CHK")
                {
                    Output = Output + "<td>" + vals[0] + "</td>";
                    obj.Name = vals[0];
                    objMapExtCol.Column_Value = vals[0];
                    arrColumnsValueCode = vals[0].Replace('-', ',').Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    hdnExtendedColumnValue = vals[0].Replace('-', ',');
                }

                if (Operation == "A")
                {
                    obj.Columns_Code = Convert.ToInt32(vals[1]);
                    //if (arrColumnsValueCode.Split(',').Count() <= 1)
                    //    obj.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                    obj.Is_Ref = ExtendedColumns.Is_Ref;
                    obj.Is_Defined_Values = ExtendedColumns.Is_Defined_Values;
                    obj.Is_Multiple_Select = ExtendedColumns.Is_Multiple_Select;
                    obj.Ref_Table = ExtendedColumns.Ref_Table;
                    obj.Ref_Display_Field = ExtendedColumns.Ref_Display_Field;
                    obj.Ref_Value_Field = ExtendedColumns.Ref_Value_Field;
                    obj.Columns_Name = ExtendedColumns.Columns_Name;
                    obj.Row_No = rowNum + 1;
                    //obj.Name = hdnName;

                    gvExtended.Add(obj);

                    objMapExtCol.Row_No = rowNum + 1;
                    objMapExtCol.Columns_Code = Convert.ToInt32(vals[1]);
                    objMapExtCol.Table_Name = "TITLE";
                    objMapExtCol.Is_Multiple_Select = ExtendedColumns.Is_Multiple_Select;
                    objMapExtCol.Record_Code = Title_Code;
                    objMapExtCol.EntityState = State.Added;
                    lstAddedExtendedColumns.Add(objMapExtCol);
                }
                else if (Operation == "E" || Operation == "D")
                {
                    int OldColumnCode = 0;
                    hdnExtendedColumnsCode = Convert.ToString(config_Code);
                    string hdnRefTable = "";
                    if (ExtendedColumns.Ref_Table != null)
                    {
                        hdnRefTable = ExtendedColumns.Ref_Table;
                    }
                    string hdnMEColumnCode = "0";
                    int ColumnCode = Convert.ToInt32(config_Code);
                    //int RowNum = Convert.ToInt32(hdnRowNum);
                    //obj = gvExtended[RowNum - 1];
                    var chkObj = gvExtended.Where(x => x.Columns_Code == config_Code && x.Row_No == Row_No).FirstOrDefault();

                    if (chkObj == null && config_Code > 1)
                    {
                        chkObj = obj;
                        chkObj.Columns_Code = Convert.ToInt32(config_Code);
                        chkObj.Is_Ref = ExtendedColumns.Is_Ref;
                        chkObj.Is_Defined_Values = ExtendedColumns.Is_Defined_Values;
                        chkObj.Is_Multiple_Select = ExtendedColumns.Is_Multiple_Select;
                        chkObj.Ref_Table = ExtendedColumns.Ref_Table;
                        chkObj.Ref_Display_Field = ExtendedColumns.Ref_Display_Field;
                        chkObj.Ref_Value_Field = ExtendedColumns.Ref_Value_Field;
                        chkObj.Columns_Name = ExtendedColumns.Columns_Name;
                        chkObj.Row_No = rowNum;
                        chkObj.Name = hdnExtendedColumnValue;
                        chkObj.Column_Value = hdnExtendedColumnValue;
                        gvExtended.Add(chkObj);
                        var ChklstAdd = lstAddedExtendedColumns.Where(x => x.Columns_Code == config_Code && x.Row_No == Row_No).FirstOrDefault();
                        if (ChklstAdd == null)
                        {
                            objMapExtCol.Row_No = Row_No;
                            objMapExtCol.Columns_Code = Convert.ToInt32(config_Code);
                            objMapExtCol.Table_Name = "TITLE";
                            objMapExtCol.Is_Multiple_Select = ExtendedColumns.Is_Multiple_Select;
                            objMapExtCol.Record_Code = Title_Code;
                            objMapExtCol.EntityState = State.Added;
                            lstAddedExtendedColumns.Add(objMapExtCol);
                        }
                    }
                    else
                    {
                        obj = gvExtended.Where(x => x.Columns_Code == config_Code && x.Row_No == Row_No).FirstOrDefault();

                        OldColumnCode = obj.Columns_Code;

                        if (hdnExtendedColumnsCode != "")
                            obj.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                        if (hdnColumnValueCode != "")
                        {
                            if (hdnColumnValueCode.Split(',').Count() <= 1)
                                obj.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                        }
                        obj.Is_Ref = ExtendedColumns.Is_Ref;
                        obj.Is_Defined_Values = ExtendedColumns.Is_Defined_Values;
                        obj.Is_Multiple_Select = ExtendedColumns.Is_Multiple_Select;
                        obj.Ref_Table = ExtendedColumns.Ref_Table;
                        obj.Ref_Display_Field = ExtendedColumns.Ref_Display_Field;
                        obj.Ref_Value_Field = ExtendedColumns.Ref_Value_Field;
                        obj.Columns_Name = ExtendedColumns.Columns_Name;
                        obj.Name = hdnExtendedColumnValue;
                        obj.Column_Value = hdnExtendedColumnValue;

                    }

                    int MapExtendedColumnCode = 0;
                    hdnMEColumnCode = Convert.ToString(obj.Map_Extended_Columns_Code);

                    if (hdnMEColumnCode != "")
                        MapExtendedColumnCode = Convert.ToInt32(hdnMEColumnCode);

                    Map_Extended_Columns objMEc;
                    try
                    {
                        objMEc = lstDBExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.Row_No == Row_No && y.EntityState != State.Added).FirstOrDefault();



                        if (objMEc != null)
                        {

                            if (ValidateTalent(hdnColumnValueCode.ToString().Trim(' ').Trim(','), ColumnCode, "S") != "N")
                            {
                                objMEc.EntityState = State.Modified;
                                objMEc.Columns_Code = ColumnCode;
                                if (hdnColumnValueCode.Split(',').Count() <= 0)
                                    objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);

                                var FirstList = objMEc.Map_Extended_Columns_Details.Select(y => y.Columns_Value_Code.ToString()).Distinct().ToList();
                                var SecondList = arrColumnsValueCode.Distinct().ToList();
                                var Diff = FirstList.Except(SecondList);

                                foreach (string str1 in Diff)
                                {
                                    if (str1 != "" && str1 != " ")
                                    {
                                        int ColumnValCode = Convert.ToInt32(str1);
                                        objMEc.Map_Extended_Columns_Details.Where(y => y.Columns_Value_Code == ColumnValCode).ToList().ForEach(x => x.EntityState = State.Deleted);
                                    }
                                }

                                foreach (string str1 in arrColumnsValueCode)
                                {
                                    if (str1 != "" && str1 != "0" && str1 != " ")
                                    {
                                        Map_Extended_Columns_Details objMECD;

                                        objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str1) && p.EntityState != State.Added).FirstOrDefault();
                                        if (objMECD != null)
                                        {
                                            if (Operation == "D")
                                                objMECD.EntityState = State.Deleted;
                                            else
                                                objMECD.EntityState = State.Modified;

                                            objMECD.Columns_Value_Code = Convert.ToInt32(str1);
                                        }
                                        else
                                        {
                                            objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str1) && p.EntityState == State.Added).FirstOrDefault();
                                            if (objMECD == null)
                                            {
                                                if ((hdnRefTable.Trim().ToUpper() == "TITLE" || hdnRefTable.Trim().ToUpper() == "") && ExtendedColumns.Is_Multiple_Select.Trim().ToUpper() == "N")
                                                {
                                                    if (ExtendedColumns.Control_Type.Trim().ToUpper() != "TXT")
                                                    {
                                                        objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
                                                        objMEc.Columns_Code = ColumnCode;
                                                        objMEc.Column_Value = "";
                                                    }
                                                    else
                                                    {
                                                        objMEc.Columns_Value_Code = null;
                                                        objMEc.Column_Value = hdnExtendedColumnValue;
                                                    }
                                                    objMEc.EntityState = State.Modified;
                                                    if (objMEc.Map_Extended_Columns_Details.Count > 0)
                                                    {
                                                        foreach (Map_Extended_Columns_Details objMECD_inner in objMEc.Map_Extended_Columns_Details)
                                                        {
                                                            objMECD_inner.EntityState = State.Deleted;
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    objMECD = new Map_Extended_Columns_Details();
                                                    objMECD.Columns_Value_Code = Convert.ToInt32(str1);

                                                    int MapExtCode;
                                                    if (objMEc.Map_Extended_Columns_Details.Count > 0)
                                                    {
                                                        //MapExtCode =(int) objMEc.Map_Extended_Columns_Details.Select(x => x.Map_Extended_Columns_Code).Distinct().SingleOrDefault();
                                                        if (hdnMEColumnCode != "")
                                                            objMECD.Map_Extended_Columns_Code = Convert.ToInt32(hdnMEColumnCode);
                                                    }
                                                    else
                                                    {
                                                        objMECD.Map_Extended_Columns_Code = null;
                                                    }
                                                    if (Operation == "D")
                                                    {
                                                        objMECD.EntityState = State.Deleted;
                                                    }
                                                    else
                                                        objMECD.EntityState = State.Added;
                                                    objMEc.Map_Extended_Columns_Details.Add(objMECD);
                                                }
                                            }
                                        }
                                    }
                                }
                                if (ExtendedColumns.Control_Type.Trim().ToUpper() == "TXT" || ExtendedColumns.Control_Type.Trim().ToUpper() == "DATE" || ExtendedColumns.Control_Type.Trim().ToUpper() == "INT" || ExtendedColumns.Control_Type.Trim().ToUpper() == "DT")
                                {
                                    objMEc.Columns_Value_Code = null;
                                    objMEc.Column_Value = hdnExtendedColumnValue;
                                    objMEc.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
                                }
                                if (Operation == "D")
                                {
                                    USP_Bind_Extend_Column_Grid_Result objDeleteUBECD = gvExtended.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
                                    //gvExtended.Remove(objDeleteUBECD);
                                    try
                                    {

                                        int code = Convert.ToInt32(objDeleteUBECD.Map_Extended_Columns_Code);
                                        if (code > 0)
                                        {
                                            lstDBExtendedColumns.ForEach(t => { if (t.Map_Extended_Columns_Code == code) t.EntityState = State.Deleted; });
                                        }
                                    }
                                    catch { }
                                }
                            }
                            else
                                Message = "Cannot delete talent as already referenced in deal";
                        }
                        else
                        {

                            //objMEc = lstDBExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState == State.Added).FirstOrDefault();
                            //if (objMEc == null)
                            //{
                            if (OldColumnCode != 0)
                                objMEc = lstAddedExtendedColumns.Where(y => y.Columns_Code == OldColumnCode).FirstOrDefault();
                            else
                                objMEc = lstAddedExtendedColumns.Where(y => y.Columns_Code == config_Code).FirstOrDefault();

                            objMEc.Columns_Code = ColumnCode;
                            if (hdnColumnValueCode.Split(',').Count() <= 0)
                                objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);


                            if (objMEc.Map_Extended_Columns_Details.Count > 0)
                            {
                                if (arrColumnsValueCode.Length < 1)
                                {
                                    foreach (Map_Extended_Columns_Details objMECD in objMEc.Map_Extended_Columns_Details)
                                    {
                                        objMECD.Columns_Value_Code = 0;
                                    }
                                }
                                else
                                {
                                    foreach (string str1 in arrColumnsValueCode)
                                    {
                                        int ColumnValueCode = Convert.ToInt32(str1);
                                        Map_Extended_Columns_Details objMECD = objMEc.Map_Extended_Columns_Details.Where(x => x.Columns_Value_Code == ColumnValueCode).FirstOrDefault();

                                        if (objMECD == null)
                                        {
                                            objMECD = new Map_Extended_Columns_Details();
                                            objMECD.Columns_Value_Code = Convert.ToInt32(str1);
                                            objMEc.Map_Extended_Columns_Details.Add(objMECD);
                                        }
                                    }
                                }
                            }
                            if (ControlType == "TXT" || ControlType == "INT" || ControlType == "DBL" || ControlType == "DATE" || ControlType == "CHK")
                            {
                                objMEc.Column_Value = hdnExtendedColumnValue;
                            }                                

                            if (Operation == "D")
                            {
                                lstAddedExtendedColumns.Remove(objMEc);
                                USP_Bind_Extend_Column_Grid_Result objUSPbecgr = gvExtended.Where(w => w.Row_No == Row_No && w.Columns_Code == config_Code).FirstOrDefault();
                                gvExtended.Remove(objUSPbecgr);
                            }
                        }
                        //}
                    }
                    catch
                    {
                        objMEc = lstAddedExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
                        if (objMEc != null)
                        {
                            if (Operation == "D")
                                objMEc.EntityState = State.Deleted;
                            else
                                objMEc.EntityState = State.Modified;
                        }
                    }
                }
            }
            Extended_Group objExtGrp = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == GlobalParams.ModuleCodeForTitle && x.Add_Edit_Type == "grid").FirstOrDefault();
            int ExtColCount = objExtGrp.Extended_Group_Config.Select(s => s.Extended_Columns).Count();
            int ColValCount = columnValueList.Count();
            if (ExtColCount > ColValCount)
            {
                for (int i = ColValCount; i < ExtColCount; i++)
                {
                    Output = Output + "<td></td>";
                }
            }
            if (Operation == "A")
            {
                Output = Output + "<td style=\"text-align: center;\"><a title = \"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"PopupEdit(this,'0','" + Convert.ToString(rowNum + 1) + "','" + Convert.ToString(rowNum + 1) + "','" + TabCode + "');\"></a><a title =\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"PopupDelete(this,'0','" + Convert.ToString(rowNum + 1) + "','" + Convert.ToString(rowNum + 1) + "','" + TabCode + "','" + Short_Name + "' );\"></a></td>";
            }
            else if (Operation == "E")
            {
                Output = Output + "<td style=\"text-align: center;\"><a title = \"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"PopupEdit(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "');\"></a><a title =\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"PopupDelete(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "','" + Short_Name + "');\"></a></td>";

            }
            Output = Output + "</tr>";

            //objSupplementary.Acq_Deal_Supplementary_detail = lstDetailObj;
            //objAcq_Deal_Supplementary = objSupplementary;
            return Output;
        }

        public string BindPopupGridResult(List<Extended_Columns> ListExtended_Columns_Data, string Short_Name, string Operation, int Title_Code = 0, int TabCode = 0)
        {
            string Output = "";

            var lstExtendedColumnDB = gvExtended.Where(w => ListExtended_Columns_Data.Any(a => w.Columns_Code == a.Columns_Code)).ToList();
            var lstColumnRowNo = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Row_No != null).Where(x => x.Record_Code == Title_Code).Distinct().ToList();
            var lstTabwiseData = lstColumnRowNo.Where(w => lstExtendedColumnDB.Any(a => w.Columns_Code == a.Columns_Code && w.Map_Extended_Columns_Code == a.Map_Extended_Columns_Code)).OrderBy(x => x.Row_No).ToList();
            var lstRowDetail = lstTabwiseData.Select(x => x.Row_No).Distinct().ToList();

            int? rowNum = 0;
            int Count = 0;

            foreach (int? RowDetail in lstRowDetail)
            {
                rowNum = RowDetail;
                if (rowNum > 0)
                {
                    Output = Output + "<tr id=\"" + Short_Name + (rowNum).ToString() + "\"data-configitem =\"" + TabCode + "\"> ";
                }
                foreach (var i in ListExtended_Columns_Data)
                {
                    var ExtendedColumn = lstTabwiseData.Where(x => x.Columns_Code == i.Columns_Code && x.Row_No == RowDetail).FirstOrDefault();
                    USP_Bind_Extend_Column_Grid_Result ExtendedColumnDB = null;
                    if (ExtendedColumn != null)
                    {
                        ExtendedColumnDB = lstExtendedColumnDB.Where(x => x.Columns_Code == i.Columns_Code && x.Map_Extended_Columns_Code == ExtendedColumn.Map_Extended_Columns_Code).FirstOrDefault();
                    }

                    //if (rowNum > 0 && Count == 0)
                    //{
                    //    Output = "<tr id=\"" + Short_Name + (rowNum).ToString() + "\"data-configitem =\"" + TabCode + "\"> ";
                    //}

                    if (ExtendedColumnDB != null && (ExtendedColumnDB.Control_Type == "DDL"))
                    {
                        Output = Output + "<td data-configitem =\"" + TabCode + "\">" + ExtendedColumnDB.Name + "</td>";
                    }
                    else if (ExtendedColumnDB != null && (ExtendedColumnDB.Control_Type == "TXT" || ExtendedColumnDB.Control_Type == "INT" || ExtendedColumnDB.Control_Type == "DBL" || ExtendedColumnDB.Control_Type == "DATE" || ExtendedColumnDB.Control_Type == "CHK"))
                    {
                        Output = Output + "<td>" + ExtendedColumnDB.Name + "</td>";
                    }
                    else
                    {
                        Output = Output + "<td></td>";
                    }

                    Count++;
                }

                if (Operation != "VIEW")
                {
                    Output = Output + "<td style=\"text-align: center;\"><a title = \"Edit\" class=\"glyphicon glyphicon-pencil\" onclick=\"PopupEdit(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "');\"></a><a title =\"Delete\" class=\"glyphicon glyphicon-trash\" onclick=\"PopupDelete(this,'0','" + Convert.ToString(rowNum) + "','" + Convert.ToString(rowNum) + "','" + TabCode + "','" + Short_Name + "');\"></a></td>";
                }

                Output = Output + "</tr>";
            }

            return Output;
        }

        public JsonResult GridRowDelete(int TitleCode = 0, int rowno = 0, int TabCode = 0)
        {
            Map_Extended_Columns objMEc;
            var lstEditRecord = lstAddedExtendedColumns;
            var lstEditRecordDB = gvExtended;

            if (lstAddedExtendedColumns.Count != 0 && lstAddedExtendedColumns.Count(x => x.Record_Code == TitleCode && x.Row_No == rowno) != 0)
            {
                lstEditRecord = lstAddedExtendedColumns.Where(x => x.Record_Code == TitleCode && x.Row_No == rowno).ToList();
            }
            else if (gvExtended.Count != 0)
            {
                var lstColumnRowNo = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Row_No != null).Where(x => x.Record_Code == TitleCode && x.Row_No == rowno).Distinct().ToList();
                lstEditRecordDB = gvExtended.Where(w => lstColumnRowNo.Any(a => w.Map_Extended_Columns_Code == a.Map_Extended_Columns_Code)).ToList();
            }

            //if (lstEditRecord.Count > 0)
            //{
            //    foreach(var i in lstEditRecord)
            //    {
            //        objMEc = lstAddedExtendedColumns.Where(y => y.Columns_Code == i.Columns_Code).FirstOrDefault();
            //        objMEc.Columns_Code = i.Columns_Code;
            //        if (objMEc.Map_Extended_Columns_Details.Count > 0)
            //        {
            //            if (arrColumnsValueCode.Length < 1)
            //            {
            //                foreach (Map_Extended_Columns_Details objMECD in objMEc.Map_Extended_Columns_Details)
            //                {
            //                    objMECD.Columns_Value_Code = 0;
            //                }
            //            }
            //            else
            //            {
            //                foreach (string str in arrColumnsValueCode)
            //                {
            //                    int ColumnValueCode = Convert.ToInt32(str);
            //                    Map_Extended_Columns_Details objMECD = objMEc.Map_Extended_Columns_Details.Where(x => x.Columns_Value_Code == ColumnValueCode).FirstOrDefault();

            //                    if (objMECD == null)
            //                    {
            //                        objMECD = new Map_Extended_Columns_Details();
            //                        objMECD.Columns_Value_Code = Convert.ToInt32(str);
            //                        objMEc.Map_Extended_Columns_Details.Add(objMECD);
            //                    }
            //                }
            //            }
            //        }
            //    }                
            //}



            //objMEc.Columns_Code = ColumnCode;
            //if (hdnColumnValueCode.Split(',').Count() <= 0)
            //    objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);




            //if (hdnType == "D")
            //{
            //    lstAddedExtendedColumns.Remove(objMEc);
            //}
            ///////////////////////////////////////////////////////////////////////
            //int OldColumnCode = 0;

            //   int RowNum = Convert.ToInt32(hdnRowNum);
            //   obj = gvExtended[RowNum - 1];

            //   OldColumnCode = obj.Columns_Code;

            //   if (hdnExtendedColumnsCode != "")
            //       obj.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
            //   if (hdnColumnValueCode != "")
            //   {
            //       if (hdnColumnValueCode.Split(',').Count() <= 1)
            //           obj.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
            //   }
            //   obj.Is_Ref = hdnIsRef;
            //   obj.Is_Defined_Values = hdnIsDefined_Values;
            //   obj.Is_Multiple_Select = hdnIsMultipleSelect;
            //   obj.Ref_Table = hdnRefTable;
            //   obj.Ref_Display_Field = hdnRefDisplayField;
            //   obj.Ref_Value_Field = hdnRefValueField;
            //   obj.Columns_Name = hdnExtendedColumnName;
            //   obj.Name = hdnName;

            //   //if(hdnType == "D")
            //   //{
            //   //    gvExtended.Remove(obj);
            //   //}


            //   int MapExtendedColumnCode = 0;

            //   if (hdnMEColumnCode != "")
            //       MapExtendedColumnCode = Convert.ToInt32(hdnMEColumnCode);

            //   Map_Extended_Columns objMEc;
            //   try
            //   {
            //       //if (hdnMEColumnCode != "")
            //       objMEc = lstDBExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState != State.Added).FirstOrDefault();



            //       if (objMEc != null)
            //       {

            //           if (ValidateTalent(hdnColumnValueCode.ToString().Trim(' ').Trim(','), ColumnCode, "S") != "N")
            //           {
            //               objMEc.EntityState = State.Modified;
            //               objMEc.Columns_Code = ColumnCode;
            //               if (hdnColumnValueCode.Split(',').Count() <= 0)
            //                   objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);

            //               var FirstList = objMEc.Map_Extended_Columns_Details.Select(y => y.Columns_Value_Code.ToString()).Distinct().ToList();
            //               var SecondList = arrColumnsValueCode.Distinct().ToList();
            //               var Diff = FirstList.Except(SecondList);




            //               foreach (string str in Diff)
            //               {
            //                   if (str != "" && str != " ")
            //                   {
            //                       int ColumnValCode = Convert.ToInt32(str);
            //                       objMEc.Map_Extended_Columns_Details.Where(y => y.Columns_Value_Code == ColumnValCode).ToList().ForEach(x => x.EntityState = State.Deleted);
            //                   }
            //               }

            //               foreach (string str in arrColumnsValueCode)
            //               {
            //                   if (str != "" && str != "0" && str != " ")
            //                   {
            //                       Map_Extended_Columns_Details objMECD;

            //                       objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str) && p.EntityState != State.Added).FirstOrDefault();
            //                       if (objMECD != null)
            //                       {
            //                           if (hdnType == "D")
            //                               objMECD.EntityState = State.Deleted;
            //                           else
            //                               objMECD.EntityState = State.Modified;

            //                           objMECD.Columns_Value_Code = Convert.ToInt32(str);
            //                       }
            //                       else
            //                       {
            //                           objMECD = objMEc.Map_Extended_Columns_Details.Where(p => p.Columns_Value_Code == Convert.ToInt32(str) && p.EntityState == State.Added).FirstOrDefault();
            //                           if (objMECD == null)
            //                           {
            //                               if ((hdnRefTable.Trim().ToUpper() == "TITLE" || hdnRefTable.Trim().ToUpper() == "") && hdnIsMultipleSelect.Trim().ToUpper() == "N")
            //                               {
            //                                   if (hdnControlType.Trim().ToUpper() != "TXT")
            //                                   {
            //                                       objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);
            //                                       objMEc.Columns_Code = ColumnCode;
            //                                       objMEc.Column_Value = "";
            //                                   }
            //                                   else
            //                                   {
            //                                       objMEc.Columns_Value_Code = null;
            //                                       objMEc.Column_Value = hdnExtendedColumnValue;
            //                                   }
            //                                   objMEc.EntityState = State.Modified;
            //                                   if (objMEc.Map_Extended_Columns_Details.Count > 0)
            //                                   {
            //                                       foreach (Map_Extended_Columns_Details objMECD_inner in objMEc.Map_Extended_Columns_Details)
            //                                       {
            //                                           objMECD_inner.EntityState = State.Deleted;
            //                                       }
            //                                   }
            //                               }
            //                               else
            //                               {
            //                                   objMECD = new Map_Extended_Columns_Details();
            //                                   objMECD.Columns_Value_Code = Convert.ToInt32(str);

            //                                   int MapExtCode;
            //                                   if (objMEc.Map_Extended_Columns_Details.Count > 0)
            //                                   {
            //                                       //MapExtCode =(int) objMEc.Map_Extended_Columns_Details.Select(x => x.Map_Extended_Columns_Code).Distinct().SingleOrDefault();
            //                                       if (hdnMEColumnCode != "")
            //                                           objMECD.Map_Extended_Columns_Code = Convert.ToInt32(hdnMEColumnCode);
            //                                   }
            //                                   else
            //                                   {
            //                                       objMECD.Map_Extended_Columns_Code = null;
            //                                   }
            //                                   if (hdnType == "D")
            //                                   {
            //                                       objMECD.EntityState = State.Deleted;
            //                                   }
            //                                   else
            //                                       objMECD.EntityState = State.Added;
            //                                   objMEc.Map_Extended_Columns_Details.Add(objMECD);
            //                               }
            //                           }
            //                       }
            //                   }
            //               }
            //               if (hdnControlType.Trim().ToUpper() == "TXT")
            //               {
            //                   objMEc.Columns_Value_Code = null;
            //                   objMEc.Column_Value = hdnExtendedColumnValue;
            //                   objMEc.Columns_Code = Convert.ToInt32(hdnExtendedColumnsCode);
            //               }
            //               if (hdnType == "D")
            //               {
            //                   USP_Bind_Extend_Column_Grid_Result objDeleteUBECD = gvExtended.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
            //                   //gvExtended.Remove(objDeleteUBECD);
            //                   try
            //                   {

            //                       int code = Convert.ToInt32(objDeleteUBECD.Map_Extended_Columns_Code);
            //                       if (code > 0)
            //                       {
            //                           lstDBExtendedColumns.ForEach(t => { if (t.Map_Extended_Columns_Code == code) t.EntityState = State.Deleted; });
            //                       }
            //                   }
            //                   catch { }
            //               }
            //           }
            //           else
            //               Message = "Cannot delete talent as already referenced in deal";
            //       }
            //       else
            //       {

            //           //objMEc = lstDBExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode && y.EntityState == State.Added).FirstOrDefault();
            //           //if (objMEc == null)
            //           //{
            //           objMEc = lstAddedExtendedColumns.Where(y => y.Columns_Code == OldColumnCode).FirstOrDefault();
            //           objMEc.Columns_Code = ColumnCode;
            //           if (hdnColumnValueCode.Split(',').Count() <= 0)
            //               objMEc.Columns_Value_Code = Convert.ToInt32(hdnColumnValueCode);


            //           if (objMEc.Map_Extended_Columns_Details.Count > 0)
            //           {
            //               if (arrColumnsValueCode.Length < 1)
            //               {
            //                   foreach (Map_Extended_Columns_Details objMECD in objMEc.Map_Extended_Columns_Details)
            //                   {
            //                       objMECD.Columns_Value_Code = 0;
            //                   }
            //               }
            //               else
            //               {
            //                   foreach (string str in arrColumnsValueCode)
            //                   {
            //                       int ColumnValueCode = Convert.ToInt32(str);
            //                       Map_Extended_Columns_Details objMECD = objMEc.Map_Extended_Columns_Details.Where(x => x.Columns_Value_Code == ColumnValueCode).FirstOrDefault();

            //                       if (objMECD == null)
            //                       {
            //                           objMECD = new Map_Extended_Columns_Details();
            //                           objMECD.Columns_Value_Code = Convert.ToInt32(str);
            //                           objMEc.Map_Extended_Columns_Details.Add(objMECD);
            //                       }
            //                   }
            //               }
            //           }

            //           if (hdnType == "D")
            //           {
            //               lstAddedExtendedColumns.Remove(objMEc);
            //           }
            //       }
            //       //}
            //   }
            //   catch
            //   {
            //       objMEc = lstAddedExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
            //       if (objMEc != null)
            //       {
            //           if (hdnType == "D")
            //               objMEc.EntityState = State.Deleted;
            //           else
            //               objMEc.EntityState = State.Modified;
            //       }
            //   }

            Dictionary<string, object> obj = new Dictionary<string, object>();

            obj.Add("ErrorCode", "100");
            obj.Add("ErrorMsg", "Deal Deleted successfully");

            return Json(obj);
        }

        public ActionResult AddEditEpisodeData(Title_Episode_Details objTED, string CommandName)
        {
            //Title_Episode_Details objTED_Edit = lstEpisodeDetails.Where(w => w.Title_Episode_Detail_Code == objTED.Title_Episode_Detail_Code).FirstOrDefault();

            List<Title_Episode_Details> listTitleEpisodeDetail = new List<Title_Episode_Details>();
            listTitleEpisodeDetail = lstEpisodeDetails.Where(w => w.Title_Code == objTED.Title_Code).ToList();
            string TDBind = "";
            foreach (Title_Episode_Details objTEDlst in listTitleEpisodeDetail.Where(w => w.EntityState != State.Deleted))
            {
                string status = "";
                if (objTEDlst.Status == "P")
                {
                    status = "Pending";
                }
                if (objTEDlst.Status == "C")
                {
                    status = "Complete";
                }
                if (objTEDlst.Title_Episode_Detail_Code == objTED.Title_Episode_Detail_Code && CommandName == "EDIT")
                {
                    TDBind = TDBind + "<tr id=\"trGrid_EpisodeNum\" data-configitem=\"1\"> <td> <input type=\"text\" id=\"txtEpisodeNumber\" value = \"" + objTEDlst.Episode_Nos + "\" />  <input type=\"hidden\" id=\"hdnTitleEpsDetailCode\" value=\"" + objTEDlst.Title_Episode_Detail_Code + "\" />  <input type=\"hidden\" id=\"hdnTitleCode\" value=\"" + objTEDlst.Title_Code + "\" />  </td> <td> <input type=\"text\" id=\"txtRemark\" style=\"width:100%\"  value = \"" + objTEDlst.Remarks + "\"  /> </td> <td> <input type=\"hidden\" id=\"EpsStatus\" value=\"" + objTEDlst.Status + "\" /> " + status + "</td> <td> <a class=\"glyphicon glyphicon-ok-circle\" title=\"Save\" onclick=\"PostEpisodeDetails()\"></a> <a class=\"glyphicon glyphicon-remove-circle\" title=\"Close\" onclick=\"EditEpisodeDetails('', '')\" > </a> </td> </tr>";
                }
                else
                {
                    if (objTEDlst.Status == "C")
                    {
                        TDBind = TDBind + "<tr><td><span id=\"spnEpisodeNumber\">" + objTEDlst.Episode_Nos + "</span></td><td><span id=\"spnEpisodeRemark\">" + objTEDlst.Remarks + "</span></td><td>" + status + "</td><td> <a class=\"glyphicon glyphicon-eye-open\" title=\"View Title Contents\" onclick=\"ViewTitleEpisodeDetailsTC('" + objTEDlst.Title_Episode_Detail_Code + "')\"></a> </td></tr>";
                    }
                    else
                    {
                        TDBind = TDBind + "<tr><td><span id=\"spnEpisodeNumber\">" + objTEDlst.Episode_Nos + "</span></td><td><span id=\"spnEpisodeRemark\">" + objTEDlst.Remarks + "</span></td><td>" + status + "</td><td><a class=\"glyphicon glyphicon-pencil\" title=\"Edit\" onclick=\"EditEpisodeDetails('" + objTEDlst.Title_Episode_Detail_Code + "', 'EDIT')\"></a> <a class=\"glyphicon glyphicon-trash\" title=\"Delete\" onclick=\"DeleteEpisodeDetails(" + objTEDlst.Title_Episode_Detail_Code + ")\"></a> </td></tr>";
                        //<a class=\"glyphicon glyphicon-arrow-up\" title=\"Proceed\" onclick=\"ProceedEpisodeDetails('" + objTEDlst.Title_Episode_Detail_Code + "', '" + objTEDlst.Episode_Nos + "', '" + objTEDlst.Remarks + "', '" + objTEDlst.Title_Code + "')\"></a>
                    }
                }
            }
            if (CommandName == "ADD")
            {
                TDBind = TDBind + "<tr id=\"trGrid_EpisodeNum\" data-configitem=\"1\"> <td> <input type=\"text\" id=\"txtEpisodeNumber\" />  <input type=\"hidden\" id=\"hdnTitleEpsDetailCode\" value=\"0\" />  <input type=\"hidden\" id=\"hdnTitleCode\" value=\"" + objTitle.Title_Code + "\" />  </td> <td> <input type=\"text\" id=\"txtRemark\" style=\"width:100%\"  value = \"\"  /> </td> <td> <input type=\"hidden\" id=\"EpsStatus\" value=\"\" /> </td> <td> <a class=\"glyphicon glyphicon-ok-circle\" title=\"Save\" onclick=\"PostEpisodeDetails()\"></a> <a class=\"glyphicon glyphicon-remove-circle\" title=\"Close\" onclick=\"EditEpisodeDetails('', '')\" > </a> </td> </tr>";
            }

            return Json(TDBind);
        }

        public ActionResult ViewEpisodeData(int TitleCode)
        {
            List<Title_Episode_Details> listTitleEpisodeDetail = new List<Title_Episode_Details>();
            listTitleEpisodeDetail = lstEpisodeDetails.Where(w => w.Title_Code == TitleCode).ToList();
            string TDBind = "";
            foreach (Title_Episode_Details objTED in listTitleEpisodeDetail)
            {
                string status = "";
                if (objTED.Status == "P")
                {
                    status = "Pending";
                }
                if (objTED.Status == "C")
                {
                    status = "Complete";
                }
                if (objTED.Status == "C")
                {
                    TDBind = TDBind + "<tr><td><span id=\"spnEpisodeNumber\">" + objTED.Episode_Nos + "</span></td><td><span id=\"spnEpisodeRemark\">" + objTED.Remarks + "</span></td><td>" + status + "</td><td> <a class=\"glyphicon glyphicon-eye-open\" title=\"View Title Contents\" onclick=\"ViewTitleEpisodeDetailsTC('" + objTED.Title_Episode_Detail_Code + "')\"></a> </td></tr>";
                }
                else
                {
                    TDBind = TDBind + "<tr><td><span id=\"spnEpisodeNumber\">" + objTED.Episode_Nos + "</span></td><td><span id=\"spnEpisodeRemark\">" + objTED.Remarks + "</span></td><td>" + status + "</td></tr>";
                }
            }
            return Json(TDBind);
        }

        public ActionResult SaveEpisodeData(Title_Episode_Details objTED)
        {
            if (objTED.Title_Episode_Detail_Code == 0)
            {
                if (lstEpisodeDetails.Count == 0)
                {
                    objTED.Title_Episode_Detail_Code = -1;
                    objTED.Status = "P";
                    objTED.EntityState = State.Added;
                    lstEpisodeDetails.Add(objTED);
                }
                else
                {
                    objTED.Title_Episode_Detail_Code = Convert.ToInt32(Session["tempTED_Code"]) - 1;
                    objTED.Status = "P";
                    objTED.EntityState = State.Added;
                    lstEpisodeDetails.Add(objTED);
                }
                Session["tempTED_Code"] = objTED.Title_Episode_Detail_Code;
                objTED.Inserted_By = objLoginUser.Users_Code;
                objTED.Inserted_On = DateTime.Now;
            }
            else
            {
                if (objTED.Title_Episode_Detail_Code > 0)
                {
                    Title_Episode_Details objTED_DB = lstEpisodeDetails.Where(w => w.Title_Episode_Detail_Code == objTED.Title_Episode_Detail_Code).FirstOrDefault();
                    objTED_DB.Episode_Nos = objTED.Episode_Nos;
                    objTED_DB.Remarks = objTED.Remarks;
                    objTED_DB.Status = objTED.Status;
                    objTED_DB.EntityState = State.Modified;
                }
                if (objTED.Title_Episode_Detail_Code < 0)
                {
                    Title_Episode_Details objTED_Sess = lstEpisodeDetails.Where(w => w.Title_Episode_Detail_Code == objTED.Title_Episode_Detail_Code).FirstOrDefault();
                    objTED_Sess.Episode_Nos = objTED.Episode_Nos;
                    objTED_Sess.Remarks = objTED.Remarks;
                    objTED_Sess.Status = objTED.Status;
                    objTED_Sess.EntityState = State.Added;
                    objTED.Inserted_By = objLoginUser.Users_Code;
                    objTED.Inserted_On = DateTime.Now;
                }
            }

            //string TDBind = "<tr><td><span id=\"spnEpisodeNumber\">" + objTED.Episode_Nos + "</span></td><td><span id=\"spnEpisodeRemark\">" + objTED.Remarks + "</span></td><td>" + objTED.Status + "</td><td><a class=\"glyphicon glyphicon-pencil\" title=\"Edit\" onclick=\"EditEpisodeDetails('" + objTED.Title_Episode_Detail_Code + "', 'EDIT')\"></a></td></tr>";

            var EpsSaveObj = new
            {
                status = "S",
                message = "Episode data saved successfully"
            };

            return Json(EpsSaveObj);
        }

        public ActionResult ProceedEpisodeDetail(Title_Episode_Details objTED)
        {
            //Call procedure
            //return Json("Episode details sent for auto data generation");
            return Json("");
        }

        public ActionResult DeleteEpisodeDetails(int TitleEpisodeDetailCode)
        {
            string status = "S";
            string message = "";

            Title_Episode_Details ObjDeleteEpsDetails = lstEpisodeDetails.Where(w => w.Title_Episode_Detail_Code == TitleEpisodeDetailCode).FirstOrDefault();
            if (ObjDeleteEpsDetails != null)
            {
                if (ObjDeleteEpsDetails.Title_Episode_Detail_Code < 0)
                {
                    lstEpisodeDetails.Remove(ObjDeleteEpsDetails);
                }
                else if (ObjDeleteEpsDetails.Title_Episode_Detail_Code > 0)
                {
                    ObjDeleteEpsDetails.EntityState = State.Deleted;
                }
            }
            else
            {
                status = "E";
                message = objMessageKey.FileNotFound;
            }

            var obj = new
            {
                status,
                message
            };

            return Json(obj);
        }

        public RightsU_Entities.Title DBSaveEpisodeDetails(RightsU_Entities.Title objTitle)
        {
            System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
            List<string> lstShowCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();
            int DealTypeIncluded = lstShowCode.Where(w => w == objTitle.Deal_Type_Code.ToString()).Count();

            if (DealTypeIncluded == 1)
            {
                foreach (Title_Episode_Details objTEDSess in lstEpisodeDetails)
                {
                    if (objTEDSess.Title_Episode_Detail_Code > 0)
                    {
                        Title_Episode_Details objTEDdbSave = new Title_Episode_Details();
                        if (objTEDSess.EntityState == State.Modified)
                        {
                            objTEDdbSave = objTitle.Title_Episode_Details.Where(w => w.Title_Episode_Detail_Code == objTEDSess.Title_Episode_Detail_Code).FirstOrDefault();
                            objTEDdbSave.Episode_Nos = objTEDSess.Episode_Nos;
                            objTEDdbSave.Remarks = objTEDSess.Remarks;
                            objTEDdbSave.Status = objTEDSess.Status;
                        }
                        if (objTEDSess.EntityState == State.Deleted)
                        {
                            objTEDdbSave = objTitle.Title_Episode_Details.Where(w => w.Title_Episode_Detail_Code == objTEDSess.Title_Episode_Detail_Code).FirstOrDefault();
                            objTEDdbSave.EntityState = objTEDSess.EntityState;
                        }
                    }

                    if (objTEDSess.Title_Episode_Detail_Code < 0 || objTEDSess.Title_Episode_Detail_Code == 0)
                    {
                        if (objTEDSess.EntityState == State.Added)
                        {
                            objTitle.Title_Episode_Details.Add(objTEDSess);
                        }
                    }
                }
            }
            return objTitle;
        }

        #region 

        public ActionResult ViewTitleEpisodeDetailsTC(int TitleEpisodeDetailCode, string CurrentTitleURL)
        {
            Title_Episode_Details_TC_Service objTEDTCservice = new Title_Episode_Details_TC_Service(objLoginEntity.ConnectionStringName);
            List<Title_Episode_Details_TC> lstEpisodeContent = new List<Title_Episode_Details_TC>();
            lstEpisodeContent = objTEDTCservice.SearchFor(s => true).Where(w => w.Title_Episode_Detail_Code == TitleEpisodeDetailCode).ToList();
            //RightsU_Entities.Title objTitle = new RightsU_Entities.Title();
            string TitleName = new Title_Episode_Details_Service(objLoginEntity.ConnectionStringName).GetById(TitleEpisodeDetailCode).Title.Title_Name;
            //return RedirectToAction("SearchProgram", "Title_Content", new { searchText = "Wandering Minds", episodeFrom = 0, episodeTo = 0 });
            TempData["IsSearchFromTitle"] = "Y";
            Session["SearchTitleInTitleContent"] = TitleName;
            Session["CurrentTitleURL"] = CurrentTitleURL;
            return Json(TitleName);
        }

        #endregion

        public string ValidateDuplicate(string Value_list, string Short_Name, string Operation, int Row_No, string rwIndex, int Title_Code = 0)
        {
            string isDuplicate = "";
            Extended_Group objExtGrp = new Extended_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == GlobalParams.ModuleCodeForTitle && x.Add_Edit_Type == "grid" && x.Short_Name == Short_Name).FirstOrDefault();
            List<Extended_Group_Config> lstExtGrpCfgWithDuplicateVal = new List<Extended_Group_Config>();
            List<USP_Bind_Extend_Column_Grid_Result> lstOfRecordsToCheckDuplicateFor = new List<USP_Bind_Extend_Column_Grid_Result>();

            foreach (Extended_Group_Config objExtGrpCfg in objExtGrp.Extended_Group_Config)
            {
                if (objExtGrpCfg.Validations != null && objExtGrpCfg.Validations.Contains("dup"))
                {
                    lstExtGrpCfgWithDuplicateVal.Add(objExtGrpCfg);
                }
            }
            //Total fields with duplication validation in a group. Group wise duplication check.
            int totalFieldsToCheckDuplicate = lstExtGrpCfgWithDuplicateVal.Count();

            if (totalFieldsToCheckDuplicate == 0)
            {
                return isDuplicate;
            }

            var Value = "";
            Value_list = Value_list.Substring(0, Value_list.Length - 2);
            string[] columnValueList = Value_list.Split(new string[] { "¿ï" }, StringSplitOptions.None);
            foreach (string str in columnValueList)
            {
                string[] vals = str.Split(new string[] { "ï¿" }, StringSplitOptions.None);
                //string[] arrColumnsValueCode = null;
                Value = vals[0];
                int Columns_Code = Convert.ToInt32(vals[1]);
                Extended_Columns ExtendedColumns = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Columns_Code).FirstOrDefault();
                int checkDuplicateCount = lstExtGrpCfgWithDuplicateVal.Where(w => w.Columns_Code == Columns_Code).Count();

                if (checkDuplicateCount > 0)
                {
                    if (ExtendedColumns.Control_Type == "DDL")
                    {
                        if (vals[0] != null && vals[0] != "")
                        {
                            if (ExtendedColumns.Is_Multiple_Select.Trim().ToUpper() == "Y")
                            {
                                var MultiSelectColumnsValueCode = vals[0].Replace('-', ',');
                                string[] MultiSelectValuesArray = MultiSelectColumnsValueCode.Split(',');

                                foreach (string SelectedVal in MultiSelectValuesArray)
                                {
                                    int Duplicate = gvExtended.Where(w => w.Columns_Code == Columns_Code && w.Columns_Value_Code1 != null && w.Columns_Value_Code1.Contains(SelectedVal) && w.Row_No != Row_No).Count();
                                    if (Duplicate > 0)
                                    {
                                        isDuplicate = "Y";
                                        return isDuplicate;
                                    }
                                }
                            }
                            else
                            {
                                var SingleSelectColumnsValueCode = vals[0];
                                int Duplicate = gvExtended.Where(w => w.Columns_Value_Code == Convert.ToInt32(SingleSelectColumnsValueCode) && w.Row_No != Row_No).Count();
                                if (Duplicate > 0)
                                {
                                    isDuplicate = "Y";
                                    return isDuplicate;
                                }
                            }
                        }
                    }
                    if (ExtendedColumns.Control_Type == "TXT" || ExtendedColumns.Control_Type == "INT" || ExtendedColumns.Control_Type == "DBL" || ExtendedColumns.Control_Type == "DATE" || ExtendedColumns.Control_Type == "CHK")
                    {
                        //var SingleValueField = vals[0];
                        //int Duplicate = gvExtended.Where(w => w.Name == SingleValueField && w.Row_No != Row_No).Count();
                        //if (Duplicate > 0)
                        //{
                        //    isDuplicate = "Y";
                        //    return isDuplicate;
                        //}
                        USP_Bind_Extend_Column_Grid_Result objToCheckDuplicate = new USP_Bind_Extend_Column_Grid_Result();
                        objToCheckDuplicate.Column_Value = vals[0];
                        objToCheckDuplicate.Name = vals[0];
                        objToCheckDuplicate.Columns_Code = Convert.ToInt32(vals[1]);
                        lstOfRecordsToCheckDuplicateFor.Add(objToCheckDuplicate);
                    }
                }
            }
            //check duplicate for objects added in List with gvExtended
            var GroupedByRowNum = gvExtended.GroupBy(g => g.Row_No).ToList();
            foreach (var SingleGroup in GroupedByRowNum)
            {
                int IsDuplicateCount = SingleGroup.Where(w => lstOfRecordsToCheckDuplicateFor.Any(a => a.Columns_Code == w.Columns_Code && (a.Column_Value == w.Column_Value || a.Name == w.Name) && w.Row_No != Row_No)).Count();
                if (IsDuplicateCount >= totalFieldsToCheckDuplicate)
                {
                    isDuplicate = "Y";
                }
            }

            return isDuplicate;
        }

        public ActionResult ProgramShowList()
        {
            System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
            List<string> lstShowCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();

            return Json(lstShowCode, JsonRequestBehavior.AllowGet);
        }

        #endregion
    }
}
class ExtendedMethod
{
    public int Id { get; set; }
    public string Is_Add_OnScreen { get; set; }
}
