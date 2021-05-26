using System.Data.Entity.Core.Objects;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Collections;

//using RightsU_BLL;
//using RightsU_Dapper.Entity.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;
using System.Xml;
using System.IO;
using System.Text;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity.StoredProcedure_Entities;

namespace RightsU_Plus.Controllers
{
    public class BV_LogController : BaseController
    {
        private readonly System_Parameter_NewService objSPNService = new System_Parameter_NewService();
        private readonly BMS_Log_Service objBMSLogService = new BMS_Log_Service();
        private readonly USP_List_BMS_log_Service objUSPService =  new USP_List_BMS_log_Service();
        private readonly BMS_All_Masters_Service objBMSAllMastersService = new BMS_All_Masters_Service();
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();

        private List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lstBMS_Log
        {
            get
            {
                if (Session["lstBMS_Log"] == null)
                    Session["lstBMS_Log"] = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();
                return (List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>)Session["lstBMS_Log"];
            }
            set { Session["lstBMS_Log"] = value; }
        }

        private List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lstBMS_Log_Searched
        {
            get
            {
                if (Session["lstBMS_Log_Searched"] == null)
                    Session["lstBMS_Log_Searched"] = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();
                return (List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>)Session["lstBMS_Log_Searched"];
            }
            set { Session["lstBMS_Log_Searched"] = value; }
        }

        private List<RightsU_Dapper.Entity.Master_Entities.BMS_All_Masters> lstBMS_All_Masters
        {
            get
            {
                if (Session["lstBMS_All_Masters"] == null)
                    Session["lstBMS_All_Masters"] = new List<RightsU_Dapper.Entity.Master_Entities.BMS_All_Masters>();
                return (List<RightsU_Dapper.Entity.Master_Entities.BMS_All_Masters>)Session["lstBMS_All_Masters"];
            }
            set { Session["lstBMS_All_Masters"] = value; }
        }

        private List<RightsU_Dapper.Entity.Master_Entities.BMS_All_Masters> lstBMS_All_Masters_Searched
        {
            get
            {
                if (Session["lstBMS_All_Masters_Searched"] == null)
                    Session["lstBMS_All_Masters_Searched"] = new List<RightsU_Dapper.Entity.Master_Entities.BMS_All_Masters>();
                return (List<RightsU_Dapper.Entity.Master_Entities.BMS_All_Masters>)Session["lstBMS_All_Masters_Searched"];
            }
            set { Session["lstBMS_All_Masters_Searched"] = value; }
        }

        private RightsU_Dapper.Entity.Master_Entities.BMS_Log objBMSLog
        {
            get
            {
                if (Session["objBMSLog"] == null)
                    Session["objBMSLog"] = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();
                return (RightsU_Dapper.Entity.Master_Entities.BMS_Log)Session["objBMSLog"];
            }
            set { Session["objCurrency"] = value; }
        }

        //private BMS_Log_Service objBMSLog_Service
        //{
        //    get
        //    {
        //        if (Session["objBMSLog_Service"] == null)
        //            Session["objBMSLog_Service"] = new BMS_Log_Service(objLoginEntity.ConnectionStringName);
        //        return (BMS_Log_Service)Session["objBMSLog_Service"];
        //    }
        //    set { Session["objBMSLog_Service"] = value; }
        //}



        public BV_Log_Search objPage_Properties
        {
            get
            {
                if (Session["BV_Log_Search_Page_Properties"] == null)
                    Session["BV_Log_Search_Page_Properties"] = new BV_Log_Search();
                return (BV_Log_Search)Session["BV_Log_Search_Page_Properties"];
            }
            set { Session["BV_Log_Search_Page_Properties"] = value; }
        }

        //private List<SelectListItem> BindModuleName()
        //{
        //    List<SelectListItem> lstTitleType = new List<SelectListItem>();

        //    lstTitleType = new SelectList(new BMS_All_Masters_Service().SearchFor(x => x.Module_Name == "Y" && x.Is_Active == "Y"), "Music_Type_Code", "Music_Type_Name", Convert.ToInt32(objTitle.Music_Type_Code)).ToList();
        //    lstTitleType.Insert(0, new SelectListItem() { Value = "0", Text = "Please Select" });

