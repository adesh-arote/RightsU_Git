using System;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;
using System.Collections;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Net.Mail;
using System.Drawing;

namespace UTOFrameWork.FrameworkClasses
{
    public class GlobalUtil
    {
        public LoginEntity objLoginEntity
        {
            get
            {
                if (System.Web.HttpContext.Current.Session["objLoginEntity"] == null)
                    System.Web.HttpContext.Current.Session["objLoginEntity"] = new LoginEntity();
                return (LoginEntity)System.Web.HttpContext.Current.Session["objLoginEntity"];
            }
            set { System.Web.HttpContext.Current.Session["objLoginEntity"] = value; }
        }

        public static int ShowPagingInBatch(Persistent obj, string filter, int recordPerPage, int pagePerBatch, HttpRequest request, Label lblRecordCount, PlaceHolder pageLink)
        {
            return ShowPagingInBatch(obj, filter, recordPerPage, pagePerBatch, request, lblRecordCount, pageLink, "");
        }
        public static int ShowPagingInBatch(Persistent obj, string filter, int recordPerPage, int pagePerBatch, HttpRequest request, Label lblRecordCount, PlaceHolder pageLink, string appendedQueryStringKeyValue)
        {
            Criteria objCriteria = new Criteria();
            objCriteria.ClassRef = obj;
            objCriteria.IsCountRequired = true;
            objCriteria.RecordCount = Convert.ToInt32(objCriteria.Execute(filter)[0]);
            objCriteria.IsCountRequired = false;
            objCriteria.IsPagingRequired = true;
            objCriteria.RecordPerPage = recordPerPage;

            int intPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(objCriteria.RecordCount) / objCriteria.RecordPerPage));
            int totalPages = intPages;
            lblRecordCount.Text = "<b>" + objCriteria.RecordCount;// +"</b>&nbsp&nbsp&nbsp Total Pages : <b> " + totalPages + "</b>";
            int pageNo = GetPageNumber(request);

            bool firstBatch = true;
            bool lastBatch = true;


            int firstCondition = 1;
            int lastCondition = totalPages;
            int batchNo = 1;
            int TotBatches;

            if (totalPages > pagePerBatch)
            {
                batchNo = Convert.ToInt32(Math.Floor(Convert.ToDouble((pageNo - 1) / pagePerBatch))) + 1;
                if (batchNo < 1)
                    batchNo = 1;
                TotBatches = Convert.ToInt32(Math.Floor(Convert.ToDouble((totalPages - 1) / pagePerBatch))) + 1;
                if (batchNo > 1 && batchNo < TotBatches)
                {
                    firstBatch = true;
                    lastBatch = true;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
                else if (batchNo == TotBatches)
                {
                    firstBatch = true;
                    lastBatch = false;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = totalPages;
                }
                else
                {
                    firstBatch = false;
                    lastBatch = true;
                    firstCondition = 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
            }
            if (totalPages <= pagePerBatch)
            {
                firstBatch = false;
                lastBatch = false;
                firstCondition = 1;
                lastCondition = totalPages;
            }

            pageLink.Controls.Clear();
            if (firstBatch)
            {
                HyperLink hyper = new HyperLink();
                //hyper.Text = "Prev  ";
                hyper.ImageUrl = "../Images/back.gif";
                int urlPageNoSet = ((batchNo - 1) * pagePerBatch);
                hyper.NavigateUrl = GetNavigateUrl(request, urlPageNoSet, appendedQueryStringKeyValue);
                pageLink.Controls.Add(hyper);
            }

            for (int i = firstCondition; i <= lastCondition; i++)
            {
                if (i <= totalPages)
                {
                    HyperLink hlPage = new HyperLink();
                    hlPage.Text = i.ToString() + " ";

                    hlPage.NavigateUrl = GetNavigateUrl(request, i, appendedQueryStringKeyValue);

                    if ((i == pageNo || (request.QueryString["pageNo"] == null && i == 1)))
                    {
                        hlPage.NavigateUrl = "";
                        hlPage.Font.Bold = true;
                    }
                    pageLink.Controls.Add(hlPage);
                }
            }

            if (lastBatch)
            {
                HyperLink hyper = new HyperLink();
                //hyper.Text = " Next";
                hyper.ImageUrl = "../Images/forward.gif";
                int urlPageNoSet = ((batchNo) * pagePerBatch) + 1;

                hyper.NavigateUrl = GetNavigateUrl(request, urlPageNoSet, appendedQueryStringKeyValue);
                pageLink.Controls.Add(hyper);
            }
            return objCriteria.RecordCount;
        }

        public static int MaxPageNo(Persistent obj, string filter, int recordPerPage)
        {
            Criteria objCri = new Criteria();
            objCri.ClassRef = obj;
            objCri.IsCountRequired = true;
            objCri.IsPagingRequired = false;
            objCri.IsSubClassRequired = false;
            objCri.RecordCount = Convert.ToInt32(objCri.Execute(filter)[0]);
            objCri.RecordPerPage = recordPerPage;

            return Convert.ToInt32(Math.Ceiling(Convert.ToDouble(objCri.RecordCount) / objCri.RecordPerPage));
        }

        public static void BindDataList(AttribValue objAttVal, ArrayList arrBtnList,ref DataList dtLst, int totalPages, int pagePerBatch, int pageNo)
        {
            bool firstBatch = true;
            bool lastBatch = true;


            int firstCondition = 1;
            int lastCondition = totalPages;
            int batchNo = 1;
            int TotBatches;
            //int pagePerBatch = 5;

            if (totalPages > pagePerBatch)
            {
                batchNo = Convert.ToInt32(Math.Floor(Convert.ToDouble((pageNo - 1) / pagePerBatch))) + 1;
                if (batchNo < 1)
                    batchNo = 1;
                TotBatches = Convert.ToInt32(Math.Floor(Convert.ToDouble((totalPages - 1) / pagePerBatch))) + 1;
                if (batchNo > 1 && batchNo < TotBatches)
                {
                    firstBatch = true;
                    lastBatch = true;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
                else if (batchNo == TotBatches)
                {
                    firstBatch = true;
                    lastBatch = false;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = totalPages;
                }
                else
                {
                    firstBatch = false;
                    lastBatch = true;
                    firstCondition = 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
            }
            if (totalPages <= pagePerBatch)
            {
                firstBatch = false;
                lastBatch = false;
                firstCondition = 1;
                lastCondition = totalPages;
            }

            if (firstBatch)
            {
                objAttVal = new AttribValue(" << ", ((batchNo - 1) * pagePerBatch).ToString());
                arrBtnList.Add(objAttVal);
            }

            for (int i = firstCondition; i <= lastCondition; i++)
            {
                if (i <= totalPages)
                {
                    objAttVal = new AttribValue(i.ToString(), i.ToString());
                    arrBtnList.Add(objAttVal);
                }
            }

            if (lastBatch)
            {
                objAttVal = new AttribValue(" >> ", (((batchNo) * pagePerBatch) + 1).ToString());
                arrBtnList.Add(objAttVal);
            }
            //  objCri.PageNo = iPageNo;//GlobalUtil.GetPageNumber(Request);
            dtLst.DataSource = arrBtnList;
            dtLst.DataBind();
        }

        public static int ShowBatchWisePaging(string filter, int RecordPerPage, int pagePerBatch, Label lblTotal, int pageNo, DataList dtLst, int RecordCount)
        {
            ArrayList arrBtnList = new ArrayList();
            AttribValue objAttVal = new AttribValue("", "");
            arrBtnList = new ArrayList();
            int intPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(RecordCount) / RecordPerPage));
            int totalPages = intPages;
            lblTotal.Text = "<b>" + RecordCount;// +"</b>&nbsp&nbsp&nbsp Total Pages : <b> " + totalPages + "</b>";
            //if (iPageNo > 0 )
            //int pageNo = GetPageNumber(request);

            BindDataList(objAttVal, arrBtnList, ref dtLst, totalPages, pagePerBatch, pageNo);

            return RecordCount;
        }
        public static int ShowBatchWisePaging(Persistent obj, string filter, int RecordPerPage, int pagePerBatch, Label lblTotal, int pageNo, DataList dtLst, int RecordCount)
        {
            ArrayList arrBtnList = new ArrayList();
            AttribValue objAttVal = new AttribValue("","");
            arrBtnList = new ArrayList();
            int intPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(RecordCount) / RecordPerPage));
            int totalPages = intPages;
            lblTotal.Text = "<b>" + RecordCount;// +"</b>&nbsp&nbsp&nbsp Total Pages : <b> " + totalPages + "</b>";
            //if (iPageNo > 0 )
            //int pageNo = GetPageNumber(request);

            BindDataList(objAttVal, arrBtnList, ref dtLst, totalPages, pagePerBatch, pageNo);

