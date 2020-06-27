using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace RightsU_Plus.WebServices
{
    /// <summary>
    /// Summary description for GeneralWS
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class GeneralWS : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod(EnableSession = true)]
        public string GetMenuStr(string TabName)
        {
            return "Hello World!!!";
            //User objLoginUser = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;

            //var List = (dynamic)null;

            //string strHTML = "";
            //string OpeningULTag = "<ul>";
            //string ClosingULTag = "</ul>";
            //string OpeningLITag = "<li>";
            //string ClosingLITag = "</li>";


            //List<USP_GetMenu_Result> LoadMenuList = new USP_Service().USP_GetMenu(objLoginUser.Security_Group_Code.ToString(), "Y").ToList();

            //LoadMenuList = LoadMenuList.Where(x => x.Module_Position.ToUpper().StartsWith(TabName.ToUpper())).ToList();

            //if (TabName == "A")
            //{
            //    strHTML = strHTML + "<h4>Masters</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlMasters');\"><span class='Reviewclose'>x</span></a>";
            //}
            //else if (TabName == "E")
            //{
            //    strHTML = strHTML + "<h4>Reports</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlReports');\"><span class='Reviewclose'>x</span></a>";
            //}

            //strHTML = strHTML + OpeningULTag;

            //List<USP_GetMenu_Result> SubMenuList = LoadMenuList.Where(x => x.Module_Position.Length == 2).ToList();

            //foreach (USP_GetMenu_Result USP_GetMenu_Result_Obj in SubMenuList)
            //{
            //    if (USP_GetMenu_Result_Obj.Is_Sub_Module == "Y")
            //    {
            //        int Count = LoadMenuList.Where(x => x.Module_Position.Length == 3 && x.Module_Position.StartsWith(USP_GetMenu_Result_Obj.Module_Position)).ToList().Count();
            //        if (Count > 0)
            //        {
            //            strHTML = strHTML + "<li class='active has-sub'>";
            //            strHTML = strHTML + "<a href='#'>" + USP_GetMenu_Result_Obj.Module_Name + "</a>";
            //            strHTML = strHTML + OpeningULTag;

            //            List<USP_GetMenu_Result> SubSubMenuList = LoadMenuList.Where(x => x.Module_Position.Length == 3 && x.Module_Position.StartsWith(USP_GetMenu_Result_Obj.Module_Position)).ToList();
            //            foreach (USP_GetMenu_Result USP_GetMenu_Result_Sub_Obj in SubSubMenuList)
            //            {
            //                strHTML = strHTML + OpeningLITag + "<a href='" + USP_GetMenu_Result_Sub_Obj.Url + "'>" + USP_GetMenu_Result_Sub_Obj.Module_Name + "</a>" + ClosingLITag;
            //            }
            //            strHTML = strHTML + ClosingULTag;
            //        }
            //        else
            //        {

            //            strHTML = strHTML + OpeningLITag + "<a href='" + USP_GetMenu_Result_Obj.Url + "'>" + USP_GetMenu_Result_Obj.Module_Name + "</a>" + ClosingLITag;
            //        }
            //    }
            //    else
            //    {
            //        strHTML = strHTML + OpeningLITag + "<a href='" + USP_GetMenu_Result_Obj.Url + "'>" + USP_GetMenu_Result_Obj.Module_Name + "</a>" + ClosingLITag;
            //    }
            //}

            //strHTML = strHTML + ClosingULTag;

            //List = strHTML;

            //return List;
        }
    }
}