        //    return lstTitleType;
        //}

        #region ---------------BIND DROPDOWNS---------------
        private List<USP_List_BMS_log_Result> BindAllDropDowns()
        {
            int resultSet = 0;
            //ObjectParameter objresultSet = new ObjectParameter("resultSet", resultSet);
            int objresultSet = 0;
            // List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new USP_Service().USP_Get_Acq_PreReq("DTG,DTP,DTC,BUT,VEN,DIR,TIT", "LST", objLoginUser.Users_Code, 0, Convert.ToInt32(obj_Acq_Syn_List_Search.DealType_Search), obj_Acq_Syn_List_Search.BUCodes_Search).ToList();
            List<USP_List_BMS_log_Result> obj_USP_List_BMS_log_Result = objUSPService.USP_List_BMS_log("AND 1=1", 1, "Y", 10,out objresultSet).ToList();

            return obj_USP_List_BMS_log_Result;
        }
        //public JsonResult OnChangeBindTitle(int? dealTypeCode, int? BUCode)
        //{
        //    return Json(BindTitle(dealTypeCode, BUCode), JsonRequestBehavior.AllowGet);
        //}
        //private MultiSelectList BindTitle(int? Deal_Type_Code, int? BUCode)
        //{
        //    Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
        //    MultiSelectList lstTitle = new MultiSelectList(objTS.SearchFor(T => T.Is_Active == "Y" &&
        //                                         T.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BUCode && AM.Title_Code == T.Title_Code)
        //                                           && (T.Deal_Type_Code == Deal_Type_Code || Deal_Type_Code == 0)
        //)
        //                             .Select(R => new { Title_Name = R.Title_Name, Title_Code = R.Title_Code }), "Title_Code", "Title_Name", obj_Acq_Syn_List_Search.TitleCodes_Search.Split(','));
        //    return lstTitle;
        //}
        //private SelectList BindWorkflowStatus()
        //{

        //    return new SelectList(new Deal_Workflow_Status_Service().SearchFor(x => x.Deal_Type == "A"), "Deal_WorkflowFlag", "Deal_Workflow_Status_Name");
        //}
        #endregion

        public JsonResult BindAdvanced_Search_Controls(string Module_Name = "", string Method_Type = "", string Record_Status = "", string Request_Xml = "")
        {

            int recordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);

            //List<USP_List_BMS_log_Result> obj_USP_List_BMS_log_Result = new USP_Service().USP_List_BMS_log("AND 1=1", 2, "Y", 10, objRecordCount).ToList();


            Dictionary<string, object> objJson = new Dictionary<string, object>();

            int Original_Language_code = Convert.ToInt32(objSPNService.GetList().Where(y => y.Parameter_Name == "Title_OriginalLanguage").Select(i => i.Parameter_Value).FirstOrDefault());

            //SelectList lstModuleName = new SelectList(new BMS_All_Masters_Service().SearchFor(x => x.Is_Active == "Y")
            //   .Select(i => new { Display_Value = i.Order_Id, Display_Text = i.Module_Name }).ToList(),
            //   "Display_Value", "Display_Text", Module_Name.Split(','));

            SelectList lstModuleName = new SelectList(objBMSAllMastersService.GetAll().Where(x => true).Select(i => new { Display_Value = i.Order_Id, Display_Text = i.Module_Name }).ToList(),
                "Display_Value", "Display_Text", Module_Name.Split(','));
            SelectList lstMethodType = new SelectList(objBMSLogService.GetAll().Where(x => true).Select(i => i.Method_Type).Distinct().ToList());
            //.Select(i => new {Display_Text = i.Method_Type }).Distinct().ToList());

            //SelectList lstRecordStatus = new SelectList(new BMS_Log_Service().SearchFor(x => true).Select(i => i.Record_Status).Distinct().ToList());

            List<SelectListItem> lstRecordStatus = new List<SelectListItem>();
            lstRecordStatus.Add(new SelectListItem() { Text = "Error"});
            lstRecordStatus.Add(new SelectListItem() { Text = "Complete"});
            lstRecordStatus.Add(new SelectListItem() { Text = "Pending"});


