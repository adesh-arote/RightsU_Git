using RightsU_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;

namespace RightsU_Plus.Controllers
{
    public class Attrib_ReportsController : BaseController
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
        // GET: Attrib_Reports
        public ActionResult Index()
        {
            string config = "";
            config = Convert.ToString(TempData["config"]);
            Session["Configuration"] = config;

            if (Convert.ToString(Session["Configuration"]) == "config")
            {
                FetchConfigureList();
                //Session["Configuration"] = null;
            }
            else
            {
                FetchData();
            }
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            if (Session["Message"] != null)
            {
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }
            return View();
        }

        public ActionResult BindAttribReport(int pageNo, int recordPerPage, string sortType)
        {
            List<Attrib_Report_Column> lst = new List<Attrib_Report_Column>();
            lst = lstAttrib_Report_Column.OrderBy(o => o.Attrib_Report_Column_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstAttrib_Report_Column_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstAttrib_Report_Column_Searched.OrderByDescending(o => o.Attrib_Report_Column_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstAttrib_Report_Column_Searched.OrderBy(o => o.Column_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstAttrib_Report_Column_Searched.OrderByDescending(o => o.Control_Type).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            List<Attrib_Group> lstAttribGrp = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            ViewBag.BindAttribLst = lstAttribGrp;

            return PartialView("~/Views/Attrib_Reports/_BindList.cshtml", lst);
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

        private void FetchData()
        {
            //lstAttrib_Group_Searched = lstAttrib_Group = objAttrib_Group_Service.SearchFor(x => true).OrderByDescending(o => o.Attrib_Group_Code).ToList();
            //lstReport_Column_Setup_IT_Searched = lstReport_Column_Setup_IT = objReport_Column_Setup_IT_Service.SearchFor(x => true).OrderBy(o => o.Column_Code).ToList();
            lstAttrib_Report_Column_Searched = lstAttrib_Report_Column = objAttrib_Report_Column_Service.SearchFor(x => true).OrderBy(o => o.Attrib_Report_Column_Code).ToList();
        }

        private void FetchConfigureList()
        {
            int ColumnCode = 0;
            string DisplayName = "";


            if (TempData["DisplayName"] != null && TempData["config"] != null && TempData["ColumnCode"] != null)
            {
                ColumnCode = Convert.ToInt32(TempData["ColumnCode"]);
                DisplayName = Convert.ToString(TempData["DisplayName"]);
                lstAttrib_Report_Column_Searched = lstAttrib_Report_Column = objAttrib_Report_Column_Service.SearchFor(x => true).Where(a => a.Column_Code == ColumnCode).ToList();
            }
        }


        public JsonResult SearchAttribReport(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstAttrib_Report_Column_Searched = lstAttrib_Report_Column.Where(w => w.Type != null && w.Type.ToUpper().Contains(searchText.ToUpper()) || w.Attrib_Group.Attrib_Group_Name != null && w.Attrib_Group.Attrib_Group_Name.ToUpper().Contains(searchText.ToUpper())
                || w.Report_Column_Setup_IT.Display_Name != null && w.Report_Column_Setup_IT.Display_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstAttrib_Report_Column_Searched = lstAttrib_Report_Column;

            var obj = new
            {
                Record_Count = lstAttrib_Report_Column_Searched.Count
            };

            return Json(obj);
        }

        //----------------------------------------------------------------CRUD----------------------------------------------------------------

        public ActionResult Create()
        {
            int AttribGrpCode = 0;
            string AttribType = "";
            string config = "";

            if (TempData["AttribType"] != null && TempData["config"] != null && TempData["AttribGrpCode"] != null)
            {
                AttribGrpCode = Convert.ToInt32(TempData["AttribGrpCode"]);
                AttribType = Convert.ToString(TempData["AttribType"]);
                config = Convert.ToString(TempData["config"]);
                ViewBag.Configuration = config;
            }

            List<Attrib_Group> lstAttribGrpName = objAttrib_Group_Service.SearchFor(s => true).ToList();

            Attrib_Report_Column objARC = new Attrib_Report_Column();
            ViewBag.Title = "Create";

            if (AttribType == "DP")
            {
                objARC.DP_Attrib_Group_Code = AttribGrpCode;
                var lstAttribTypeBV = lstAttribGrpName.Where(a => a.Attrib_Type == "BV").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
                ViewBag.AttribTypeBV = new SelectList(lstAttribTypeBV, "Attrib_Group_Code", "Attrib_Group_Name");
                ViewBag.DP = lstAttribGrpName.Where(a => a.Attrib_Group_Code == AttribGrpCode).Select(b => b.Attrib_Group_Name).FirstOrDefault();
            }
            else if (AttribType == "BV")
            {
                objARC.BV_Attrib_Group_Code = AttribGrpCode;
                var lstAttribTypeDP = lstAttribGrpName.Where(a => a.Attrib_Type == "DP").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
                ViewBag.AttribTypeDP = new SelectList(lstAttribTypeDP, "Attrib_Group_Code", "Attrib_Group_Name");
                ViewBag.BV = lstAttribGrpName.Where(a => a.Attrib_Group_Code == AttribGrpCode).Select(b => b.Attrib_Group_Name).FirstOrDefault();
            }
            else
            {
                var lstAttribTypeDP = lstAttribGrpName.Where(a => a.Attrib_Type == "DP").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
                ViewBag.AttribTypeDP = new SelectList(lstAttribTypeDP, "Attrib_Group_Code", "Attrib_Group_Name");
                var lstAttribTypeBV = lstAttribGrpName.Where(a => a.Attrib_Type == "BV").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
                ViewBag.AttribTypeBV = new SelectList(lstAttribTypeBV, "Attrib_Group_Code", "Attrib_Group_Name");
            }

            List<Report_Column_Setup_IT> lstDspName = objReport_Column_Setup_IT_Service.SearchFor(s => true).ToList();
            var lstDisplaypName = lstDspName.Select(a => new { a.Display_Name, a.Column_Code }).ToList();
            ViewBag.DisplayName = new SelectList(lstDisplaypName, "Column_Code", "Display_Name");

            return View(objARC);
        }

        [HttpPost]
        public ActionResult Create(Attrib_Report_Column objARC)
        {
            string status = "", message = "";
            List<Attrib_Report_Column> lstAttribReportColumn = objAttrib_Report_Column_Service.SearchFor(s => true).ToList();
            List<Attrib_Report_Column> tempList = objAttrib_Report_Column_Service.SearchFor(x => true).Where(a => (a.DP_Attrib_Group_Code == objARC.DP_Attrib_Group_Code) && (a.BV_Attrib_Group_Code == objARC.BV_Attrib_Group_Code) && (a.Column_Code == objARC.Column_Code) && (a.Control_Type == objARC.Control_Type)).ToList();
            var LastIdArc = lstAttribReportColumn.OrderBy(a => a.Attrib_Report_Column_Code).LastOrDefault();

            if (tempList.Count == 0)
            {
                objAttrib_Report_Column_Service = null;
                objAttrib_Report_Column = objARC;
                objAttrib_Report_Column.EntityState = State.Added;

                objAttrib_Report_Column.Attrib_Report_Column_Code = LastIdArc.Attrib_Report_Column_Code + 1;

                dynamic resultSet;
                if (!objAttrib_Report_Column_Service.Save(objAttrib_Report_Column, out resultSet))
                {
                    status = "E";
                    Session["Message"] = "Record Not saved";
                }
                else
                {
                    status = "S";
                    Session["Message"] = objMessageKey.Recordsavedsuccessfully;
                }
            }
            else
            {
                status = "E";
                Session["Message"] = objMessageKey.RecordAlreadyExists;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public ActionResult Edit(int id)
        {
            objAttrib_Report_Column = lstAttrib_Report_Column.Where(a => a.Attrib_Report_Column_Code == id).FirstOrDefault();

            List<Attrib_Group> lstAttribGrpName = objAttrib_Group_Service.SearchFor(s => true).ToList();
            var lstAttribTypeDP = lstAttribGrpName.Where(a => a.Attrib_Type == "DP").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
            ViewBag.AttribTypeDP = new SelectList(lstAttribTypeDP, "Attrib_Group_Code", "Attrib_Group_Name", objAttrib_Report_Column.DP_Attrib_Group_Code);
            var lstAttribTypeBV = lstAttribGrpName.Where(a => a.Attrib_Type == "BV").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
            ViewBag.AttribTypeBV = new SelectList(lstAttribTypeBV, "Attrib_Group_Code", "Attrib_Group_Name", objAttrib_Report_Column.BV_Attrib_Group_Code);

            List<Report_Column_Setup_IT> lstDspName = objReport_Column_Setup_IT_Service.SearchFor(s => true).ToList();
            var lstDisplaypName = lstDspName.Select(a => new { a.Display_Name, a.Column_Code }).ToList();
            ViewBag.DisplayName = new SelectList(lstDisplaypName, "Column_Code", "Display_Name", objAttrib_Report_Column.Column_Code);

            ViewBag.Title = "Edit";
            return View("Create", objAttrib_Report_Column);
        }
        [HttpPost]
        public ActionResult Edit(Attrib_Report_Column attrib_Report_Column, int id)
        {
            string status = "", message = "";
            objAttrib_Report_Column_Service = null;
            objAttrib_Report_Column = attrib_Report_Column;
            objAttrib_Report_Column.Attrib_Report_Column_Code = id;
            List<Attrib_Report_Column> tempList = objAttrib_Report_Column_Service.SearchFor(x => true).Where(a => (a.DP_Attrib_Group_Code == attrib_Report_Column.DP_Attrib_Group_Code) && (a.BV_Attrib_Group_Code == attrib_Report_Column.BV_Attrib_Group_Code) && (a.Column_Code == attrib_Report_Column.Column_Code) && (a.Control_Type == attrib_Report_Column.Control_Type) && (a.Attrib_Report_Column_Code != attrib_Report_Column.Attrib_Report_Column_Code)).ToList();

            if (tempList.Count == 0)
            {

                objAttrib_Report_Column.EntityState = State.Modified;
                dynamic resultSet;
                if (!objAttrib_Report_Column_Service.Save(objAttrib_Report_Column, out resultSet))
                {
                    status = "E";
                    Session["Message"] = objMessageKey.CouldNotsavedRecord;
                }
                else
                {
                    status = "S";
                    Session["Message"] = objMessageKey.Recordsavedsuccessfully;
                }
            }
            else
            {
                status = "E";
                message = objMessageKey.RecordAlreadyExists;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public ActionResult Details(int id)
        {
            Attrib_Report_Column objAtc = new Attrib_Report_Column();
            objAtc = lstAttrib_Report_Column.Where(a => a.Attrib_Report_Column_Code == id).FirstOrDefault();

            List<Attrib_Group> lstAttribGrpName = objAttrib_Group_Service.SearchFor(s => true).ToList();
            var lstAttribTypeDP = lstAttribGrpName.Where(a => a.Attrib_Type == "DP").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
            ViewBag.DP = lstAttribGrpName.Where(a => a.Attrib_Group_Code == objAtc.DP_Attrib_Group_Code).Select(b => b.Attrib_Group_Name).FirstOrDefault();
            var lstAttribTypeBV = lstAttribGrpName.Where(a => a.Attrib_Type == "BV").Select(b => new { b.Attrib_Group_Name, b.Attrib_Group_Code }).ToList();
            ViewBag.BV = lstAttribGrpName.Where(a => a.Attrib_Group_Code == objAtc.BV_Attrib_Group_Code).Select(b => b.Attrib_Group_Name).FirstOrDefault();

            ViewBag.Title = "View";

            return View("Create", objAtc);
        }

        //public ActionResult Delete(int id)
        //{
        //    Attrib_Report_Column objAtc = new Attrib_Report_Column();
        //    objAtc = lstAttrib_Report_Column.Where(a => a.Attrib_Report_Column_Code == id).FirstOrDefault();
        //    return View(objAtc);
        //}

        //[HttpPost, ActionName("Delete")]
        public ActionResult Delete(int id)
        {
            Attrib_Report_Column objAtc = new Attrib_Report_Column();
            objAtc = objAttrib_Report_Column_Service.GetById(id);
            objAtc.EntityState = State.Deleted;
            dynamic resultSet;
            if (objAttrib_Report_Column_Service.Delete(objAtc, out resultSet))
            {
                Session["Message"] = objMessageKey.RecordDeletedsuccessfully;
                return RedirectToAction("Index");
            }

            return View();
        }
    }
}