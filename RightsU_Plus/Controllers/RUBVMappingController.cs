using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_Entities;
//using RightsU_BLL;
using System.Collections;
using System.Globalization;
using System.Threading;
using System.Web.UI;
using System.Data.Entity.Core.Objects;
using RightsU_Dapper.BLL.Services;
//using RightsU_Dapper.Entity.StoredProcedure_Entities;
using RightsU_Dapper.Entity;

namespace RightsU_Plus.Controllers
{ 
    public class RUBVMappingController : BaseController
    {
        private readonly USPRUBVMappingList_Service objUSPService = new USPRUBVMappingList_Service();
        private readonly BMS_Asset_Service objBMS_Asset_Service = new BMS_Asset_Service();
        private readonly BMS_Deal_Content_Service objBMS_Deal_Content_Service = new BMS_Deal_Content_Service();
        private readonly BMS_Deal_Content_Rights_Service objBMS_Deal_Content_Rights_Service = new BMS_Deal_Content_Rights_Service();
        private readonly BMS_Deal_Service objBMS_Deal_Service = new BMS_Deal_Service();
        private readonly Vendor_Service objVendor_Service = new Vendor_Service();

        string url = "";
        public string SelectedValue {
            set {
                Session["SelectedValue2"] = value;
            }
            get {
                if (Session["SelectedValue2"] == null)
                    Session["SelectedValue2"] =  SelectedValue;
                return (string)Session["SelectedValue2"];
            }           
        }
        public ActionResult Index()
        {
            return View();
        }  
        public PartialViewResult BindTable(string selectedValue,string selectedOption, int pageNo, int recordPerPage)
        {
            int RecordCount = 0;
            Session["SelectedValue2"] = selectedValue;
            List<USPRUBVMappingList_Result> lstRUBVMapping = new List<USPRUBVMappingList_Result>();
            int objRecordCount = 0;// new ObjectParameter("RecordCount", RecordCount);
            
            if (selectedOption == "Asset")
            {
                lstRUBVMapping = objUSPService.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage,out objRecordCount).ToList();
                ViewBag.RecordCount = objRecordCount;
                url = "~/Views/RUBVMapping/_ListBMSAsset.cshtml";
             }
            else if (selectedOption == "Deal")
            {
                lstRUBVMapping = objUSPService.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage,out objRecordCount).ToList();
               ViewBag.RecordCount = objRecordCount;
                url = "~/Views/RUBVMapping/_ListBMSDeal.cshtml";                  
            }
            else if (selectedOption == "Content")
            {
                lstRUBVMapping = objUSPService.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage,out objRecordCount).ToList();
                ViewBag.RecordCount = objRecordCount;
                url = "~/Views/RUBVMapping/_ListBMSDealContent.cshtml";             
            }
            else if (selectedOption == "Rights")
            {
                lstRUBVMapping = objUSPService.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage,out objRecordCount).ToList();
               ViewBag.RecordCount = objRecordCount;
                url = "~/Views/RUBVMapping/_ListBMSDealContentRights.cshtml";
            }
            else if (selectedOption == "License")
            {
                lstRUBVMapping = objUSPService.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage,out objRecordCount).ToList();
                ViewBag.RecordCount = objRecordCount;
                url = "~/Views/RUBVMapping/_ListLicensor.cshtml";
        }
            return PartialView(url,lstRUBVMapping);
        }        
        public PartialViewResult MapReferenceKey(int[] ruidArray, int[] bvidArray, string selectedOption, int pageNo, int recordPerPage)
        {
            dynamic resultset = 0;
            int c = 0;
            int RecordCount = 0;
            int objRecordCount = 0;// new ObjectParameter("RecordCount", RecordCount);
            List<USPRUBVMappingList_Result> lstRUBVMapping = new List<USPRUBVMappingList_Result>();
            if (selectedOption == "Asset")
            {
                //BMS_Asset_Service serviceAsset = new BMS_Asset_Service(objLoginEntity.ConnectionStringName);
                //BMS_Deal_Content_Service serviceDealContent = new BMS_Deal_Content_Service(objLoginEntity.ConnectionStringName);
                //BMS_Deal_Content_Rights_Service serviceDealContentRights = new BMS_Deal_Content_Rights_Service(objLoginEntity.ConnectionStringName);
            RightsU_BLL.Title_Content_Service serviceTitleContent = new RightsU_BLL.Title_Content_Service(objLoginEntity.ConnectionStringName);
                foreach (var ruid in ruidArray)
                {
                    BMS_Asset objAsset = objBMS_Asset_Service.GetByID(ruid);
                    List<BMS_Deal_Content> lstDealContent = objBMS_Deal_Content_Service.GetAll().Where(x => x.BMS_Asset_Code == ruid).ToList();
                    List<BMS_Deal_Content_Rights>  lstDealContentRights = objBMS_Deal_Content_Rights_Service.GetAll().Where(x => x.BMS_Asset_Code == ruid).ToList();

                    int episodenumber = Convert.ToInt32(objAsset.Episode_Number);
                 RightsU_Entities.Title_Content objTitleContent = serviceTitleContent.SearchFor(x => x.Title_Code == objAsset.RU_Title_Code && x.Episode_No == episodenumber).FirstOrDefault();
                    objAsset.BMS_Asset_Ref_Key = bvidArray[c];
                    objAsset.Record_Status = "D";
                    objAsset.IS_Consider = "N";
                     foreach (var item in lstDealContent)
                    {
                        item.BMS_Asset_Ref_Key = bvidArray[c];
                        //item.EntityState = State.Modified;
                        objBMS_Deal_Content_Service.AddEntity(item);
                    }
                    foreach (var item in lstDealContentRights)
                    {
                        item.BMS_Asset_Ref_Key = bvidArray[c];
                        //item.EntityState = State.Modified;
                        objBMS_Deal_Content_Rights_Service.AddEntity(item);
                    }
                   // objAsset.EntityState = State.Modified;
                    objBMS_Asset_Service.AddEntity(objAsset);

                    if (objTitleContent != null)
                    {
                        objTitleContent.Ref_BMS_Content_Code = bvidArray[c].ToString();
                        //objTitleContent.EntityState = State.Modified;
                        serviceTitleContent.Save(objTitleContent, out resultset);
                    }
                    c++;
                }  
                
                lstRUBVMapping = objUSPService.USPRUBVMappingList(SelectedValue, "Asset", pageNo, recordPerPage,out objRecordCount).ToList();                
                ViewBag.RecordCount = (int)objRecordCount;

                url = "~/Views/RUBVMapping/_ListBMSAsset.cshtml";
            }
            if (selectedOption == "License")
            {
                //Vendor_Service serviceVendor = new Vendor_Service(objLoginEntity.ConnectionStringName);
                //BMS_Deal_Service serviceDeal = new BMS_Deal_Service(objLoginEntity.ConnectionStringName);
                foreach (var vendorcode in ruidArray)
                {
                    RightsU_Dapper.Entity.Vendor objVendor = objVendor_Service.GetAll().Where(x => x.Vendor_Code == vendorcode).FirstOrDefault();
                    objVendor.Ref_Vendor_Key = bvidArray[c];
                    objVendor.Record_Status = "D";
                     List<BMS_Deal> lstDeal = objBMS_Deal_Service.GetAll().Where(x => x.RU_Licensor_Code == vendorcode).ToList();
                    foreach (var item in lstDeal)
                    {
                        item.BMS_Licensor_Code = bvidArray[c];
                        //item.EntityState = State.Modified;
                        objBMS_Deal_Service.AddEntity(item);
                    }
                   // objVendor.EntityState = State.Modified;
                    objVendor_Service.AddEntity(objVendor);
                    c++;
                }               
               lstRUBVMapping = objUSPService.USPRUBVMappingList(SelectedValue, "License", pageNo, recordPerPage,out objRecordCount).ToList();
                ViewBag.RecordCount = (int)objRecordCount;
                url = "~/Views/RUBVMapping/_ListLicensor.cshtml";
            }
            return PartialView(url, lstRUBVMapping);
        }
    }
}