            return RecordCount;
        }

        public static int ShowBatchWisePaging(Persistent obj, string filter, int recordPerPage, int pagePerBatch, Label lblTotal, int pageNo, DataList dtLst)
        {
            ArrayList arrBtnList = new ArrayList();
            AttribValue objAttVal = new AttribValue("", "");
            arrBtnList = new ArrayList();
            Criteria objCri = new Criteria();
            objCri.ClassRef = obj;
            objCri.IsCountRequired = true;
            objCri.RecordCount = Convert.ToInt32(objCri.Execute(filter)[0]);
            objCri.IsCountRequired = false;
            objCri.IsPagingRequired = true;
            objCri.RecordPerPage = recordPerPage;


            int intPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(objCri.RecordCount) / objCri.RecordPerPage));
            int totalPages = intPages;
            lblTotal.Text = "<b>" + objCri.RecordCount;// +"</b>&nbsp&nbsp&nbsp Total Pages : <b> " + totalPages + "</b>";
            //if (iPageNo > 0 )
            //int pageNo = GetPageNumber(request);

            BindDataList(objAttVal, arrBtnList,ref dtLst, totalPages, pagePerBatch, pageNo);

            return objCri.RecordCount;
        }

        public static ArrayList getArrBatchWisePaging(Persistent obj, string filter, int recordPerPage, int pagePerBatch, Label lblTotal, int pageNo, out int maxPageNo, out int recordCount)
        {
            ArrayList arrBtnList = new ArrayList();
            AttribValue objAttVal;
            Criteria objCri = new Criteria();
            objCri.ClassRef = obj;
            objCri.IsCountRequired = true;
            objCri.RecordCount = Convert.ToInt32(objCri.Execute(filter)[0]);
            objCri.IsCountRequired = false;
            objCri.IsPagingRequired = true;
            objCri.RecordPerPage = recordPerPage;

            int intPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(objCri.RecordCount) / objCri.RecordPerPage));
            int totalPages = intPages;
            lblTotal.Text = "<b>" + objCri.RecordCount + "</b>";// +"</b>&nbsp&nbsp&nbsp Total Pages : <b> " + totalPages + "</b>";
            maxPageNo = totalPages;
            recordCount = objCri.RecordCount;
            bool firstBatch = true;
            bool lastBatch = true;

            int firstCondition = 1;
            int lastCondition = totalPages;
            int batchNo = 1;
            int TotBatches;

            if (totalPages > pagePerBatch)
            {
                batchNo = Convert.ToInt32(Math.Floor(Convert.ToDouble((pageNo - 1) / pagePerBatch))) + 1;
                if (batchNo < 1)
                    batchNo = 1;
                TotBatches = Convert.ToInt32(Math.Floor(Convert.ToDouble((totalPages - 1) / pagePerBatch))) + 1;
                if (batchNo > 1 && batchNo < TotBatches)
                {
                    firstBatch = true;
                    lastBatch = true;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
                else if (batchNo == TotBatches)
                {
                    firstBatch = true;
                    lastBatch = false;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = totalPages;
                }
                else
                {
                    firstBatch = false;
                    lastBatch = true;
                    firstCondition = 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
            }
            if (totalPages <= pagePerBatch)
            {
                firstBatch = false;
                lastBatch = false;
                firstCondition = 1;
                lastCondition = totalPages;
            }

            if (firstBatch)
            {
                objAttVal = new AttribValue(" << ", ((batchNo - 1) * pagePerBatch).ToString());
                arrBtnList.Add(objAttVal);
            }

            for (int i = firstCondition; i <= lastCondition; i++)
            {
                if (i <= totalPages)
                {
                    objAttVal = new AttribValue(i.ToString(), i.ToString());
                    arrBtnList.Add(objAttVal);
                }
            }

            if (lastBatch)
            {
                objAttVal = new AttribValue(" >> ", (((batchNo) * pagePerBatch) + 1).ToString());
                arrBtnList.Add(objAttVal);
            }
            return arrBtnList;
        }


        public static ArrayList getArrBatchWisePaging(Persistent obj, string sql, int recordPerPage,
                                                     int pagePerBatch, Label lblTotal, int pageNo,
                                                     out int maxPageNo, out int recordCount, out int dummy)
        {
            dummy = 0;
            ArrayList arrBtnList = new ArrayList();
            AttribValue objAttVal;
            Criteria objCri = new Criteria();
            objCri.ClassRef = obj;
            objCri.IsCountRequired = true;
            objCri.RecordCount = Convert.ToInt32(DatabaseBroker.ProcessSelectDirectly(sql).Tables[0].Rows[0][0]);
            //Convert.ToInt32(objCri.Execute(filter)[0]);
            objCri.IsCountRequired = false;
            objCri.IsPagingRequired = true;
            objCri.RecordPerPage = recordPerPage;

            int intPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(objCri.RecordCount) / objCri.RecordPerPage));
            int totalPages = intPages;
            lblTotal.Text = "<b>" + objCri.RecordCount + "</b>";// +"</b>&nbsp&nbsp&nbsp Total Pages : <b> " + totalPages + "</b>";
            maxPageNo = totalPages;
            recordCount = objCri.RecordCount;
            bool firstBatch = true;
            bool lastBatch = true;

            int firstCondition = 1;
            int lastCondition = totalPages;
            int batchNo = 1;
            int TotBatches;

            if (totalPages > pagePerBatch)
            {
                batchNo = Convert.ToInt32(Math.Floor(Convert.ToDouble((pageNo - 1) / pagePerBatch))) + 1;
                if (batchNo < 1)
                    batchNo = 1;
                TotBatches = Convert.ToInt32(Math.Floor(Convert.ToDouble((totalPages - 1) / pagePerBatch))) + 1;
                if (batchNo > 1 && batchNo < TotBatches)
                {
                    firstBatch = true;
                    lastBatch = true;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
                else if (batchNo == TotBatches)
                {
                    firstBatch = true;
                    lastBatch = false;
                    firstCondition = ((batchNo - 1) * pagePerBatch) + 1;
                    lastCondition = totalPages;
                }
                else
                {
                    firstBatch = false;
                    lastBatch = true;
                    firstCondition = 1;
                    lastCondition = (batchNo) * pagePerBatch;
                }
            }
            if (totalPages <= pagePerBatch)
            {
                firstBatch = false;
                lastBatch = false;
                firstCondition = 1;
                lastCondition = totalPages;
            }

            if (firstBatch)
            {
                objAttVal = new AttribValue(" << ", ((batchNo - 1) * pagePerBatch).ToString());
                arrBtnList.Add(objAttVal);
            }

            for (int i = firstCondition; i <= lastCondition; i++)
            {
                if (i <= totalPages)
                {
                    objAttVal = new AttribValue(i.ToString(), i.ToString());
                    arrBtnList.Add(objAttVal);
                }
            }

            if (lastBatch)
            {
                objAttVal = new AttribValue(" >> ", (((batchNo) * pagePerBatch) + 1).ToString());
                arrBtnList.Add(objAttVal);
            }
            return arrBtnList;
        }


        public static int GetPageNumber(HttpRequest request)
        {
            int pageNo = Convert.ToInt32(request.QueryString["pageNo"]);
            if (pageNo == 0)
                pageNo = 1;

            return pageNo;
        }
        private static string GetNavigateUrl(HttpRequest request, int urlPageNoSet, string appendedQueryStringKeyValue)
        {
            string url = request.RawUrl;//.Replace(request.ApplicationPath+"/", "");
            if (url.IndexOf("pageNo=") > 0)
            {
                url = ResetKeyValueFromQueryString(url, "pageNo", urlPageNoSet.ToString());
            }
            else
            {
                if (request.QueryString.ToString().IndexOf("=") > 0)
                    url += "&pageNo=" + urlPageNoSet.ToString();
                else
                    url += "?pageNo=" + urlPageNoSet.ToString();
            }

            if (appendedQueryStringKeyValue.Trim() != "" && appendedQueryStringKeyValue.IndexOf('=') > 0)
            {

                string[] arr = appendedQueryStringKeyValue.Split('=');
                if (url.IndexOf(arr[0] + "=") > 0)
                    url = ResetKeyValueFromQueryString(url, arr[0], arr[1]);
                else
                    url += appendedQueryStringKeyValue == "" ? "" : "&" + appendedQueryStringKeyValue;
            }
            return url;
        }
        private static string ResetKeyValueFromQueryString(string url, string strKey, string newValue)
        {
            strKey = strKey + "=";
            //if(url.IndexOf(strKey )<0)
            //    return url;

            int li = url.IndexOf("&", url.IndexOf(strKey)) - url.IndexOf(strKey);
            if (li < -1)
                li = url.Substring(url.IndexOf(strKey)).Length;

            string oldString = url.Substring(url.IndexOf(strKey), li);
            string newString = strKey + newValue;
            url = url.Replace(oldString, newString);
            return url;
        }

        //public static string getDeleteMsg(string moduleName, string tblName)
        //{
        //    string refModuleName = "";
        //    refModuleName = getRefModuleName(tblName);
        //    string msg = System.Web.HttpContext.GetGlobalResourceObject("UTOMRCS", "msgCanDelete1") + " \\'" + moduleName + "\\' " + System.Web.HttpContext.GetGlobalResourceObject("UTOMRCS", "msgCanDelete2") + " \\'"
        //                + refModuleName + "\\'";
        //    return msg;
        //}
        //public static string getForeignKeyMsg(string moduleName, string tblName, bool isAdd)
        //{
        //    string refModuleName = "";
        //    string usrAction = "save";
        //    if (!isAdd)
        //    {
        //        usrAction = "update";
        //    }
        //    refModuleName = getRefModuleName(tblName);
        //    string msg = (string)System.Web.HttpContext.GetGlobalResourceObject("NDTVMRCS", "msgFKError");
        //    msg = msg.Replace("{action}", usrAction).Replace("{moduleName}", moduleName).Replace("{refModuleName}", refModuleName);
        //    return msg;
        //}
        public static string getRefModuleName(string tblName)
        {
            string refModuleName = "";
            switch (tblName.ToUpper().Trim())
            {
                case "DBO.USER_MASTER":
                    refModuleName = "USER";
                    break;
                case "DBO.SECURITY_GROUP":
                    refModuleName = "USER RIGHTS";
                    break;
                case "DBO.COMPANY":
                    refModuleName = "COMPANY";
                    break;
                case "DBO.DEPARTMENT":
                    refModuleName = "DEPARTMENT";
                    break;
                case "DBO.SUBDEPARTMENT":
                    refModuleName = "SUB DEPARTMENT";
                    break;
                case "DBO.SOURCE":
                    refModuleName = "EMPLOYEE SOURCE";
                    break;
                case "DBO.ASSET":
                    refModuleName = "ASSET";
                    break;
                case "DBO.FUNCTIONS":
                    refModuleName = "FUNCTION";
                    break;
                case "DBO.GRADE":
                    refModuleName = "GRADE";
                    break;
                case "DBO.DESIGNATION":
                    refModuleName = "DESIGNATION";
                    break;
                case "DBO.":
                    refModuleName = "ERF";
                    break;

            }
            return refModuleName;
        }
        //public static void ShowPaging(object sender, string frmName, Criteria objCriteria, PlaceHolder pageLink, bool isPageBatchRequire, int pagesPerBatch, int currentBatchNo, double recordCount, string urlString)//string selectfranchise,string selectmajorLOB)
        //{
        //    if (recordCount <= 0)
        //    {
        //        return;
        //    }
        //    int pgNo = objCriteria.PageNo;
        //    string urlChar = "?";
        //    if (frmName.IndexOf("?") > 0) {
        //        urlChar = "&";
        //    }
        //    if (isPageBatchRequire)
        //    {
        //        if (objCriteria.IsPagingRequired)
        //        {
        //            double noOfPages = Math.Ceiling(recordCount / objCriteria.RecordPerPage);

        //            int lastOnes = Convert.ToInt32(Math.Ceiling(recordCount / objCriteria.RecordPerPage));

        //            //Batch Logic for Paging
        //            int totalBatches;
        //            totalBatches = Convert.ToInt16(Math.Ceiling(noOfPages / pagesPerBatch));

        //            if (currentBatchNo > 1)
        //            {
        //                HyperLink hprLinkp = new HyperLink();
        //                hprLinkp.ID = "hprLinkPrev";
        //                //	hprLinkp.Text ="<<   ";
        //                //  hprLinkp.ImageUrl = "Images/page-left.gif";
        //                hprLinkp.NavigateUrl = frmName + urlChar + "currentBatchNo=" + (currentBatchNo - 1) + "&pageNo=" + (currentBatchNo * pagesPerBatch - (2 * pagesPerBatch) + 1) + urlString;//+"&selectfranchise="+selectfranchise+"&selectmajorLOB="+selectmajorLOB; //+ "&moduleCodePass="+rtCode;
        //                hprLinkp.ForeColor = Color.Brown;
        //                hprLinkp.Font.Bold = true;
        //                hprLinkp.Font.Size = 12;
        //                pageLink.Controls.Add(hprLinkp);
        //            }

        //            int lastpages = lastOnes - 1;

        //            if (currentBatchNo != totalBatches)
        //            {
        //                lastpages = (currentBatchNo * pagesPerBatch - 1);
        //            }

        //            int k = (currentBatchNo * pagesPerBatch - pagesPerBatch);

        //            for (int i = (currentBatchNo * pagesPerBatch - pagesPerBatch); i <= lastpages; i++)
        //            {
        //                k = k + 1;
        //                pageLink.Controls.Add(getPageLink(frmName, k, pgNo, currentBatchNo, urlString, true, urlChar));
        //            }

        //            if (currentBatchNo != totalBatches)
        //            {
        //                HyperLink hprLinkn = new HyperLink();
        //                hprLinkn.ID = "hprLinkNext";
        //                // hprLinkn.Text ="   >>";
        //                //hprLinkn.ImageUrl = "Images/page-right.gif";
        //                hprLinkn.NavigateUrl = frmName + urlChar + "currentBatchNo=" + (currentBatchNo + 1) + "&pageNo=" + (currentBatchNo * pagesPerBatch + 1) + urlString;//+"&selectfranchise="+selectfranchise+"&selectmajorLOB="+selectmajorLOB; //+ "&moduleCodePass="+rtCode;
        //                hprLinkn.ForeColor = Color.Black;
        //                hprLinkn.Font.Bold = true;
        //                hprLinkn.Font.Size = 12;
        //                pageLink.Controls.Add(hprLinkn);
        //            }
        //        }
        //    }
        //    else
        //    {
        //        if (objCriteria.IsPagingRequired)
        //        {
        //            int i;
        //            int k = 0;

        //            double noOfPages = Math.Ceiling(recordCount / objCriteria.RecordPerPage);

        //            for (i = 1; i <= noOfPages; i++)
        //            {
        //                k = k + 1;
        //                pageLink.Controls.Add(getPageLink(frmName, k, pgNo, currentBatchNo, urlString, false, urlChar));
        //            }
        //        }
        //    }
        //}

        private static HyperLink getPageLink(string frmName, int k, int pgNo, int currentBatchNo, string urlString, bool needBatch, string urlChar)
        {
            HyperLink hprLink = new HyperLink();

            hprLink.ID = "hprLink" + k;
            hprLink.Text = " " + Convert.ToString(k) + " ";

            hprLink.ForeColor = Color.Black;

            if (k == pgNo)
            {
                hprLink.NavigateUrl = "";
                hprLink.Font.Bold = true;
            }
            else
            {
                hprLink.NavigateUrl = frmName + urlChar + "pageNo=" + k + (needBatch ? ("&currentBatchNo=" + currentBatchNo) : "") + urlString;//"&selectfranchise="+selectfranchise+"&selectmajorLOB="+selectmajorLOB; //+ "&moduleCodePass="+rtCode;
            }
            return hprLink;
        }

        #region --NumberToWords functions--
        //Usage tips
        //decimal sai =111022545.50M; 
        //string[] stramt = sai.ToString().Split('.'); 
        //string strNum;
        //strNum = "Rupees " + GlobalUtil.NumberToWords(stramt[0]);
        //if (sai.ToString().IndexOf(".") > 0 )
        //{
        //    strNum = strNum + " and " + GlobalUtil.NumberToWords(stramt[1]) + " Paise Only";
        //}
        public static string NumberToWords(string strAmt)
        {
            int x = 0, i;
            string teen1 = "", teen2 = "", teen3 = "";
            string numName = "", invalidNum = "";
            string a1 = "", a2 = "", a3 = "", a4 = "", a5 = "";

            //string strAmt = Convert.ToString(amt);
            if (strAmt.Length == 0)
            {
                return "zero only";
            }

            char[] digit = new char[strAmt.Length];

            for (i = 1; i <= strAmt.Length; i++)
            {
                digit[strAmt.Length - i] = Convert.ToChar(strAmt.Substring(i - 1, 1));
            }
            string[] store = new string[10];

            for (i = 1; i <= strAmt.Length; i++)
            {
                x = strAmt.Length - i;
                switch (x)
                {
                    case 9:
                        if (digit[x] == '1')
                        {
                            teen3 = "yes";
                        }
                        else
                        {
                            teen3 = "";
                        }
                        store[x] = d1(digit[x]);
                        break;
                    case 8:
                        if (digit[x] == '1')
                        {
                            teen3 = "yes";
                        }
                        else
                        {
                            teen3 = "";
                        }
                        store[x] = d2(digit[x]);
                        break;
                    case 7:
                        if (teen3 == "yes")
                        {
                            teen3 = "";
                            store[x] = d3(digit[x]);
                        }
                        else
                        {
                            store[x] = d1(digit[x]);
                        }
                        break;
                    case 6:
                        if (digit[x] == '1')
                        {
                            teen3 = "yes";
                        }
                        else
                        {
                            teen3 = "";
                        }
                        store[x] = d2(digit[x]);
                        break;
                    case 5:
                        if (teen3 == "yes")
                        {
                            teen3 = "";
                            store[x] = d3(digit[x]);
                        }
                        else
                        {
                            store[x] = d1(digit[x]);
                        }
                        break;
                    case 4:
                        if (digit[x] == '1')
                        {
                            teen2 = "yes";
                        }
                        else
                        {
                            teen2 = "";
                        }
                        store[x] = d2(digit[x]);
                        break;
                    case 3:
                        if (teen2 == "yes")
                        {
                            teen2 = "";
                            store[x] = d3(digit[x]);
                        }
                        else
                        {
                            store[x] = d1(digit[x]);
                        }
                        break;
                    case 2:
                        store[x] = d1(digit[x]);
                        break;
                    case 1:
                        if (digit[x] == '1')
                        {
                            teen1 = "yes";
                        }
                        else
                        {
                            teen1 = "";
                        }
                        store[x] = d2(digit[x]);
                        break;
                    case 0:
                        if (teen1 == "yes")
                        {
                            teen1 = "";
                            store[x] = d3(digit[x]);
                        }
                        else
                        {
                            store[x] = d1(digit[x]);
                        }
                        break;
                }
                if (store[x] == "Not a Number")
                {
                    invalidNum = "yes";
                }
                switch (strAmt.Length)
                {
                    case 1: store[2] = ""; break;
                    case 2: store[3] = ""; break;
                    case 3: store[4] = ""; break;
                    case 4: store[5] = ""; break;
                    case 5: store[6] = ""; break;
                    case 6: store[7] = ""; break;
                    case 7: store[8] = ""; break;
                    case 8: store[9] = ""; break;
                }
                if (store[8] != "")
                {
                    a1 = "";
                }
                else
                {
                    a1 = "";
                }
                if ((store[8] != "" && store[8] != null) || (store[7] != "" && store[7] != null))
                {
                    a2 = " Crore, ";
                }
                else
                {
                    a2 = "";
                }
                if ((store[5] != "" && store[5] != null) || (store[6] != "" && store[6] != null))
                {
                    a3 = " Lakhs, ";
                }
                else
                {
                    a3 = "";
                }
                if ((store[4] != "" && store[4] != null) || (store[3] != "" && store[3] != null))
                {
                    a4 = " Thousand, ";
                }
                else
                {
                    a4 = "";
                }
                if (store[2] != "" && store[2] != null)
                {
                    a5 = " Hundred ";
                }
                else
                {
                    a5 = "";
                }
            }

            if (invalidNum == "yes")
            {
                numName = "Invalid Input";
            }
            else
            {
                numName = store[8] + a1 + store[7] + a2 + store[6]
                 + store[5] + a3 + store[4] + store[3]
                + a4 + store[2] + a5 + store[1] + store[0];
            }
            store[0] = ""; store[1] = ""; store[2] = "";
            store[3] = ""; store[4] = ""; store[5] = "";
            store[6] = ""; store[7] = ""; store[8] = "";
            if (numName == "")
            {
                numName = " Zero ";
            }

            return numName;

            //return "";
        }

        private static string d1(char x)
        { // single digit terms
            string n;
            switch (x)
            {
                case '0': n = ""; break;
                case '1': n = " One "; break;
                case '2': n = " Two "; break;
                case '3': n = " Three "; break;
                case '4': n = " Four "; break;
                case '5': n = " Five "; break;
                case '6': n = " Six "; break;
                case '7': n = " Seven "; break;
                case '8': n = " Eight "; break;
                case '9': n = " Nine "; break;
                default: n = "Not a Number"; break;
            }
            return n;
        }

        private static string d2(char x)
        { // 10x digit terms
            string n;
            switch (x)
            {
                case '0': n = ""; break;
                case '1': n = ""; break;
                case '2': n = " Twenty "; break;
                case '3': n = " Thirty "; break;
                case '4': n = " Forty "; break;
                case '5': n = " Fifty "; break;
                case '6': n = " Sixty "; break;
                case '7': n = " Seventy "; break;
                case '8': n = " Eighty "; break;
                case '9': n = " Ninety "; break;
                default: n = "Not a Number"; break;
            }
            return n;
        }

        private static string d3(char x)
        { // teen digit terms
            string n;
            switch (x)
            {
                case '0': n = " Ten "; break;
                case '1': n = " Eleven "; break;
                case '2': n = " Twelve "; break;
                case '3': n = " Thirteen "; break;
                case '4': n = " Fourteen "; break;
                case '5': n = " Fifteen "; break;
                case '6': n = " Sixteen "; break;
                case '7': n = " Seventeen "; break;
                case '8': n = " Eighteen "; break;
                case '9': n = " Nineteen "; break;
                default: n = "Not a Number"; break;
            }
            return n;
        }

        #endregion --NumberToWords functions--

        public string ConvertToDMY(string strDateTime)
        {
            string[] strArr = strDateTime.Split('/');
            strDateTime = strArr[1] + "/" + strArr[0] + "/" + strArr[2];
            return strDateTime;
        }

        public static string ReplaceSingleQuotes(string str)
        {
            if (str != null)
            {
                return str.Trim().Replace("'", "''");
            }
            else
            {
                return "";
            }
        }

        //public static string ReplaceSingleQuotes(string strOld, int maxLength) {
        //    string strNew = strOld.Trim().Replace("'", "''");
        //    if (strNew.Length > maxLength)
        //        strNew = strNew.Substring(0, maxLength);
        //    return strNew;
        //}

        public static DateTime GetFormatedDateTime(string strDateTime)
        {
            DateTime dt = new DateTime();
            if (!string.IsNullOrEmpty(strDateTime))
                if (strDateTime.Length >= 8)
                {
                    string[] strArr = strDateTime.Split('/');
                    strDateTime = strArr[1].Trim() + "/" + strArr[0].Trim() + "/" + strArr[2].Trim();
                    dt = Convert.ToDateTime(strDateTime);
                }
            return dt;
        }

        public static DateTime GetFormatedDateTimeNew(string strDateTime)
        {
            DateTime dt = new DateTime();
            if (!string.IsNullOrEmpty(strDateTime))
                if (strDateTime.Length >= 8)
                {
                    string[] strArr = strDateTime.Split('/');
                    strDateTime = strArr[0] + "/" + strArr[1] + "/" + strArr[2];
                    dt = Convert.ToDateTime(strDateTime);
                }
            return dt;
        }

        public static string MakedateFormat(string format)
        {
            if (format != null && format !="DD/MM/YYYY")
            {
                if (format.Contains("/") || format.Contains("-"))
                {
                    string[] array = format.Split(new string[] { "/", "-" }, StringSplitOptions.None);
                    int month = Convert.ToInt32(array[1]);
                    switch (month)
                    {
                        case 1:
                            array[1] = "Jan";
                            break;

                        case 2:
                            array[1] = "Feb";
                            break;

                        case 3:
                            array[1] = "Mar";
                            break;

                        case 4:
                            array[1] = "Apr";
                            break;

                        case 5:
                            array[1] = "May";
                            break;

                        case 6:
                            array[1] = "Jun";
                            break;

                        case 7:
                            array[1] = "Jul";
                            break;

                        case 8:
                            array[1] = "Aug";
                            break;

                        case 9:
                            array[1] = "Sep";
                            break;

                        case 10:
                            array[1] = "Oct";
                            break;

                        case 11:
                            array[1] = "Nov";
                            break;

                        case 12:
                            array[1] = "Dec";
                            break;
                    }
                    format = array[0] + "-" + array[1] + "-" + array[2];
                    return format;
                }
            }
            return format;
        }

        public static object GetValue(object value, bool returnString, bool returnNullString)
        {
            if (value == DBNull.Value || value == null || value.ToString() == "" || value.ToString() == "''" || value.ToString() == "0" || value.ToString() == "0.00")
            {
                return (returnNullString) ? "NULL" : (returnString) ? "" : "0";
            }
            return value;
        }

        public static object GetValue(object value, bool returnString)
        {
            return GetValue(value, returnString, false);
        }

        // Function to Check if given value is DBNull then return "0" for int & numeric 
        public static object GetValue(object value)
        {
            return GetValue(value, false);
        }

        //Function to Display blank on Page when '0' 
        public static object DisplayZeroWithNull(object value)
        {
            return GetValue(value, true);
        }

        //Function to insert null in database instead of 0 
        public static object GetNullFromZero(object value)
        {
            return GetNullFromZero(value, false);
        }

        //Function to insert null in database instead of 0 
        public static object GetNullFromZero(object value, bool isString)
        {
            object o = GetValue(value, false, true);
            if (isString && o.ToString() != "NULL")
            {
                return "'" + ReplaceSingleQuotes(o.ToString()) + "'";
            }
            return o;
        }

        //Function to insert DateTime from date(string)
        public static object GetFormatedDate(object value)
        {
            return (Convert.ToString(GetValue(value, true)) == "" ? "NULL" : "'" + MakedateFormat(value.ToString()) + "'");
        }

        //Function to get Date in string format from Database DateTime
        public static string GetStringFromDateTime(object value)
        {
            return Convert.ToString(GetValue(value, true)) == "" ? "" : Convert.ToDateTime(value).ToString("dd/MM/yyyy");
        }

        public static int GetMonthDiff(int fromYr, int fromMM, int toYr, int toMM)
        {
            int fromYr1, fromMM1, toYr1, toMM1, direction, result;
            result = 0;
            direction = 1;
            if (fromYr > toYr || (fromYr == toYr && fromMM > toMM))
            {
                fromYr1 = toYr;
                fromMM1 = toMM;
                toYr1 = fromYr;
                toMM1 = fromMM;
                direction = -1;
            }
            else
            {
                fromYr1 = fromYr;
                fromMM1 = fromMM;
                toYr1 = toYr;
                toMM1 = toMM;
            }

            result = (toYr1 - fromYr1) * 12 + (toMM1 - fromMM1 + 1);

            return result * direction;
        }

        //public static double CalculateBudgetPNL(double budgetAmount, DateTime EndDate, DateTime Effectivedate)
        //{
        //    double amount = 0;
        //    int startdays = Effectivedate.Day;
        //    int months = 0;
        //    int Totaldays = 0;
        //    int effday = 0;
        //    double dayamount = 0;
        //    months = GlobalUtil.GetMonthDiff(Effectivedate.Year, Effectivedate.Month, EndDate.Year, EndDate.Month);
        //    double onemonthsamount = budgetAmount / 12;

        //    if (startdays > 1)
        //    {
        //        Totaldays = DateTime.DaysInMonth(Effectivedate.Year, Effectivedate.Month);
        //        effday = Totaldays - startdays;
        //        effday = effday + 1;

        //        if (months > 0)
        //            months = months - 1;
        //        dayamount = (onemonthsamount / Totaldays) * effday;
        //    }

        //    double Totalmonthsamount = onemonthsamount * months;
        //    amount = Totalmonthsamount + dayamount;

        //    return amount;
        //}

        public static bool IsDuplicate(SqlConnection conn, string tableName, string duplicateColumnName, string duplicateValue, string primaryKeyColumnName, int primaryKeyValue, string errMsg, string addOnSql)
        {
            return IsDuplicate(conn, tableName, duplicateColumnName, duplicateValue, primaryKeyColumnName, primaryKeyValue, errMsg, addOnSql, true);
        }

        public static bool IsDuplicate(SqlConnection conn, string tableName, string duplicateColumnName, string duplicateValue, string primaryKeyColumnName, int primaryKeyValue, string errMsg, string addOnSql, bool throwExceptionOnDulpication)
        {
            string sql;

            sql = "select count(*) from " + tableName + " where " + duplicateColumnName + " =N'" + duplicateValue.Trim().Replace("'", "''").ToUpper() + "'";
            if (primaryKeyValue != 0)
            {
                sql = sql + " and " + primaryKeyColumnName + " <> " + primaryKeyValue;
            }
            if (addOnSql != "")
            {
                sql = sql + " and " + addOnSql;
            }
            if (errMsg == "")
            {
                errMsg = "Duplicate";
            }
            if (GetCountForSQL(conn, sql) > 0)
            {
                if (throwExceptionOnDulpication)
                    throw new DuplicateRecordException(errMsg);
                else
                    return true;
            }
            return false;
        }

        public static bool IsDuplicateSqlTrans(ref Persistent obj, string tableName, string duplicateColumnName, string duplicateValue, string primaryKeyColumnName, int primaryKeyValue, string errMsg, string addOnSql, bool throwExceptionOnDulpication)
        {
            string sql;

            sql = "select count(*) from " + tableName + " where upper(" + duplicateColumnName + ")=N'" + duplicateValue.Trim().Replace("'", "''").ToUpper() + "'";
            if (primaryKeyValue != 0)
            {
                sql = sql + " and " + primaryKeyColumnName + " <> " + primaryKeyValue;
            }
            if (addOnSql != "")
            {
                sql = sql + " and " + addOnSql;
            }
            if (errMsg == "")
            {
                errMsg = "Duplicate";
            }

            SqlCommand nonQryCommand = new SqlCommand();
            int RowsCount = -1;
            try
            {
                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;
                nonQryCommand.Connection = ((SqlTransaction)obj.SqlTrans).Connection;// sqlTran.Connection;
                nonQryCommand.Transaction = ((SqlTransaction)obj.SqlTrans);
                RowsCount = Convert.ToInt32(nonQryCommand.ExecuteScalar());
            }
            catch (Exception ex)
            {
                ((SqlTransaction)obj.SqlTrans).Rollback();
                throw ex;
            }

            if (RowsCount > 0)
            {
                if (throwExceptionOnDulpication)
                    throw new DuplicateRecordException(errMsg);
                else
                    return true;
            }
            return false;
        }
        public static bool IsDuplicateSqlTrans(ref Persistent obj, string tableName, string[] duplicateColumnName, string[] duplicateValue, string primaryKeyColumnName, int primaryKeyValue, string errMsg, string addOnSql, bool throwExceptionOnDulpication)
        {
            string sql;

            sql = "select count(*) from " + tableName + " where upper(" + duplicateColumnName.GetValue(0).ToString() + ")='" + duplicateValue.GetValue(0).ToString().Trim().Replace("'", "''").ToUpper() + "'";
            for (int i = 1; i < duplicateColumnName.Length; i++)
            {
                sql += " and upper(" + duplicateColumnName.GetValue(i).ToString() + ")='" + duplicateValue.GetValue(i).ToString().Trim().Replace("'", "''").ToUpper() + "'";
            }
            if (primaryKeyValue != 0)
            {
                sql = sql + " and " + primaryKeyColumnName + " <> " + primaryKeyValue;
            }
            if (addOnSql != "")
            {
                sql = sql + " and " + addOnSql;
            }
            if (errMsg == "")
            {
                errMsg = "Duplicate";
            }

            SqlCommand nonQryCommand = new SqlCommand();
            int RowsCount = -1;
            try
            {
                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;
                nonQryCommand.Connection = ((SqlTransaction)obj.SqlTrans).Connection;// sqlTran.Connection;
                nonQryCommand.Transaction = ((SqlTransaction)obj.SqlTrans);
                RowsCount = Convert.ToInt32(nonQryCommand.ExecuteScalar());
            }
            catch (Exception ex)
            {
                ((SqlTransaction)obj.SqlTrans).Rollback();
                throw ex;
            }

            if (RowsCount > 0)
            {
                if (throwExceptionOnDulpication)
                    throw new DuplicateRecordException(errMsg);
                else
                    return true;
            }
            return false;
        }
        public static bool HasRecords(SqlConnection conn, string tabName, string colName, string colValue)
        {
            string sql;
            sql = "select count(*) as c from " + tabName + " where " + colName + " = '" + colValue + "'";
            return GetCountForSQL(conn, sql) > 0;
        }

        public static bool HasRecords(SqlConnection conn, string tabName, string colName, string colValue, string addOnSql)
        {
            string sql;
            sql = "select count(*) as c from " + tabName + " where " + colName + " = '" + colValue + "' " + addOnSql;
            return GetCountForSQL(conn, sql) > 0;
        }

        public static bool HasRecordsTrans(ref Persistent obj, string tabName, string colName, string colValue, string addOnSql)
        {
            string sql;
            sql = "select count(*) as c from " + tabName + " where " + colName + " = '" + colValue + "' " + addOnSql;
            return GetCountForSQLTrans(sql, ref obj) > 0;
        }

        public static int GetCountForSQL(SqlConnection myConnection, string Sql)
        {
            int retVal = -1;
            if (myConnection.State == ConnectionState.Closed)
            {
                myConnection.Open();
            }
            SqlDataReader dr = new SqlCommand(Sql, myConnection).ExecuteReader();
            if (dr.HasRows)
            {
                dr.Read();
                retVal = Convert.ToInt32(dr[0]);
            }
            myConnection.Close();

            return retVal;
        }
        public static int GetCountForSQLTrans(string Sql, ref Persistent obj)
        {
            SqlCommand nonQryCommand = new SqlCommand();
            int RowsCount = -1;
            try
            {
                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = Sql;
                nonQryCommand.Connection = ((SqlTransaction)obj.SqlTrans).Connection;// sqlTran.Connection;
                nonQryCommand.Transaction = ((SqlTransaction)obj.SqlTrans);
                RowsCount = Convert.ToInt32(nonQryCommand.ExecuteScalar());
            }
            catch (Exception ex)
            {
                ((SqlTransaction)obj.SqlTrans).Rollback();
                throw ex;
            }

            return RowsCount;
        }

        public static ArrayList FillArrayList(Persistent Obj, string strSearch, bool isSubClassReq)
        {
            ArrayList arrFilledObject;
            Criteria ObjCri = new Criteria(Obj);
            ObjCri.IsPagingRequired = false;
            ObjCri.IsSubClassRequired = isSubClassReq;
            arrFilledObject = ObjCri.Execute(strSearch);
            return arrFilledObject;
        }
        public static string getRecordStatus(Persistent objP, int loginUserCode, out string userName)
        {
            string strSql, strStatus = "";
            objP = (Persistent)objP;
            strSql = "select lock_time,last_updated_time,isNUll(datediff(ss,lock_time,getdate()),500) TimeDiff,Last_Action_By from " + objP.tableName + " where " + objP.pkColName + "=" + objP.IntCode;

            DataSet dsRecord = new DataSet();
            dsRecord = DatabaseBroker.ProcessSelectDirectly(strSql);
            int userCode = 0;
            userName = "";
            if (dsRecord.Tables[0].Rows.Count > 0)
            {
                if (objP.LastUpdatedTime != dsRecord.Tables[0].Rows[0]["last_updated_time"].ToString())
                {
                    userCode = Convert.ToInt32(dsRecord.Tables[0].Rows[0]["Last_Action_By"].ToString());
                    strStatus = GlobalParams.RECORD_STATUS_CHANGED;
                }
                else if (objP.LastUpdatedTime == dsRecord.Tables[0].Rows[0]["last_updated_time"].ToString())
                {
                    if (Convert.ToInt32(dsRecord.Tables[0].Rows[0]["TimeDiff"]) > Convert.ToInt32(HttpContext.GetGlobalResourceObject("STAR_RIGHTS", "intTimeDiffForLock")))
                    {
                        DatabaseBroker.ProcessScalarDirectly("update " + objP.tableName + " set lock_time=getdate(), Last_Action_By=" + objP.LastUpdatedBy + " where " + objP.pkColName + "=" + objP.IntCode);
                        userCode = objP.LastUpdatedBy;
                        strStatus = GlobalParams.RECORD_STATUS_UPDATABLE;
                    }
                    else
                    {
                        userCode = Convert.ToInt32(dsRecord.Tables[0].Rows[0]["Last_Action_By"].ToString());
                        strStatus = GlobalParams.RECORD_STATUS_LOCKED;
                    }
                }
                if (userCode > 0)
                {
                    Users objUser = new Users();
                    objUser.IntCode = userCode;
                    // objUser.NeedAllUser = true;
                    objUser.Fetch();
                    userName = objUser.firstName;
                    if (userCode == loginUserCode)
                        strStatus = GlobalParams.RECORD_STATUS_UPDATABLE;
                }
                return strStatus;
            }
            else
            {
                return GlobalParams.RECORD_STATUS_DELETED;//record has been deleted;
            }

            return null;

        }

        public static void unlockRecord(Persistent objP)
        {
            string strSql = "";
            string className = objP.ToString();
            strSql = "update " + objP.tableName + " set lock_time=null where " + objP.pkColName + "=" + objP.IntCode;
            DatabaseBroker.ProcessScalarDirectly(strSql);

        }

        public static void refreshRecord(Persistent objP)
        {

            string strSql = "";
            strSql = "update " + objP.tableName + " set lock_time=getdate() where " + objP.pkColName + "=" + objP.IntCode;
            DatabaseBroker.ProcessScalarDirectly(strSql);

        }

        //public static void sendEmailForForgetPassword(Users objUser, HttpServerUtility Server, out bool error)
        //{
        //    error = false;
        //    try
        //    {
        //        StreamReader reader;
        //        string MailTemplatePath = "~/Templates";

        //        reader = new StreamReader(new FileStream(Server.MapPath(MailTemplatePath) + "/ChangePassword.htm"
        //                                , FileMode.Open, FileAccess.Read));

        //        StringBuilder BodyText = new StringBuilder();
        //        BodyText.Append(reader.ReadToEnd());
        //        reader.Close();
        //        SendMail objSendMail = new SendMail();
        //        string sysName = ConfigurationManager.AppSettings["SystemName"].ToString();
        //        string subject = "Your new Password for " + sysName;
        //        BodyText = BodyText.Replace("{user_fname}", objUser.firstName);
        //        BodyText = BodyText.Replace("{user_lname}", objUser.lastName);
        //        BodyText = BodyText.Replace("{user_name}", objUser.loginName);
        //        BodyText = BodyText.Replace("{user_password}", objUser.password);

        //        objSendMail.FromEmailId = objLoginUser.emailId;
        //        objSendMail.ToEmailId = objUser.emailId;
        //        objSendMail.MailText = BodyText.ToString();
        //        objSendMail.send();
        //        SendMailToUser(BodyText, subject, ConfigurationManager.AppSettings["FROMEMAIL"].ToString(), objUser.emailId);
        //    }
        //    catch
        //    {
        //        error = true;
        //    }
        //}

        //public static void sendEmailForGeneratePassword(Users objUser, Users objLoginUser, HttpServerUtility Server, out bool error, string process)
        //{
        //    error = false;
        //    try
        //    {
        //        StreamReader reader;
        //        string MailTemplatePath = "~/Templates";

        //        reader = new StreamReader(new FileStream(Server.MapPath(MailTemplatePath) + "/GeneratePassword.htm"
        //                                , FileMode.Open, FileAccess.Read));

        //        StringBuilder BodyText = new StringBuilder();
        //        BodyText.Append(reader.ReadToEnd());
        //        reader.Close();
        //        SendMail objSendMail = new SendMail();
        //        string sysName = ConfigurationManager.AppSettings["SystemName"].ToString();
        //        string subject = "Your new Password for " + sysName;
        //        BodyText = BodyText.Replace("{PROCESS}", process);
        //        BodyText = BodyText.Replace("{user_fname}", objUser.firstName);
        //        BodyText = BodyText.Replace("{user_lname}", objUser.lastName);
        //        BodyText = BodyText.Replace("{user_name}", objUser.loginName);
        //        BodyText = BodyText.Replace("{user_password}", objUser.password);
        //        BodyText = BodyText.Replace("{adminEmail}", objLoginUser.emailId);
        //        BodyText = BodyText.Replace("{adminfname}", objLoginUser.firstName);
        //        BodyText = BodyText.Replace("{adminlname}", objLoginUser.lastName);

        //        objSendMail.FromEmailId = objLoginUser.emailId;
        //        objSendMail.ToEmailId = objUser.emailId;
        //        objSendMail.MailText = BodyText.ToString();
        //        objSendMail.send();
        //        SendMailToUser(BodyText, subject, objLoginUser.emailId, objUser.emailId);
        //    }
        //    catch
        //    {
        //        error = true;
        //    }
        //}

        //public static void SendMailToUser(wsinvitation objInv, wsinvitationdetail objInvDet)
        //{
        //    MailMessage mail = new MailMessage();
        //    //mail.To.Add(objInvDet.toemail);
        //    mail.To.Add("adesh.arote@gmail.com");
        //    mail.From = new MailAddress(objInv.fromemail);
        //    mail.Subject = objInv.subject;
        //    string Body = objInv.message;
        //    mail.Body = Body;
        //    mail.IsBodyHtml = true;

        //    SmtpClient smtp = new SmtpClient();
        //    smtp.Host = ConfigurationManager.AppSettings["SMTP"];
        //    smtp.UseDefaultCredentials = false;
        //    smtp.Port = 587;
        //    smtp.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["FROMEMAIL"], ConfigurationManager.AppSettings["FROMPWD"]);
        //    //smtp.Port = Convert.ToInt32(ConfigurationManager.AppSettings["PORT"]);

        //    smtp.EnableSsl = true;
        //    smtp.Send(mail);
        //}

        public static void SendMailToUser(StringBuilder BodyText, string subject, string fromMailId, string toMailId)
        {
            MailMessage mail = new MailMessage();
            mail.To.Add(toMailId);
            mail.CC.Add("adesh.arote@gmail.com");
            mail.From = new MailAddress(fromMailId);
            mail.Subject = subject;
            string Body = BodyText.ToString();
            mail.Body = Body;
            mail.IsBodyHtml = true;

            SmtpClient smtp = new SmtpClient();
            smtp.Host = ConfigurationSettings.AppSettings["SMTP"];
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = new System.Net.NetworkCredential(ConfigurationSettings.AppSettings["FROMEMAIL"], ConfigurationSettings.AppSettings["FROMPWD"]);
            smtp.Port = Convert.ToInt32(ConfigurationSettings.AppSettings["PORT"]);

            smtp.EnableSsl = false;
            smtp.Send(mail);
        }

        public static string convertDateinMDY(string dateDMY)
        {
            if (!dateDMY.Trim().Equals(""))
            {
                string[] dt = dateDMY.Split('/');
                //return dt[2] + "-" + dt[1] + "-" + dt[0];
                return dt[1] + "/" + dt[0] + "/" + dt[2];
            }
            return "";
        }

        public static string DisplayZeroWithEmpty(string val)
        {
            if (val == string.Empty)
                return "0";
            else
                return val;
        }

        public static ArrayList GetArrDayShortName(bool is1Dim)
        {
            ArrayList arrRet = new ArrayList();
            if (is1Dim)
            {
                arrRet.Add("MON");
                arrRet.Add("TUE");
                arrRet.Add("WED");
                arrRet.Add("THU");
                arrRet.Add("FRI");
                arrRet.Add("SAT");
                arrRet.Add("SUN");
            }
            else
            {
                arrRet.Add(new AttribValue("MON", "MON"));
                arrRet.Add(new AttribValue("TUE", "TUE"));
                arrRet.Add(new AttribValue("WED", "WED"));
                arrRet.Add(new AttribValue("THU", "THU"));
                arrRet.Add(new AttribValue("FRI", "FRI"));
                arrRet.Add(new AttribValue("SAT", "SAT"));
                arrRet.Add(new AttribValue("SUN", "SUN"));
            }

            return arrRet;
        }
        public static string replaceSingleQuotesAndTrim(string str)
        {
            if (str != null)
            {
                return str.Trim().Replace("'", "''");
            }
            else
            {
                return "";
            }
        }
        public static void dtLst_ItemDataBound(DataListItemEventArgs e, Button btnPager, int pageNo, HiddenField hdnEditRecord)
        {
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                if (hdnEditRecord != null)
                {
                    btnPager.Attributes.Add("Onclick", "javascript:return canEditRecordAjax(" + hdnEditRecord.ClientID + ")");
                }
                if (pageNo == Convert.ToInt32(btnPager.CommandArgument))
                {
                    btnPager.Enabled = false;
                    btnPager.CssClass = "band1";
                }
            }
        }


        //public static void GenPaymentIntimation(int dealMemoCode, int moduleCode, int rightCode, ref SqlTransaction sqlTrans, string dueDate, int userCode, out int recCount, out bool isMailSend) {
        public static void GenPaymentIntimation(int dealMemoCode, int moduleCode, int rightCode, ref SqlTransaction sqlTrans, string dueDate, int userCode)
        {
            //// Check whether Payment intimation is to be generated for this module along with current operation right or not
            //int recCount = 0;
            ////isMailSend = false;
            //StringBuilder payIntCodes = new StringBuilder();

            //string strSql = "SELECT payment_terms_code FROM Payment_Terms_Module_Right PTMR INNER JOIN System_Module_Right SMR" +
            //                " ON PTMR.module_right_code = SMR.module_right_code WHERE module_code = " + moduleCode + " AND right_code = " + rightCode;
            ////DataSet dsPayTermCode = (new DraftLFARcdBroker()).ProcessSelect(strSql);
            //DataSet dsPayTermCode = GetDataSetForSQL(sqlTrans, strSql);
            //if (dsPayTermCode.Tables[0].Rows.Count > 0)
            //{
            //    for (int j = 0; j < dsPayTermCode.Tables[0].Rows.Count; j++)
            //    {
            //        int payTermCode = Convert.ToInt32(dsPayTermCode.Tables[0].Rows[j]["payment_terms_code"]);

            //        // Selecting the records for which Payment intimation to be generated 
            //        strSql = "SELECT deal_movie_payment_terms_code, deal_movie_rights_code, amount, exchange_rate,due_date FROM vw_DealMemoDetails WHERE payment_terms_code = " + payTermCode
            //                    + " AND deal_memo_code = " + dealMemoCode + " AND payment_intitmation_code IS NULL AND (due_date  >= getdate() OR due_date IS NULL )";

            //        DataSet dsPayRec;
            //        if (sqlTrans == null)
            //        {
            //            dsPayRec = GetDataSetForSQL(sqlTrans, strSql);
            //        }
            //        else
            //        {
            //            dsPayRec = GetDataSetForSQL(sqlTrans, strSql);
            //        }

            //        for (int i = 0; i < dsPayRec.Tables[0].Rows.Count; i++)
            //        {
            //            int dealMovieRightsCode = Convert.ToInt32(dsPayRec.Tables[0].Rows[i]["deal_movie_rights_code"]);

            //            // Get the amount for which payment intimation already generated
            //            strSql = "select isnull(payment_intimation_amount, 0) from Deal_movie_rights where deal_movie_rights_code = " + dealMovieRightsCode;

            //            double payIntDone = 0;
            //            if (sqlTrans == null)
            //            {
            //                payIntDone = Convert.ToDouble(ProcessScalar(strSql));
            //            }
            //            else
            //            {
            //                payIntDone = Convert.ToDouble(ProcessScalar(strSql, ref sqlTrans));
            //            }

            //            // Get the amount which is paid in advance
            //            strSql = "select isnull(paid_amount, 0) from Deal_movie_rights where deal_movie_rights_code = " + dealMovieRightsCode;

            //            double advPayment = 0;
            //            if (sqlTrans == null)
            //            {
            //                advPayment = Convert.ToDouble(ProcessScalar(strSql));
            //            }
            //            else
            //            {
            //                advPayment = Convert.ToDouble(ProcessScalar(strSql, ref sqlTrans));
            //            }

            //            // Get the remaining amount
            //            strSql = "select (isnull(cost_of_rights,0) - isnull(paid_amount, 0)) RemAmount from Deal_Movie_Rights where deal_movie_rights_code=" + dealMovieRightsCode;

            //            double remAmount = 0;
            //            if (sqlTrans == null)
            //            {
            //                remAmount = Convert.ToDouble(ProcessScalar(strSql));
            //            }
            //            else
            //            {
            //                remAmount = Convert.ToDouble(ProcessScalar(strSql, ref sqlTrans));
            //            }
            //            //double payIntAmount = Convert.ToDouble(dsPayRec.Tables[0].Rows[i]["amount"]) * Convert.ToDouble(dsPayRec.Tables[0].Rows[i]["exchange_rate"]);
            //            double payIntAmount = Convert.ToDouble(dsPayRec.Tables[0].Rows[i]["amount"]);

            //            if (remAmount >= (payIntAmount + payIntDone))
            //            {
            //                // Create Payment Intimation
            //                // Update deal_movie_payment_terms

            //                PaymentIntimation objPayInt = new PaymentIntimation();
            //                objPayInt.intimationType = GlobalParams.PayIntType_LicenceFees;
            //                objPayInt.recCode = Convert.ToInt32(dsPayRec.Tables[0].Rows[i]["deal_movie_payment_terms_code"]);
            //                if (sqlTrans == null)
            //                {
            //                    objPayInt.paymentIntimationNo = DBUtil.getAutoGeneratedNo("Payment_Intimation", "payment_intitmation_no", "payment_intitmation_no", (Convert.ToDateTime(GlobalUtil.MakedateFormat(getCurrentDateFromServer()))).Year, 4, 4, 7, "PI-{yr}-{no}");
            //                }
            //                else
            //                {
            //                    objPayInt.paymentIntimationNo = DBUtil.getAutoGeneratedNo("Payment_Intimation", "payment_intitmation_no", "payment_intitmation_no", (Convert.ToDateTime(GlobalUtil.MakedateFormat(getCurrentDateFromServer()))).Year, 4, 4, 7, "PI-{yr}-{no}", ref sqlTrans);
            //                }
            //                //objPayInt.insertedBy = loginUserId;
            //                objPayInt.intimationAmt = payIntAmount;
            //                objPayInt.dueDate = (GlobalUtil.GetStringFromDateTime(dsPayRec.Tables[0].Rows[i]["due_date"]) == "" ? dueDate : GlobalUtil.GetStringFromDateTime(dsPayRec.Tables[0].Rows[i]["due_date"]));
            //                if (objPayInt.dueDate == "")
            //                {
            //                    objPayInt.dueDate = dueDate;
            //                }
            //                objPayInt.insertedBy = userCode;
            //                objPayInt.IsTransactionRequired = true;

            //                if (sqlTrans == null)
            //                    objPayInt.IsBeginningOfTrans = true;
            //                else
            //                    objPayInt.SqlTrans = sqlTrans;

            //                objPayInt.IsLastIdRequired = true;
            //                objPayInt.IsProxy = true;
            //                objPayInt.Save();
            //                recCount++;

            //                if (payIntCodes.ToString() != "")
            //                {
            //                    payIntCodes.Append(",");
            //                }
            //                payIntCodes.Append(objPayInt.IntCode);

            //                int res = (new DealMoviePaymentTerms()).UpdatePayInt(objPayInt.recCode, objPayInt.IntCode, payIntAmount, ref sqlTrans);
            //            }
            //        }
            //    }
            //    if (recCount > 0)
            //    {
            //        SendPaymentIntimationSummaryMail(payIntCodes, ref sqlTrans);
            //    }
            //    else
            //    {
            //        //GlobalParams.paymentintimationMailFlag = GlobalParams.payIntMailNotApplicable;
            //    }
            //}
        }


        public static void SendPaymentIntimationSummaryMail(object obj, ref SqlTransaction sqlTrans)
        {
            StringBuilder innerMailBody = (StringBuilder)obj;
            ArrayList arrParam = new ArrayList();
            arrParam.Add(new AttribValue("@paymentIntimationCodes", obj.ToString()));
            int res = Convert.ToInt32(DBUtil.ProcessScalar("EXEC usp_SendPayIntMail '" + obj + "'", ref sqlTrans));
        }

        public static DataSet getMailTemplateDetails(int moduleCode)
        {
            string strTemplate = "SELECT * FROM Email_Template et INNER JOIN Email_Template_Module etm "
                              + "ON et.email_template_code=etm.email_template_code WHERE module_code=" + moduleCode
                              + " AND is_active='Y'";
            DataSet dsTemplate = DatabaseBroker.ProcessSelectDirectly(strTemplate);
            return dsTemplate;
        }

        /// <summary>
        /// Get object from given object which is not NULL
        /// This function mainly used to get "0" or blank string or "NULL" string from any NULL object
        /// </summary>
        /// <param name="value">Given object to check</param>
        /// <param name="returnInt">Is return object need Integer(0)</param>
        /// <param name="returnNullString">Is return object need "NULL" string</param>
        /// <returns>Get object which is not NULL</returns>
        public static object checkAndGetValue(object value, bool returnInt, bool returnNullString)
        {
            //if (value == DBNull.Value || value == null || value.ToString() == "" || value.ToString() == "''" || value.ToString() == "0" || value.ToString() == "0.00") {
            if (value == DBNull.Value || value == null || value.ToString() == "" || value.ToString() == "''" || (checkNumeric(value.ToString(), NumericType.doubleType) && Convert.ToDouble(value) == 0.0))
            {
                return (returnNullString) ? "NULL" : (returnInt) ? "0" : "";
            }
            return value;
        }

        /// <summary>
        /// Get object from given object which is not NULL
        /// This function mainly used to get blank string or "0" from any NULL object
        /// </summary>
        /// <param name="value">Given object to check</param>
        /// <param name="returnInt">Is return object need Integer(0)</param>
        /// <returns>Get object which is not NULL</returns>
        public static object checkAndGetValue(object value, bool returnInt)
        {
            return checkAndGetValue(value, returnInt, false);
        }
        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType)
        {
            return checkNumeric(value, valueType, true);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="isZeroAllowed">Is Zero allowed in Value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, bool isZeroAllowed)
        {
            return checkNumeric(value, valueType, isZeroAllowed, int.MaxValue);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="resultValue">Output parameter to get result value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, out object resultValue)
        {
            return checkNumeric(value, valueType, true, int.MaxValue, out resultValue);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="isZeroAllowed">Is Zero allowed in Value</param>
        /// <param name="resultValue">Output parameter to get result value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, bool isZeroAllowed, out object resultValue)
        {
            return checkNumeric(value, valueType, isZeroAllowed, int.MaxValue, out resultValue);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, int intergerPartDigit)
        {
            return checkNumeric(value, valueType, true, intergerPartDigit, 0);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="isZeroAllowed">Is Zero allowed in Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, bool isZeroAllowed, int intergerPartDigit)
        {
            return checkNumeric(value, valueType, isZeroAllowed, intergerPartDigit, 0);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <param name="resultValue">Output parameter to get result value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, int intergerPartDigit, out object resultValue)
        {
            return checkNumeric(value, valueType, true, intergerPartDigit, 0, out resultValue);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="isZeroAllowed">Is Zero allowed in Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <param name="resultValue">Output parameter to get result value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, bool isZeroAllowed, int intergerPartDigit, out object resultValue)
        {
            return checkNumeric(value, valueType, isZeroAllowed, intergerPartDigit, 0, out resultValue);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <param name="decimalPartDigit">No of digit limit to Decimal part</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, int intergerPartDigit, int decimalPartDigit)
        {
            return checkNumeric(value, valueType, true, intergerPartDigit, decimalPartDigit);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="isZeroAllowed">Is Zero allowed in Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <param name="decimalPartDigit">No of digit limit to Decimal part</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, bool isZeroAllowed, int intergerPartDigit, int decimalPartDigit)
        {
            object resultValue;
            return checkNumeric(value, valueType, isZeroAllowed, intergerPartDigit, decimalPartDigit, out resultValue);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="isZeroAllowed">Is Zero allowed in Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <param name="decimalPartDigit">No of digit limit to Decimal part</param>
        /// <param name="resultValue">Output parameter to get result value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, int intergerPartDigit, int decimalPartDigit, out object resultValue)
        {
            return checkNumeric(value, valueType, true, intergerPartDigit, decimalPartDigit, out resultValue);
        }

        /// <summary>
        /// Method to validate Numeric value
        /// </summary>
        /// <param name="value">Value to check for numeric</param>
        /// <param name="valueType">Type of Value</param>
        /// <param name="isZeroAllowed">Is Zero allowed in Value</param>
        /// <param name="intergerPartDigit">No of digit limit to Intiger part</param>
        /// <param name="decimalPartDigit">No of digit limit to Decimal part</param>
        /// <param name="resultValue">Output parameter to get result value</param>
        /// <returns>Return wheather given is numeric</returns>
        public static bool checkNumeric(string value, NumericType valueType, bool isZeroAllowed, int intergerPartDigit, int decimalPartDigit, out object resultValue)
        {
            bool result;
            switch (valueType)
            {
                case NumericType.int16Type:
                    Int16 resValue16 = 0;
                    result = Int16.TryParse(value, out resValue16);
                    resultValue = resValue16;
                    if (result)
                    {
                        if (resultValue.ToString().Length > intergerPartDigit || (!isZeroAllowed && resValue16 == 0))
                        {
                            return false;
                        }
                        return true;
                    }
                    return result;
                case NumericType.int32Type:
                    Int32 resValue32 = 0;
                    result = Int32.TryParse(value, out resValue32);
                    resultValue = resValue32;
                    if (result)
                    {
                        if (resultValue.ToString().Length > intergerPartDigit || (!isZeroAllowed && resValue32 == 0))
                        {
                            return false;
                        }
                        return true;
                    }
                    return result;
                case NumericType.int64Type:
                    Int64 resValue64 = 0;
                    result = Int64.TryParse(value, out resValue64);
                    resultValue = resValue64;
                    if (result)
                    {
                        if (resultValue.ToString().Length > intergerPartDigit || (!isZeroAllowed && resValue64 == 0))
                        {
                            return false;
                        }
                        return true;
                    }
                    return result;
                case NumericType.floatType:
                    float resValueFloat = 0;
                    result = float.TryParse(value, out resValueFloat);
                    resultValue = resValueFloat;
                    if (result)
                    {
                        if ((resultValue.ToString().Split(Convert.ToChar("."))[0].Length > intergerPartDigit) || (resultValue.ToString().Split(Convert.ToChar(".")).Length > 1 && resultValue.ToString().Split(Convert.ToChar("."))[1].Length > decimalPartDigit) || (!isZeroAllowed && resValueFloat == 0))
                        {
                            return false;
                        }
                        return true;
                    }
                    return result;
                case NumericType.decimalType:
                    decimal resValueDecimal = 0;
                    result = decimal.TryParse(value, out resValueDecimal);
                    resultValue = resValueDecimal;
                    if (result)
                    {
                        if ((resultValue.ToString().Split(Convert.ToChar("."))[0].Length > intergerPartDigit) || (resultValue.ToString().Split(Convert.ToChar(".")).Length > 1 && resultValue.ToString().Split(Convert.ToChar("."))[1].Length > decimalPartDigit) || (!isZeroAllowed && resValueDecimal == 0))
                        {
                            return false;
                        }
                        return true;
                    }
                    return result;
                case NumericType.doubleType:
                    double resValueDouble = 0;
                    result = double.TryParse(value, out resValueDouble);
                    resultValue = resValueDouble;
                    if (result)
                    {
                        if ((resultValue.ToString().Split(Convert.ToChar("."))[0].Length > intergerPartDigit) || (resultValue.ToString().Split(Convert.ToChar(".")).Length > 1 && resultValue.ToString().Split(Convert.ToChar("."))[1].Length > decimalPartDigit) || (!isZeroAllowed && resValueDouble == 0))
                        {
                            return false;
                        }
                        return true;
                    }
                    return result;
            }
            resultValue = 0;
            return true;
        }



        //Added by bhavesh on 20 Aug 2013
        public static string HideShowBudgetTab(int dealCode)
        {
            string result = "";
            if (dealCode > 0)
            {
                result = DatabaseBroker.ProcessScalarReturnString("select   case when BudgetWiseCostingApplicable = 'Y' and ValidateCostWithBudget = 'Y' then 'Y' else 'N' end from deal where deal_code =" + dealCode);
            }
            return result;
        }

        /*Added by bhavesh on 20 Aug 2013 */
        public static string GetBudgetWiseCostingApplicable(int DealCode, SqlTransaction SqlSqlTrans)
        {

            string ISBudgetWiseCostingApplicable = "";
            if (SqlSqlTrans != null)
            {
                ISBudgetWiseCostingApplicable = DatabaseBroker.ProcessScalarUsingTrans("select BudgetWiseCostingApplicable from deal where deal_code = " + DealCode, ref SqlSqlTrans);
            }
            else
            {
                ISBudgetWiseCostingApplicable = DatabaseBroker.ProcessScalarReturnString("select BudgetWiseCostingApplicable from deal where deal_code = " + DealCode);
            }
            return ISBudgetWiseCostingApplicable;
        }

        public static string GetValidateCostWithBudget(int DealCode, SqlTransaction SqlSqlTrans)
        {
            string ISValidateCostWithBudget = "";

            if (SqlSqlTrans != null)
            {
                ISValidateCostWithBudget = DatabaseBroker.ProcessScalarUsingTrans("select ValidateCostWithBudget from deal where deal_code = " + DealCode, ref  SqlSqlTrans);
            }
            else
            {
                ISValidateCostWithBudget = DatabaseBroker.ProcessScalarReturnString("select ValidateCostWithBudget from deal where deal_code = " + DealCode);
            }
            return ISValidateCostWithBudget;

            /* End of Add by Bhavesh on 20 Aug 2013*/

        }


        //This Function is not in use Added bu bhavesh on 21 Aug 2013
        public static string IsBudgetTabAllowedInSystemparam(SqlTransaction sqltrans)
        {
            string Result = "";

            if (sqltrans != null)
                Result = DatabaseBroker.ProcessScalarUsingTrans("select parameter_value from system_parameter_new where parameter_name = 'IsBudgetWiseCostAllowed'", ref sqltrans);
            else
                Result = DatabaseBroker.ProcessScalarReturnString("select parameter_value from system_parameter_new where parameter_name = 'IsBudgetWiseCostAllowed'");
            return Result;
        }


        public static string IsBudgetWiseCostingApplicableInDeal(int DealMovieCode, SqlTransaction SqlSqlTrans)
        {
            string Result = "";
            if (SqlSqlTrans == null)
            {
                Result = DatabaseBroker.ProcessScalarReturnString("select budgetwiseCostingApplicable from Deal " +
                            " where deal_code = (select deal_code from deal_movie where deal_movie_code = " + DealMovieCode + ")");
            }
            return Result;
        }

        public static string GetCurrentLoggedInEntity(Users objloginuser)
        {
            return Convert.ToString(new GlobalUtil().objLoginEntity.ReportingServerFolder);
        }

        public static string GetDealTypeCondition(int dealTypeCode)
        {
            if (dealTypeCode == GlobalParams.Deal_Type_Content || dealTypeCode == GlobalParams.Deal_Type_Sports
                || dealTypeCode == GlobalParams.Deal_Type_Format_Program || dealTypeCode == GlobalParams.Deal_Type_Event
                || dealTypeCode == GlobalParams.Deal_Type_Documentary_Show || dealTypeCode == GlobalParams.Deal_Type_WebSeries)
            {
                return GlobalParams.Deal_Program;
            }
            else if (dealTypeCode == GlobalParams.Deal_Type_Music || dealTypeCode == GlobalParams.Deal_Type_ContentMusic)
                return GlobalParams.Deal_Music;
            else if (dealTypeCode == GlobalParams.Deal_Type_Movie || dealTypeCode == GlobalParams.Deal_Type_Documentary_Film
                || dealTypeCode == GlobalParams.Deal_Type_ShortFlim || dealTypeCode == GlobalParams.Deal_Type_Featurette || dealTypeCode == GlobalParams.Deal_Type_Cineplay
                || dealTypeCode == GlobalParams.Deal_Type_Tele_Film || dealTypeCode == GlobalParams.Deal_Type_Drama_Play
                )
                return GlobalParams.Deal_Movie;
            else
                return GlobalParams.Sub_Deal_Talent;
        }

        public static string Acq_Change_Page(string command, string mode)
        {
            string strURL = "~/Deal_Acquisition/";

            switch (command)
            {
                case "A":
                    if (mode == GlobalParams.DEAL_MODE_VIEW || mode == GlobalParams.DEAL_MODE_APPROVE)
                        strURL += "Acq_General_View.aspx";
                    else
                        strURL += "Acq_General.aspx";
                    break;
                case "B": strURL += "Acq_Rights_List.aspx"; break;
                case "AN": strURL += "Acq_Ancillary.aspx"; break;
                case "DR": strURL += "Acq_Run_List.aspx"; break;
                case "PB": strURL += "Acq_Pushback.aspx"; break;
                case "H": strURL += "Acq_Payment_Term.aspx"; break;
                case "F": strURL += "Acq_Attachment.aspx"; break;
                case "I": strURL += "Acq_Material.aspx"; break;
                case "J": strURL += "WorkFlow_Status_History.aspx"; break;
                case "C": strURL += "Acq_Cost_List.aspx"; break;
                case "L": strURL += "Acq_Sports.aspx"; break;
                case "SA": strURL += "Acq_Sports_Ancillary_New.aspx"; break;
                case "BD": strURL += "Acq_Budget.aspx"; break;
            }

            return strURL;
        }

        public static string Syn_Change_Page(string command, string mode)
        {
            string strURL = "~/Deal_Syndication/";
            switch (command)
            {
                case "A":
                    if (mode == GlobalParams.DEAL_MODE_VIEW || mode == GlobalParams.DEAL_MODE_APPROVE)
                        strURL += "Syn_General_View.aspx";
                    else
                        strURL += "Syn_General.aspx";
                    break;
                case "B": strURL += "Syn_Rights_list.aspx"; break;
                case "DR": strURL += "Syn_Run_List.aspx"; break;
                case "PB": strURL += "Syn_Pushback.aspx"; break;
                case "D": strURL += "Syn_Payment_Term.aspx"; break;
                case "F": strURL += "Syn_Attachment.aspx"; break;
                case "E": strURL += "Syn_Material.aspx"; break;
                case "G": strURL = "~/Deal_Acquisition/WorkFlow_Status_History.aspx?Module_Type=S"; break;
                //case "J": strURL += "WorkFlow_Status_History.aspx?Module_Type=S"; break;
                case "C": strURL += "Syn_Cost_List.aspx"; break;
            }

            return strURL;
        }
    }
}
