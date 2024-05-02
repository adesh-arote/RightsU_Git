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
    public class Event_PlatformController : BaseController
    {
        #region  Sessions
        private List<RightsU_Entities.Event_Platform> lstEvent_Platform
        {
            get
            {
                if (Session["lstEvent_Platform"] == null)
                    Session["lstEvent_Platform"] = new List<RightsU_Entities.Event_Platform>();
                return (List<RightsU_Entities.Event_Platform>)Session["lstEvent_Platform"];
            }
            set { Session["lstEvent_Platform"] = value; }
        }
        private List<Event_Platform> lstEvent_Platform_Searched = new List<Event_Platform>();

        #endregion

        public ActionResult Index()
        {
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Event Platform Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Event Platform Desc", Value = "ND" });
            ViewBag.SortType = lstSort;


            return View();
        }

        public PartialViewResult Bind_EventPlatForm(int pageNo, int recordPerPage, int Event_PlatformCode, string commandName, string sortType)
        {
            lstEvent_Platform_Searched = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            ViewBag.Event_PlatformCode = Event_PlatformCode;
            ViewBag.CommandName = commandName;
            List<Event_Platform> lst = new List<Event_Platform>();
            if (lstEvent_Platform != null)
            {
                lstEvent_Platform_Searched = lstEvent_Platform;
            }
            lst = lstEvent_Platform.OrderBy(a => a.Event_Platform_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstEvent_Platform_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstEvent_Platform_Searched.OrderByDescending(o => o.Last_UpDated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstEvent_Platform_Searched.OrderBy(o => o.Event_Platform_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lst = lstEvent_Platform_Searched.OrderByDescending(o => o.Event_Platform_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }

            }

            if (commandName == "ADD")
            {
                var lstAL_LabType = lstEvent_Platform.Select(s => s.Event_Platform_Name).Distinct().ToList();
                ViewBag.AttribType = new SelectList(lstAL_LabType);

                List<SelectListItem> lstMultiSelect = new List<SelectListItem>();
                lstMultiSelect.Add(new SelectListItem { Text = "Yes", Value = "Y" });
                lstMultiSelect.Add(new SelectListItem { Selected = true, Text = "No", Value = "N" });
                ViewBag.MultiSelect = lstMultiSelect;
            }
            else if (commandName == "EDIT")
            {
                Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
                Event_Platform ObjEvent_Platform = new Event_Platform();

                ObjEvent_Platform = objEvent_Platform_Service.GetById(Event_PlatformCode);
                //   var lstAL_LabType = lstAL_Lab_Searched.Select(s => s.AL_Lab_Name).Distinct().ToList();
                // ViewBag.AttribType = new SelectList(lstAL_LabType, lstAL_Lab.AL_Lab_Name);
            }

            return PartialView("_EventPlatform_List", lst);
        }
        public int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                    {
                        pageNo = v1;
                    }
                    else
                    {
                        pageNo = v1 + 1;
                    }
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                {
                    noOfRecordTake = recordCount - noOfRecordSkip;
                }
                else
                {
                    noOfRecordTake = recordPerPage;
                }
            }
            return pageNo;
        }

        public JsonResult Search_EventPlatform(string searchText)
        {
            lstEvent_Platform_Searched = new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            if (!string.IsNullOrEmpty(searchText))
            {
                lstEvent_Platform_Searched = lstEvent_Platform_Searched.Where(a => a.Event_Platform_Name.ToUpper().Contains(searchText.ToUpper()) || (a.Event_Platform_Name != null && a.Event_Platform_Name.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            var obj = new
            {
                Record_Count = lstEvent_Platform_Searched.Count
            };
            lstEvent_Platform = lstEvent_Platform_Searched;
            return Json(obj);
        }

        public JsonResult SaveEventPlatform(int EventPlatform_Code, string EventPlatform_Name, string EventPlatform_short_name)
        {
            string status = "S", message = "", Action = Convert.ToString(ActionType.C); // C = "Create";

            List<AL_Lab> tempLstAttribGrp = new AL_Lab_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList().Where(a => (a.AL_Lab_Name == EventPlatform_Name) && (a.AL_Lab_Short_Name == EventPlatform_short_name) && (a.AL_Lab_Code != EventPlatform_Code)).ToList();

            if (tempLstAttribGrp.Count == 0)
            {
                Event_Platform_Service objEvent_Platform_Service = new Event_Platform_Service(objLoginEntity.ConnectionStringName);
                Event_Platform Objevent_Platform = new Event_Platform();
               

                if (EventPlatform_Code > 0)
                {
                    Objevent_Platform = objEvent_Platform_Service.GetById(EventPlatform_Code);
                    Objevent_Platform.EntityState = State.Modified;
                }
                else
                {
                    Objevent_Platform = new Event_Platform();
                    Objevent_Platform.EntityState = State.Added;
                    Objevent_Platform.Inserted_By = objLoginUser.Users_Code;
                    Objevent_Platform.Inserted_On = DateTime.Now;
                }
                Objevent_Platform.Event_Platform_Name = EventPlatform_Name;
                Objevent_Platform.Short_Code = EventPlatform_short_name;
                Objevent_Platform.Last_Action_By = objLoginUser.Users_Code;
                Objevent_Platform.Last_UpDated_Time = DateTime.Now;

                dynamic resultSet;
                if (!objEvent_Platform_Service.Save(Objevent_Platform, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    if (EventPlatform_Code > 0)
                    {
                        message = objMessageKey.Recordupdatedsuccessfully;
                        Action = Convert.ToString(ActionType.U); // U = "Update";
                    }
                    else
                    {
                        message = objMessageKey.Recordsavedsuccessfully;
                    }
                    lstEvent_Platform_Searched = objEvent_Platform_Service.SearchFor(s => true).ToList();
                }
            }
            else
            {
                status = "E";
                message = "Entry for this record already Exists!";
            }

            var obj = new
            {
                RecordCount = lstEvent_Platform_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public JsonResult CheckRecordLock(int AL_LabCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (AL_LabCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(AL_LabCode, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public bool CheckIfLabIsUsed(int? LabCode)
        {
            List<Extended_Columns> lstExtColRefLab = new Extended_Columns_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => (w.Ref_Table != null && w.Ref_Table.ToUpper() == "AL_Lab".ToUpper())).ToList();
            int UsedCount = 0;
            foreach (Extended_Columns eg in lstExtColRefLab)
            {
                UsedCount = eg.Map_Extended_Columns.Where(w => w.Columns_Value_Code == LabCode).Count();
                if (UsedCount > 0)
                {
                    return false;
                }
                foreach (Map_Extended_Columns mec in eg.Map_Extended_Columns)
                {
                    UsedCount = mec.Map_Extended_Columns_Details.Where(w => w.Columns_Value_Code == LabCode).Count();
                    if (UsedCount > 0)
                    {
                        return false;
                    }
                }
            }

            return true;
        }
    }
}