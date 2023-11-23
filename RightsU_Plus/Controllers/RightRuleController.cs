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
    public class RightRuleController : BaseController
    {
        //
        // GET: /RightRule/

        #region --- Properties ---

        private List<RightsU_Entities.Right_Rule> lstRight_Rule
        {
            get
            {
                if (Session["lstRight_Rule"] == null)
                    Session["lstRight_Rule"] = new List<RightsU_Entities.Right_Rule>();
                return (List<RightsU_Entities.Right_Rule>)Session["lstRight_Rule"];
            }
            set { Session["lstRight_Rule"] = value; }
        }

        private List<RightsU_Entities.Right_Rule> lstRight_Rule_Searched
        {
            get
            {
                if (Session["lstRight_Rule_Searched"] == null)
                    Session["lstRight_Rule_Searched"] = new List<RightsU_Entities.Right_Rule>();
                return (List<RightsU_Entities.Right_Rule>)Session["lstRight_Rule_Searched"];
            }
            set { Session["lstRight_Rule_Searched"] = value; }
        }

        private string ModuleCode
        {
            get
            {
                if (Session["ModuleCode"] == null)
                {
                    Session["ModuleCode"] = 0;
                }
                return Convert.ToString(Session["ModuleCode"].ToString());
            }
            set
            {
                Session["ModuleCode"] = value;
            }
        }

        #endregion

        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForRightRule);
            //ModuleCode = Request.QueryString["modulecode"];
            ModuleCode = GlobalParams.ModuleCodeForRightRule.ToString();
            return View("~/Views/RightRule/Index.cshtml");
        }

        public PartialViewResult BindPartialPages(string key, int RightruleCode)
        {
            if (key == "LIST")
            {
                ViewBag.Code = ModuleCode;
                ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
                List<SelectListItem> lstSort = new List<SelectListItem>();
                lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
                ViewBag.SortType = lstSort;
                lstRight_Rule_Searched = lstRight_Rule = new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
                ViewBag.RightRuleCode = "";
                ViewBag.Action = "";
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/RightRule/_RgtRule.cshtml", lstRight_Rule_Searched);
               
            }
            else
            {
                Right_Rule_Service objRightRule_Service = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Right_Rule objRightRule = null;
                if (RightruleCode > 0)
                    objRightRule = objRightRule_Service.GetById(RightruleCode);
                else
                    objRightRule = new RightsU_Entities.Right_Rule();
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/RightRule/_AddRightRule.cshtml", objRightRule);
               // return PartialView("~/Views/Vendor/_AddEditPartyVendor.cshtml");
            }
        }

        public PartialViewResult BindRight_RuleList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.Right_Rule> lst = new List<RightsU_Entities.Right_Rule>();
            int RecordCount = 0;
            RecordCount = lstRight_Rule_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstRight_Rule_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstRight_Rule_Searched.OrderBy(o => o.Right_Rule_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstRight_Rule_Searched.OrderByDescending(o => o.Right_Rule_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/RightRule/_RightRule.cshtml", lst);
        }

        public JsonResult SearchRightRule(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstRight_Rule_Searched = lstRight_Rule.Where(w => w.Right_Rule_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstRight_Rule_Searched = lstRight_Rule;

            var obj = new
            {
                Record_Count = lstRight_Rule_Searched.Count
            };
            return Json(obj);
        }

        private void FetchData()
        {
            lstRight_Rule_Searched = lstRight_Rule = new Right_Rule_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
        }

        #region  --- Other Methods ---

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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForRightRule), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();
            return rights;
        }

        #endregion

        public JsonResult SaveRuleRight(FormCollection objFormCollection,RightsU_Entities.Right_Rule ObjRightRuleMVC)
        {
            string Right_Rule_Name = objFormCollection["Right_Rule_Name"].ToString();
            string Start_Time = Convert.ToString(objFormCollection["Start_Time"]);
            string Play_Per_Day = objFormCollection["Play_Per_Day"].ToString();
            string Duration_Of_Day = objFormCollection["Duration_Of_Day"].ToString();
            string No_Of_Repeat = objFormCollection["No_Of_Repeat"].ToString();
            string Short_Key = objFormCollection["Short_Key"].ToString();
            string FromFirstAir =Convert.ToString(objFormCollection["chkFromFirstAir"]);	
       
            string status = "S", message = "Record {ACTION} successfully";

            Right_Rule_Service objRight_Rule_Service = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Right_Rule objRight_Rule = new RightsU_Entities.Right_Rule();

            if (ObjRightRuleMVC.Right_Rule_Code > 0)
            {
                objRight_Rule = objRight_Rule_Service.GetById(ObjRightRuleMVC.Right_Rule_Code);               
                objRight_Rule.Last_Action_By = objLoginUser.Users_Code;
                objRight_Rule.EntityState = State.Modified;
            }
            else
            {
                objRight_Rule.EntityState = State.Added;
                objRight_Rule.Inserted_By = objLoginUser.Users_Code;
                objRight_Rule.Inserted_On = System.DateTime.Now;
                objRight_Rule.Is_Active = "Y";
            }

            objRight_Rule.Right_Rule_Name = Right_Rule_Name;
            objRight_Rule.Start_Time = Start_Time;
            objRight_Rule.Play_Per_Day = Convert.ToInt32(Play_Per_Day);
            objRight_Rule.Duration_Of_Day = Convert.ToInt32(Duration_Of_Day);
            objRight_Rule.No_Of_Repeat = Convert.ToInt32(No_Of_Repeat);
            objRight_Rule.Short_Key = Short_Key;
            objRight_Rule.Last_Updated_Time = System.DateTime.Now;

            if(FromFirstAir != null)
            {
                objRight_Rule.Start_Time = "00:00";
                objRight_Rule.IS_First_Air = true;
            }
            else
            {
                objRight_Rule.IS_First_Air = false;
            }
        
            dynamic resultSet;
            bool isValid = objRight_Rule_Service.Save(objRight_Rule, out resultSet);
            if (isValid)
            {
                string Action = "C";
                if (ObjRightRuleMVC.Right_Rule_Code > 0)
                {
                    int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                    status = "S";
                    message = objMessageKey.Recordupdatedsuccessfully;
                    ViewBag.Alert = message;
                    Action = "U";
                }
                else
                {
                    status = "S";
                    message = objMessageKey.RecordAddedSuccessfully;
                    Action = "C";
                }

                try
                {
                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objRight_Rule);
                    bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForRightRule), Convert.ToInt32(objRight_Rule.Right_Rule_Code), LogData, Action, objLoginUser.Users_Code);
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

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
         
        }

        public ActionResult AddEditRightRule(int RightruleCode)
        {
            Right_Rule_Service objRightRule_Service = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Right_Rule objRightRule = null;
            if (RightruleCode > 0)
                objRightRule = objRightRule_Service.GetById(RightruleCode);
            else
                objRightRule = new RightsU_Entities.Right_Rule();

            return View("~/Views/RightRule/AddRightRule.cshtml", objRightRule);
        }

        public ActionResult UpdateRightRule(FormCollection objFormCollection)
        {
            string Right_Rule_Code = objFormCollection["RightruleCode"].ToString();
            string Right_Rule_Name = objFormCollection["Right_Rule_Name"].ToString();
            string Start_Time = objFormCollection["Start_Time"].ToString();
            string Play_Per_Day = objFormCollection["Play_Per_Day"].ToString();
            string Duration_Of_Day = objFormCollection["Duration_Of_Day"].ToString();
            string No_Of_Repeat = objFormCollection["No_Of_Repeat"].ToString();
            string Short_Key = objFormCollection["Short_Key"].ToString();

            Right_Rule_Service objService = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.Right_Rule objRight_Rule = objService.GetById(Convert.ToInt32(Right_Rule_Code));
            objRight_Rule.Right_Rule_Name = Right_Rule_Name;
            objRight_Rule.Start_Time = Start_Time;
            objRight_Rule.Play_Per_Day = Convert.ToInt32(Play_Per_Day);
            objRight_Rule.Duration_Of_Day = Convert.ToInt32(Duration_Of_Day);
            objRight_Rule.No_Of_Repeat = Convert.ToInt32(No_Of_Repeat);
            objRight_Rule.Short_Key = Short_Key;
            objRight_Rule.Last_Action_By = objLoginUser.Users_Code;
            objRight_Rule.Last_Updated_Time = System.DateTime.Now;
            objRight_Rule.EntityState = State.Modified;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully";
            ViewBag.RightRuleCode = "";
            ViewBag.Action = "";
            RedirectToAction("index"); 

            bool isValid = objService.Save(objRight_Rule, out resultSet);
            if (isValid)
            {
                //ask abhay
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                lstRight_Rule.Where(w => w.Right_Rule_Code == Convert.ToInt32(Right_Rule_Code)).First();
                lstRight_Rule_Searched.Where(w => w.Right_Rule_Code == Convert.ToInt32(Right_Rule_Code)).First();
                status = "S";
                message = objMessageKey.Recordupdatedsuccessfully;
                ViewBag.Alert = message; 
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
         //   return Json(obj);
          //  return View("~/Views/RightRule/AddRightRule.cshtml");
            return RedirectToAction("Index");

              
        }

        public JsonResult CheckRecordLock(int RightruleCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (RightruleCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(RightruleCode, GlobalParams.ModuleCodeForRightRule, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public ActionResult ActiveDeactiveRightRule(int RightruleCode, string doActive)
        {
             string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(RightruleCode, GlobalParams.ModuleCodeForRightRule, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                Right_Rule_Service objService = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.Right_Rule objRight_Rule = objService.GetById(Convert.ToInt32(RightruleCode));


                objRight_Rule.Is_Active = doActive;
                objRight_Rule.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = objService.Save(objRight_Rule, out resultSet);
                if (isValid)
                {
                    string Action = "A";
                    lstRight_Rule.Where(w => w.Right_Rule_Code == RightruleCode).First().Is_Active = doActive;
                    lstRight_Rule_Searched.Where(w => w.Right_Rule_Code == RightruleCode).First().Is_Active = doActive;

                    if (doActive == "Y")
                    {
                        //message = message.Replace("{ACTION}", "Activated");
                        message = objMessageKey.Recordactivatedsuccessfully;
                        Action = "A";
                    }                        
                    else
                    {
                        //message = message.Replace("{ACTION}", "Deactivated");
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                        Action = "DA";
                    }

                    try
                    {
                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objRight_Rule);
                        bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(Convert.ToInt32(GlobalParams.ModuleCodeForRightRule), Convert.ToInt32(objRight_Rule.Right_Rule_Code), LogData, Action, objLoginUser.Users_Code);
                    }
                    catch (Exception ex)
                    {

                    }
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }

                objCommonUtil.Release_Record(RLCode, objLoginEntity.ConnectionStringName);
            }

            else
            {
                status = "E";
                message = strMessage;
            }
            ViewBag.Alert = message; 
            var obj = new
            {
                Status = status,
                Message = message
            };

           //return Json(obj);
           // return View("~/Views/RightRule/AddRightRule.cshtml");

            return Json(obj);
        }
    }
}
 