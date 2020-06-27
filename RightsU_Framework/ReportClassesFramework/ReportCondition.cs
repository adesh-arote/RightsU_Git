using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

/// <summary>
/// Summary description for ReportCondition
/// </summary>
namespace UTOFrameWork.FrameworkClasses
{
    public class ReportCondition : Persistent
    {
        private ReportColumn _leftCol;
        public ReportColumn LeftCol
        {
            get { return _leftCol; }
            set
            {
                if (value == null)
                    throw new Exception("Cannot null column of Condition");
                _leftCol = value;
            }
        }

        public string LeftColDbname
        {
            get { return _leftCol.NameInDb; }
        }
        public int queryCode
        {
            get { return LeftCol.queryCode; }
        }

        //private int _condType;
        //public int CondType {
        //    get { return _condType; }
        //    set {
        //        if (value != OP_IN && value != OP_NOT_IN && value != COMPARE)
        //            throw new Exception("Condtion type not supported:" + value);
        //        _condType = value; }
        //}

        private string _rightValue;
        public string RightValue
        {
            get { return _rightValue; }
            set { _rightValue = value; }
        }

        private string _theOp;
        public string theOp
        {
            get { return _theOp; }
            set { _theOp = value; }
        }

        private string _logicalConnect;  //and / Or
        public string logicalConnect
        {
            get { return _logicalConnect; }
            set { _logicalConnect = value; }
        }

        //public const int OP_IN = 1;
        //public const int OP_NOT_IN = 2;
        public const string OP_COMPARE = "=";
        public const string OP_LIKE = "like";
        public const string OP_LT = "<";
        public const string OP_GT = ">";
        public const string OP_BW = "Between";
        public const string OP_NE = "<>";

        private ReportCondition()
        {
        }

        public ReportCondition(ReportColumn rc)
            : base()
        {
            _leftCol = rc;
        }

        public AttribValue GetCondition()
        {
            AttribValue retAv = new AttribValue("", "");
            return retAv;
        }

        public void Setup(string op, string rightVal, string AndOrConnect)
        {
            theOp = op;
            RightValue = rightVal;
            logicalConnect = AndOrConnect;
        }
        public void FormWhSQLPredefined(StringBuilder sb)
        {
            if (theOp.Trim().ToUpper() == "BETWEEN")
                FormWhSQLPredefinedTwoVal(sb);
            else
                FormWhSQLPredefinedSingleVal(sb);
        }
        public void FormWhSQLPredefined(StringBuilder sb, out string availableDates)
        {
            string availableDatesLocal = String.Empty;

            if (theOp.Trim().ToUpper() == "BETWEEN")
            {
                FormWhSQLPredefinedTwoVal(sb, out availableDates);
                availableDatesLocal = availableDates;
            }
            else
                FormWhSQLPredefinedSingleVal(sb);


            availableDates = availableDatesLocal;
        }

        public void FormWhSQLPredefinedTwoVal(StringBuilder sb)
        {
            string newWh = _leftCol.WhCondition;
            string[] arrValues = RightValue.Trim().Split(' ');
            string val1 = arrValues[0], val2 = arrValues[2];

            if (_leftCol.valuedAs == ReportColumn.DATE_VALUED)
            {
                val1 = GlobalUtil.MakedateFormat(arrValues[0]);
                val2 = GlobalUtil.MakedateFormat(arrValues[2]);
            }

            newWh = newWh.Replace("{VAL1}", val1).Replace("{VAL2}", val2);
            sb.Append(" " + logicalConnect + " " + newWh);
        }
        public void FormWhSQLPredefinedTwoVal(StringBuilder sb, out string availableDates)
        {
            string newWh = _leftCol.WhCondition;
            string[] arrValues = RightValue.Trim().Split(' ');
            string val1 = "", val2 = "";

            if (this.LeftCol.valuedAs == ReportColumn.DATE_VALUED_OPTIONAL && arrValues.Length < 3)
                val1 = arrValues[0];
            else
            {
                val1 = arrValues[0];
                val2 = arrValues[2];
            }

            if (_leftCol.valuedAs == ReportColumn.DATE_VALUED || _leftCol.valuedAs == ReportColumn.DATE_VALUED_OPTIONAL)
            {
                val1 = GlobalUtil.MakedateFormat(arrValues[0]);

                if (val2 != "")
                    val2 = GlobalUtil.MakedateFormat(arrValues[2]);
            }

            availableDates = val1 + "#" + val2;
            newWh = newWh.Replace("{VAL1}", val1).Replace("{VAL2}", val2);
            sb.Append(" " + logicalConnect + " " + newWh);
        }

