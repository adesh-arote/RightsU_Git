using RightsU_HealthCheckup.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Text;

namespace RightsU_HealthCheckup
{
    class System_Mail
    {
        static int ColCount = 0;
        static bool showDBName = true;
        public static string getHtmlTable<T>(List<T> lst, RightsU_HC objRightsU_HC = null, params string[] arrCol)
        {
            bool isSSJDTL = true;

            if (objRightsU_HC != null)
                isSSJDTL = new string[] { "SSJ", "DTL", "SDP" }.Contains(objRightsU_HC.Type) ? true : false;


            ColCount = 0;
            string EmailBody = "";
            string htmlTableStart = "<table border = 1 class=\"tblFormat\">";
            string htmlTableEnd = "</table> </br>";
            string htmlHeaderRowStart = "<tr>";
            string htmlHeaderRowEnd = "</tr>";
            string htmlTrStart = "<tr style=\"color:#555555;\">";
            string htmlTrEnd = "</tr>";
            string htmlTdStart = "<td class=\"tblData\">";
            string htmlTdEnd = "</td>";
            string htmlThStart = "<th style=\"text-align:center;\" class=\"tblHead\">";
            string htmlThEnd = "</th>";

            EmailBody += htmlTableStart;
            EmailBody += htmlHeaderRowStart;

            if (arrCol.Count() > 0)
            {
                foreach (var item in arrCol)
                {
                    EmailBody += htmlThStart + item + htmlThEnd;
                }
            }
            else
            {
                foreach (PropertyInfo prop in objRightsU_HC.GetType().GetProperties())
                {
                    showDBName = isSSJDTL == true && prop.Name == "DatabaseName" ? false : true;
                    if (prop.Name != "SrNo" && prop.Name != "Type")
                    {
                        if (prop.GetValue(objRightsU_HC) != "" && showDBName == true)
                        {
                            ColCount++;
                            EmailBody += htmlThStart + prop.GetValue(objRightsU_HC) + htmlThEnd;
                        }

                    }
                }
            }
            EmailBody += htmlHeaderRowEnd;
            int Count = 0;
            Type _type;
            PropertyInfo[] _props;
            foreach (var item in lst)
            {
                _type = item.GetType();
                _props = _type.GetProperties();
                EmailBody = EmailBody + htmlTrStart;
                Count = 0;
                foreach (var prop in _props)
                {
                    showDBName = isSSJDTL == true && prop.Name == "DatabaseName" ? false : true;
                    if (prop.Name == "AvailableFreeSpace")
                    {
                        if (showDBName == true)
                        {
                            Count++;
                            if (prop.GetValue(item) != "")
                            {
                                EmailBody = EmailBody + htmlTdStart + "<span style =\"color: " + _props[4].GetValue(item) + ";\"> " + prop.GetValue(item) + "</span>" + htmlTdEnd;
                            }
                            else if (Count <= ColCount)
                            {
                                EmailBody = EmailBody + "<td style=\"text-align:center;\"> - </td>";
                            }
                        }
                    }
                    else if (prop.Name != "SrNo" && prop.Name != "Type" && prop.Name != "ColorAFS")
                    {
                        if (showDBName == true)
                        {
                            Count++;
                            if (prop.GetValue(item) != "")
                            {
                                if (prop.GetValue(item).ToString() == "Disabled" || prop.GetValue(item).ToString() == "Failed")
                                {
                                    EmailBody = EmailBody + htmlTdStart + "<span style =\"color: red;\"> " + prop.GetValue(item) + "</span>" + htmlTdEnd;
                                }
                                else
                                    EmailBody = EmailBody + htmlTdStart + prop.GetValue(item) + htmlTdEnd;
                            }
                            else if (Count <= ColCount)
                            {
                                EmailBody = EmailBody + "<td style=\"text-align:center;\"> - </td>";
                            }
                        }
                    }

                }
                EmailBody = EmailBody + htmlTrEnd;
            }
            if (lst.Count <= 0)
            {
                EmailBody = EmailBody + "<td colspan= " + arrCol.Count().ToString() + " style=\"text-align:center;\"> No Record Found </td>";
            }
            EmailBody = EmailBody + htmlTableEnd;
            return EmailBody;
        }