            objJson.Add("lstModuleName", lstModuleName);
            objJson.Add("lstMethodType", lstMethodType);
            objJson.Add("lstRecordStatus", lstRecordStatus);

            return Json(objJson);
        }



        public JsonResult AdvanceSearch(string SrchModuleName = "", string SrchModuleType = "", string SrchRecordStatus = "", string SrchRequestXML = "", string SrchResponseXML = "", string SrchRequestTime = "", string SrchResponseTime = "")
        {
            string tempString= "";
            if(SrchRecordStatus == "Error")
            {
                tempString = "E";
            }
            if (SrchRecordStatus == "Complete")
            {
                tempString = "D";
            }
            if (SrchRecordStatus == "Pending")
            {
                tempString = "10E";
            }


            objPage_Properties.ModuleName = SrchModuleName;
            objPage_Properties.MethodType = SrchModuleType;
            objPage_Properties.RecordStatus = tempString;
            objPage_Properties.RequestXML = SrchRequestXML;
            objPage_Properties.ResponseXML = SrchResponseXML;
            objPage_Properties.RequestTime = SrchRequestTime;
            objPage_Properties.ResponseTime = SrchResponseTime;

            ViewBag.RC = "";
            List<USP_List_BMS_log_Result> obj_USP_List_BMS_log_Result = new List<USP_List_BMS_log_Result>();

            List<USP_List_BMS_log_Result> lst1 = new List<USP_List_BMS_log_Result>();
            //List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lst1 = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();

            List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lst = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();
            int RecordCount = 0;
            RecordCount = lstBMS_Log_Searched.Count;
           

                string query = "";

                if (objPage_Properties.ModuleName != "0" && objPage_Properties.ModuleName != "")
                {
                    query = "AND";
                    int code = Convert.ToInt32(objPage_Properties.ModuleName);
                    var moduleName = lstBMS_All_Masters_Searched.Where(x => x.Order_Id == code).Select(X => X.Module_Name).SingleOrDefault();
                    query = query + " Module_Name = '" + moduleName + "'";
                }
                if (objPage_Properties.MethodType != "--Please Select--" && objPage_Properties.MethodType != "")
                {
                    query = query + " AND Method_Type = '" + objPage_Properties.MethodType + "'";
                }

                if (objPage_Properties.RecordStatus != "--Please Select--" && objPage_Properties.RecordStatus != "")
                {
                    query = query + " AND  Record_Status = '" + objPage_Properties.RecordStatus + "'";
                }
                if (objPage_Properties.RequestXML != "")
                {
                    query = query + " AND  Request_Xml like '%" + objPage_Properties.RequestXML + "%'";
                }

                if (objPage_Properties.ResponseXML != "")
                {
                    query = query + "   AND  Response_Xml like '%" + objPage_Properties.ResponseXML + "%'  ";
                }
                if (objPage_Properties.RequestTime != "" && objPage_Properties.ResponseTime != "")
                {
                    query = query + " AND (Request_Time between CONVERT(datetime,'" + objPage_Properties.RequestTime + "',105) AND  CONVERT(datetime,'" + objPage_Properties.ResponseTime + "',105) OR  Response_Time between CONVERT(datetime,'" + objPage_Properties.RequestTime + "',105)  AND  CONVERT(datetime,'" + objPage_Properties.ResponseTime + "',105))";

                }
                int recordCount = 0;
              //  ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
                int objRecordCount = 0;
                obj_USP_List_BMS_log_Result = objUSPService.USP_List_BMS_log(query, 1, "Y", 50,out objRecordCount).ToList();
                foreach (var item in obj_USP_List_BMS_log_Result)
                {
                    RightsU_Dapper.Entity.Master_Entities.BMS_Log objbvlog = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();
                    objbvlog.BMS_Log_Code = item.BMS_Log_Code;
                    objbvlog.Module_Name = item.Module_Name;
                    objbvlog.Method_Type = item.Method_Type;
                    objbvlog.Request_Time = item.Request_Time;
                    objbvlog.Request_Xml = item.Request_Xml;
                    objbvlog.Response_Time = item.Response_Time;
                    objbvlog.Response_Xml = item.Response_Xml;
                    objbvlog.Record_Status = item.Record_Status;
                    objbvlog.Error_Description = item.Error_Description;
                    lst.Add(objbvlog);
                }
                ViewBag.RC = objRecordCount;


            

            var obj = new
            {
                Record_Count = objRecordCount
            };
            return Json(obj);
        }


        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

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

