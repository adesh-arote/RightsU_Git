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
    public class MaterialMediumController : BaseController
    {
        #region --- Properties ---

        private List<RightsU_Entities.Material_Medium> lstMaterialMedium
        {
            get
            {
                if (Session["lstMaterialMedium"] == null)
                    Session["lstMaterialMedium"] = new List<RightsU_Entities.Material_Medium>();
                return (List<RightsU_Entities.Material_Medium>)Session["lstMaterialMedium"];
            }
            set { Session["lstMaterialMedium"] = value; }
        }

        private List<RightsU_Entities.Material_Medium> lstMaterialMedium_Searched
        {
            get
            {
                if (Session["lstMaterialMedium_Searched"] == null)
                    Session["lstMaterialMedium_Searched"] = new List<RightsU_Entities.Material_Medium>();
                return (List<RightsU_Entities.Material_Medium>)Session["lstMaterialMedium_Searched"];
            }
            set { Session["lstMaterialMedium_Searched"] = value; }
        }

        #endregion

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMaterialMedium);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForMaterialMedium.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            lstMaterialMedium_Searched = lstMaterialMedium = new Material_Medium_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o=>o.Last_Updated_Time).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/MaterialMedium/Index.cshtml");
        }
 
        public PartialViewResult BindMaterialMediumList(int pageNo, int recordPerPage ,string sortType)
        {
            List<RightsU_Entities.Material_Medium> lst = new List<RightsU_Entities.Material_Medium>();
            int RecordCount = 0;
            RecordCount = lstMaterialMedium_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstMaterialMedium_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstMaterialMedium_Searched.OrderBy(o => o.Material_Medium_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstMaterialMedium_Searched.OrderByDescending(o => o.Material_Medium_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/MaterialMedium/_MaterialMediumList.cshtml", lst);
        }

        #region  --- Other Methods ---

        public JsonResult CheckRecordLock(int Material_Medium_Code)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Material_Medium_Code > 0)
            {
                isLocked = DBUtil.Lock_Record(Material_Medium_Code, GlobalParams.ModuleCodeForMaterialMedium, objLoginUser.Users_Code, out RLCode, out strMessage);
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMaterialMedium), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        #endregion

        public JsonResult SearchMaterialMedium(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstMaterialMedium_Searched = lstMaterialMedium.Where(w => w.Material_Medium_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstMaterialMedium_Searched = lstMaterialMedium;

            var obj = new
            {
                Record_Count = lstMaterialMedium_Searched.Count
            };
            return Json(obj);
        }

        #region --- CRUD Method ---

        public JsonResult ActiveDeactiveMaterialMedium(int MaterialMediumCode, string doActive)
        {
             string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(MaterialMediumCode, GlobalParams.ModuleCodeForMaterialMedium, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                string Action = "A";
                //string status = "S", message = "Record {ACTION} successfully";
                Material_Medium_Service objService = new Material_Medium_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Material_Medium objMaterialMedium = objService.GetById(MaterialMediumCode);
                objMaterialMedium.Is_Active = doActive;
                objMaterialMedium.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objMaterialMedium, out resultSet);
                if (isValid)
                {
                    lstMaterialMedium.Where(w => w.Material_Medium_Code == MaterialMediumCode).First().Is_Active = doActive;
                    lstMaterialMedium_Searched.Where(w => w.Material_Medium_Code == MaterialMediumCode).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                {
                    //message = message.Replace("{ACTION}", "Activated");
                    message = objMessageKey.Recordactivatedsuccessfully;
                    Action = "A";
                }
                else
                {
                    message = objMessageKey.Recorddeactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Deactivated");
                    Action = "DA";
                }

                try
                {
                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objMaterialMedium);
                    bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForMaterialMedium), Convert.ToInt32(objMaterialMedium.Material_Medium_Code), LogData, Action, objLoginUser.Users_Code);
                }
                catch (Exception ex)
                {

                }

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

        public JsonResult AddEditMaterialMediumList(int MaterialMediumCode,string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";
            if (commandName == "ADD")
            {
                TempData["Action"] = "AddMaterialMedium";
            }
            else if (commandName == "EDIT")
            {
                Material_Medium_Service objService = new Material_Medium_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Material_Medium objMaterialMedium = objService.GetById(MaterialMediumCode);
                TempData["Action"] = "EditMaterialMedium";
                TempData["idMaterialMedium"] = objMaterialMedium.Material_Medium_Code;
            }         
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveUpdateMaterialMediumList(FormCollection objFormCollection)
        {
            int recordCount = 0;
            string status = "S", message = "Record {ACTION} successfully";
            int int_Duration = 0;
            int MaterialMediumCode = Convert.ToInt32(objFormCollection["MaterialMediumCode"]);
            Material_Medium_Service objService = new Material_Medium_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Material_Medium objMaterialMedium = new RightsU_Entities.Material_Medium();
            if (MaterialMediumCode != 0)
            {
                string str_Material_Medium_Name = objFormCollection["Material_Medium_Name"].ToString().Trim();
                if (objFormCollection["Duration"] != "")
                {
                    int_Duration = Convert.ToInt32(objFormCollection["Duration"]);
                }
                string str_Type = objFormCollection["Type"].ToString();
                string str_QC = objFormCollection["QC"].ToString();
                objMaterialMedium = objService.GetById(MaterialMediumCode);
                objMaterialMedium.Material_Medium_Name = str_Material_Medium_Name;
                if (str_Type == "NA" || str_Type == "")
                {
                    objMaterialMedium.Type = null;
                    objMaterialMedium.Duration = 0;
                }
                else
                {
                    objMaterialMedium.Type = str_Type;
                    objMaterialMedium.Duration = int_Duration;
                }
                objMaterialMedium.Is_Qc_Required = str_QC;
                objMaterialMedium.Last_Action_By = objLoginUser.Users_Code;
                objMaterialMedium.EntityState = State.Modified;
            }
            else
            {
                string str_Material_Medium_Name = objFormCollection["Material_Medium_Name"].ToString().Trim();
                if (objFormCollection["Duration"] != "")
                {
                    int_Duration = Convert.ToInt32(objFormCollection["Duration"]);
                }
                string str_Type = objFormCollection["Type"].ToString();
                string chr_QC = objFormCollection["QC"].ToString();

                objMaterialMedium = new RightsU_Entities.Material_Medium();
                objMaterialMedium.Is_Active = "Y";
                objMaterialMedium.Material_Medium_Name = str_Material_Medium_Name;
                if (str_Type == "NA")
                {
                    objMaterialMedium.Type = null;
                    objMaterialMedium.Duration = 0;
                }
                else
                {
                    objMaterialMedium.Type = str_Type;
                    objMaterialMedium.Duration = int_Duration;
                }
                objMaterialMedium.Is_Qc_Required = chr_QC;
                objMaterialMedium.Inserted_By = objLoginUser.Users_Code;
                objMaterialMedium.Inserted_On = System.DateTime.Now;
                objMaterialMedium.EntityState = State.Added;
            }
            objMaterialMedium.Last_Updated_Time = System.DateTime.Now;
            dynamic resultSet;
            bool isDuplicate = objService.Validate(objMaterialMedium, out resultSet);
            if (isDuplicate)
            {
                bool isValid = objService.Save(objMaterialMedium, out resultSet);
                if (isValid)
                {
                    string Action = "C";
                    lstMaterialMedium_Searched = lstMaterialMedium = new Material_Medium_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o=>o.Last_Updated_Time).ToList();

                    int recordLockingCode = Convert.ToInt32(objFormCollection["Record_Code"]);
                    DBUtil.Release_Record(recordLockingCode);

                    if (MaterialMediumCode > 0)
                    {
                        Action = "U";
                        message = objMessageKey.Recordupdatedsuccessfully;
                        //message = message.Replace("{ACTION}", "updated");
                    }
                    else
                    {
                        Action = "C";
                        //message = message.Replace("{ACTION}", "added");
                        message = objMessageKey.RecordAddedSuccessfully;
                    }

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objMaterialMedium);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForMaterialMedium), Convert.ToInt32(objMaterialMedium.Material_Medium_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }
                }
                else
                {
                    status = "E";
                    message = resultSet;
                }
            }
            else
            {
                status = "E";
                message = resultSet;
            }
            var obj = new
            {
                recordCount = lstMaterialMedium.Count(),
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion
    }
}
