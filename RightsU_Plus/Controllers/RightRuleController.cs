using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Entities;
//using RightsU_BLL;
using RightsU_Dapper.Entity;
using RightsU_Dapper.BLL.Services;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class RightRuleController : BaseController
    {
        private readonly USP_Service objProcedureService = new USP_Service();
        private readonly Right_Rule_Service objRightRuleService = new Right_Rule_Service();
        //
        // GET: /RightRule/
        #region --- Properties ---
        private List<RightsU_Dapper.Entity.Right_Rule> lstRight_Rule
        {
            get
            {
                if (Session["lstRight_Rule"] == null)
                    Session["lstRight_Rule"] = new List<RightsU_Dapper.Entity.Right_Rule>();
                return (List<RightsU_Dapper.Entity.Right_Rule>)Session["lstRight_Rule"];
            }
            set { Session["lstRight_Rule"] = value; }
        }

        private List<RightsU_Dapper.Entity.Right_Rule> lstRight_Rule_Searched
        {
            get
            {
                if (Session["lstRight_Rule_Searched"] == null)
                    Session["lstRight_Rule_Searched"] = new List<RightsU_Dapper.Entity.Right_Rule>();
                return (List<RightsU_Dapper.Entity.Right_Rule>)Session["lstRight_Rule_Searched"];
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
                lstRight_Rule_Searched = lstRight_Rule = (List<RightsU_Dapper.Entity.Right_Rule>)objRightRuleService.GetList().OrderByDescending(o => o.Last_Updated_Time).ToList();
                ViewBag.RightRuleCode = "";
                ViewBag.Action = "";
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/RightRule/_RgtRule.cshtml", lstRight_Rule_Searched);
               
            }
            else
            {
                //Right_Rule_Service objRightRule_Service = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Right_Rule objRightRule = null;
                if (RightruleCode > 0)
                    objRightRule = objRightRuleService.GetRightRuleByID(RightruleCode);
                else
                    objRightRule = new RightsU_Dapper.Entity.Right_Rule();
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/RightRule/_AddRightRule.cshtml", objRightRule);
               // return PartialView("~/Views/Vendor/_AddEditPartyVendor.cshtml");
            }
        }

        public PartialViewResult BindRight_RuleList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Dapper.Entity.Right_Rule> lst = new List<RightsU_Dapper.Entity.Right_Rule>();
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
            lstRight_Rule_Searched = lstRight_Rule = (List<RightsU_Dapper.Entity.Right_Rule>)objRightRuleService.GetList();
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
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForRightRule), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;
            return rights;
        }
        #endregion

        public JsonResult SaveRuleRight(FormCollection objFormCollection, RightsU_Dapper.Entity.Right_Rule ObjRightRuleMVC)
        {
            string Right_Rule_Name = objFormCollection["Right_Rule_Name"].ToString();
            string Start_Time = Convert.ToString(objFormCollection["Start_Time"]);
            string Play_Per_Day = objFormCollection["Play_Per_Day"].ToString();
            string Duration_Of_Day = objFormCollection["Duration_Of_Day"].ToString();
            string No_Of_Repeat = objFormCollection["No_Of_Repeat"].ToString();
            string Short_Key = objFormCollection["Short_Key"].ToString();
            string FromFirstAir =Convert.ToString(objFormCollection["chkFromFirstAir"]);	

           
            string status = "S", message = "Record {ACTION} successfully";



            //Right_Rule_Service objRight_Rule_Service = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Right_Rule objRight_Rule = new RightsU_Dapper.Entity.Right_Rule();

            if (ObjRightRuleMVC.Right_Rule_Code > 0)
            {
                objRight_Rule = objRightRuleService.GetRightRuleByID(ObjRightRuleMVC.Right_Rule_Code);               
                objRight_Rule.Last_Action_By = objLoginUser.Users_Code;
               // objRight_Rule.EntityState = State.Modified;
            }
            else
            {
                //objRightRuleService.AddEntity(objRight_Rule);
                //objRight_Rule.EntityState = State.Added;
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
        
         string resultSet;
            bool isDuplicate = objRightRuleService.Validate(objRight_Rule, out resultSet);
            if (isDuplicate)
            {
                if (ObjRightRuleMVC.Right_Rule_Code > 0)
                {
                    objRightRuleService.UpdateGenres(objRight_Rule);
                    message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    objRightRuleService.AddEntity(objRight_Rule);
                    message = objMessageKey.RecordAddedSuccessfully;
                }    
            }
            else
            {
                status = "E";
                message = resultSet;
            }
                //bool isValid = objRight_Rule_Service.Save(objRight_Rule, out resultSet);
                bool isValid = true;
            
                if (ObjRightRuleMVC.Right_Rule_Code > 0)
                {
                    int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                    ViewBag.Alert = message;
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
            //Right_Rule_Service objRightRule_Service = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Right_Rule objRightRule = null;
            if (RightruleCode > 0)
                objRightRule = objRightRuleService.GetRightRuleByID(RightruleCode);
            else
                objRightRule = new RightsU_Dapper.Entity.Right_Rule();

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

            //Right_Rule_Service objService = new Right_Rule_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Right_Rule objRight_Rule = objRightRuleService.GetRightRuleByID(Convert.ToInt32(Right_Rule_Code));
            objRight_Rule.Right_Rule_Name = Right_Rule_Name;
            objRight_Rule.Start_Time = Start_Time;
            objRight_Rule.Play_Per_Day = Convert.ToInt32(Play_Per_Day);
            objRight_Rule.Duration_Of_Day = Convert.ToInt32(Duration_Of_Day);
            objRight_Rule.No_Of_Repeat = Convert.ToInt32(No_Of_Repeat);
            objRight_Rule.Short_Key = Short_Key;
            objRight_Rule.Last_Action_By = objLoginUser.Users_Code;
            objRight_Rule.Last_Updated_Time = System.DateTime.Now;
            // objRight_Rule.EntityState = State.Modified;
            
             string resultSet;
            string status = "S", message = "Record {ACTION} successfully";
            bool isDuplicate = objRightRuleService.Validate(objRight_Rule, out resultSet);
            if (isDuplicate)
            {
                objRightRuleService.UpdateGenres(objRight_Rule); 
            }
            else
            {
                status = "";
                message = resultSet;
            }
            
            ViewBag.RightRuleCode = "";
            ViewBag.Action = "";
            RedirectToAction("index");

            // bool isValid = objService.Save(objRight_Rule, out resultSet);
            bool isValid = true;
            if (isValid)
            {
                //ask abhay
                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                lstRight_Rule.Where(w => w.Right_Rule_Code == Convert.ToInt32(Right_Rule_Code)).First();
                lstRight_Rule_Searched.Where(w => w.Right_Rule_Code == Convert.ToInt32(Right_Rule_Code)).First();
                ViewBag.Alert = message; 
            }
            else
            {
                status = "E";
                message = "";
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
                //Right_Rule_Service objService = new /*Right_Rule_Service*/(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Right_Rule objRight_Rule = objRightRuleService.GetRightRuleByID(Convert.ToInt32(RightruleCode));


                objRight_Rule.Is_Active = doActive;
                objRightRuleService.UpdateGenres(objRight_Rule);
                // objRight_Rule.EntityState = State.Modified;
                dynamic resultSet;
                //bool isValid = objService.Save(objRight_Rule, out resultSet);
                bool isValid = true;
                if (isValid)
                {
                    lstRight_Rule.Where(w => w.Right_Rule_Code == RightruleCode).First().Is_Active = doActive;
                    lstRight_Rule_Searched.Where(w => w.Right_Rule_Code == RightruleCode).First().Is_Active = doActive;

                    if (doActive == "Y")
                        //message = message.Replace("{ACTION}", "Activated");
                        message = objMessageKey.Recordactivatedsuccessfully;
                    else
                        //message = message.Replace("{ACTION}", "Deactivated");
                        message = objMessageKey.Recorddeactivatedsuccessfully;
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
 