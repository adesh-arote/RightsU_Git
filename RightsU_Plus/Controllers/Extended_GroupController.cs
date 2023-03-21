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
    public class Extended_GroupController : BaseController
    {
        #region --- Properties ---
        private List<RightsU_Entities.Extended_Group> lstExtended_Group
        {
            get
            {
                if (Session["lstExtended_Group"] == null)
                    Session["lstExtended_Group"] = new List<RightsU_Entities.Extended_Group>();
                return (List<RightsU_Entities.Extended_Group>)Session["lstExtended_Group"];
            }
            set { Session["lstExtended_Group"] = value; }
        }

        private List<RightsU_Entities.Extended_Group> lstlstExtended_Group_Searched
        {
            get
            {
                if (Session["lstlstExtended_Group_Searched"] == null)
                    Session["lstlstExtended_Group_Searched"] = new List<RightsU_Entities.Extended_Group>();
                return (List<RightsU_Entities.Extended_Group>)Session["lstlstExtended_Group_Searched"];
            }
            set { Session["lstlstExtended_Group_Searched"] = value; }
        }

        private RightsU_Entities.Extended_Group objExtended_Group
        {
            get
            {
                if (Session["objExtended_Group"] == null)
                    Session["objExtended_Group"] = new RightsU_Entities.Extended_Group();
                return (RightsU_Entities.Extended_Group)Session["objExtended_Group"];
            }
            set { Session["objExtended_Group"] = value; }
        }

        private Extended_Group_Service objExtended_Group_Service
        {
            get
            {
                if (Session["objExtended_Group_Service"] == null)
                    Session["objExtended_Group_Service"] = new Extended_Group_Service(objLoginEntity.ConnectionStringName);
                return (Extended_Group_Service)Session["objExtended_Group_Service"];
            }
            set { Session["objExtended_Group_Service"] = value; }
        }
        #endregion

        //-----------------------------------------------------Paging--------------------------------------------------------------------------------------

        public ActionResult Index()
        {
            FetchData();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            if (Session["Message"] != null)
            {                                            //-----To add edit success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }

            ViewBag.UserModuleRights = GetUserModuleRights();

            return View();
        }

        private void FetchData()
        {
            Extended_Group_Service objExtended_Group_Service = new Extended_Group_Service(objLoginEntity.ConnectionStringName);
            lstlstExtended_Group_Searched = lstExtended_Group = objExtended_Group_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        public ActionResult BindExtendedGroupList(int pageNo, int recordPerPage, string sortType)
        {
            List<Extended_Group> lst = new List<Extended_Group>();
        
            int RecordCount = 0;
            RecordCount = lstlstExtended_Group_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstlstExtended_Group_Searched.OrderByDescending(o => o.Extended_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstlstExtended_Group_Searched.OrderBy(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstlstExtended_Group_Searched.OrderByDescending(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            ViewBag.UserModuleRights = GetUserModuleRights();

            return PartialView("_ExtendedGroupList", lst);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
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

        public JsonResult SearchExtendedGroup(string searchText, int? ModuleCode)
        {
            if (!string.IsNullOrEmpty(searchText) && ModuleCode == null)
            {
                lstlstExtended_Group_Searched = lstExtended_Group.Where(w => w.Group_Name != null && w.Group_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else if (searchText == "" && ModuleCode != null)
            {
                lstlstExtended_Group_Searched = lstExtended_Group.Where(w => w.Module_Code != null && w.Module_Code.ToString().Contains(ModuleCode.ToString())).ToList();
            }
            else if (!string.IsNullOrEmpty(searchText) && ModuleCode != null)
            {
                lstlstExtended_Group_Searched = lstExtended_Group.Where(w => (w.Group_Name != null && w.Group_Name.ToUpper().Contains(searchText.ToUpper())) && (w.Module_Code != null && w.Module_Code.ToString().Contains(ModuleCode.ToString()))).ToList();
            }
            else
                lstlstExtended_Group_Searched = lstExtended_Group;

            var obj = new
            {
                Record_Count = lstlstExtended_Group_Searched.Count
            };

            return Json(obj);
        }

        public JsonResult CheckRecordLock(int Extended_Group_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Extended_Group_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Extended_Group_Code, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        //------------------------------------------------------PopUp--------------------------------------------------------------------------------------

        public PartialViewResult AddEditViewExtdGrp(int ExtendedGroupCode, string CommandName)
        {
            objExtended_Group = null;
            objExtended_Group_Service = null;

            //Extended_Group_Service objExtended_Group_Service = new Extended_Group_Service(objLoginEntity.ConnectionStringName);

            int count = lstExtended_Group.Where(w => w.Extended_Group_Code == ExtendedGroupCode).Count();
            if (count > 0)
            {
                objExtended_Group = objExtended_Group_Service.GetById(ExtendedGroupCode);
            }
            ViewBag.CommandName = CommandName;

            return PartialView("_AddEditViewExtdGrp", objExtended_Group);
        }

        public PartialViewResult BindExtdGrpDetail(int Id, string CommandName)
        {
            List<Extended_Group_Config> lst = objExtended_Group.Extended_Group_Config.ToList();

            Extended_Columns_Service objExtended_Columns_Service = new Extended_Columns_Service(objLoginEntity.ConnectionStringName);
            Extended_Group_Config_Service objExtended_Group_Config_Service = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName);

            List<Extended_Columns> lstExtendedColumns = objExtended_Columns_Service.SearchFor(s => true).ToList();
            ViewBag.ddlMetadata = new SelectList(lstExtendedColumns, "Columns_Code", "Columns_Name");
            ViewBag.ddlMetaData2 = lstExtendedColumns;

            List<SelectListItem> lstValidation = new List<SelectListItem>();
            lstValidation.Add(new SelectListItem { Text = "Mandatory", Value = "man" });
            lstValidation.Add(new SelectListItem { Text = "Duplicate", Value = "dup" });
            ViewBag.ddlValidation = lstValidation;

            foreach (Extended_Group_Config EGCDetail in objExtended_Group.Extended_Group_Config)
            {
                Extended_Columns objEDCS = objExtended_Columns_Service.SearchFor(s => true).Where(w => w.Columns_Code == EGCDetail.Columns_Code).FirstOrDefault();
            }

            if (Id != 0)
            {
                lst = lst.Where(a => a.Extended_Group_Config_Code == Id).ToList();

                Extended_Group_Config Detail = lst.FirstOrDefault();
                List<Extended_Columns> lstExtndClmns = objExtended_Columns_Service.SearchFor(s => true).ToList();
                ViewBag.ddlMetadata = new SelectList(lstExtndClmns, "Columns_Code", "Columns_Name", Detail.Columns_Code);
             
                if (Detail.Validations == "man,dup" || Detail.Validations == "dup,man")
                {
                    ViewBag.SelectedValidation = new MultiSelectList(lstValidation, "Value", "Text", lstValidation.Select(s => s.Value));
                }
                else
                {
                    ViewBag.SelectedValidation = new SelectList(lstValidation, "Value", "Text", Detail.Validations);
                }               


                ViewBag.DetailId = Detail.Extended_Group_Config_Code;
                lst = objExtended_Group.Extended_Group_Config.ToList();
            }

            ViewBag.CommandName = CommandName;
            return PartialView("_AddEditViewDetail", lst);
        }

        //------------------------------------------------------CRUD---------------------------------------------------------------------------------------

        public ActionResult SaveMaster(int ExtdGrpId, Extended_Group objEg)
        {
            string Message = "";
            string Status = "";

            Dictionary<string, object> obj = new Dictionary<string, object>();
            //Extended_Group_Service objExtended_Group_Service = new Extended_Group_Service(objLoginEntity.ConnectionStringName);
            Extended_Group_Config_Service objExtended_Columns_Config_Service = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName);
            List<Extended_Group> lstExtendedGroup = objExtended_Group_Service.SearchFor(s => true).ToList();
            var LastId = lstExtendedGroup.OrderBy(a => a.Extended_Group_Code).LastOrDefault();

            if (ExtdGrpId != 0)
            {
                objExtended_Group = objExtended_Group_Service.GetById(ExtdGrpId);

                objExtended_Group.Module_Code = objEg.Module_Code;
                objExtended_Group.Group_Name = objEg.Group_Name;
                objExtended_Group.Short_Name = objEg.Short_Name;
                objExtended_Group.Group_Order = objEg.Group_Order;
                objExtended_Group.Add_Edit_Type = objEg.Add_Edit_Type;
                objExtended_Group.Last_Updated_Time = DateTime.Now;
                objExtended_Group.Last_Action_By = objLoginUser.Users_Code;

                objExtended_Group.EntityState = State.Modified;
            }
            else
            {
                objExtended_Group.Module_Code = objEg.Module_Code;
                objExtended_Group.Group_Name = objEg.Group_Name;
                objExtended_Group.Short_Name = objEg.Short_Name;
                objExtended_Group.Group_Order = objEg.Group_Order;
                objExtended_Group.Add_Edit_Type = objEg.Add_Edit_Type;
                objExtended_Group.Inserted_On = DateTime.Now;
                objExtended_Group.Inserted_By = objLoginUser.Users_Code;
                objExtended_Group.Extended_Group_Code = LastId.Extended_Group_Code + 1;

                objExtended_Group.EntityState = State.Added;
            }

            foreach (Extended_Group_Config ObjEGC in objExtended_Group.Extended_Group_Config)
            {
                if (ObjEGC.Extended_Group_Config_Code < 0)
                {
                    ObjEGC.Extended_Group_Config_Code = 0;
                    ObjEGC.Extended_Group_Code = ExtdGrpId;
                    ObjEGC.EntityState = State.Added;
                    objExtended_Group.Extended_Group_Config.Add(ObjEGC);
                }
                else
                {
                    ObjEGC.EntityState = State.Modified;
                    objExtended_Group.Extended_Group_Config.Add(ObjEGC);
                }
            }

            dynamic resultSet;
            if (!objExtended_Group_Service.Save(objExtended_Group, out resultSet))
            {
                Status = "E";
                Message = resultSet;
                DeleteSessionData();
            }
            else
            {
                Status = "S";
                Session["Message"] = objMessageKey.Recordsavedsuccessfully;
                DeleteSessionData();
            }

            var Obj = new
            {
                Status = Status,
                Message = Message
            };

            return Json(Obj);
        }

        public ActionResult SaveGrpDetail(int Id, Extended_Group_Config objEGC)
        {
            int result = 0;

            Extended_Group_Config objEDGC = new Extended_Group_Config();
            //objEDGC =  objExtended_Group.Extended_Group_Config.Where(w => w.Extended_Group_Config_Code == Id).FirstOrDefault();
            Dictionary<string, object> obj = new Dictionary<string, object>();


            if (Id == 0)
            {
                objEDGC.Columns_Code = Convert.ToInt32(objEGC.Columns_Code);
                objEDGC.Group_Control_Order = objEGC.Group_Control_Order;
                objEDGC.Validations = objEGC.Validations;
                objEDGC.Additional_Condition = objEGC.Additional_Condition;

                result = ValidEGCDetail(objEDGC);
                if (result == 1)
                {
                    if (objExtended_Group.Extended_Group_Config.Count == 0)
                    {
                        objEDGC.Extended_Group_Config_Code = -1;
                    }
                    else
                    {
                        objEDGC.Extended_Group_Config_Code = Convert.ToInt32(Session["TempId"]) - 1;
                    }
                    Session["TempId"] = objEDGC.Extended_Group_Config_Code;

                    objExtended_Group.Extended_Group_Config.Add(objEDGC);
                }
                else
                {
                    obj.Add("Error", "1");
                    return Json(obj);
                }
            }
            else
            {
                if (Id != 0)
                {
                    objEDGC = objExtended_Group.Extended_Group_Config.Where(w => w.Extended_Group_Config_Code == Id).FirstOrDefault();

                    objEDGC.Columns_Code = Convert.ToInt32(objEGC.Columns_Code);
                    objEDGC.Group_Control_Order = objEGC.Group_Control_Order;
                    objEDGC.Validations = objEGC.Validations;
                    objEDGC.Additional_Condition = objEGC.Additional_Condition;

                    result = ValidEGCDetail(objEDGC);
                    if (result == 1)
                    {
                        objExtended_Group.Extended_Group_Config.Append(objEDGC);
                    }
                    else
                    {
                        obj.Add("Error", "1");
                        return Json(obj);
                    }
                }
                else
                {
                    obj.Add("Error", "1");
                    return Json(obj);
                }
            }

            obj.Add("Status", "S");
            return Json(obj);
        }

        public ActionResult DeleteGrpDetail(int DetailId)
        {
            string status = "S";
            string message = "";

            Dictionary<string, object> obj = new Dictionary<string, object>();
            Extended_Group_Config objdtl = objExtended_Group.Extended_Group_Config.Where(w => w.Extended_Group_Config_Code == DetailId).FirstOrDefault();

            if (objdtl != null)
            {
                objExtended_Group.Extended_Group_Config.Remove(objdtl);
            }
            else
            {
                status = "E";
                message = "Object not found";
            }

            obj.Add("Status", "S");
            return Json(obj);
        }

        public void DeleteSessionData()
        {
            dynamic resultSet;
            List<Extended_Group_Config> LstExGC = new List<Extended_Group_Config>();
            Extended_Group_Config_Service objExtended_Group_Config_Service = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName);
            LstExGC = objExtended_Group_Config_Service.SearchFor(x => true).OrderBy(o => o.Extended_Group_Config_Code).ToList();
            LstExGC = LstExGC.Where(a => a.Extended_Group_Code == null).ToList();
            foreach (Extended_Group_Config obj in LstExGC)
            {
                obj.EntityState = State.Deleted;
                objExtended_Group_Config_Service.Delete(obj, out resultSet);
            }
        }

        public int ValidEGCDetail(Extended_Group_Config obj)
        {
            int result = 0;
            List<Extended_Group_Config> TempList = new List<Extended_Group_Config>();
            if (obj.Extended_Group_Config_Code == 0)
            {
                TempList = objExtended_Group.Extended_Group_Config.Where(x => (x.Columns_Code == obj.Columns_Code) || (x.Group_Control_Order == obj.Group_Control_Order)).ToList();
            }
            else
            {
                TempList = objExtended_Group.Extended_Group_Config.Where(x => ((x.Columns_Code == obj.Columns_Code) || (x.Group_Control_Order == obj.Group_Control_Order)) && (x.Extended_Group_Config_Code != obj.Extended_Group_Config_Code)).ToList();
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

    }
}


#region  ----KACHARA----
//public ActionResult SaveGrpDetail(int Id, int Metadata, int OrdrerInGroup, string Validations)
//{
//    Dictionary<string, object> obj = new Dictionary<string, object>();
//    Extended_Columns_Service objExtended_Columns_Service = new Extended_Columns_Service(objLoginEntity.ConnectionStringName);
//    Extended_Group_Config_Service objExtended_Columns_Config_Service = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName);

//    Extended_Group_Config objEGC = objExtended_Group.Extended_Group_Config.Where(w => w.Extended_Group_Config_Code == Id).FirstOrDefault();

//    if (objEGC == null)
//    {
//        if (objExtended_Group.Extended_Group_Config.Count == 0)
//        {
//            objEGC = new Extended_Group_Config();
//            objEGC.Extended_Group_Config_Code = -1;

//            objEGC.EntityState = State.Added;
//            objExtended_Group.Extended_Group_Config.Add(objEGC);
//        }
//        else
//        {
//            objEGC = new Extended_Group_Config();
//            objEGC.Extended_Group_Config_Code = Convert.ToInt32(Session["TempId"]) - 1;
//            objEGC.EntityState = State.Added;
//            objExtended_Group.Extended_Group_Config.Add(objEGC);
//        }
//    }
//    else
//    {
//        if (objEGC.Extended_Group_Config_Code > 0)
//            objEGC.EntityState = State.Modified;
//    }

//    Session["TempId"] = objEGC.Extended_Group_Config_Code;

//    if (objEGC.EntityState == State.Added || (objEGC.EntityState == State.Modified && objEGC.Extended_Group_Config_Code < 0))
//    {
//        objEGC.Extended_Columns = objExtended_Columns_Service.GetById(Metadata);
//    }

//    Extended_Group_Config objExtended_Group_Config = objExtended_Columns_Config_Service.GetById(Id);

//    if (objEGC.EntityState == State.Modified && objEGC.Extended_Group_Config_Code > 0)
//    {
//        objEGC.Extended_Columns = objExtended_Columns_Service.GetById(Metadata);            
//    }

//    objEGC.Columns_Code = Metadata;
//    objEGC.Group_Control_Order = OrdrerInGroup;
//    objEGC.Validations = Validations;

//    TempData["getMetada"] = Metadata;

//    obj.Add("Status", "S");
//    return Json(obj);
//}

//public ActionResult SaveMaster(int ExtdGrpId, int Module, string GrpName, string ShortName, int GrpOrder, string GrpType)
//{
//    Dictionary<string, object> obj = new Dictionary<string, object>();
//    Extended_Group_Service objExtended_Group_Service = new Extended_Group_Service(objLoginEntity.ConnectionStringName);
//    Extended_Group_Config_Service objExtended_Columns_Config_Service = new Extended_Group_Config_Service(objLoginEntity.ConnectionStringName);
//    List<Extended_Group> lstExtendedGroup = objExtended_Group_Service.SearchFor(s => true).ToList();
//    var LastId = lstExtendedGroup.OrderBy(a => a.Extended_Group_Code).LastOrDefault();

//    string status = "S", message = "";

//    if (ExtdGrpId > 0)
//        objExtended_Group.EntityState = State.Modified;
//    else
//    {
//        objExtended_Group_Service = null;
//        objExtended_Group.EntityState = State.Added;
//    }
//    objExtended_Group.Module_Code = Module;
//    objExtended_Group.Group_Name = GrpName;
//    objExtended_Group.Short_Name = ShortName;
//    objExtended_Group.Group_Order = GrpOrder;
//    objExtended_Group.Add_Edit_Type = GrpType;

//    foreach (Extended_Group_Config EGCDetail in objExtended_Group.Extended_Group_Config)
//    {
//        if (EGCDetail.EntityState == State.Added)
//        {
//            EGCDetail.Columns_Code = null;
//        }
//        if (EGCDetail.EntityState == State.Modified && EGCDetail.Extended_Group_Config_Code < 0)
//        {
//            EGCDetail.EntityState = State.Added;
//            EGCDetail.Columns_Code = null;
//        }
//        if (EGCDetail.EntityState == State.Modified && EGCDetail.Extended_Group_Config_Code > 0)
//        {
//            EGCDetail.EntityState = State.Modified;
//            Extended_Group_Config objDetail = objExtended_Columns_Config_Service.GetById(EGCDetail.Extended_Group_Config_Code);
//            if (objDetail.Columns_Code != objDetail.Columns_Code)
//            {
//                objDetail.Columns_Code = null;
//            }
//        }
//    }

//    dynamic resultSet;
//    if (!objExtended_Group_Service.Save(objExtended_Group, out resultSet))
//    {
//        status = "E";
//        message = resultSet;
//    }
//    else
//    {
//        if (ExtdGrpId > 0)
//            message = objMessageKey.Recordupdatedsuccessfully;
//        else
//            message = objMessageKey.Recordsavedsuccessfully;

//        objExtended_Group = null;
//        objExtended_Group_Service = null;
//        FetchData();
//    }
//    obj.Add("Status", "S");
//    return Json(obj);
//}
#endregion