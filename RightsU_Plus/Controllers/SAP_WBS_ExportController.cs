
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class SAP_WBS_ExportController : BaseController
    {
        private List<RightsU_Entities.Upload_Files> lstUpload_Files
        {
            get
            {
                if (Session["lstUpload_Files"] == null)
                    Session["lstUpload_Files"] = new List<RightsU_Entities.Upload_Files>();
                return (List<RightsU_Entities.Upload_Files>)Session["lstUpload_Files"];
            }
            set { Session["lstUpload_Files"] = value; }
        }

        private List<RightsU_Entities.Upload_Files> lstUpload_Files_Searched
        {
            get
            {
                if (Session["lstUpload_Files_Searched"] == null)
                    Session["lstUpload_Files_Searched"] = new List<RightsU_Entities.Upload_Files>();
                return (List<RightsU_Entities.Upload_Files>)Session["lstUpload_Files_Searched"];
            }
            set { Session["lstUpload_Files_Searched"] = value; }
        }

        private List<RightsU_Entities.SAP_WBS> lstSAP_WBS
        {
            get
            {
                if (Session["lstSAP_WBS"] == null)
                    Session["lstSAP_WBS"] = new List<RightsU_Entities.SAP_WBS>();
                return (List<RightsU_Entities.SAP_WBS>)Session["lstSAP_WBS"];
            }
            set { Session["lstSAP_WBS"] = value; }
        }

        private List<RightsU_Entities.SAP_WBS> lstSAP_WBS_Searched
        {
            get
            {
                if (Session["lstSAP_WBS_Searched"] == null)
                    Session["lstSAP_WBS_Searched"] = new List<RightsU_Entities.SAP_WBS>();
                return (List<RightsU_Entities.SAP_WBS>)Session["lstSAP_WBS_Searched"];
            }
            set { Session["lstSAP_WBS_Searched"] = value; }
        }

        private List<RightsU_Entities.SAP_Export> lstSAP_Export1
        {
            get
            {
                if (Session["lstSAP_Export1"] == null)
                    Session["lstSAP_Export1"] = new List<RightsU_Entities.SAP_Export>();
                return (List<RightsU_Entities.SAP_Export>)Session["lstSAP_Export1"];
            }
            set { Session["lstSAP_Export1"] = value; }
        }

        private List<RightsU_Entities.SAP_Export> lstSAP_Export_Searched1
        {
            get
            {
                if (Session["lstSAP_Export_Searched1"] == null)
                    Session["lstSAP_Export_Searched1"] = new List<RightsU_Entities.SAP_Export>();
                return (List<RightsU_Entities.SAP_Export>)Session["lstSAP_Export_Searched1"];
            }
            set { Session["lstSAP_Export_Searched1"] = value; }
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;


        }

        public PartialViewResult BindSAP_WBS_ExportList(int pageNo, int recordPerPage, int Language_Code, string commandName)
        {
            if (commandName == "VIEW")
            {
                //Session["WorkflowCode_AddEdit"] = Language_Code;
                if (Language_Code > 0)
                {
                    TempData["View"] = "V";
                    ViewData["Status"] = "V";


                    Upload_Files_Service objService = new Upload_Files_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Entities.Upload_Files objSAPWBS = objService.GetById(Language_Code);

                    List<RightsU_Entities.SAP_Export> objSAPWBS1 = new List<RightsU_Entities.SAP_Export>();
                    objSAPWBS1 = new SAP_Export_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(w => w.File_Code == objSAPWBS.File_Code).ToList();

                    lstSAP_Export_Searched1 = objSAPWBS1;
                    ViewData["MyWorkflow"] = objSAPWBS1;
                }
                return PartialView("~/Views/SAP_WBS_Export/_SAP_WBS_Export_ListDetails.cshtml");
            }

            
            ViewBag.Language_Code = Language_Code;
            ViewBag.CommandName = commandName;
            List<RightsU_Entities.Upload_Files> lst = new List<RightsU_Entities.Upload_Files>();
            int RecordCount = 0;
            RecordCount = lstUpload_Files_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstUpload_Files_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SAP_WBS_Export/_SAP_WBS_Export_List.cshtml", lst);
        }

        public JsonResult SearchSAP_WBS(string searchText, string txtfrom, string txtto , int pageNo)
        {
            int recordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
            if (!string.IsNullOrEmpty(searchText) || !string.IsNullOrEmpty(txtfrom) || !string.IsNullOrEmpty(txtto))
            {
                string query = "";
                if (Session["code"].ToString() == "125") // to check if it is BV WBS Export
                 {
                      query = " AND Upload_Type = 'BMS_WBS_EXP' ";
                 }
                 else
                 {
                     query = " AND Upload_Type = 'SAP_EXP' ";
                 }
                //lstUpload_Files_Searched = lstUpload_Files.Where(w => w.File_Name.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
                if (!string.IsNullOrEmpty(searchText))
                {
                    query = "AND";
                    query = query + " File_Name like '%" + searchText + "%'";

                }

                if (!string.IsNullOrEmpty(txtfrom) && !string.IsNullOrEmpty(txtto))
                {
                    if (txtfrom == txtto)
                    {
                        //query = query + " AND Upload_Date between CAST('" + txtfrom + " 00:00:00' as datetime) AND CAST('" + txtfrom + " 23:59:59' as datetime)";
                        query = query + " AND Upload_Date between CONVERT(datetime,'" + txtfrom + " 00:00:00',105) AND  CONVERT(datetime,'" + txtto + " 23:59:59',105)";
                    }
                    else
                    {
                        query = query + " AND (Upload_Date between CONVERT(datetime,'" + txtfrom + "',105) AND  CONVERT(datetime,'" + txtto + "',105))";
                    }
                }

                else if (!string.IsNullOrEmpty(txtfrom) || !string.IsNullOrEmpty(txtto))
                {

                   // query = query + " Upload_Type = '" + SAP_EXP + "' ";

                    if (!string.IsNullOrEmpty(txtfrom))
                    {
                        query = query + " AND (Upload_Date > CONVERT(datetime,'" + txtfrom + "',105))";
                    }
                    if (!string.IsNullOrEmpty(txtto))
                    {
                        query = query + " AND (Upload_Date < CONVERT(datetime,'" + txtto + "',105))";
                    }

                    //if (!string.IsNullOrEmpty(txtfrom) && !string.IsNullOrEmpty(txtto))
                    //{

                    //    query = query + " AND (Upload_Date between CONVERT(datetime,'" + txtfrom + "',105) AND  CONVERT(datetime,'" + txtto + "',105))";
                    //}
                }


                //int recordCount = 0;
                //ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
                List<USP_Uploaded_File_List_Result> obj1 = new USP_Service(objLoginEntity.ConnectionStringName).USP_Uploaded_File_List(query, pageNo, objRecordCount, "Y", 10).ToList();
                lstUpload_Files_Searched.Clear();

                foreach (var item in obj1)
                {
                    RightsU_Entities.Upload_Files objbvlog1 = new RightsU_Entities.Upload_Files();
                    objbvlog1.File_Code = item.File_Code;
                    objbvlog1.File_Name = item.File_Name;
                    objbvlog1.Upload_Date = item.Upload_Date;
                    lstUpload_Files_Searched.Add(objbvlog1);
                }

            }
            else
            {
                if (Session["code"].ToString() == "125")
                {
                    string query = " AND Upload_Type = 'BMS_WBS_EXP' ";
                    //int recordCount = 0;
                    //ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
                    List<USP_Uploaded_File_List_Result> obj1 = new USP_Service(objLoginEntity.ConnectionStringName).USP_Uploaded_File_List(query, pageNo, objRecordCount, "Y", 10).ToList();
                    lstUpload_Files_Searched.Clear();

                    foreach (var item in obj1)
                    {
                        RightsU_Entities.Upload_Files objbvlog1 = new RightsU_Entities.Upload_Files();
                        objbvlog1.File_Code = item.File_Code;
                        objbvlog1.File_Name = item.File_Name;
                        objbvlog1.Upload_Date = item.Upload_Date;
                        lstUpload_Files_Searched.Add(objbvlog1);
                    }


                   //lstUpload_Files_Searched = lstUpload_Files = new Upload_Files_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(w => w.Upload_Type == "BMS_WBS_EXP").ToList();
                }
                else
                {
                    string query = " AND Upload_Type = 'SAP_EXP' ";

                    List<USP_Uploaded_File_List_Result> obj1 = new USP_Service(objLoginEntity.ConnectionStringName).USP_Uploaded_File_List(query, pageNo, objRecordCount, "Y", 10).ToList();
                    lstUpload_Files_Searched.Clear();

                    foreach (var item in obj1)
                    {
                        RightsU_Entities.Upload_Files objbvlog1 = new RightsU_Entities.Upload_Files();
                        objbvlog1.File_Code = item.File_Code;
                        objbvlog1.File_Name = item.File_Name;
                        objbvlog1.Upload_Date = item.Upload_Date;
                        lstUpload_Files_Searched.Add(objbvlog1);
                    }
                
                    //lstUpload_Files_Searched = lstUpload_Files = new Upload_Files_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(w=>w.Upload_Type== "SAP_EXP").ToList();
                }
            }
            //   lstUpload_Files_Searched = lstUpload_Files;

            var obj = new
            {

                Record_Count = objRecordCount.Value
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
        
        //-----------------------------------------------------------------

        public PartialViewResult BindSAP_WBS_ExportList_Details(int pageNo, int recordPerPage,bool isFirstTime = false)
        {
            ViewData["MyWorkflow"] = "";
            //ViewBag.Language_Code = Language_Code;
            //ViewBag.CommandName = commandName;
            List<RightsU_Entities.SAP_Export> lst = new List<RightsU_Entities.SAP_Export>();
            int RecordCount = 0;
            RecordCount = lstSAP_Export1.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstSAP_Export1.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewData["MyWorkflow"] = lst;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SAP_WBS_Export/_SAP_WBS_Export_ListDetails.cshtml");
        }

        public JsonResult SearchSAP_WBS_Details(string searchText, string txtfrom, string txtto)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstSAP_Export1 = lstSAP_Export_Searched1.Where(w => w.WBS_Code.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else { 

             lstSAP_Export1.Clear();
            lstSAP_Export1 = lstSAP_Export_Searched1;
            }
            var obj = new
            {
                Record_Count = lstSAP_Export_Searched1.Count
                //Record_Count = lstSAP_Export_Searched1.Count
            };
            return Json(obj);
            //   lstUpload_Files_Searched = lstUpload_Files;

        }

        //-----------------------------------------------------------------
        public ActionResult Index()
         {
             string moduleCode = Request.QueryString["modulecode"];
             ViewBag.Code = moduleCode;
             Session["code"] = moduleCode;

            lstSAP_WBS_Searched = lstSAP_WBS = new SAP_WBS_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();

            int recordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
            List<USP_Uploaded_File_List_Result> obj1 = new USP_Service(objLoginEntity.ConnectionStringName).USP_Uploaded_File_List("AND 1=1", 0, objRecordCount, "N", 10).ToList();
            lstUpload_Files_Searched.Clear();

            foreach (var item in obj1)
            {
                RightsU_Entities.Upload_Files objbvlog1 = new RightsU_Entities.Upload_Files();
                objbvlog1.File_Code = item.File_Code;
                objbvlog1.File_Name = item.File_Name;
                objbvlog1.Upload_Date = item.Upload_Date;
                lstUpload_Files_Searched.Add(objbvlog1);
            }


           // lstUpload_Files_Searched = lstUpload_Files = new Upload_Files_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/SAP_WBS_Export/Index.cshtml");
            
        }

    }
}
