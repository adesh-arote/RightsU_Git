using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class LoadSheetController : BaseController
    {
        private List<RightsU_Entities.AL_Load_Sheet> lstAL_LoadSheet
        {
            get
            {
                if (Session["lstAL_Load_Sheet"] == null)
                    Session["lstAL_Load_Sheet"] = new List<RightsU_Entities.AL_Load_Sheet>();
                return (List<RightsU_Entities.AL_Load_Sheet>)Session["lstAL_Load_Sheet"];
            }
            set { Session["lstAL_Load_Sheet"] = value; }
        }

        private List<RightsU_Entities.AL_Load_Sheet> lstAL_Load_Sheet_Searched
        {
            get
            {
                if (Session["lstAL_Load_Sheet_Searched"] == null)
                    Session["lstAL_Load_Sheet_Searched"] = new List<RightsU_Entities.AL_Load_Sheet>();
                return (List<RightsU_Entities.AL_Load_Sheet>)Session["lstAL_Load_Sheet_Searched"];
            }
            set { Session["lstAL_Load_Sheet_Searched"] = value; }
        }

        List<USPAL_GetLoadsheetList_Result> lstLoadSheet_Searched
        {
            get
            {
                if (Session["lstLoadSheet_Searched"] == null)
                    Session["lstLoadSheet_Searched"] = new List<USPAL_GetLoadsheetList_Result>();
                return (List<USPAL_GetLoadsheetList_Result>)Session["lstLoadSheet_Searched"];
            }
            set
            {
                Session["lstLoadSheet_Searched"] = value;
            }
        }

        List<USPAL_GetBookingsheetDataForLoadsheet_Result> lstBookingsheetDataForLoadsheet_Searched
        {
            get
            {
                if (Session["lstBookingsheetDataForLoadsheet_Searched"] == null)
                    Session["lstBookingsheetDataForLoadsheet_Searched"] = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
                return (List<USPAL_GetBookingsheetDataForLoadsheet_Result>)Session["lstBookingsheetDataForLoadsheet_Searched"];
            }
            set
            {
                Session["lstBookingsheetDataForLoadsheet_Searched"] = value;
            }
        }

        private RightsU_Entities.AL_Load_Sheet objAL_Load_Sheet
        {
            get
            {
                if (Session["objAL_Load_Sheet"] == null)
                    Session["objAL_Load_Sheet"] = new RightsU_Entities.AL_Load_Sheet();
                return (RightsU_Entities.AL_Load_Sheet)Session["objAL_Load_Sheet"];
            }
            set { Session["objAL_Load_Sheet"] = value; }
        }

        private AL_Load_Sheet_Service objAL_Load_Sheet_Service
        {
            get
            {
                if (Session["objAL_Load_Sheet_Service"] == null)
                    Session["objAL_Load_Sheet_Service"] = new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName);
                return (AL_Load_Sheet_Service)Session["objAL_Load_Sheet_Service"];
            }
            set { Session["objCurrency_Service"] = value; }
        }

        // GET: LoadSheet
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCurrency);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForCurrency.ToString();
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = SysLanguageCode;
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            lstLoadSheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
            return View("~/Views/LoadSheet/Index.cshtml");
        }
       
        public JsonResult SearchBookingsheet(string loadsheetMonth = "", int loadsheetCode = 0, string CommandName = "")
        {
            
            if (!string.IsNullOrEmpty(loadsheetMonth) || (loadsheetCode > 0))
            {
                lstBookingsheetDataForLoadsheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingsheetDataForLoadsheet(loadsheetMonth, loadsheetCode).ToList();
            }
            else
            {
                lstBookingsheetDataForLoadsheet_Searched = null;
                lstBookingsheetDataForLoadsheet_Searched = lstBookingsheetDataForLoadsheet_Searched;
            }
            
            var obj = new
            {
                Record_Count = lstBookingsheetDataForLoadsheet_Searched.Count
            };

            return Json(obj);
        }

        public PartialViewResult OpenBookingsheetPopup(string CommandName, string LoadSheetMonth = "", int AL_Load_Sheet_Code = 0)
        {
            List<USPAL_GetBookingsheetDataForLoadsheet_Result> lst = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();

            ViewBag.CommandName = CommandName;
            ViewBag.AL_Load_Sheet_Code = AL_Load_Sheet_Code;

            if(CommandName == "VIEW")
            {
                AL_Load_Sheet objLoadSheet = objAL_Load_Sheet_Service.SearchFor(s => true).Where(w => w.AL_Load_Sheet_Code == AL_Load_Sheet_Code).FirstOrDefault();
                ViewBag.LoadsheetMonth = Convert.ToDateTime(objLoadSheet.Load_Sheet_Month).ToString("MMMM yyyy");
                ViewBag.LSRemark = objLoadSheet.Remarks;
            }
            
            return PartialView("~/Views/LoadSheet/_AddLoadSheet.cshtml", lst);
        }

        public PartialViewResult BindBookingsheet(int pageNo, int recordPerPage, string sortType, string CommandName = "")
        {
            List<USPAL_GetBookingsheetDataForLoadsheet_Result> lst = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
            
            lst = lstBookingsheetDataForLoadsheet_Searched;          
            
            int RecordCount = 0;
            RecordCount = lstBookingsheetDataForLoadsheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.CommandName = CommandName;

            return PartialView("~/Views/LoadSheet/_BookingsheetList.cshtml", lst);
        }

        public PartialViewResult BindLoadSheetList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetLoadsheetList_Result> lst = new List<USPAL_GetLoadsheetList_Result>();
            int RecordCount = 0;
            RecordCount = lstLoadSheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstLoadSheet_Searched.OrderByDescending(o => o.Inserted_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstLoadSheet_Searched.OrderBy(o => o.AL_Load_Sheet_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstLoadSheet_Searched.OrderByDescending(o => o.AL_Load_Sheet_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/LoadSheet/_LoadSheetList.cshtml", lst);
        }

        public JsonResult SearchLoadSheet(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstLoadSheet_Searched = lstLoadSheet_Searched.Where(w => w.Load_sheet_No.ToUpper().Contains(searchText.ToUpper())
                || w.Status.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstLoadSheet_Searched = lstLoadSheet_Searched;

            var obj = new
            {
                Record_Count = lstLoadSheet_Searched.Count
            };

            return Json(obj);
        }

        public JsonResult GenerateLoadSheet(string bookingSheetCodes, string Remark, DateTime LoadSheetMonth)
        {
            string status = "S", message = "";

            List<AL_Load_Sheet_Details> lst = new List<AL_Load_Sheet_Details>();
            try
            {
                foreach (var item in bookingSheetCodes.Split(','))
                {
                    AL_Load_Sheet_Details objloadSheetDetails = new AL_Load_Sheet_Details();
                    objloadSheetDetails.AL_Booking_Sheet_Code = Convert.ToInt32(item);

                    lst.Add(objloadSheetDetails);
                }

                objAL_Load_Sheet_Service = null;
                objAL_Load_Sheet.EntityState = State.Added;
                objAL_Load_Sheet.Load_Sheet_No = "LS-" + GenerateId();
                objAL_Load_Sheet.Load_Sheet_Month = LoadSheetMonth;
                objAL_Load_Sheet.Remarks = Remark;
                objAL_Load_Sheet.Status = "P";
                objAL_Load_Sheet.Inserted_By = objLoginUser.Users_Code;
                objAL_Load_Sheet.Inserted_On = DateTime.Now;
                objAL_Load_Sheet.Updated_By = objLoginUser.Users_Code;
                objAL_Load_Sheet.Updated_On = DateTime.Now;
                objAL_Load_Sheet.AL_Load_Sheet_Details = lst;

                dynamic resultSet;
                if (!objAL_Load_Sheet_Service.Save(objAL_Load_Sheet, out resultSet))
                {
                    status = "E";
                    message = resultSet;
                }
                else
                {
                    message = objMessageKey.Recordsavedsuccessfully;

                    objAL_Load_Sheet = null;
                    objAL_Load_Sheet_Service = null;

                    lstLoadSheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
                    //FetchData();
                }
            }
            catch(Exception ex)
            {
                message = "Please search loadsheet for month and Select atleast one booking sheet.";
                status = "E";
            }

            var obj = new
            {
                RecordCount = lstLoadSheet_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public JsonResult RefreshLoadSheet(int AL_Load_Sheet_Code)
        {
            string status = "S", message = "";
            AL_Load_Sheet_Service objService = new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName);
            AL_Load_Sheet objToSave = new AL_Load_Sheet();

            List<AL_Load_Sheet_Details> lst = new List<AL_Load_Sheet_Details>();
            objToSave = objService.GetById(AL_Load_Sheet_Code);

            //objToSave.AL_Load_Sheet_Details = new AL_Load_Sheet_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code).ToList();
            objToSave.EntityState = State.Modified;
            objToSave.Status = "P";
            objToSave.Download_File_Name = "";

            dynamic resultSet;
            bool isValid = objService.Save(objToSave, out resultSet);

            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                message = objMessageKey.Recordsavedsuccessfully;

                objAL_Load_Sheet = null;
                objAL_Load_Sheet_Service = null;

                lstLoadSheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
                //FetchData();
            }

            var obj = new
            {
                RecordCount = lstLoadSheet_Searched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCurrency), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
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

        public JsonResult GetLoadSheetStatus(int AL_Load_Sheet_Code)
        {
            string recordStatus = new RightsU_BLL.AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code).Select(s => s.Status).FirstOrDefault();
            double TotalCount = new RightsU_BLL.AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code).Count();
            double PendingCount = new RightsU_BLL.AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.AL_Load_Sheet_Code == AL_Load_Sheet_Code && x.Status == "P").Count();

            var obj = new
            {
                RecordStatus = recordStatus,
                TotalCount = TotalCount,
                PendingCount = PendingCount
            };
            return Json(obj);
        }

        public JsonResult ValidateDownload(int AL_Load_Sheet_Code)
        {
            string FileName = Convert.ToString(new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).GetById(AL_Load_Sheet_Code).Download_File_Name);
            string fullPath = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadFilePath"]);
            string path = fullPath + FileName;
            FileInfo file = new FileInfo(path);
            if (file.Exists)
            {
                var obj = new
                {
                    path = path
                };
                return Json(obj);
            }
            else
            {
                var obj = new
                {
                    path = ""
                };
                return Json(obj);
            }
        }

        public void Download(int AL_Load_Sheet_Code)
        {
            string FileName = new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName).GetById(AL_Load_Sheet_Code).Download_File_Name.ToString();
            string fullPath = (Server.MapPath("~") + "\\" + System.Configuration.ConfigurationManager.AppSettings["UploadFilePath"]);
            string path = fullPath + FileName;
            FileInfo file = new FileInfo(path);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            if (file.Exists)
            {
                byte[] bts = System.IO.File.ReadAllBytes(path);
                Response.Clear();
                Response.ClearHeaders();
                Response.AddHeader("Content-Type", "Application/ms-excel");
                Response.AddHeader("Content-Length", bts.Length.ToString());
                Response.AddHeader("Content-Disposition", "attachment;   filename=" + FileName);
                Response.BinaryWrite(bts);
                Response.Flush();
                //WebClient client = new WebClient();
                //Byte[] buffer = client.DownloadData(path);
                //Response.Clear();
                //Response.ContentType = "application/ms-excel";
                //Response.AddHeader("content-disposition", "Attachment;filename=" + fileName);
                //Response.WriteFile(path);
                //Response.End();

            }
        }

        private string GenerateId()
        {
            string demo = "";
            //string LS_No = objAL_Load_Sheet_Service.SearchFor(x => true).OrderByDescending(x => x.AL_Load_Sheet_Code).FirstOrDefault().Load_Sheet_No;     // get this value from database
            string LS_No = objAL_Load_Sheet_Service.SearchFor(x => true).OrderByDescending(x => x.AL_Load_Sheet_Code).Select(s => s.Load_Sheet_No).FirstOrDefault();
            if (!string.IsNullOrEmpty(LS_No))
            {
                int lastAddedId = Convert.ToInt32(LS_No.Split('-')[1]); 
                demo = Convert.ToString(lastAddedId + 1).PadLeft(4, '0');
            }
            else
            {
                int lastAddedId = 0000; 
                demo = Convert.ToString(lastAddedId + 1).PadLeft(4, '0');
            }
            
            return demo;
            // it will return 0009
        }       
    }
}