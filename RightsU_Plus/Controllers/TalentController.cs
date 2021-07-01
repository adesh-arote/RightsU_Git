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
    public class TalentController : BaseController
    {
        private readonly Talent_Service objTalent_Service = new Talent_Service();
        private readonly Role_Service objRoleService = new Role_Service();
        private readonly USP_Service objProcedureService = new USP_Service();

        #region --- Properties ---

        private List<RightsU_Dapper.Entity.Talent> lstTalent
        {
            get
            {
                if (Session["lstTalent"] == null)
                    Session["lstTalent"] = new List<RightsU_Dapper.Entity.Talent>();
                return (List<RightsU_Dapper.Entity.Talent>)Session["lstTalent"];
            }
            set { Session["lstTalent"] = value; }
        }
        private List<RightsU_Dapper.Entity.Talent> lstTalent_Searched
        {
            get
            {
                if (Session["lstTalent_Searched"] == null)
                    Session["lstTalent_Searched"] = new List<RightsU_Dapper.Entity.Talent>();
                return (List<RightsU_Dapper.Entity.Talent>)Session["lstTalent_Searched"];
            }
            set { Session["lstTalent_Searched"] = value; }
        }

        #endregion

        public ViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTalent);
            string moduleCode = GlobalParams.ModuleCodeForTalent.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            /*lstTalent_Searched = lstTalent = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(a => true).ToList()*/   
            lstTalent_Searched = lstTalent = (List<RightsU_Dapper.Entity.Talent>)objTalent_Service.GetList(new Type[] { typeof(Talent_Role) });

            RightsU_Dapper.Entity.Talent objTalent = new RightsU_Dapper.Entity.Talent();
            List<SelectListItem> lstTitleType = new List<SelectListItem>();
            lstTitleType = new SelectList(objRoleService.GetList().Where(x => x.Role_Type != null && x.Role_Type.Trim() == "T").OrderBy(o => o.Role_Name),"Role_Code","Role_Name","Please Select").ToList();
            lstTitleType.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });
            var rolecode = objTalent.Talent_Role.Select(s => s.Role_Code).ToArray();
            ViewBag.RoleList = lstTitleType;
            Session["RoleList"] = lstTitleType;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Talent/Index.cshtml");
        }

        public PartialViewResult BindTalentList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Dapper.Entity.Talent> lst = new List<RightsU_Dapper.Entity.Talent>();
            List<SelectListItem> lstTitleType = new List<SelectListItem>();
            lstTitleType = new SelectList(objRoleService.GetList().Where(x => x.Role_Type != null && x.Role_Type.Trim() == "T").OrderBy(o => o.Role_Name), "Role_Code", "Role_Name", "Please Select").ToList();
            ViewBag.ROle = lstTitleType;
            int RecordCount = 0;
            RecordCount = lstTalent_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstTalent_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstTalent_Searched.OrderBy(o => o.Talent_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstTalent_Searched.OrderByDescending(o => o.Talent_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Talent/_TalentList.cshtml", lst);
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

            //List<string> lstRights = new USP_Service.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTalent), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();

            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTalent), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;
            return rights;
        }
        #endregion

        public JsonResult SearchTalent(string searchText, int roleCode)
        {

            if (!string.IsNullOrEmpty(searchText) && roleCode != 0)
            {
                lstTalent_Searched = lstTalent.Where(w => w.Talent_Name.ToUpper().Contains(searchText.ToUpper())
             && w.Talent_Role.Any(j => j.Role_Code == roleCode)).Select(s => s).ToList();
            }
            else if (!string.IsNullOrEmpty(searchText) && roleCode == 0)
            {
                lstTalent_Searched = lstTalent.Where(w => w.Talent_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else if (string.IsNullOrEmpty(searchText) && roleCode != 0)
            {

                lstTalent_Searched = lstTalent.Where(i => i.Talent_Role.Any(j => j.Role_Code == roleCode)).Select(s => s).ToList();
            }
            else
                lstTalent_Searched = lstTalent;


            var obj = new
            {
                Record_Count = lstTalent_Searched.Count
            };
            RightsU_Dapper.Entity.Talent objTalent = new RightsU_Dapper.Entity.Talent();
            List<Role> lstRoleUnit = objRoleService.GetList().Where(x =>x.Role_Type!=null && x.Role_Type.Trim() == "T").OrderBy(o => o.Role_Name).ToList();
            var rolecode = objTalent.Talent_Role.Select(s => s.Role_Code).ToArray();
            ViewBag.RoleList = new MultiSelectList(lstRoleUnit, "Role_Code", "Role_Name", "--Please Select--");
            Session["RoleList"] = new MultiSelectList(lstRoleUnit, "Role_Code", "Role_Name", "--Please Select--");
            return Json(obj);
        }

        public JsonResult ActiveDeactiveTalent(int talentCode, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;
            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(talentCode, GlobalParams.ModuleCodeForTalent, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Talent_Service objService = new Talent_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Talent objTalent = objTalent_Service.GetTalentByID(talentCode);
                objTalent.Is_Active = doActive;
                //objTalent.EntityState = State.Modified;
                dynamic resultSet;
                //bool isValid = objService.Save(objTalent, out resultSet);
                if(talentCode > 0)
                {
                    objTalent_Service.UpdateMusic_Deal(objTalent);
                }
                bool isValid = true;
                if (isValid)
                {
                    lstTalent.Where(w => w.Talent_Code == talentCode).First().Is_Active = doActive;
                    lstTalent_Searched.Where(w => w.Talent_Code == talentCode).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                    message = objMessageKey.Recordactivatedsuccessfully;
                //message = message.Replace("{ACTION}", "Activated");
                else
                    message = objMessageKey.Recorddeactivatedsuccessfully;
                //message = message.Replace("{ACTION}", "Deactivated");

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

        public JsonResult EditTalentList(int talentcode)
        {

            string status = "S", message = "Record {ACTION} successfully";
            Talent_Service objService = new Talent_Service();
            RightsU_Dapper.Entity.Talent objTalent = objService.GetTalentByID(talentcode);
            //Talent_Service objService = new Talent_Service(objLoginEntity.ConnectionStringName);
            //RightsU_Dapper.Entity.Talent objTalent = new RightsU_Dapper.Entity.Talent();

            TempData["Action"] = "EditTalent";
            TempData["idTalent"] = objTalent.Talent_Code;

           // lstTitleType = new SelectList(objRoleService.GetList().Where(x => x.Role_Type != null && x.Role_Type.Trim() == "T").OrderBy(o => o.Role_Name), "Role_Code", "Role_Name", "Please Select").ToList();
            List<Role> lstRoleUnit = objRoleService.GetList().Where(x =>x.Role_Type != null && x.Role_Type.Trim() == "T").OrderBy(o => o.Role_Name).ToList();
            var rolecode = objTalent.Talent_Role.Select(s => s.Role_Code).ToArray();
            ViewBag.RoleList = new MultiSelectList(lstRoleUnit, "Role_Code", "Role_Name", rolecode);
            Session["RoleList"] = new MultiSelectList(lstRoleUnit, "Role_Code", "Role_Name", rolecode);

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult UpdateTalent(FormCollection help)
        {
            int talentcode = Convert.ToInt32(help["Talent_Code"]);
            //  int recordCode = Convert.ToInt32(help["Record_Code"]);
            string talentname = help["Talent_Name"].ToString();
            string gender = help["Gender"].ToString();
            string status = "S", message = "Record {ACTION} successfully";

            //Talent_Service objService = new Talent_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Talent objTalent = objTalent_Service.GetTalentByID(talentcode);
            objTalent.Talent_Name = talentname;
            objTalent.Last_Action_By = objLoginUser.Users_Code;
            objTalent.Last_Updated_Time = System.DateTime.Now;
            objTalent.Gender = gender;
            #region --- Talent Role List ---
            ICollection<Talent_Role> talentRoleList = new HashSet<Talent_Role>();
            if (help["Talent_Role"] != null)
            {
                string[] arrRoleCodes = help["Talent_Role"].Split(',');
                foreach (string roleCode in arrRoleCodes)
                {
                    Talent_Role objTR = new Talent_Role();
                    //objTR.EntityState = State.Added;
                    objTR.Role_Code = Convert.ToInt32(roleCode);
                    talentRoleList.Add(objTR);
                }
            }
            IEqualityComparer<Talent_Role> comparerTalentRole = new RightsU_Dapper.BLL.LambdaComparer<Talent_Role>((x, y) => x.Role_Code == y.Role_Code);// && x.EntityState != State.Deleted);
            var Deleted_Talent_Role = new List<Talent_Role>();
            var Added_Talent_Role = CompareLists<Talent_Role>(talentRoleList.ToList<Talent_Role>(), objTalent.Talent_Role.ToList<Talent_Role>(), comparerTalentRole, ref Deleted_Talent_Role);
            Added_Talent_Role.ToList<Talent_Role>().ForEach(t => objTalent.Talent_Role.Add(t));
           // Deleted_Talent_Role.ToList<Talent_Role>().ForEach(t => t.EntityState = State.Deleted);
            Deleted_Talent_Role.ToList().ForEach(t => objTalent.Talent_Role.Remove(t));
            #endregion
            //objTalent.EntityState = State.Modified;

            if (objTalent.Title_Audio_Details_Singers.Count > 0 || objTalent.Title_Talent.Count > 0 || objTalent.Music_Album_Talent.Count > 0 || objTalent.Music_Title_Talent.Count > 0 || objTalent.Talent_Role.Count > 0)
            {
                string[] arrroleCodes = help["Talent_Role"].Split(',');
                List<string> lst_Ref = new List<string>();
                //lst_Ref.AddRange(new USP_Service(objLoginEntity.ConnectionStringName).USP_Validate_Talent_Master(objTalent.Talent_Code, help["Talent_Role"].ToString()));
                lst_Ref.AddRange(objProcedureService.USP_Validate_Talent_Master(objTalent.Talent_Code, help["Talent_Role"].ToString()));
                if (lst_Ref.Count > 0 && lst_Ref[0].ToString() == "YES")
                {
                    status = "E";
                    message = objMessageKey.TalentisalreadyusedYoucannotremoveexistingTalentRoles;
                }
            }

            if (status != "E")
            {
                string resultSet;
                //bool isValid = objService.Save(objTalent, out resultSet);
                bool isDuplicate = objTalent_Service.Validate(objTalent, out resultSet);
                if (isDuplicate)
                {
                    objTalent_Service.UpdateMusic_Deal(objTalent);
                }
                else
                {
                    status = "";
                    message = resultSet;
                }
                bool isValid = true;
                if (isValid)
                {
                    lstTalent.Where(w => w.Talent_Code == talentcode).First();
                    lstTalent_Searched.Where(w => w.Talent_Code == talentcode).First();
                    status = "S";
                    message = objMessageKey.Recordupdatedsuccessfully;
                    int recordLockingCode = Convert.ToInt32(help["Record_Code"]);
                    CommonUtil objCommonUtil = new CommonUtil();
                    objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
                    FetchData();
                }
                else
                {
                    status = "E";
                    //message = resultSet;
                }
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult AddTalent()
        {

            string status = "S", message = "Record {ACTION} successfully";

            TempData["Action"] = "AddTalent";

            RightsU_Dapper.Entity.Talent objTalent = new RightsU_Dapper.Entity.Talent();
            List<Role> lstRoleUnit = objRoleService.GetList().Where(x => x.Role_Type != null && x.Role_Type.Trim() == "T").OrderBy(o => o.Role_Name).ToList();
            var rolecode = objTalent.Talent_Role.Select(s => s.Role_Code).ToArray();
            ViewBag.RoleList = new MultiSelectList(lstRoleUnit, "Role_Code", "Role_Name", rolecode);
            Session["RoleList"] = new MultiSelectList(lstRoleUnit, "Role_Code", "Role_Name", rolecode);

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult SaveTalent(FormCollection help)
        {

            string talentname = help["Talent_Name"].ToString();
            string gender = help["Gender"].ToString();
            string Role_Code = help["Talent_Role"].ToString();
            string status = "S", message = "Record {ACTION} successfully";



            //Talent_Service objService = new Talent_Service(objLoginEntity.ConnectionStringName);
            Talent_Service objService = new Talent_Service();
            RightsU_Dapper.Entity.Talent objTalent = new RightsU_Dapper.Entity.Talent();

            objTalent.Gender = gender;
            // objTalent.
            objTalent.Is_Active = "Y";
            objTalent.Talent_Name = talentname;
            objTalent.Inserted_By = objLoginUser.Users_Code;
            objTalent.Inserted_On = System.DateTime.Now;
            //objTalent.EntityState = State.Added;
            objTalent.Last_Updated_Time = System.DateTime.Now;

            #region --- Talent Role List ---
            ICollection<Talent_Role> talentRoleList = new HashSet<Talent_Role>();
            if (help["Talent_Role"] != null)
            {
                string[] arrRoleCodes = help["Talent_Role"].Split(',');
                foreach (string roleCode in arrRoleCodes)
                {
                    Talent_Role objTR = new Talent_Role();
                    //objTR.EntityState = State.Added;
                    
                    objTR.Role_Code = Convert.ToInt32(roleCode);
                    talentRoleList.Add(objTR);
                }
            }
            IEqualityComparer<Talent_Role> comparerTalentRole = new RightsU_Dapper.BLL.LambdaComparer<Talent_Role>((x, y) => x.Role_Code == y.Role_Code);// && x.EntityState != State.Deleted);
            var Deleted_Talent_Role = new List<Talent_Role>();
            var Added_Talent_Role = CompareLists<Talent_Role>(talentRoleList.ToList<Talent_Role>(), objTalent.Talent_Role.ToList<Talent_Role>(), comparerTalentRole, ref Deleted_Talent_Role);
            Added_Talent_Role.ToList<Talent_Role>().ForEach(t => objTalent.Talent_Role.Add(t));
            //Deleted_Talent_Role.ToList<Talent_Role>().ForEach(t => t.EntityState = State.Deleted);
           // Deleted_Talent_Role.ToList().ForEach(t => objTalent.Talent_Role.Remove(t));
            #endregion

            string resultSet;
            bool isDuplicate = objTalent_Service.Validate(objTalent, out resultSet);
            //bool isValid = objService.Save(objTalent, out resultSet);
            if (isDuplicate)
            {
                objTalent_Service.AddEntity(objTalent);
                status = "S";
                message = objMessageKey.RecordAddedSuccessfully;
                FetchData();
            }
            else
            {
                status = "E";
                message = resultSet;
            }

            var obj = new
            {
                Record_Count = lstTalent_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult CheckRecordLock(int talentcode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (talentcode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(talentcode, GlobalParams.ModuleCodeForTalent, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        //protected List<T> CompareLists<T>(List<T> FirstList, List<T> SecondList, IEqualityComparer<T> comparer, ref List<T> DelResult, ref List<T> UPResult) where T : class
        //{
        //    var AddResult = FirstList.Except(SecondList, comparer);
        //    var DeleteResult = SecondList.Except(FirstList, comparer);
        //    var UpdateResult = FirstList.Except(DeleteResult, comparer);
        //    var Modified_Result = UpdateResult.Except(AddResult);

        //    DelResult = DeleteResult.ToList<T>();
        //    UPResult = Modified_Result.ToList<T>();

        //    return AddResult.ToList<T>();
        //}

        protected List<T> CompareLists<T>(List<T> FirstList,
                                          List<T> SecondList,
                                          IEqualityComparer<T> comparer,
                                          ref List<T> DelResult) where T : class
        {

            var AddResult = FirstList.Except(SecondList, comparer);
            var DeleteResult = SecondList.Except(FirstList, comparer);

            DelResult = DeleteResult.ToList<T>();

            return AddResult.ToList<T>();
        }
        private void FetchData()
        {
            lstTalent_Searched = lstTalent = objTalent_Service.GetList(new Type[] { typeof(Talent_Role) }).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }
    }
}

