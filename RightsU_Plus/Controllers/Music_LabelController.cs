using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Entities;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;

namespace RightsU_Plus.Controllers
{
    public class Music_LabelController : BaseController
    {
        private readonly Music_Label_Service objMusicLabelService = new Music_Label_Service();
        private readonly Title_Service objTitleService = new Title_Service();
        private readonly USP_Service objProcedureService = new USP_Service();
        #region --- Properties ---
        private List<RightsU_Dapper.Entity.Music_Label> lstMusic_Label
        {
            get
            {
                if (Session["lstMusic_Label"] == null)
                    Session["lstMusic_Label"] = new List<RightsU_Dapper.Entity.Music_Label>();
                return (List< RightsU_Dapper.Entity.Music_Label>)Session["lstMusic_Label"];
            }
            set { Session["lstMusic_Label"] = value; }
        }

        private List<RightsU_Dapper.Entity.Music_Label> lstMusic_Label_Searched
        {
            get
            {
                if (Session["lstMusic_Label_Searched"] == null)
                    Session["lstMusic_Label_Searched"] = new List<RightsU_Dapper.Entity.Music_Label>();
                return (List<RightsU_Dapper.Entity.Music_Label>)Session["lstMusic_Label_Searched"];
            }
            set { Session["lstMusic_Label_Searched"] = value; }
        }

        #endregion

        public ViewResult Index()
        {
            //string modulecode = Request.QueryString["modulecode"];
            string modulecode = GlobalParams.ModuleCodeForMusicLabel.ToString();
            ViewBag.Code = modulecode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicLabel);
            lstMusic_Label_Searched = lstMusic_Label = (List<RightsU_Dapper.Entity.Music_Label>)objMusicLabelService.GetAll();
            Session["TitleLabelCode"] = "";
            Session["TitleLabelCode"] = GetTitleLabelCode();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Music_Label/Index.cshtml");
        }

        public PartialViewResult BindMusic_LabelList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Dapper.Entity.Music_Label> lst = new List<RightsU_Dapper.Entity.Music_Label>();
            int RecordCount = 0;
            RecordCount = lstMusic_Label_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstMusic_Label_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstMusic_Label_Searched.OrderBy(o => o.Music_Label_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstMusic_Label_Searched.OrderByDescending(o => o.Music_Label_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            Session["TitleLabelCode"] = "";
            Session["TitleLabelCode"] = GetTitleLabelCode();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Music_Label/_Music_LabelList.cshtml", lst);
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
            string lstRights = objProcedureService.USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForMusicLabel), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string rights = "";
            if (lstRights != null)
                rights = lstRights;
            return rights;
        }

        private string GetTitleLabelCode()
        {
            List<RightsU_Dapper.Entity.Title> lstRights = objTitleService.GetAll().Where(x => true).Where(x => x.Music_Label_Code != null && x.Music_Label_Code != 0).ToList();
            string rights = "~";
            if (lstRights.FirstOrDefault() != null)
            {
                foreach (var item in lstRights)
                {
                    rights = rights + item.Music_Label_Code + "~";
                }
            }
            rights.TrimEnd('~');
            return rights;
        }



        #endregion

        public JsonResult SearchMusic_Label(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                string[] keywords = searchText.ToUpper().Split(' ');
                lstMusic_Label_Searched = lstMusic_Label.Where(x => keywords.Any(keyword => x.Music_Label_Name.ToUpper()
                                                         .Contains(keyword))).ToList();
               //  lstMusic_Label_Searched = lstMusic_Label.Where(w => searchText.ToUpper().Split(' ').Contains(w.Music_Label_Name.ToUpper())).ToList();
            }
            else
                lstMusic_Label_Searched = lstMusic_Label;

