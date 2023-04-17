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

        private List<RightsU_Entities.Extended_Group> lstExtended_Group_Searched
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
            lstExtended_Group_Searched = lstExtended_Group = objExtended_Group_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        public ActionResult BindExtendedGroupList(int pageNo, int recordPerPage, string sortType)
        {
            List<Extended_Group> lst = new List<Extended_Group>();

            int RecordCount = 0;
            RecordCount = lstExtended_Group_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstExtended_Group_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstExtended_Group_Searched.OrderBy(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstExtended_Group_Searched.OrderByDescending(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
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
                lstExtended_Group_Searched = lstExtended_Group.Where(w => w.Group_Name != null && w.Group_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else if (searchText == "" && ModuleCode != null)
            {
                lstExtended_Group_Searched = lstExtended_Group.Where(w => w.Module_Code != null && w.Module_Code.ToString().Contains(ModuleCode.ToString())).ToList();
            }
            else if (!string.IsNullOrEmpty(searchText) && ModuleCode != null)
            {
                lstExtended_Group_Searched = lstExtended_Group.Where(w => (w.Group_Name != null && w.Group_Name.ToUpper().Contains(searchText.ToUpper())) && (w.Module_Code != null && w.Module_Code.ToString().Contains(ModuleCode.ToString()))).ToList();
            }
            else
                lstExtended_Group_Searched = lstExtended_Group;

            var obj = new
            {
                Record_Count = lstExtended_Group_Searched.Count
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
            lstValidation.Add(new SelectListItem { Text = "Reference", Value = "ref" });
            lstValidation.Add(new SelectListItem { Text = "0 or 1", Value = "0 & 1" });
            ViewBag.ddlValidation = lstValidation;

            List<SelectListItem> lstDisplayFor = new List<SelectListItem>();
            lstDisplayFor.Add(new SelectListItem { Text = "Movie", Value = "M" });
            lstDisplayFor.Add(new SelectListItem { Text = "Show", Value = "S" });
            lstDisplayFor.Add(new SelectListItem { Text = "Both", Value = "B" });
            ViewBag.ddlDisplayFor = lstDisplayFor;

            List<SelectListItem> lstImportType = new List<SelectListItem>();
            lstImportType.Add(new SelectListItem { Text = "Only Export", Value = "E" });
            lstImportType.Add(new SelectListItem { Text = "Only Import", Value = "I" });
            lstImportType.Add(new SelectListItem { Text = "Both", Value = "B" });
            ViewBag.ddlImportType = lstImportType;

            foreach (Extended_Group_Config EGCDetail in objExtended_Group.Extended_Group_Config)
            {
                Extended_Columns objEDCS = objExtended_Columns_Service.SearchFor(s => true).Where(w => w.Columns_Code == EGCDetail.Columns_Code).FirstOrDefault();
            }

            if (Id != 0)
            {
                lst = lst.Where(a => a.Extended_Group_Config_Code == Id).ToList();

                //--------------------------------------------DDLMetadata--------------------------------------------------------
                Extended_Group_Config Detail = lst.FirstOrDefault();
                List<Extended_Columns> lstExtndClmns = objExtended_Columns_Service.SearchFor(s => true).ToList();
                ViewBag.ddlMetadata = new SelectList(lstExtndClmns, "Columns_Code", "Columns_Name", Detail.Columns_Code);

                //--------------------------------------------DDLValidation------------------------------------------------------
                if (Detail.Validations == null)
                {
                    ViewBag.SelectedValidation = new MultiSelectList(lstValidation, "Value", "Text");
                }
                else
                {
                    List<string> SelectedValue = lstValidation.Where(w => Detail.Validations.Split(',').ToList().Any(a => w.Value == a)).Select(s => s.Value).ToList();
                    ViewBag.SelectedValidation = new MultiSelectList(lstValidation, "Value", "Text", SelectedValue);
                }

                //--------------------------------------------DDLDisplayFor------------------------------------------------------
                if (Detail.Display_Name == null)
                {
                    ViewBag.SelectedDisplay = new SelectList(lstDisplayFor, "Value", "Text");
                }
                else
                {
                    string SelectedDisplayFor = lstDisplayFor.Where(w => Detail.Display_Name.Any(a => w.Value == a.ToString())).Select(s => s.Value).FirstOrDefault();
                    ViewBag.SelectedDisplay = new SelectList(lstDisplayFor, "Value", "Text", SelectedDisplayFor);
                }

                //--------------------------------------------DDLImportType------------------------------------------------------
                if (Detail.Allow_Import == null)
                {
                    ViewBag.SelectedImportType = new SelectList(lstImportType, "Value", "Text");
                }
                else
                {
                    string SelectedImportTypeValue = lstImportType.Where(w => Detail.Allow_Import.Any(a => w.Value == a.ToString())).Select(s => s.Value).FirstOrDefault();
                    ViewBag.SelectedImportType = new SelectList(lstImportType, "Value", "Text", SelectedImportTypeValue);
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
                DeleteSessionData();
                if (ExtdGrpId == 0)
                {
                    Session["Message"] = objMessageKey.Recordsavedsuccessfully;
                }
                else
                {
                    Session["Message"] = objMessageKey.Recordupdatedsuccessfully;
                }
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
                objEDGC.Inter_Group_Name = objEGC.Inter_Group_Name;
                objEDGC.Display_Name = objEGC.Display_Name;
                objEDGC.Allow_Import = objEGC.Allow_Import;
                objEDGC.Is_Active = "Y";

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
                    objEDGC.Inter_Group_Name = objEGC.Inter_Group_Name;
                    objEDGC.Display_Name = objEGC.Display_Name;
                    objEDGC.Allow_Import = objEGC.Allow_Import;
                    objEDGC.Is_Active = "Y";

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

        public JsonResult ActivateDeactivateGrpDtl(string ActiveAction, int GrpDtlCode)
        {
            string Status = "";
            string Message = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            Extended_Group_Config objEDGC = new Extended_Group_Config();

            if (GrpDtlCode != 0)
            {
                objEDGC = objExtended_Group.Extended_Group_Config.Where(w => w.Extended_Group_Config_Code == GrpDtlCode).FirstOrDefault();
                objEDGC.Is_Active = ActiveAction;

                objExtended_Group.Extended_Group_Config.Append(objEDGC);

                if (objEDGC != null)
                {
                    Status = "S";
                    if (ActiveAction == "Y")
                    {
                        Message = objMessageKey.Recordactivatedsuccessfully;
                    }
                    else
                    {
                        Message = objMessageKey.Recorddeactivatedsuccessfully;
                    }
                }
                else
                {
                    Status = "E";
                    if (ActiveAction == "Y")
                    {
                        Message = objMessageKey.CouldNotActivatedRecord;
                    }
                    else
                    {
                        Message = objMessageKey.CouldNotDeactivatedRecord;
                    }
                }
            }
            var Obj = new
            {
                Status = Status,
                Message = Message
            };
            return Json(Obj);
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

        #region ---Activate-Deactivate---
        //public JsonResult ActivateDeactivateExtdGrp(string ActiveAction, int ExtdGrpCode)
        //{
        //    string status = "S";
        //    string message = "";

        //    objExtended_Group = null;

        //    if (ExtdGrpCode > 0)
        //    {
        //        objExtended_Group = objExtended_Group_Service.GetById(ExtdGrpCode);
        //        objExtended_Group.EntityState = State.Modified;
        //    }
        //    //objExtended_Group.Is_Active = ActiveAction;
        //    if (objExtended_Group != null)
        //    {
        //        if (ActiveAction == "Y")
        //        {
        //            message = objMessageKey.Recordactivatedsuccessfully;
        //        }
        //        else
        //        {
        //            message = objMessageKey.Recorddeactivatedsuccessfully;
        //        }
        //    }
        //    else
        //    {
        //        if (ActiveAction == "Y")
        //        {
        //            message = objMessageKey.CouldNotActivatedRecord;
        //        }
        //        else
        //        {
        //            message = objMessageKey.CouldNotDeactivatedRecord;
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
        //        status = "S";
        //        message = resultSet;
        //    }

        //    var obj = new
        //    {               
        //        Status = status,
        //        Message = message
        //    };
        //    return Json(obj);
        //}
        #endregion

    }
}