        public PartialViewResult BindBVLogList(int pageNo, int pageSize, int recordPerPage, string ADSearch, string searchtext)
        {
            ViewBag.RC = "";
            List<USP_List_BMS_log_Result> obj_USP_List_BMS_log_Result = new List<USP_List_BMS_log_Result>();

            List<USP_List_BMS_log_Result> lst1 = new List<USP_List_BMS_log_Result>();
            //List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lst1 = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();

            List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lst = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();
            int RecordCount = 0;
            RecordCount = lstBMS_Log_Searched.Count;
            if (ADSearch == "Y")
            {

                string query = "";

                if (objPage_Properties.ModuleName != "0" && objPage_Properties.ModuleName!="")
                {
                    query = "AND";
                    int code = Convert.ToInt32(objPage_Properties.ModuleName);
                    var moduleName = lstBMS_All_Masters_Searched.Where(x => x.Order_Id == code).Select(X => X.Module_Name).SingleOrDefault();
                    query = query + " Module_Name = '" + moduleName + "'";
                }
                if (objPage_Properties.MethodType != "--Please Select--" && objPage_Properties.MethodType!="")
                {
                    query = query + " AND Method_Type = '" + objPage_Properties.MethodType + "'";
                }

                if (objPage_Properties.RecordStatus != "--Please Select--" && objPage_Properties.RecordStatus!="")
                {
                    query = query + " AND  Record_Status = '" + objPage_Properties.RecordStatus + "'";
                }
                if (objPage_Properties.RequestXML != "")
                {
                    query = query + " AND  Request_Xml like '%" + objPage_Properties.RequestXML + "%'";
                }

                if (objPage_Properties.ResponseXML != "")
                {
                    query = query + "   AND  Response_Xml like '%" + objPage_Properties.ResponseXML + "%'  ";
                }
                if (objPage_Properties.RequestTime != "" && objPage_Properties.ResponseTime != "")
                {
                    query = query + " AND (Request_Time between CONVERT(datetime,'" + objPage_Properties.RequestTime + " 00:00:00 ',105) AND  CONVERT(datetime,'" + objPage_Properties.ResponseTime + " 23:59:59',105) OR  Response_Time between CONVERT(datetime,'" + objPage_Properties.RequestTime + "',105)  AND  CONVERT(datetime,'" + objPage_Properties.ResponseTime + "',105))";

                }
                int recordCount = 0;
                int objRecordCount = 0;
                //ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
                obj_USP_List_BMS_log_Result = objUSPService.USP_List_BMS_log(query, pageNo, "Y", pageSize,out objRecordCount).ToList();
                foreach (var item in obj_USP_List_BMS_log_Result)
                {
                    RightsU_Dapper.Entity.Master_Entities.BMS_Log objbvlog = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();
                    objbvlog.BMS_Log_Code = item.BMS_Log_Code;
                    objbvlog.Module_Name = item.Module_Name;
                    objbvlog.Method_Type = item.Method_Type;
                    objbvlog.Request_Time = item.Request_Time;
                    objbvlog.Request_Xml = item.Request_Xml;
                    objbvlog.Response_Time = item.Response_Time;
                    objbvlog.Response_Xml = item.Response_Xml;
                    objbvlog.Record_Status = item.Record_Status;
                    objbvlog.Error_Description = item.Error_Description;
                    lst.Add(objbvlog);
                }
                ViewBag.RC = objRecordCount;

               
            }
            if (RecordCount > 0)
            {

               
                if (ADSearch != "Y")
                {          
                    string query = "";
                    if (searchtext != "")
                    {
                        query = "AND";
                        query = query + " Module_Name like '%" + searchtext + "%'";
                        query = query + " OR Method_Type like '%" + searchtext + "%'";
                        query = query + " OR  Record_Status like '%" + searchtext + "%'";
                        query = query + " OR  Request_Xml like '%" + searchtext + "%'";
                        query = query + "   OR  Response_Xml like '%" + searchtext + "%'  ";
                
                    }
                    else
                    {
                        query = "AND 1=1";
                    }

                    RightsU_Dapper.Entity.Master_Entities.BMS_Log objbvlog = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();

                    //int resultSet = 0;
                    //ObjectParameter objresultSet = new ObjectParameter("resultSet", resultSet);

                    int recordCount = 0;
                    int objRecordCount = 0;
                    //ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);


                    //USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
                    // lst = lstBMS_Log_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).OrderByDescending(a => a.Module_Name).ToList();



                    lst1 = objUSPService.USP_List_BMS_log(query, pageNo, "Y", pageSize,out objRecordCount).ToList();
                    foreach (var item in lst1)
                    {
                        RightsU_Dapper.Entity.Master_Entities.BMS_Log objbvlog1 = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();
                        objbvlog1.BMS_Log_Code = item.BMS_Log_Code;
                        objbvlog1.Module_Name = item.Module_Name;
                        objbvlog1.Method_Type = item.Method_Type;
                        objbvlog1.Request_Time = item.Request_Time;
                        objbvlog1.Request_Xml = item.Request_Xml;
                        objbvlog1.Response_Time = item.Response_Time;
                        objbvlog1.Response_Xml = item.Response_Xml;
                        objbvlog1.Record_Status = item.Record_Status;
                        objbvlog1.Error_Description = item.Error_Description;
                        lst.Add(objbvlog1);
                    }
                    ViewBag.RC = objRecordCount;
                    
                }
            }
     

            ViewBag.UserModuleRights = GetUserModuleRights();

       

            return PartialView("~/Views/BV_Log/_BVLogList.cshtml", lst.OrderBy(x => x.Module_Name).ToList());

        }

