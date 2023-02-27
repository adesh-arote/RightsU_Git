using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;

namespace RightsU_Plus.Controllers
{
    public class ReportColumnSetupController : BaseController
    {
        private List<Report_Column_Setup> lstReportColumnSetup
        {
            get
            {
                if (Session["lstReportColumnSetup"] == null)
                    Session["lstReportColumnSetup"] = new List<Report_Column_Setup>();
                return (List<Report_Column_Setup>)Session["lstReportColumnSetup"];
            }
            set
            {
                Session["lstReportColumnSetup"] = value;
            }
        }

        private List<Report_Column_Setup> lstReportColumnSetup_Searched
        {
            get
            {
                if (Session["lstReportColumnSetupSearched"] == null)
                    Session["lstReportColumnSetupSearched"] = new List<Report_Column_Setup>();
                return (List<Report_Column_Setup>)Session["lstReportColumnSetupSearched"];
            }
            set
            {
                Session["lstReportColumnSetupSearched"] = value;
            }
        }

        private Report_Column_Setup objReportColumnSetup
        {
            get
            {
                if (Session["objReportColumnSetup"] == null)
                    Session["objReportColumnSetup"] = new Report_Column_Setup();
                return (Report_Column_Setup)Session["objReportColumnSetup"];
            }
            set
            {
                Session["objReportColumnSetup"] = value;
            }
        }

