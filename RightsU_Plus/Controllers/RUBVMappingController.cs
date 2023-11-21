using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Collections;
using System.Globalization;
using System.Threading;
using System.Web.UI;
using System.Data.Entity.Core.Objects;

namespace RightsU_Plus.Controllers
{ 
    public class RUBVMappingController : BaseController
    {
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
         ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            
            if (selectedOption == "Asset")
            {
                lstRUBVMapping = objUSP_Service.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage, objRecordCount).ToList();
                ViewBag.RecordCount = objRecordCount.Value;
                url = "~/Views/RUBVMapping/_ListBMSAsset.cshtml";
             }
            else if (selectedOption == "Deal")
            {
                lstRUBVMapping = objUSP_Service.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage, objRecordCount).ToList();
               ViewBag.RecordCount = objRecordCount.Value;
                url = "~/Views/RUBVMapping/_ListBMSDeal.cshtml";                  
            }
            else if (selectedOption == "Content")
            {
                lstRUBVMapping = objUSP_Service.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage, objRecordCount).ToList();
                ViewBag.RecordCount = objRecordCount.Value;
                url = "~/Views/RUBVMapping/_ListBMSDealContent.cshtml";             
            }
            else if (selectedOption == "Rights")
            {
                lstRUBVMapping = objUSP_Service.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage, objRecordCount).ToList();
               ViewBag.RecordCount = objRecordCount.Value;
                url = "~/Views/RUBVMapping/_ListBMSDealContentRights.cshtml";
            }
            else if (selectedOption == "License")
            {
                lstRUBVMapping = objUSP_Service.USPRUBVMappingList(SelectedValue, selectedOption, pageNo, recordPerPage, objRecordCount).ToList();
                ViewBag.RecordCount = objRecordCount.Value;
                url = "~/Views/RUBVMapping/_ListLicensor.cshtml";
        }
            return PartialView(url,lstRUBVMapping);
        }        

        public PartialViewResult MapReferenceKey(int[] ruidArray, int[] bvidArray, string selectedOption, int pageNo, int recordPerPage)
        {
            dynamic resultset = 0;
            int c = 0;
            int RecordCount = 0;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            List<USPRUBVMappingList_Result> lstRUBVMapping = new List<USPRUBVMappingList_Result>();
            if (selectedOption == "Asset")
            {
                BMS_Asset_Service serviceAsset = new BMS_Asset_Service(objLoginEntity.ConnectionStringName);
                BMS_Deal_Content_Service serviceDealContent = new BMS_Deal_Content_Service(objLoginEntity.ConnectionStringName);
                BMS_Deal_Content_Rights_Service serviceDealContentRights = new BMS_Deal_Content_Rights_Service(objLoginEntity.ConnectionStringName);
                Title_Content_Service serviceTitleContent = new Title_Content_Service(objLoginEntity.ConnectionStringName);
                foreach (var ruid in ruidArray)
                {
                    BMS_Asset objAsset = serviceAsset.GetById(ruid);
                    List<BMS_Deal_Content> lstDealContent = serviceDealContent.SearchFor(x => x.BMS_Asset_Code == ruid).ToList();
                    List<BMS_Deal_Content_Rights>  lstDealContentRights = serviceDealContentRights.SearchFor(x => x.BMS_Asset_Code == ruid).ToList();

                    int episodenumber = Convert.ToInt32(objAsset.Episode_Number);
                    Title_Content objTitleContent = serviceTitleContent.SearchFor(x => x.Title_Code == objAsset.RU_Title_Code && x.Episode_No == episodenumber).FirstOrDefault();
                    objAsset.BMS_Asset_Ref_Key = bvidArray[c];
                    objAsset.Record_Status = "D";
                    objAsset.IS_Consider = "N";
                     foreach (var item in lstDealContent)
                    {
                        item.BMS_Asset_Ref_Key = bvidArray[c];
                        item.EntityState = State.Modified;
                        serviceDealContent.Save(item, out resultset);
                    }
                    foreach (var item in lstDealContentRights)
                    {
                        item.BMS_Asset_Ref_Key = bvidArray[c];
                        item.EntityState = State.Modified;
                        serviceDealContentRights.Save(item, out resultset);
                    }
                    objAsset.EntityState = State.Modified;
                    serviceAsset.Save(objAsset, out resultset);

                    if (objTitleContent != null)
                    {
                        objTitleContent.Ref_BMS_Content_Code = bvidArray[c].ToString();
                        objTitleContent.EntityState = State.Modified;
                        serviceTitleContent.Save(objTitleContent, out resultset);
                    }
                    c++;
                }  
                
                lstRUBVMapping = objUSP_Service.USPRUBVMappingList(SelectedValue, "Asset", pageNo, recordPerPage,objRecordCount).ToList();                
                ViewBag.RecordCount = (int)objRecordCount.Value;

                url = "~/Views/RUBVMapping/_ListBMSAsset.cshtml";
            }
            if (selectedOption == "License")
            {
                Vendor_Service serviceVendor = new Vendor_Service(objLoginEntity.ConnectionStringName);
                BMS_Deal_Service serviceDeal = new BMS_Deal_Service(objLoginEntity.ConnectionStringName);
                foreach (var vendorcode in ruidArray)
                {
                    RightsU_Entities.Vendor objVendor = serviceVendor.SearchFor(x => x.Vendor_Code == vendorcode).FirstOrDefault();
                    objVendor.Ref_Vendor_Key = bvidArray[c];
                    objVendor.Record_Status = "D";
                     List<BMS_Deal> lstDeal = serviceDeal.SearchFor(x => x.RU_Licensor_Code == vendorcode).ToList();
                    foreach (var item in lstDeal)
                    {
                        item.BMS_Licensor_Code = bvidArray[c];
                        item.EntityState = State.Modified;
                        serviceDeal.Save(item, out resultset);
                    }
                    objVendor.EntityState = State.Modified;
                    serviceVendor.Save(objVendor, out resultset);
                    c++;
                }               
               lstRUBVMapping = objUSP_Service.USPRUBVMappingList(SelectedValue, "License", pageNo, recordPerPage, objRecordCount).ToList();
                ViewBag.RecordCount = (int)objRecordCount.Value;
                url = "~/Views/RUBVMapping/_ListLicensor.cshtml";
            }
            return PartialView(url, lstRUBVMapping);
        }
    }
}

