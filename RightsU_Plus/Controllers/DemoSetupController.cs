using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;
using System.Xml;
using System.Data;
using System.Xml.Linq;
using System.Drawing;
using System.Text;


namespace RightsU_Plus.Controllers
{
    public class DemoSetupController : BaseController
    {
        dynamic resultset = 0;
        List<USPBindJobAndExecute_Result> lstBindJobandExecute = new List<USPBindJobAndExecute_Result>();
        RightsU_Entities.Business_Unit objBusinessUnit = new Business_Unit();
        System_Parameter_New objSystemParameterNew = new System_Parameter_New();
        ImgPathData objImgpathDatas = new ImgPathData();
        public ActionResult Index()
        {
            Business_Unit_Service objBusinessUnitService = new Business_Unit_Service(objLoginEntity.ConnectionStringName);
            ViewBag.BusinessNameSelect = new SelectList(objBusinessUnitService.SearchFor(x => true), "Business_Unit_Name", "Business_Unit_Name");
            ViewBag.JobNameSelect = new SelectList(objUSP_Service.USPBindJobAndExecute("List", "").Where(x => true), "JobName", "JobName");
            return View();
        }
        public JsonResult Save(string searchBy, string businessName, string entityName)
        {
            string Status = "S";
            Dictionary<string, object> dicobj = new Dictionary<string, object>();

            Entity_Service objEntityService = new Entity_Service(objLoginEntity.ConnectionStringName);
            Business_Unit_Service objBusinessUnitService = new Business_Unit_Service(objLoginEntity.ConnectionStringName);
            System_Parameter_New_Service objSystemParameterNewService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            Users_Business_Unit_Service objUsersBusinessUnitService = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName);
            User_Service objUserService = new User_Service(objLoginEntity.ConnectionStringName);
            ImgPathData_Service objimgpathdataSerivice = new ImgPathData_Service(objLoginEntity.ConnectionStringName);

            RightsU_Entities.Entity objEntity = objEntityService.GetById(1);
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
                BinaryReader br = new BinaryReader(file.InputStream);
                byte[] bytes = br.ReadBytes((int)file.InputStream.Length);
                string base64String = Convert.ToBase64String(bytes, 0, bytes.Length);

                objImgpathDatas.ImgPath = file.FileName;
                objImgpathDatas.ImgData = base64String;
                objImgpathDatas.EntityState = State.Added;
                objimgpathdataSerivice.Save(objImgpathDatas, out resultset);

            }
            objEntity.EntityState = State.Modified;
            objEntityService.Save(objEntity, out resultset);

            objSystemParameterNew = objSystemParameterNewService.SearchFor(x => x.Parameter_Name.Contains("Title_Avail_BU")).SingleOrDefault();
            if (searchBy == "New")
            {
                if (new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Business_Unit_Name == businessName).Any())
                {
                    Status = "N";
                }
                else
                {

                    objBusinessUnit.Business_Unit_Name = businessName;
                    objBusinessUnit.Is_Active = "Y";
                    objBusinessUnit.EntityState = State.Added;
                    objBusinessUnitService.Save(objBusinessUnit, out resultset);

                    RightsU_Entities.Users_Business_Unit objUsersBusinessUnit = new Users_Business_Unit();
                    RightsU_Entities.User objUser = objUserService.SearchFor(x => x.Login_Name == "Admin").Single();
                    objUsersBusinessUnit.Users_Code = objUser.Users_Code;
                    objUsersBusinessUnit.Business_Unit_Code = objBusinessUnit.Business_Unit_Code;
                    objUsersBusinessUnit.EntityState = State.Added;
                    objUsersBusinessUnitService.Save(objUsersBusinessUnit, out resultset);
                }
            }
            else if (searchBy == "Existing")
            {
                objBusinessUnit = objBusinessUnitService.SearchFor(x => x.Business_Unit_Name == businessName).Single();
                objBusinessUnit.Is_Active = "Y";
                objBusinessUnit.EntityState = State.Modified;
                objBusinessUnitService.Save(objBusinessUnit, out resultset);
            }
            objSystemParameterNew.Parameter_Value = objBusinessUnit.Business_Unit_Code.ToString();
            objSystemParameterNew.EntityState = State.Modified;
            objSystemParameterNewService.Update(objSystemParameterNew, out resultset);


            dicobj.Add("Status", Status);

            return Json(dicobj);
        }
        public void Execute(string ddOption)
        {
            objUSP_Service.USPBindJobAndExecute("Execute", ddOption);
        }


    }
}
