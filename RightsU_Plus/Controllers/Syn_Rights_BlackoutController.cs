using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_Rights_BlackoutController : BaseController
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

        #endregion
        //
        // GET: /Acq_Rights_Blackout/

        public ActionResult Index()
        {
            return View();
        }

        public PartialViewResult BindBlackOut()
        {
            if (objPage_Properties.RMODE == GlobalParams.DEAL_MODE_VIEW || objPage_Properties.RMODE == GlobalParams.DEAL_MODE_APPROVE)
                ViewBag.CommandName_HB = objPage_Properties.RMODE;
            else
                ViewBag.CommandName_HB = "LIST";
            objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.Where(t => t.EntityState != State.Deleted);            
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Blackout.cshtml", new Syn_Deal_Rights_Blackout());
        }

        public PartialViewResult Add_Blackout()
        {
            ViewBag.CommandName_HB = "ADD";
            ViewBag.IsAddEditMode = "Y";            
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Blackout.cshtml", new Syn_Deal_Rights_Blackout());
        }

        public JsonResult Save_Blackout(string Start_Date, string End_Date, string DummyProperty)
        {
            string mode = string.Empty;
            DateTime StartDate = new DateTime();
            DateTime EndDate = new DateTime();
            if (Start_Date != string.Empty && Start_Date != "DD/MM/YYYY")
                StartDate = Convert.ToDateTime(GlobalUtil.MakedateFormat(Start_Date));
            if (End_Date != string.Empty && End_Date != "DD/MM/YYYY")
                EndDate = Convert.ToDateTime(GlobalUtil.MakedateFormat(End_Date));
            if (StartDate > EndDate)
            {
                return Json(objMessageKey.Startdateshouldbelessthanenddate);
            }
            else
            {
                var vBlackout = from Syn_Deal_Rights_Blackout objB in objSyn_Deal_Rights.Syn_Deal_Rights_Blackout
                                where objB.strDummyProp != DummyProperty && objB.EntityState != State.Deleted && (
                                    (objB.Start_Date >= StartDate && objB.Start_Date <= EndDate) ||
                                    (objB.End_Date >= StartDate && objB.End_Date <= EndDate) ||
                                    (StartDate >= objB.Start_Date && StartDate <= objB.End_Date) ||
                                    (EndDate >= objB.Start_Date && EndDate <= objB.End_Date)
                                )
                                select objB;

                if (vBlackout.ToList().Count > 0)
                {
                    return Json(objMessageKey.Blackoutperiodcannotbeoverlap);
                }
                else
                {
                    Syn_Deal_Rights_Blackout objADRB = null;
                    if (DummyProperty != "0" && DummyProperty != null)
                    {
                        mode = "E";
                        objADRB = objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
                        if (objADRB.Syn_Deal_Rights_Blackout_Code > 0)
                            objADRB.EntityState = State.Modified;
                    }
                    else
                    {
                        mode = "A";
                        objADRB = new Syn_Deal_Rights_Blackout();
                        objADRB.EntityState = State.Added;
                    }
                    new Syn_Deal_Rights_Blackout();
                    if (Start_Date != string.Empty && Start_Date != "DD/MM/YYYY")
                        objADRB.Start_Date = Convert.ToDateTime(Start_Date);
                    if (End_Date != string.Empty && End_Date != "DD/MM/YYYY")
                        objADRB.End_Date = Convert.ToDateTime(End_Date);
                    if (objADRB.EntityState == State.Added)
                        objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.Add(objADRB);
                    var obj = new
                    {
                        Success = "Success",
                        mode = mode
                    };
                   
                    return Json(obj);
                }
            }
        }

        public PartialViewResult Edit_Blackout(string DummyProperty)
        {

            ViewBag.CommandName_HB = GlobalParams.DEAL_MODE_EDIT;
            ViewBag.DummyProperty = DummyProperty;
            ViewBag.IsAddEditMode = "Y";
            Syn_Deal_Rights_Blackout obj = objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();            
            return PartialView("~/Views/Syn_Deal/_Syn_Rights_Blackout.cshtml", obj);
        }

        public JsonResult Delete_Blackout(string DummyProperty)
        {
            Syn_Deal_Rights_Blackout obj = objSyn_Deal_Rights.Syn_Deal_Rights_Blackout.Where(w => w.strDummyProp == DummyProperty).FirstOrDefault();
            obj.EntityState = State.Deleted;
            ViewBag.CommandName_HB = "LIST";
            var objs = new
            {
               
            };
            return Json(objs);
        }
    }
}
