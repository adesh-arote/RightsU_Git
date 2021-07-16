using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Dapper.Entity;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Royalty_RecoupmentController : BaseController
    {
        private readonly Royalty_Recoupment_Service objRoyaltyRecoupmentService = new Royalty_Recoupment_Service();
        private readonly Royalty_Recoupment_Details_Service objRoyalty_Recoupment_Details_Service = new Royalty_Recoupment_Details_Service();
        private readonly Additional_Expense_Services objAdditionalExpenseService = new Additional_Expense_Services();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();

        
        #region --- Properties ---
        private List<RightsU_Dapper.Entity.Royalty_Recoupment> lstRoyalty
        {
            get
            {
                if (Session["lstRoyalty"] == null)
                    Session["lstRoyalty"] = new List<RightsU_Dapper.Entity.Royalty_Recoupment>();
                return (List<RightsU_Dapper.Entity.Royalty_Recoupment>)Session["lstRoyalty"];
            }
            set { Session["lstRoyalty"] = value; }
        }

        private List<RightsU_Dapper.Entity.Royalty_Recoupment> lstRoyalty_Searched
        {
            get
            {
                if (Session["lstRoyalty_Searched"] == null)
                    Session["lstRoyalty_Searched"] = new List<RightsU_Dapper.Entity.Royalty_Recoupment>();
                return (List<RightsU_Dapper.Entity.Royalty_Recoupment>)Session["lstRoyalty_Searched"];
            }
            set { Session["lstRoyalty_Searched"] = value; }
        }
        private List<RightsU_Dapper.Entity.Royalty_Recoupment_Details> RoyaltyRecoupmentDetailsList
        {
            get
            {
                if (Session["RoyaltyRecoupmentDetailsList"] == null)
                    Session["RoyaltyRecoupmentDetailsList"] = new List<RightsU_Dapper.Entity.Royalty_Recoupment_Details>();
                return (List<RightsU_Dapper.Entity.Royalty_Recoupment_Details>)Session["RoyaltyRecoupmentDetailsList"];
            }
            set { Session["RoyaltyRecoupmentDetailsList"] = value; }
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

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForRoyaltyRecoupment);
            //ModuleCode = Request.QueryString["modulecode"];
            ModuleCode = GlobalParams.ModuleCodeForRoyaltyRecoupment.ToString();
            return View("~/Views/Royalty_Recoupment/Index.cshtml");
        }

        public PartialViewResult BindPartialPages(string key, int royltyCode)
        {
            if (key == "LIST")
            {
                ViewBag.Code = ModuleCode;
                ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
                FetchData();
                List<SelectListItem> lstSort = new List<SelectListItem>();
                lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
                lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
                ViewBag.SortType = lstSort;
                ViewBag.UserModuleRights = GetUserModuleRights();
                return PartialView("~/Views/Royalty_Recoupment/_RoyaltyRecoupment.cshtml");
            }
            else
            {
               // Royalty_Recoupment_Service objRoyalty_Service = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Royalty_Recoupment objRoyalty = null;

                if (royltyCode > 0)
                    objRoyalty = objRoyaltyRecoupmentService.GetByID(royltyCode, new Type[] { typeof(Royalty_Recoupment_Details) });
                else
                    objRoyalty = new RightsU_Dapper.Entity.Royalty_Recoupment();

                List<Royalty_Recoupment_Details> lstRRD = objAdditionalExpenseService.GetAll().Where(s => s.Is_Active == "Y").ToList().Select(s =>
                    new Royalty_Recoupment_Details()
                    {
                        //EntityState = State.Added,
                        Recoupment_Type = "A",
                        Recoupment_Type_Code = s.Additional_Expense_Code,
                        Recoupment_Type_Name = s.Additional_Expense_Name,
                        Add_Subtract = "A"
                    }).ToList();

                lstRRD.AddRange(new RightsU_BLL.Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList().Select(s =>
                    new Royalty_Recoupment_Details()
                    {
                        //EntityState = State.Added,
                        Recoupment_Type = "C",
                        Recoupment_Type_Code = s.Cost_Type_Code,
                        Recoupment_Type_Name = s.Cost_Type_Name,
                        Add_Subtract = "A"
                    }).ToList());

                if (royltyCode > 0 && objRoyalty.Royalty_Recoupment_Details.Count > 0)
                {
                    int Postion = objRoyalty.Royalty_Recoupment_Details.Max(m => (m.Position ?? 0));
                    lstRRD.OrderBy(o => o.Recoupment_Type_Name).ToList().ForEach(f =>
                    {
                        Postion++;
                        Royalty_Recoupment_Details objRRD = objRoyalty.Royalty_Recoupment_Details.ToList().Where(w => w.Recoupment_Type_Code == f.Recoupment_Type_Code
                            && w.Recoupment_Type == f.Recoupment_Type).FirstOrDefault();

                        f.Position = (objRRD != null) ? objRRD.Position : Postion;
                    });
                }
                ViewBag.RecoupmentTypeList = RoyaltyRecoupmentDetailsList = lstRRD.OrderBy(o => o.Position).ToList();
                return PartialView("~/Views/Royalty_Recoupment/_AddEditRoyaltyRecoupment.cshtml", objRoyalty);

            }
        }

        public PartialViewResult BindRoyltyList(int pageNo, int recordPerPage,string sortType)
        {
            List<RightsU_Dapper.Entity.Royalty_Recoupment> lst = new List<RightsU_Dapper.Entity.Royalty_Recoupment>();
            int RecordCount = 0;
            RecordCount = lstRoyalty_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstRoyalty_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstRoyalty_Searched.OrderBy(o => o.Royalty_Recoupment_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstRoyalty_Searched.OrderByDescending(o => o.Royalty_Recoupment_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Royalty_Recoupment/_RoyaltyRecoupmentList.cshtml", lst);
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
        private void FetchData()
        {
            lstRoyalty_Searched = lstRoyalty = objRoyaltyRecoupmentService.GetAll().OrderByDescending(o => o.Last_Updated_Time).ToList();
        }
        #endregion

        public JsonResult SearchRoyalty(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstRoyalty_Searched = lstRoyalty.Where(w => w.Royalty_Recoupment_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstRoyalty_Searched = lstRoyalty;

            var obj = new
            {
                Record_Count = lstRoyalty_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult ActiveDeactiveRoyalty(int royaltyCode, string doActive)
        {
             string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(royaltyCode, GlobalParams.ModuleCodeForRoyaltyRecoupment, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Royalty_Recoupment_Service objService = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Royalty_Recoupment objRoyalty = objRoyaltyRecoupmentService.GetByID(royaltyCode);
                objRoyalty.Is_Active = doActive;
                //objRoyalty.EntityState = State.Modified;
                dynamic resultSet;
                objRoyaltyRecoupmentService.AddEntity(objRoyalty);
                bool isValid = true;// objService.Save(objRoyalty, out resultSet);

                lstRoyalty.Where(w => w.Royalty_Recoupment_Code == royaltyCode).First().Is_Active = doActive;
                lstRoyalty_Searched.Where(w => w.Royalty_Recoupment_Code == royaltyCode).First().Is_Active = doActive;

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

        public ViewResult AddEditRoyality(int royltyCode)
        {
            //Royalty_Recoupment_Service objRoyalty_Service = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Royalty_Recoupment objRoyalty = null;
            if (royltyCode > 0)
                objRoyalty = objRoyaltyRecoupmentService.GetByID(royltyCode);
            else
                objRoyalty = new RightsU_Dapper.Entity.Royalty_Recoupment();

            List<Royalty_Recoupment_Details> lstRRD = objAdditionalExpenseService.GetAll().Where(s => s.Is_Active == "Y").ToList().Select(s =>
                new Royalty_Recoupment_Details()
                {
                   // EntityState = State.Added,
                    Recoupment_Type = "A",
                    Recoupment_Type_Code = s.Additional_Expense_Code,
                    Recoupment_Type_Name = s.Additional_Expense_Name,
                    Add_Subtract = "A"                                      
                }).ToList();

            lstRRD.AddRange(new RightsU_BLL.Cost_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList().Select(s =>
                new Royalty_Recoupment_Details()
                {
                    //EntityState = State.Added,
                    Recoupment_Type = "C",
                    Recoupment_Type_Code = s.Cost_Type_Code,
                    Recoupment_Type_Name = s.Cost_Type_Name,
                    Add_Subtract = "A"
                }).ToList());
            if (royltyCode > 0 && objRoyalty.Royalty_Recoupment_Details.Count>0)
            {
                int Postion = objRoyalty.Royalty_Recoupment_Details.Max(m => (m.Position ?? 0));
                lstRRD.OrderBy(o => o.Recoupment_Type_Name).ToList().ForEach(f =>
                {
                    Postion++;
                    Royalty_Recoupment_Details objRRD = objRoyalty.Royalty_Recoupment_Details.ToList().Where(w => w.Recoupment_Type_Code == f.Recoupment_Type_Code
                        && w.Recoupment_Type == f.Recoupment_Type).FirstOrDefault();

                    f.Position = (objRRD != null) ? objRRD.Position : Postion;
                });
            }

            ViewBag.RecoupmentTypeList = RoyaltyRecoupmentDetailsList = lstRRD.OrderBy(o => o.Position).ToList();
            return View("~/Views/Royalty_Recoupment/AddEditRoyaltyRecoupment.cshtml", objRoyalty);
        }

        [HttpPost]
        public ActionResult SaveRoyalty(RightsU_Dapper.Entity.Royalty_Recoupment objRoyalty_MVC, FormCollection objFormCollection)
        {
            //Royalty_Recoupment_Service objRoyalty_Service = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Royalty_Recoupment objRoyalty = null;
            if (objRoyalty_MVC.Royalty_Recoupment_Code > 0)
            {
                dynamic resultSets = "";
                objRoyalty = objRoyaltyRecoupmentService.GetByID(objRoyalty_MVC.Royalty_Recoupment_Code);
                //objRoyalty.Royalty_Recoupment_Details.ToList().ForEach(f => { f.EntityState = State.Deleted; });
                objRoyalty.Royalty_Recoupment_Details.ToList().ForEach(t => objRoyalty.Royalty_Recoupment_Details.Remove(t));


                objRoyalty.Royalty_Recoupment_Code = objRoyalty_MVC.Royalty_Recoupment_Code;
                //objRoyalty.EntityState = State.Modified;
            }
            else
            {
                objRoyalty = new RightsU_Dapper.Entity.Royalty_Recoupment();
                //objRoyalty.EntityState = State.Added;
                objRoyalty.Royalty_Recoupment_Name = objRoyalty_MVC.Royalty_Recoupment_Name;
                objRoyalty.Is_Active = "Y";
                objRoyalty.Inserted_By = objLoginUser.Users_Code;
                objRoyalty.Inserted_On = DateTime.Now;
            }
            objRoyalty.Last_Updated_Time = DateTime.Now;
            
            if (objFormCollection["chkRecoupmentType"] != null)
            {
                string[] arrDummyGuid = objFormCollection["chkRecoupmentType"].Split(',');
                int i = 0;
                foreach (string dummyGuid in arrDummyGuid)
                {
                    Royalty_Recoupment_Details objRRD = RoyaltyRecoupmentDetailsList.Where(w => w.Dummy_Guid == dummyGuid).FirstOrDefault();
                    if (objRRD != null)
                    {
                        i++;
                        objRRD.Position = i;
                        objRoyalty.Royalty_Recoupment_Details.Add(objRRD);
                    }

                }
            }

            objRoyalty.Royalty_Recoupment_Name = objRoyalty_MVC.Royalty_Recoupment_Name;
            Royalty_Recoupment objR = new Royalty_Recoupment();
            //Royalty_Recoupment_Service objRoyaltyService = new Royalty_Recoupment_Service(objLoginEntity.ConnectionStringName);


            string resultSet;
            string status = "S", message = "";
            bool isDuplicate = objRoyaltyRecoupmentService.Validate(objRoyalty, out resultSet);
            
            /*bool valid = true*/;// objRoyalty_Service.Save(objRoyalty, out resultSet);
            
            if(isDuplicate)
            {
                objRoyaltyRecoupmentService.AddEntity(objRoyalty);

                int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                if (objRoyalty_MVC.Royalty_Recoupment_Code > 0)
                {
                    message = objMessageKey.Recordupdatedsuccessfully;
                }
                else
                {
                    message = objMessageKey.RecordAddedSuccessfully;
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

        public JsonResult CheckRecordLock(int royltyCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (royltyCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(royltyCode, GlobalParams.ModuleCodeForRoyaltyRecoupment, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForRoyaltyRecoupment), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
    }
}

