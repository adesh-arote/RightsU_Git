using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_Sport_AncillaryController : BaseController
    {
        //
        // GET: /Acq_Sport_Ancillary/
        #region --- Properties ---

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
                if (Session["ADS_Acq_General"] == null)
                    Session["ADS_Acq_General"] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Service)Session["ADS_Acq_General"];
            }
            set { Session["ADS_Acq_General"] = value; }
        }

        public Acq_Deal_Sport_Ancillary sportAncillaryInstance
        {
            get
            {
                if (Session["Acq_Deal_Sport_Ancillary"] == null)
                    Session["Acq_Deal_Sport_Ancillary"] = new Acq_Deal_Sport_Ancillary();
                return (Acq_Deal_Sport_Ancillary)Session["Acq_Deal_Sport_Ancillary"];
            }
            set { Session["Acq_Deal_Sport_Ancillary"] = value; }
        }
        public Acq_Deal_Sport_Ancillary_Service objADSAS
        {
            get
            {
                if (Session["Acq_Deal_Sport_Ancillary_Service"] == null)
                    Session["Acq_Deal_Sport_Ancillary_Service"] = new Acq_Deal_Sport_Ancillary_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Sport_Ancillary_Service)Session["Acq_Deal_Sport_Ancillary_Service"];
            }
            set { Session["Acq_Deal_Sport_Ancillary_Service"] = value; }
        }
        public Acq_Deal_Sport_Sales_Ancillary sportSalesAncillaryInstance
        {
            get
            {
                if (Session["Acq_Deal_Sport_Sales_Ancillary"] == null)
                    Session["Acq_Deal_Sport_Sales_Ancillary"] = new Acq_Deal_Sport_Sales_Ancillary();
                return (Acq_Deal_Sport_Sales_Ancillary)Session["Acq_Deal_Sport_Sales_Ancillary"];
            }
            set { Session["Acq_Deal_Sport_Sales_Ancillary"] = value; }
        }
        public Acq_Deal_Sport_Sales_Ancillary_Service objADSSaleAS
        {
            get
            {
                if (Session["Acq_Deal_Sport_Sales_Ancillary_Service"] == null)
                    Session["Acq_Deal_Sport_Sales_Ancillary_Service"] = new Acq_Deal_Sport_Sales_Ancillary_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Sport_Sales_Ancillary_Service)Session["Acq_Deal_Sport_Sales_Ancillary_Service"];
            }
            set { Session["Acq_Deal_Sport_Sales_Ancillary_Service"] = value; }
        }
        public Acq_Deal_Sport_Monetisation_Ancillary sportMonetisationAncillaryInstance
        {
            get
            {
                if (Session["Acq_Deal_Sport_Monetisation_Ancillary"] == null)
                    Session["Acq_Deal_Sport_Monetisation_Ancillary"] = new Acq_Deal_Sport_Monetisation_Ancillary();
                return (Acq_Deal_Sport_Monetisation_Ancillary)Session["Acq_Deal_Sport_Monetisation_Ancillary"];
            }
            set { Session["Acq_Deal_Sport_Monetisation_Ancillary"] = value; }
        }
        public Acq_Deal_Sport_Monetisation_Ancillary_Service objADSMonetisationAS
        {
            get
            {
                if (Session["Acq_Deal_Sport_Monetisation_Ancillary_Service"] == null)
                    Session["Acq_Deal_Sport_Monetisation_Ancillary_Service"] = new Acq_Deal_Sport_Monetisation_Ancillary_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Sport_Monetisation_Ancillary_Service)Session["Acq_Deal_Sport_Monetisation_Ancillary_Service"];
            }
            set { Session["Acq_Deal_Sport_Monetisation_Ancillary_Service"] = value; }
        }

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

        #endregion

        public static List<int> selectedDisplayProTitle;
        public PartialViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Ancillary;
            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);
            Session["FileName"] = "";
            Session["FileName"] = "acq_SportsAncillary";
            return PartialView("~/Views/Acq_Deal/_Acq_Sport_Ancillary_List.cshtml");
        }

        #region ========= Programming =========

        public PartialViewResult BindProgramming(string displayType = "G", string selectedTitle = "")
        {
            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            ViewBag.DisplayProTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name");

            selectedDisplayProTitle = new List<int>();
            if (selectedTitle != string.Empty)
                foreach (string titleCode in selectedTitle.Split(','))
                {
                    selectedDisplayProTitle.Add(Convert.ToInt32(titleCode));
                }
            BindProDropDown();
            List<Acq_Deal_Sport_Ancillary> lstSportAncillary = objADSAS.SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code && s.Ancillary_For == "P").ToList();
            ViewBag.PageMode = objDeal_Schema.Mode;
            if (displayType == "G")
            {
                var q = from sportAnc in lstSportAncillary
                        //from sportAncTitle in sportAnc.Acq_Deal_Sport_Ancillary_Title.DefaultIfEmpty()
                        //where selectedDisplayProTitle.Contains(sportAncTitle.Title_Code.Value) || selectedDisplayProTitle.Count == 0
                        where sportAnc.Acq_Deal_Sport_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Count() > 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Ancillary_Code = sportAnc.Acq_Deal_Sport_Ancillary_Code,
                            Title = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Select(t => t.Title.Title_Name)),//((sportAncTitle != null) ? ((sportAncTitle.Title != null) ? sportAncTitle.Title.Title_Name : "") : ""),
                            TitleCode = "0",
                            Type = (sportAnc.Sport_Ancillary_Type != null) ? sportAnc.Sport_Ancillary_Type.Name : "",
                            Obligation_Broadcast = (sportAnc.Obligation_Broadcast == "Y") ? "Yes" : "No",
                            Obligation = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Select(sportAncBroadcast => sportAncBroadcast.Sport_Ancillary_Broadcast.Name)) + ((sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Count > 0 && sportAnc.Sport_Ancillary_Periodicity1 != null) ? "-" : "") + ((sportAnc.Sport_Ancillary_Periodicity1 != null) ? sportAnc.Broadcast_Window.ToString() + " " + sportAnc.Sport_Ancillary_Periodicity1.Name : ""),
                            Duration = getHourMinutesSeconds(sportAnc.Duration) + ((sportAnc.Duration != null && sportAnc.Sport_Ancillary_Periodicity_Code != null) ? "-" : "") + ((sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : ""),
                            Source = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Source.Select(s => s.Sport_Ancillary_Source.Name)),
                            Remarks = sportAnc.Remarks
                        };

                return PartialView("~/Views/Acq_Deal/_Programing.cshtml", q);
            }
            else
            {
                var q = from sportAnc in lstSportAncillary
                        from sportAncTitle in sportAnc.Acq_Deal_Sport_Ancillary_Title.DefaultIfEmpty()
                        //where selectedDisplayProTitle.Contains(sportAncTitle.Title_Code.Value) || selectedDisplayProTitle.Count == 0
                        where selectedDisplayProTitle.Contains(sportAncTitle.Title_Code.Value) || selectedDisplayProTitle.Count == 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Ancillary_Code = sportAnc.Acq_Deal_Sport_Ancillary_Code,
                            Title = (sportAncTitle.Title_Code != null) ? sportAncTitle.Title.Title_Name : "",
                            TitleCode = ((sportAncTitle != null) ? ((sportAncTitle.Title_Code != null) ? sportAncTitle.Title_Code.ToString() : "") : ""),
                            Type = (sportAnc.Sport_Ancillary_Type != null) ? sportAnc.Sport_Ancillary_Type.Name : "",
                            Obligation_Broadcast = (sportAnc.Obligation_Broadcast == "Y") ? "Yes" : "No",
                            Obligation = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Select(sportAncBroadcast => sportAncBroadcast.Sport_Ancillary_Broadcast.Name)) + ((sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Count > 0 && sportAnc.Sport_Ancillary_Periodicity1 != null) ? "-" : "") + ((sportAnc.Sport_Ancillary_Periodicity1 != null) ? sportAnc.Broadcast_Window.ToString() + " " + sportAnc.Sport_Ancillary_Periodicity1.Name : ""),
                            Duration = getHourMinutesSeconds(sportAnc.Duration) + ((sportAnc.Duration != null && sportAnc.Sport_Ancillary_Periodicity_Code != null) ? "-" : "") + ((sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : ""),
                            Source = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Source.Select(s => s.Sport_Ancillary_Source.Name)),
                            Remarks = sportAnc.Remarks
                        };
                return PartialView("~/Views/Acq_Deal/_Programing.cshtml", q);
            }
        }

        private void BindProDropDown()
        {

            Sport_Ancillary_Type_Service objTypeService = new Sport_Ancillary_Type_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Source_Service objSourceService = new Sport_Ancillary_Source_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Periodicity_Service objPeriodicityService = new Sport_Ancillary_Periodicity_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Broadcast_Service objBroadcastService = new Sport_Ancillary_Broadcast_Service(objLoginEntity.ConnectionStringName);

            #region Bind Programming Dropdown
            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);
            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            ViewBag.ProTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name");

            List<Sport_Ancillary_Type> lstAncillaryType = objTypeService.SearchFor(t => t.Is_Active == "Y" && t.Sport_Ancillary_Config.Any(c => c.Flag == "P")).ToList();
            lstAncillaryType.Insert(0, new Sport_Ancillary_Type { Sport_Ancillary_Type_Code = 0, Name = objMessageKey.PleaseSelect });
            ViewBag.ProTypeList = new MultiSelectList(lstAncillaryType, "Sport_Ancillary_Type_Code", "Name");


            List<Sport_Ancillary_Source> lstAncillarySource = objSourceService.SearchFor(s => s.Is_Active == "Y" && s.Sport_Ancillary_Config.Any(c => c.Flag == "P")).ToList();
            ViewBag.ProSourceList = new MultiSelectList(lstAncillarySource, "Sport_Ancillary_Source_Code", "Name");

            List<Sport_Ancillary_Periodicity> lstAcillaryPeriodicity = objPeriodicityService.SearchFor(p => p.Is_Active == "Y" && p.Sport_Ancillary_Config.Any(c => c.Flag == "P")).OrderBy(p => p.Order_By).ToList();
            ViewBag.ProPeriodicityList = new MultiSelectList(lstAcillaryPeriodicity, "Sport_Ancillary_Periodicity_Code", "Name");

            List<Sport_Ancillary_Periodicity> lstAcillaryBroadcastPeriodicity = objPeriodicityService.SearchFor(p => p.Is_Active == "Y" && p.Sport_Ancillary_Config.Any(c => c.Flag == "W")).OrderBy(p => p.Order_By).ToList();
            lstAcillaryBroadcastPeriodicity.Insert(0, new Sport_Ancillary_Periodicity { Sport_Ancillary_Periodicity_Code = 0, Name = "N.A." });
            ViewBag.ProBroadcastPeriodicityList = new MultiSelectList(lstAcillaryBroadcastPeriodicity, "Sport_Ancillary_Periodicity_Code", "Name", "0");

            List<Sport_Ancillary_Broadcast> lstAncillaryBroadcast = objBroadcastService.SearchFor(b => b.Is_Active == "Y" && b.Sport_Ancillary_Config.Any(c => c.Flag == "P")).ToList();
            ViewBag.ProBroadcastList = new MultiSelectList(lstAncillaryBroadcast, "Sport_Ancillary_Broadcast_Code", "Name");

            #endregion

        }

        public JsonResult GetSportAncProForEdit(int Acq_Deal_Sport_Ancillary_Code = 0)
        {
            Acq_Deal_Sport_Ancillary currentSportAncInstance = new Acq_Deal_Sport_Ancillary();
            var sportExistingAncillaryInstance = objADSAS.GetById(Acq_Deal_Sport_Ancillary_Code);
            currentSportAncInstance.Acq_Deal_Code = sportExistingAncillaryInstance.Acq_Deal_Code;
            currentSportAncInstance.Acq_Deal_Sport_Ancillary_Code = sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Code;
            currentSportAncInstance.Ancillary_For = sportExistingAncillaryInstance.Ancillary_For;
            if (sportExistingAncillaryInstance.Broadcast_Periodicity_Code != null)
                currentSportAncInstance.Broadcast_Periodicity_Code = sportExistingAncillaryInstance.Broadcast_Periodicity_Code;
            else
                currentSportAncInstance.Broadcast_Periodicity_Code = 0;
            currentSportAncInstance.Sport_Ancillary_Periodicity1 = new Sport_Ancillary_Periodicity();
            if (sportExistingAncillaryInstance.Sport_Ancillary_Periodicity1 != null)
                currentSportAncInstance.Sport_Ancillary_Periodicity1.Name = sportExistingAncillaryInstance.Sport_Ancillary_Periodicity1.Name;
            currentSportAncInstance.Broadcast_Window = sportExistingAncillaryInstance.Broadcast_Window;
            currentSportAncInstance.Duration = sportExistingAncillaryInstance.Duration;
            currentSportAncInstance.Obligation_Broadcast = sportExistingAncillaryInstance.Obligation_Broadcast;
            currentSportAncInstance.Remarks = sportExistingAncillaryInstance.Remarks;
            currentSportAncInstance.Sport_Ancillary_Periodicity_Code = sportExistingAncillaryInstance.Sport_Ancillary_Periodicity_Code;
            currentSportAncInstance.Sport_Ancillary_Periodicity = new Sport_Ancillary_Periodicity();
            if (sportExistingAncillaryInstance.Sport_Ancillary_Periodicity != null)
                currentSportAncInstance.Sport_Ancillary_Periodicity.Name = sportExistingAncillaryInstance.Sport_Ancillary_Periodicity.Name;
            currentSportAncInstance.Sport_Ancillary_Type_Code = sportExistingAncillaryInstance.Sport_Ancillary_Type_Code;
            currentSportAncInstance.Sport_Ancillary_Type = new Sport_Ancillary_Type();
            if (sportExistingAncillaryInstance.Sport_Ancillary_Type != null)
            currentSportAncInstance.Sport_Ancillary_Type.Name = sportExistingAncillaryInstance.Sport_Ancillary_Type.Name;
            sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.ToList().ForEach(b =>
            {
                Acq_Deal_Sport_Ancillary_Broadcast objBroadcast = new Acq_Deal_Sport_Ancillary_Broadcast();
                objBroadcast.Acq_Deal_Sport_Ancillary_Broadcast_Code = b.Acq_Deal_Sport_Ancillary_Broadcast_Code;
                objBroadcast.Acq_Deal_Sport_Ancillary_Code = b.Acq_Deal_Sport_Ancillary_Code;
                objBroadcast.Sport_Ancillary_Broadcast_Code = b.Sport_Ancillary_Broadcast_Code;
                objBroadcast.Sport_Ancillary_Broadcast = new Sport_Ancillary_Broadcast();
                objBroadcast.Sport_Ancillary_Broadcast.Name = b.Sport_Ancillary_Broadcast.Name;
                currentSportAncInstance.Acq_Deal_Sport_Ancillary_Broadcast.Add(objBroadcast);
            });
            sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.ToList().ForEach(s =>
            {
                Acq_Deal_Sport_Ancillary_Source objSource = new Acq_Deal_Sport_Ancillary_Source();
                objSource.Acq_Deal_Sport_Ancillary_Source_Code = s.Acq_Deal_Sport_Ancillary_Source_Code;
                objSource.Acq_Deal_Sport_Ancillary_Code = s.Acq_Deal_Sport_Ancillary_Code;
                objSource.Sport_Ancillary_Source_Code = s.Sport_Ancillary_Source_Code;
                objSource.Sport_Ancillary_Source = new Sport_Ancillary_Source();
                objSource.Sport_Ancillary_Source.Name = s.Sport_Ancillary_Source.Name;
                currentSportAncInstance.Acq_Deal_Sport_Ancillary_Source.Add(objSource);
            });
            sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.ToList().ForEach(t =>
            {
                Acq_Deal_Sport_Ancillary_Title objTitle = new Acq_Deal_Sport_Ancillary_Title();
                objTitle.Acq_Deal_Sport_Ancillary_Code = t.Acq_Deal_Sport_Ancillary_Code;
                objTitle.Acq_Deal_Sport_Ancillary_Title_Code = t.Acq_Deal_Sport_Ancillary_Title_Code;
                objTitle.Episode_From = t.Episode_From;
                objTitle.Episode_To = t.Episode_To;
                objTitle.Title_Code = t.Title_Code;
                objTitle.Title = new RightsU_Entities.Title();
                objTitle.Title.Title_Name = t.Title.Title_Name;
                currentSportAncInstance.Acq_Deal_Sport_Ancillary_Title.Add(objTitle);
            });

            return Json(currentSportAncInstance, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetSportAncProForView(int Acq_Deal_Sport_Ancillary_Code = 0)
        {
            var sportExistingAncillaryInstance = objADSAS.GetById(Acq_Deal_Sport_Ancillary_Code);
            return Json(sportExistingAncillaryInstance, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SavePrograming(string AnchillaryFor, string DisplayType = "G", int Acq_Deal_Sport_Ancillary_Code = 0, string Title = "", int Sport_Ancillary_Type_Code = 0, string Obligation_Broadcast = "", string ddlWhenToBroadcastPro = "", int Broadcast_Window = 0, int Broadcast_Periodicity_Code = 0, int Sport_Ancillary_Periodicity_Code = 0, string Duration = "", string ddlSourceOfContentPro = "", string Remarks = "")
        {
            try
            {
                dynamic resulSet;
                Acq_Deal_Sport_Ancillary sportExistingAncillaryInstance;
                if (Acq_Deal_Sport_Ancillary_Code > 0)
                    sportExistingAncillaryInstance = objADSAS.GetById(Acq_Deal_Sport_Ancillary_Code);
                else
                    sportExistingAncillaryInstance = new Acq_Deal_Sport_Ancillary();

                if (sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Count > 1 && DisplayType == "D" && sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Code > 0)
                {
                    Acq_Deal_Sport_Ancillary newSportAncillaryInstance = new Acq_Deal_Sport_Ancillary();
                    CreateProAncillaryObj(AnchillaryFor, Title, Sport_Ancillary_Type_Code, Obligation_Broadcast, ddlWhenToBroadcastPro, Broadcast_Window, Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code, Duration, ddlSourceOfContentPro, Remarks, newSportAncillaryInstance);

                    foreach (string Code in Title.Split(','))
                    {
                        int titleCode = Convert.ToInt32(Code);
                        sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Where(t => t.Title_Code == titleCode).SingleOrDefault().EntityState = State.Deleted;
                    }
                    newSportAncillaryInstance.EntityState = State.Added;
                    objADSAS.Save(newSportAncillaryInstance, out resulSet);
                }
                else
                    CreateProAncillaryObj(AnchillaryFor, Title, Sport_Ancillary_Type_Code, Obligation_Broadcast, ddlWhenToBroadcastPro, Broadcast_Window, Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code, Duration, ddlSourceOfContentPro, Remarks, sportExistingAncillaryInstance);

                string Message = string.Empty;
                if (sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Code > 0)
                {
                    sportExistingAncillaryInstance.EntityState = State.Modified;
                    Message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    sportExistingAncillaryInstance.EntityState = State.Added;
                    Message = objMessageKey.RecordAddedSuccessfully;
                }

                objADSAS.Save(sportExistingAncillaryInstance, out resulSet);
                objADSAS = null;
                Session["Acq_Deal_Sport_Ancillary_Service"] = null;
                return Json(Message);
            }
            catch
            {
                return Json("Error");
            }
        }

        private void CreateProAncillaryObj(string AnchillaryFor, string Title, int Sport_Ancillary_Type_Code, string Obligation_Broadcast, string ddlWhenToBroadcastPro, int Broadcast_Window, int Broadcast_Periodicity_Code, int Sport_Ancillary_Periodicity_Code, string Duration, string ddlSourceOfContentPro, string Remarks, Acq_Deal_Sport_Ancillary sportExistingAncillaryInstance)
        {
            sportExistingAncillaryInstance.Ancillary_For = AnchillaryFor;
            sportExistingAncillaryInstance.Acq_Deal_Code = objAcq_Deal.Acq_Deal_Code;

            #region ========= Title object creation =========
            ICollection<Acq_Deal_Sport_Ancillary_Title> selectTitleList = new HashSet<Acq_Deal_Sport_Ancillary_Title>();


            foreach (string titleCode in Title.Split(','))
            {
                Acq_Deal_Sport_Ancillary_Title sportAncillaryTitleInstance = new Acq_Deal_Sport_Ancillary_Title();
                sportAncillaryTitleInstance.Episode_From = 1;
                sportAncillaryTitleInstance.Episode_To = 1;
                sportAncillaryTitleInstance.Title_Code = Convert.ToInt32(titleCode);
                selectTitleList.Add(sportAncillaryTitleInstance);
            }



            IEqualityComparer<Acq_Deal_Sport_Ancillary_Title> comparerT = null;
            if (objDeal_Schema.Deal_Type_Code == GlobalParams.Deal_Type_Content)
                comparerT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);
            else
                comparerT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Ancillary_Title = new List<Acq_Deal_Sport_Ancillary_Title>();
            var Added_Acq_Deal_Sport_Ancillary_Title = CompareLists<Acq_Deal_Sport_Ancillary_Title>(selectTitleList.ToList<Acq_Deal_Sport_Ancillary_Title>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>(), comparerT, ref Deleted_Acq_Deal_Sport_Ancillary_Title);
            Added_Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Add(t));
            Deleted_Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Ancillary_Title titleInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Where(t => t.EntityState != State.Deleted))
            {
                if (titleInstance.Acq_Deal_Sport_Ancillary_Title_Code > 0)
                    titleInstance.EntityState = State.Modified;
                else
                    titleInstance.EntityState = State.Added;
            }
            #endregion

            if (Sport_Ancillary_Type_Code != 0)
                sportExistingAncillaryInstance.Sport_Ancillary_Type_Code = Convert.ToInt32(Sport_Ancillary_Type_Code);

            sportExistingAncillaryInstance.Obligation_Broadcast = Obligation_Broadcast;

            #region ========= Broadcast object creation =========

            ICollection<Acq_Deal_Sport_Ancillary_Broadcast> selectBroadcastList = new HashSet<Acq_Deal_Sport_Ancillary_Broadcast>();

            if (!string.IsNullOrEmpty(ddlWhenToBroadcastPro))
                foreach (string broadCastCode in ddlWhenToBroadcastPro.Split(','))
                {
                    Acq_Deal_Sport_Ancillary_Broadcast sportAncillaryBroadcastInstance = new Acq_Deal_Sport_Ancillary_Broadcast();
                    sportAncillaryBroadcastInstance.Sport_Ancillary_Broadcast_Code = Convert.ToInt32(broadCastCode); ;
                    sportAncillaryBroadcastInstance.EntityState = State.Added;
                    selectBroadcastList.Add(sportAncillaryBroadcastInstance);
                }

            IEqualityComparer<Acq_Deal_Sport_Ancillary_Broadcast> comparerBT = null;
            comparerBT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Broadcast>((x, y) => x.Sport_Ancillary_Broadcast_Code == y.Sport_Ancillary_Broadcast_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Ancillary_Broadcast = new List<Acq_Deal_Sport_Ancillary_Broadcast>();
            var Added_Acq_Deal_Sport_Ancillary_Broadcast = CompareLists<Acq_Deal_Sport_Ancillary_Broadcast>(selectBroadcastList.ToList<Acq_Deal_Sport_Ancillary_Broadcast>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>(), comparerBT, ref Deleted_Acq_Deal_Sport_Ancillary_Broadcast);
            Added_Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Add(t));
            Deleted_Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Ancillary_Broadcast broadcastInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Where(t => t.EntityState != State.Deleted))
            {
                if (broadcastInstance.Acq_Deal_Sport_Ancillary_Broadcast_Code > 0)
                    broadcastInstance.EntityState = State.Modified;
                else
                    broadcastInstance.EntityState = State.Added;
            }
            #endregion

            if (Broadcast_Periodicity_Code != 0)
            {
                sportExistingAncillaryInstance.Broadcast_Window = Broadcast_Window;
                sportExistingAncillaryInstance.Broadcast_Periodicity_Code = Broadcast_Periodicity_Code;
            }
            else
            {
                sportExistingAncillaryInstance.Broadcast_Window = null;
                sportExistingAncillaryInstance.Broadcast_Periodicity_Code = null;
            }

            if (Sport_Ancillary_Periodicity_Code != 0)
                sportExistingAncillaryInstance.Sport_Ancillary_Periodicity_Code = Sport_Ancillary_Periodicity_Code;

            if (Duration != string.Empty)
                sportExistingAncillaryInstance.Duration = Convert.ToDateTime(Duration).TimeOfDay;
            else
                sportExistingAncillaryInstance.Duration = null;

            #region ========= Source object creation =========

            ICollection<Acq_Deal_Sport_Ancillary_Source> selectSourceList = new HashSet<Acq_Deal_Sport_Ancillary_Source>();


            foreach (string sourceCode in ddlSourceOfContentPro.Split(','))
            {
                Acq_Deal_Sport_Ancillary_Source sportAncillarySourceInstance = new Acq_Deal_Sport_Ancillary_Source();
                sportAncillarySourceInstance.Sport_Ancillary_Source_Code = Convert.ToInt32(sourceCode); ;
                sportAncillarySourceInstance.EntityState = State.Added;
                selectSourceList.Add(sportAncillarySourceInstance);
            }

            IEqualityComparer<Acq_Deal_Sport_Ancillary_Source> comparerST = null;
            comparerST = new LambdaComparer<Acq_Deal_Sport_Ancillary_Source>((x, y) => x.Sport_Ancillary_Source_Code == y.Sport_Ancillary_Source_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Ancillary_Source = new List<Acq_Deal_Sport_Ancillary_Source>();
            var Added_Acq_Deal_Sport_Ancillary_Source = CompareLists<Acq_Deal_Sport_Ancillary_Source>(selectSourceList.ToList<Acq_Deal_Sport_Ancillary_Source>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>(), comparerST, ref Deleted_Acq_Deal_Sport_Ancillary_Source);
            Added_Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Add(t));
            Deleted_Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Ancillary_Source sourceInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Where(t => t.EntityState != State.Deleted))
            {
                if (sourceInstance.Acq_Deal_Sport_Ancillary_Source_Code > 0)
                    sourceInstance.EntityState = State.Modified;
                else
                    sourceInstance.EntityState = State.Added;
            }
            #endregion

            sportExistingAncillaryInstance.Remarks = Remarks;
        }

        #endregion

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult) where T : class
        {

            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);

            DelResult = DeleteResult.ToList<T>();

            return AddResult.ToList<T>();
        }

        public JsonResult ValidateDuplicate(string AnchillaryFor, int Acq_Deal_Sport_Ancillary_Code = 0, string Title = "", string Sport_Ancillary_Type_Code = "", string DisplayType = "", string DetailsTitleCode = "")
        {
            string Message = "Success";
            List<int> lstTitleCodes = new List<int>();
            List<int> lstSourceCode = new List<int>();
            int ancillaryTypeCode = 0;
            foreach (string titleCode in Title.Split(','))
            {
                lstTitleCodes.Add(Convert.ToInt32(titleCode));
            }
            ancillaryTypeCode = Convert.ToInt32(Sport_Ancillary_Type_Code);
           // objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);

            List<Acq_Deal_Sport_Ancillary> lstAcq_Deal_Sport_Ancillary = objADSAS.SearchFor(s => s.Acq_Deal_Code == objDeal_Schema.Deal_Code).ToList();

            if (AnchillaryFor == "P")
            {
                if (Acq_Deal_Sport_Ancillary_Code > 0 && DisplayType != "D")
                {

                    if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "P" && a.Acq_Deal_Sport_Ancillary_Code != Acq_Deal_Sport_Ancillary_Code).Count() > 0) //&& a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                        Message = objMessageKey.SportAncillaryProgrammingWithselectedTitleandTypealreadyexists;

                }
                else
                {
                    if (DisplayType != "D")
                    {
                        if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "P").Count() > 0) //&& a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                            Message = objMessageKey.SportAncillaryProgrammingWithselectedTitleandTypealreadyexists;
                    }
                    else
                    {
                        if (!string.IsNullOrEmpty(DetailsTitleCode))
                        {
                            if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Where(t => t.Title_Code != Convert.ToInt32(DetailsTitleCode)).Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "P").Count() > 0) //&& a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                Message = objMessageKey.SportAncillaryProgrammingWithselectedTitleandTypealreadyexists;
                        }
                        else
                        {
                            if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "P").Count() > 0) //&& a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                Message = objMessageKey.SportAncillaryProgrammingWithselectedTitleandTypealreadyexists;
                        }
                    }
                }
            }
            else
                if (AnchillaryFor == "M")
                {
                    if (Acq_Deal_Sport_Ancillary_Code > 0 && DisplayType != "D")
                    {
                        if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "M" && a.Acq_Deal_Sport_Ancillary_Code != Acq_Deal_Sport_Ancillary_Code).Count() > 0) //&& a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                            Message = objMessageKey.SportAncillaryMarketingWithselectedTitleandTypealreadyexists;
                    }
                    else
                    {
                        if (DisplayType != "D")
                        {
                            if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "M").Count() > 0)// && a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                Message = objMessageKey.SportAncillaryMarketingWithselectedTitleandTypealreadyexists;
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(DetailsTitleCode))
                            {
                                if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Where(t => t.Title_Code != Convert.ToInt32(DetailsTitleCode)).Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "M").Count() > 0)// && a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                    Message = objMessageKey.SportAncillaryMarketingWithselectedTitleandTypealreadyexists;
                            }
                            else
                            {
                                if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "M").Count() > 0)// && a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                    Message = objMessageKey.SportAncillaryMarketingWithselectedTitleandTypealreadyexists;
                            }
                        }
                    }
                }
                else
                    if (AnchillaryFor == "F")
                    {
                        if (Acq_Deal_Sport_Ancillary_Code > 0 && DisplayType != "D")
                        {
                            if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "F" && a.Acq_Deal_Sport_Ancillary_Code != Acq_Deal_Sport_Ancillary_Code).Count() > 0) //&& a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                Message = objMessageKey.SportAncillaryFCTWithselectedTitleandTypealreadyexists;
                        }
                        else
                        {
                            if (DisplayType != "D")
                            {
                                if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "F").Count() > 0)// && a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                    Message = objMessageKey.SportAncillaryFCTWithselectedTitleandTypealreadyexists;
                            }
                            else
                            {
                                if (!string.IsNullOrEmpty(DetailsTitleCode))
                                {
                                    if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Where(t => t.Title_Code != Convert.ToInt32(DetailsTitleCode)).Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "F").Count() > 0)// && a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                        Message = objMessageKey.SportAncillaryFCTWithselectedTitleandTypealreadyexists;
                                }
                                else
                                {
                                    if (lstAcq_Deal_Sport_Ancillary.Where(a => a.Sport_Ancillary_Type_Code == ancillaryTypeCode && a.Acq_Deal_Sport_Ancillary_Title.Any(t => lstTitleCodes.Contains(t.Title_Code.Value)) && a.Ancillary_For == "F").Count() > 0)// && a.Acq_Deal_Sport_Ancillary_Source.Any(s => lstSourceCode.Contains(s.Sport_Ancillary_Source_Code.Value))
                                        Message = objMessageKey.SportAncillaryFCTWithselectedTitleandTypealreadyexists;
                                }
                            }
                        }
                    }
            objADS = null;
            return Json(Message);
        }

        public string DeleteSportAncillary(int id, int titleCode, string DisplayType)
        {
            string Message = "Success";
            try
            {
                sportAncillaryInstance = objADSAS.GetById(id);
                if (DisplayType == "G")
                {
                    sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.ToList().ForEach(b => b.EntityState = State.Deleted);
                    sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.ToList().ForEach(s => s.EntityState = State.Deleted);
                    sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.ToList().ForEach(t => t.EntityState = State.Deleted);
                    sportAncillaryInstance.EntityState = State.Deleted;
                }
                else
                {
                    if (sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Count > 1)
                    {
                        sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Remove(sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Where(t => t.Title_Code.Value == titleCode).SingleOrDefault());
                        sportAncillaryInstance.EntityState = State.Modified;
                    }
                    else
                    {
                        sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.ToList().ForEach(b => b.EntityState = State.Deleted);
                        sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.ToList().ForEach(s => s.EntityState = State.Deleted);
                        sportAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.ToList().ForEach(t => t.EntityState = State.Deleted);
                        sportAncillaryInstance.EntityState = State.Deleted;
                    }
                }
                dynamic resultSet;
                objADSAS.Save(sportAncillaryInstance, out resultSet);
                objADSAS = null;
            }
            catch
            {
                Message = "Error";
            }
            return Message;
        }



        #region ========= Marketing =========

        public PartialViewResult BindMarketing(string displayType = "G", string selectedTitle = "")
        {
            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            ViewBag.DisplayMrktTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name");

            selectedDisplayProTitle = new List<int>();
            if (selectedTitle != string.Empty)
                foreach (string titleCode in selectedTitle.Split(','))
                {
                    selectedDisplayProTitle.Add(Convert.ToInt32(titleCode));
                }
            List<Acq_Deal_Sport_Ancillary> lstSportAncillary = objADSAS.SearchFor(s => s.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code && s.Ancillary_For == "M").ToList();
            ViewBag.PageMode = objDeal_Schema.Mode;
            if (displayType == "G")
            {
                var q = from sportAnc in lstSportAncillary
                        where sportAnc.Acq_Deal_Sport_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Count() > 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Ancillary_Code = sportAnc.Acq_Deal_Sport_Ancillary_Code,
                            Title = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Select(t => t.Title.Title_Name)),
                            TitleCode = "0",
                            Type = sportAnc.Sport_Ancillary_Type.Name,
                            Obligation_Broadcast = (sportAnc.Obligation_Broadcast == "Y") ? "Yes" : "No",
                            Obligation = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Select(b => b.Sport_Ancillary_Broadcast.Name)) + ((sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Count > 0 && sportAnc.Sport_Ancillary_Periodicity1 != null) ? "-" : "") + ((sportAnc.Sport_Ancillary_Periodicity1 != null) ? sportAnc.Broadcast_Window.ToString() + " " + sportAnc.Sport_Ancillary_Periodicity1.Name : ""),
                            Duration = ((sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : "") +
                            (
                            (
                            (
                            (
                            (sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : ""
                            ) != ""
                            ) && (sportAnc.Duration != null || sportAnc.No_Of_Promos != null)) ? "-" : "") + ((sportAnc.Duration != null) ? getHourMinutesSeconds(sportAnc.Duration) + " " : "") + ((sportAnc.Duration != null && sportAnc.No_Of_Promos != null) ? "-" : "") + ((sportAnc.No_Of_Promos != null) ? sportAnc.No_Of_Promos + " spots" : ""),
                            Source = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Source.Select(s => s.Sport_Ancillary_Source.Name)),
                            Time_Slot = ((sportAnc.Prime_Start_Time != null) ? "Prime :" + getAMPMTime(sportAnc.Prime_Start_Time) + "-" + getAMPMTime(sportAnc.Prime_End_Time) + ((sportAnc.Prime_No_of_Promos != null) ? "-" + sportAnc.Prime_No_of_Promos + " spots" : "") + ((sportAnc.Prime_Durartion != null) ? "-" + getHourMinutesSeconds(sportAnc.Prime_Durartion) : "") : "") + ((sportAnc.Prime_Start_Time == null || sportAnc.Off_Prime_Start_Time == null) ? "" : ", ") +
                            ((sportAnc.Off_Prime_Start_Time != null) ? "Off Prime :" + getAMPMTime(sportAnc.Off_Prime_Start_Time) + "-" + getAMPMTime(sportAnc.Off_Prime_End_Time) + ((sportAnc.Off_Prime_No_of_Promos != null) ? "-" + sportAnc.Off_Prime_No_of_Promos + " spots" : "") + ((sportAnc.Off_Prime_Durartion != null) ? "-" + getHourMinutesSeconds(sportAnc.Off_Prime_Durartion) : "") : ""),
                            Remarks = sportAnc.Remarks
                        };
                return PartialView("~/Views/Acq_Deal/_Marketing.cshtml", q);
            }
            else
            {
                var v = from sportAnc in lstSportAncillary
                        from sportAncTitle in sportAnc.Acq_Deal_Sport_Ancillary_Title
                        where selectedDisplayProTitle.Contains(sportAncTitle.Title_Code.Value) || selectedDisplayProTitle.Count == 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Ancillary_Code = sportAnc.Acq_Deal_Sport_Ancillary_Code,
                            Title = (sportAncTitle.Title_Code != null) ? sportAncTitle.Title.Title_Name : "",
                            TitleCode = ((sportAncTitle != null) ? ((sportAncTitle.Title_Code != null) ? sportAncTitle.Title_Code.ToString() : "") : ""),
                            Type = sportAnc.Sport_Ancillary_Type.Name,
                            Obligation_Broadcast = (sportAnc.Obligation_Broadcast == "Y") ? "Yes" : "No",
                            Obligation = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Select(b => b.Sport_Ancillary_Broadcast.Name)) + ((sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Count > 0 && sportAnc.Sport_Ancillary_Periodicity1 != null) ? "-" : "") + ((sportAnc.Sport_Ancillary_Periodicity1 != null) ? sportAnc.Broadcast_Window.ToString() + " " + sportAnc.Sport_Ancillary_Periodicity1.Name : ""),
                            Duration = ((sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : "") +
                            (
                            (
                            (
                            (
                            (sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : ""
                            ) != ""
                            ) && (sportAnc.Duration != null || sportAnc.No_Of_Promos != null)) ? "-" : "") + ((sportAnc.Duration != null) ? getHourMinutesSeconds(sportAnc.Duration) + " " : "") + ((sportAnc.Duration != null && sportAnc.No_Of_Promos != null) ? "-" : "") + ((sportAnc.No_Of_Promos != null) ? sportAnc.No_Of_Promos + " spots" : ""),
                            //Duration = ((sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : "") + (((((sportAnc.Sport_Ancillary_Periodicity_Code != null) ? sportAnc.Sport_Ancillary_Periodicity.Name : "") != "") && (sportAnc.Duration != null || sportAnc.No_Of_Promos != null)) ? "-" : "") + ((sportAnc.Duration != null) ? getHourMinutesSeconds(sportAnc.Duration) : " ") + ((sportAnc.No_Of_Promos != null) ? sportAnc.No_Of_Promos + " spots" : ""),
                            Source = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Source.Select(s => s.Sport_Ancillary_Source.Name)),
                            Time_Slot = ((sportAnc.Prime_Start_Time != null) ? "Prime :" + getAMPMTime(sportAnc.Prime_Start_Time) + "-" + getAMPMTime(sportAnc.Prime_End_Time) + ((sportAnc.Prime_No_of_Promos != null) ? "-" + sportAnc.Prime_No_of_Promos + " spots" : "") + ((sportAnc.Prime_Durartion != null) ? "-" + getHourMinutesSeconds(sportAnc.Prime_Durartion) : "") : "") + ((sportAnc.Prime_Start_Time == null || sportAnc.Off_Prime_Start_Time == null) ? "" : ", ") +
                            ((sportAnc.Off_Prime_Start_Time != null) ? "Off Prime :" + getAMPMTime(sportAnc.Off_Prime_Start_Time) + "-" + getAMPMTime(sportAnc.Off_Prime_End_Time) + ((sportAnc.Off_Prime_No_of_Promos != null) ? "-" + sportAnc.Off_Prime_No_of_Promos + " spots" : "") + ((sportAnc.Off_Prime_Durartion != null) ? "-" + getHourMinutesSeconds(sportAnc.Off_Prime_Durartion) : "") : ""),
                            Remarks = sportAnc.Remarks
                        };
                return PartialView("~/Views/Acq_Deal/_Marketing.cshtml", v);
            }
        }

        public string getHourMinutesSeconds(Nullable<TimeSpan> t)
        {
            string strFor = string.Empty;
            if (t != null)
            {
                if (t.Value.Hours != 0)
                    strFor += t.Value.Hours + " Hour(s) ";

                if (t.Value.Minutes != 0)
                    strFor += t.Value.Minutes + " Minute(s) ";

                if (t.Value.Seconds != 0)
                    strFor += t.Value.Seconds + " Second(s) ";
            }
            return strFor;
        }

        public string getAMPMTime(Nullable<TimeSpan> t)
        {
            if (t != null)
                return DateTime.Today.Add(t.Value).ToString("hh:mm tt");
            return string.Empty;
        }

        private void BindMrktDropDown(Acq_Deal_Sport_Ancillary acqDealSportAncillaryInstance, string TitleCode, string DisplayType)
        {

            Sport_Ancillary_Type_Service objTypeService = new Sport_Ancillary_Type_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Source_Service objSourceService = new Sport_Ancillary_Source_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Periodicity_Service objPeriodicityService = new Sport_Ancillary_Periodicity_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Broadcast_Service objBroadcastService = new Sport_Ancillary_Broadcast_Service(objLoginEntity.ConnectionStringName);
            string[] selectedTitles = acqDealSportAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Select(t => t.Title_Code.ToString()).ToArray();
            string[] selectedTypes = Convert.ToString(acqDealSportAncillaryInstance.Sport_Ancillary_Type_Code).Split(',');
            string[] selectedSource = acqDealSportAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Select(t => t.Sport_Ancillary_Source_Code.ToString()).ToArray();
            string[] selectedBroadcast = acqDealSportAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Select(t => t.Sport_Ancillary_Broadcast_Code.ToString()).ToArray();
            string[] selectedPeriodicity = Convert.ToString(acqDealSportAncillaryInstance.Sport_Ancillary_Periodicity_Code).Split(',');


            #region Bind Programming Dropdown
            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);

            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            if (DisplayType == "G")
                ViewBag.MrktTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", selectedTitles);
            else
                ViewBag.MrktTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", TitleCode.Split(','));

            List<Sport_Ancillary_Type> lstAncillaryType = objTypeService.SearchFor(t => t.Is_Active == "Y" && t.Sport_Ancillary_Config.Any(c => c.Flag == "M")).ToList();
            lstAncillaryType.Insert(0, new Sport_Ancillary_Type { Sport_Ancillary_Type_Code = 0, Name = objMessageKey.PleaseSelect });
            ViewBag.MrktTypeList = new MultiSelectList(lstAncillaryType, "Sport_Ancillary_Type_Code", "Name", selectedTypes);

            List<Sport_Ancillary_Source> lstAncillarySource = objSourceService.SearchFor(s => s.Is_Active == "Y" && s.Sport_Ancillary_Config.Any(c => c.Flag == "M")).ToList();
            ViewBag.MrktSourceList = new MultiSelectList(lstAncillarySource, "Sport_Ancillary_Source_Code", "Name", selectedSource);

            List<Sport_Ancillary_Periodicity> lstAcillaryPeriodicity = objPeriodicityService.SearchFor(p => p.Is_Active == "Y" && p.Sport_Ancillary_Config.Any(c => c.Flag == "M")).OrderBy(p => p.Order_By).ToList();
            ViewBag.MrktPeriodicityList = new MultiSelectList(lstAcillaryPeriodicity, "Sport_Ancillary_Periodicity_Code", "Name", selectedPeriodicity);

            List<Sport_Ancillary_Periodicity> lstAcillaryBroadcastPeriodicity = objPeriodicityService.SearchFor(p => p.Is_Active == "Y" && p.Sport_Ancillary_Config.Any(c => c.Flag == "W")).OrderBy(p => p.Order_By).ToList();
            lstAcillaryBroadcastPeriodicity.Insert(0, new Sport_Ancillary_Periodicity { Sport_Ancillary_Periodicity_Code = 0, Name = "N.A." });
            ViewBag.MrktBroadcastPeriodicityList = new MultiSelectList(lstAcillaryBroadcastPeriodicity, "Sport_Ancillary_Periodicity_Code", "Name", "0");

            List<Sport_Ancillary_Broadcast> lstAncillaryBroadcast = objBroadcastService.SearchFor(b => b.Is_Active == "Y" && b.Sport_Ancillary_Config.Any(c => c.Flag == "M")).ToList();
            ViewBag.MrktBroadcastList = new MultiSelectList(lstAncillaryBroadcast, "Sport_Ancillary_Broadcast_Code", "Name", selectedBroadcast);

            #endregion
        }

        public PartialViewResult CreateMarketing(int Acq_Deal_Sport_Ancillary_Code = 0, string TitleCode = "", string DisplayType = "")
        {

            Acq_Deal_Sport_Ancillary acqDealSportAncillaryInstance;

            if (Acq_Deal_Sport_Ancillary_Code > 0)
                acqDealSportAncillaryInstance = objADSAS.GetById(Acq_Deal_Sport_Ancillary_Code);
            else
            {
                acqDealSportAncillaryInstance = new Acq_Deal_Sport_Ancillary();
                acqDealSportAncillaryInstance.Ancillary_For = "M";
            }
            BindMrktDropDown(acqDealSportAncillaryInstance, TitleCode, DisplayType);
            ViewBag.DisplayType = DisplayType;
            ViewBag.Mode = objDeal_Schema.Mode;
            ViewBag.DetailTitleCode = TitleCode;
            return PartialView("~/Views/Acq_Deal/_Popup_Programing.cshtml", acqDealSportAncillaryInstance);
        }

        public JsonResult SaveMarketing(Acq_Deal_Sport_Ancillary objAcq_Deal_Sport_Ancillary, string[] ddlTitleMarketing, string[] ddlWhenToBroadcastMrkt, string[] ddlSourceOfContentMrkt, string DisplayType, string Prime_Start_Time = "", string Prime_End_Time = "", string Prime_Durartion = "", string Off_Prime_Start_Time = "", string Off_Prime_End_Time = "", string Off_Prime_Durartion = "")
        {
            try
            {
                dynamic resulSet;
                Acq_Deal_Sport_Ancillary sportExistingAncillaryInstance;
                if (objAcq_Deal_Sport_Ancillary.Acq_Deal_Sport_Ancillary_Code > 0)
                    sportExistingAncillaryInstance = objADSAS.GetById(objAcq_Deal_Sport_Ancillary.Acq_Deal_Sport_Ancillary_Code);
                else
                    sportExistingAncillaryInstance = new Acq_Deal_Sport_Ancillary();
                if (sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Count > 1 && DisplayType == "D" && sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Code > 0)
                {
                    Acq_Deal_Sport_Ancillary newSportAncillaryInstance = new Acq_Deal_Sport_Ancillary();
                    CreateMrktAncillaryObj(objAcq_Deal_Sport_Ancillary, ddlTitleMarketing, ddlWhenToBroadcastMrkt, ddlSourceOfContentMrkt, Prime_Start_Time, Prime_End_Time, Prime_Durartion, Off_Prime_Start_Time, Off_Prime_End_Time, Off_Prime_Durartion, newSportAncillaryInstance);

                    foreach (string Code in ddlTitleMarketing)
                    {
                        int titleCode = Convert.ToInt32(Code);
                        sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Remove(sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Where(t => t.Title_Code == titleCode).SingleOrDefault());
                    }
                    newSportAncillaryInstance.EntityState = State.Added;
                    objADSAS.Save(newSportAncillaryInstance, out resulSet);
                }
                else
                    CreateMrktAncillaryObj(objAcq_Deal_Sport_Ancillary, ddlTitleMarketing, ddlWhenToBroadcastMrkt, ddlSourceOfContentMrkt, Prime_Start_Time, Prime_End_Time, Prime_Durartion, Off_Prime_Start_Time, Off_Prime_End_Time, Off_Prime_Durartion, sportExistingAncillaryInstance);

                string Message = string.Empty;
                if (sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Code > 0)
                {
                    sportExistingAncillaryInstance.EntityState = State.Modified;
                    Message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    sportExistingAncillaryInstance.EntityState = State.Added;
                    Message = objMessageKey.RecordAddedSuccessfully;
                }


                objADSAS.Save(sportExistingAncillaryInstance, out resulSet);
                objADSAS = null;
                Session["Acq_Deal_Sport_Ancillary_Service"] = null;
                return Json(Message);
            }
            catch
            {
                return Json("Error");
            }
            //return View("Index");
        }

        private void CreateMrktAncillaryObj(Acq_Deal_Sport_Ancillary objAcq_Deal_Sport_Ancillary, string[] ddlTitleMarketing, string[] ddlWhenToBroadcastMrkt, string[] ddlSourceOfContentMrkt, string Prime_Start_Time, string Prime_End_Time, string Prime_Durartion, string Off_Prime_Start_Time, string Off_Prime_End_Time, string Off_Prime_Durartion, Acq_Deal_Sport_Ancillary sportExistingAncillaryInstance)
        {
            sportExistingAncillaryInstance.Ancillary_For = objAcq_Deal_Sport_Ancillary.Ancillary_For;
            sportExistingAncillaryInstance.Acq_Deal_Code = objAcq_Deal.Acq_Deal_Code;

            #region ========= Title object creation =========
            ICollection<Acq_Deal_Sport_Ancillary_Title> selectTitleList = new HashSet<Acq_Deal_Sport_Ancillary_Title>();


            foreach (string titleCode in ddlTitleMarketing)
            {
                Acq_Deal_Sport_Ancillary_Title sportAncillaryTitleInstance = new Acq_Deal_Sport_Ancillary_Title();
                sportAncillaryTitleInstance.Episode_From = 1;
                sportAncillaryTitleInstance.Episode_To = 1;
                sportAncillaryTitleInstance.Title_Code = Convert.ToInt32(titleCode);
                selectTitleList.Add(sportAncillaryTitleInstance);
            }

            IEqualityComparer<Acq_Deal_Sport_Ancillary_Title> comparerT = null;
            if (objDeal_Schema.Deal_Type_Code == GlobalParams.Deal_Type_Content)
                comparerT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);
            else
                comparerT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Ancillary_Title = new List<Acq_Deal_Sport_Ancillary_Title>();
            var Added_Acq_Deal_Sport_Ancillary_Title = CompareLists<Acq_Deal_Sport_Ancillary_Title>(selectTitleList.ToList<Acq_Deal_Sport_Ancillary_Title>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>(), comparerT, ref Deleted_Acq_Deal_Sport_Ancillary_Title);
            Added_Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Add(t));
            Deleted_Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Ancillary_Title titleInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Where(t => t.EntityState != State.Deleted))
            {
                if (titleInstance.Acq_Deal_Sport_Ancillary_Title_Code > 0)
                    titleInstance.EntityState = State.Modified;
                else
                    titleInstance.EntityState = State.Added;
            }
            #endregion

            if (objAcq_Deal_Sport_Ancillary.Sport_Ancillary_Type_Code != 0)
                sportExistingAncillaryInstance.Sport_Ancillary_Type_Code = Convert.ToInt32(objAcq_Deal_Sport_Ancillary.Sport_Ancillary_Type_Code);

            sportExistingAncillaryInstance.Obligation_Broadcast = objAcq_Deal_Sport_Ancillary.Obligation_Broadcast;

            #region ========= Broadcast object creation =========

            ICollection<Acq_Deal_Sport_Ancillary_Broadcast> selectBroadcastList = new HashSet<Acq_Deal_Sport_Ancillary_Broadcast>();

            if (ddlWhenToBroadcastMrkt != null)
            {
                foreach (string broadCastCode in ddlWhenToBroadcastMrkt)
                {
                    Acq_Deal_Sport_Ancillary_Broadcast sportAncillaryBroadcastInstance = new Acq_Deal_Sport_Ancillary_Broadcast();
                    sportAncillaryBroadcastInstance.Sport_Ancillary_Broadcast_Code = Convert.ToInt32(broadCastCode); ;
                    sportAncillaryBroadcastInstance.EntityState = State.Added;
                    selectBroadcastList.Add(sportAncillaryBroadcastInstance);
                }

                IEqualityComparer<Acq_Deal_Sport_Ancillary_Broadcast> comparerBT = null;
                comparerBT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Broadcast>((x, y) => x.Sport_Ancillary_Broadcast_Code == y.Sport_Ancillary_Broadcast_Code && x.EntityState != State.Deleted);

                var Deleted_Acq_Deal_Sport_Ancillary_Broadcast = new List<Acq_Deal_Sport_Ancillary_Broadcast>();
                var Added_Acq_Deal_Sport_Ancillary_Broadcast = CompareLists<Acq_Deal_Sport_Ancillary_Broadcast>(selectBroadcastList.ToList<Acq_Deal_Sport_Ancillary_Broadcast>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>(), comparerBT, ref Deleted_Acq_Deal_Sport_Ancillary_Broadcast);
                Added_Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Add(t));
                Deleted_Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>().ForEach(t => t.EntityState = State.Deleted);

                foreach (Acq_Deal_Sport_Ancillary_Broadcast broadcastInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Where(t => t.EntityState != State.Deleted))
                {
                    if (broadcastInstance.Acq_Deal_Sport_Ancillary_Broadcast_Code > 0)
                        broadcastInstance.EntityState = State.Modified;
                    else
                        broadcastInstance.EntityState = State.Added;
                }
            }
            #endregion

            if (objAcq_Deal_Sport_Ancillary.Broadcast_Periodicity_Code != 0)
            {
                sportExistingAncillaryInstance.Broadcast_Window = objAcq_Deal_Sport_Ancillary.Broadcast_Window;
                sportExistingAncillaryInstance.Broadcast_Periodicity_Code = objAcq_Deal_Sport_Ancillary.Broadcast_Periodicity_Code;
            }
            else
            {
                sportExistingAncillaryInstance.Broadcast_Window = null;
                sportExistingAncillaryInstance.Broadcast_Periodicity_Code = null;
            }


            sportExistingAncillaryInstance.Sport_Ancillary_Periodicity_Code = objAcq_Deal_Sport_Ancillary.Sport_Ancillary_Periodicity_Code;

            if (objAcq_Deal_Sport_Ancillary.Duration != null)
                sportExistingAncillaryInstance.Duration = objAcq_Deal_Sport_Ancillary.Duration;
            else
                sportExistingAncillaryInstance.Duration = null;

            if (objAcq_Deal_Sport_Ancillary.No_Of_Promos != null)
                sportExistingAncillaryInstance.No_Of_Promos = objAcq_Deal_Sport_Ancillary.No_Of_Promos;
            else
                sportExistingAncillaryInstance.No_Of_Promos = null;


            if (Prime_Start_Time != string.Empty)
                sportExistingAncillaryInstance.Prime_Start_Time = Convert.ToDateTime(Prime_Start_Time).TimeOfDay;
            else
                sportExistingAncillaryInstance.Prime_Start_Time = null;

            if (Prime_End_Time != string.Empty)
                sportExistingAncillaryInstance.Prime_End_Time = Convert.ToDateTime(Prime_End_Time).TimeOfDay;
            else
                sportExistingAncillaryInstance.Prime_End_Time = null;

            if (objAcq_Deal_Sport_Ancillary.Prime_No_of_Promos != null)
                sportExistingAncillaryInstance.Prime_No_of_Promos = objAcq_Deal_Sport_Ancillary.Prime_No_of_Promos;
            else
                sportExistingAncillaryInstance.Prime_No_of_Promos = null;

            if (Prime_Durartion != string.Empty)
                sportExistingAncillaryInstance.Prime_Durartion = Convert.ToDateTime(Prime_Durartion).TimeOfDay;
            else
                sportExistingAncillaryInstance.Prime_Durartion = null;

            if (Off_Prime_Start_Time != string.Empty)
                sportExistingAncillaryInstance.Off_Prime_Start_Time = Convert.ToDateTime(Off_Prime_Start_Time).TimeOfDay;
            else
                sportExistingAncillaryInstance.Off_Prime_Start_Time = null;

            if (Off_Prime_End_Time != string.Empty)
                sportExistingAncillaryInstance.Off_Prime_End_Time = Convert.ToDateTime(Off_Prime_End_Time).TimeOfDay;
            else
                sportExistingAncillaryInstance.Off_Prime_End_Time = null;

            if (objAcq_Deal_Sport_Ancillary.Off_Prime_No_of_Promos != null)
                sportExistingAncillaryInstance.Off_Prime_No_of_Promos = objAcq_Deal_Sport_Ancillary.Off_Prime_No_of_Promos;
            else
                sportExistingAncillaryInstance.Off_Prime_No_of_Promos = null;

            if (Off_Prime_Durartion != string.Empty)
                sportExistingAncillaryInstance.Off_Prime_Durartion = Convert.ToDateTime(Off_Prime_Durartion).TimeOfDay;
            else
                sportExistingAncillaryInstance.Off_Prime_Durartion = null;

            #region ========= Source object creation =========

            ICollection<Acq_Deal_Sport_Ancillary_Source> selectSourceList = new HashSet<Acq_Deal_Sport_Ancillary_Source>();


            foreach (string sourceCode in ddlSourceOfContentMrkt)
            {
                Acq_Deal_Sport_Ancillary_Source sportAncillarySourceInstance = new Acq_Deal_Sport_Ancillary_Source();
                sportAncillarySourceInstance.Sport_Ancillary_Source_Code = Convert.ToInt32(sourceCode); ;
                sportAncillarySourceInstance.EntityState = State.Added;
                selectSourceList.Add(sportAncillarySourceInstance);
            }

            IEqualityComparer<Acq_Deal_Sport_Ancillary_Source> comparerST = null;
            comparerST = new LambdaComparer<Acq_Deal_Sport_Ancillary_Source>((x, y) => x.Sport_Ancillary_Source_Code == y.Sport_Ancillary_Source_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Ancillary_Source = new List<Acq_Deal_Sport_Ancillary_Source>();
            var Added_Acq_Deal_Sport_Ancillary_Source = CompareLists<Acq_Deal_Sport_Ancillary_Source>(selectSourceList.ToList<Acq_Deal_Sport_Ancillary_Source>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>(), comparerST, ref Deleted_Acq_Deal_Sport_Ancillary_Source);
            Added_Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Add(t));
            Deleted_Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Ancillary_Source sourceInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Where(t => t.EntityState != State.Deleted))
            {
                if (sourceInstance.Acq_Deal_Sport_Ancillary_Source_Code > 0)
                    sourceInstance.EntityState = State.Modified;
                else
                    sourceInstance.EntityState = State.Added;
            }
            #endregion

            sportExistingAncillaryInstance.Remarks = objAcq_Deal_Sport_Ancillary.Remarks;
        }

        #endregion

        #region ========= FCT Commitments =========

        private void BindFCTDropDown(Acq_Deal_Sport_Ancillary acqDealSportAncillaryInstance, string TitleCode, string DisplayType)
        {

            Sport_Ancillary_Type_Service objTypeService = new Sport_Ancillary_Type_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Source_Service objSourceService = new Sport_Ancillary_Source_Service(objLoginEntity.ConnectionStringName);
            Sport_Ancillary_Broadcast_Service objBroadcastService = new Sport_Ancillary_Broadcast_Service(objLoginEntity.ConnectionStringName);
            string[] selectedTitles = acqDealSportAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Select(t => t.Title_Code.ToString()).ToArray();
            string[] selectedTypes = Convert.ToString(acqDealSportAncillaryInstance.Sport_Ancillary_Type_Code).Split(',');
            string[] selectedSource = acqDealSportAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Select(t => t.Sport_Ancillary_Source_Code.ToString()).ToArray();
            string[] selectedBroadcast = acqDealSportAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Select(t => t.Sport_Ancillary_Broadcast_Code.ToString()).ToArray();


            #region Bind Programming Dropdown
            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);

            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            if (DisplayType == "G")
                ViewBag.FCTTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", selectedTitles);
            else
                ViewBag.FCTTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", TitleCode.Split(','));

            List<Sport_Ancillary_Type> lstAncillaryType = objTypeService.SearchFor(t => t.Is_Active == "Y" && t.Sport_Ancillary_Config.Any(c => c.Flag == "F")).ToList();
            lstAncillaryType.Insert(0, new Sport_Ancillary_Type { Sport_Ancillary_Type_Code = 0, Name = objMessageKey.PleaseSelect });
            ViewBag.FCTTypeList = new MultiSelectList(lstAncillaryType, "Sport_Ancillary_Type_Code", "Name", selectedTypes);

            List<Sport_Ancillary_Source> lstAncillarySource = objSourceService.SearchFor(s => s.Is_Active == "Y" && s.Sport_Ancillary_Config.Any(c => c.Flag == "F")).ToList();
            ViewBag.FCTSourceList = new MultiSelectList(lstAncillarySource, "Sport_Ancillary_Source_Code", "Name", selectedSource);

            List<Sport_Ancillary_Broadcast> lstAncillaryBroadcast = objBroadcastService.SearchFor(b => b.Is_Active == "Y" && b.Sport_Ancillary_Config.Any(c => c.Flag == "F")).ToList();
            ViewBag.FCTBroadcastList = new MultiSelectList(lstAncillaryBroadcast, "Sport_Ancillary_Broadcast_Code", "Name", selectedBroadcast);

            #endregion
        }

        public PartialViewResult BindFCT(string displayType = "G", string selectedTitle = "")
        {
            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            ViewBag.DisplayFCTTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name");

            selectedDisplayProTitle = new List<int>();
            if (selectedTitle != string.Empty)
                foreach (string titleCode in selectedTitle.Split(','))
                {
                    selectedDisplayProTitle.Add(Convert.ToInt32(titleCode));
                }
            List<Acq_Deal_Sport_Ancillary> lstSportAncillary = objADSAS.SearchFor(s => s.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code && s.Ancillary_For == "F").ToList();
            ViewBag.PageMode = objDeal_Schema.Mode;
            if (displayType == "G")
            {
                var q = from sportAnc in lstSportAncillary
                        where (sportAnc.Acq_Deal_Sport_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Count() > 0)
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Ancillary_Code = sportAnc.Acq_Deal_Sport_Ancillary_Code,
                            Title = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Select(b => b.Title.Title_Name)),
                            TitleCode = "0",
                            Type = sportAnc.Sport_Ancillary_Type.Name,
                            Duration = getSeconds(sportAnc.Duration),
                            Broadcast = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Select(b => b.Sport_Ancillary_Broadcast.Name)),
                            Source = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Source.Select(s => s.Sport_Ancillary_Source.Name))
                        };
                return PartialView("~/Views/Acq_Deal/_FCT_Commitments.cshtml", q);
            }
            else
            {
                var q = from sportAnc in lstSportAncillary
                        from sportAncTitle in sportAnc.Acq_Deal_Sport_Ancillary_Title
                        where selectedDisplayProTitle.Contains(sportAncTitle.Title_Code.Value) || selectedDisplayProTitle.Count == 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Ancillary_Code = sportAnc.Acq_Deal_Sport_Ancillary_Code,
                            Title = ((sportAncTitle != null) ? ((sportAncTitle.Title_Code != null) ? sportAncTitle.Title.Title_Name : "") : ""),
                            TitleCode = ((sportAncTitle != null) ? ((sportAncTitle.Title_Code != null) ? sportAncTitle.Title_Code.ToString() : "") : ""),
                            Type = sportAnc.Sport_Ancillary_Type.Name,
                            Duration = getSeconds(sportAnc.Duration),
                            Broadcast = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Broadcast.Select(b => b.Sport_Ancillary_Broadcast.Name)),
                            Source = string.Join(", ", sportAnc.Acq_Deal_Sport_Ancillary_Source.Select(s => s.Sport_Ancillary_Source.Name))
                        };
                return PartialView("~/Views/Acq_Deal/_FCT_Commitments.cshtml", q);
            }
        }

        public string getSeconds(Nullable<TimeSpan> t)
        {
            if (t != null)
                return t.Value.TotalSeconds.ToString() + " secs";
            return "";
        }

        public PartialViewResult CreateFCT(int Acq_Deal_Sport_Ancillary_Code = 0, string TitleCode = "", string DisplayType = "")
        {
            Acq_Deal_Sport_Ancillary acqDealSportAncillaryInstance;

            if (Acq_Deal_Sport_Ancillary_Code > 0)
                acqDealSportAncillaryInstance = objADSAS.GetById(Acq_Deal_Sport_Ancillary_Code);
            else
            {
                acqDealSportAncillaryInstance = new Acq_Deal_Sport_Ancillary();
                acqDealSportAncillaryInstance.Ancillary_For = "F";
            }
            BindFCTDropDown(acqDealSportAncillaryInstance, TitleCode, DisplayType);
            ViewBag.DisplayType = DisplayType;
            ViewBag.Mode = objDeal_Schema.Mode;
            ViewBag.DetailTitleCode = TitleCode;
            return PartialView("~/Views/Acq_Deal/_Popup_Programing.cshtml", acqDealSportAncillaryInstance);
        }

        public JsonResult SaveFCT(Acq_Deal_Sport_Ancillary objAcq_Deal_Sport_Ancillary, string txtDur, string[] ddlTitleFCT, string[] ddlWhenToBroadcastFCT, string[] ddlSourceOfContentFCT, string DisplayType)
        {
            try
            {
                dynamic resulSet;
                Acq_Deal_Sport_Ancillary sportExistingAncillaryInstance;
                if (objAcq_Deal_Sport_Ancillary.Acq_Deal_Sport_Ancillary_Code > 0)
                    sportExistingAncillaryInstance = objADSAS.GetById(objAcq_Deal_Sport_Ancillary.Acq_Deal_Sport_Ancillary_Code);
                else
                    sportExistingAncillaryInstance = new Acq_Deal_Sport_Ancillary();
                if (sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Count > 1 && DisplayType == "D" && sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Code > 0)
                {
                    Acq_Deal_Sport_Ancillary newSportAncillaryInstance = new Acq_Deal_Sport_Ancillary();
                    CreateFCTAnciObj(objAcq_Deal_Sport_Ancillary, txtDur, ddlTitleFCT, ddlWhenToBroadcastFCT, ddlSourceOfContentFCT, newSportAncillaryInstance);
                    foreach (string Code in ddlTitleFCT)
                    {
                        int titleCode = Convert.ToInt32(Code);
                        sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Remove(sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Where(t => t.Title_Code == titleCode).SingleOrDefault());
                    }
                    newSportAncillaryInstance.EntityState = State.Added;
                    objADSAS.Save(newSportAncillaryInstance, out resulSet);
                }
                else
                    CreateFCTAnciObj(objAcq_Deal_Sport_Ancillary, txtDur, ddlTitleFCT, ddlWhenToBroadcastFCT, ddlSourceOfContentFCT, sportExistingAncillaryInstance);

                string Message = string.Empty;
                if (sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Code > 0)
                {
                    sportExistingAncillaryInstance.EntityState = State.Modified;
                    Message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    sportExistingAncillaryInstance.EntityState = State.Added;
                    Message = objMessageKey.RecordAddedSuccessfully;
                }


                objADSAS.Save(sportExistingAncillaryInstance, out resulSet);
                objADSAS = null;
                Session["Acq_Deal_Sport_Ancillary_Service"] = null;
                return Json(Message);
            }
            catch
            {
                return Json("Error");
            }
        }

        private void CreateFCTAnciObj(Acq_Deal_Sport_Ancillary objAcq_Deal_Sport_Ancillary, string txtDur, string[] ddlTitleFCT, string[] ddlWhenToBroadcastFCT, string[] ddlSourceOfContentFCT, Acq_Deal_Sport_Ancillary sportExistingAncillaryInstance)
        {
            sportExistingAncillaryInstance.Ancillary_For = objAcq_Deal_Sport_Ancillary.Ancillary_For;
            sportExistingAncillaryInstance.Acq_Deal_Code = objAcq_Deal.Acq_Deal_Code;

            #region ========= Title object creation =========
            ICollection<Acq_Deal_Sport_Ancillary_Title> selectTitleList = new HashSet<Acq_Deal_Sport_Ancillary_Title>();


            foreach (string titleCode in ddlTitleFCT)
            {
                Acq_Deal_Sport_Ancillary_Title sportAncillaryTitleInstance = new Acq_Deal_Sport_Ancillary_Title();
                sportAncillaryTitleInstance.Episode_From = 1;
                sportAncillaryTitleInstance.Episode_To = 1;
                sportAncillaryTitleInstance.Title_Code = Convert.ToInt32(titleCode);
                selectTitleList.Add(sportAncillaryTitleInstance);
            }

            IEqualityComparer<Acq_Deal_Sport_Ancillary_Title> comparerT = null;
            if (objDeal_Schema.Deal_Type_Code == GlobalParams.Deal_Type_Content)
                comparerT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);
            else
                comparerT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Ancillary_Title = new List<Acq_Deal_Sport_Ancillary_Title>();
            var Added_Acq_Deal_Sport_Ancillary_Title = CompareLists<Acq_Deal_Sport_Ancillary_Title>(selectTitleList.ToList<Acq_Deal_Sport_Ancillary_Title>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>(), comparerT, ref Deleted_Acq_Deal_Sport_Ancillary_Title);
            Added_Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Add(t));
            Deleted_Acq_Deal_Sport_Ancillary_Title.ToList<Acq_Deal_Sport_Ancillary_Title>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Ancillary_Title titleInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Title.Where(t => t.EntityState != State.Deleted))
            {
                if (titleInstance.Acq_Deal_Sport_Ancillary_Title_Code > 0)
                    titleInstance.EntityState = State.Modified;
                else
                    titleInstance.EntityState = State.Added;
            }
            #endregion

            if (objAcq_Deal_Sport_Ancillary.Sport_Ancillary_Type_Code != 0)
                sportExistingAncillaryInstance.Sport_Ancillary_Type_Code = Convert.ToInt32(objAcq_Deal_Sport_Ancillary.Sport_Ancillary_Type_Code);

            #region ========= Broadcast object creation =========

            ICollection<Acq_Deal_Sport_Ancillary_Broadcast> selectBroadcastList = new HashSet<Acq_Deal_Sport_Ancillary_Broadcast>();

            if (ddlWhenToBroadcastFCT != null)
            {
                foreach (string broadCastCode in ddlWhenToBroadcastFCT)
                {
                    Acq_Deal_Sport_Ancillary_Broadcast sportAncillaryBroadcastInstance = new Acq_Deal_Sport_Ancillary_Broadcast();
                    sportAncillaryBroadcastInstance.Sport_Ancillary_Broadcast_Code = Convert.ToInt32(broadCastCode); ;
                    sportAncillaryBroadcastInstance.EntityState = State.Added;
                    selectBroadcastList.Add(sportAncillaryBroadcastInstance);
                }

                IEqualityComparer<Acq_Deal_Sport_Ancillary_Broadcast> comparerBT = null;
                comparerBT = new LambdaComparer<Acq_Deal_Sport_Ancillary_Broadcast>((x, y) => x.Sport_Ancillary_Broadcast_Code == y.Sport_Ancillary_Broadcast_Code && x.EntityState != State.Deleted);

                var Deleted_Acq_Deal_Sport_Ancillary_Broadcast = new List<Acq_Deal_Sport_Ancillary_Broadcast>();
                var Added_Acq_Deal_Sport_Ancillary_Broadcast = CompareLists<Acq_Deal_Sport_Ancillary_Broadcast>(selectBroadcastList.ToList<Acq_Deal_Sport_Ancillary_Broadcast>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>(), comparerBT, ref Deleted_Acq_Deal_Sport_Ancillary_Broadcast);
                Added_Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Add(t));
                Deleted_Acq_Deal_Sport_Ancillary_Broadcast.ToList<Acq_Deal_Sport_Ancillary_Broadcast>().ForEach(t => t.EntityState = State.Deleted);

                foreach (Acq_Deal_Sport_Ancillary_Broadcast broadcastInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Broadcast.Where(t => t.EntityState != State.Deleted))
                {
                    if (broadcastInstance.Acq_Deal_Sport_Ancillary_Broadcast_Code > 0)
                        broadcastInstance.EntityState = State.Modified;
                    else
                        broadcastInstance.EntityState = State.Added;
                }
            }
            #endregion

            if (!string.IsNullOrEmpty(txtDur))
                sportExistingAncillaryInstance.Duration = TimeSpan.FromSeconds(Convert.ToDouble(txtDur));
            else
                sportExistingAncillaryInstance.Duration = null;

            #region ========= Source object creation =========

            ICollection<Acq_Deal_Sport_Ancillary_Source> selectSourceList = new HashSet<Acq_Deal_Sport_Ancillary_Source>();


            foreach (string sourceCode in ddlSourceOfContentFCT)
            {
                if (sourceCode != "false")
                {
                    Acq_Deal_Sport_Ancillary_Source sportAncillarySourceInstance = new Acq_Deal_Sport_Ancillary_Source();
                    sportAncillarySourceInstance.Sport_Ancillary_Source_Code = Convert.ToInt32(sourceCode); ;
                    sportAncillarySourceInstance.EntityState = State.Added;
                    selectSourceList.Add(sportAncillarySourceInstance);
                }
            }

            IEqualityComparer<Acq_Deal_Sport_Ancillary_Source> comparerST = null;
            comparerST = new LambdaComparer<Acq_Deal_Sport_Ancillary_Source>((x, y) => x.Sport_Ancillary_Source_Code == y.Sport_Ancillary_Source_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Ancillary_Source = new List<Acq_Deal_Sport_Ancillary_Source>();
            var Added_Acq_Deal_Sport_Ancillary_Source = CompareLists<Acq_Deal_Sport_Ancillary_Source>(selectSourceList.ToList<Acq_Deal_Sport_Ancillary_Source>(), sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>(), comparerST, ref Deleted_Acq_Deal_Sport_Ancillary_Source);
            Added_Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>().ForEach(t => sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Add(t));
            Deleted_Acq_Deal_Sport_Ancillary_Source.ToList<Acq_Deal_Sport_Ancillary_Source>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Ancillary_Source sourceInstance in sportExistingAncillaryInstance.Acq_Deal_Sport_Ancillary_Source.Where(t => t.EntityState != State.Deleted))
            {
                if (sourceInstance.Acq_Deal_Sport_Ancillary_Source_Code > 0)
                    sourceInstance.EntityState = State.Modified;
                else
                    sourceInstance.EntityState = State.Added;
            }
            #endregion
        }

        #endregion

        #region ========= Sales =========

        public PartialViewResult BindSales(string displayType = "G", string selectedTitle = "")
        {
            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            ViewBag.DisplaySalesTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name");

            ViewBag.DisplayType = displayType;
            selectedDisplayProTitle = new List<int>();
            if (selectedTitle != string.Empty)
                foreach (string titleCode in selectedTitle.Split(','))
                {
                    selectedDisplayProTitle.Add(Convert.ToInt32(titleCode));
                }

            string[] str = { "T", "O" };
            List<Acq_Deal_Sport_Sales_Ancillary> lstSaleAncillary = objADSSaleAS.SearchFor(s => s.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).ToList();
            ViewBag.PageMode = objDeal_Schema.Mode;
            if (displayType == "G")
            {
                var q = from anc in lstSaleAncillary
                        from sponsor in str
                        where anc.Acq_Deal_Sport_Sales_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Count() > 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Sales_Ancillary_Code = anc.Acq_Deal_Sport_Sales_Ancillary_Code,
                            Title = string.Join(", ", anc.Acq_Deal_Sport_Sales_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Select(t => t.Title.Title_Name)),
                            TitleCode = "0",
                            Type_Of_Sponsor = (sponsor.ToString() == "T") ? "Title Sponsor" : "Official Sponsor",
                            Sponsor = string.Join(", ", anc.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == sponsor.ToString()).Select(s => s.Sponsor.Sponsor_Name)),
                            FRO_To_Given = (sponsor.ToString() == "T") ? ((
                            anc.FRO_Given_Title_Sponsor == "Y") ? ("Yes " + ((anc.Title_FRO_No_of_Days != null) ? "(No. of days before the Tournament-" + anc.Title_FRO_No_of_Days.ToString() + " days)" : "") + ((anc.Title_FRO_Validity != null) ? " (Validity of FRO-" + anc.Title_FRO_Validity.ToString() + " days)" : "")) : "No") :
                            ((anc.FRO_Given_Official_Sponsor == "Y") ? ("Yes " + ((anc.Official_FRO_No_of_Days != null) ? "(No. of days before the Tournament-" + anc.Official_FRO_No_of_Days.ToString() + " days)" : "") + ((anc.Official_FRO_Validity != null) ? " (Validity of FRO-" + anc.Official_FRO_Validity.ToString() + " days)" : "")) : "No"),
                            Price_Protection = (sponsor.ToString() == "T") ? ((anc.Price_Protection_Title_Sponsor == "Y") ? "Yes" : "No") : ((anc.Price_Protection_Official_Sponsor == "Y") ? "Yes" : "No"),
                            Last_Matching_Right = (sponsor.ToString() == "T") ? ((anc.Last_Matching_Rights_Title_Sponsor == "Y") ? ("Yes " + ((anc.Title_Last_Matching_Rights_Validity != null) ? " (Validity of Last Matching Right-" + anc.Title_Last_Matching_Rights_Validity.ToString() + " days)" : "")) : "No") : ((anc.Last_Matching_Rights_Official_Sponsor == "Y") ? ("Yes " + ((anc.Official_Last_Matching_Rights_Validity != null) ? " (Validity of Last Matching Right-" + anc.Official_Last_Matching_Rights_Validity.ToString() + " days)" : "")) : "No"),
                            Remarks = anc.Remarks
                        };
                return PartialView("~/Views/Acq_Deal/_Sales.cshtml", q);
            }
            else
            {
                var q = from anc in lstSaleAncillary
                        from saleAncTitle in anc.Acq_Deal_Sport_Sales_Ancillary_Title
                        from sponsor in str
                        where selectedDisplayProTitle.Contains(saleAncTitle.Title_Code.Value) || selectedDisplayProTitle.Count == 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Sales_Ancillary_Code = anc.Acq_Deal_Sport_Sales_Ancillary_Code,
                            Title = (saleAncTitle.Title_Code != null) ? saleAncTitle.Title.Title_Name : "",
                            TitleCode = ((saleAncTitle != null) ? ((saleAncTitle.Title_Code != null) ? saleAncTitle.Title_Code.ToString() : "") : ""),
                            Type_Of_Sponsor = (sponsor.ToString() == "T") ? "Title Sponsor" : "Official Sponsor",
                            Sponsor = string.Join(", ", anc.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == sponsor.ToString()).Select(s => s.Sponsor.Sponsor_Name)),
                            FRO_To_Given = (sponsor.ToString() == "T") ? ((
                            anc.FRO_Given_Title_Sponsor == "Y") ? ("Yes " + ((anc.Title_FRO_No_of_Days != null) ? "(No. of days before the Tournament-" + anc.Title_FRO_No_of_Days.ToString() + " days)" : "") + ((anc.Title_FRO_Validity != null) ? "(Validity of FRO-" + anc.Title_FRO_Validity.ToString() + " days)" : "")) : "No") :
                            ((anc.FRO_Given_Official_Sponsor == "Y") ? ("Yes " + ((anc.Official_FRO_No_of_Days != null) ? "(No. of days before the Tournament-" + anc.Official_FRO_No_of_Days.ToString() + " days)" : "") + ((anc.Official_FRO_Validity != null) ? "(Validity of FRO-" + anc.Official_FRO_Validity.ToString() + " days)" : "")) : "No"),
                            Price_Protection = (sponsor.ToString() == "T") ? ((anc.Price_Protection_Title_Sponsor == "Y") ? "Yes" : "No") : ((anc.Price_Protection_Official_Sponsor == "Y") ? "Yes" : "No"),
                            Last_Matching_Right = (sponsor.ToString() == "T") ? ((anc.Last_Matching_Rights_Title_Sponsor == "Y") ? ("Yes " + ((anc.Title_Last_Matching_Rights_Validity != null) ? "(Validity of Last Matching Right-" + anc.Title_Last_Matching_Rights_Validity.ToString() + " days)" : "")) : "No") : ((anc.Last_Matching_Rights_Official_Sponsor == "Y") ? ("Yes" + ((anc.Official_Last_Matching_Rights_Validity != null) ? "(Validity of Last Matching Right-" + anc.Official_Last_Matching_Rights_Validity.ToString() + " days)" : "")) : "No"),
                            Remarks = anc.Remarks
                        };
                return PartialView("~/Views/Acq_Deal/_Sales.cshtml", q);
            }
        }

        public JsonResult GetSponsorName()
        {
            Sponsor_Service objSponsorService = new Sponsor_Service(objLoginEntity.ConnectionStringName);
            return Json(objSponsorService.SearchFor(s => s.Is_Active == "Y").Select(s => s.Sponsor_Name).ToList());
        }

        private void BindSalesDropDown(Acq_Deal_Sport_Sales_Ancillary acqDealSportSaleAncillary, string TitleCode, string DisplayType)
        {
            string[] selectedTitles = acqDealSportSaleAncillary.Acq_Deal_Sport_Sales_Ancillary_Title.Select(t => t.Title_Code.ToString()).ToArray();

            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);

            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            if (DisplayType == "G")
                ViewBag.SalesTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", selectedTitles);
            else
                ViewBag.SalesTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", TitleCode.Split(','));
        }

        public PartialViewResult CreateSales(int Acq_Deal_Sport_Ancillary_Code = 0, string TitleCode = "", string DisplayType = "")
        {

            Acq_Deal_Sport_Sales_Ancillary acqDealSportSalesAncillaryInstance;

            if (Acq_Deal_Sport_Ancillary_Code > 0)
                acqDealSportSalesAncillaryInstance = new Acq_Deal_Sport_Sales_Ancillary_Service(objLoginEntity.ConnectionStringName).GetById(Acq_Deal_Sport_Ancillary_Code);
            else
                acqDealSportSalesAncillaryInstance = new Acq_Deal_Sport_Sales_Ancillary();

            if (acqDealSportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == "T").Count() > 0)
            {
                ViewBag.hdnSponsorId = acqDealSportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == "T").Count().ToString();
                ViewBag.hdnSponserlist = string.Join("~", acqDealSportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == "T").Select(s => s.Sponsor.Sponsor_Name));
            }
            else
            {
                ViewBag.hdnSponsorId = "1";
                ViewBag.hdnSponserlist = string.Empty;
            }

            if (acqDealSportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == "O").Count() > 0)
            {
                ViewBag.hdnOfficialId = acqDealSportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == "O").Count().ToString();
                ViewBag.hdnOfficiallist = string.Join("~", acqDealSportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(s => s.Sponsor_Type == "O").Select(s => s.Sponsor.Sponsor_Name));
            }
            else
            {
                ViewBag.hdnOfficialId = "1";
                ViewBag.hdnOfficiallist = string.Empty;
            }

            ViewBag.DisplayType = DisplayType;
            BindSalesDropDown(acqDealSportSalesAncillaryInstance, TitleCode, DisplayType);
            ViewBag.Mode = objDeal_Schema.Mode;
            ViewBag.DetailTitleCode = TitleCode;
            return PartialView("~/Views/Acq_Deal/_Popup_FCT.cshtml", acqDealSportSalesAncillaryInstance);
        }

        public JsonResult SaveSales(Acq_Deal_Sport_Sales_Ancillary objAcq_Deal_Sport_Sale_Ancillary, string[] lstSalesTitle, string hdnSponserlist, string hdnOfficiallist, string DisplayType)
        {
            try
            {
                dynamic resultSet;
                Acq_Deal_Sport_Sales_Ancillary_Service objADSSAS = new Acq_Deal_Sport_Sales_Ancillary_Service(objLoginEntity.ConnectionStringName);
                Acq_Deal_Sport_Sales_Ancillary sportExistingSalesAncillaryInstance;
                if (objAcq_Deal_Sport_Sale_Ancillary.Acq_Deal_Sport_Sales_Ancillary_Code > 0)
                    sportExistingSalesAncillaryInstance = objADSSAS.GetById(objAcq_Deal_Sport_Sale_Ancillary.Acq_Deal_Sport_Sales_Ancillary_Code);
                else
                    sportExistingSalesAncillaryInstance = new Acq_Deal_Sport_Sales_Ancillary();

                if (sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.Count > 1 && DisplayType == "D" && sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Code > 0)
                {
                    Acq_Deal_Sport_Sales_Ancillary newSportSalesAncillaryInstance = new Acq_Deal_Sport_Sales_Ancillary();
                    CreateSalesAncillaryObj(objAcq_Deal_Sport_Sale_Ancillary, lstSalesTitle, hdnSponserlist, hdnOfficiallist, newSportSalesAncillaryInstance);

                    foreach (string Code in lstSalesTitle)
                    {
                        int titleCode = Convert.ToInt32(Code);
                        sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.Remove(sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.Where(t => t.Title_Code == titleCode).SingleOrDefault());
                    }
                    newSportSalesAncillaryInstance.EntityState = State.Added;
                    objADSSAS.Save(newSportSalesAncillaryInstance, out resultSet);
                }
                else
                    CreateSalesAncillaryObj(objAcq_Deal_Sport_Sale_Ancillary, lstSalesTitle, hdnSponserlist, hdnOfficiallist, sportExistingSalesAncillaryInstance);

                string Message = string.Empty;
                if (sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Code > 0)
                {
                    sportExistingSalesAncillaryInstance.EntityState = State.Modified;
                    Message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    sportExistingSalesAncillaryInstance.EntityState = State.Added;
                    Message =objMessageKey.RecordAddedSuccessfully;
                }


                objADSSAS.Save(sportExistingSalesAncillaryInstance, out resultSet);
                objADSSaleAS = null;
                return Json(Message);
            }
            catch
            {
                return Json("Error");
            }
        }

        private void CreateSalesAncillaryObj(Acq_Deal_Sport_Sales_Ancillary objAcq_Deal_Sport_Sale_Ancillary, string[] lstSalesTitle, string hdnSponserlist, string hdnOfficiallist, Acq_Deal_Sport_Sales_Ancillary sportExistingSalesAncillaryInstance)
        {
            sportExistingSalesAncillaryInstance.Acq_Deal_Code = objAcq_Deal.Acq_Deal_Code;

            #region ========= Title object creation =========

            ICollection<Acq_Deal_Sport_Sales_Ancillary_Title> selectTitleList = new HashSet<Acq_Deal_Sport_Sales_Ancillary_Title>();

            foreach (string titleCode in lstSalesTitle)
            {
                Acq_Deal_Sport_Sales_Ancillary_Title sportAncillaryTitleInstance = new Acq_Deal_Sport_Sales_Ancillary_Title();
                sportAncillaryTitleInstance.Episode_From = 1;
                sportAncillaryTitleInstance.Episode_To = 1;
                sportAncillaryTitleInstance.Title_Code = Convert.ToInt32(titleCode);
                selectTitleList.Add(sportAncillaryTitleInstance);
            }

            IEqualityComparer<Acq_Deal_Sport_Sales_Ancillary_Title> comparerT = null;
            if (objDeal_Schema.Deal_Type_Code == GlobalParams.Deal_Type_Content)
                comparerT = new LambdaComparer<Acq_Deal_Sport_Sales_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);
            else
                comparerT = new LambdaComparer<Acq_Deal_Sport_Sales_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Sales_Ancillary_Title = new List<Acq_Deal_Sport_Sales_Ancillary_Title>();
            var Added_Acq_Deal_Sport_Sales_Ancillary_Title = CompareLists<Acq_Deal_Sport_Sales_Ancillary_Title>(selectTitleList.ToList<Acq_Deal_Sport_Sales_Ancillary_Title>(), sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.ToList<Acq_Deal_Sport_Sales_Ancillary_Title>(), comparerT, ref Deleted_Acq_Deal_Sport_Sales_Ancillary_Title);
            Added_Acq_Deal_Sport_Sales_Ancillary_Title.ToList<Acq_Deal_Sport_Sales_Ancillary_Title>().ForEach(t => sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.Add(t));
            Deleted_Acq_Deal_Sport_Sales_Ancillary_Title.ToList<Acq_Deal_Sport_Sales_Ancillary_Title>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Sales_Ancillary_Title titleInstance in sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.Where(t => t.EntityState != State.Deleted))
            {
                if (titleInstance.Acq_Deal_Sport_Sales_Ancillary_Title_Code > 0)
                    titleInstance.EntityState = State.Modified;
                else
                    titleInstance.EntityState = State.Added;
            }

            #endregion

            #region ========= Title Sponser =========

            ICollection<Acq_Deal_Sport_Sales_Ancillary_Sponsor> selectSponsorList = new HashSet<Acq_Deal_Sport_Sales_Ancillary_Sponsor>();
            Sponsor_Service objSponsorService = new Sponsor_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(hdnSponserlist))
            {
                foreach (string spons in hdnSponserlist.Split('~'))
                {
                    RightsU_Entities.Sponsor sponsorInstance = objSponsorService.SearchFor(spo => spo.Sponsor_Name.ToLower() == spons.ToLower()).FirstOrDefault();
                    if (sponsorInstance == null)
                    {
                        sponsorInstance = new RightsU_Entities.Sponsor();
                        sponsorInstance.Sponsor_Name = spons;
                        sponsorInstance.Is_Active = "Y";
                        sponsorInstance.EntityState = State.Added;
                        objSponsorService.Save(sponsorInstance);
                    }
                    Acq_Deal_Sport_Sales_Ancillary_Sponsor saleAncillartSponsorInstance = new Acq_Deal_Sport_Sales_Ancillary_Sponsor();
                    saleAncillartSponsorInstance.Sponsor_Code = sponsorInstance.Sponsor_Code;
                    saleAncillartSponsorInstance.Sponsor_Type = "T";
                    selectSponsorList.Add(saleAncillartSponsorInstance);
                }
            }

            if (!string.IsNullOrEmpty(hdnOfficiallist))
            {
                foreach (string spons in hdnOfficiallist.Split('~'))
                {
                    RightsU_Entities.Sponsor sponsorInstance = objSponsorService.SearchFor(spo => spo.Sponsor_Name.ToLower() == spons.ToLower()).FirstOrDefault();
                    if (sponsorInstance == null)
                    {
                        sponsorInstance = new RightsU_Entities.Sponsor();
                        sponsorInstance.Sponsor_Name = spons;
                        sponsorInstance.Is_Active = "Y";
                        sponsorInstance.EntityState = State.Added;
                        objSponsorService.Save(sponsorInstance);
                    }
                    Acq_Deal_Sport_Sales_Ancillary_Sponsor saleAncillartSponsorInstance = new Acq_Deal_Sport_Sales_Ancillary_Sponsor();
                    saleAncillartSponsorInstance.Sponsor_Code = sponsorInstance.Sponsor_Code;
                    saleAncillartSponsorInstance.Sponsor_Type = "O";
                    selectSponsorList.Add(saleAncillartSponsorInstance);
                }
            }


            IEqualityComparer<Acq_Deal_Sport_Sales_Ancillary_Sponsor> comparerST = null;
            comparerST = new LambdaComparer<Acq_Deal_Sport_Sales_Ancillary_Sponsor>((x, y) => x.Sponsor_Code == y.Sponsor_Code && x.EntityState != State.Deleted && x.Sponsor_Type == y.Sponsor_Type);

            var Deleted_Acq_Deal_Sport_Sales_Ancillary_Sponsor = new List<Acq_Deal_Sport_Sales_Ancillary_Sponsor>();
            var Added_Acq_Deal_Sport_Sales_Ancillary_Sponsor = CompareLists<Acq_Deal_Sport_Sales_Ancillary_Sponsor>(selectSponsorList.ToList<Acq_Deal_Sport_Sales_Ancillary_Sponsor>(), sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.ToList<Acq_Deal_Sport_Sales_Ancillary_Sponsor>(), comparerST, ref Deleted_Acq_Deal_Sport_Sales_Ancillary_Sponsor);
            Added_Acq_Deal_Sport_Sales_Ancillary_Sponsor.ToList<Acq_Deal_Sport_Sales_Ancillary_Sponsor>().ForEach(t => sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Add(t));
            Deleted_Acq_Deal_Sport_Sales_Ancillary_Sponsor.ToList<Acq_Deal_Sport_Sales_Ancillary_Sponsor>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Sales_Ancillary_Sponsor titleSponsorInstance in sportExistingSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.Where(t => t.EntityState != State.Deleted))
            {
                if (titleSponsorInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code > 0)
                    titleSponsorInstance.EntityState = State.Modified;
                else
                    titleSponsorInstance.EntityState = State.Added;
            }

            #endregion

            sportExistingSalesAncillaryInstance.FRO_Given_Title_Sponsor = objAcq_Deal_Sport_Sale_Ancillary.FRO_Given_Title_Sponsor;
            sportExistingSalesAncillaryInstance.FRO_Given_Official_Sponsor = objAcq_Deal_Sport_Sale_Ancillary.FRO_Given_Official_Sponsor;
            sportExistingSalesAncillaryInstance.Title_FRO_No_of_Days = objAcq_Deal_Sport_Sale_Ancillary.Title_FRO_No_of_Days;
            sportExistingSalesAncillaryInstance.Title_FRO_Validity = objAcq_Deal_Sport_Sale_Ancillary.Title_FRO_Validity;
            sportExistingSalesAncillaryInstance.Official_FRO_No_of_Days = objAcq_Deal_Sport_Sale_Ancillary.Official_FRO_No_of_Days;
            sportExistingSalesAncillaryInstance.Official_FRO_Validity = objAcq_Deal_Sport_Sale_Ancillary.Official_FRO_Validity;
            sportExistingSalesAncillaryInstance.Price_Protection_Title_Sponsor = objAcq_Deal_Sport_Sale_Ancillary.Price_Protection_Title_Sponsor;
            sportExistingSalesAncillaryInstance.Price_Protection_Official_Sponsor = objAcq_Deal_Sport_Sale_Ancillary.Price_Protection_Official_Sponsor;
            sportExistingSalesAncillaryInstance.Last_Matching_Rights_Title_Sponsor = objAcq_Deal_Sport_Sale_Ancillary.Last_Matching_Rights_Title_Sponsor;
            sportExistingSalesAncillaryInstance.Last_Matching_Rights_Official_Sponsor = objAcq_Deal_Sport_Sale_Ancillary.Last_Matching_Rights_Official_Sponsor;
            sportExistingSalesAncillaryInstance.Title_Last_Matching_Rights_Validity = objAcq_Deal_Sport_Sale_Ancillary.Title_Last_Matching_Rights_Validity;
            sportExistingSalesAncillaryInstance.Official_Last_Matching_Rights_Validity = objAcq_Deal_Sport_Sale_Ancillary.Official_Last_Matching_Rights_Validity;
            sportExistingSalesAncillaryInstance.Remarks = objAcq_Deal_Sport_Sale_Ancillary.Remarks;
        }

        public string DeleteSportSalesAncillary(int id, int titleCode, string DisplayType)
        {
            //Acq_Deal_Sport_Sales_Ancillary_Service objADSSAS = new Acq_Deal_Sport_Sales_Ancillary_Service();
            string Message = "Success";
            try
            {
                Acq_Deal_Sport_Sales_Ancillary sportSalesAncillaryInstance = objADSSaleAS.GetById(id);
                if (DisplayType == "G")
                {
                    sportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.ToList().ForEach(b => b.EntityState = State.Deleted);
                    sportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.ToList().ForEach(t => t.EntityState = State.Deleted);
                    sportSalesAncillaryInstance.EntityState = State.Deleted;
                }
                else
                {
                    if (sportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.Count > 1)
                    {
                        sportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.Where(t => t.Title_Code.Value == titleCode).SingleOrDefault().EntityState = State.Deleted;
                        sportSalesAncillaryInstance.EntityState = State.Modified;
                    }
                    else
                    {
                        sportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Sponsor.ToList().ForEach(b => b.EntityState = State.Deleted);
                        sportSalesAncillaryInstance.Acq_Deal_Sport_Sales_Ancillary_Title.ToList().ForEach(t => t.EntityState = State.Deleted);
                        sportSalesAncillaryInstance.EntityState = State.Deleted;
                    }
                }
                dynamic resultSet;
                objADSSaleAS.Save(sportSalesAncillaryInstance, out resultSet);
                objADSSaleAS = null;
            }
            catch
            {
                Message = "Error";
            }
            return Message;
        }

        #endregion

        #region ========= Monetization =========

        public PartialViewResult BindMonetisation(string displayType = "G", string selectedTitle = "")
        {
            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            ViewBag.DisplayMonetisationTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name");
            ViewBag.DisplayType = displayType;
            selectedDisplayProTitle = new List<int>();
            if (selectedTitle != string.Empty)
                foreach (string titleCode in selectedTitle.Split(','))
                {
                    selectedDisplayProTitle.Add(Convert.ToInt32(titleCode));
                }

            List<Acq_Deal_Sport_Monetisation_Ancillary> lstMonetisation = objADSMonetisationAS.SearchFor(m => m.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).ToList();
            ViewBag.PageMode = objDeal_Schema.Mode;
            if (displayType == "G")
            {
                var q = from mon in lstMonetisation
                        from monetisationSponsor in mon.Acq_Deal_Sport_Monetisation_Ancillary_Type.DefaultIfEmpty()
                        where mon.Acq_Deal_Sport_Monetisation_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Count() > 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Monetisation_Ancillary_Code = mon.Acq_Deal_Sport_Monetisation_Ancillary_Code,
                            Title = string.Join(", ", mon.Acq_Deal_Sport_Monetisation_Ancillary_Title.Where(t => selectedDisplayProTitle.Contains(t.Title_Code.Value) || selectedDisplayProTitle.Count == 0).Select(t => t.Title.Title_Name)),
                            TitleCode = "0",
                            Broadcast_Sponsor = (mon.Appoint_Broadcast_Sponsor == "Y") ? "Yes" : "No",
                            Title_Broadcast_Sponsor = (mon.Appoint_Title_Sponsor == "Y") ? "Yes" : "No",
                            Monetisations_Type = ((monetisationSponsor != null) ? monetisationSponsor.Monetisation_Type.Monetisation_Type_Name + ":" + ((monetisationSponsor.Monetisation_Rights == -1) ? "Unlimited" : (monetisationSponsor.Monetisation_Rights == -2) ? "Not Defined" : Convert.ToString(monetisationSponsor.Monetisation_Rights)) : ""),//string.Join(",", mon.Acq_Deal_Sport_Monetisation_Ancillary_Type.Select(s => (s.Monetisation_Type.Monetisation_Type_Name + ":" + s.Monetisation_Rights))),
                            Remarks = mon.Remarks
                        };
                return PartialView("~/Views/Acq_Deal/_Monetization.cshtml", q);
            }
            else
            {

                var q = from mon in lstMonetisation
                        from monTitles in mon.Acq_Deal_Sport_Monetisation_Ancillary_Title
                        from monetisationSponsor in mon.Acq_Deal_Sport_Monetisation_Ancillary_Type.DefaultIfEmpty()
                        where selectedDisplayProTitle.Contains(monTitles.Title_Code.Value) || selectedDisplayProTitle.Count == 0
                        select new Acq_Sport_Ancillary_Wrapper
                        {
                            Acq_Deal_Sport_Monetisation_Ancillary_Code = mon.Acq_Deal_Sport_Monetisation_Ancillary_Code,
                            Title = (monTitles.Title_Code != null) ? monTitles.Title.Title_Name : "",
                            TitleCode = (monTitles.Title_Code != null) ? monTitles.Title_Code.ToString() : "",
                            Broadcast_Sponsor = (mon.Appoint_Broadcast_Sponsor == "Y") ? "Yes" : "No",
                            Title_Broadcast_Sponsor = (mon.Appoint_Title_Sponsor == "Y") ? "Yes" : "No",
                            Monetisations_Type = ((monetisationSponsor != null) ? monetisationSponsor.Monetisation_Type.Monetisation_Type_Name + ":" + ((monetisationSponsor.Monetisation_Rights == -1) ? "Unlimited" : (monetisationSponsor.Monetisation_Rights == -2) ? "Not Defined" : Convert.ToString(monetisationSponsor.Monetisation_Rights)) : ""),//string.Join(",", mon.Acq_Deal_Sport_Monetisation_Ancillary_Type.Select(s => (s.Monetisation_Type.Monetisation_Type_Name + ":" + s.Monetisation_Rights))),
                            Remarks = mon.Remarks
                        };
                return PartialView("~/Views/Acq_Deal/_Monetization.cshtml", q);
            }
        }

        public PartialViewResult CreateMonetisation(int Acq_Deal_Sport_Monetisation_Ancillary_Code = 0, string TitleCode = "", string DisplayType = "")
        {

            Acq_Deal_Sport_Monetisation_Ancillary acqDealSportMoneAncillaryInstance;

            if (Acq_Deal_Sport_Monetisation_Ancillary_Code > 0)
                acqDealSportMoneAncillaryInstance = new Acq_Deal_Sport_Monetisation_Ancillary_Service(objLoginEntity.ConnectionStringName).GetById(Acq_Deal_Sport_Monetisation_Ancillary_Code);
            else
                acqDealSportMoneAncillaryInstance = new Acq_Deal_Sport_Monetisation_Ancillary();
            string selectedMoneTypes = string.Empty;
            if (acqDealSportMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.Count() > 0)
            {
                ViewBag.hdnMonetizationTypeId = acqDealSportMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.Count().ToString();
                ViewBag.hdnMonetisationTypeList = string.Join("~", acqDealSportMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.Select(s => s.Monetisation_Type_Code + "#" + s.Monetisation_Rights));
                ViewBag.RightPerMatch = Convert.ToString(acqDealSportMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.ElementAt(0).Monetisation_Rights);
                selectedMoneTypes = acqDealSportMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.ElementAt(0).Monetisation_Type_Code.ToString();
            }
            else
            {
                ViewBag.hdnMonetizationTypeId = "1";
                ViewBag.hdnMonetisationTypeList = string.Empty;
                ViewBag.RightPerMatch = "";
            }
            ViewBag.DisplayType = DisplayType;
            BindMoneDropDown(acqDealSportMoneAncillaryInstance, selectedMoneTypes, TitleCode, DisplayType);
            ViewBag.Mode = objDeal_Schema.Mode;
            ViewBag.DetailTitleCode = TitleCode;
            return PartialView("~/Views/Acq_Deal/_Popup_Monetization.cshtml", acqDealSportMoneAncillaryInstance);
        }

        private void BindMoneDropDown(Acq_Deal_Sport_Monetisation_Ancillary acqDealSportMoneAncillaryInstance, string selectedMoneTypes, string TitleCode, string DisplayType)
        {
            string[] selectedTitles = acqDealSportMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Select(t => t.Title_Code.ToString()).ToArray();

            objAcq_Deal = objADS.GetById(objDeal_Schema.Deal_Code);

            string[] arrSelectedTitle = objAcq_Deal.Acq_Deal_Movie.Select(x => x.Title_Code.ToString()).ToArray();
            List<RightsU_Entities.Title> lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrSelectedTitle.Contains(x.Title_Code.ToString())).ToList();
            if (DisplayType == "G")
                ViewBag.MoneTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", selectedTitles);
            else
                ViewBag.MoneTitleList = new MultiSelectList(lstTitle, "Title_Code", "Title_Name", TitleCode.Split(','));

            List<Monetisation_Type> lstMonetisationType = new Monetisation_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(m => m.Is_Active == "Y").ToList();
            if (!string.IsNullOrEmpty(selectedMoneTypes))
                ViewBag.MoneTypeList = new MultiSelectList(lstMonetisationType, "Monetisation_Type_Code", "Monetisation_Type_Name", selectedMoneTypes.Split(','));
            else
                ViewBag.MoneTypeList = new MultiSelectList(lstMonetisationType, "Monetisation_Type_Code", "Monetisation_Type_Name");
        }

        public JsonResult SaveMonetisation(Acq_Deal_Sport_Monetisation_Ancillary objAcq_Deal_Sport_Monetisation_Ancillary, string[] lstMonetizationTitle, string hdnMonetisationTypeList, string DisplayType)
        {
            try
            {
                dynamic resultSet;
                Acq_Deal_Sport_Monetisation_Ancillary sportExistingMoneAncillaryInstance;
                if (objAcq_Deal_Sport_Monetisation_Ancillary.Acq_Deal_Sport_Monetisation_Ancillary_Code > 0)
                    sportExistingMoneAncillaryInstance = objADSMonetisationAS.GetById(objAcq_Deal_Sport_Monetisation_Ancillary.Acq_Deal_Sport_Monetisation_Ancillary_Code);
                else
                    sportExistingMoneAncillaryInstance = new Acq_Deal_Sport_Monetisation_Ancillary();

                if (sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Count > 1 && DisplayType == "D" && sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Code > 0)
                {
                    Acq_Deal_Sport_Monetisation_Ancillary newSportMoneAncillaryInstance = new Acq_Deal_Sport_Monetisation_Ancillary();
                    CreateMoneAncillaryObj(objAcq_Deal_Sport_Monetisation_Ancillary, lstMonetizationTitle, hdnMonetisationTypeList, newSportMoneAncillaryInstance);

                    foreach (string Code in lstMonetizationTitle)
                    {
                        int titleCode = Convert.ToInt32(Code);
                        sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Remove(sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Where(t => t.Title_Code == titleCode).SingleOrDefault());
                    }
                    newSportMoneAncillaryInstance.EntityState = State.Added;
                    objADSMonetisationAS.Save(newSportMoneAncillaryInstance, out resultSet);
                }
                else
                    CreateMoneAncillaryObj(objAcq_Deal_Sport_Monetisation_Ancillary, lstMonetizationTitle, hdnMonetisationTypeList, sportExistingMoneAncillaryInstance);

                string Message = string.Empty;
                if (sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Code > 0)
                {
                    sportExistingMoneAncillaryInstance.EntityState = State.Modified;
                    Message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    sportExistingMoneAncillaryInstance.EntityState = State.Added;
                    Message = objMessageKey.RecordAddedSuccessfully;
                }

                objADSMonetisationAS.Save(sportExistingMoneAncillaryInstance, out resultSet);
                objADSMonetisationAS = null;
                return Json(Message);
            }
            catch
            {
                return Json("Error");
            }
        }

        private void CreateMoneAncillaryObj(Acq_Deal_Sport_Monetisation_Ancillary objAcq_Deal_Sport_Monetisation_Ancillary, string[] lstMonetizationTitle, string hdnMonetisationTypeList, Acq_Deal_Sport_Monetisation_Ancillary sportExistingMoneAncillaryInstance)
        {
            sportExistingMoneAncillaryInstance.Acq_Deal_Code = objAcq_Deal.Acq_Deal_Code;

            #region ========= Title object creation =========

            ICollection<Acq_Deal_Sport_Monetisation_Ancillary_Title> selectTitleList = new HashSet<Acq_Deal_Sport_Monetisation_Ancillary_Title>();

            foreach (string code in lstMonetizationTitle)
            {
                int titleCode = Convert.ToInt32(code);
                Acq_Deal_Sport_Monetisation_Ancillary_Title sportAncillaryTitleInstance = new Acq_Deal_Sport_Monetisation_Ancillary_Title();
                sportAncillaryTitleInstance.Episode_From = 1;
                sportAncillaryTitleInstance.Episode_To = 1;
                sportAncillaryTitleInstance.Title_Code = titleCode;
                selectTitleList.Add(sportAncillaryTitleInstance);
            }

            IEqualityComparer<Acq_Deal_Sport_Monetisation_Ancillary_Title> comparerT = null;
            if (objDeal_Schema.Deal_Type_Code == GlobalParams.Deal_Type_Content)
                comparerT = new LambdaComparer<Acq_Deal_Sport_Monetisation_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted && x.Episode_From == y.Episode_From && x.Episode_To == y.Episode_To);
            else
                comparerT = new LambdaComparer<Acq_Deal_Sport_Monetisation_Ancillary_Title>((x, y) => x.Title_Code == y.Title_Code && x.EntityState != State.Deleted);

            var Deleted_Acq_Deal_Sport_Monetisation_Ancillary_Title = new List<Acq_Deal_Sport_Monetisation_Ancillary_Title>();
            var Added_Acq_Deal_Sport_Monetisation_Ancillary_Title = CompareLists<Acq_Deal_Sport_Monetisation_Ancillary_Title>(selectTitleList.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Title>(), sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Title>(), comparerT, ref Deleted_Acq_Deal_Sport_Monetisation_Ancillary_Title);
            Added_Acq_Deal_Sport_Monetisation_Ancillary_Title.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Title>().ForEach(t => sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Add(t));
            Deleted_Acq_Deal_Sport_Monetisation_Ancillary_Title.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Title>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Monetisation_Ancillary_Title titleInstance in sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Where(t => t.EntityState != State.Deleted))
            {
                if (titleInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title_Code > 0)
                    titleInstance.EntityState = State.Modified;
                else
                    titleInstance.EntityState = State.Added;
            }

            #endregion

            #region Monetisation Tye creation
            ICollection<Acq_Deal_Sport_Monetisation_Ancillary_Type> selectMonetisationList = new HashSet<Acq_Deal_Sport_Monetisation_Ancillary_Type>();
            if (!string.IsNullOrEmpty(hdnMonetisationTypeList))
            {
                string[] arrMonetisation = hdnMonetisationTypeList.Split('~');
                foreach (string s in arrMonetisation)
                {
                    Acq_Deal_Sport_Monetisation_Ancillary_Type monetarySponsor = new Acq_Deal_Sport_Monetisation_Ancillary_Type();
                    string[] arr = s.Split('#');
                    if (arr.Length > 1)
                    {
                        monetarySponsor.Monetisation_Type_Code = Convert.ToInt32(arr[0]);
                        if (arr[1] != string.Empty)
                            monetarySponsor.Monetisation_Rights = Convert.ToInt32(arr[1]);
                        else
                            monetarySponsor.Monetisation_Rights = 0;
                    }
                    selectMonetisationList.Add(monetarySponsor);
                }
            }
            IEqualityComparer<Acq_Deal_Sport_Monetisation_Ancillary_Type> comparerMT = null;
            comparerMT = new LambdaComparer<Acq_Deal_Sport_Monetisation_Ancillary_Type>((x, y) => x.Monetisation_Type_Code == y.Monetisation_Type_Code && x.EntityState != State.Deleted && x.Monetisation_Type == y.Monetisation_Type);

            var Deleted_Acq_Deal_Sport_Monetisation_Ancillary_Type = new List<Acq_Deal_Sport_Monetisation_Ancillary_Type>();
            var Added_Acq_Deal_Sport_Monetisation_Ancillary_Type = CompareLists<Acq_Deal_Sport_Monetisation_Ancillary_Type>(selectMonetisationList.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Type>(), sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Type>(), comparerMT, ref Deleted_Acq_Deal_Sport_Monetisation_Ancillary_Type);
            Added_Acq_Deal_Sport_Monetisation_Ancillary_Type.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Type>().ForEach(t => sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.Add(t));
            Deleted_Acq_Deal_Sport_Monetisation_Ancillary_Type.ToList<Acq_Deal_Sport_Monetisation_Ancillary_Type>().ForEach(t => t.EntityState = State.Deleted);

            foreach (Acq_Deal_Sport_Monetisation_Ancillary_Type monetisationInstance in sportExistingMoneAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.Where(t => t.EntityState != State.Deleted))
            {
                if (monetisationInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type_Code > 0)
                    monetisationInstance.EntityState = State.Modified;
                else
                    monetisationInstance.EntityState = State.Added;
            }

            #endregion

            sportExistingMoneAncillaryInstance.Appoint_Broadcast_Sponsor = objAcq_Deal_Sport_Monetisation_Ancillary.Appoint_Broadcast_Sponsor;
            sportExistingMoneAncillaryInstance.Appoint_Title_Sponsor = objAcq_Deal_Sport_Monetisation_Ancillary.Appoint_Title_Sponsor;

            sportExistingMoneAncillaryInstance.Remarks = objAcq_Deal_Sport_Monetisation_Ancillary.Remarks;
        }

        public string DeleteSportMonetisationAncillary(int id, int titleCode, string DisplayType)
        {
            string Message = "Success";
            try
            {
                Acq_Deal_Sport_Monetisation_Ancillary sportMonetisationAncillaryInstance = objADSMonetisationAS.GetById(id);
                if (DisplayType == "G")
                {
                    sportMonetisationAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.ToList().ForEach(b => b.EntityState = State.Deleted);
                    sportMonetisationAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.ToList().ForEach(s => s.EntityState = State.Deleted);
                    sportMonetisationAncillaryInstance.EntityState = State.Deleted;
                }
                else
                {
                    if (sportMonetisationAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Count > 0)
                    {
                        sportMonetisationAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.Where(t => t.Title_Code.Value == titleCode).SingleOrDefault().EntityState = State.Deleted;
                        sportMonetisationAncillaryInstance.EntityState = State.Modified;
                    }
                    else
                    {
                        sportMonetisationAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Type.ToList().ForEach(b => b.EntityState = State.Deleted);
                        sportMonetisationAncillaryInstance.Acq_Deal_Sport_Monetisation_Ancillary_Title.ToList().ForEach(s => s.EntityState = State.Deleted);
                        sportMonetisationAncillaryInstance.EntityState = State.Deleted;
                    }
                }
                dynamic resultSet;
                objADSMonetisationAS.Save(sportMonetisationAncillaryInstance, out resultSet);
                objADSMonetisationAS = null;
            }
            catch
            {
                Message = "Error";
            }
            return Message;
        }

        #endregion

        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_EDIT_WO_APPROVAL)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            objDeal_Schema = null;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            return RedirectToAction("Index", "Acq_List");
        }
    }
}
