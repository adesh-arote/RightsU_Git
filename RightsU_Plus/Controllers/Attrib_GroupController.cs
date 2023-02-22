using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;

namespace RightsU_Plus.Controllers
{
    public class Attrib_GroupController : BaseController
    {
        #region
        private List<Attrib_Group> lstAttrib_Group
        {
            get
            {
                if (Session["lstAttrib_Group"] == null)
                    Session["lstAttrib_Group"] = new List<Attrib_Group>();
                return (List<Attrib_Group>)Session["lstAttrib_Group"];
            }
            set
            {
                Session["lstAttrib_Group"] = value;
            }
        }

        private List<Attrib_Group> lstAttrib_Group_Searched
        {
            get
            {
                if (Session["lstAttrib_Group_Searched"] == null)
                    Session["lstAttrib_Group_Searched"] = new List<Attrib_Group>();
                return (List<Attrib_Group>)Session["lstAttrib_Group_Searched"];
            }
            set
            {
                Session["lstAttrib_Group_Searched"] = value;
            }
        }

        private Attrib_Group objAttrib_Group
        {
            get
            {
                if (Session["objAttrib_Group"] == null)
                    Session["objAttrib_Group"] = new Attrib_Group();
                return (Attrib_Group)Session["objAttrib_Group"];
            }
            set
            {
                Session["objAttrib_Group"] = value;
            }
        }


        #endregion

        // GET: Attrib_Group
        public ActionResult Index()
        {
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.LangCode = SysLanguageCode;
            lstAttrib_Group_Searched = lstAttrib_Group = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Ascending", Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "L" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            return View();
        }

