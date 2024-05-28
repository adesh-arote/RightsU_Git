using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace UTOFrameWork.FrameworkClasses
{

    public class ReportColumn : Persistent
    {
        private ReportQuery _rq;

        private int _compID;  //component ID
        public int compID
        {
            get { return _compID; }
        }

        private int _columnCode;
        public int columnCode
        {
            get { return _columnCode; }
            set { _columnCode = value; }
        }

        private string _viewName;
        public string ViewName
        {
            get { return _viewName; }
            set { _viewName = value; }
        }

        private string _nameInDb;
        public string NameInDb
        {
            get { return _nameInDb; }
            set { _nameInDb = value; }
        }

        private string _displayName;
        public string DisplayName
        {
            get { return _displayName; }
            set { _displayName = value; }
        }

        private int _valuedAs;
        public int valuedAs
        {
            get { return _valuedAs; }
        }

        private int _selectOrder;
        public int SelectOrder
        {
            get { return _selectOrder; }
            set { _selectOrder = value; }
        }

        private string _isPartofSelectonly;
        public string IsPartofSelectonly
        {
            get { return _isPartofSelectonly; }
            set { _isPartofSelectonly = value; }
        }

        private string _listSource;  //name of Persistent class to fetch list of values
        private string _lookupCol;
        private string _displayCol;

        private List<AttribValue> arrAvail = new List<AttribValue>();

        private string _dbValue;
        public string dbValue
        {
            get { return _dbValue; }
            set { _dbValue = value; }
        }

        private int _maxLen = 15;
        public int maxLen
        {
            get { return _maxLen; }
            set { _maxLen = value; }
        }

        private string _addedJavascript = "";
        public string addedJavascript
        {
            get { return _addedJavascript; }
            set { _addedJavascript = value; }
        }

        private string _filter = "";
        public string filter
        {
            get { return _filter; }
            set { _filter = value; }
        }

        private bool _isSelect = false;
        public bool IsSelect
        {
            get { return _isSelect; }
            set { _isSelect = value; }
        }

        private int _displayOrd;
        public int DisplayOrd
        {
            get { return _displayOrd; }
            set { _displayOrd = value; }
        }

        private string _sortType;
        public string SortType
        {
            get { return _sortType; }
            set { _sortType = value; }
        }

        private int _sortOrd;
        public int SortOrd
        {
            get { return _sortOrd; }
            set { _sortOrd = value; }
        }

        private string _aggFunction;
        public string AggFunction
        {
            get { return _aggFunction; }
            set { _aggFunction = value; }
        }
        public int queryCode
        {
            get { return _rq.IntCode; }
        }

        private int _rightCodeForQuery;
        public int RightCodeForQuery
        {
            get { return _rightCodeForQuery; }
            set { _rightCodeForQuery = value; }
        }

        private string _whCondition;
        public string WhCondition
        {
            get { return _whCondition; }
            set { _whCondition = value; }
        }

        private string _validOpList;
        public string ValidOpList
        {
            get { return _validOpList; }
            set { _validOpList = value; }
        }

        private int _Alternate_Config_Code;
        public int Alternate_Config_Code
        {
            get { return _Alternate_Config_Code; }
            set { _Alternate_Config_Code = value; }
        }

        public bool isPartofWhere = false;

        public const int STR_VALUED = 1;
        public const int N_VALUE_1SELECT = 2;
        public const int MULTI_VALUED = 3;
        public const int DATE_VALUED = 4;
        public const int DATE_VALUED_OPTIONAL = 9;
        public const int AMT_VALUED = 5;
        public const int NUM_VALUED = 6;
        public const int DEC_VALUED = 7;
        public const int BOOL_VALUED = 8;

        private ReportColumn()
        { }

        public ReportColumn(ReportQuery rq, int compID, int columnCode, int Alternate_Config_Code, string viewName,
            string nameInDb, string displayName, int valuedAs, string listSource, string lookupCol, string displayCol, string selectOnly, int RightCol
            , int MaxLen, string WhCondition, string ValidOpList)
            : base()
        {
            _rq = rq;
            _compID = compID;
            _columnCode = columnCode;
            _Alternate_Config_Code = Alternate_Config_Code;
            _viewName = viewName;
            _nameInDb = nameInDb;
            _displayName = displayName;
            _valuedAs = valuedAs;
            _isPartofSelectonly = selectOnly;
            _listSource = listSource;
            _lookupCol = lookupCol;
            _displayCol = displayCol;
            _rightCodeForQuery = RightCol;
            _maxLen = MaxLen;
            _whCondition = WhCondition;
            _validOpList = ValidOpList;
            
        }

        public AttribValue GetDefaultCondition()
        {
            return new AttribValue(_compID, _displayName);
        }

        public AttribValue GetDefaultSelect()
        {
            return new AttribValue(_nameInDb + " as " + _displayName, _displayName);
        }

        public void AddGUI(HtmlTable ht, string businessUnitCode, bool theatricalTerr, int UserCode)
        {
            string innerHTMstr = "";
            switch (valuedAs)
            {
                case N_VALUE_1SELECT:
                    innerHTMstr = GetInnerHTMLforOneSelect(businessUnitCode, theatricalTerr, UserCode);
                    break;
                case MULTI_VALUED:
                    innerHTMstr = GetInnerHTMLforNSelect(businessUnitCode, theatricalTerr, UserCode);
                    break;
                case DATE_VALUED:
                    innerHTMstr = GetInnerHTMLforDate(false);
                    break;
                case BOOL_VALUED:
                    innerHTMstr = GetInnerHTMLforYesOrNo();
                    break;
                case NUM_VALUED:
                    innerHTMstr = GetInnerHTMLforNumbers();
                    break;
                case DATE_VALUED_OPTIONAL:
                    innerHTMstr = GetInnerHTMLforDate(true);
                    break;

                default:
                    innerHTMstr = GetInnerHTMLforText();
                    break;
            }

            HtmlTableRow tr = new HtmlTableRow();
            HtmlTableCell td = new HtmlTableCell();
            tr.ID = "divlist" + _compID;
            tr.Style.Add("display", "none");
            tr.Style.Add("margin-bottom", "15px");
            td.InnerHtml = innerHTMstr;
            tr.Cells.Add(td);
            ht.Rows.Add(tr);
        }
        private string GetInnerHTMLforYesOrNo()
        {
            StringBuilder sb = new StringBuilder();
            GetInnerHTMLCommon(sb);
            string[] valText = _lookupCol.Split('~');
            string[] textVal = _displayCol.Split('~');

            sb.Append(" 	    <td colspan='2' class='normal'>");
            sb.Append(" 		    <table width='100%' cellpadding='0' cellspacing='0' align=left border='0'>");
            sb.Append(" 			    <tr>");
            sb.Append("                     <td class='normal'><input name='YesNoOption" + _compID + "' type='radio' value ='" + valText[0] + "~" + textVal[0] + "' style='cursor:hand' checked='checked' onKeyPress='fnEnterKey(\"btn" + _nameInDb + "\");' />&nbsp;" + textVal[0] + "");
            sb.Append("						    <input type='radio' value =\"" + valText[1] + "~" + textVal[1] + "\" style='cursor:hand' name='YesNoOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;" + textVal[1] + "</td>");
            sb.Append(" 					<td class='normal'>&nbsp;</td>");
            sb.Append("						</tr>");
            sb.Append("					</table>");
            sb.Append("			   </td>");
            sb.Append("		  </tr>");
            sb.Append("		  <tr>");
            sb.Append("			 <td colspan='2'>");
            sb.Append("			  <div id='DivOrAnd" + _compID + "'>");
            sb.Append("				 AND &nbsp;<input  name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' checked = 'checked' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("				 OR &nbsp;<input type='radio' value ='2' style='cursor:hand' name='radioandor" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("			 </div> ");
            sb.Append("			 </td>");
            sb.Append("		 </tr>");
            sb.Append("		<tr>");
            sb.Append("			<td align='center' colspan='3'>");
            sb.Append("				<input type = 'button' id='btn" + _nameInDb + "' class='btn btn-primary' value='Add' onclick =\"javascript:return AddYesOrNoCondition('" + _nameInDb + "')\"/>");
            sb.Append("			  &nbsp;&nbsp;<input type='button' value ='Clear & remove' class='btn btn-primary' onclick =\"javascript:CancelClick(" + _compID + ")\" /></td>");
            sb.Append("		</tr>");
            sb.Append("	</table>");

            return sb.ToString();
        }

        private string GetInnerHTMLforOneSelect(string businessUnitCode, bool theatricalTerr, int UserCode)
        {
            GetDataFromBackend(businessUnitCode, theatricalTerr,UserCode);

            StringBuilder sb = new StringBuilder();
            GetInnerHTMLCommon(sb);

            sb.Append(" 	    <td colspan='2' class='normal'>");
            sb.Append(" 		    <table width='100%' cellpadding='0' cellspacing='0' align=left border='0'>");
            sb.Append(" 			    <tr>");
            sb.Append("                     <td class='normal' width='15%'><input name='TextOption" + _compID + "' type='radio' value ='1' style='cursor:hand' checked='checked' onKeyPress='fnEnterKey(\"btn" + _nameInDb + "\");' />&nbsp;Equal</td>");
            sb.Append("					    <td class='normal' rowspan='3' style='height:38px'><img alt='' class='imgBracket' src='../Images/curly_brace_right.png'/>" + GetHTMLofDDL(arrAvail) + "</td>");
            sb.Append("					</tr>");
            sb.Append("					<tr>");
            sb.Append("						<td class='normal'><input type='radio' value ='2' style='cursor:hand' name='TextOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Not Equal</td>");
            sb.Append("					</tr>");
            sb.Append("				</table>");
            sb.Append("		    </td>");
            sb.Append("		  </tr>");
            sb.Append("		  <tr>");
            sb.Append("			 <td colspan='2'>");
            sb.Append("			  <div id='DivOrAnd" + _compID + "'>");
            sb.Append("				 AND &nbsp;<input  name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' checked = 'checked' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("				 OR &nbsp;<input type='radio' value ='2' style='cursor:hand' name='radioandor" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("			 </div> ");
            sb.Append("			 </td>");
            sb.Append("		 </tr>");
            sb.Append("		<tr>");
            sb.Append("		   <td align='center' colspan='3'>");
            sb.Append("		   <input type = 'button' id='btn" + _nameInDb + "' class='btn btn-primary' value='Add' onclick =\"javascript:return AddDDLCondition('" + _nameInDb + "')\"/>");
            sb.Append("        &nbsp;&nbsp;<input type='button' value ='Clear & remove' class='btn btn-primary' onclick =\"javascript:CancelClick(" + _compID + ")\" /></td>");
            sb.Append("    </tr>");
            sb.Append("</table>");

            return sb.ToString();
        }

        private void GetDataFromBackend(string businessUnitCode, bool theatricalTerr,int UserCode)
        {
            string sql = "";
            string businessUnitFilter = "";

            //switch (_listSource.ToUpper())
            //{
            //    case "TITLE": businessUnitFilter = " INNER JOIN Acq_Deal_Movie ADM ON ADM.Title_Code = Title.Title_Code INNER JOIN Acq_Deal AD ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Is_Master_Deal ='Y' AND AD.Business_Unit_Code = " + businessUnitCode;
            //        break;
            //}

            if (_listSource.ToUpper() == "TITLE")
            {
                if (ViewName == "VW_ACQ_DEALS")
                    businessUnitFilter = " INNER JOIN Acq_Deal_Movie ADM ON ADM.Title_Code = Title.Title_Code INNER JOIN Acq_Deal AD ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code AND (AD.Is_Master_Deal ='Y' OR AD.Deal_Type_Code = (SELECT TOP 1 Parameter_Value FROM System_Parameter_New WHERE Parameter_Name IN ('Deal_Type_Music'))) AND AD.Business_Unit_Code = " + businessUnitCode;
                else if (ViewName == "VW_SYN_DEALS")
                    businessUnitFilter = " INNER JOIN Syn_Deal_Movie SDM ON SDM.Title_Code = Title.Title_Code INNER JOIN Syn_Deal SD ON SDM.Syn_Deal_Code = SD.Syn_Deal_Code AND SD.Business_Unit_Code = " + businessUnitCode;
            }

            sql = "SELECT DISTINCT " + _lookupCol + "," + _displayCol + " FROM " + _listSource + businessUnitFilter;
            sql += " WHERE 1 = 1";

         //   UtoSession objSession = (UtoSession)System.Web.HttpContext.Current.Session[UtoSession.SESS_KEY];
         //   Users objUser = (Users)objSession.Objuser;

            if (_listSource.ToUpper() == "ENTITY")
                sql += " AND Entity_Code IN (SELECT Entity_Code FROM Users_Entity WHERE Users_Code = " + UserCode + ") ";
            if (_listSource.ToUpper() == "BUSINESS_UNIT")
                sql += " AND Business_Unit_Code in (select Business_Unit_Code from Users_Business_Unit where Users_Code = " + UserCode + ")";

            if (_listSource.ToUpper() == "COUNTRY" && theatricalTerr)
            {
                string str = (theatricalTerr == true ? "Y" : "N");
                sql += " AND ISNULL(Is_Theatrical_Territory, 'N')='" + str + "'";
            }

            if (!string.IsNullOrEmpty(WhCondition))
                sql += " AND " + WhCondition;

            if (_displayCol == "platform_name")
                _displayCol = "Platform_Hiearachy";

            sql += " ORDER BY " + _displayCol;

            DataSet ds = DatabaseBroker.ProcessSelectDirectly(sql);
            DataTable dt = ds.Tables[0];
            arrAvail.Clear();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                string val = dt.Rows[i][0].ToString();
                string txt = dt.Rows[i][1].ToString();
                arrAvail.Add(new AttribValue(val, txt));
            }
        }

        private string GetInnerHTMLforDate(bool isOptionalEndDt)
        {
            ArrayList arrImageNm = new ArrayList();
            StringBuilder sb = new StringBuilder();
            GetInnerHTMLCommon(sb);

            bool isEQ = true, isGT = true, isLT = true, isBet = true;
            int opCnt = 4;
            //int ImgNmIndx = 0;

            if (this.ValidOpList != null && this.ValidOpList != "")
            {
                opCnt = 0;
                isEQ = ValidOpList.Contains("=");
                isGT = ValidOpList.Contains(">");
                isLT = ValidOpList.Contains("<");
                isBet = ValidOpList.Contains("B");

                if (isEQ)
                    opCnt++;

                if (isGT)
                    opCnt++;

                if (isLT)
                    opCnt++;

                if (isBet)
                    opCnt++;
            }

            //if (opCnt == 4)
            //{
            //    arrImageNm.Add("../Images/1bracket.gif");
            //    arrImageNm.Add("../Images/3bracket.gif");
            //    arrImageNm.Add("../Images/4bracket.gif");
            //    arrImageNm.Add("../Images/5bracket.gif");
            //}
            //else if (opCnt == 3)
            //{
            //    arrImageNm.Add("../Images/1bracket.gif");
            //    arrImageNm.Add("../Images/3bracket.gif");
            //    arrImageNm.Add("../Images/5bracket.gif");
            //}
            //else if (opCnt == 2 || opCnt == 1)
            //{
            //    arrImageNm.Add("../Images/1bracket.gif");
            //    arrImageNm.Add("../Images/5bracket.gif");
            //}

            sb.Append(" 	    <td colspan='2' class='normal'>");
            sb.Append(" 		    <table width='100%' cellpadding='0' cellspacing='0' align=left border='0'>");
            sb.Append(" 			    <tr id='trdate'>");
            sb.Append("                     <td class='normal' width='15%'><table width='130px' style='border-spacing: 0'><tr><td>");

            if (isEQ)
                sb.Append("                     <input name='DateOption" + _compID + "' type='radio' value='1' style='cursor:hand' checked='checked' onclick='javascript:return showOtherDate()' onKeyPress='fnEnterKey(\"btn" + _nameInDb + "\");' />&nbsp;Equal");

            sb.Append("                     </td>");
            sb.Append("						<td align='right' width='5%' style='padding:0'>");

            //if (isEQ && opCnt > 1)
              //sb.Append("                 <img alt='' src='" + arrImageNm[ImgNmIndx++] + "' border='0' />");

            if (isBet && opCnt == 1)
            {
                sb.Append("                         </td></tr></table></td>");
                sb.Append("							<td class='normal' rowspan='4' width='85%' style='height: 73px;'><img alt='' class='imgBracket' src='../Images/curly_brace_right.png'/><input type='text' ID='txtDate1Field" + _compID + "' Class='text' value='' Width='70px' maxlength='" + maxLen + "' onKeyPress='" + addedJavascript + "fnEnterKey(\"btn" + _nameInDb + "\");' readonly/>");
                sb.Append("                             <img src='../Images/show-calendar.gif' align='absmiddle' border='0' alt='' style='cursor: hand;' id='btnfromDate1' name='btnfromDate1' onclick=\"call_makecalendar(txtDate1Field" + _compID + ");\" unselectable='off'/>");
                sb.Append("							<div id='tdDate" + _compID + "'><input type='text' ID='txtDate2Field" + _compID + "' Class='text' value='' Width='70px' maxlength='" + maxLen + "' onKeyPress='" + addedJavascript + "fnEnterKey(\"btn" + _nameInDb + "\");' readonly/>");
                sb.Append("                             <img src='../Images/show-calendar.gif' align='absmiddle' border='0' alt='' style='cursor: hand;' id='btnfromDate2' name='btnfromDate2' onclick=\"call_makecalendar(txtDate2Field" + _compID + ");\" unselectable='off' />");
                sb.Append("						</div></td></tr>");
            }
            else
            {
                sb.Append("                         </td></tr></table></td> ");
                sb.Append("							<td class='normal' rowspan='4' width='85%' style='height: 73px;'><img alt='' class='imgBracket' src='../Images/curly_brace_right.png'/><input type='text' ID='txtDate1Field" + _compID + "' Class='text dateRange' value='' Width='70px' maxlength='" + maxLen + "' onKeyPress='" + addedJavascript + "fnEnterKey(\"btn" + _nameInDb + "\");' readonly/>");
                sb.Append("							<div id='tdDate" + _compID + "' style='display:none'><input type='text' ID='txtDate2Field" + _compID + "' Class='text dateRange' value='' Width='70px' maxlength='" + maxLen + "' onKeyPress='" + addedJavascript + "fnEnterKey(\"btn" + _nameInDb + "\");' readonly/>");
                sb.Append("						</div></td></tr>");
            }

            if (isGT)
            {
                sb.Append("						<tr>");
                sb.Append("							<td class='normal'><table width='130px' style='border-spacing: 0'><tr><td> ");
                sb.Append("                             <input type='radio' checked='checked' value='2' style='cursor:hand' name='DateOption" + _compID + "' onclick ='javascript:return showOtherDate()' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Greater Than");
              //sb.Append("							</td><td align='right' width='5%' style='padding:0'><img alt='' src='" + arrImageNm[ImgNmIndx++] + "' border='0' /></td> ");
                sb.Append("							</td>");
                sb.Append("                         </tr></table></td>");
                sb.Append("						</tr>");
            }

            if (isLT)
            {
                sb.Append("						<tr>");
                sb.Append("							<td class='normal'><table width='130px' style='border-spacing: 0'><tr><td>");
                sb.Append("                             <input type='radio' value ='3' checked='checked' style='cursor:hand' name='DateOption" + _compID + "' onclick='javascript:return showOtherDate()' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Less Than");
              //sb.Append("							</td><td align='right' width='5%' style='padding:0'><img alt='' src='" + arrImageNm[ImgNmIndx++] + "' border='0' /></td> </tr></table></td>");
                sb.Append("							</td></tr></table></td>");
                sb.Append("						</tr>");
            }

            if (isBet)
            {
                sb.Append("						<tr>");
                sb.Append("							<td class='normal'><table width='130px' style='border-spacing: 0'><tr><td>");
                sb.Append("                         <input type='radio' value ='4' checked='checked' style='cursor:hand' name='DateOption" + _compID + "' onclick='javascript:return showOtherDate()' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Between");
              //sb.Append("							</td><td align='right' width='5%' style='padding:0'><img alt='' src='" + arrImageNm[ImgNmIndx++] + "' border='0' /></td></tr></table></td>");
                sb.Append("							</td></tr></table></td>");
                sb.Append("						</tr>");
            }

            sb.Append("					</table>");
            sb.Append("			   </td>");
            sb.Append("		  </tr>");
            sb.Append("		  <tr>");
            sb.Append("			 <td colspan='2'>");
            sb.Append("			  <div id='DivOrAnd" + _compID + "'>");
            sb.Append("				 AND &nbsp;<input name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' checked='checked' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("				 OR &nbsp;<input type='radio' value ='2' style='cursor:hand' name='radioandor" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("			 </div> ");
            sb.Append("			 </td>");
            sb.Append("		 </tr>");
            sb.Append("		<tr>");
            sb.Append("			<td align='center' colspan='3'>");
            sb.Append("				<input type='button' id='btn" + _nameInDb + "' class='btn btn-primary' value='Add' onclick=\"addDateCondition" +
                (isOptionalEndDt ? "OptEndDt" : "") + "('" + _nameInDb + "')\"/>");
            sb.Append("			  &nbsp;&nbsp;<input type='button' value='Clear & remove' class='btn btn-primary' onclick=\"javascript:CancelClick(" + _compID + ")\" /></td>");
            sb.Append("		</tr>");
            sb.Append("	</table>");

            return sb.ToString();
        }

        public string GetWidIDForFocus()
        {
            switch (_valuedAs)
            {
                case N_VALUE_1SELECT:
                    return "ddlField" + _compID.ToString();
                case MULTI_VALUED:
                    return "LstValueList" + _compID.ToString();
                case DATE_VALUED:
                    return "img" + _compID.ToString();
                case BOOL_VALUED:
                    return "rdo" + _nameInDb + _compID.ToString();
                default:
                    return "txtTextField" + _compID.ToString();
            }
        }

        protected string GetHTMLofDDL(List<AttribValue> arrAttribVal)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<select class='select chosen-select' id='ddlValueList" + this._compID + "'> ");
            AttribValue av;
            string sel = "";

            for (int i = 0; i < arrAttribVal.Count; i++)
            {
                av = (AttribValue)arrAttribVal[i];
                sel = "";

                if (this.dbValue == av.Attrib.ToString())
                    sel = "Selected";

                sb.Append("<option " + sel + " value='" + av.Attrib.ToString() + "'>" + av.Val.ToString() + "</option> ");
            }

            sb.Append("</select>");
            return sb.ToString();
        }

        protected string GetHTMLofListbox(List<AttribValue> arrAttribVal, int h, int w, bool isAvailSide)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<select multiple='multiple' style='height:" + h.ToString() + "px;width:" + w.ToString() + "px' id='");

            if (isAvailSide)
                sb.Append("LstValueList" + _compID + "' ondblclick=\"javascript:move(document.getElementById('LstValueList" + _compID + "'),document.getElementById('LstSelectedList" + _compID + "'))\"> ");
            else
                sb.Append("LstSelectedList" + _compID + "' ondblclick=\"javascript:move(document.getElementById('LstSelectedList" + _compID + "'),document.getElementById('LstValueList" + _compID + "'))\"> ");

            if (arrAttribVal != null)
            {
                AttribValue av;
                for (int i = 0; i < arrAttribVal.Count; i++)
                {
                    av = (AttribValue)arrAttribVal[i];
                    sb.Append("<option value='" + av.Attrib.ToString() + "'>" + av.Val.ToString() + "</option> ");
                }
            }

            sb.Append("</select>");

            //Added by Reshma, to include ListSearchExtender (search) for ListBox
            if (isAvailSide)
                sb.Append("<input type='hidden' name='ListSearchExtender" + _compID + "_ClientState' id='ListSearchExtender" + _compID + "_ClientState' />  "
                    + " <script type='text/javascript'>Sys.Application.initialize();Sys.Application.add_init(function() { "
                    + " $create(AjaxControlToolkit.ListSearchBehavior, {'ClientStateFieldID':'ListSearchExtender" + _compID + "_ClientState','id':'ListSearchExtender"
                    + _compID + "','promptCssClass':'ListSearchExtenderPrompt'}, null, null, $get('LstValueList" + _compID + "'));});</script>");
            else
                sb.Append("<input type='hidden' name='ListSearchExtenderRight" + _compID + "_ClientState' id='ListSearchExtenderRight" + _compID + "_ClientState' />  "
                    + " <script type='text/javascript'>Sys.Application.initialize();Sys.Application.add_init(function() { "
                    + " $create(AjaxControlToolkit.ListSearchBehavior, {'ClientStateFieldID':'ListSearchExtenderRight" + _compID
                    + "_ClientState','id':'ListSearchExtenderRight" + _compID + "','promptCssClass':'ListSearchExtenderPrompt'}, null, null, $get('LstSelectedList"
                    + _compID + "'));});</script>");

            return sb.ToString();
        }

        protected string GetHTMLofListbox(List<AttribValue> arrAttribVal)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<select class='select Chosenlb100' style='width:100%' multiple='multiple' id='ddlValueList" + this._compID + "'> ");
            AttribValue av;
            string sel = "";

            for (int i = 0; i < arrAttribVal.Count; i++)
            {
                av = (AttribValue)arrAttribVal[i];
                sel = "";

                if (this.dbValue == av.Attrib.ToString())
                    sel = "Selected";

                sb.Append("<option " + sel + " value='" + av.Attrib.ToString() + "'>" + av.Val.ToString() + "</option> ");
            }

            sb.Append("</select>");
            return sb.ToString();
        }

        protected void GetInnerHTMLCommon(StringBuilder sb)
        {
            sb.Append(" <table  width ='100%' cellpadding='5' cellspacing='0' align=center border='0'>");
            sb.Append("    <tr>");
            sb.Append(" 	   <td  class='normal' colspan='2'><b>" + _displayName + "</b></td>");
            sb.Append("    </tr>");
            sb.Append("    <tr>");
        }
        protected string GetInnerHTMLforNSelect(string businessUnitCode, bool theatricalTerr, int UserCode)
        {
            GetDataFromBackend(businessUnitCode, theatricalTerr,UserCode);

            StringBuilder sb = new StringBuilder();
            GetInnerHTMLCommon(sb);

            sb.Append(" 		<td width='10%'>Condition</td> ");
            sb.Append(" 		<td class='normal'>");
            sb.Append(" 		   in  <input  name='RadioInNotin" + _compID + "' type='radio' value ='1' style='cursor:hand;' checked = 'checked' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append(" 		   not in <input type='radio' value ='2' style='cursor:hand;' name='RadioInNotin" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append(" 		</td> ");
            sb.Append(" 	</tr>");
            sb.Append(" 	<tr>");
            sb.Append(" 		<td colspan='2'>");

            //sb.Append(" 			<table cellpadding='5' cellspacing='0' border='0'>");
            //sb.Append(" 				<tr>");
            //sb.Append(" 					<td align='right'>" + GetHTMLofListbox(arrAvail, 150, 350, true) + "</td>");  //to do use dbValue
            //sb.Append(" 					<td align='center'>");
            //sb.Append(" 					    <input type='button' onclick=\"moveAll(document.getElementById('LstValueList" + _compID + "'),document.getElementById('LstSelectedList" + _compID + "'))\" class='button' value='>>' style='cursor:hand;'><br><br>");
            //sb.Append(" 						<input type='button' onClick=\"move(document.getElementById('LstValueList" + _compID + "'),document.getElementById('LstSelectedList" + _compID + "'))\" class='button' value='>' style='cursor:hand;'><br><br>");
            //sb.Append(" 						<input type='button' onClick=\"move(document.getElementById('LstSelectedList" + _compID + "'),document.getElementById('LstValueList" + _compID + "'))\" class='button' value='<' style='cursor:hand;'><br><br>");
            //sb.Append(" 					    <input type='button' onclick=\"moveAll(document.getElementById('LstSelectedList" + _compID + "'),document.getElementById('LstValueList" + _compID + "'))\" class='button' value='<<' style='cursor:hand;'>");
            //sb.Append(" 					</td>");
            //sb.Append(" 					<td align='left'>" + GetHTMLofListbox(null, 150, 350, false) + "</td>"); //to do use dbValue
            //sb.Append(" 				</tr>");
            //sb.Append(" 			</table>");

            sb.Append(GetHTMLofListbox(arrAvail));

            sb.Append(" 		</td>");
            sb.Append(" 	</tr>");
            sb.Append(" 	  <tr>");
            sb.Append(" 		 <td colspan='2' class='normal'>");

            if (_nameInDb == "S_Lang" || _nameInDb == "D_Lang" || _nameInDb == "COU.Country_Code" || _nameInDb == "ChannelNames")
            {
                sb.Append(" 		  <div id='DivOrAnd" + _compID + "'>");
                sb.Append(" 			 <span class='normal'>AND &nbsp;<input  name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" checked = 'checked' />");
                sb.Append(" 		  </div> ");
            }
            else
            {
                sb.Append(" 		  <div id='DivOrAnd" + _compID + "'>");
                sb.Append(" 			 <span class='normal'>AND &nbsp;<input  name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" checked = 'checked' />");
                sb.Append(" 			 OR </span>&nbsp;<input type='radio' value ='2' style='cursor:hand' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" name='radioandor" + _compID + "' />");
                sb.Append(" 		  </div> ");
            }

            sb.Append(" 		 </td>");
            sb.Append(" 	 </tr>");
            sb.Append(" 	<tr >");
            sb.Append(" 		<td align='center' colspan='2'>");
            sb.Append(" 			<input type = 'button' value='Add' id='btn" + _nameInDb + "' class='btn btn-primary' onclick =\"javascript:return AddCondition('" + _nameInDb + "')\"/>");
            sb.Append(" 			&nbsp;&nbsp;<input type='button' value ='Clear & remove' class='btn btn-primary' onclick ='javascript:CancelClick(" + _compID + ")' />");
            sb.Append(" 		</td>");
            sb.Append(" 	</tr>");
            sb.Append(" </table>");
            return sb.ToString();
        }
        protected string GetInnerHTMLforText()
        {
            StringBuilder sb = new StringBuilder();
            GetInnerHTMLCommon(sb);

            sb.Append(" 	    <td colspan='2' class='normal'>");
            sb.Append(" 		    <table width='100%' cellpadding='0' cellspacing='0' align=left border='0'>");
            sb.Append(" 			    <tr>");
            sb.Append("                     <td class='normal' width='15%'><input name='TextOption" + _compID + "' type='radio' value ='1' style='cursor:hand' checked='checked' onKeyPress='fnEnterKey(\"btn" + _nameInDb + "\");' />&nbsp;Equal</td>");
            sb.Append("						<td width='3%' rowspan='3' style='height: 54px;'><img alt='' class='imgBracket' src='../Images/curly_brace_right.png'/></td> ");
            sb.Append("						<td class='normal' rowspan='3'><input type='text' ID='txtTextField" + _compID + "' Class='text' value='' Width='70px' maxlength='" + maxLen + "' onKeyPress='" + addedJavascript + "fnEnterKey(\"btn" + _nameInDb + "\");'/></td>");
            sb.Append("					</tr>");
            sb.Append("					<tr>");
            sb.Append("						<td class='normal'><input type='radio' value ='2' style='cursor:hand' name='TextOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Start With</td>");
            sb.Append("					</tr>");
            sb.Append("					<tr>");
            sb.Append("						<td class='normal' style='height: 22px'><input type='radio' value ='3' style='cursor:hand' name='TextOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Contains</td>");
            sb.Append("					</tr>");
            sb.Append("				</table>");
            sb.Append("			 </td>");
            sb.Append("		  </tr>");
            sb.Append("		  <tr>");
            sb.Append("			 <td colspan='2'>");
            sb.Append("			  <div id='DivOrAnd" + _compID + "'>");
            sb.Append("				 AND &nbsp;<input  name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' checked = 'checked' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("				 OR &nbsp;<input type='radio' value ='2' style='cursor:hand' name='radioandor" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("			 </div> ");
            sb.Append("			 </td>");
            sb.Append("		 </tr>");
            sb.Append("		<tr>");
            sb.Append("			<td align='center' colspan='3'>");
            sb.Append("				<input type = 'button' id='btn" + _nameInDb + "' class='btn btn-primary' value='Add' onclick =\"javascript:return AddTextCondition('" + _nameInDb
                + "','" + (_valuedAs == STR_VALUED ? "Text" : "Number") + "')\"/>");
            sb.Append("			  &nbsp;&nbsp;<input type='button' value ='Clear & remove' class='btn btn-primary' onclick =\"javascript:CancelClick(" + _compID + ")\" /></td>");
            sb.Append("		</tr>");
            sb.Append("	</table>");

            return sb.ToString();
        }
        protected string GetInnerHTMLforText(int MaxLen)
        {
            StringBuilder sb = new StringBuilder();
            GetInnerHTMLCommon(sb);

            sb.Append(" 	    <td colspan='2' class='normal'>");
            sb.Append(" 		    <table width='100%' cellpadding='0' cellspacing='0' align=left border='0'>");
            sb.Append(" 			    <tr>");
            sb.Append("                     <td class='normal' width='15%'><input name='TextOption" + _compID + "' type='radio' value ='1' style='cursor:hand' checked='checked' onKeyPress='fnEnterKey(\"btn" + _nameInDb + "\");' />&nbsp;Equal</td>");
            sb.Append(" 					<td rowspan='3' width='3%'>&nbsp;</td>");
            sb.Append("							<td width='3%' rowspan='3' style='height: 54px;'><img alt='' class='imgBracket' src='../Images/curly_brace_right.png'/></td>");
            sb.Append("							<td class='normal' rowspan='3'><input type='text' ID='txtTextField" + _compID + "' Class='text' value='' Width='70px' maxlength='" + MaxLen + "' onKeyPress='" + addedJavascript + "fnEnterKey(\"btn" + _nameInDb + "\");'/></td>");
            sb.Append("						</tr>");
            sb.Append("						<tr>");
            sb.Append("							<td class='normal'><input type='radio' value ='2' style='cursor:hand' name='TextOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Start With</td>");
            sb.Append("						</tr>");
            sb.Append("						<tr>");
            sb.Append("							<td class='normal' style='height: 22px'><input type='radio' value ='3' style='cursor:hand' name='TextOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Contains</td>");
            sb.Append("						</tr>");
            sb.Append("					</table>");
            sb.Append("			   </td>");
            sb.Append("		  </tr>");
            sb.Append("		  <tr>");
            sb.Append("			 <td colspan='2'>");
            sb.Append("			  <div id='DivOrAnd" + _compID + "'>");
            sb.Append("				 AND &nbsp;<input  name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' checked = 'checked' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("				 OR &nbsp;<input type='radio' value ='2' style='cursor:hand' name='radioandor" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("			 </div> ");
            sb.Append("			 </td>");
            sb.Append("		 </tr>");
            sb.Append("		<tr>");
            sb.Append("			<td align='center' colspan='3'>");
            sb.Append("				<input type = 'button' id='btn" + _nameInDb + "' class='btn btn-primary' value='Add' onclick =\"javascript:return AddTextCondition('" + _nameInDb
                + "','" + (_valuedAs == STR_VALUED ? "Text" : "Number") + "')\"/>");
            sb.Append("			  &nbsp;&nbsp;<input type='button' value ='Clear & remove' class='btn btn-primary' onclick =\"javascript:CancelClick(" + _compID + ")\" /></td>");
            sb.Append("		</tr>");
            sb.Append("	</table>");

            return sb.ToString();
        }
        protected string GetInnerHTMLforNumbers()
        {
            StringBuilder sb = new StringBuilder();
            GetInnerHTMLCommon(sb);

            sb.Append(" 	    <td colspan='2' class='normal'>");
            sb.Append(" 		    <table width='100%' cellpadding='0' cellspacing='0' align=left border='0'>");
            sb.Append(" 			    <tr>");
            sb.Append("                     <td class='normal' width='15%'><input name='TextOption" + _compID + "' type='radio' value ='1' style='cursor:hand' checked='checked' onKeyPress='fnEnterKey(\"btn" + _nameInDb + "\");' />&nbsp;Equal</td>");
            sb.Append(" 					<td rowspan='3' width='3%'>&nbsp;</td>");
            sb.Append("							<td width='3%' rowspan='3' style='height: 54px;'><img alt='' class='imgBracket' src='../Images/curly_brace_right.png'/></td> ");
            sb.Append("							<td class='normal' rowspan='3'><input type='text' ID='txtTextField" + _compID + "' Class='text' value='' Width='70px' maxlength='" + maxLen + "' onKeyPress='" + addedJavascript + "fnEnterKey(\"btn" + _nameInDb + "\");'/></td>");
            sb.Append("						</tr>");
            sb.Append("						<tr>");
            sb.Append("							<td class='normal'><input type='radio' value ='2' style='cursor:hand' name='TextOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Greater than</td>");
            sb.Append("						</tr>");
            sb.Append("						<tr>");
            sb.Append("							<td class='normal' style='height: 22px'><input type='radio' value ='3' style='cursor:hand' name='TextOption" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />&nbsp;Less Than</td>");
            sb.Append("						</tr>");
            sb.Append("					</table>");
            sb.Append("			   </td>");
            sb.Append("		  </tr>");
            sb.Append("		  <tr>");
            sb.Append("			 <td colspan='2'>");
            sb.Append("			  <div id='DivOrAnd" + _compID + "'>");
            sb.Append("				 AND &nbsp;<input  name='radioandor" + _compID + "' type='radio' value ='1' style='cursor:hand' checked = 'checked' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("				 OR &nbsp;<input type='radio' value ='2' style='cursor:hand' name='radioandor" + _compID + "' onKeyPress=\"fnEnterKey('btn" + _nameInDb + "');\" />");
            sb.Append("			 </div> ");
            sb.Append("			 </td>");
            sb.Append("		 </tr>");
            sb.Append("		<tr>");
            sb.Append("			<td align='center' colspan='3'>");
            sb.Append("				<input type = 'button' id='btn" + _nameInDb + "' class='btn btn-primary' value='Add' onclick =\"javascript:return AddTextCondition('" + _nameInDb
                + "','" + (_valuedAs == NUM_VALUED ? "Number" : "Text") + "')\"/>");
            sb.Append("			  &nbsp;&nbsp;<input type='button' value ='Clear & remove' class='btn btn-primary' onclick =\"javascript:CancelClick(" + _compID + ")\" /></td>");
            sb.Append("		</tr>");
            sb.Append("	</table>");

            return sb.ToString();
        }

        public void Setup(bool pIsSelect, int pDisplayOrd, string pSortType, int pSortOrd, string pAggFunction, bool isEdit, int code)
        {
            this.IsSelect = pIsSelect;
            this.DisplayOrd = pDisplayOrd;
            this.SortType = pSortType;
            this.SortOrd = pSortOrd;
            this.AggFunction = pAggFunction;
            this.IsDirty = isEdit;
            this.IntCode = code;
            this.SelectOrder = pDisplayOrd;
        }

        public string GetUserTextForOp(string theOp, string rightVal)
        {
            string userTxt = this.DisplayName;

            switch (valuedAs)
            {
                case N_VALUE_1SELECT:
                    userTxt += " " + theOp + getDBDesc(rightVal);
                    break;

                case MULTI_VALUED:
                    userTxt += " " + theOp + " (" + getDBDesc(rightVal) + ")";
                    break;

                case DATE_VALUED:
                    if (theOp.Trim() == ReportCondition.OP_COMPARE)
                        userTxt += " " + theOp + rightVal;
                    else
                        userTxt += GetUserTextForTexttype(theOp.Trim(), rightVal);
                    break;

                case BOOL_VALUED:
                    string[] strbool = _lookupCol.Split('~');
                    string[] strtxt = _displayCol.Split('~');
                    string str = rightVal.Trim().Replace("'", "") == strbool[0].Trim() ? strtxt[0] : strtxt[1];
                    userTxt = userTxt + " " + theOp + str;
                    break;

                default:
                    if (theOp.Trim() == ReportCondition.OP_COMPARE)
                        userTxt += " " + theOp + rightVal;
                    else
                        userTxt += GetUserTextForTexttype(theOp.Trim(), rightVal);
                    break;
            }

            return userTxt;
        }

        private string getDBDesc(string rightVal)
        {
            bool flag = rightVal.Contains(",");
            string sql = "";
            string returnedvalue = "";

            if (flag)
                sql = "select " + _displayCol + " from " + _listSource + " where " + _lookupCol + " in (" + rightVal + ")";
            else
                sql = "select " + _displayCol + " from " + _listSource + " where " + _lookupCol + " = " + rightVal;

            if (!string.IsNullOrEmpty(_whCondition))
                sql += " AND " + _whCondition;

            DataSet ds = DatabaseBroker.ProcessSelectDirectly(sql);
            DataTable dt = ds.Tables[0];

            string[] arr_displayCol = _displayCol.Split('.');
            string columnName = arr_displayCol[arr_displayCol.Length - 1];

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                returnedvalue += dt.Rows[i][columnName] + ",";
            }

            return returnedvalue.Substring(0, returnedvalue.Length - 1);
        }

        private string GetUserTextForTexttype(string theOp, string rightVal)
        {
            if (this.valuedAs == ReportColumn.STR_VALUED)
            {
                if (rightVal.StartsWith("'%"))
                    if (rightVal.EndsWith("%'"))
                        return " contains word " + rightVal.Replace("'%", "'").Replace("%'", "'");
                    else
                        return " ends with " + rightVal.Replace("'%", "'");
                else
                    if (rightVal.EndsWith("%'"))
                        return " starts with " + rightVal.Replace("%'", "'");
                    else
                        return " like " + rightVal;
            }
            else
            {
                if (theOp == ReportCondition.OP_LT)
                    return " less than " + rightVal;
                else if (theOp == ReportCondition.OP_GT)
                    return " greater than " + rightVal;
                else
                    return " " + theOp + " " + rightVal;
            }
        }

        public override DatabaseBroker GetBroker()
        {
            return new ReportColumnBroker();
        }

        public override void UnloadObjects()
        {
            throw new Exception("The method or operation is not implemented.");
        }

    }
}