        public JsonResult SearchBVLogList(string searchText)
        {
            List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lstsearch = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();
            List<RightsU_Dapper.Entity.Master_Entities.BMS_Log> lst = new List<RightsU_Dapper.Entity.Master_Entities.BMS_Log>();
            List<USP_List_BMS_log_Result> lst1 = new List<USP_List_BMS_log_Result>();
            RightsU_Dapper.Entity.Master_Entities.BMS_Log objbvlog = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();

            //int resultSet = 0;
            //ObjectParameter objresultSet = new ObjectParameter("resultSet", resultSet);

            int recordCount = 0;
            int objRecordCount = 0;

           // ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);


            //USP_Service objUSP = new USP_Service(objLoginEntity.ConnectionStringName);
            // lst = lstBMS_Log_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).OrderByDescending(a => a.Module_Name).ToList();


            lst1 = objUSPService.USP_List_BMS_log("AND 1=1", 1, "Y", 50,out objRecordCount).ToList();
            foreach (var item in lst1)
            {
                RightsU_Dapper.Entity.Master_Entities.BMS_Log objbvlog1 = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();
                objbvlog1.BMS_Log_Code = item.BMS_Log_Code;
                objbvlog1.Module_Name = item.Module_Name;
                objbvlog1.Method_Type = item.Method_Type;
                objbvlog1.Request_Time = item.Request_Time;
                objbvlog1.Request_Xml = item.Request_Xml;
                objbvlog1.Response_Time = item.Response_Time;
                objbvlog1.Response_Xml = item.Response_Xml;
                objbvlog1.Record_Status = item.Record_Status;
                objbvlog1.Error_Description = item.Error_Description;
                lst.Add(objbvlog1);
            }

            if (!string.IsNullOrEmpty(searchText))
            {             
                    string query = "";         
                        query = "AND";
                        query = query + " Module_Name like '%" + searchText + "%'";
                        query = query + " OR Method_Type like '%" + searchText + "%'";
                        query = query + " OR  Record_Status like '%" + searchText + "%'";
                        query = query + " OR  Request_Xml like '%" + searchText + "%'";
                        query = query + "   OR  Response_Xml like '%" + searchText + "%'  ";        

                    lst1 = objUSPService.USP_List_BMS_log(query, 1, "Y", 50,out objRecordCount).ToList();
                    foreach (var item in lst1)
                    {
                        RightsU_Dapper.Entity.Master_Entities.BMS_Log objbvlog1 = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();
                        objbvlog1.BMS_Log_Code = item.BMS_Log_Code;
                        objbvlog1.Module_Name = item.Module_Name;
                        objbvlog1.Method_Type = item.Method_Type;
                        objbvlog1.Request_Time = item.Request_Time;
                        objbvlog1.Request_Xml = item.Request_Xml;
                        objbvlog1.Response_Time = item.Response_Time;
                        objbvlog1.Response_Xml = item.Response_Xml;
                        objbvlog1.Record_Status = item.Record_Status;
                        objbvlog1.Error_Description = item.Error_Description;
                        lstsearch.Add(objbvlog1);
                    }
                    lstBMS_Log_Searched = lstsearch;
            }
            else
                lstBMS_Log_Searched = lstBMS_Log = lst;


            var obj = new
            {
                Record_Count = objRecordCount
            };
            return Json(obj);
        }

