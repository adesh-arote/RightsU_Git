using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class ReportColumnSetupITController : BaseController
    {
        //-------------------------------------------------------------------Attrib_Group---------------------------------------------------------
        private List<RightsU_Entities.Attrib_Group> lstAttrib_Group
        {
            get
            {
                if (Session["lstAttrib_Group"] == null)
                    Session["lstAttrib_Group"] = new List<RightsU_Entities.Attrib_Group>();
                return (List<RightsU_Entities.Attrib_Group>)Session["lstAttrib_Group"];
            }
            set { Session["lstAttrib_Group"] = value; }
        }

        private List<RightsU_Entities.Attrib_Group> lstAttrib_Group_Searched
        {
            get
            {
                if (Session["lstAttrib_Group_Searched"] == null)
                    Session["lstAttrib_Group_Searched"] = new List<RightsU_Entities.Attrib_Group>();
                return (List<RightsU_Entities.Attrib_Group>)Session["lstAttrib_Group_Searched"];
            }
            set { Session["lstAttrib_Group_Searched"] = value; }
        }

        private RightsU_Entities.Attrib_Group objAttrib_Group
        {
            get
            {
                if (Session["objAttrib_Group"] == null)
                    Session["objAttrib_Group"] = new RightsU_Entities.Attrib_Group();
                return (RightsU_Entities.Attrib_Group)Session["objAttrib_Group"];
            }
            set { Session["objAttrib_Group"] = value; }
        }

        private Attrib_Group_Service objAttrib_Group_Service
        {
            get
            {
                if (Session["objAttrib_Group_Service"] == null)
                    Session["objAttrib_Group_Service"] = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);
                return (Attrib_Group_Service)Session["objAttrib_Group_Service"];
            }
            set { Session["objAttrib_Group_Service"] = value; }
        }

        //-----------------------------------------------------------------Attrib_Report_Column------------------------------------------------------
        private List<RightsU_Entities.Attrib_Report_Column> lstAttrib_Report_Column
        {
            get
            {
                if (Session["lstAttrib_Report_Column"] == null)
                    Session["lstAttrib_Report_Column"] = new List<RightsU_Entities.Attrib_Report_Column>();
                return (List<RightsU_Entities.Attrib_Report_Column>)Session["lstAttrib_Report_Column"];
            }
            set { Session["lstAttrib_Report_Column"] = value; }
        }

        private List<RightsU_Entities.Attrib_Report_Column> lstAttrib_Report_Column_Searched
        {
            get
            {
                if (Session["lstAttrib_Report_Column_Searched"] == null)
                    Session["lstAttrib_Report_Column_Searched"] = new List<RightsU_Entities.Attrib_Report_Column>();
                return (List<RightsU_Entities.Attrib_Report_Column>)Session["lstAttrib_Report_Column_Searched"];
            }
            set { Session["lstAttrib_Report_Column_Searched"] = value; }
        }

        private RightsU_Entities.Attrib_Report_Column objAttrib_Report_Column
        {
            get
            {
                if (Session["objAttrib_Report_Column"] == null)
                    Session["objAttrib_Report_Column"] = new RightsU_Entities.Attrib_Report_Column();
                return (RightsU_Entities.Attrib_Report_Column)Session["objAttrib_Report_Column"];
            }
            set { Session["objAttrib_Report_Column"] = value; }
        }

        private Attrib_Report_Column_Service objAttrib_Report_Column_Service
        {
            get
            {
                if (Session["objAttrib_Report_Column_Service"] == null)
                    Session["objAttrib_Report_Column_Service"] = new Attrib_Report_Column_Service(objLoginEntity.ConnectionStringName);
                return (Attrib_Report_Column_Service)Session["objAttrib_Report_Column_Service"];
            }
            set { Session["objAttrib_Report_Column_Service"] = value; }
        }

        //-----------------------------------------------------------------Report_Column_Setup_IT-------------------------------------------------------
        private List<RightsU_Entities.Report_Column_Setup_IT> lstReport_Column_Setup_IT
        {
            get
            {
                if (Session["lstReport_Column_Setup_IT"] == null)
                    Session["lstReport_Column_Setup_IT"] = new List<RightsU_Entities.Report_Column_Setup_IT>();
                return (List<RightsU_Entities.Report_Column_Setup_IT>)Session["lstReport_Column_Setup_IT"];
            }
            set { Session["lstReport_Column_Setup_IT"] = value; }
        }

        private List<RightsU_Entities.Report_Column_Setup_IT> lstReport_Column_Setup_IT_Searched
        {
            get
            {
                if (Session["lstReport_Column_Setup_IT_Searched"] == null)
                    Session["lstReport_Column_Setup_IT_Searched"] = new List<RightsU_Entities.Report_Column_Setup_IT>();
                return (List<RightsU_Entities.Report_Column_Setup_IT>)Session["lstReport_Column_Setup_IT_Searched"];
            }
            set { Session["lstReport_Column_Setup_IT_Searched"] = value; }
        }

        private RightsU_Entities.Report_Column_Setup_IT objReport_Column_Setup_IT
        {
            get
            {
                if (Session["objReport_Column_Setup_IT"] == null)
                    Session["objReport_Column_Setup_IT"] = new RightsU_Entities.Report_Column_Setup_IT();
                return (RightsU_Entities.Report_Column_Setup_IT)Session["objReport_Column_Setup_IT"];
            }
            set { Session["objReport_Column_Setup_IT"] = value; }
        }

        private Report_Column_Setup_IT_Service objReport_Column_Setup_IT_Service
        {
            get
            {
                if (Session["objReport_Column_Setup_IT_Service"] == null)
                    Session["objReport_Column_Setup_IT_Service"] = new Report_Column_Setup_IT_Service(objLoginEntity.ConnectionStringName);
                return (Report_Column_Setup_IT_Service)Session["objReport_Column_Setup_IT_Service"];
            }
            set { Session["objReport_Column_Setup_IT_Service"] = value; }
        }

        //-----------------------------------------------------Paging------------------------------------------------------------------------------------
        // GET: ReportColumnSetupIT
        public ActionResult Index()
        {
            FetchData();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "LatestModified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "SortNameAsc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "SortNameDesc", Value = "ND" });
            ViewBag.SortType = lstSort;
            return View();
        }

        public ActionResult BindReportColumnSetupIT(int pageNo, int recordPerPage, string sortType)
        {
            List<Report_Column_Setup_IT> lst = new List<Report_Column_Setup_IT>();
            lst = lstReport_Column_Setup_IT.OrderBy(o => o.Column_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstReport_Column_Setup_IT_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstReport_Column_Setup_IT_Searched.OrderByDescending(o => o.Column_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstReport_Column_Setup_IT_Searched.OrderBy(o => o.Display_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstReport_Column_Setup_IT_Searched.OrderByDescending(o => o.Name_In_DB).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/ReportColumnSetupIT/_BindList.cshtml", lst);
        }

        private void FetchData()
        {
            //lstAttrib_Group_Searched = lstAttrib_Group = objAttrib_Group_Service.SearchFor(x => true).OrderByDescending(o => o.Attrib_Group_Code).ToList();
            lstReport_Column_Setup_IT_Searched = lstReport_Column_Setup_IT = objReport_Column_Setup_IT_Service.SearchFor(x => true).OrderBy(o => o.Column_Code).ToList();
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

        public JsonResult SearchReportColumnSetupIT(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstReport_Column_Setup_IT_Searched = lstReport_Column_Setup_IT.Where(w => w.Display_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstReport_Column_Setup_IT_Searched = lstReport_Column_Setup_IT;

            var obj = new
            {
                Record_Count = lstReport_Column_Setup_IT_Searched.Count
            };

            return Json(obj);
        }

        //------------------------------------------------------------CRUD--------------------------------------------------------------------------------
        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(Report_Column_Setup_IT objRCSI)
        {
            objReport_Column_Setup_IT_Service = null;
            objReport_Column_Setup_IT = objRCSI;
            objReport_Column_Setup_IT.EntityState = State.Added;
            dynamic resultSet;
            if (objReport_Column_Setup_IT_Service.Save(objReport_Column_Setup_IT, out resultSet))
            {
                return RedirectToAction("Index");
            }
            return View();
        }

        public ActionResult Edit(int id)
        {
            Report_Column_Setup_IT objRCSIT = new Report_Column_Setup_IT();
            objRCSIT = lstReport_Column_Setup_IT.Where(a => a.Column_Code == id).FirstOrDefault();

            return View("Create", objRCSIT);
        }

        [HttpPost]
        public ActionResult Edit(int id, Report_Column_Setup_IT objRCSI)
        {
            objReport_Column_Setup_IT_Service = null;
            objReport_Column_Setup_IT = objRCSI;
            objReport_Column_Setup_IT.Column_Code = id;
            objReport_Column_Setup_IT.EntityState = State.Modified;

            dynamic resultSet;
            if (objReport_Column_Setup_IT_Service.Save(objReport_Column_Setup_IT, out resultSet))
            {
                return RedirectToAction("Index");
            }
            return View();
        }

        public ActionResult Details(int id)
        {
            Report_Column_Setup_IT objRCSIT = new Report_Column_Setup_IT();
            objRCSIT = lstReport_Column_Setup_IT.Where(a => a.Column_Code == id).FirstOrDefault();
            ViewBag.Details = "Details";
            return View("Delete", objRCSIT);
        }

        public ActionResult Delete(int id)
        {
            Report_Column_Setup_IT objRCSIT = new Report_Column_Setup_IT();
            objRCSIT = lstReport_Column_Setup_IT.Where(a => a.Column_Code == id).FirstOrDefault();
            return View(objRCSIT);
        }

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Report_Column_Setup_IT objRCSIT = new Report_Column_Setup_IT();
            objRCSIT = objReport_Column_Setup_IT_Service.GetById(id);
            objRCSIT.EntityState = State.Deleted;

            dynamic resultSet;
            if(objReport_Column_Setup_IT_Service.Delete(objRCSIT, out resultSet))
            {
                return RedirectToAction("Index");
            }
            return View();
        }
    }
}