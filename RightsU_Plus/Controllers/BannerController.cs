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
    public class BannerController : BaseController
    {
        private List<Banner> lstBanner_Group
        {
            get
            {
                if (Session["lstBanner_Group"] == null)
                    Session["lstBanner_Group"] = new List<Attrib_Group>();
                return (List<Banner>)Session["lstBanner_Group"];
            }
            set
            {
                Session["lstBanner_Group"] = value;
            }
        }


        private List<Banner> lstBanner_Searched = new List<Banner>();

        private Banner lstBanner = new Banner();

        public ActionResult Index()
        {
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.LangCode = SysLanguageCode;
            List<Banner_Service> banner_Services = new List<Banner_Service>();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "L" });
            lstSort.Add(new SelectListItem { Text = "Banner Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Banner Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            return View();
        }


        public PartialViewResult BindBanner_List(int pageNo, int recordPerPage, int Banner_Code, string commandName, string sortType)
        {
            lstBanner_Searched = new Banner_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            ViewBag.BannerCode = Banner_Code;
            ViewBag.CommandName = commandName;
            if (sortType == "AA" || sortType == "AD")
            {
                ViewBag.SortAttrType = sortType;
            }
            List<Banner> lst = new List<Banner>();
            if(lstBanner_Group != null)
            {
                lstBanner_Searched = lstBanner_Group;
            }
            lst = lstBanner_Group.OrderBy(a => a.Banner_Code).ToList();
            int RecordCount = 0;
            RecordCount = lstBanner_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "L")
                {
                    lst = lstBanner_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "NA")
                {
                    lst = lstBanner_Searched.OrderBy(o => o.Banner_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                else if (sortType == "ND")
                {
                    lst = lstBanner_Searched.OrderByDescending(o => o.Banner_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }

            }

            if (commandName == "ADD")
            {
                var lstBannerType = lstBanner_Group.Select(s => s.Banner_Name).Distinct().ToList();
                ViewBag.AttribType = new SelectList(lstBannerType);

                List<SelectListItem> lstMultiSelect = new List<SelectListItem>();
                lstMultiSelect.Add(new SelectListItem { Text = "Yes", Value = "Y" });
                lstMultiSelect.Add(new SelectListItem { Selected = true, Text = "No", Value = "N" });
                ViewBag.MultiSelect = lstMultiSelect;
            }
            else if (commandName == "EDIT")
            {
                Banner_Service objBanner_Service = new Banner_Service(objLoginEntity.ConnectionStringName);

                lstBanner = objBanner_Service.GetById(Banner_Code);
                var lstBannerType = lstBanner_Searched.Select(s => s.Banner_Name).Distinct().ToList();
                ViewBag.AttribType = new SelectList(lstBannerType, lstBanner.Banner_Name);
            }

            return PartialView("_BindBannerGroup", lst);
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

        public JsonResult SearchBanner(string searchText)
        {
            lstBanner_Searched = new Banner_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList();
            if (!string.IsNullOrEmpty(searchText))
            {
                lstBanner_Searched = lstBanner_Searched.Where(a => a.Banner_Name.ToUpper().Contains(searchText.ToUpper()) || (a.Banner_Short_Name != null && a.Banner_Short_Name.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            var obj = new
            {
                Record_Count = lstBanner_Searched.Count
            };
            lstBanner_Group = lstBanner_Searched;
            return Json(obj);
        }

        public JsonResult CheckRecordLock(int BannerCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (BannerCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(BannerCode, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
        public JsonResult SaveBanner(int Banner_Code, string Banner_Name, string Banner_short_name)
        {
            string status = "S";
            string message = "";
            int UserId = objLoginUser.Users_Code;
            List<Banner> tempLstAttribGrp = new Banner_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList().Where(a => (a.Banner_Name == Banner_Name) && (a.Banner_Short_Name == Banner_short_name) && (a.Banner_Code != Banner_Code)).ToList();

            if (tempLstAttribGrp.Count == 0)
            {
                Banner_Service objBanner_Service = new Banner_Service(objLoginEntity.ConnectionStringName);

                lstBanner = null;

                if (Banner_Code > 0)
                {
                    Banner banner = new Banner_Service(objLoginEntity.ConnectionStringName).GetById(Banner_Code);
                    lstBanner = objBanner_Service.GetById(Banner_Code);
                    lstBanner.EntityState = State.Modified;
                    lstBanner.Inserted_By = banner.Inserted_By;
                }
                else
                {
                    lstBanner = new Banner();
                    lstBanner.EntityState = State.Added;
                    lstBanner.Inserted_By = UserId;
                }
                lstBanner.Banner_Short_Name = Banner_short_name;
                lstBanner.Banner_Name = Banner_Name;
                lstBanner.Inserted_On = DateTime.Now;
                lstBanner.Last_Action_By = UserId;
                lstBanner.Last_Updated_Time = DateTime.Now;

                dynamic resultSet;
                if (!objBanner_Service.Save(lstBanner, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    if(Banner_Code > 0)
                    {
                        message = objMessageKey.Recordupdatedsuccessfully;
                    }
                    else
                    {
                        message = objMessageKey.Recordsavedsuccessfully;
                    }
                    lstBanner_Searched = objBanner_Service.SearchFor(s => true).ToList();
                }
            }
            else
            {
                status = "E";
                message = "Entry for this record already Exists!";
            }

            var obj = new
            {
                RecordCount = lstBanner_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public ActionResult DeleteBanner(int id)
        {
            string message = "";
            Banner_Service objBanner_Service = new Banner_Service(objLoginEntity.ConnectionStringName);
            Banner bannerObj = objBanner_Service.GetById(id);
            bannerObj.EntityState = State.Deleted;
            dynamic resultSet;
            if (!objBanner_Service.Delete(bannerObj, out resultSet))
            {
                message = resultSet;
            }
            else
            {
                message = objMessageKey.RecordDeletedsuccessfully;
            }

            var obj = new
            {
                RecordCount = lstBanner_Searched.Count,
                Status = "S",
                Message = message
            };

            return Json(obj);
        }
    }
}