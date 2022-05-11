using System;
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

            objTitle.Title_Name = objTitleModel.Title_Name;
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

        public string BindNewRowDdl(int ColumnCode, int RowNum, string IsExists)
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

            var lstextCol = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(x => !ColumnNotInCode.Contains(x.Columns_Code) && x.Columns_Name != "Program Category").ToList();

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
            var lstextCol = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == Column_Code).Select(y => new { ColumnsValue = y.Columns_Value, Columns_Value_Code = y.Columns_Value_Code }).ToList();
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
            var lstextCol = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Role.Any(TR => TR.Role_Code == RoleCode)).Where(y => y.Is_Active == "Y").Select(i => new { Talent_Code = i.Talent_Code, Talent_Name = i.Talent_Name }).ToList();
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
                ExtendedColumnsCode = 0;
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

                gvExtended.Remove(obj);

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
                            if (hdnControlType.Trim().ToUpper() == "TXT")
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
                                    Map_Extended_Columns_Details objMECD = objMEc.Map_Extended_Columns_Details.Where(x => x.Columns_Value_Code == ColumnValueCode).FirstOrDefault();

                                    if (objMECD == null)
                                    {
                                        objMECD = new Map_Extended_Columns_Details();
                                        objMECD.Columns_Value_Code = Convert.ToInt32(str);
                                        objMEc.Map_Extended_Columns_Details.Add(objMECD);
                                    }
                                }
                            }
                        }

                        //if (hdnType == "D")
                        //{
                        //    lstAddedExtendedColumns.Remove(objMEc);
                        //}
                    }
                    //}
                }
                catch
                {
                    objMEc = lstAddedExtendedColumns.Where(y => y.Map_Extended_Columns_Code == MapExtendedColumnCode).FirstOrDefault();
                    //if (objMEc != null)
                    //{
                    //    if (hdnType == "D")
                    //        objMEc.EntityState = State.Deleted;
                    //    else
                    //        objMEc.EntityState = State.Modified;
                    //}
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
            if (tabName == "TA")
            {
                ViewBag.Direction = "LTR";
                ViewBag.IsFirstTime = "N";
                ViewBag.Is_AcqSyn_Type_Of_Film = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").FirstOrDefault().Parameter_Value;
                //return PartialView("~/Views/Title/Index.cshtml", objTitle);

                string Per_Logic =  new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Allow_Perpetual_Date_Logic_Title").FirstOrDefault().Parameter_Value;

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
    }
}
class ExtendedMethod
{
    public int Id { get; set; }
    public string Is_Add_OnScreen { get; set; }
}