﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;


namespace RightsU_Plus.Controllers
{
    public class ExtendedColumn_MetadataController : BaseController
    {
        #region Sessions
        private RightsU_BLL.Extended_Columns_Service objExtended_Columns_Service
        {
            get
            {
                if (Session["objExtended_Columns_Service"] == null)
                    Session["objExtended_Columns_Service"] = new Extended_Columns_Service(objLoginEntity.ConnectionStringName);
                return (Extended_Columns_Service)Session["objExtended_Columns_Service"];
            }
            set { Session["objExtended_Columns_Service"] = value; }
        }

        private List<RightsU_Entities.Extended_Columns> lstExtended_Columns_Searched
        {
            get
            {
                if (Session["lstExtended_Columns_Searched"] == null)
                    Session["lstExtended_Columns_Searched"] = new List<RightsU_Entities.Extended_Columns>();
                return (List<RightsU_Entities.Extended_Columns>)Session["lstExtended_Columns_Searched"];
            }
            set { Session["lstExtended_Columns_Searched"] = value; }
        }

        private RightsU_Entities.Extended_Columns objExtended_Columns
        {
            get
            {
                if (Session["objExtended_Columns"] == null)
                    Session["objExtended_Columns"] = new RightsU_Entities.Extended_Columns();
                return (RightsU_Entities.Extended_Columns)Session["objExtended_Columns"];
            }
            set { Session["objExtended_Columns"] = value; }
        }
        #endregion

