using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using Microsoft.Reporting.WebForms;

namespace RightsU_Plus.Controllers
{

    public class AmortController : BaseController
    {
        private List<Amort_Month_Data> lstAMD
        {
            get
            {
                if (Session["lstAMD"] == null)
                    Session["lstAMD"] = new List<Amort_Month_Data>();
                return (List<Amort_Month_Data>)Session["lstAMD"];
            }
            set
            {
                Session["lstAMD"] = value;
            }
        }
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult BindTitle(char TitleFor)
        {
            int deal_Type_Code = TitleFor == 'M' ? 1 : 11;
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            SelectList lstTitle = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type_Code == deal_Type_Code)
              .Select(i => new { Display_Value = i.Title_Code, Display_Text = i.Title_Name }).ToList(),
              "Display_Value", "Display_Text");
            obj_Dictionary.Add("lstTitle", lstTitle);
            return Json(obj_Dictionary);
        }

        public JsonResult BindRuleNo(string Rule_Type = "R")
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            SelectList lstRule_No = new SelectList(new Amort_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Rule_Type == Rule_Type)
              .Select(i => new { Display_Value = i.Amort_Rule_Code, Display_Text = i.Rule_No }).ToList(),
              "Display_Value", "Display_Text");
            obj_Dictionary.Add("lstRule_No", lstRule_No);
            return Json(obj_Dictionary);
        }

        public PartialViewResult BindAmortList(int TitleCode = 0)
        {
            List<Acq_Deal> listAcqDeal = new List<Acq_Deal>();
            if (TitleCode != 0)
            {
                //make global List save time
                var lstAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                var lstADTitle = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();

                var TempList = (from ad in lstAcq_Deal
                                join adm in lstADTitle on
                                ad.Acq_Deal_Code equals adm.Acq_Deal_Code
                                where adm.Title_Code == TitleCode
                                select ad).ToList();

                listAcqDeal = TempList;
            }
            return PartialView("~/Views/Amort/_AmortList.cshtml", listAcqDeal);
        }

        public PartialViewResult ViewAmortRule(int Acq_Deal_Code, string Amort_On, int TitleCode)
        {
            if (Amort_On == "C")
            {
                var Acq_Deal_list = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
                var acq_Deal_cost_list = new Acq_Deal_Cost_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                var acq_deal_cost_title_list = new Acq_Deal_Cost_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                var acq_Deal_cost_costtype_list = new Acq_Deal_Cost_Costtype_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                var Cost_Type_list = new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();

                var Cost_Type_List = (from ad in Acq_Deal_list
                                      join adc in acq_Deal_cost_list on ad.Acq_Deal_Code equals adc.Acq_Deal_Code
                                      join adct in acq_deal_cost_title_list on adc.Acq_Deal_Cost_Code equals adct.Acq_Deal_Cost_Code
                                      join adcct in acq_Deal_cost_costtype_list on adc.Acq_Deal_Cost_Code equals adcct.Acq_Deal_Cost_Code
                                      join ct in Cost_Type_list on adcct.Cost_Type_Code equals ct.Cost_Type_Code
                                      where ad.Acq_Deal_Code == Acq_Deal_Code && adct.Title_Code == TitleCode
                                      select new
                                      {
                                          Cost_Type_Name = ct.Cost_Type_Name,
                                          Amount = adcct.Amount
                                      }).ToList();

                List<Cost_Type_Data> lst = new List<Cost_Type_Data>();
                //List<string> Cost_Type_List = new Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(x => x.Cost_Type_Name).ToList();

                foreach (var item in Cost_Type_List)
                {
                    Cost_Type_Data obj = new Cost_Type_Data();
                    obj.Amount = item.Amount;
                    obj.Cost_Type_Name = item.Cost_Type_Name;
                    lst.Add(obj);
                }
                ViewBag.Cost_Type_List = lst;
            }

            ViewBag.AmortOn = Amort_On;
            return PartialView("~/Views/Amort/_AmortRule.cshtml");
        }

        public PartialViewResult BindShowAortRule(int Amort_Rule_Code)
        {
            Amort_Rule objAR = new Amort_Rule();
            Amort_Rule_Service objAmortRuleService = new Amort_Rule_Service(objLoginEntity.ConnectionStringName);
            objAR = objAmortRuleService.GetById(Amort_Rule_Code);

            return PartialView("~/Views/Amort/_ViewAmortRule.cshtml", objAR);
        }




        public ActionResult AddAmort(string isEdit = "N")
        {
            ViewBag.isEdit = isEdit;
            return View("~/Views/Amort/AmortDetails.cshtml");
        }
        public PartialViewResult BindAmortMonthList(int pageNo, int recordPerPage)
        {
            List<Amort_Month_Data> lst = new List<Amort_Month_Data>();
            int RecordCount = 0;


            RecordCount = lstAMD.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstAMD.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/Amort/_AmortMonthList.cshtml", lst);
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
        public JsonResult SearchAmortMonth(string searchText)
        {
            lstAMD = new List<Amort_Month_Data>();
            Amort_Month_Data objAMD = new Amort_Month_Data();
            objAMD.Month = "NOV 2017";
            objAMD.status = "O";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "OCT 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "SEP 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);
            objAMD = new Amort_Month_Data();
            objAMD.Month = "AUG 2017";
            objAMD.status = "C";
            lstAMD.Add(objAMD);


            if (!string.IsNullOrEmpty(searchText))
            {
                lstAMD = lstAMD.Where(w => w.Month.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            var obj = new
            {
                Record_Count = lstAMD.Count()
            };
            return Json(obj);
        }
        public class Amort_Month_Data
        {
            public string Month { get; set; }
            public string status { get; set; }
        }

        public class Cost_Type_Data
        {
            public string Cost_Type_Name { get; set; }
            public decimal? Amount { get; set; }
        }
    }
}