        public static string EmailHead()
        {
            string EmailHead = @"<html><head> <style>table { font-family: arial, sans-serif; border-collapse: collapse;width:100%;font-size: 12px;}td, th { border: 1px solid #dddddd;text-align: left; padding: 5px;} th {background-color :#dddd}</style></head><body style='font-family: arial, sans-serif;'>";
            EmailHead = EmailHead + "Dear User,<br><br> Kindly take note of the System Health Checkup status of " + Convert.ToString(ConfigurationSettings.AppSettings["HC_Env"]) + " on " + System.DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt") + " </b> <br><br>";
            return EmailHead;
        }
        public static string EmailFooter()
        {
            string EmailFooter = "</br>&nbsp;</br><SIZE=2 >This email is generated by RightsU (Rights Management System)</font></body></html>";
            return EmailFooter;
        }
        public static string ServiceSection_One(string IIS_Service_State, string SSRS_Service_State, string SQL_Service_State, string SQL_Agent_Service, string Server)
        {
            string result = "";
            if (Server == "APP")
            {
                result = result + (IIS_Service_State.StartsWith("The") ? "<br> 1.<span style=\"color: red;\"> IIS Status - " + IIS_Service_State + " </span> <br> <br> " : "<br> 1.<span> IIS Status - " + IIS_Service_State + " </span><br> <br>");
            }
            else if (Server == "DB")
            {
                result = result + (SSRS_Service_State.StartsWith("The") ? "<br> 1.<span style=\"color: red;\"> SSRS (Reporting) Service - " + SSRS_Service_State + "  </span> <br>" : "<br> 1.<span> SSRS (Reporting) Service - " + SSRS_Service_State + "  </span> <br>");
                result = result + (SQL_Service_State.StartsWith("The") ? "2.<span style=\"color: red;\"> DB (SQL) Service - " + SQL_Service_State + "  </span> <br>" : "2.<span> DB (SQL) Service - " + SQL_Service_State + "  </span> <br>");
                result = result + (SQL_Agent_Service.StartsWith("The") ? "3.<span style=\"color: red;\"> SQL Agent (Schedule Job) - " + SQL_Agent_Service + "  </span> <br> <br>" : "3.<span> SQL Agent (Schedule Job) - " + SQL_Agent_Service + "  </span> <br> <br>");
            }
            else if (Server == "APPDB")
            {
                result = result + (IIS_Service_State.StartsWith("The") ? "<br> 1.<span style=\"color: red;\"> IIS Status - " + IIS_Service_State + " </span> <br> " : "<br> 1.<span> IIS Status - " + IIS_Service_State + " </span><br> ");
                result = result + (SSRS_Service_State.StartsWith("The") ? "2.<span style=\"color: red;\"> SSRS (Reporting) Service - " + SSRS_Service_State + "  </span> <br>" : "2.<span> SSRS (Reporting) Service - " + SSRS_Service_State + "  </span> <br>");
                result = result + (SQL_Service_State.StartsWith("The") ? "3.<span style=\"color: red;\"> DB (SQL) Service - " + SQL_Service_State + "  </span> <br>" : "3.<span> DB (SQL) Service - " + SQL_Service_State + "  </span> <br>");
                result = result + (SQL_Agent_Service.StartsWith("The") ? "4.<span style=\"color: red;\"> SQL Agent (Schedule Job) - " + SQL_Agent_Service + "  </span> <br> <br>" : "4.<span> SQL Agent (Schedule Job) - " + SQL_Agent_Service + "  </span> <br> <br>");
            }
            return result;
        }

        public static string ParagraphTag(string Name, bool isBrTag = false)
        {
            string EmailFooter = "<div style=\"width: 100 %; height: 16px; padding: 7px 5px; background-color: palegoldenrod; font-weight: bold; \"> " + Name + " </div>";
            //if (isBrTag)
            //    EmailFooter = EmailFooter + "</br>";

            return EmailFooter;
        }
    }
}