        public PartialViewResult BindAttrib_Group_List(int pageNo, int recordPerPage, int Attrib_Group_Code, string commandName, string sortType)
        {
            ViewBag.AttribGroupCode = Attrib_Group_Code;
            ViewBag.CommandName = commandName;
            if (sortType == "AA" || sortType == "AD")
            {
                ViewBag.SortAttrType = sortType;
            }
            List<Attrib_Group> lst = new List<Attrib_Group>();
            lst = lstAttrib_Group.OrderBy(o => o.Attrib_Group_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstAttrib_Group_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstAttrib_Group_Searched.OrderBy(o => o.Attrib_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "L")
                {
                    lst = lstAttrib_Group_Searched.OrderByDescending(o => o.Attrib_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstAttrib_Group_Searched.OrderBy(o => o.Attrib_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lst = lstAttrib_Group_Searched.OrderByDescending(o => o.Attrib_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "AA")
                {
                    lst = lstAttrib_Group_Searched.OrderBy(o => o.Attrib_Type).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else
                {
                    lst = lstAttrib_Group_Searched.OrderByDescending(o => o.Attrib_Type).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }

            if (commandName == "ADD")
            {
                var lstAttribType = lstAttrib_Group.Select(s => s.Attrib_Type).Distinct().ToList();
                ViewBag.AttribType = new SelectList(lstAttribType);

                List<SelectListItem> lstMultiSelect = new List<SelectListItem>();
                lstMultiSelect.Add(new SelectListItem { Text = "Yes", Value = "Y" });
                lstMultiSelect.Add(new SelectListItem { Selected = true, Text = "No", Value = "N" });
                ViewBag.MultiSelect = lstMultiSelect;
            }
            else if (commandName == "EDIT")
            {
                Attrib_Group_Service objAttrib_Group_Service = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);

                objAttrib_Group = objAttrib_Group_Service.GetById(Attrib_Group_Code);
                var lstAttribType = lstAttrib_Group.Select(s => s.Attrib_Type).Distinct().ToList();
                ViewBag.AttribType = new SelectList(lstAttribType, objAttrib_Group.Attrib_Type);

                List<SelectListItem> lstMultiSelect = new List<SelectListItem>();

                if (objAttrib_Group.Is_Multiple_Select == "Y")
                {
                    lstMultiSelect.Add(new SelectListItem { Selected = true, Text = "Yes", Value = "Y" });
                    lstMultiSelect.Add(new SelectListItem { Text = "No", Value = "N" });
                }
                else
                {
                    lstMultiSelect.Add(new SelectListItem { Text = "Yes", Value = "Y" });
                    lstMultiSelect.Add(new SelectListItem { Selected = true, Text = "No", Value = "N" });
                }

                ViewBag.MultiSelect = lstMultiSelect;
            }

            return PartialView("_BindAttribGroupList", lst);
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

        public JsonResult SearchAttrib_Group(string searchText)
        {
            lstAttrib_Group_Searched = lstAttrib_Group = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();

            if (!string.IsNullOrEmpty(searchText))
            {
                lstAttrib_Group_Searched = lstAttrib_Group.Where(a => a.Attrib_Group_Name.ToUpper().Contains(searchText.ToUpper()) || (a.Comment_Name != null && a.Comment_Name.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            else
            {
                lstAttrib_Group_Searched = lstAttrib_Group;
            }

            var obj = new
            {
                Record_Count = lstAttrib_Group_Searched.Count
            };

            return Json(obj);
        }

        public JsonResult SaveAttrib_Group(int Attrib_Group_Code, string Attrib_Group_Name, string Attrib_Type, string Comment_Name, string Is_Multiple_Select)
        {
            string status = "S";
            string message = "";

            List<Attrib_Group> tempLstAttribGrp = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList().Where(a => (a.Attrib_Group_Name == Attrib_Group_Name) && (a.Attrib_Type == Attrib_Type) && (a.Attrib_Group_Code != Attrib_Group_Code)).ToList();

            if (tempLstAttribGrp.Count == 0)
            {
                Attrib_Group_Service objAttrib_Group_Service = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);

                objAttrib_Group = null;

                if (Attrib_Group_Code > 0)
                {
                    objAttrib_Group = objAttrib_Group_Service.GetById(Attrib_Group_Code);
                    objAttrib_Group.EntityState = State.Modified;
                }
                else
                {
                    objAttrib_Group = new Attrib_Group();
                    objAttrib_Group.EntityState = State.Added;
                    Attrib_Group objTempAttrGrp = objAttrib_Group_Service.SearchFor(s => true).OrderByDescending(o => o.Attrib_Group_Code).FirstOrDefault();
                    objAttrib_Group.Attrib_Group_Code = objTempAttrGrp.Attrib_Group_Code + 1;
                }

                objAttrib_Group.Attrib_Group_Name = Attrib_Group_Name;
                objAttrib_Group.Attrib_Type = Attrib_Type;
                objAttrib_Group.Comment_Name = Comment_Name;
                objAttrib_Group.Is_Multiple_Select = Is_Multiple_Select;
                objAttrib_Group.Is_Active = "Y";

                dynamic resultSet;
                if (!objAttrib_Group_Service.Save(objAttrib_Group, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    message = objMessageKey.Recordsavedsuccessfully;
                    lstAttrib_Group_Searched = lstAttrib_Group = objAttrib_Group_Service.SearchFor(s => true).ToList();
                }
            }
            else
            {
                status = "E";
                message = "Entry for this record already Exists!";
            }

            var obj = new
            {
                RecordCount = lstAttrib_Group_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult ActivateDeactivateAttrib_Group(string ActiveAction, int AttGrpCode)
        {
            string status = "S";
            string message = "";

            Attrib_Group_Service objAttrib_Group_Service = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);

            objAttrib_Group = null;

            if (AttGrpCode > 0)
            {
                objAttrib_Group = objAttrib_Group_Service.GetById(AttGrpCode);
                objAttrib_Group.EntityState = State.Modified;
            }
            objAttrib_Group.Is_Active = ActiveAction;
            if (ActiveAction == "Y")
            {
                message = objMessageKey.Recordactivatedsuccessfully;
            }
            else
            {
                message = objMessageKey.Recorddeactivatedsuccessfully;
            }

            dynamic resultSet;
            if (!objAttrib_Group_Service.Save(objAttrib_Group, out resultSet))
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                lstAttrib_Group_Searched = lstAttrib_Group = objAttrib_Group_Service.SearchFor(s => true).ToList();
            }

            var obj = new
            {
                RecordCount = lstAttrib_Group_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult Configuration(int AttribGrpCode, string AttribType, string config)
        {
            string status = "S";
            TempData["AttribGrpCode"] = AttribGrpCode;
            //TempData["AttribGrpName"] = AttribGrpName;
            TempData["AttribType"] = AttribType;
            TempData["config"] = config;

            //RedirectToAction("Create", "Attrib_Reports");
            //return View();
            var obj = new
            {
                status
            };
            return Json(obj);
        }
    }
}

//Config in actions(View)
//Config only available for BV(Business Vertical) and DP(Department)
//Duplication based on Attrib Grp Name and Attrib Type
//Hide Active Status Column