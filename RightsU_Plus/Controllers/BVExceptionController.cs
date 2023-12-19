using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using Newtonsoft.Json;

namespace RightsU_Plus.Controllers
{
    public class BVExceptionController : BaseController
    {
        #region --- Properties ---

        private List<RightsU_Entities.BVException> lstBVException
        {
            get
            {
                if (Session["lstBVException"] == null)
                    Session["lstBVException"] = new List<RightsU_Entities.BVException>();
                return (List<RightsU_Entities.BVException>)Session["lstBVException"];
            }
            set { Session["lstBVException"] = value; }
        }

        private List<RightsU_Entities.BVException> lstBVException_Searched
        {
            get
            {
                if (Session["lstBVException_Searched"] == null)
                    Session["lstBVException_Searched"] = new List<RightsU_Entities.BVException>();
                return (List<RightsU_Entities.BVException>)Session["lstBVException_Searched"];
            }
            set { Session["lstBVException_Searched"] = value; }
        }

        private RightsU_Entities.BVException objBVException
        {
            get
            {
                if (Session["objBVException"] == null)
                    Session["objBVException"] = new RightsU_Entities.BVException();
                return (RightsU_Entities.BVException)Session["objBVException"];
            }
            set { Session["objBVException"] = value; }
        }

        private BVException_Service objBVException_Service
        {
            get
            {
                if (Session["objBVException_Service"] == null)
                    Session["objBVException_Service"] = new BVException_Service(objLoginEntity.ConnectionStringName);
                return (BVException_Service)Session["objBVException_Service"];
            }
            set { Session["objBVException_Service"] = value; }
        }