        public ActionResult Index()
        {
            lstBMS_All_Masters_Searched = lstBMS_All_Masters = objBMSAllMastersService.GetAll().ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/BV_Log/Index.cshtml");

            //return View();
        }

        public PartialViewResult ViewXML(int BMSLogCode, string commandName)
        {
           // BMS_Log_Service objBMS_Log_Service = new BMS_Log_Service(objLoginEntity.ConnectionStringName);
            RightsU_Dapper.Entity.Master_Entities.BMS_Log objBMS_Log = new RightsU_Dapper.Entity.Master_Entities.BMS_Log();
            objBMS_Log = objBMSLogService.GetByID(BMSLogCode);

            string type = "RES";

            string Text = "";
            string Text1 = "";
            string Text2 = "";
            string Text3 = "";
            string Text4 = "";

            string xml = objBMS_Log.Request_Xml;

            DataSet ds = new DataSet();
            ds.ReadXml(XmlReader.Create(new StringReader(xml)));
           

            DataTable dt = ds.Tables[0];

            //Building an HTML string.
            StringBuilder html = new StringBuilder();

            //Table start.
            //  html.Append("<table border = '1'>");

            //Building the Header row.
            html.Append("<tr>");
            foreach (DataColumn column in dt.Columns)
            {
                html.Append("<th>");
                html.Append(column.ColumnName);
                html.Append("</th>");
            }
            html.Append("</tr>");

            //Building the Data rows.
            foreach (DataRow row in dt.Rows)
            {
                html.Append("<tr>");
                foreach (DataColumn column in dt.Columns)
                {
                    html.Append("<td class='expandable'>");
                    html.Append(row[column.ColumnName]);
                    html.Append("</td>");
                }
                html.Append("</tr>");
            }

            //Table end.
            //  html.Append("</table>");

            ViewBag.HtmlStr = html;

            string Datatext = Text + "~" + Text1 + "~" + Text2 + "~" + Text3 + "~" + Text4;


            ViewBag.Datatext1 = Datatext;

            //DataSet ds = new DataSet();
            //if (type == "RES")
            //    ds.ReadXml(objBMS_Log.Request_Xml);

            //ds.Tables[0];


            ViewBag.CommandName = commandName;

            return PartialView("~/Views/BV_Log/_BV_LogXML.cshtml", objBMS_Log);

        }

    }


    public partial class BV_Log_Search
    {

        public BV_Log_Search() { }

        #region ========== PAGE PROPERTIES ==========
        public string F { get; set; }
        public string ModuleName { get; set; }
        public int DealTypeCode { get; set; }
        public string MethodType { get; set; }
        public string RecordStatus { get; set; }
        public string RequestXML { get; set; }
        public string ResponseXML { get; set; }
        public string RequestTime { get; set; }
        public string ResponseTime { get; set; }

        #endregion
    }
}
