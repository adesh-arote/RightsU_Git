using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.ReportingServices.ReportRendering;
using System.Web.UI.WebControls;
using System.Collections;
using System.Data;
using System.Web.Script.Services;
using System.Data.Entity.Core.Objects;
using RightsU_BLL;
using RightsU_Entities;
//using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Web_ServiceController : BaseController
    {
        public Acq_Deal_Rights_Territory_Service objAcq_Deal_Rights_Territory_Service
        {
            get
            {
                if (Session["objAcq_Deal_Rights_Territory_Service"] == null)
                    Session["objAcq_Deal_Rights_Territory_Service"] = new Acq_Deal_Rights_Territory_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Rights_Territory_Service)Session["objAcq_Deal_Rights_Territory_Service"];
            }
            set
            {
                Session["objAcq_Deal_Rights_Territory_Service"] = value;
            }
        }

        public Acq_Deal_Pushback_Territory_Service objAcq_Deal_Pushback_Territory_Service
        {
            get
            {
                if (Session["objAcq_Deal_Pushback_Territory_Service"] == null)
                    Session["objAcq_Deal_Pushback_Territory_Service"] = new Acq_Deal_Pushback_Territory_Service(objLoginEntity.ConnectionStringName);
                return (Acq_Deal_Pushback_Territory_Service)Session["objAcq_Deal_Pushback_Territory_Service"];
            }
            set
            {
                Session["objAcq_Deal_Pushback_Territory_Service"] = value;
            }
        }

        public Country_Service objCountry_Service
        {
            get
            {
                if (Session["objCountry_Service"] == null)
                    Session["objCountry_Service"] = new Country_Service(objLoginEntity.ConnectionStringName);
                return (Country_Service)Session["objCountry_Service"];
            }
            set
            {
                Session["objCountry_Service"] = value;
            }
        }

        public ActionResult Index()
        {
            return View();
        }


        public ActionResult chkTerritoryEnability(string territoryCode = "")
        {
            int Code = Convert.ToInt32(territoryCode);

            int Count1 = objAcq_Deal_Rights_Territory_Service.SearchFor(x => x.Territory_Code == Code && x.Acq_Deal_Rights_Code != null).Count();
            int Count2 = objAcq_Deal_Pushback_Territory_Service.SearchFor(x => x.Territory_Code == Code && x.Acq_Deal_Pushback_Code != null).Count();

            int Count = Count1 + Count2;

            bool Result = false;

            if (Count >= 1)
                Result = true;

            return Json(Result);
        }

        public ActionResult ValidateAndMoveRL(string territoryCode = "", string countryCode = "")
        {
            int territory = Convert.ToInt32(territoryCode);
            int country = Convert.ToInt32(countryCode);

            int Count1 = objAcq_Deal_Rights_Territory_Service.SearchFor(x => x.Territory_Code == territory && x.Country_Code == country && x.Acq_Deal_Rights_Code != null).Count();
            int Count2 = objAcq_Deal_Pushback_Territory_Service.SearchFor(x => x.Territory_Code == territory && x.Country_Code == country && x.Acq_Deal_Pushback_Code != null).Count();

            int Count = Count1 + Count2;

            bool Result = false;

            if (Count >= 1)
                Result = true;

            return Json(Result);
        }

        public ActionResult chkCountryEnability(string countryCode = "")
        {
            int country = Convert.ToInt32(countryCode);

            int Count1 = objAcq_Deal_Rights_Territory_Service.SearchFor(x => x.Country_Code == country && x.Acq_Deal_Rights_Code != null).Count();
            int Count2 = objAcq_Deal_Pushback_Territory_Service.SearchFor(x => x.Country_Code == country && x.Acq_Deal_Pushback_Code != null).Count();
            int Count3 = objCountry_Service.SearchFor(x => x.Parent_Country_Code == country).Count();

            int Count = Count1 + Count2 + Count3;

            bool Result = false;

            if (Count > 0)
                Result = true;

            return Json(Result);
        }

        public ActionResult ValidateWithDeal(string territoryCode = "", string countryCode = "")
        {
            int territory = Convert.ToInt32(territoryCode);
            int country = Convert.ToInt32(countryCode);

            string strQuery = "Exec USP_ValidateWithDeal '" + territoryCode + "','" + countryCode + "'";
            var count = new USP_Service(objLoginEntity.ConnectionStringName).USP_ValidateWithDeal(territoryCode, countryCode);

            int Count = Convert.ToInt32(count);

            bool Result = false;

            if (Count > 0)
                Result = true;

            return Json(Result);
        }

        //public ActionResult GetDealTitles(string keyword, string scheduleDate_Time)
        //{
        //    DateTime dtSchedule = Convert.ToDateTime(scheduleDate_Time);
        //    USP_Service objUS = new USP_Service(objLoginEntity.ConnectionStringName);
        //    List<USP_GET_TITLE_DATA_Result> arrDealTitlesEPS = objUS.USP_GET_TITLE_DATA(keyword,0).ToList();
        //    List<string> LstDealTitles = new List<string>();
        //    //var LstDealTitles1 = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(
        //    //                                               x => x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Deal_Workflow_Status == "A" &&
        //    //                                               AM.Title_Code == x.Title_Code && x.Title_Name.Contains(keyword))
        //    //                                              )
        //    //               .Select(R => new { Title_Name = R.Title_Name + "~" + R.Title_Code }).OrderBy(O => O.Title_Name).ToList();

        //    //var result = (from USP_GET_TITLE_DATA_Result UGT in arrDealTitlesEPS
        //    //            where UGT.Title_Name.ToUpper().Contains(keyword.ToUpper())
        //    //                && UGT.Actual_Right_Start_Date <= dtSchedule && (UGT.Actual_Right_End_Date ?? dtSchedule) >= dtSchedule
        //    //                //&& ((UGT.Actual_Right_Start_Date == DateTime.MinValue ? dtSchedule : UGT.Actual_Right_Start_Date) >= dtSchedule
        //    //                //    && (UGT.Actual_Right_End_Date == DateTime.MinValue ? dtSchedule : UGT.Actual_Right_End_Date) <= dtSchedule)
        //    //            select UGT.Title_Name).ToList();

        //    //LstDealTitles =  (from o in test select o.Title_Name).ToList();

        //    //var result = (from USP_GET_TITLE_DATA_Result UGT in arrDealTitlesEPS
        //    //              where UGT.Title_Name.ToUpper().Contains(keyword.ToUpper())
        //    //                  && UGT.Actual_Right_Start_Date <= dtSchedule && (UGT.Actual_Right_End_Date ?? dtSchedule) >= dtSchedule
        //    //              select UGT.Title_Name + "~" + UGT.Acq_Deal_Movie_Code + "^" + UGT.Episode_Starts_From + "^" + UGT.Episode_End_To
        //    //              ).Distinct().ToList();
        //    var result = (from USP_GET_TITLE_DATA_Result UGT in arrDealTitlesEPS
        //                  where UGT.Title_Name.ToUpper().Contains(keyword.ToUpper())
        //                  select UGT.Title_Name + "~" + UGT.Acq_Deal_Movie_Code + "^" + UGT.Episode_Starts_From + "^" + UGT.Episode_End_To
        //                  ).Distinct().ToList();

        //    return Json(result);
        //}

        public ActionResult GetDealTitlesForSchedule(string keyword)
        {
            //DateTime dtSchedule = Convert.ToDateTime(scheduleDate_Time);
            //USP_Service objUS = new USP_Service();
            //List<USP_GET_TITLE_DATA_Result> arrDealTitlesEPS = objUS.USP_GET_TITLE_DATA().ToList();
            //List<string> LstDealTitles = new List<string>();

            //var result = (from USP_GET_TITLE_DATA_Result UGT in arrDealTitlesEPS
            //              where UGT.Title_Name.ToUpper().Contains(keyword.ToUpper())
            //              select UGT.Title_Name + "~" + UGT.Acq_Deal_Movie_Code + "^" + UGT.Episode_Starts_From + "^" + UGT.Episode_End_To
            //              ).Distinct().ToList();

            var result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(
                                                            x => x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Deal_Workflow_Status == "A" &&
                                                            AM.Title.Title_Name.ToUpper().Contains(keyword.ToUpper()) && AM.Acq_Deal.Deal_Type_Code == UTOFrameWork.FrameworkClasses.GlobalParams.Deal_Type_Movie)
                                                           )
                            .Select(R => R.Title_Name + "~" + R.Title_Code).Distinct().ToList();
            //arrDealTitles = lst_Title;

            return Json(result);
        }
        //public ActionResult Get_Agreement_No(string keyword, int Selected_BU_Code)
        public ActionResult Get_Agreement_No(string keyword)
        {
            int Selected_BU_Code = Convert.ToInt32(keyword.Split('~')[0]);
            string Deal_No =keyword.Split('~')[1];
            var result = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(c => c.Is_Active == "Y" && c.Business_Unit_Code == Selected_BU_Code && c.Agreement_No.Contains(Deal_No) 
                                                            && (c.Deal_Workflow_Status == "A" || c.Version != "0001")
                                                         )
                                               .Select(i => i.Agreement_No + "~" + i.Acq_Deal_Code).Distinct().ToList();
            return Json(result);
        }

        public ActionResult LoadCountry(string code,string IFTACluster)
        {
            if(IFTACluster == "IFTA")
            {
                int TerriteroyCode = Convert.ToInt32(code.TrimStart('T'));
                Report_Territory_Country_Service reportTerrCountryService = new Report_Territory_Country_Service(objLoginEntity.ConnectionStringName);
                //   List<Country> lstCountry = new List<Country>();
                var lstCountry = reportTerrCountryService.SearchFor(t => t.Report_Territory_Code == TerriteroyCode).Select(c => new Country { IntCode = c.Report_Territory_Country_Code,CountryName = c.Country.Country_Name}).OrderBy(c=>c.CountryName).ToList();
                return Json(lstCountry);
            }
            else
            {
                int TerriteroyCode = Convert.ToInt32(code.TrimStart('T'));
                Territory_Details_Service terrDeatailService = new Territory_Details_Service(objLoginEntity.ConnectionStringName);
                //   List<Country> lstCountry = new List<Country>();
                var lstCountry = terrDeatailService.SearchFor(t => t.Territory_Code == TerriteroyCode).Select(c => new Country { IntCode = c.Country_Code, CountryName = c.Country.Country_Name }).OrderBy(c => c.CountryName).ToList();
                return Json(lstCountry);
            }
            
        }
        public ActionResult LoadCountryRegion(string code)
        {
            int TerriteroyCode = Convert.ToInt32(code.TrimStart('T'));
            Country_Service countryService = new Country_Service(objLoginEntity.ConnectionStringName);
            //   List<Country> lstCountry = new List<Country>();
            var lstCountry = countryService.SearchFor(t => t.Parent_Country_Code == TerriteroyCode).Select(c => new Country { IntCode = c.Country_Code, CountryName = c.Country_Name }).OrderBy(c => c.CountryName).ToList();
            return Json(lstCountry);
        }

        public ActionResult LoadLanguageNew(string code)
        {
           int LangGroupCode = Convert.ToInt32(code.TrimStart('G'));
                Language_Group_Service languGroupService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
                if (LangGroupCode != 0)
                {
                    var lstCountry = languGroupService.GetById(LangGroupCode).Language_Group_Details.Select(c => new Language { IntCode = c.Language_Code.Value, LanguageName = c.Language.Language_Name }).ToList();
                    return Json(lstCountry);
                }
                else
                {
                    return Json("");
                }                   
        } 

        public ActionResult LoadLanguage(string code)
        {
            if (code == "Language")
            {
                Language_Service langServiceInstance = new Language_Service(objLoginEntity.ConnectionStringName);
                var lstCountry = langServiceInstance.SearchFor(l => l.Is_Active == "Y").Select(l => new ListItem { Text = l.Language_Name, Value = "L" + l.Language_Code }).OrderBy(l => l.Text).ToList();       
                return Json(lstCountry);
            }
            else
            {
                int LangGroupCode = Convert.ToInt32(code.TrimStart('G'));
                Language_Group_Service languGroupService = new Language_Group_Service(objLoginEntity.ConnectionStringName);
                if (LangGroupCode != 0)
                {
                    var lstCountry = languGroupService.GetById(LangGroupCode).Language_Group_Details.Select(c => new Language { IntCode = c.Language_Code.Value, LanguageName = c.Language.Language_Name }).ToList();
                    return Json(lstCountry);
                }
                else
                {
                    return Json("");
                }                            
            }             
        }


        //public string LoadUserControl()
        //{
        //    using (Page page = new Page())
        //    {
        //        int[] arrPlatform;
        //        arrPlatform = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Is_Active == "Y")
        //                                                                            .Select(p => p.Platform_Code).Distinct().ToArray();
        //        RightsU_WebApp.UserControl.UC_Platform_Tree userControl = (RightsU_WebApp.UserControl.UC_Platform_Tree)page.LoadControl("Reports/UserControl/UC_Platform_Tree.ascx");
        //        userControl.PlatformCodes_Display = string.Join(",", arrPlatform);
        //        userControl.PopulateTreeNode("N");
        //        System.Web.UI.HtmlControls.HtmlForm form = new System.Web.UI.HtmlControls.HtmlForm();
        //        form.Controls.Add(userControl);
        //        page.Controls.Add(form);
        //        using (StringWriter writer = new StringWriter())
        //        {
        //            //page.Controls.Add(userControl);
        //            HttpContext.Current.Server.Execute(page, writer, false);
        //            return writer.ToString();
        //        }
        //    }
        //}
    }
}