        #endregion

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeFor_BV_Exception);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeFor_BV_Exception.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            lstBVException_Searched = lstBVException = objBVException_Service.SearchFor(x => x.Is_Active == "Y").OrderByDescending(o => o.Last_Updated_Time).ToList();
            return View("~/Views/BVException/Index.cshtml");
        }

        public PartialViewResult BindBVExceptionList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.BVException> lst = new List<RightsU_Entities.BVException>();
            int RecordCount = 0;
            RecordCount = lstBVException_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                ViewBag.SrNo_StartFrom = ((pageNo - 1) * recordPerPage);
                if (sortType == "T")
                    lst = lstBVException_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstBVException_Searched.OrderBy(o => o.Bv_Exception_Type).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstBVException_Searched.OrderByDescending(o => o.Bv_Exception_Type).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/BVException/_BVExceptionList.cshtml", lst);
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
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeFor_BV_Exception), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        #endregion

        public JsonResult SearchBVException(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstBVException_Searched = lstBVException.Where(w => w.BVException_Channel
                    .Any(a => a.Channel.Channel_Name.ToUpper().Contains(searchText.ToUpper()))
                || w.BVException_Users.Any(x => x.User.First_Name.ToUpper().Contains(searchText.ToUpper()) || x.User.Last_Name.ToUpper().Contains(searchText.ToUpper()))
                ).ToList();
            }
            else
                lstBVException_Searched = lstBVException;

            var obj = new
            {
                Record_Count = lstBVException_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult DeleteBVException(int exceptionCode)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "", Action = Convert.ToString(ActionType.X); // X = "Delete";
            int RLCode = 0;

            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(exceptionCode, GlobalParams.ModuleCodeFor_BV_Exception, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                BVException_Service objService = new BVException_Service(objLoginEntity.ConnectionStringName);
                RightsU_Entities.BVException objBVException = objService.GetById(exceptionCode);
                objBVException.Is_Active = "N";
                objBVException.Last_Action_By = objLoginUser.Users_Code;
                objBVException.Last_Updated_Time = DateTime.Now;
                objBVException.EntityState = State.Modified;
                dynamic resultSet;

                bool valid = objService.Save(objBVException, out resultSet);
                if (valid)
                {
                    lstBVException.Where(w => w.Bv_Exception_Code == exceptionCode).First().Is_Active = "N";
                    lstBVException_Searched.Where(w => w.Bv_Exception_Code == exceptionCode).First().Is_Active = "N";
                    message = objMessageKey.RecordDeletedsuccessfully;
                    FetchDeep();

                    try
                    {
                        objBVException.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objBVException.Inserted_By));
                        objBVException.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objBVException.Last_Action_By));
                        objBVException.BVException_Channel.ToList().ForEach(f => f.Channel_Name = new Channel_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Channel_Code)).Channel_Name);
                        objBVException.BVException_Users.ToList().ForEach(f => f.User_Name = new User_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Users_Code)).Full_Name);

                        string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objBVException);
                        //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeFor_BV_Exception, objBVException.Bv_Exception_Code, LogData, Action, objLoginUser.Users_Code);

                        MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                        objAuditLog.moduleCode = GlobalParams.ModuleCodeFor_BV_Exception;
                        objAuditLog.intCode = objBVException.Bv_Exception_Code;
                        objAuditLog.logData = LogData;
                        objAuditLog.actionBy = objLoginUser.Login_Name;
                        objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objBVException.Last_Updated_Time));
                        objAuditLog.actionType = Action;
                        var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                        var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                        if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                        {

                        }
                    }
                    catch (Exception ex)
                    {

                    }
                }
                else
                {
                    message = objMessageKey.RecordCouldnotDelete;
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
                Message = message,
                Record_Count = lstBVException_Searched.Count
            };
            return Json(obj);
        }

        public void FetchDeep()
        {
            lstBVException_Searched = lstBVException = objBVException_Service.SearchFor(x => x.Is_Active == "Y").OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        public PartialViewResult AddEditBVException(int exceptionCode)
        {
            BVException_Service objBVException_Service = new BVException_Service(objLoginEntity.ConnectionStringName);
            RightsU_Entities.BVException objBVException = null;
            if (exceptionCode > 0)
                objBVException = objBVException_Service.GetById(exceptionCode);
            else
                objBVException = new RightsU_Entities.BVException();
            lstBVException = objBVException_Service.SearchFor(x => true).ToList();

            List<RightsU_Entities.Channel> lstChaneels = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Channel_Name).ToList();
            var ChannelCodes = objBVException.BVException_Channel.Select(s => s.Channel_Code).ToArray();
            ViewBag.ChannelList = new MultiSelectList(lstChaneels, "Channel_Code", "Channel_Name", ChannelCodes);

            List<RightsU_Entities.User> lstUsers = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.First_Name).ToList();
            var UserCode = objBVException.BVException_Users.Select(s => s.Users_Code).ToArray();
            ViewBag.UserList = new MultiSelectList(lstUsers, "Users_Code", "Full_Name", UserCode);

            return PartialView("~/Views/BVException/_AddEditBVException.cshtml", objBVException);
        }

        [HttpPost]
        public ActionResult saveBVException(RightsU_Entities.BVException objBVException_MVC, FormCollection objFormCollection)
        {
            RightsU_Entities.BVException objB = new RightsU_Entities.BVException();
            BVException_Service ObjBVExceptionService = new BVException_Service(objLoginEntity.ConnectionStringName);
            if (objBVException_MVC.Bv_Exception_Code > 0)
            {
                objB = ObjBVExceptionService.GetById(objBVException_MVC.Bv_Exception_Code);
                objB.EntityState = State.Modified;
            }
            else
            {
                objB.Bv_Exception_Type = objBVException_MVC.Bv_Exception_Type;
                objB.Inserted_By = objLoginUser.Users_Code;
                objB.Inserted_On = System.DateTime.Now;
                objB.EntityState = State.Added;
                objB.Is_Active = "Y";
            }
            objB.Last_Action_By = objLoginUser.Users_Code;
            objB.Last_Updated_Time = DateTime.Now;
            objB.Bv_Exception_Type = objBVException_MVC.Bv_Exception_Type;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully", Action = Convert.ToString(ActionType.C); // C = "Create";


            ICollection<BVException_Channel> ChannelList = new HashSet<BVException_Channel>();
            if (objFormCollection["ddlChannel"] != null)
            {
                string[] arrChannelCode = objFormCollection["ddlChannel"].Split(',');
                foreach (string ChannelCode in arrChannelCode)
                {
                    BVException_Channel objTR = new BVException_Channel();
                    objTR.EntityState = State.Added;
                    objTR.Channel_Code = Convert.ToInt32(ChannelCode);
                    ChannelList.Add(objTR);
                }
            }

            IEqualityComparer<BVException_Channel> comparerChannel_List = new LambdaComparer<BVException_Channel>((x, y) => x.Channel_Code == y.Channel_Code && x.EntityState != State.Deleted);
            var Deleted_BVException_Channel = new List<BVException_Channel>();
            var Updated_BVException_Channel = new List<BVException_Channel>();
            var Added_BVException_Channel = CompareLists<BVException_Channel>(ChannelList.ToList<BVException_Channel>(), objB.BVException_Channel.ToList<BVException_Channel>(), comparerChannel_List, ref Deleted_BVException_Channel, ref Updated_BVException_Channel);
            Added_BVException_Channel.ToList<BVException_Channel>().ForEach(t => objB.BVException_Channel.Add(t));
            Deleted_BVException_Channel.ToList<BVException_Channel>().ForEach(t => t.EntityState = State.Deleted);


            ICollection<BVException_Users> UserList = new HashSet<BVException_Users>();
            if (objFormCollection["ddlUser"] != null)
            {
                string[] arrUserCode = objFormCollection["ddlUser"].Split(',');
                foreach (string UserCode in arrUserCode)
                {
                    BVException_Users objTR = new BVException_Users();
                    objTR.EntityState = State.Added;
                    objTR.Users_Code = Convert.ToInt32(UserCode);
                    UserList.Add(objTR);
                }
            }

            IEqualityComparer<BVException_Users> comparerUser_List = new LambdaComparer<BVException_Users>((x, y) => x.Users_Code == y.Users_Code && x.EntityState != State.Deleted);
            var Deleted_BVException_User = new List<BVException_Users>();
            var Updated_BVException_User = new List<BVException_Users>();
            var Added_BVException_User = CompareLists<BVException_Users>(UserList.ToList<BVException_Users>(), objB.BVException_Users.ToList<BVException_Users>(), comparerUser_List, ref Deleted_BVException_User, ref Updated_BVException_User);
            Added_BVException_User.ToList<BVException_Users>().ForEach(t => objB.BVException_Users.Add(t));
            Deleted_BVException_User.ToList<BVException_Users>().ForEach(t => t.EntityState = State.Deleted);

            bool valid = ObjBVExceptionService.Save(objB, out resultSet);

            if (valid)
            {
                if (objBVException_MVC.Bv_Exception_Code > 0)
                {
                    Action = Convert.ToString(ActionType.U); // U = "Update";
                    //message = message.Replace("{ACTION}", "updated");
                    message = objMessageKey.Recordupdatedsuccessfully;
                    int recordLockingCode = Convert.ToInt32(objFormCollection["hdnRecodLockingCode"]);
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                    FetchData();
                }
                else
                {
                    //message = message.Replace("{ACTION}", "added");
                    message = objMessageKey.RecordAddedSuccessfully;
                    FetchData();
                }

                try
                {
                    objB.Inserted_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objB.Inserted_By));
                    objB.Last_Action_By_User = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetUserName(Convert.ToInt32(objB.Last_Action_By));
                    objB.BVException_Channel.ToList().ForEach(f => f.Channel_Name = new Channel_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Channel_Code)).Channel_Name);
                    objBVException.BVException_Users.ToList().ForEach(f => f.User_Name = new User_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(f.Users_Code)).Full_Name);

                    string LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().ConvertObjectToJson(objB);
                    //bool isLogSave = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().SaveMasterLogData(GlobalParams.ModuleCodeFor_BV_Exception, objB.Bv_Exception_Code, LogData, Action, objLoginUser.Users_Code);

                    MasterAuditLogInput objAuditLog = new MasterAuditLogInput();
                    objAuditLog.moduleCode = GlobalParams.ModuleCodeFor_BV_Exception;
                    objAuditLog.intCode = objB.Bv_Exception_Code;
                    objAuditLog.logData = LogData;
                    objAuditLog.actionBy = objLoginUser.Login_Name;
                    objAuditLog.actionOn = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(objB.Last_Updated_Time));
                    objAuditLog.actionType = Action;
                    var strCheck = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().PostAuditLogAPI(objAuditLog, "");

                    var LogDetail = JsonConvert.DeserializeObject<JsonData>(strCheck);
                    if (Convert.ToString(LogDetail.ErrorMessage) == "Error")
                    {

                    }
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
                RecordCount = lstBVException.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult CheckRecordLock(int exceptionCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (exceptionCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(exceptionCode, GlobalParams.ModuleCodeFor_BV_Exception, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult, ref List<T> UPResult) where T : class
        {
            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);
            var UpdateResult = FirstList.Except(DeleteResult, comparer);
            var Modified_Result = UpdateResult.Except(AddResult);

            DelResult = DeleteResult.ToList<T>();
            UPResult = Modified_Result.ToList<T>();

            return AddResult.ToList<T>();
        }

        private void FetchData()
        {
            lstBVException_Searched = lstBVException = new BVException_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
        }

    }
}