            var obj = new
            {
                Record_Count = lstMusic_Label_Searched.Count
            };
            return Json(obj);
        }

        #region --- CRUD Method ---

        public JsonResult ActiveDeactiveMusic_Label(int Music_LabelCode, string doActive)
        {
            string status = "S", message = "Record {ACTION} successfully", strMessage = "";
            int RLCode = 0;

            CommonUtil objCommonUtil = new CommonUtil();
            bool isLocked = objCommonUtil.Lock_Record(Music_LabelCode, GlobalParams.ModuleCodeForMusicLabel, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            if (isLocked)
            {
                //Music_Label_Service objService = new Music_Label_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Music_Label objMusic_Label = objMusicLabelService.GetByID(Music_LabelCode);
                objMusic_Label.Is_Active = doActive;
                objMusicLabelService.UpdateEntity(objMusic_Label);
                //objMusic_Label.EntityState = State.Modified;
                dynamic resultSet;
                bool isValid = true;//= objService.Save(objMusic_Label, out resultSet);
                if (isValid)
                {
                    lstMusic_Label.Where(w => w.Music_Label_Code == Music_LabelCode).First().Is_Active = doActive;
                    lstMusic_Label_Searched.Where(w => w.Music_Label_Code == Music_LabelCode).First().Is_Active = doActive;
                }
                else
                {
                    status = "E";
                    message = "Cound not {ACTION} record";
                }
                if (doActive == "Y")
                {
                    if (status == "E")
                        message = objMessageKey.CouldNotActivatedRecord;
                    else
                        message = objMessageKey.Recordactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Activated");
                }
                else
                {
                    if (status == "E")
                        message = objMessageKey.CouldNotDeactivatedRecord;
                    else
                        message = objMessageKey.Recorddeactivatedsuccessfully;
                    //message = message.Replace("{ACTION}", "Deactivated");
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

        public JsonResult AddEditMusic_LabelList(int Music_LabelCode, string commandName)
        {
            string status = "S", message = "Record {ACTION} successfully";
            if (commandName == "ADD")
            {
                TempData["Action"] = "AddMusic_Label";
            }
            else if (commandName == "EDIT")
            {
               // Music_Label_Service objService = new Music_Label_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Music_Label objMusic_Label = objMusicLabelService.GetByID(Music_LabelCode);
                TempData["Action"] = "EditMusic_Label";
                TempData["idMusic_Label"] = objMusic_Label.Music_Label_Code;
            }
            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public JsonResult CheckRecordLock(int Music_LabelCode, string commandName)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (Music_LabelCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(Music_LabelCode, GlobalParams.ModuleCodeForMusicLabel, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SaveUpdateMusic_LabelList(FormCollection objFormCollection)
        {
            int Music_LabelCode = Convert.ToInt32(objFormCollection["Music_LabelCode"]);
            int Record_Code = Convert.ToInt32(objFormCollection["Record_Code"]);
            string status = "S", message = "Record {ACTION} successfully";
           // Music_Label_Service objService = new Music_Label_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Music_Label objMusic_Label = new RightsU_Dapper.Entity.Music_Label();
            if (Music_LabelCode != 0)
            {
                string str_Music_Label_Name = objFormCollection["Music_Label_Name"].ToString().Trim();
                objMusic_Label = objMusicLabelService.GetByID(Music_LabelCode);
                objMusic_Label.Music_Label_Name = str_Music_Label_Name;
                objMusic_Label.Last_Action_By = objLoginUser.Users_Code;

                //objMusic_Label.EntityState = State.Modified;
            }
            else
            {
                string str_Music_Label_Name = objFormCollection["Music_Label_Name"].ToString().Trim();
                objMusic_Label = new RightsU_Dapper.Entity.Music_Label();
                objMusic_Label.Is_Active = "Y";
                objMusic_Label.Music_Label_Name = str_Music_Label_Name;
                objMusic_Label.Inserted_By = objLoginUser.Users_Code;
                objMusic_Label.Inserted_On = System.DateTime.Now;
                //objMusic_Label.EntityState = State.Added;
            }
            objMusic_Label.Last_Updated_Time = System.DateTime.Now;
            dynamic resultSet;
            //bool isDuplicate = objService.Validate(objMusic_Label, out resultSet);
            bool isDuplicate = true;
            if (isDuplicate)
            {
                if (Music_LabelCode != 0)
                {
                    objMusicLabelService.UpdateEntity(objMusic_Label);
                }
                else
                {
                    objMusicLabelService.AddEntity(objMusic_Label);
                }

                bool isValid = true;//objService.Save(objMusic_Label, out resultSet);
                    if (isValid)
                {
                    lstMusic_Label_Searched = lstMusic_Label = objMusicLabelService.GetAll().Where(x => true).OrderByDescending(x => x.Last_Updated_Time).ToList();
                    if (Music_LabelCode > 0)
                    {
                        if (status == "E")
                            message = objMessageKey.CouldNotupdatedRecord;
                        else
                            message = objMessageKey.Recordupdatedsuccessfully;
                        //message = message.Replace("{ACTION}", "updated");
                    }
                    else
                    {
                        if (status == "E")
                            message = objMessageKey.CouldNotsavedRecord;
                        else
                            message = objMessageKey.RecordAddedSuccessfully;
                    }
                        //message = message.Replace("{ACTION}", "added");
                }
                else
                {
                    status = "E";
                    message = "";
                }
            }
            else
            {
                status = "E";
                message = "";
            }
            int recordLockingCode = Convert.ToInt32(Record_Code);
            CommonUtil objCommonUtil = new CommonUtil();
            objCommonUtil.Release_Record(recordLockingCode, objLoginEntity.ConnectionStringName);
            var obj = new
            {
                RecordCount = lstMusic_Label_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        #endregion
    }
}