        public void FormWhSQLPredefinedSingleVal(StringBuilder sb)
        {
            string newWh = _leftCol.WhCondition;

            if (_leftCol.valuedAs == ReportColumn.BOOL_VALUED)
            {
                if (newWh.IndexOf("~") >= 0)
                {
                    string[] arrBoolCond = newWh.Split(new char[] { '~' });

                    if (RightValue == "'0'")  //the '' were added so that values can be simply replaced into
                        newWh = arrBoolCond[0];
                    else
                        newWh = arrBoolCond[1];
                }
            }

            newWh = newWh.Replace("{OP}", theOp).Replace("{VAL}", RightValue);
            sb.Append(" " + logicalConnect + " " + newWh);
        }

        public void FormWhSQL(StringBuilder sb)
        {
            if (_leftCol.WhCondition != null && _leftCol.WhCondition != ""
                && (_leftCol.WhCondition.IndexOf("{VAL}") >= 0 || _leftCol.WhCondition.IndexOf("{VAL1}") >= 0))
            {
                FormWhSQLPredefined(sb);
                return;
            }

            if (theOp.Trim().ToUpper() == "IN")
            {
                if (_leftCol.NameInDb.ToUpper() == "DIRECTOR_CODE")
                {
                    sb.Append(" " + logicalConnect + " tit.Title_Code In (Select Title_Code From Title_Talent Where Talent_Code " + theOp + " (" + RightValue + ") and Role_Code = 1)");
                }
                else if (_leftCol.NameInDb.ToUpper() == "STARCAST_CODE")
                {
                    sb.Append(" " + logicalConnect + " tit.Title_Code In (Select Title_Code From Title_Talent Where Talent_Code " + theOp + " (" + RightValue + ") and Role_Code = 2)");
                }
                else if (_leftCol.NameInDb.ToUpper() == "GENRES_CODE")
                {
                    sb.Append(" " + logicalConnect + " tit.Title_Code In (Select Title_Code From Title_Geners Where Genres_Code " + theOp + " (" + RightValue + "))");
                }
                else if (_leftCol.NameInDb.ToUpper() == "TIT.YEAR_OF_PRODUCTION")
                {
                    sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " (" + DateTime.Parse(RightValue).Year + ")");
                }
                else
                    sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " (" + RightValue + ")");
            }
            else if (theOp.Trim().ToUpper() == "NOT IN" || theOp.Trim() == "<>")
            {

                if (_leftCol.NameInDb.ToUpper() == "DIRECTOR_CODE")
                {
                    sb.Append(" " + logicalConnect + " tit.Title_Code In (Select Title_Code From Title_Talent Where Talent_Code " + theOp + " (" + RightValue + ") and Role_Code = 1)");
                }
                else if (_leftCol.NameInDb.ToUpper() == "STARCAST_CODE")
                {
                    sb.Append(" " + logicalConnect + " tit.Title_Code In (Select Title_Code From Title_Talent Where Talent_Code " + theOp + " (" + RightValue + ") and Role_Code = 2)");
                }
                else if (_leftCol.NameInDb.ToUpper() == "GENRES_CODE")
                {
                    sb.Append(" " + logicalConnect + " tit.Title_Code In (Select Title_Code From Title_Geners Where Genres_Code " + theOp + " (" + RightValue + "))");
                }
                else if (_leftCol.NameInDb.ToUpper() == "TIT.YEAR_OF_PRODUCTION")
                {
                    sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " (" + DateTime.Parse(RightValue).Year + ") or " + _leftCol.NameInDb + " Is Null ) ");
                }
                else if (_leftCol.NameInDb.ToUpper() == "P.PLATFORM_CODE")
                {
                    if (_leftCol.ViewName != null && _leftCol.ViewName.Trim().ToUpper() == "VW_SYN_DEALS")
                    {
                        sb.Append(" " + logicalConnect + " SDM.Title_Code" + " " + theOp
                              + "("
                              + "SELECT ISADRT.Title_Code FROM Syn_Deal_Rights_Title ISADRT WHERE ISADRT.Syn_Deal_Rights_Code IN"
                              + "("
                                        + " SELECT ISDRP.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Platform ISDRP WHERE ISDRP.Platform_Code IN(" + RightValue + ")"
                              + ")"
                              + ")"
                              );
                    }
                    else
                    {
                        sb.Append(" " + logicalConnect + " ADM.Title_Code" + " " + theOp
                                 + "("
                                 + "SELECT IAADRT.Title_Code FROM Acq_Deal_Rights_Title IAADRT WHERE IAADRT.Acq_Deal_Rights_Code IN"
                                 + "("
                                           + " SELECT IADRP.Acq_Deal_Rights_Code FROM Acq_Deal_Rights_Platform IADRP WHERE IADRP.Platform_Code IN(" + RightValue + ")"
                                 + ")"
                                 + ")"
                                 );
                    }
                }
                else
                    sb.Append(" " + logicalConnect + " (" + _leftCol.NameInDb + " " + theOp + " (" + RightValue + ") or " + _leftCol.NameInDb + " Is Null ) ");
            }
            else
            {
                if (_leftCol.valuedAs == ReportColumn.DATE_VALUED) // 4)
                {
                    if (theOp.Trim().ToUpper() == "BETWEEN")
                    {
                        string[] dates = RightValue.Trim().Split(' ');

                        if (_leftCol.NameInDb.ToUpper() == "TIT.YEAR_OF_PRODUCTION")
                            sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " '" + DateTime.Parse(GlobalUtil.MakedateFormat(dates[0])).Year + "' " + dates[1] + " '" + DateTime.Parse(GlobalUtil.MakedateFormat(dates[2])).Year + "'");
                        else
                        {
                            string strdates = "'" + GlobalUtil.MakedateFormat(dates[0]) + "' " + dates[1] + " '" + GlobalUtil.MakedateFormat(dates[2]) + "'";
                            sb.Append(" " + logicalConnect + " Convert(datetime," + _leftCol.NameInDb + ",103) " + theOp + " " + strdates);
                        }
                    }
                    else
                    {
                        if (_leftCol.NameInDb.ToUpper() == "TIT.YEAR_OF_PRODUCTION")
                            sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " '" + DateTime.Parse(GlobalUtil.MakedateFormat(RightValue)).Year + "'");
                        else
                            sb.Append(" " + logicalConnect + " Convert(datetime," + _leftCol.NameInDb + ",103) " + theOp + " '" + GlobalUtil.MakedateFormat(RightValue) + "'");
                    }
                }
                else
                    sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " " + "N" + RightValue);
            }
        }
        public void FormWhSQL(StringBuilder sb, out string availableDates)
        {
            string availableDatesLocal = string.Empty;

            if (_leftCol.WhCondition != null && _leftCol.WhCondition != ""
                && (_leftCol.WhCondition.IndexOf("{VAL}") >= 0 || _leftCol.WhCondition.IndexOf("{VAL1}") >= 0))
            {
                FormWhSQLPredefined(sb, out availableDates);
                availableDatesLocal = availableDates;
                return;
            }

            if (theOp.Trim().ToUpper() == "IN")
            {
                sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " (" + RightValue + ")");
            }
            else if (theOp.Trim().ToUpper() == "NOT IN" || theOp.Trim() == "<>")
            {
                sb.Append(" " + logicalConnect + " (" + _leftCol.NameInDb + " " + theOp + " (" + RightValue + ") or " + _leftCol.NameInDb + " Is Null ) ");
            }
            else
            {
                if (_leftCol.valuedAs == ReportColumn.DATE_VALUED) // 4)
                {
                    if (theOp.Trim().ToUpper() == "BETWEEN")
                    {
                        string[] dates = RightValue.Trim().Split(' ');
                        string strdates = "'" + GlobalUtil.MakedateFormat(dates[0]) + "' " + dates[1] + " '" + GlobalUtil.MakedateFormat(dates[2]) + "'";

                        sb.Append(" " + logicalConnect + " Convert(datetime," + _leftCol.NameInDb + ",103) " + theOp + " " + strdates);
                    }
                    else
                        sb.Append(" " + logicalConnect + " Convert(datetime," + _leftCol.NameInDb + ",103) " + theOp + " '" + GlobalUtil.MakedateFormat(RightValue) + "'");
                }
                else
                    sb.Append(" " + logicalConnect + " " + _leftCol.NameInDb + " " + theOp + " " + RightValue);
            }

            availableDates = availableDatesLocal;
        }

        public void FillHidden(StringBuilder sbHidID, StringBuilder sbHidUserText, StringBuilder sbHidStringAllCond)
        {
            try
            {
                sbHidID.Append("~" + this.LeftCol.compID.ToString() + "$" + this.LeftCol.DisplayName);
                sbHidStringAllCond.Append("~" + this.LeftCol.NameInDb + "~" + this.theOp + "~" + this.RightValue + "~" + this.logicalConnect);

                if (theOp.Trim().ToUpper() == OP_BW.ToUpper() && RightValue.Trim().ToLower().EndsWith("and"))
                {
                    sbHidUserText.Append("~" + (this.logicalConnect.ToLower().Equals("or") ? " OR " : "")
                        + this.LeftCol.GetUserTextForOp(">=", RightValue.Replace("and", "")));
                }
                else
                {
                    sbHidUserText.Append("~" + (this.logicalConnect.ToLower().Equals("or") ? " OR " : "")
                                + this.LeftCol.GetUserTextForOp(theOp, RightValue));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public override DatabaseBroker GetBroker()
        {
            return new ReportConditionBroker();
        }

        public override void UnloadObjects()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public void DeleteABunchofRows()
        {
            ((ReportConditionBroker)(this.GetBroker())).DeleteABunchofRowsBroker(this);
        }

    }
}