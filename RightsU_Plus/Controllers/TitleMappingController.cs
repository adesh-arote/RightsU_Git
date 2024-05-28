using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Net;
using System.Globalization;
using System.Collections;

namespace RightsU_Plus.Controllers
{
    public class TitleMappingController : BaseController
    {
        public ActionResult Index()
        {
            Acq_Deal_Service objAds = new Acq_Deal_Service(objLoginEntity.ConnectionStringName);
            int Acq_Deal_Code = 0;
            ViewBag.AgreementNo = new SelectList(objAds.SearchFor(x=>x.Business_Unit_Code==1), "Acq_Deal_Code", "Agreement_No", Acq_Deal_Code).ToList();
            return View();
        }
    }
}