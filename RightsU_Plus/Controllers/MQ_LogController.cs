
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
    public class MQ_LogController : BaseController
    {
        #region --- Properties ---
        private List<RightsU_Entities.MQ_Log> lstMQ_Log
        {
            get
            {
                if (Session["lstMQ_Log"] == null)
                    Session["lstMQ_Log"] = new List<RightsU_Entities.MQ_Log>();
                return (List<RightsU_Entities.MQ_Log>)Session["lstMQ_Log"];
            }
            set { Session["lstMQ_Log"] = value; }
        }

        private List<RightsU_Entities.MQ_Log> lstMQ_Log_Searched
        {
            get
            {
                if (Session["lstMQ_Log_Searched"] == null)
                    Session["lstMQ_Log_Searched"] = new List<RightsU_Entities.MQ_Log>();
                return (List<RightsU_Entities.MQ_Log>)Session["lstMQ_Log_Searched"];
            }
            set { Session["lstMQ_Log_Searched"] = value; }
        }

        #endregion


        public ViewResult Index()
        {
            lstMQ_Log_Searched = lstMQ_Log = new MQ_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).OrderByDescending(o => o.MQ_Log_Code).ToList();   
            return View("~/Views/MQ_Log/Index.cshtml");
        }

        public PartialViewResult BindMQ_LogList(int pageNo, int recordPerPage)
        {
            List<RightsU_Entities.MQ_Log> lst = new List<RightsU_Entities.MQ_Log>();
            int RecordCount = 0;
            RecordCount = lstMQ_Log_Searched.Count;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstMQ_Log_Searched.OrderByDescending(o => o.MQ_Config_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/MQ_Log/_MQ_LogList.cshtml", lst);
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
      
        #endregion

        public JsonResult SearchMQ_Log(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstMQ_Log_Searched = lstMQ_Log;
                //lstMQ_Log_Searched = lstMQ_Log.Where(w => w.Material_Type_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstMQ_Log_Searched = lstMQ_Log;

            var obj = new
            {
                Record_Count = lstMQ_Log_Searched.Count
            };
            return Json(obj);
        }
    }
}
