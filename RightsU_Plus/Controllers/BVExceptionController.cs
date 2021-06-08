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
    public class BVExceptionController : BaseController
    {
        private readonly BVException_Service objBVExceptionService = new BVException_Service();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();
        private readonly Channel_Service objChannelService = new Channel_Service();
        private readonly User_Service objUserService = new User_Service();


        #region --- Properties ---
        private List<RightsU_Dapper.Entity.BVException> lstBVException
        {
            get
            {
                if (Session["lstBVException"] == null)
                    Session["lstBVException"] = new List<RightsU_Dapper.Entity.BVException>();
                return (List<RightsU_Dapper.Entity.BVException>)Session["lstBVException"];
            }
            set { Session["lstBVException"] = value; }
        }

        private List<RightsU_Dapper.Entity.BVException> lstBVException_Searched
        {
            get
            {
                if (Session["lstBVException_Searched"] == null)
                    Session["lstBVException_Searched"] = new List<RightsU_Dapper.Entity.BVException>();
                return (List<RightsU_Dapper.Entity.BVException>)Session["lstBVException_Searched"];
            }
            set { Session["lstBVException_Searched"] = value; }
        }

        private RightsU_Dapper.Entity.BVException objBVException
        {
            get
            {
                if (Session["objBVException"] == null)
                    Session["objBVException"] = new RightsU_Dapper.Entity.BVException();
                return (RightsU_Dapper.Entity.BVException)Session["objBVException"];
            }
            set { Session["objBVException"] = value; }
        }

        //private BVException_Service objBVException_Service
        //{
        //    get
        //    {
        //        if (Session["objBVException_Service"] == null)
        //            Session["objBVException_Service"] = new BVException_Service(objLoginEntity.ConnectionStringName);
        //        return (BVException_Service)Session["objBVException_Service"];
        //    }
        //    set { Session["objBVException_Service"] = value; }
        //}

        Type[] RelationList = new Type[] { typeof(BVException_Channel),
                        typeof(BVException_Users)
            };

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
            lstBVException_Searched = lstBVException = objBVExceptionService.GetAll(RelationList).Where(x => x.Is_Active == "Y").OrderByDescending(o => o.Last_Updated_Time).ToList();
            return View("~/Views/BVException/Index.cshtml");
        }

        public PartialViewResult BindBVExceptionList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Dapper.Entity.BVException> lst = new List<RightsU_Dapper.Entity.BVException>();
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
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeFor_BV_Exception), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        #endregion

        public JsonResult SearchBVException(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                List<int?> lstChannelCode = objChannelService.GetList().Where(x => x.Channel_Name.ToUpper().Contains(searchText.ToUpper())).Select(y => y.Channel_Code).ToList();
                List<int?> lstUserCode = objUserService.GetAll().Where(x => x.First_Name.ToUpper().Contains(searchText.ToUpper()) || x.Last_Name.ToUpper().Contains(searchText.ToUpper())).
                    Select(y => y.Users_Code).ToList();
                //lstBVException_Searched = lstBVException.Where(w => w.BVException_Channel
                //    .Any(a => a.Channel.Channel_Name.ToUpper().Contains(searchText.ToUpper()))
                //|| w.BVException_Users.Any(x => x.User.First_Name.ToUpper().Contains(searchText.ToUpper()) || x.User.Last_Name.ToUpper().Contains(searchText.ToUpper()))
                //).ToList();
                lstBVException_Searched = lstBVException.Where(w => w.BVException_Channel
                    .Any(a => lstChannelCode.Contains(a.Channel_Code))
                || w.BVException_Users.Any(x => lstUserCode.Contains(x.Users_Code))
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
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;


            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(exceptionCode, GlobalParams.ModuleCodeFor_BV_Exception, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {


                //BVException_Service objService = new BVException_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.BVException objBVException = objBVExceptionService.GetByID(exceptionCode,RelationList);
                objBVException.Is_Active = "N";
               // objBVException.EntityState = State.Modified;
                dynamic resultSet;
                objBVExceptionService.AddEntity(objBVException);
                bool valid = true;// objService.Save(objBVException, out resultSet);
                if (valid)
                {
                    lstBVException.Where(w => w.Bv_Exception_Code == exceptionCode).First().Is_Active = "N";
                    lstBVException_Searched.Where(w => w.Bv_Exception_Code == exceptionCode).First().Is_Active = "N";
                    message = objMessageKey.RecordDeletedsuccessfully;
                    FetchDeep();
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
            lstBVException_Searched = lstBVException = objBVExceptionService.GetAll(RelationList).Where(x => x.Is_Active == "Y").OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        public PartialViewResult AddEditBVException(int exceptionCode)
        {
            //BVException_Service objBVException_Service = new BVException_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.BVException objBVException = null;
            if (exceptionCode > 0)
                objBVException = objBVExceptionService.GetByID(exceptionCode, RelationList);
            else
                objBVException = new RightsU_Dapper.Entity.BVException();
            lstBVException = objBVExceptionService.GetAll(RelationList).ToList();

            List<RightsU_Dapper.Entity.Channel> lstChaneels = objChannelService.GetList().Where(w => w.Is_Active == "Y").OrderBy(o => o.Channel_Name).ToList();
            var ChannelCodes = objBVException.BVException_Channel.Select(s => s.Channel_Code).ToArray();
            ViewBag.ChannelList = new MultiSelectList(lstChaneels, "Channel_Code", "Channel_Name", ChannelCodes);

            List<RightsU_Dapper.Entity.User> lstUsers = objUserService.GetAll().Where(w => w.Is_Active == "Y").OrderBy(o => o.First_Name).ToList();
            var UserCode = objBVException.BVException_Users.Select(s => s.Users_Code).ToArray();
            ViewBag.UserList = new MultiSelectList(lstUsers, "Users_Code", "Full_Name", UserCode);

            return PartialView("~/Views/BVException/_AddEditBVException.cshtml", objBVException);
        }

        [HttpPost]
        public ActionResult saveBVException(RightsU_Dapper.Entity.BVException objBVException_MVC, FormCollection objFormCollection)
        {
            RightsU_Dapper.Entity.BVException objB = new RightsU_Dapper.Entity.BVException();
            //BVException_Service ObjBVExceptionService = new BVException_Service(objLoginEntity.ConnectionStringName);
            if (objBVException_MVC.Bv_Exception_Code > 0)
            {
                objB = objBVExceptionService.GetByID(objBVException_MVC.Bv_Exception_Code, RelationList);
                objB.Last_Action_By = objLoginUser.Users_Code;

                //objB.EntityState = State.Modified;
            }
            else
            {
                objB.Bv_Exception_Type = objBVException_MVC.Bv_Exception_Type;
                objB.Inserted_By = objLoginUser.Users_Code;
                objB.Inserted_On = System.DateTime.Now;
                //objB.EntityState = State.Added;
                objB.Is_Active = "Y";
            }
            objB.Last_Updated_Time = DateTime.Now;
            objB.Bv_Exception_Type = objBVException_MVC.Bv_Exception_Type;

            dynamic resultSet;
            string status = "S", message = "Record {ACTION} successfully";


            ICollection<BVException_Channel> ChannelList = new HashSet<BVException_Channel>();
            if (objFormCollection["ddlChannel"] != null)
            {
                string[] arrChannelCode = objFormCollection["ddlChannel"].Split(',');
                foreach (string ChannelCode in arrChannelCode)
                {
                    BVException_Channel objTR = new BVException_Channel();
                    //objTR.EntityState = State.Added;
                    objTR.Channel_Code = Convert.ToInt32(ChannelCode);
                    ChannelList.Add(objTR);
                }
            }

            IEqualityComparer<BVException_Channel> comparerChannel_List = new RightsU_BLL.LambdaComparer<BVException_Channel>((x, y) => x.Channel_Code == y.Channel_Code);
            var Deleted_BVException_Channel = new List<BVException_Channel>();
            var Updated_BVException_Channel = new List<BVException_Channel>();
            var Added_BVException_Channel = CompareLists<BVException_Channel>(ChannelList.ToList<BVException_Channel>(), objB.BVException_Channel.ToList<BVException_Channel>(), comparerChannel_List, ref Deleted_BVException_Channel, ref Updated_BVException_Channel);
            Added_BVException_Channel.ToList<BVException_Channel>().ForEach(t => objB.BVException_Channel.Add(t));
            Deleted_BVException_Channel.ToList<BVException_Channel>().ForEach(t => objB.BVException_Channel.Remove(t));


            ICollection<BVException_Users> UserList = new HashSet<BVException_Users>();
            if (objFormCollection["ddlUser"] != null)
            {
                string[] arrUserCode = objFormCollection["ddlUser"].Split(',');
                foreach (string UserCode in arrUserCode)
                {
                    BVException_Users objTR = new BVException_Users();
                    //objTR.EntityState = State.Added;
                    objTR.Users_Code = Convert.ToInt32(UserCode);
                    UserList.Add(objTR);
                }
            }

            IEqualityComparer<BVException_Users> comparerUser_List = new RightsU_BLL.LambdaComparer<BVException_Users>((x, y) => x.Users_Code == y.Users_Code);
            var Deleted_BVException_User = new List<BVException_Users>();
            var Updated_BVException_User = new List<BVException_Users>();
            var Added_BVException_User = CompareLists<BVException_Users>(UserList.ToList<BVException_Users>(), objB.BVException_Users.ToList<BVException_Users>(), comparerUser_List, ref Deleted_BVException_User, ref Updated_BVException_User);
            Added_BVException_User.ToList<BVException_Users>().ForEach(t => objB.BVException_Users.Add(t));
            Deleted_BVException_User.ToList<BVException_Users>().ForEach(t => objB.BVException_Users.Remove(t));

            objBVExceptionService.AddEntity(objB);
            bool valid = true;// ObjBVExceptionService.Save(objB, out resultSet);

            if (valid)
            {

                if (objBVException_MVC.Bv_Exception_Code > 0)
                {
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
            }
            else
            {
                status = "E";
                message = "";
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
            lstBVException_Searched = lstBVException = objBVExceptionService.GetAll(RelationList).ToList();
        }

    }
}

