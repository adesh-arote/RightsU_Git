
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
//using RightsU_Entities;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    
    public class MaterialTypeController : BaseController
    {
        private readonly Material_Type_Service objMaterialTypeService = new Material_Type_Service();
        private readonly USP_Service objProcedureService = new USP_Service();
        #region --- Properties ---
        private List<RightsU_Dapper.Entity.Material_Type> lstMaterialType
        {
            get
            {
                if (Session["lstMaterialType"] == null)
                    Session["lstMaterialType"] = new List<RightsU_Dapper.Entity.Material_Type>();
                return (List<RightsU_Dapper.Entity.Material_Type>)Session["lstMaterialType"];
            }
            set { Session["lstMaterialType"] = value; }
        }

        private List<RightsU_Dapper.Entity.Material_Type> lstMaterialType_Searched
        {
            get
            {
                if (Session["lstMaterialType_Searched"] == null)
                    Session["lstMaterialType_Searched"] = new List<RightsU_Dapper.Entity.Material_Type>();
                return (List<RightsU_Dapper.Entity.Material_Type>)Session["lstMaterialType_Searched"];
            }
            set { Session["lstMaterialType_Searched"] = value; }
        }

        #endregion


        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMaterialType);
            //string modulecode = Request.QueryString["modulecode"];
            string modulecode = GlobalParams.ModuleCodeForMaterialType.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstMaterialType_Searched = lstMaterialType = objMaterialTypeService.GetList().OrderByDescending(o=>o.Last_Updated_Time).ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/MaterialType/Index.cshtml");
        }

        public PartialViewResult BindMaterialTypeList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Dapper.Entity.Material_Type> lst = new List<RightsU_Dapper.Entity.Material_Type>();
            int RecordCount = 0;
            RecordCount = lstMaterialType_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstMaterialType_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstMaterialType_Searched.OrderBy(o => o.Material_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstMaterialType_Searched.OrderByDescending(o => o.Material_Type_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/MaterialType/_MaterialTypeList.cshtml", lst);
        }

        #region  --- Other Methods ---
        public JsonResult CheckRecordLock(int Material_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Material_Code > 0)
            {
                isLocked = DBUtil.Lock_Record(Material_Code, GlobalParams.ModuleCodeForMaterialType, objLoginUser.Users_Code, out RLCode, out strMessage);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
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
        private string GetUserModuleRights()
        {
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMaterialType), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights!= null)
                rights = lstRights;

            return rights;
        }
        #endregion

        public JsonResult SearchMaterialType(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstMaterialType_Searched = lstMaterialType.Where(w => w.Material_Type_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstMaterialType_Searched = lstMaterialType;

            var obj = new
            {
                Record_Count = lstMaterialType_Searched.Count
            };
            return Json(obj);
        }

        #region --- CRUD Method ---

        public JsonResult ActiveDeactiveMaterialType(int materialTypeCode, string doActive)
        {
             string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(materialTypeCode, GlobalParams.ModuleCodeForMaterialType, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
           // string status = "S", message = "Record {ACTION} successfully";
            //Material_Type_Service objService = new Material_Type_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Material_Type objMaterialType = objMaterialTypeService.GetMaterial_TypeByID(materialTypeCode);
            objMaterialType.Is_Active = doActive;
                //objMaterialType.EntityState = State.Modified;
                objMaterialTypeService.UpdateGenres(objMaterialType);
                dynamic resultSet;
                //  bool isValid = objService.Save(objMaterialType, out resultSet);
                bool isValid = true;
            if (isValid)
            {
                lstMaterialType.Where(w => w.Material_Type_Code == materialTypeCode).First().Is_Active = doActive;
                lstMaterialType_Searched.Where(w => w.Material_Type_Code == materialTypeCode).First().Is_Active = doActive;
            }
            else
            {
                status = "E";
                message = "Cound not {ACTION} record";
            }
            if (doActive == "Y")
                //message = message.Replace("{ACTION}", "Activated");
                message = objMessageKey.Recordactivatedsuccessfully;
            else
                //message = message.Replace("{ACTION}", "Deactivated");
                message = objMessageKey.Recorddeactivatedsuccessfully;
                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);
            }
            else
            {
                status = "E";
                message = strMessage;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult AddEditMaterialTypeList(int materialTypeCode, string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";
            if (commandName == "ADD")
            {
                TempData["Action"] = "AddMaterialType";
            }
            else if (commandName == "EDIT")
            {
                //Material_Type_Service objService = new Material_Type_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Material_Type objMaterialType = objMaterialTypeService.GetMaterial_TypeByID(materialTypeCode);
                TempData["Action"] = "EditMaterialType";
                TempData["idMaterialType"] = objMaterialType.Material_Type_Code;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveUpdateMaterialTypeList(FormCollection objFormCollection)
        {
            int recordCount = 0;
            int materialTypeCode = Convert.ToInt32(objFormCollection["materialTypeCode"]);
            string status = "S", message = "Record {ACTION} successfully";
            //Material_Type_Service objService = new Material_Type_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Material_Type objMaterialType = new RightsU_Dapper.Entity.Material_Type();
            if (materialTypeCode != 0)
            {
                string str_Material_Type_Name = objFormCollection["Material_Type_Name"].ToString().Trim();
                objMaterialType = objMaterialTypeService.GetMaterial_TypeByID(materialTypeCode);
                objMaterialType.Material_Type_Name = str_Material_Type_Name;
                objMaterialType.Last_Action_By = objLoginUser.Users_Code;
                //objMaterialType.EntityState = State.Modified;      
            }
            else
            {
                string str_Material_Type_Name = objFormCollection["Material_Type_Name"].ToString().Trim();   
                objMaterialType = new RightsU_Dapper.Entity.Material_Type();
                objMaterialType.Is_Active = "Y";
                objMaterialType.Material_Type_Name = str_Material_Type_Name;
                objMaterialType.Inserted_By = objLoginUser.Users_Code;
                objMaterialType.Inserted_On = System.DateTime.Now;
                //objMaterialType.EntityState = State.Added;         
            }
            objMaterialType.Last_Updated_Time = System.DateTime.Now;
            string resultSet;
            bool isDuplicate = objMaterialTypeService.Validate(objMaterialType, out resultSet);
            if (isDuplicate)
            {
                if (materialTypeCode != 0)
                {
                    objMaterialTypeService.UpdateGenres(objMaterialType);
                }
                else
                {
                    objMaterialTypeService.AddEntity(objMaterialType);
                }
            }
            else
            {
                status = "";
                message = resultSet;
            }
                //bool isDuplicate = objService.Validate(objMaterialType, out resultSet);
            
                //bool isValid = objService.Save(objMaterialType, out resultSet);
                bool isValid = true;
                if (isValid)
                {
                    lstMaterialType_Searched = lstMaterialType = objMaterialTypeService.GetList().OrderByDescending(o=>o.Last_Updated_Time).ToList();

                    int recordLockingCode = Convert.ToInt32(objFormCollection["Record_Code"]);
                    DBUtil.Release_Record(recordLockingCode);
                    if (materialTypeCode > 0)
                        //message = message.Replace("{ACTION}", "updated");
                        message = objMessageKey.Recordupdatedsuccessfully;
                    else
                        //message = message.Replace("{ACTION}", "added");
                        message = objMessageKey.RecordAddedSuccessfully;
                }
                else
                {
                    
                    status = "E";
                    message = "";
                }
           
            var obj = new
            {
                recordCount = lstMaterialType.Count(),
                Status = status,
                Message = message
            };
            return Json(obj);
        }  

        #endregion
    }
}
