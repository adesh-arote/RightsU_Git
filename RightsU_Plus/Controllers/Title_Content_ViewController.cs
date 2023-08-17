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
using System.Xml.Serialization;
using System.Data.SqlClient;
using System.Data;
using System.Data.OleDb;
using System.Xml;


namespace RightsU_Plus.Controllers
{
    public class Title_Content_ViewController : BaseController
    {
        #region --- Properties ---
        public List<USP_Title_Content_Version_PI> lstError
        {
            get
            {
                if (Session["lstError_Session"] == null)
                    Session["lstError_Session"] = new List<USP_Title_Content_Version_PI>();
                return (List<USP_Title_Content_Version_PI>)Session["lstError_Session"];
            }
            set { Session["lstError_Session"] = value; }
        }
        private USP_GetContentMetadata_Result objContentMetadata
        {
            get
            {
                if (Session["objContentMetadata"] == null)
                    Session["objContentMetadata"] = new USP_GetContentMetadata_Result();
                return (USP_GetContentMetadata_Result)Session["objContentMetadata"];
            }
            set { Session["objContentMetadata"] = value; }
        }
        private List<USP_GetContentsRightData_Result> lstContentRightsData
        {
            get
            {
                if (Session["lstContentRightsData"] == null)
                    Session["lstContentRightsData"] = new List<USP_GetContentsRightData_Result>();
                return (List<USP_GetContentsRightData_Result>)Session["lstContentRightsData"];
            }
            set { Session["lstContentRightsData"] = value; }
        }
        private List<USP_Get_Content_Cost_Result> lstContentCostData
        {
            get
            {
                if (Session["lstContentCostData"] == null)
                    Session["lstContentCostData"] = new List<USP_Get_Content_Cost_Result>();
                return (List<USP_Get_Content_Cost_Result>)Session["lstContentCostData"];
            }
            set { Session["lstContentCostData"] = value; }
        }
        private List<USP_GetContentsMusicData_Result> lstContentMusicData
        {
            get
            {
                if (Session["lstContentMusicData"] == null)
                    Session["lstContentMusicData"] = new List<USP_GetContentsMusicData_Result>();
                return (List<USP_GetContentsMusicData_Result>)Session["lstContentMusicData"];
            }
            set { Session["lstContentMusicData"] = value; }
        }
        private List<USP_GetContentsMusicData_Result> lstContentMusicData_Searched
        {
            get
            {
                if (Session["lstContentMusicData_Searched"] == null)
                    Session["lstContentMusicData_Searched"] = new List<USP_GetContentsMusicData_Result>();
                return (List<USP_GetContentsMusicData_Result>)Session["lstContentMusicData_Searched"];
            }
            set { Session["lstContentMusicData_Searched"] = value; }
        }
        private List<USP_GetContentsVersionData_Result> lstContentVersionData
        {
            get
            {
                if (Session["lstContentVersionData"] == null)
                    Session["lstContentVersionData"] = new List<USP_GetContentsVersionData_Result>();
                return (List<USP_GetContentsVersionData_Result>)Session["lstContentVersionData"];
            }
            set { Session["lstContentVersionData"] = value; }
        }
        private List<USP_GetContentsAiringData_Result> lstContentAiringData
        {
            get
            {
                if (Session["lstContentAiringData"] == null)
                    Session["lstContentAiringData"] = new List<USP_GetContentsAiringData_Result>();
                return (List<USP_GetContentsAiringData_Result>)Session["lstContentAiringData"];
            }
            set { Session["lstContentAiringData"] = value; }
        }
        private List<USP_GetContentsStatusHistoryData_Result> lstContentStatusHistoryData
        {
            get
            {
                if (Session["lstContentStatusHistoryData"] == null)
                    Session["lstContentStatusHistoryData"] = new List<USP_GetContentsStatusHistoryData_Result>();
                return (List<USP_GetContentsStatusHistoryData_Result>)Session["lstContentStatusHistoryData"];
            }
            set { Session["lstContentStatusHistoryData"] = value; }
        }
        private Title_Content_View_Search objSearch
        {
            get
            {
                if (Session["objSearch_TitleContentView"] == null)
                    Session["objSearch_TitleContentView"] = new Title_Content_View_Search();
                return (Title_Content_View_Search)Session["objSearch_TitleContentView"];
            }
            set { Session["objSearch_TitleContentView"] = value; }
        }
        private List<Title_Content_Version_Service> lstTCVS
        {
            get
            {
                if (Session["lstTCVS"] == null)
                    Session["lstTCVS"] = new List<Title_Content_Version_Service>();
                return (List<Title_Content_Version_Service>)Session["lstTCVS"];
            }
            set { Session["lstTCVS"] = value; }
        }
        private List<USP_GetRunDefinitonForContent_Result> lstContentRunDefData
        {
            get
            {
                if (Session["lstContentRunDefData"] == null)
                    Session["lstContentRunDefData"] = new List<USP_GetRunDefinitonForContent_Result>();
                return (List<USP_GetRunDefinitonForContent_Result>)Session["lstContentRunDefData"];
            }
            set { Session["lstContentRunDefData"] = value; }
        }
        private const string Command_Search = "SEARCH";
        private const string Command_ShowAll = "SHOW_ALL";
        #endregion

