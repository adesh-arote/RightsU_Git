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
    public class AL_LabController : BaseController
    {
        private List<AL_Lab> lstAL_Lab_Group
        {
            get
            {
                if (Session["lstAL_Lab_Group"] == null)
                    Session["lstAL_Lab_Group"] = new List<AL_Lab>();
                return (List<AL_Lab>)Session["lstAL_Lab_Group"];
            }
            set
            {
                Session["lstAL_Lab_Group"] = value;
            }
        }

        private List<AL_Lab> lstAL_Lab_Searched = new List<AL_Lab>();

        private AL_Lab lstAL_Lab = new AL_Lab();

        public ActionResult Index()
        {
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.LangCode = SysLanguageCode;
            List<AL_Lab_Service> AL_Lab_Services = new List<AL_Lab_Service>();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            return View();
        }

        public PartialViewResult BindAL_Lab_List(int pageNo, int recordPerPage, int AL_Lab_Code, string commandName, string sortType)
        {
            lstAL_Lab_Searched = new AL_Lab_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            ViewBag.AL_LabCode = AL_Lab_Code;
            ViewBag.CommandName = commandName;
            //if (sortType == "AA" || sortType == "AD")
            //{
            //    ViewBag.SortAttrType = sortType;
            //}
            List<AL_Lab> lst = new List<AL_Lab>();
            if (lstAL_Lab_Group != null)
            {
                lstAL_Lab_Searched = lstAL_Lab_Group;
            }
            lst = lstAL_Lab_Group.OrderBy(a => a.AL_Lab_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstAL_Lab_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstAL_Lab_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstAL_Lab_Searched.OrderBy(o => o.AL_Lab_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lst = lstAL_Lab_Searched.OrderByDescending(o => o.AL_Lab_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }

            }

            if (commandName == "ADD")
            {
                var lstAL_LabType = lstAL_Lab_Group.Select(s => s.AL_Lab_Name).Distinct().ToList();
                ViewBag.AttribType = new SelectList(lstAL_LabType);

                List<SelectListItem> lstMultiSelect = new List<SelectListItem>();
                lstMultiSelect.Add(new SelectListItem { Text = "Yes", Value = "Y" });
                lstMultiSelect.Add(new SelectListItem { Selected = true, Text = "No", Value = "N" });
                ViewBag.MultiSelect = lstMultiSelect;
            }
            else if (commandName == "EDIT")
            {
                AL_Lab_Service objAL_Lab_Service = new AL_Lab_Service(objLoginEntity.ConnectionStringName);

                lstAL_Lab = objAL_Lab_Service.GetById(AL_Lab_Code);
                var lstAL_LabType = lstAL_Lab_Searched.Select(s => s.AL_Lab_Name).Distinct().ToList();
                ViewBag.AttribType = new SelectList(lstAL_LabType, lstAL_Lab.AL_Lab_Name);
            }

            return PartialView("_BindAL_LabGroup", lst);
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

        public JsonResult SearchAL_Lab(string searchText)
        {
            lstAL_Lab_Searched = new AL_Lab_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            if (!string.IsNullOrEmpty(searchText))
            {
                lstAL_Lab_Searched = lstAL_Lab_Searched.Where(a => a.AL_Lab_Name.ToUpper().Contains(searchText.ToUpper()) || (a.AL_Lab_Short_Name != null && a.AL_Lab_Short_Name.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            var obj = new
            {
                Record_Count = lstAL_Lab_Searched.Count
            };
            lstAL_Lab_Group = lstAL_Lab_Searched;
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

        public JsonResult SaveAL_Lab(int AL_Lab_Code, string AL_Lab_Name, string AL_Lab_short_name, string AL_Lab_Contact_person)
        {
            string status = "S";
            string message = "";
            int UserId = objLoginUser.Users_Code;
            List<AL_Lab> tempLstAttribGrp = new AL_Lab_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList().Where(a => (a.AL_Lab_Name == AL_Lab_Name) && (a.AL_Lab_Short_Name == AL_Lab_short_name) && (a.AL_Lab_Code != AL_Lab_Code)).ToList();

            if (tempLstAttribGrp.Count == 0)
            {
                AL_Lab_Service objAL_Lab_Service = new AL_Lab_Service(objLoginEntity.ConnectionStringName);

                lstAL_Lab = null;

                if (AL_Lab_Code > 0)
                {
                    AL_Lab AL_Lab = new AL_Lab_Service(objLoginEntity.ConnectionStringName).GetById(AL_Lab_Code);
                    lstAL_Lab = objAL_Lab_Service.GetById(AL_Lab_Code);
                    lstAL_Lab.EntityState = State.Modified;
                    lstAL_Lab.Inserted_By = AL_Lab.Inserted_By;
                }
                else
                {
                    lstAL_Lab = new AL_Lab();
                    lstAL_Lab.EntityState = State.Added;
                    lstAL_Lab.Inserted_By = UserId;
                }
                lstAL_Lab.AL_Lab_Name = AL_Lab_Name;
                lstAL_Lab.AL_Lab_Short_Name = AL_Lab_short_name;
                lstAL_Lab.Contact_Person = AL_Lab_Contact_person;
                lstAL_Lab.Inserted_On = DateTime.Now;
                lstAL_Lab.Last_Action_By = UserId;
                lstAL_Lab.Last_Updated_Time = DateTime.Now;

                dynamic resultSet;
                if (!objAL_Lab_Service.Save(lstAL_Lab, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    if (AL_Lab_Code > 0)
                    {
                        message = objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        message = objMessageKey.Recordsavedsuccessfully;
                    }
                    lstAL_Lab_Searched = objAL_Lab_Service.SearchFor(s => true).ToList();
                }
            }
            else
            {
                status = "E";
                message = "Entry for this record already Exists!";
            }

            var obj = new
            {
                RecordCount = lstAL_Lab_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public ActionResult DeleteAL_Lab(int id)
        {
            string message = "";
            AL_Lab_Service objAL_Lab_Service = new AL_Lab_Service(objLoginEntity.ConnectionStringName);
            AL_Lab AL_LabObj = objAL_Lab_Service.GetById(id);
            AL_LabObj.EntityState = State.Deleted;
            dynamic resultSet;
            if (!objAL_Lab_Service.Delete(AL_LabObj, out resultSet))
            {
                message = resultSet;
            }
            else
            {
                message = objMessageKey.RecordDeletedsuccessfully;
            }

            var obj = new
            {
                RecordCount = lstAL_Lab_Searched.Count,
                Status = "S",
                Message = message
            };

            return Json(obj);
        }
    }
}