using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;

namespace RightsU_Plus.Controllers
{
    public class Acq_AmortController : BaseController
    {
        #region --- Properties ---
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
        public int Acq_Deal_Code
        {
            get
            {
                if (Session["Acq_Deal_Code"] == null)
                    Session["Acq_Deal_Code"] = "0";
                return Convert.ToInt32(Session["Acq_Deal_Code"]);
            }
            set { Session["Acq_Deal_Code"] = value; }
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
                if (Session["ADS_Acq_General"] == null)
                    Session["ADS_Acq_General"] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Service)Session["ADS_Acq_General"];
            }
            set { Session["ADS_Acq_General"] = value; }
        }
        #endregion
        public PartialViewResult Index()
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            Dictionary<string, string> obj_Dictionary_Title = new Dictionary<string, string>();
            if (TempData["QueryString"] != null)
            {
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
                objDeal_Schema = null;
                if (Convert.ToString(obj_Dictionary["Mode"]).Trim() == GlobalParams.DEAL_MODE_REOPEN)
                    ClearSession();
                Acq_Deal_Code = Convert.ToInt32(obj_Dictionary["Acq_Deal_Code"]);
                objDeal_Schema.Mode = Convert.ToString(obj_Dictionary["Mode"]).Trim();
                objDeal_Schema.Pushback_Text = obj_Dictionary["Pushback_Text"];
            }
            else
            {
                Acq_Deal_Code = objDeal_Schema.Deal_Code;
            }
            if (TempData["TitleData"] != null)
            {
                TempData.Keep("TitleData");
            }
            objDeal_Schema.Page_From = GlobalParams.Page_From_Amort;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD)
            {
                if (Acq_Deal_Code > 0)
                    objAD_Session = objADS.GetById(Acq_Deal_Code);
            }
            else
            {
                objAD_Session.Is_Master_Deal = "Y";
                objAD_Session.Agreement_Date = DateTime.Now;
                objAD_Session.Deal_Type_Code = GlobalParams.Deal_Type_Movie;
                objAD_Session.Year_Type = "DY";

                ViewBag.Deal_Mode = GlobalParams.DEAL_MODE_ADD;
            }

            objDeal_Schema.Module_Rights_List = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objLoginUser.Security_Group_Code
                            && i.System_Module_Rights_Code == i.System_Module_Right.Module_Right_Code
                            && i.System_Module_Right.Module_Code == 30)
                .Select(i => i.System_Module_Right.Right_Code).Distinct().ToList();

            BindSchemaObject();
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_APPROVE && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
            {
                ViewBag.Deal_Mode = objDeal_Schema.Mode;
                if (objAD_Session.Deal_Workflow_Status != null)
                    if (Convert.ToString(objAD_Session.Deal_Workflow_Status).Trim() == GlobalParams.dealWorkFlowStatus_Approved)
                    {
                        objAD_Session.Version = (Convert.ToInt32(Convert.ToDouble(objAD_Session.Version)) + 1).ToString("0000");
                        objAD_Session.Deal_Workflow_Status = GlobalParams.dealWorkFlowStatus_Ammended;
                        objAD_Session.Amendment_Date = DateTime.Now;
                    }

                ViewBag.DealTypeCode_MasterDeal = 0;
                if (objAD_Session.Is_Master_Deal.Equals("N"))
                    ViewBag.DealTypeCode_MasterDeal = (new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Acq_Deal_Movie_Code == objAD_Session.Master_Deal_Movie_Code_ToLink).Select(s => (int)s.Acq_Deal.Deal_Type_Code).FirstOrDefault();

                if (objAD_Session.Deal_Tag_Code == null)
                    objAD_Session.Deal_Tag_Code = 0;

                if (objAD_Session.Is_Master_Deal == null)
                    objAD_Session.Is_Master_Deal = "Y";

                if (objAD_Session.Master_Deal_Movie_Code_ToLink == null)
                    objAD_Session.Master_Deal_Movie_Code_ToLink = 0;

                if (objAD_Session.Deal_Type_Code == null)
                    objAD_Session.Deal_Type_Code = GlobalParams.Deal_Type_Movie;
            }
            else
            {
                objDeal_Schema.List_Deal_Tag = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true), "Deal_Tag_Code", "Deal_Tag_Description", objAD_Session.Deal_Tag_Code == 0 ? 1 : objAD_Session.Deal_Tag_Code).ToList();

                if (objAD_Session.Master_Deal_Movie_Code_ToLink == null)
                    objAD_Session.Master_Deal_Movie_Code_ToLink = 0;
            }

            //var MovieList = new Acq_Deal_Service().SearchFor(x => x.Acq_Deal_Code == Acq_Deal_Code).FirstOrDefault().Acq_Deal_Movie.ToList().Select(b => new { b.Title.Title_Code, b.Title.Title_Name }).ToList();
            var licensor = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == Acq_Deal_Code).FirstOrDefault().Vendor.Vendor_Name;
            ViewBag.licensor = licensor.ToString();

            var Rights = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == Acq_Deal_Code).Select(a => new { a.Original_Right_Type, a.Actual_Right_Start_Date, a.Actual_Right_End_Date }).ToList().FirstOrDefault();
            string Rights_Type = Convert.ToString(Rights.Original_Right_Type);
            if (Rights_Type == "U")
            {
                ViewBag.Rights = Convert.ToDateTime(Rights.Actual_Right_Start_Date).ToString("dd/MM/yyyy") + "(Perpetuity)";
            }
            else
            {
                ViewBag.Rights = Convert.ToDateTime(Rights.Actual_Right_Start_Date).ToString("dd/MM/yyyy") + " - " + Convert.ToString(Convert.ToDateTime(Rights.Actual_Right_End_Date).ToString("dd/MM/yyyy")).Replace("01/01/0001", "");
            }
            //ViewBag.MovieList = new MultiSelectList(MovieList.ToList(), "Title_Code", "Title_Name"); //DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().BindTitle_List(objDeal_Schema.Deal_Code, objDeal_Schema.Deal_Type_Code, Title_Code_Search); 

            string[] arrSelectedTitle = (string.Join(",", objAD_Session.Acq_Deal_Movie.Where(w => w.EntityState != State.Deleted).Select(s => Convert.ToInt32(s.Title_Code)).ToArray())).Split(',');
            List<SelectListItem> lstTitleSearch = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).Distinct(), "Title_Code", "Title_Name").OrderBy(o => o.Text).ToList();
            ViewBag.TitleList = lstTitleSearch;

            int TitleCode = Convert.ToInt32(lstTitleSearch[0].Value);
            var NoOfEposide = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == Acq_Deal_Code && x.Title_Code == TitleCode).Select(a => a.No_Of_Episodes ?? 0).ToList().FirstOrDefault();
            ViewBag.NoOfEposide = NoOfEposide.ToString();

            var Acq_Deal_Run_Channel = new Acq_Deal_Run_Service(objLoginEntity.ConnectionStringName).SearchFor(a => a.Acq_Deal_Code == Acq_Deal_Code);

            Session["FileName"] = "";
            ViewBag.PageMode = objDeal_Schema.Mode;
            ViewBag.Record_Locking_Code = 0;
            return PartialView("~/Views/Acq_Deal/_Acq_Amort.cshtml");
        }

        public ActionResult ClosingDealMovieEpisode()
        {
            return PartialView("~/Views/Shared/ClosingDealMovieEpisode.cshtml");
        }

        public JsonResult NoOfEposide(int TitleCode)
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            if (TempData["QueryString"] != null)
            {
                obj_Dictionary = TempData["QueryString"] as Dictionary<string, string>;
                Acq_Deal_Code = Convert.ToInt32(obj_Dictionary["Acq_Deal_Code"]);
            }
            var NoOfEposide = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Acq_Deal_Code == Acq_Deal_Code && x.Title_Code == TitleCode).Select(a => a.No_Of_Episodes).ToList().FirstOrDefault();
            ViewBag.NoOfEposide = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Status", "S");
            obj.Add("NoOfEposide", NoOfEposide.Value);
            return Json(obj);
        }

        private void ClearSession()
        {
            objAD_Session = null;
            objADS = null;
            Session["Acq_Deal_Code"] = null;
            Session["Clone_Acq_Deal_Code"] = null;
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
                    objDeal_Schema.Deal_Workflow_Flag = Convert.ToString(objAD_Session.Deal_Workflow_Status).Trim();

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

                    if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_CLONE)
                    {
                        objDeal_Schema.Deal_Desc = objAD_Session.Deal_Desc;
                        objDeal_Schema.Agreement_Date = objAD_Session.Agreement_Date;
                    }
                }

                if (TempData["QueryString"] != null && obj_Dictionary["PageNo"] != null)
                    objDeal_Schema.PageNo = Convert.ToInt32(obj_Dictionary["PageNo"].ToString());
                //objDeal_Schema.PageNo = Convert.ToInt32(obj_Dictionary["PageNo"] != null ? obj_Dictionary["PageNo"].ToString() : "1");
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
            objDeal_Schema.Title_Icon_Path = fileName;
            objDeal_Schema.Title_Icon_Tooltip = "Deal Type - " + GetTitleLabel(dealTypeCode);

            titleIconTooltip = objDeal_Schema.Title_Icon_Tooltip;
            return iconPath;
        }

        private string GetTitleLabel(int dealTypeCode)
        {
            string Title_Label = "";
            if (dealTypeCode == GlobalParams.Deal_Type_Movie)
                Title_Label = "Movie";
            else if (dealTypeCode == GlobalParams.Deal_Type_Documentary_Film)
                Title_Label = "Documentary Film";
            else if (dealTypeCode == GlobalParams.Deal_Type_Content)
                Title_Label = "Program";
            else if (dealTypeCode == GlobalParams.Deal_Type_Event)
                Title_Label = "Event";
            else if (dealTypeCode == GlobalParams.Deal_Type_Documentary_Show)
                Title_Label = "Deal Documentary Show";
            else if (dealTypeCode == GlobalParams.Deal_Type_Sports)
                Title_Label = "Sports";
            else if (dealTypeCode == GlobalParams.Deal_Type_Music)
                Title_Label = "Embedded Music";
            else if (dealTypeCode == GlobalParams.Deal_Type_ContentMusic)
                Title_Label = "Content Music";
            else if (dealTypeCode == GlobalParams.Deal_Type_Format_Program)
                Title_Label = "Format Program";
            else if (dealTypeCode == GlobalParams.Deal_Type_Performer)
                Title_Label = "Performer";
            else if (dealTypeCode == GlobalParams.Deal_Type_Writer)
                Title_Label = "Writer";
            else if (dealTypeCode == GlobalParams.Deal_Type_Music_Composer)
                Title_Label = "Music Composer";
            else if (dealTypeCode == GlobalParams.Deal_Type_DOP)
                Title_Label = "DOP";
            else if (dealTypeCode == GlobalParams.Deal_Type_Choreographer)
                Title_Label = "Choreographer";
            else if (dealTypeCode == GlobalParams.Deal_Type_Lyricist)
                Title_Label = "Lyricist";
            else if (dealTypeCode == GlobalParams.Deal_Type_Director)
                Title_Label = "Director";
            else if (dealTypeCode == GlobalParams.Deal_Type_VideoMusic)
                Title_Label = "Video Company";
            else if (dealTypeCode == GlobalParams.Deal_Type_Singer)
                Title_Label = "Singer";
            else if (dealTypeCode == GlobalParams.Deal_Type_Other_Talent)
                Title_Label = "Other Talent";
            else if (dealTypeCode == GlobalParams.Deal_Type_Contestant)
                Title_Label = "Contestant Name";
            else if (dealTypeCode == GlobalParams.Deal_Type_Producer)
                Title_Label = "Producer";
            else if (dealTypeCode == GlobalParams.Deal_Type_ShortFlim)
                Title_Label = "Deal For Short Film";

            return Title_Label;
        }
    }
}
