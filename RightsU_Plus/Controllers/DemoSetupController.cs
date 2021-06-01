using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Dapper.Entity;
//using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;
using System.Xml;
using System.Data;
using System.Xml.Linq;
using RightsU_Dapper.BLL.Services;
using RightsU_Dapper.Entity;

namespace RightsU_Plus.Controllers
{


    public class DemoSetupController : BaseController
    {
        private readonly System_Parameter_NewService objSPNService = new System_Parameter_NewService();
        private readonly Business_Unit_Service objBusiness_Unit_Service = new Business_Unit_Service();
        private readonly Entity_Service objEntity_Service = new Entity_Service();
        private readonly Users_Business_Unit_Service objUsers_Business_Unit_Service = new Users_Business_Unit_Service();
        private readonly USPBindJobAndExecute_Service objUSPService = new USPBindJobAndExecute_Service();
        private readonly User_Service objUser_Service = new User_Service();



        dynamic resultset = 0;
        List<USPBindJobAndExecute_Result> lstBindJobandExecute = new List<USPBindJobAndExecute_Result>();
        RightsU_Dapper.Entity.Business_Unit objBusinessUnit = new RightsU_Dapper.Entity.Business_Unit();
        RightsU_Dapper.Entity.System_Parameter_New objSystemParameterNew = new RightsU_Dapper.Entity.System_Parameter_New();
        public ActionResult Index()
        {
            //Business_Unit_Service objBusinessUnitService = new Business_Unit_Service(objLoginEntity.ConnectionStringName);
            ViewBag.BusinessNameSelect = new SelectList(objBusiness_Unit_Service.GetAll(), "Business_Unit_Name", "Business_Unit_Name");
            ViewBag.JobNameSelect = new SelectList(objUSP_Service.USPBindJobAndExecute("List", "").Where(x => true), "JobName", "JobName");
            return View();
        }
        public JsonResult Save(string searchBy, string businessName, string entityName)
        {
            string Status = "S";
            Dictionary<string, object> dicobj = new Dictionary<string, object>();
            //Entity_Service objEntityService = new Entity_Service(objLoginEntity.ConnectionStringName);
                //Business_Unit_Service objBusinessUnitService = new Business_Unit_Service(objLoginEntity.ConnectionStringName);
                //System_Parameter_New_Service objSystemParameterNewService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
               // Users_Business_Unit_Service objUsersBusinessUnitService = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName);
                //User_Service objUserService = new User_Service(objLoginEntity.ConnectionStringName);
                RightsU_Dapper.Entity.Entity objEntity = objEntity_Service.GetByID(1);
                objEntity.Entity_Name = entityName;
                objEntity.Last_Updated_Time = DateTime.Now;

                XmlDocument xmlDocument = new XmlDocument();
                xmlDocument.Load(Server.MapPath("~") + "\\EntitiesList.xml");
                xmlDocument.FirstChild.FirstChild.FirstChild.NextSibling.InnerText = entityName;
                xmlDocument.FirstChild.FirstChild.FirstChild.InnerText = entityName;
                xmlDocument.Save(Server.MapPath("~") + "\\EntitiesList.xml");
                if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
                {
                    var file = System.Web.HttpContext.Current.Request.Files["postedFile"];
                    objEntity.Logo_Name = Path.GetFileName(file.FileName);
                    string filename = Path.GetFileName(file.FileName);
                    string filepath = Path.Combine(Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["LogoImagePath"] + filename));
                    file.SaveAs(filepath);
                }
                //objEntity.EntityState = State.Modified;
                objEntity_Service.AddEntity(objEntity);

                objSystemParameterNew = objSPNService.GetList().Where(x => x.Parameter_Name.Contains("Title_Avail_BU")).SingleOrDefault();
                if (searchBy == "New")
                {
              if (objBusiness_Unit_Service.GetAll().Where(x => x.Business_Unit_Name==businessName).Any())
                {
                    Status = "N";
                }
                else
                {
                    
                    objBusinessUnit.Business_Unit_Name = businessName;
                    objBusinessUnit.Is_Active = "Y";
                   // objBusinessUnit.EntityState = State.Added;
                    objBusiness_Unit_Service.AddEntity(objBusinessUnit);

                    RightsU_Dapper.Entity.Users_Business_Unit objUsersBusinessUnit = new RightsU_Dapper.Entity.Users_Business_Unit();
                    RightsU_Dapper.Entity.User objUser = objUser_Service.GetAll().Where(x => x.Login_Name == "Admin").Single();
                    objUsersBusinessUnit.Users_Code = objUser.Users_Code;
                    objUsersBusinessUnit.Business_Unit_Code = objBusinessUnit.Business_Unit_Code;
                    //objUsersBusinessUnit.EntityState = State.Added;
                    objUsers_Business_Unit_Service.AddEntity(objUsersBusinessUnit);
                }
                }
                else if (searchBy == "Existing")
                {  objBusinessUnit = objBusiness_Unit_Service.GetAll().Where(x => x.Business_Unit_Name == businessName).Single();
                    objBusinessUnit.Is_Active = "Y";
                    //objBusinessUnit.EntityState = State.Modified;
                    objBusiness_Unit_Service.AddEntity(objBusinessUnit);
                }
                objSystemParameterNew.Parameter_Value = objBusinessUnit.Business_Unit_Code.ToString();
                //objSystemParameterNew.EntityState = State.Modified;
                objSPNService.UpdateEntity(objSystemParameterNew);
            dicobj.Add("Status",Status); 
            return Json(dicobj);
        }
        public void Execute(string ddOption)
        {
            objUSP_Service.USPBindJobAndExecute("Execute", ddOption);
        }
    }
}
