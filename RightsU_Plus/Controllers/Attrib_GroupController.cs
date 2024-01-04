using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;


namespace RightsU_Plus.Controllers
{
    public class Attrib_GroupController : BaseController
    {
        #region  --Properties--
        private List<RightsU_Entities.Attrib_Group> lstAttribGroup
        {
            get
            {
                if (Session["lstAttribGroup"] == null)
                    Session["lstAttribGroup"] = new List<RightsU_Entities.Attrib_Group>();
                return (List<RightsU_Entities.Attrib_Group>)Session["lstAttribGroup"];
            }
            set { Session["lstAttribGroup"] = value; }
        }
        private List<RightsU_Entities.Attrib_Group> lstAttribGroup_Searched
        {
            get
            {
                if (Session["lstAttribGroup_Searched"] == null)
                    Session["lstAttribGroup_Searched"] = new List<RightsU_Entities.Attrib_Group>();
                return (List<RightsU_Entities.Attrib_Group>)Session["lstAttribGroup_Searched"];
            }
            set { Session["lstAttribGroup_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            lstAttribGroup_Searched = lstAttribGroup = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
           // lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            return View();
        }

        public PartialViewResult BindAttribGroup_List(int pageNo, int recordPerPage, string sortType, int attribCode, string commandName)
        {
            ViewBag.Attrib_Group_Code = attribCode;
            ViewBag.CommandName = commandName;
            int RecordCount = 0;
            RecordCount = lstAttribGroup_Searched.Count;
            List<RightsU_Entities.Attrib_Group> lst = new List<RightsU_Entities.Attrib_Group>();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "NA")
                {
                    lst = lstAttribGroup_Searched.OrderBy(o => o.Attrib_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else
                {
                    lst = lstAttribGroup_Searched.OrderByDescending(o => o.Attrib_Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }
            var AttribCode = new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Attrib_Group_Code == attribCode).Select(x => x.Attrib_Type).FirstOrDefault();
            ViewBag.AttribType = new SelectList(new Attrib_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).GroupBy(z => z.Attrib_Type).Select(x => x.FirstOrDefault()).ToList(), "Attrib_Type", "Attrib_Type", AttribCode);

            
            return PartialView("~/Views/Attrib_Group/_AttribGroupList.cshtml", lst);
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

        public JsonResult SearchAttribGroup(string searchText)
        {
            Attrib_Group_Service objService = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);
            if (!string.IsNullOrEmpty(searchText))
            {
                lstAttribGroup_Searched = lstAttribGroup.Where(w => w.Attrib_Group_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstAttribGroup_Searched = lstAttribGroup;


            var obj = new
            {
                Record_Count = lstAttribGroup_Searched.Count
            };
            return Json(obj);
        }
        
        public JsonResult SaveAttribGroup(int attribCode, string AttribGroupName,string attribeType,string isMultiSelect)
        {
            string status = "S", message = "Record saved successfully";
            if (attribCode > 0)
                message = "Record updated successfully";

            Attrib_Group_Service objService = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Attrib_Group objAttribGroup = null;

            List<Attrib_Group> AtrLst = objService.SearchFor(s => true).ToList();
            var LastId = AtrLst.OrderBy(a => a.Attrib_Group_Code).Last();

            if (attribCode > 0)
            {
                objAttribGroup = objService.GetById(attribCode);
                objAttribGroup.EntityState = State.Modified;
            }
            else
            {
                objAttribGroup = new RightsU_Entities.Attrib_Group();
                objAttribGroup.EntityState = State.Added;
                objAttribGroup.Attrib_Group_Code = LastId.Attrib_Group_Code + 1; 
            }
            objAttribGroup.Attrib_Group_Name = AttribGroupName;
            objAttribGroup.Attrib_Type = attribeType;
            objAttribGroup.Is_Multiple_Select = isMultiSelect;
            objAttribGroup.Is_Active = "Y";

            dynamic resultSet;
            bool isValid = objService.Save(objAttribGroup, out resultSet);

            if (isValid)
            {
                objService = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);
                lstAttribGroup_Searched = lstAttribGroup = objService.SearchFor(s => true).OrderBy(x => x.Attrib_Group_Name).ToList();
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {
                RecordCount = lstAttribGroup_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult EditAttribGroup(int attribCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            var obj = new
            {
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveAttribGroup(int Attrib_Code, string doActive)
        {
            string status = "S", message = "";
          
            Attrib_Group_Service objService = new Attrib_Group_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Attrib_Group objAttribGroup = objService.GetById(Attrib_Code);
            objAttribGroup.Is_Active = doActive;
            objAttribGroup.EntityState = State.Modified;
            dynamic resultSet;

            bool isValid = objService.Save(objAttribGroup, out resultSet);
            if (isValid)
            {
                lstAttribGroup.Where(w => w.Attrib_Group_Code == Attrib_Code).First().Is_Active = doActive;
                lstAttribGroup_Searched.Where(w => w.Attrib_Group_Code == Attrib_Code).First().Is_Active = doActive;
                if (doActive == "Y")
                    message = "Record activated successfully";
                else
                    message = "Record deactivated successfully";
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
    }
}