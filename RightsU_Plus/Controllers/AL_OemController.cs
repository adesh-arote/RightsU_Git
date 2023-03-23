using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class AL_OemController : BaseController
    {
        private List<RightsU_Entities.AL_OEM> lstOem_Searched
        {
            get
            {
                if (Session["lstOem_Searched"] == null)
                    Session["lstOem_Searched"] = new List<RightsU_Entities.AL_OEM>();
                return (List<RightsU_Entities.AL_OEM>)Session["lstOem_Searched"];
            }
            set { Session["lstOem_Searched"] = value; }
        }
        public ActionResult Index()
        {
            ViewBag.Message = "";
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Device Name Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Device Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;
            if (Session["Message"] != null)
            {                                            //-----To add edit success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }
            return View();
        }
        public PartialViewResult BindALOemList(int pageNo, int recordPerPage, string sortType, string CommandName, int AL_OemCode)
        {
            List<RightsU_Entities.AL_OEM> lst = new List<RightsU_Entities.AL_OEM>();
            int RecordCount = 0;
            RecordCount = lstOem_Searched.Count;
            Session["TotalRecord"] = RecordCount;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstOem_Searched.OrderByDescending(o => o.AL_OEM_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
                //else if (sortType == "NA")
                //{
                //    lst = lstOem_Searched.OrderBy(o => o.Device_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //}
                //else
                //{
                //    lst = lstOem_Searched.OrderByDescending(o => o.Device_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //}
            }
            if (CommandName == "ADD")
            {
                TempData["Action"] = "AddALOem";
            }
            if (CommandName == "EDIT")
            {
                TempData["Action"] = "EditALOem";
                TempData["Id"] = AL_OemCode;
            }
            return PartialView("~/Views/AL_Oem/_BindALOemList.cshtml", lst);
        }
        public void FetchData()
        {
            AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
            lstOem_Searched = aL_OEM_Service.SearchFor(x => true).OrderBy(o => o.AL_OEM_Code).ToList();
        }
        public JsonResult SearchALOem(string searchText)
        {
            FetchData();
            if (!string.IsNullOrEmpty(searchText))
            {
                //lstOem_Searched = lstOem_Searched.Where(w => w.Device_Name.ToUpper().Contains(searchText.ToUpper())
                //|| w.MPEG != null && w.MPEG.ToUpper().Contains(searchText.ToUpper())
                //|| w.Company != null && w.Company.ToUpper().Contains(searchText.ToUpper())
                //|| w.Aspect_Ratio != null && w.Aspect_Ratio.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
            {
                FetchData();
            }
            var obj = new
            {
                Record_Count = lstOem_Searched.Count
            };
            return Json(obj);
        }
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

        [HttpPost]
        public ActionResult SaveOEM(int Id, AL_OEM obj)
        {
            try
            {
                string Message = "", Status = "";
                AL_OEM aL_OEM = new AL_OEM();
                AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
                if (Id == 0)
                {
                    //aL_OEM.Device_Name = obj.Device_Name;
                    //aL_OEM.Company = obj.Company;
                    //aL_OEM.Aspect_Ratio = obj.Aspect_Ratio;
                    //aL_OEM.MPEG = obj.MPEG;
                    aL_OEM.Inserted_On = DateTime.Now;
                    aL_OEM.Inserted_By = objLoginUser.Users_Code;

                    aL_OEM.EntityState = State.Added;
                }
                else
                {
                    aL_OEM = aL_OEM_Service.GetById(Id);

                    //aL_OEM.Device_Name = obj.Device_Name;
                    //aL_OEM.Company = obj.Company;
                    //aL_OEM.Aspect_Ratio = obj.Aspect_Ratio;
                    //aL_OEM.MPEG = obj.MPEG;
                    aL_OEM.Inserted_On = aL_OEM.Inserted_On;
                    aL_OEM.Inserted_By = aL_OEM.Inserted_By;
                    aL_OEM.Last_Updated_Time = DateTime.Now;
                    aL_OEM.Last_Action_By = objLoginUser.Users_Code;

                    aL_OEM.EntityState = State.Modified;
                }
                dynamic resultSet;
                if (!aL_OEM_Service.Save(aL_OEM, out resultSet))
                {
                    Message = resultSet;
                    Status = "E";
                }
                else
                {
                    if (Id == 0)
                    {
                        Session["Message"] = objMessageKey.RecordAddedSuccessfully;
                    }
                    else
                    {
                        Session["Message"] = objMessageKey.Recordupdatedsuccessfully;
                    }
                    Status = "S";
                }
                var Obj = new
                {
                    Status = Status,
                    Message = Message
                };

                return Json(Obj);
            }
            catch (Exception ex)
            {
                string Message = ex.Message;
                throw;
            }
        }
        public ActionResult DeleteAlOem(int Id)
        {
            try
            {
                string Message = "", Status = "";
                AL_OEM aL_OEM = new AL_OEM();
                AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
                aL_OEM = aL_OEM_Service.GetById(Id);
                aL_OEM.EntityState = State.Deleted;

                dynamic resultSet;
                if (!aL_OEM_Service.Delete(aL_OEM, out resultSet))
                {
                    Message = resultSet;
                    Status = "E";
                }
                else
                {
                    Session["Message"] = objMessageKey.RecordDeletedsuccessfully;
                    Status = "S";
                }
                var Obj = new
                {
                    Status = Status,
                    Message = Message
                };

                return Json(Obj);
            }
            catch (Exception ex)
            {
                string Message = ex.Message;
                throw;
            }

        }
        [HttpPost]
        public JsonResult CheckRecordLock(int AL_OemCode)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            if (AL_OemCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(AL_OemCode, GlobalParams.ModuleCodeForLanguage, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }

            if (isLocked == false)
            {
                AL_OEM aL_OEM = new AL_OEM();
                AL_OEM_Service aL_OEM_Service = new AL_OEM_Service(objLoginEntity.ConnectionStringName);
                aL_OEM = aL_OEM_Service.GetById(AL_OemCode);
                aL_OEM.Lock_Time = DateTime.Now;
                aL_OEM.EntityState = State.Modified;
                dynamic resultSet;
                aL_OEM_Service.Save(aL_OEM, out resultSet);
            }

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }
    }
}