        #region --- Actions ---
        public ActionResult Index(long Title_Content_Code = 0)
        {
            ClearSession();
            objContentMetadata = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentMetadata(Title_Content_Code).FirstOrDefault();
            BindDDL();
            int? titleCode = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == objContentMetadata.Title_Content_Code).Select(x => x.Title_Code).FirstOrDefault();
            int? EpisodeNo = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == objContentMetadata.Title_Content_Code).Select(x => x.Episode_No).FirstOrDefault();
            int?[] acqdealcostCode = new Acq_Deal_Cost_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == titleCode && x.Episode_From <= EpisodeNo && x.Episode_To >= EpisodeNo).Select(x => x.Acq_Deal_Cost_Code).ToArray();
            string[] AcqDealCostCodes = new Acq_Deal_Cost_Costtype_Service(objLoginEntity.ConnectionStringName).SearchFor(x => acqdealcostCode.Contains(x.Acq_Deal_Cost_Code)).Select(x => x.Acq_Deal_Cost_Costtype_Code.ToString()).ToArray();
            int?[] AcqDealCostEpisodecodes = new Acq_Deal_Cost_Costtype_Episode_Service(objLoginEntity.ConnectionStringName).SearchFor(x => AcqDealCostCodes.Contains(x.Acq_Deal_Cost_Costtype_Code.ToString()) && x.Episode_From <= EpisodeNo && x.Episode_To >= EpisodeNo).Select(x => x.Acq_Deal_Cost_Costtype_Code).ToArray();
            int?[] costTypeCode = new Acq_Deal_Cost_Costtype_Service(objLoginEntity.ConnectionStringName).SearchFor(x => AcqDealCostEpisodecodes.Contains(x.Acq_Deal_Cost_Costtype_Code)).Select(x => x.Cost_Type_Code).ToArray();
            ViewBag.CostTypeList = new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => costTypeCode.Contains(x.Cost_Type_Code)).Select(a => new SelectListItem { Text = a.Cost_Type_Name, Value = a.Cost_Type_Code.ToString() }).ToList();
            ViewBag.ChannelList = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(p => true).Select(a => new SelectListItem { Text = a.Channel_Name, Value = a.Channel_Code.ToString() }).ToList();

            ViewBag.Command_Search = Command_Search;
            ViewBag.Command_ShowAll = Command_ShowAll;
            int?[] alternateConfigCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == titleCode).OrderBy(x => x.Alternate_Config.Display_Order).Select(x => x.Alternate_Config_Code).ToArray();
            //int[] alternateConfigCode = new Alternate_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(x => x.Display_Order).Select(x => x.Alternate_Config_Code).ToArray();
            int titleAlternateCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == titleCode).Select(x => x.Title_Alternate_Code).FirstOrDefault();
            if (titleAlternateCode != 0)
                ViewBag.PartialTabList = alternateConfigCode;
            else
            {
                ViewBag.PartialTabList = null;
            }
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForContent);
            ViewBag.TitleContentCode = Title_Content_Code;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View(objContentMetadata);
        }
        public ActionResult Cancel()
        {
            ClearSession();
            if (TempData["BackToListTitle"] != null)
            {
                TempData["IsSearchFromTitle"] = "Y";
            }
            return RedirectToAction("Index", "Title_Content", new { IsMenu = "N" });
        }
        private void ClearSession()
        {
            objSearch = null;
            objContentMetadata = null;
            lstContentRightsData = null;
            lstContentMusicData = null;
            lstContentMusicData_Searched = null;
            lstContentAiringData = null;
            lstContentStatusHistoryData = null;
        }
        public JsonResult BindDDL()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForContent);
            List<SelectListItem> lst = new Title_Content_Version_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == objContentMetadata.Title_Content_Code).Select(x => new SelectListItem { Text = x.Version.Version_Name, Value = x.Version_Code.ToString() }).Distinct().ToList();
            lst.Insert(0, new SelectListItem() { Text = "Please Select", Value = "" });
            ViewBag.Version = lst;
          
            lstContentRunDefData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetRunDefinitonForContent(objContentMetadata.Title_Content_Code, "", 0, "", "", "", "").ToList();
            List<SelectListItem> lstChannel = lstContentRunDefData.Select(x => new SelectListItem { Text = x.Channel_Name, Value = x.Channel_Code.ToString() }).ToList();
            lstChannel= lstChannel.GroupBy(g => g.Value).Select(s => s.FirstOrDefault()).ToList();
            lstChannel.Insert(0, new SelectListItem() { Text = "Please Select", Value = "0" });
            ViewBag.Channel = lstChannel;

            List<SelectListItem> lstRunDefType = new List<SelectListItem>();
            lstRunDefType.Add(new SelectListItem { Text = objMessageKey.None, Value = "N" });
            lstRunDefType.Add(new SelectListItem { Text = objMessageKey.Channel, Value = "C" });
            lstRunDefType.Add(new SelectListItem { Text = objMessageKey.Deal, Value = "D" });
            ViewBag.RunDefintionType = lstRunDefType;

            List<SelectListItem> lstDealType = new List<SelectListItem>();
            lstDealType.Add(new SelectListItem { Text = objMessageKey.Acquisition, Value = "A" });
            lstDealType.Add(new SelectListItem { Text = objMessageKey.Provisional, Value = "P" });
            lstDealType.Insert(0, new SelectListItem() { Text = "Please Select", Value = "" });
            ViewBag.DealType = lstDealType;

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("VersionList", ViewBag.Version);
            obj.Add("RunDefintionType", lstRunDefType);
            obj.Add("Channel", lstChannel);
            obj.Add("Deal", lstDealType);
            return Json(obj);
        }

        public PartialViewResult BindRightsListData(int pageNo, int recordPerPage, string command, bool tabChanged)
        {
            if (!objSearch.VisitedOn_Rights)
            {
                lstContentRightsData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsRightData(objContentMetadata.Title_Content_Code).ToList();
                objSearch.VisitedOn_Rights = true;
            }

            if (tabChanged)
            {
                pageNo = objSearch.PageNo_Rights;
                recordPerPage = objSearch.PageSize_Rights;
            }
            else
            {
                objSearch.PageNo_Rights = pageNo;
                objSearch.PageSize_Rights = recordPerPage;
            }

            int RecordCount = lstContentRightsData.Count;
            List<USP_GetContentsRightData_Result> lst = new List<USP_GetContentsRightData_Result>();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContentRightsData.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;
            ViewBag.RecordCount = RecordCount;
            return PartialView("~/Views/Title_Content_View/_Rights_Content.cshtml", lst);
        }
        public PartialViewResult BindTitleMetadata(int pageNo, int recordPerPage, string command, bool tabChanged)
        {
            int? Title_Code = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == objContentMetadata.Title_Content_Code).Select(s => s.Title_Code).FirstOrDefault();
            RightsU_Entities.Title objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(Title_Code));
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT,LA,C,G,P,DR,S,RL,O", 0, 0, "").ToList();
            var Country_codes = string.Join(",", (objTitle.Title_Country.Where(i => i.Title_Code == objTitle.Title_Code).Select(i => i.Country_Code).ToList()));
            if (Country_codes == "" || Country_codes == null)
            {
                int Original_Country_code = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Parameter_Name == "Title_CountryOfOrigin").Select(i => i.Parameter_Value).FirstOrDefault());
                Country_codes = Original_Country_code + "";
            }
            var lstCountry = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "C"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var lstProducer = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "P"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var producer_code = string.Join(",", (objTitle.Title_Talent.Where(i => i.Title_Code == objTitle.Title_Code && i.Role_Code == GlobalParams.Role_code_Producer).Select(i => i.Talent_Code).ToList()));

            //Director 
            var lstDirector = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DR"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var Director_code = string.Join(",", (objTitle.Title_Talent.Where(i => i.Title_Code == objTitle.Title_Code && i.Role_Code == GlobalParams.RoleCode_Director).Select(i => i.Talent_Code).ToList()));

            //StarCast
            var lstStarCast = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "S"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var StarCast_code = string.Join(",", (objTitle.Title_Talent.Where(i => i.Title_Code == objTitle.Title_Code && i.Role_Code == GlobalParams.RoleCode_StarCast).Select(i => i.Talent_Code).ToList()));

            //Program
            if (objTitle.Program_Code > 0)
                ViewBag.ProgramList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "O"), "Display_Value", "Display_Text", objTitle.Program_Code).OrderBy(x => x.Text).ToList();
            else
                ViewBag.ProgramList = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "O"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
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

            var Geners_code = string.Join(",", (objTitle.Title_Geners.Where(i => i.Title_Code == objTitle.Title_Code).Select(i => i.Genres_Code).ToList()));
            if (Geners_code != "")
            {
                var lstGenere = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "G"), "Display_Value", "Display_Text", Geners_code.Split(',')).ToList();
                var lstGenersNames = string.Join(", ", (lstGenere.Where(y => Geners_code.Split(',').Contains(y.Value.ToString())).Distinct().OrderBy(x => x.Text).Select(i => i.Text)));
                ViewBag.GenresList = lstGenersNames.ToString().Trim(',');
            }
            else
                ViewBag.GenresList = "";
           
            ViewBag.TitleContentCode = objContentMetadata.Title_Content_Code;
            return PartialView("~/Views/Title_Content_View/_Title_Metadata.cshtml", objTitle);
        }
        public PartialViewResult BindProgramList(int contentCodeForEdit, string CommandName)
        {
            List<RightsU_Entities.Title_Content> lstTitleContent = new List<Title_Content>();
            string rightCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForContent), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList().FirstOrDefault();
            if (string.IsNullOrEmpty(rightCodes))
                rightCodes = "";
            ViewBag.RightCode = rightCodes;
            int newPageNo = 0;
            ViewBag.ContentCodeForEdit = contentCodeForEdit;
            ViewBag.CommandName = CommandName;
            RightsU_Entities.Title_Content objTitleContent = new Title_Content_Service(objLoginEntity.ConnectionStringName).GetById(contentCodeForEdit);
            return PartialView("~/Views/Title_Content_View/_Title_Metadata_List.cshtml", objTitleContent);
        }
        public JsonResult SaveTitleContent(int titleContentCode, string EpisodeName, string duration, string synopsis, int EpisodeNum)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (titleContentCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;
            if (CheckDuplicateEpisodeNumber(titleContentCode, EpisodeNum))
            {
                status = "E";
                message = "Episode number " + EpisodeNum + " already exists for Title";
            }
            else
            {
                Title_Content_Service objService = new Title_Content_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Title_Content objTitleContent = null;

                if (titleContentCode > 0)
                {
                    objTitleContent = objService.GetById(titleContentCode);
                    objTitleContent.EntityState = State.Modified;
                }
                else
                {
                    objTitleContent = new RightsU_Entities.Title_Content();
                    objTitleContent.EntityState = State.Added;
                    objTitleContent.Inserted_On = DateTime.Now;
                    objTitleContent.Inserted_By = objLoginUser.Users_Code;
                }

                objTitleContent.Last_Updated_Time = DateTime.Now;
                objTitleContent.Last_Action_By = objLoginUser.Users_Code;
                objTitleContent.Episode_Title = EpisodeName;
                string IsEpisodeNoUpdateAllowed = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AllowEpisodeNoUpdate").FirstOrDefault().Parameter_Value;
                if (IsEpisodeNoUpdateAllowed == "Y")
                {
                    objTitleContent.Episode_No = EpisodeNum;
                }                
                if (duration != "")
                    objTitleContent.Duration = Convert.ToDecimal(duration);
                else
                    objTitleContent.Duration = null;
                objTitleContent.Synopsis = synopsis;
                dynamic resultSet;
                bool isValid = objService.Save(objTitleContent, out resultSet);

                if (isValid)
                {
                    objTitleContent = objService.GetById(titleContentCode);
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public PartialViewResult BindTitleAlternateData(int pageNo, int recordPerPage, string command, int configCode, bool tabChanged)
        {
            ViewBag.Direction = new Alternate_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Alternate_Config_Code == configCode).Select(s => s.Direction).FirstOrDefault();
            int? Title_Code = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == objContentMetadata.Title_Content_Code).Select(s => s.Title_Code).FirstOrDefault();
            int title_Alternate_Code = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == Title_Code && x.Alternate_Config_Code == configCode).Select(x => x.Title_Alternate_Code).FirstOrDefault();
            RightsU_Entities.Title_Alternate objTitleAlternate = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).GetById(title_Alternate_Code);
            List<USP_Get_Title_PreReq_Result> lstUSP_Get_Title_PreReq = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_PreReq("DT,LA,C,G,P,DR,S,RL,O", 0, 0, "").ToList();
            var lstProducer = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "P"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var producer_code = string.Join(",", (objTitleAlternate.Title_Alternate_Talent.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code && i.Role_Code == GlobalParams.Role_code_Producer).Select(i => i.Talent_Code).ToList()));

            //Director 
            var lstDirector = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "DR"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var Director_code = string.Join(",", (objTitleAlternate.Title_Alternate_Talent.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code && i.Role_Code == GlobalParams.RoleCode_Director).Select(i => i.Talent_Code).ToList()));

            //StarCast
            var lstStarCast = new SelectList(lstUSP_Get_Title_PreReq.Where(x => x.Data_For == "S"), "Display_Value", "Display_Text").OrderBy(x => x.Text).ToList();
            var StarCast_code = string.Join(",", (objTitleAlternate.Title_Alternate_Talent.Where(i => i.Title_Alternate_Code == objTitleAlternate.Title_Alternate_Code && i.Role_Code == GlobalParams.RoleCode_StarCast).Select(i => i.Talent_Code).ToList()));
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

            ViewBag.ConfigCode = configCode;
            ViewBag.titleContentCode = objContentMetadata.Title_Content_Code;
            ViewBag.TitleAlternateCode = objTitleAlternate.Title_Alternate_Code;
            return PartialView("~/Views/Title_Content_View/_Title_Alternate.cshtml", objTitleAlternate);
        }
        public PartialViewResult BindTitleAlternateList(int ConfigCode, int contentCodeForEdit,int titleAlternateContetCode, string CommandName, string firstTime)
        {
            string rightCodes = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForContent), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList().FirstOrDefault();
            int title_Code = 0;
            int TitleAlternateContentCode = 0;
            RightsU_Entities.Title_Alternate_Content objTitleAlternateContent = new RightsU_Entities.Title_Alternate_Content();
            RightsU_Entities.Title_Content objTitleContent = new RightsU_Entities.Title_Content();
            RightsU_Entities.Title objTitle = new RightsU_Entities.Title();
            if (string.IsNullOrEmpty(rightCodes))
                rightCodes = "";
            ViewBag.RightCode = rightCodes;
            int newPageNo = 0;
            if (firstTime == "Y")
            {
                objTitleContent = new Title_Content_Service(objLoginEntity.ConnectionStringName).GetById(contentCodeForEdit);
                title_Code = Convert.ToInt32(objTitleContent.Title_Code);
                 objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(title_Code);
                int titleAlternateCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objTitle.Title_Code && x.Alternate_Config_Code == ConfigCode).Select(x => x.Title_Alternate_Code).FirstOrDefault();
                string ContentName = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objTitle.Title_Code && x.Alternate_Config_Code == ConfigCode).Select(x => x.Title_Name).FirstOrDefault();
                string synopsis = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objTitle.Title_Code && x.Alternate_Config_Code == ConfigCode).Select(x => x.Synopsis).FirstOrDefault();
                ViewBag.ContentCodeForEdit = contentCodeForEdit;
                ViewBag.CommandName = CommandName;
                ViewBag.EpisodeNo = objTitleContent.Episode_No;
                ViewBag.Duration = objTitle.Duration_In_Min;
                ViewBag.ContentName = ContentName;
                ViewBag.Synopsis = synopsis;

                RightsU_Entities.Title_Alternate objTitleAlternate = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).GetById(titleAlternateCode);
                TitleAlternateContentCode = new Title_Alternate_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Alternate_Code == titleAlternateCode && x.Episode_No == objTitleContent.Episode_No).Select(x => x.Title_Alternate_Content_Code).FirstOrDefault();
                objTitleAlternateContent = new Title_Alternate_Content_Service(objLoginEntity.ConnectionStringName).GetById(TitleAlternateContentCode);

            }
            else
            {
                objTitleContent = new Title_Content_Service(objLoginEntity.ConnectionStringName).GetById(contentCodeForEdit);
                title_Code = Convert.ToInt32(objTitleContent.Title_Code);
                objTitle = new Title_Service(objLoginEntity.ConnectionStringName).GetById(title_Code);
                int titleAlternateCode = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Code == objTitle.Title_Code && x.Alternate_Config_Code == ConfigCode).Select(x => x.Title_Alternate_Code).FirstOrDefault();
                objTitleContent = new Title_Content_Service(objLoginEntity.ConnectionStringName).GetById(contentCodeForEdit);
                TitleAlternateContentCode = new Title_Alternate_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Alternate_Code == titleAlternateCode && x.Episode_No == objTitleContent.Episode_No).Select(x => x.Title_Alternate_Content_Code).FirstOrDefault();
                objTitleAlternateContent = new Title_Alternate_Content_Service(objLoginEntity.ConnectionStringName).GetById(TitleAlternateContentCode);
            }
            if(CommandName == "EDIT")
            {
                objTitleAlternateContent = new Title_Alternate_Content_Service(objLoginEntity.ConnectionStringName).GetById(titleAlternateContetCode);
            }
            if (objTitleAlternateContent == null)
            {
                ViewBag.FirstTime = "Y";
                ViewBag.TitleAlternateContentcode = 0;
                objTitleAlternateContent = new Title_Alternate_Content();
            }
            else
                ViewBag.FirstTime = firstTime;

            ViewBag.TitleAlternateContnetCode = objTitleAlternateContent.Title_Alternate_Content_Code;
            ViewBag.CommandName = CommandName;
            return PartialView("~/Views/Title_Content_View/_Title_Alternate_List.cshtml", objTitleAlternateContent);
        }
        public JsonResult SaveTitleAlternateContent(int titleAlternateContentCode, string EpisodeName, string duration, string synopsis, int EpisodeNo, int titlealternateCode, int alternateConfigCode)
        {
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (titleAlternateContentCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Title_Alternate_Content_Service objService = new Title_Alternate_Content_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Title_Alternate_Content objTitleAlternateContent = null;
            Title_Alternate objTitleAlternate = new Title_Alternate_Service(objLoginEntity.ConnectionStringName).GetById(titlealternateCode);
            if (titleAlternateContentCode > 0)
            {
                objTitleAlternateContent = objService.GetById(titleAlternateContentCode);
                objTitleAlternateContent.EntityState = State.Modified;
            }
            else
            {
                objTitleAlternateContent = new RightsU_Entities.Title_Alternate_Content();
                objTitleAlternateContent.EntityState = State.Added;
                objTitleAlternateContent.Inserted_On = DateTime.Now;
                objTitleAlternateContent.Inserted_By = objLoginUser.Users_Code;
            }

            objTitleAlternateContent.Last_UpDated_Time = DateTime.Now;
            objTitleAlternateContent.Last_Action_By = objLoginUser.Users_Code;
            objTitleAlternateContent.Content_Name = EpisodeName;
            if (duration != "")
                objTitleAlternateContent.Duration = Convert.ToDecimal(duration);
            else
                objTitleAlternateContent.Duration = null;
            objTitleAlternateContent.Synopsis = synopsis;
            objTitleAlternateContent.Episode_No = EpisodeNo;
            objTitleAlternateContent.Alternate_Config_Code = alternateConfigCode;
            objTitleAlternateContent.Title_Alternate_Code = titlealternateCode;
            objTitleAlternateContent.Title_Image = objTitleAlternate.Title_Image;
            objTitleAlternateContent.Language_Code = objTitleAlternate.Title_Language_Code;
            objTitleAlternateContent.Is_Active = "Y";

            dynamic resultSet;
            bool isValid = objService.Save(objTitleAlternateContent, out resultSet);

            if (isValid)
            {
                objTitleAlternateContent = objService.GetById(titleAlternateContentCode);
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public PartialViewResult BindCostListData(string searchText, int pageNo, int recordPerPage, string command, bool tabChanged)
        {
            int? Title_Code = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == objContentMetadata.Title_Content_Code).Select(x => x.Title_Code).FirstOrDefault();
            int? Episode_No = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Code == objContentMetadata.Title_Content_Code).Select(x => x.Episode_No).FirstOrDefault();
            if (!objSearch.VisitedOn_Cost)
            {
                lstContentCostData = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Content_Cost(Title_Code, Episode_No, searchText).ToList();
                objSearch.VisitedOn_Cost = true;
            }
            if (tabChanged)
            {
                pageNo = objSearch.PageNo_Cost;
                recordPerPage = objSearch.PageSize_Cost;
                searchText = objSearch.SearchText_Cost;
            }
            else
            {
                objSearch.PageNo_Cost = pageNo;
                objSearch.PageSize_Cost = recordPerPage;
                objSearch.SearchText_Cost = searchText;
            }

            if (command == Command_Search)
            {
                lstContentCostData = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Content_Cost(Title_Code, Episode_No, searchText).ToList();
            }
            else if (command == Command_ShowAll)
            {
                lstContentCostData = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Content_Cost(Title_Code, Episode_No, searchText).ToList();
            }

            int recordCount = lstContentCostData.Count;
            List<USP_Get_Content_Cost_Result> lst = new List<USP_Get_Content_Cost_Result>();
            if (recordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, recordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContentCostData.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.Sum = lstContentCostData.Sum(t => Convert.ToDouble(t.Cost_per_Episode));
            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;
            ViewBag.RecordCount = recordCount;
            ViewBag.TabChanged = (tabChanged) ? "Y" : "N";
            ViewBag.costtypeCode = searchText;
            return PartialView("~/Views/Title_Content_View/_Cost_Content_List.cshtml", lst);
        }
        public PartialViewResult BindMusicListData(string searchText, string searchVersion, int pageNo, int recordPerPage, string command, bool tabChanged)
        {
            int versionCode = 0;
            if (searchVersion != "")
            {
                versionCode = Convert.ToInt32(searchVersion);
            }
            if (!objSearch.VisitedOn_Music)
            {
                lstContentMusicData_Searched = lstContentMusicData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsMusicData(objContentMetadata.Title_Content_Code).ToList();
                objSearch.VisitedOn_Music = true;
            }

            if (tabChanged)
            {
                pageNo = objSearch.PageNo_Music;
                recordPerPage = objSearch.PageSize_Music;
                searchText = objSearch.SearchText_Music;
                searchVersion = objSearch.SearchText_Music_Version;
            }
            else
            {
                objSearch.PageNo_Music = pageNo;
                objSearch.PageSize_Music = recordPerPage;
                objSearch.SearchText_Music = searchText;
                objSearch.SearchText_Music_Version = searchVersion;
            }

            if (command == Command_Search)
            {
                if (searchText != "" && versionCode > 0)
                {
                    lstContentMusicData_Searched = lstContentMusicData.Where(w => w.Movie_Album.ToUpper().Contains(searchText.ToUpper()) ||
                    w.Music_Label_Name.ToUpper().Contains(searchText.ToUpper()) || w.Music_Title_Name.ToUpper().Contains(searchText.ToUpper()) && w.Version_Code == versionCode).ToList();
                }
                else if (searchText != "")
                {
                    lstContentMusicData_Searched = lstContentMusicData.Where(w => w.Movie_Album.ToUpper().Contains(searchText.ToUpper()) ||
                    w.Music_Label_Name.ToUpper().Contains(searchText.ToUpper()) || w.Music_Title_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
                }
                else if (versionCode > 0)
                {
                    lstContentMusicData_Searched = lstContentMusicData.Where(w => w.Version_Code == versionCode).ToList();
                }
            }
            else if (command == Command_ShowAll)
            {
                lstContentMusicData_Searched = lstContentMusicData;
            }

            int RecordCount = lstContentMusicData_Searched.Count;
            List<USP_GetContentsMusicData_Result> lst = new List<USP_GetContentsMusicData_Result>();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContentMusicData_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.Title_Name = objContentMetadata.Title_Name;
            ViewBag.Episode_No = objContentMetadata.Episode_No;
            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;
            ViewBag.RecordCount = RecordCount;
            ViewBag.SearchText = searchText;
            ViewBag.Version = searchVersion;
            ViewBag.TabChanged = (tabChanged) ? "Y" : "N";
            return PartialView("~/Views/Title_Content_View/_Music_Content_List.cshtml", lst);
        }
        public PartialViewResult BindVersionListData(string searchText, int titleversioncode, int pageNo, int recordPerPage, string command, bool tabChanged)
        {
            ViewBag.titleVersionCode = titleversioncode;
            ViewBag.Command = command;
            ViewBag.Duration = objContentMetadata.Duration;
            var versionCode = new Title_Content_Version_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Content_Version_Code == titleversioncode).Select(x => x.Version_Code).FirstOrDefault();
            ViewBag.VersionList = new SelectList(new Version_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Version_Name != "").ToList(), "Version_Code", "Version_Name", versionCode);
            //ViewBag.VersionList = new Version_Service().SearchFor(x => x.Is_Active == "Y" && x.Version_Name!= "").Select(x => new SelectListItem { Text = x.Version_Name, Value = x.Version_Code.ToString(), Selected= versionCode.ToString() }).Distinct().ToList();
            if (!objSearch.VisitedOn_Version)
            {
                lstContentVersionData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsVersionData(objContentMetadata.Title_Content_Code).ToList();
                objSearch.VisitedOn_Version = true;
            }

            if (tabChanged)
            {
                pageNo = objSearch.PageNo_Version;
                recordPerPage = objSearch.PageSize_Version;
                searchText = objSearch.SearchText_Version;
            }
            else
            {
                objSearch.PageNo_Version = pageNo;
                objSearch.PageSize_Version = recordPerPage;
                objSearch.SearchText_Version = searchText;
            }
            if (command == Command_Search)
            {
                lstContentVersionData = lstContentVersionData.Where(w => w.Version_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else if (command == Command_ShowAll)
            {
                lstContentVersionData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsVersionData(objContentMetadata.Title_Content_Code).ToList();
            }
            int RecordCount = lstContentVersionData.Count;
            List<USP_GetContentsVersionData_Result> lst = new List<USP_GetContentsVersionData_Result>();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContentVersionData.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;
            ViewBag.RecordCount = RecordCount;
            ViewBag.SearchText = searchText;
            ViewBag.TabChanged = (tabChanged) ? "Y" : "N";
            return PartialView("~/Views/Title_Content_View/_Version_Content.cshtml", lst);
        }
        public JsonResult SaveVersion(int titleContentCode, string versioncode, string duration, string HouseId)
        {
            bool returnVal = true;
            dynamic resultSet;
            bool isValid;
            int VersionCode = Convert.ToInt32(versioncode);
            decimal Duration = Convert.ToDecimal(duration);
            //string houseId = Convert.ToString(HouseId);
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            if (titleContentCode > 0)
                message = objMessageKey.Recordupdatedsuccessfully;

            Title_Content_Version_Service objService = new Title_Content_Version_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Title_Content_Version objTCV = null;

            //Title_Content_Version_Details_Service objServices = new Title_Content_Version_Details_Service(objLoginEntity.ConnectionStringName);
            //RightsU_Entities.Title_Content_Version_Details objTCVD = null;

            if (returnVal)
            {
                if (titleContentCode > 0)
                {
                    objTCV = objService.GetById(titleContentCode);
                    objTCV.EntityState = State.Modified;
                }
                else
                {
                    objTCV = new RightsU_Entities.Title_Content_Version();
                    objTCV.EntityState = State.Added;
                }
                objTCV.Version_Code = VersionCode;
                objTCV.Title_Content_Code = objContentMetadata.Title_Content_Code;
                objTCV.Duration = Convert.ToDecimal(duration);
                ICollection<Title_Content_Version_Details> TitleContentVersionDetails = new HashSet<Title_Content_Version_Details>();
                string houseId = Convert.ToString(HouseId);
               
                Title_Content_Version_Details TCDV = new Title_Content_Version_Details();
                int TitleContentVersionDeatilCode = objTCV.Title_Content_Version_Details.Select(s => s.Title_Content_Version_Details_Code).FirstOrDefault();
                TCDV = new Title_Content_Version_Details_Service(objLoginEntity.ConnectionStringName).GetById(TitleContentVersionDeatilCode);
                if (TCDV != null)
                {
                    TCDV.EntityState = State.Modified;
                    //objTCV.Title_Content_Version_Details.FirstOrDefault().House_Id = houseId;
                }
                else
                {
                     TCDV = new Title_Content_Version_Details();
                    TCDV.EntityState = State.Added;
                    objTCV.Title_Content_Version_Details.Add(TCDV);
                }
                objTCV.Title_Content_Version_Details.FirstOrDefault().House_Id = houseId;
                //TCDV.House_Id = houseId;
                
               
                isValid = objService.Save(objTCV, out resultSet);
                BindDDL();
                if (isValid)

                {
                    lstContentVersionData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsVersionData(objContentMetadata.Title_Content_Code).ToList();
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
            }

            var obj = new
            {
                RecordCount = lstContentVersionData.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public JsonResult DeleteVersion(int title_Content_Version_Code, string houseId)
        {
            string status = "", Message = "";
             dynamic resultSet = "";
            Title_Content_Version_Service objService = new Title_Content_Version_Service(objLoginEntity.ConnectionStringName);
            Title_Content_Version objTCV = objService.GetById(title_Content_Version_Code);

            if (objService.Delete(objTCV, out resultSet))
            {
                status = "S";
                Message = "Record deleted successfully";
                dynamic objToDelete = lstContentVersionData.Where(w => w.Title_Content_Version_Code == title_Content_Version_Code).FirstOrDefault();
                if (objToDelete != null)
                    lstContentVersionData.Remove(objToDelete);
            }
            else
            {
                status = "E";
                Message = resultSet;
            }

            var obj = new
            {
                Status = status,
                Message = Message
            };
            return Json(obj);
        }
        public PartialViewResult BindAiringListData(string StartDate, string EndDate, string VersionId, string ChannelCodes,
            int pageNo, int recordPerPage, string command, bool tabChanged)
        {
            if (tabChanged)
            {
                pageNo = objSearch.PageNo_Airing;
                recordPerPage = objSearch.PageSize_Airing;
                StartDate = objSearch.StartDate_Airing;
                EndDate = objSearch.EndDate_Airing;
                VersionId = objSearch.VersionId_Airing;
                ChannelCodes = objSearch.ChannelCodes_Airing;
            }
            else
            {
                objSearch.PageNo_Airing = pageNo;
                objSearch.PageSize_Airing = recordPerPage;
                objSearch.StartDate_Airing = StartDate;
                objSearch.EndDate_Airing = EndDate;
                objSearch.VersionId_Airing = VersionId;
                objSearch.ChannelCodes_Airing = ChannelCodes;
            }

            if (command == Command_Search)
            {
                lstContentAiringData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsAiringData(objContentMetadata.Title_Content_Code,
                        StartDate, EndDate, VersionId, ChannelCodes).ToList();
            }
            else if (command == Command_ShowAll || !objSearch.VisitedOn_Airing)
            {
                lstContentAiringData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsAiringData(objContentMetadata.Title_Content_Code, "", "", "", "").ToList();
                objSearch.VisitedOn_Airing = true;
            }

            int RecordCount = lstContentAiringData.Count;
            List<USP_GetContentsAiringData_Result> lst = new List<USP_GetContentsAiringData_Result>();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContentAiringData.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;
            ViewBag.RecordCount = RecordCount;
            ViewBag.StartDate = StartDate;
            ViewBag.EndDate = EndDate;
            ViewBag.Version = VersionId;
            ViewBag.ChannelCodes = ChannelCodes;
            ViewBag.TabChanged = (tabChanged) ? "Y" : "N";
            return PartialView("~/Views/Title_Content_View/_Airing_Content_List.cshtml", lst);
        }
        public PartialViewResult BindStatusHistoryListData(int pageNo, int recordPerPage, string command, bool tabChanged)
        {
            if (!objSearch.VisitedOn_StatusHistory)
            {
                objSearch.VisitedOn_StatusHistory = true;
                lstContentStatusHistoryData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetContentsStatusHistoryData(objContentMetadata.Title_Content_Code).ToList();
            }

            if (tabChanged)
            {
                pageNo = objSearch.PageNo_StatusHistory;
                recordPerPage = objSearch.PageSize_StatusHistory;
            }
            else
            {
                objSearch.PageNo_StatusHistory = pageNo;
                objSearch.PageSize_StatusHistory = recordPerPage;
            }

            int RecordCount = lstContentStatusHistoryData.Count;
            List<USP_GetContentsStatusHistoryData_Result> lst = new List<USP_GetContentsStatusHistoryData_Result>();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstContentStatusHistoryData.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.PageNo = pageNo;
            ViewBag.PageSize = recordPerPage;
            ViewBag.RecordCount = RecordCount;
            return PartialView("~/Views/Title_Content_View/_Status_History_Content.cshtml", lst);
        }
        public PartialViewResult BindRunDefinitionListData( string command, bool tabChanged,String Type,int Channel_Code,String Start_Date,string End_Date,string Deal_Type,string CurrentTab)
        {
            lstContentRunDefData = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetRunDefinitonForContent(objContentMetadata.Title_Content_Code, Type, Channel_Code, Start_Date, End_Date, Deal_Type, CurrentTab).ToList();
            ViewBag.Type = Type;
            List<USP_GetContentsMusicData_Result> lst = new List<USP_GetContentsMusicData_Result>();
            return PartialView("~/Views/Title_Content_View/_Run_Defintion_List.cshtml", lstContentRunDefData);
        }
        public void ExportToXML(FormCollection objFormCollection)
        {
            int Title_Content_Version = 0;
            if (objFormCollection["DealTypeC"] != "")
            {
                Title_Content_Version = Convert.ToInt32(objFormCollection["DealTypeC"]);
            }
         

            List<USP_List_Content_Version_Result> USP_List_Content_Version = new List<USP_List_Content_Version_Result>();
            var TitleList = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Content_Version(Title_Content_Version).ToList();
            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=TitleContentVersion.xml");
            Response.ContentType = "text/xml";

            var serializer = new System.Xml.Serialization.XmlSerializer(TitleList.GetType());
            serializer.Serialize(Response.OutputStream, TitleList);
        }
        public ActionResult UploadContentVersionTitle()
        {
            return View("Version_Content_Import");
        }

        public JsonResult UploadContentTitle(HttpPostedFileBase InputFile)
        {
            string message = "";
            string isError = "N";
            string status = "";
            string sheetName = "Sheet1$";
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var PostedFile = InputFile;
                string fullPath = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadFilePath"]);
                string ext = System.IO.Path.GetExtension(PostedFile.FileName);
                if (ext == ".xml")
                {
                    //ExcelReader objExcelReader = new ExcelReader();
                    DataSet ds = new DataSet();
                    try
                    {
                        string strFileName = System.IO.Path.GetFileName(PostedFile.FileName);
                        if ((ext.ToLower() != ".xml") || (PostedFile.ContentLength <= 0))
                        {
                            isError = "Y";
                            message = "Please upload Xml Sheet named as " + sheetName.Trim() + " only with .xml extension.";
                        }
                            string connetionString = "";
                            SqlConnection connection;
                            string strActualFileNameWithDate = System.DateTime.Now.Ticks + "~" + strFileName;
                            string fullpathname = fullPath + strActualFileNameWithDate; ;
                            PostedFile.SaveAs(fullpathname);
                            ds = new DataSet();
                            try
                            {
                                connetionString = "Data Source=192.168.0.115;Initial Catalog=RightsU_Plus;User ID=dbserver2012;Password=dbserver2012";
                                connection = new SqlConnection(connetionString);
                            //string filePath = Server.MapPath("~") + "\\EntitiesList.xml";
                            System.IO.FileStream fsReadXml = new System.IO.FileStream(fullpathname, System.IO.FileMode.Open);
                            ds.ReadXml(fsReadXml);
                            fsReadXml.Close();
                            //SqlDataAdapter Adapter = new SqlDataAdapter("Select * From [TestTable]", connection);
                            //Adapter.Fill(ds);
                        }
                        catch (Exception ex)
                        {
                            isError = "Y";
                            message = "Please upload Xml sheet named as \\'" + sheetName.Trim() + "\\'";
                        }
                        finally
                        {
                            //Always delete uploaded excel file from folder.
                            System.IO.File.Delete(fullpathname.Trim());
                        }
                        var count = ds.Tables.Count;
                        if (count == 0)
                        {
                            message = "'" + sheetName.Trim('$') + "'" + " Sheet name should not be existing in uploaded xml";
                            status = "E";
                        }
                        if (ds.Tables.Count > 0)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                dynamic resultSet;
                                List<Title_Content_Version_UDT> lst_Title_Content_Import_UDT = new List<Title_Content_Version_UDT>();
                                foreach (DataRow row in ds.Tables[0].Rows)
                                {
                                    Title_Content_Version_UDT obj_Title_Content_Import_UDT = new Title_Content_Version_UDT();
                                    obj_Title_Content_Import_UDT.Title_Content_Version_Code = row["RU_PROGRAM_FOREIGN_ID"].ToString();
                                    obj_Title_Content_Import_UDT.House_Id = row["RU_HOUSE_ID"].ToString();
                                    lst_Title_Content_Import_UDT.Add(obj_Title_Content_Import_UDT);
                                }

                                lstError = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Content_Version_PI(lst_Title_Content_Import_UDT, Convert.ToString(objLoginUser.Users_Code)).ToList();

                                if (lstError.Count == 0)
                                {
                                    message = "Data saved successfully";
                                    status = "S";
                                }
                                //    return PartialView("_TitleImport_List", lstRE);
                            }

                        }
                    }
                    catch (Exception ex)
                    {
                        isError = "Y";
                        message = ex.Message;
                    }
                }
                else
                {
                    message = "Please Select Xml File";
                    status = "E";
                }

            }
            else
            {
                message = "Please Select Xml File";
                status = "E";

            }

            ViewBag.Message = message;
            Dictionary<string, object> obj_Dictionary = new Dictionary<string, object>();
            obj_Dictionary.Add("IsError", isError);
            obj_Dictionary.Add("Message", message);
            return Json(obj_Dictionary);
        }

    
        #endregion

        #region --- Other Methods ---
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
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForContent), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public bool CheckDuplicateEpisodeNumber(int titleContentCode, int EpisodeNum)
        {
            RightsU_Entities.Title_Content objTitleContent = new Title_Content_Service(objLoginEntity.ConnectionStringName).GetById(titleContentCode);
            List<int?> EpisodeNumbers = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Title_Code == objTitleContent.Title_Code && w.Title_Content_Code != objTitleContent.Title_Content_Code).Select(s => s.Episode_No).ToList();
            bool EpisodeExists = EpisodeNumbers.Contains(EpisodeNum);
            return EpisodeExists;
        }
        #endregion


    }

    internal class Title_Content_View_Search
    {
        #region --- Rights Tab ---
        private int _PageNo_Rights = 1;
        internal int PageNo_Rights
        {
            get { return _PageNo_Rights; }
            set { _PageNo_Rights = value; }
        }

        private int _PageSize_Rights = 10;
        internal int PageSize_Rights
        {
            get { return _PageSize_Rights; }
            set { _PageSize_Rights = value; }
        }


        private bool _VisitedOn_Rights = false;
        internal bool VisitedOn_Rights
        {
            get { return _VisitedOn_Rights; }
            set { _VisitedOn_Rights = value; }
        }

        #endregion
        #region --- Cost Tab ---
        private int _PageNo_Cost = 1;
        internal int PageNo_Cost
        {
            get { return _PageNo_Cost; }
            set { _PageNo_Cost = value; }
        }

        private int _PageSize_Cost = 10;
        internal int PageSize_Cost
        {
            get { return _PageSize_Cost; }
            set { _PageSize_Cost = value; }
        }

        private bool _VisitedOn_Cost = false;
        internal bool VisitedOn_Cost
        {
            get { return _VisitedOn_Cost; }
            set { _VisitedOn_Cost = value; }
        }

        private string _SearchText_Cost = "";
        internal string SearchText_Cost
        {
            get { return _SearchText_Cost; }
            set { _SearchText_Cost = value; }
        }
        #endregion

        #region --- Music Tab ---
        private int _PageNo_Music = 1;
        internal int PageNo_Music
        {
            get { return _PageNo_Music; }
            set { _PageNo_Music = value; }
        }

        private int _PageSize_Music = 10;
        internal int PageSize_Music
        {
            get { return _PageSize_Music; }
            set { _PageSize_Music = value; }
        }

        private bool _VisitedOn_Music = false;
        internal bool VisitedOn_Music
        {
            get { return _VisitedOn_Music; }
            set { _VisitedOn_Music = value; }
        }

        private string _SearchText_Music = "";
        internal string SearchText_Music
        {
            get { return _SearchText_Music; }
            set { _SearchText_Music = value; }
        }
        private string _SearchText_Music_Version = "";
        internal string SearchText_Music_Version
        {
            get { return _SearchText_Music_Version; }
            set { _SearchText_Music_Version = value; }
        }
        #endregion

        #region --- Version Tab ---
        private int _PageNo_Version = 1;
        internal int PageNo_Version
        {
            get { return _PageNo_Version; }
            set { _PageNo_Version = value; }
        }

        private int _PageSize_Version = 10;
        internal int PageSize_Version
        {
            get { return _PageSize_Version; }
            set { _PageSize_Version = value; }
        }

        private bool _VisitedOn_Version = false;
        internal bool VisitedOn_Version
        {
            get { return _VisitedOn_Version; }
            set { _VisitedOn_Version = value; }
        }

        private string _SearchText_Version = "";
        internal string SearchText_Version
        {
            get { return _SearchText_Version; }
            set { _SearchText_Version = value; }
        }
        #endregion

        #region --- Airing Tab ---

        private int _PageNo_Airing = 1;
        internal int PageNo_Airing
        {
            get
            {
                return _PageNo_Airing;
            }

            set
            {
                _PageNo_Airing = value;
            }
        }

        private int _PageSize_Airing = 10;
        internal int PageSize_Airing
        {
            get { return _PageSize_Airing; }
            set { _PageSize_Airing = value; }
        }

        private bool _VisitedOn_Airing = false;
        internal bool VisitedOn_Airing
        {
            get { return _VisitedOn_Airing; }
            set { _VisitedOn_Airing = value; }
        }

        private string _StartDate_Airing = "";
        internal string StartDate_Airing
        {
            get { return _StartDate_Airing; }
            set { _StartDate_Airing = value; }
        }

        private string _EndDate_Airing = "";
        internal string EndDate_Airing
        {
            get { return _EndDate_Airing; }
            set { _EndDate_Airing = value; }
        }

        private string _VersionId_Airing = "";
        internal string VersionId_Airing
        {
            get { return _VersionId_Airing; }
            set { _VersionId_Airing = value; }
        }

        private string _ChannelCodes_Airing = "";
        internal string ChannelCodes_Airing
        {
            get { return _ChannelCodes_Airing; }
            set { _ChannelCodes_Airing = value; }
        }
        #endregion

        #region --- Status History Tab ---
        private int _PageNo_StatusHistory = 1;
        internal int PageNo_StatusHistory
        {
            get { return _PageNo_StatusHistory; }
            set { _PageNo_StatusHistory = value; }
        }

        private int _PageSize_StatusHistory = 10;
        internal int PageSize_StatusHistory
        {
            get { return _PageSize_StatusHistory; }
            set { _PageSize_StatusHistory = value; }
        }

        private bool _VisitedOn_StatusHistory = false;
        internal bool VisitedOn_StatusHistory
        {
            get { return _VisitedOn_StatusHistory; }
            set { _VisitedOn_StatusHistory = value; }
        }
        #endregion

       
    }


}