        // GET: ReportColumnSetup
        public ActionResult Index()
        {
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.LangCode = SysLanguageCode;
            lstReportColumnSetup_Searched = lstReportColumnSetup = new Report_Column_Setup_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Ascending", Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "L" });
            lstSort.Add(new SelectListItem { Text = "Sort Display Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Display Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            return View();
        }

        public PartialViewResult BindReportColumnSetup(int pageNo, int recordPerPage, int ColumnCode, string commandName, string sortType)
        {
            ViewBag.ColumnCode = ColumnCode;
            ViewBag.CommandName = commandName;

            List<Report_Column_Setup> lstRCS = new List<Report_Column_Setup>();
            lstRCS = lstReportColumnSetup.OrderBy(o => o.Column_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstReportColumnSetup_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lstRCS = lstReportColumnSetup_Searched.OrderBy(o => o.Column_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "L")
                {
                    lstRCS = lstReportColumnSetup_Searched.OrderByDescending(o => o.Column_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lstRCS = lstReportColumnSetup_Searched.OrderBy(o => o.Display_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lstRCS = lstReportColumnSetup_Searched.OrderByDescending(o => o.Display_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }

            return PartialView("_BindReportColumnSetup", lstRCS);
        }

        public int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                    {
                        pageNo = v1;
                    }
                    else
                    {
                        pageNo = v1 + 1;
                    }
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                {
                    noOfRecordTake = recordCount - noOfRecordSkip;
                }
                else
                {
                    noOfRecordTake = recordPerPage;
                }
            }
            return pageNo;
        }

        public JsonResult SearchResultColumnSetUp(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstReportColumnSetup_Searched = lstReportColumnSetup.Where(w => (w.Display_Name.ToUpper().Contains(searchText.ToUpper())) || (w.Name_In_DB != null && w.Name_In_DB.ToUpper().Contains(searchText.ToUpper())) || (w.List_Source != null && w.List_Source.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            else
            {
                lstReportColumnSetup_Searched = lstReportColumnSetup;
            }

            var obj = new
            {
                Record_Count = lstReportColumnSetup_Searched.Count
            };

            return Json(obj);
        }

        public PartialViewResult AddEditReportColumnSetup(string commandName, int ColumnCode)
        {
            objReportColumnSetup = null;
            int countReportColumnSetup = lstReportColumnSetup.Where(w => w.Column_Code == ColumnCode).Count();

            List<string> lstViewName = new List<string>();
            List<string> lstIsPart = new List<string>();

            if (commandName != "VIEW")
            {
                lstViewName.Add("VW_ACQ_DEALS");
                lstViewName.Add("VW_SYN_DEALS");
                ViewBag.lstViewName = new SelectList(lstViewName);

                //lstIsPart.Add("Yes");
                //lstIsPart.Add("No");
                //lstIsPart.Add("Both");
                //ViewBag.lstIsPart = new SelectList(lstIsPart);
            }

            if (countReportColumnSetup > 0)
            {
                objReportColumnSetup = new Report_Column_Setup_Service(objLoginEntity.ConnectionStringName).GetById(ColumnCode);
                ViewBag.lstViewName = new SelectList(lstViewName, objReportColumnSetup.View_Name);

                #region --- DROPDOWN ---
                //ViewBag.lstIsPart = new SelectList(lstIsPart, objReportColumnSetup.IsPartofSelectOnly);
                //if (objReportColumnSetup.IsPartofSelectOnly == "Y")
                //{
                //    ViewBag.lstIsPart = new SelectList(lstIsPart, "Yes");
                //}
                //if (objReportColumnSetup.IsPartofSelectOnly == "N")
                //{
                //    ViewBag.lstIsPart = new SelectList(lstIsPart, "No");
                //}
                //if (objReportColumnSetup.IsPartofSelectOnly == "B")
                //{
                //    ViewBag.lstIsPart = new SelectList(lstIsPart, "Both");
                //}

                //List<SelectListItem> lstViewName = new List<SelectListItem>();
                //lstViewName.Add(new SelectListItem { Text = "", Value = "" });
                //lstViewName.Add(new SelectListItem { Text = "", Value = "" });
                #endregion
            }

            ViewBag.CommandName = commandName;

            return PartialView("_AddEditReportColumnSetup", objReportColumnSetup);
        }

        public JsonResult SaveReportColumnSetup(Report_Column_Setup objRepColSetup)
        {
            string status = "S";
            string message = "";
            Report_Column_Setup_Service report_Column_Setup_Service = new Report_Column_Setup_Service(objLoginEntity.ConnectionStringName);

            List<Report_Column_Setup> templstRCS = report_Column_Setup_Service.SearchFor(s => true).Where(w => (w.Display_Name.ToUpper() == objRepColSetup.Display_Name.ToUpper()) && (w.View_Name == objRepColSetup.View_Name) && (w.Display_Order == objRepColSetup.Display_Order) && w.Column_Code != objRepColSetup.Column_Code).ToList();

            if (templstRCS.Count == 0)
            {
                if (objRepColSetup.Column_Code > 0)
                {
                    objRepColSetup.EntityState = State.Modified;
                }
                else
                {
                    objRepColSetup.EntityState = State.Added;
                }

                #region ---DROPDOWN---
                //if(objRepColSetup.IsPartofSelectOnly == "Yes")
                //{
                //    objRepColSetup.IsPartofSelectOnly = "Y";
                //}
                //if (objRepColSetup.IsPartofSelectOnly == "No")
                //{
                //    objRepColSetup.IsPartofSelectOnly = "N";
                //}
                //if (objRepColSetup.IsPartofSelectOnly == "Both")
                //{
                //    objRepColSetup.IsPartofSelectOnly = "B";
                //}
                #endregion

                if (objRepColSetup.View_Name != null && objRepColSetup.Name_In_DB != null && objRepColSetup.Display_Name != null && objRepColSetup.Valued_As != null && objRepColSetup.Display_Order != null && objRepColSetup.IsPartofSelectOnly != null && objRepColSetup.Max_Length != null)
                {
                    dynamic resultSet;
                    if (!report_Column_Setup_Service.Save(objRepColSetup, out resultSet))
                    {
                        status = "E";
                        message = resultSet;
                    }
                    else
                    {
                        message = objMessageKey.Recordsavedsuccessfully;
                        lstReportColumnSetup_Searched = lstReportColumnSetup = new Report_Column_Setup_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
                    }
                }
                else
                {
                    status = "E";
                    message = "Please fill all mandatory fields";
                }
            }
            else
            {
                status = "E";
                message = "A record for provided set up already exists!";
            }

            var obj = new
            {
                RecordCount = lstReportColumnSetup.Count,
                Status = status,
                Message = message,
            };

            return Json(obj);
        }
    }
}

//Add More mandatory fields after confirmation

//Duplicate ADD more conditions

//Search based parameters

//Numbers Only

//Duplicate Display Order