using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class TestController : BaseController
    {
        //
        // GET: /Test/

        private Acq_Deal_Rights_Service objADRS
        {
            get
            {
                if (Session["Acq_Deal_Rights_Service"] == null)
                    Session["Acq_Deal_Rights_Service"] = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName);
                return ((Acq_Deal_Rights_Service)Session["Acq_Deal_Rights_Service"]);
            }
            set { Session["Acq_Deal_Rights_Service"] = value; }
        }

        private Acq_Deal_Rights objAcq_Deal_Rights
        {
            get
            {
                if (Session["Acq_Deal_Rights"] == null)
                    Session["Acq_Deal_Rights"] = new Acq_Deal_Rights();
                return ((Acq_Deal_Rights)Session["Acq_Deal_Rights"]);
            }
            set { Session["Acq_Deal_Rights"] = value; }
        }

        public ActionResult Index()
        {
            //1841
            objAcq_Deal_Rights = objADRS.GetById(1841);
            return View(objAcq_Deal_Rights);
        }

        public ActionResult Save_Rights(Acq_Deal_Rights objRights) {

            objRights.EntityState = State.Modified;

            dynamic resultSet;
            objADRS.Save(objRights, out resultSet);

            return View(objAcq_Deal_Rights);
        }
    }
}
