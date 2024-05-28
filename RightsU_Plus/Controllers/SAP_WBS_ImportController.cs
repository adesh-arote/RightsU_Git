using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
namespace RightsU_Plus.Controllers
{
    public class SAP_WBS_ImportController : BaseController
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

        private List<RightsU_Entities.SAP_WBS> lstSAP_WBS1
        {
            get
            {
                if (Session["lstSAP_WBS1"] == null)
                    Session["lstSAP_WBS1"] = new List<RightsU_Entities.SAP_WBS>();
                return (List<RightsU_Entities.SAP_WBS>)Session["lstSAP_WBS1"];
            }
            set { Session["lstSAP_WBS1"] = value; }
        }

        private List<RightsU_Entities.SAP_WBS> lstSAP_WBS_Searched1
        {
            get
            {
                if (Session["lstSAP_WBS_Searched1"] == null)
                    Session["lstSAP_WBS_Searched1"] = new List<RightsU_Entities.SAP_WBS>();
                return (List<RightsU_Entities.SAP_WBS>)Session["lstSAP_WBS_Searched1"];
            }
            set { Session["lstSAP_WBS_Searched1"] = value; }
        }

        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;


        }

        //public PartialViewResult BindPartialPages(string key, int WorkflowModuleCode)
        //{
        //    TempData["View"] = "";
        //    if (key == "VIEW")
        //    {
        //        Session["WorkflowCode_AddEdit"] = WorkflowModuleCode;
        //        if (WorkflowModuleCode > 0)
        //        {
        //            TempData["View"] = "V";
        //            ViewData["Status"] = "V";
        //            Workflow_Module_Service objService = new Workflow_Module_Service(objLoginEntity.ConnectionStringName);
        //            RightsU_Entities.Workflow_Module objWorkflow = objService.GetById(WorkflowModuleCode);
        //            // TempData["BusinessUnit"] = new SelectList(lstBusiness_Unit_Searched.Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name", objWorkflow.Business_Unit_Code);
        //            ViewData["MyWorkflow"] = objWorkflow;
        //        }
        //        return PartialView("~/Views/SAP_WBS_Import/_SAP_WBS_Import_ListDetails.cshtml");
        //    }


        //}

        public PartialViewResult BindSAP_WBS_ImportList(int pageNo, int recordPerPage, int Language_Code, string commandName)
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

                    List<RightsU_Entities.SAP_WBS> objSAPWBS1 = new List<RightsU_Entities.SAP_WBS>();
                    objSAPWBS1 = new SAP_WBS_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(w => w.File_Code == objSAPWBS.File_Code).ToList();

                    lstSAP_WBS_Searched1 = objSAPWBS1;

                    // TempData["BusinessUnit"] = new SelectList(lstBusiness_Unit_Searched.Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name", objWorkflow.Business_Unit_Code);
                    ViewData["MyWorkflow"] = objSAPWBS1;
                }
                return PartialView("~/Views/SAP_WBS_Import/_SAP_WBS_Import_ListDetails.cshtml");
            }

            if (commandName == "SEARCH")
            {
                if (Language_Code > 0)
                {
                    TempData["View"] = "V";
                    ViewData["Status"] = "V";


                    Upload_Files_Service objService = new Upload_Files_Service(objLoginEntity.ConnectionStringName);
                    RightsU_Entities.Upload_Files objSAPWBS = objService.GetById(Language_Code);

                    List<RightsU_Entities.SAP_WBS> objSAPWBS1 = new List<RightsU_Entities.SAP_WBS>();
                    objSAPWBS1 = new SAP_WBS_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Where(w => w.File_Code == objSAPWBS.File_Code).ToList();

                    lstSAP_WBS_Searched1 = objSAPWBS1;

                    // TempData["BusinessUnit"] = new SelectList(lstBusiness_Unit_Searched.Where(x => x.Is_Active == "Y"), "Business_Unit_Code", "Business_Unit_Name", objWorkflow.Business_Unit_Code);
                    ViewData["MyWorkflow"] = objSAPWBS1;
                }
                return PartialView("~/Views/SAP_WBS_Import/_SAP_WBS_Import_ListDetails.cshtml", lstSAP_WBS_Searched1);
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
            return PartialView("~/Views/SAP_WBS_Import/_SAP_WBS_Import_List.cshtml", lst);
        }

        public JsonResult SearchSAP_WBS(string searchText, string txtfrom, string txtto)
        {
            if (!string.IsNullOrEmpty(searchText) || !string.IsNullOrEmpty(txtfrom) || !string.IsNullOrEmpty(txtto))
            {
                string query = "";

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


                int recordCount = 0;
                ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
                List<USP_Uploaded_File_List_Result> obj1 = new USP_Service(objLoginEntity.ConnectionStringName).USP_Uploaded_File_List(query, 0, objRecordCount, "Y", 10).ToList();
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
                lstUpload_Files_Searched = lstUpload_Files = new Upload_Files_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            }
            //   lstUpload_Files_Searched = lstUpload_Files;

            var obj = new
            {

                Record_Count = lstUpload_Files_Searched.Count
            };
            return Json(obj);
        }

        public JsonResult SearchSAP_WBSDetails(string searchText)
        {


            if (!string.IsNullOrEmpty(searchText))
            {
                // lstUpload_Files_Searched = lstUpload_Files.Where(w => w.File_Name.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
                lstSAP_WBS_Searched = lstSAP_WBS_Searched1;
            }
            else
                lstUpload_Files_Searched = lstUpload_Files;

            var obj = new
            {
                Record_Count = lstUpload_Files_Searched.Count
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

        public ActionResult Index()
        {
            lstSAP_WBS_Searched = lstSAP_WBS = new SAP_WBS_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            lstUpload_Files_Searched = lstUpload_Files = new Upload_Files_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/SAP_WBS_Import/Index.cshtml");
        }

    }
}
