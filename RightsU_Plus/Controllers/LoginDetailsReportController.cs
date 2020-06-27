using Microsoft.Reporting.WebForms;
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class LoginDetailsReportController : BaseController
    {
        //private string GetUserModuleRights()
        //{
        //    List<string> lstRights = new USP_Service().USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForLanguage), objLoginUser.Security_Group_Code).ToList();
        //    string rights = "";
        //    if (lstRights.FirstOrDefault() != null)
        //        rights = lstRights.FirstOrDefault();

        //    return rights;


        //}
        ReportViewer ReportViewer2;
        private List<USP_Service> lstUser
        {
            get
            {
                if (Session["lstUser"] == null)
                    Session["lstUser"] = new List<USP_Service>();
                return (List<USP_Service>)Session["lstUser"];
            }
            set { Session["lstUser"] = value; }
        }

        private List<USP_Login_Details_Report_Result> lstUser_Searched
        {
            get
            {
                if (Session["lstUser_Searched"] == null)
                    Session["lstUser_Searched"] = new List<USP_Login_Details_Report_Result>();
                return (List<USP_Login_Details_Report_Result>)Session["lstUser_Searched"];
            }
            set { Session["lstUser_Searched"] = value; }
        }
        private string ModuleCode
        {
            get
            {
                if (Session["ModuleCode"] == null)
                {
                    Session["ModuleCode"] = 0;
                }
                return Convert.ToString(Session["ModuleCode"].ToString());
            }
            set
            {
                Session["ModuleCode"] = value;
            }
        }
        public LoginEntity objLoginEntity
        {
            get
            {
                if (Session[RightsU_Session.CurrentLoginEntity] == null)
                    Session[RightsU_Session.CurrentLoginEntity] = new LoginEntity();
                return (LoginEntity)Session[RightsU_Session.CurrentLoginEntity];
            }
            set { Session[RightsU_Session.CurrentLoginEntity] = value; }
        }

        public PartialViewResult BindLoginDetailsReport(int pageNo, int recordPerPage, int Language_Code, string commandName)
        {
            ViewBag.Language_Code = Language_Code;
            ViewBag.CommandName = commandName;
            List<USP_Login_Details_Report_Result> lst = new List<USP_Login_Details_Report_Result>();
            int RecordCount = 0;
            RecordCount = lstUser_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstUser_Searched.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            //ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/LoginDetailsReport/_List_LoginDetails.cshtml", lst);
        }

        public JsonResult SearchLoginDetailsReport(string searchText, string txtfrom, string txtto, int pageNo,int pageSize)
        {        
            string searchText_temp = UserAutosuggest(searchText);
            string query = "";
            int recordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
            // List<USP_Login_Details_Report_Result> obj1 = new List<USP_Login_Details_Report_Result>();


            if (!string.IsNullOrEmpty(searchText_temp) || !string.IsNullOrEmpty(txtfrom) || !string.IsNullOrEmpty(txtto))
            {

                //string query = "";

                //lstUpload_Files_Searched = lstUpload_Files.Where(w => w.File_Name.ToUpper().Contains(searchText.ToUpper().Trim())).ToList();
                if (!string.IsNullOrEmpty(searchText_temp))
                {
                    if (searchText_temp == "AND 1=1")
                    {
                        query = "AND 1=1";
                    }
                    else
                    {
                        query = "AND";
                        query = query + " LD.users_code IN (" + searchText_temp + ")";
                    }

                }

                if (!string.IsNullOrEmpty(txtfrom) && !string.IsNullOrEmpty(txtto))
                {
                    if (txtfrom == txtto)
                    {
                        //query = query + " AND Upload_Date between CAST('" + txtfrom + " 00:00:00' as datetime) AND CAST('" + txtfrom + " 23:59:59' as datetime)";
                        query = query + " AND CAST(Login_Time AS Date) between CONVERT(datetime,'" + txtfrom + " 00:00:00',105) AND  CONVERT(datetime,'" + txtto + " 23:59:59',105)";
                    }
                    else
                    {
                        query = query + " AND (CAST(Login_Time AS Date) between CONVERT(datetime,'" + txtfrom + "',105) AND  CONVERT(datetime,'" + txtto + "',105))";
                    }
                }

                else if (!string.IsNullOrEmpty(txtfrom) || !string.IsNullOrEmpty(txtto))
                {

                    // query = query + " Upload_Type = '" + SAP_EXP + "' ";

                    if (!string.IsNullOrEmpty(txtfrom))
                    {
                        query = query + " AND (CAST(Login_Time AS Date) > CONVERT(datetime,'" + txtfrom + "',105))";
                    }
                    if (!string.IsNullOrEmpty(txtto))
                    {
                        query = query + " AND (CAST(Login_Time AS Date) < CONVERT(datetime,'" + txtto + "',105))";
                    }

                    //if (!string.IsNullOrEmpty(txtfrom) && !string.IsNullOrEmpty(txtto))
                    //{

                    //    query = query + " AND (Upload_Date between CONVERT(datetime,'" + txtfrom + "',105) AND  CONVERT(datetime,'" + txtto + "',105))";
                    //}
                }



                lstUser_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USP_Login_Details_Report(query, pageNo, "LoginTime", "Y", pageSize, objRecordCount).ToList();
                //lstUser_Searched.Clear();

                // lstUser_Searched = obj1;
                //foreach (var item in obj1)
                //{
                //    USP_Login_Details_Report_Result objbvlog1 = new USP_Login_Details_Report_Result();
                //    objbvlog1.first_name = item.first_name;
                //    objbvlog1.middle_Name = item.middle_Name;
                //    objbvlog1.last_name = item.last_name;
                //    objbvlog1.login_name = item.login_name;
                //    objbvlog1.LoginTime = item.LoginTime;
                //    objbvlog1.LogoutTime = item.LogoutTime;
                //    objbvlog1.security_group_name = item.security_group_name;
                //    objbvlog1.duration = item.duration;

                //    lstUser_Searched.Add(objbvlog1);
                //}



            }
            else
            {
                query = "AND 1=1";
                lstUser_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USP_Login_Details_Report(query, pageNo, "LoginTime", "Y", pageSize, objRecordCount).ToList();
            }
            //   lstUpload_Files_Searched = lstUpload_Files;

            var obj = new
            {

                Record_Count = Convert.ToInt32(objRecordCount.Value)
            };
            return Json(obj);
        }

        public ActionResult ExportToExcel(int Module_Code, int SysLanguageCode, string Module_Name, string sortColumnOrder, string txtuser, string txtfrom, string txtto)
        {
            string searchText_temp = UserAutosuggest(txtuser);
            string query = "";
            if (!string.IsNullOrEmpty(searchText_temp) || !string.IsNullOrEmpty(txtfrom) || !string.IsNullOrEmpty(txtto))
            {
                if (!string.IsNullOrEmpty(searchText_temp))
                {
                    if (searchText_temp == "AND 1=1")
                    {
                        query = "AND 1=1";
                    }
                    else
                    {
                        query = "AND";
                        query = query + " U.users_code IN (" + searchText_temp + ")";
                    }

                }
                if (!string.IsNullOrEmpty(txtfrom) && !string.IsNullOrEmpty(txtto))
                {
                    if (txtfrom == txtto)
                    {
                        query = query + " AND CAST(LD.Login_Time AS Date) between CONVERT(datetime,'" + txtfrom + " 00:00:00',105) AND  CONVERT(datetime,'" + txtto + " 23:59:59',105)";
                    }
                    else
                    {
                        query = query + " AND (CAST(LD.Login_Time AS Date) between CONVERT(datetime,'" + txtfrom + "',105) AND  CONVERT(datetime,'" + txtto + "',105))";
                    }
                }

                else if (!string.IsNullOrEmpty(txtfrom) || !string.IsNullOrEmpty(txtto))
                {
                    if (!string.IsNullOrEmpty(txtfrom))
                    {
                        query = query + " AND (CAST(LD.Login_Time AS Date) > CONVERT(datetime,'" + txtfrom + "',105))";
                    }
                    if (!string.IsNullOrEmpty(txtto))
                    {
                        query = query + " AND (CAST(LD.Login_Time AS Date) < CONVERT(datetime,'" + txtto + "',105))";
                    }
                }
            }
            else
            {
                query = "AND 1=1";
            }
            ReportViewer2 = new ReportViewer();
            //int RecordCount = 0;
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            ReportParameter[] parm = new ReportParameter[6];

            string sortcolumn = "", sortorder = "";
            if (sortColumnOrder == "NA")
            {
                sortcolumn = "NAME";
                sortorder = "ASC";
            }
            else if (sortColumnOrder == "ND")
            {
                sortcolumn = "NAME";
                sortorder = "DSC";
            }
            else
            {
                sortcolumn = "TIME";
                sortorder = "DSC";
            }
            parm[0] = new ReportParameter("Module_Code", Convert.ToString(Module_Code));
            parm[1] = new ReportParameter("SysLanguageCode", Convert.ToString(SysLanguageCode));
            parm[2] = new ReportParameter("Column_Count", "0");
            parm[3] = new ReportParameter("Sort_Column", sortcolumn);
            parm[4] = new ReportParameter("Sort_Order", sortorder);
            parm[5] = new ReportParameter("StrSearchCriteria", query);

            ReportCredential();
            ReportViewer2.ServerReport.ReportPath = string.Empty;
            if (ReportViewer2.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer2.ServerReport.ReportPath = objRS.GetReport("rptListMasters");
            }
            ReportViewer2.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer2.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename= " + Module_Name + ".xls");
            Response.OutputStream.Write(buffer, 0, buffer.Length);
            Response.End();
            return RedirectToAction("Index", new { Message = "Attachment File downloaded successfully" });
        }
        public void ReportCredential()
        {
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

            string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
            string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];

                ReportViewer2.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
            }


            ReportViewer2.Visible = true;
            ReportViewer2.ServerReport.Refresh();
            ReportViewer2.ProcessingMode = ProcessingMode.Remote;
            if (ReportViewer2.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
            {
                ReportViewer2.ServerReport.ReportServerUrl = new Uri(ReportingServer);
            }
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
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModulecodeForLoggedInDetailsReport);
            ModuleCode = Request.QueryString["modulecode"];
            ViewBag.Code = ModuleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            //int recordCount = 0;
            //ObjectParameter objRecordCount = new ObjectParameter("RecordCount", recordCount);
            //List<USP_Login_Details_Report_Result> lstUser_Searched = new USP_Service().USP_Login_Details_Report("AND 1=1",0,"first_name","N",10, objRecordCount).ToList();
            lstUser_Searched.Clear();
            //var languageCode = objLanguage_Group.Language_Group_Details.Select(s => s.Language_Code).ToArray();
          
            return View("~/Views/LoginDetailsReport/Index.cshtml");
        }
        public JsonResult PopulateUsers(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Login_Name.ToUpper().Contains(searchString.ToUpper()) && s.Is_Active == "Y").Select(x => new { Login_Name = x.Login_Name, Users_Code = x.Users_Code }).ToList();
            }
            return Json(result);
        }
        public string UserAutosuggest(string userCode)
        {
            userCode = userCode.Trim().Trim('﹐').Trim();
            string user_names = "";
            if (userCode != "")
            {
                string[] terms = userCode.Split('﹐');
                string[] User_Codes = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Login_Name)).Select(s => s.Users_Code.ToString()).ToArray();
                user_names = string.Join(", ", User_Codes);
            }
            return user_names;
        }
    }
}