        #region UI_Methods
        public ActionResult Index()
        {
            ViewBag.Message = "";
            FetchData();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Column Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Column Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            if (Session["Message"] != null)
            {                                            //-----To add edit success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }
            return View();
        }

        public PartialViewResult BindExtendeList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.Extended_Columns> lst = new List<RightsU_Entities.Extended_Columns>();
            int RecordCount = 0;
            RecordCount = lstExtended_Columns_Searched.Count;
            Session["TotalRecord"] = RecordCount;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstExtended_Columns_Searched.OrderByDescending(o => o.Columns_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstExtended_Columns_Searched.OrderBy(o => o.Columns_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else
                {
                    lst = lstExtended_Columns_Searched.OrderByDescending(o => o.Columns_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }
            return PartialView("~/Views/ExtendedColumn_Metadata/_ExtendedColumnList.cshtml", lst);
        }

        private void FetchData()
        {
            objExtended_Columns_Service = null;
            lstExtended_Columns_Searched = objExtended_Columns_Service.SearchFor(x => true).OrderBy(o => o.Columns_Code).ToList();
        }

        public JsonResult SearchExtended_Columns(string searchText)
        {
            FetchData();
            if (!string.IsNullOrEmpty(searchText))
            {
                lstExtended_Columns_Searched = lstExtended_Columns_Searched.Where(w => w.Columns_Name.ToUpper().Contains(searchText.ToUpper())
                || w.Control_Type.ToUpper().Contains(searchText.ToUpper())//).ToList();
                || w.Ref_Table != null && w.Ref_Table.ToUpper().Contains(searchText.ToUpper())
                || w.Ref_Display_Field != null && w.Ref_Display_Field.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                FetchData();
            }
            var obj = new
            {
                Record_Count = lstExtended_Columns_Searched.Count
            };
            return Json(obj);
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
        #endregion

        #region Extended_Column
        public ActionResult Create()
        {
            objExtended_Columns = null;
            return View();
        }
        [HttpPost]
        public ActionResult Create(Extended_Columns objEC)
        {
            string Message = "";
            string Status = "";
            objExtended_Columns_Service = null;

            objExtended_Columns.Columns_Name = objEC.Columns_Name;
            objExtended_Columns.Control_Type = objEC.Control_Type;
            objExtended_Columns.Is_Ref = objEC.Is_Ref;
            objExtended_Columns.Is_Defined_Values = objEC.Is_Defined_Values;
            objExtended_Columns.Is_Multiple_Select = objEC.Is_Multiple_Select;
            objExtended_Columns.Ref_Table = objEC.Ref_Table;
            objExtended_Columns.Ref_Display_Field = objEC.Ref_Display_Field;
            objExtended_Columns.Ref_Value_Field = objEC.Ref_Value_Field;
            objExtended_Columns.Additional_Condition = objEC.Additional_Condition;
            objExtended_Columns.Is_Add_OnScreen = objEC.Is_Add_OnScreen;

            foreach (Extended_Columns_Value ObjEV in objExtended_Columns.Extended_Columns_Value)
            {
                ObjEV.Columns_Value_Code = 0;
                objExtended_Columns.Extended_Columns_Value.Add(ObjEV);
            }

            objExtended_Columns.EntityState = State.Added;

            dynamic resultSet;
            if (!objExtended_Columns_Service.Save(objExtended_Columns, out resultSet))
            {
                Status = "E";
                Message = resultSet;
            }
            else
            {
                Status = "S";
                Session["Message"] = objMessageKey.Recordsavedsuccessfully;
            }
            var Obj = new
            {
                Status = Status,
                Message = Message
            };

            return Json(Obj);
        }
        public ActionResult Edit(int id)
        {
            objExtended_Columns = null;
            objExtended_Columns_Service = null;
            objExtended_Columns = objExtended_Columns_Service.GetById(id);

            return View("Create", objExtended_Columns);
        }
        [HttpPost]
        public ActionResult Edit(int id, Extended_Columns objEC)
        {
            string Message = "";
            string Status = "";
            objExtended_Columns = null;
            objExtended_Columns = objExtended_Columns_Service.GetById(id);

            objExtended_Columns.Columns_Code = id;
            objExtended_Columns.Columns_Name = objEC.Columns_Name;
            objExtended_Columns.Control_Type = objEC.Control_Type;
            objExtended_Columns.Is_Ref = objEC.Is_Ref;
            objExtended_Columns.Is_Defined_Values = objEC.Is_Defined_Values;
            objExtended_Columns.Is_Multiple_Select = objEC.Is_Multiple_Select;
            objExtended_Columns.Ref_Table = objEC.Ref_Table;
            objExtended_Columns.Ref_Display_Field = objEC.Ref_Display_Field;
            objExtended_Columns.Ref_Value_Field = objEC.Ref_Value_Field;
            objExtended_Columns.Additional_Condition = objEC.Additional_Condition;
            objExtended_Columns.Is_Add_OnScreen = objEC.Is_Add_OnScreen;

            foreach (Extended_Columns_Value ObjEV in objExtended_Columns.Extended_Columns_Value)
            {
                if (ObjEV.Columns_Value_Code < 0)
                {
                    ObjEV.EntityState = State.Added;
                    ObjEV.Columns_Value_Code = 0;
                    ObjEV.Columns_Code = id;
                    objExtended_Columns.Extended_Columns_Value.Add(ObjEV);
                }
                else
                {
                    ObjEV.EntityState = State.Modified;
                    objExtended_Columns.Extended_Columns_Value.Add(ObjEV);
                }
            }
            objExtended_Columns.EntityState = State.Modified;
            dynamic resultSet;


            if (!objExtended_Columns_Service.Save(objExtended_Columns, out resultSet))
            {
                Status = "E";
                Message = resultSet;
                DeleteSessionUpdatedData();
            }
            else
            {
                Status = "S";
                Session["Message"] = objMessageKey.Recordupdatedsuccessfully;
                DeleteSessionUpdatedData();
            }
            var Obj = new
            {
                Status = Status,
                Message = Message
            };

            return Json(Obj);
        }
        public void DeleteSessionUpdatedData()
        {
            dynamic resultSet;
            List<Extended_Columns_Value> LstExcv = new List<Extended_Columns_Value>();
            Extended_Columns_Value_Service ExtCVService = new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName);
            LstExcv = ExtCVService.SearchFor(x => true).OrderBy(o => o.Columns_Value_Code).ToList();
            LstExcv = LstExcv.Where(a => a.Columns_Code == null).ToList();
            foreach (Extended_Columns_Value obj in LstExcv)
            {
                obj.EntityState = State.Deleted;
                ExtCVService.Delete(obj, out resultSet);
            }
        }

        public ActionResult Details(int id)
        {
            objExtended_Columns = null;
            objExtended_Columns_Service = null;

            objExtended_Columns = objExtended_Columns_Service.GetById(id);
            ViewBag.Title = "View";
            return View("Create", objExtended_Columns);
        }
        #endregion

        #region Delete Method
        //public ActionResult Delete(int id)
        //{
        //    objExtended_Columns = null;
        //    objExtended_Columns_Service = null;

        //    objExtended_Columns = objExtended_Columns_Service.GetById(id);
        //    ViewBag.Title = "View";
        //    return View("Create", objExtended_Columns);
        //}

        //[HttpPost]
        //public ActionResult DeleteConfirmed(int id)
        //{
        //    string Message = "";
        //    string Status = "";

        //    //Extended_Columns objEC = new Extended_Columns();
        //    dynamic resultSet;
        //    objExtended_Columns = objExtended_Columns_Service.GetById(id);
        //    if(objExtended_Columns.Extended_Columns_Value.Count > 0)
        //    {
        //        foreach(Extended_Columns_Value ObjExV in objExtended_Columns.Extended_Columns_Value)
        //        {
        //            Extended_Columns_Value ObjEV = objExtended_Columns_Value_Service.GetById(ObjExV.Columns_Value_Code);
        //            ObjEV.EntityState = State.Deleted;
        //            objExtended_Columns_Value_Service.Delete(ObjEV, out resultSet);
        //        }
        //    }

        //    objExtended_Columns.EntityState = State.Deleted;
        //    if (!objExtended_Columns_Service.Delete(objExtended_Columns, out resultSet))
        //    {
        //        Status = "E";
        //        Message = "Oops! Unexpected Error Occured please try Again";
        //    }
        //    else
        //    {
        //        Status = "S";
        //        Session["Message"] = objMessageKey.RecordDeletedsuccessfully;
        //    }
        //    var Obj = new
        //    {
        //        Status = Status,
        //        Message = Message
        //    };

        //    return Json(Obj);
        //}
        #endregion

        #region ExtendedColumn_ValueDeatils
        [HttpPost]
        public ActionResult AddEditEVDetails(int Id, string CommandName)
        {
            Extended_Columns_Value objExtV = new Extended_Columns_Value();
            if (CommandName == "ADD")
            {
                TempData["Action"] = "AddEVDetails";
            }
            if (CommandName == "EDIT")
            {
                objExtV = objExtended_Columns.Extended_Columns_Value.Where(c => c.Columns_Value_Code == Id).FirstOrDefault();
                TempData["Action"] = "EditEVDetails";
                TempData["Id"] = objExtV.Columns_Value_Code;
            }
            if (CommandName == "ShowView")
            {
                ViewBag.HideButton = "HideButton";
            }
            return PartialView("~/Views/ExtendedColumn_Metadata/_ExtendedColumnValueList.cshtml", objExtended_Columns.Extended_Columns_Value);
        }
        public ActionResult SaveEVDetails(string ColumnValue)
        {
            int result = 0;
            Extended_Columns_Value objEV = new Extended_Columns_Value();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            objEV.Columns_Value = ColumnValue;
            result = Valid(objEV);
            if (result == 1)
            {
                if (objExtended_Columns.Extended_Columns_Value.Count == 0)
                {
                    objEV.Columns_Value_Code = -1;
                }
                else
                {
                    objEV.Columns_Value_Code = Convert.ToInt32(Session["TempId"]) - 1;
                }
                Session["TempId"] = objEV.Columns_Value_Code;

                objExtended_Columns.Extended_Columns_Value.Add(objEV);
            }
            else
            {
                obj.Add("Error", "1");
                return Json(obj);
            }
            obj.Add("Status", "S");
            return Json(obj);
        }

        public ActionResult EditEVDetails(int Id, string ColumnValue)
        {
            int result = 0;
            Extended_Columns_Value ObjEV = objExtended_Columns.Extended_Columns_Value.Where(d => d.Columns_Value_Code == Id).FirstOrDefault();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            ObjEV.Columns_Value = ColumnValue;
            ObjEV.Columns_Value_Code = Id;
            result = Valid(ObjEV);
            if (result == 1)
            {
                objExtended_Columns.Extended_Columns_Value.Append(ObjEV);
            }
            else
            {
                obj.Add("Error", "1");
                return Json(obj);
            }
            obj.Add("Status", "S");
            return Json(obj);
        }
        public ActionResult DeleteEVDetails(int Id)
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            Extended_Columns_Value ObjEV = objExtended_Columns.Extended_Columns_Value.Where(d => d.Columns_Value_Code == Id).FirstOrDefault();
            objExtended_Columns.Extended_Columns_Value.Remove(ObjEV);

            if (objExtended_Columns.Extended_Columns_Value.Count == 0)
            {
                obj.Add("Enable", "IsDefinedValue");
            }

            obj.Add("Status", "S");
            return Json(obj);
        }

        public int Valid(Extended_Columns_Value obj)
        {
            int result = 0;
            List<Extended_Columns_Value> TempList = new List<Extended_Columns_Value>();
            if (obj.Columns_Value_Code == 0)
            {
                TempList = objExtended_Columns.Extended_Columns_Value.Where(x => x.Columns_Value.ToUpper() == obj.Columns_Value.ToUpper()).ToList();
            }
            else
            {
                TempList = objExtended_Columns.Extended_Columns_Value.Where(x => (x.Columns_Value.ToUpper() == obj.Columns_Value.ToUpper()) && (x.Columns_Value_Code != obj.Columns_Value_Code)).ToList();
            }
            if (TempList.Count == 0)
            {
                result = 1;
            }
            else
            {
                result = 2;
            }
            return result;
        }
        #endregion
    }
}