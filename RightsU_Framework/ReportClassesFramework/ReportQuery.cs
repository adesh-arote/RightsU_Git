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
using System.Linq;

namespace UTOFrameWork.FrameworkClasses
{
    public class ReportQuery : Persistent
    {
        private ArrayList _arrColList = null;
        private ArrayList _arrCondList = null;

        private string _viewName = "";
        public string ViewName
        {
            get { return _viewName; }
            // set { _viewName = value; }
        }

        private int _sortOrd;
        public int SortOrd
        {
            get { return _sortOrd; }
            set { _sortOrd = value; }
        }

        private string _queryName;
        public string QueryName
        {
            get { return _queryName; }
            set { _queryName = value; }
        }

        private int _business_Unit_Code;
        public int Business_Unit_Code
        {
            get { return _business_Unit_Code; }
            set { _business_Unit_Code = value; }
        }

        private int _security_Group_Code;
        public int Security_Group_Code
        {
            get { return _security_Group_Code; }
            set { _security_Group_Code = value; }
        }

        private string _visibility;
        public string Visibility
        {
            get { return _visibility; }
            set { _visibility = value; }
        }

        private string _theatrical_Territory;
        public string Theatrical_Territory
        {
            get { return _theatrical_Territory; }
            set { _theatrical_Territory = value; }
        }

        private string _expired_Deals;
        public string Expired_Deals
        {
            get { return _expired_Deals; }
            set { _expired_Deals = value; }
        }

        private string _Subtitle_Lang = "";
        public string Subtitle_Lang
        {
            get { return _Subtitle_Lang; }
            set { _Subtitle_Lang = value; }
        }

        private string _Dubbing_Lang = "";
        public string Dubbing_Lang
        {
            get { return _Dubbing_Lang; }
            set { _Dubbing_Lang = value; }
        }

        private string _Country_Codes = "";
        public string Country_Codes
        {
            get { return _Country_Codes; }
            set { _Country_Codes = value; }
        }

        private string _Channel_Codes = "";
        public string Channel_Codes
        {
            get { return _Channel_Codes; }
            set { _Channel_Codes = value; }
        }

        private string _Cat_Codes = "";
        public string Cat_Codes
        {
            get { return _Cat_Codes; }
            set { _Cat_Codes = value; }
        }

        private string _CBFC_Ratings_Codes = "";
        public string CBFC_Ratings_Codes
        {
            get { return _CBFC_Ratings_Codes; }
            set { _CBFC_Ratings_Codes = value; }
        }

        private string _Alternate_Config_Code;
        public string Alternate_Config_Code
        {
            get { return _Alternate_Config_Code; }
            set { _Alternate_Config_Code = value; }
        }

        public List<ReportColumn> _arrRptColumn;
        private List<ReportCondition> arrRptCond;
        public List<ReportCondition> _arrRptCond
        {
            get
            {
                return arrRptCond;
            }
            set
            {
                arrRptCond = value;
            }
        }

        private ReportQuery()
        {
            OrderByColumnName = "query_name";
            OrderByCondition = "ASC";//"DESC";
        }

        public string availableDates { get; set; }

        public ReportQuery(string viewName)
            : this()
        {
            if (viewName == "")
                throw new Exception("Provide view name");

            _viewName = viewName;
            IsProxy = false;
            _arrRptColumn = new List<ReportColumn>();
            _arrRptCond = new List<ReportCondition>();
        }

        public string GetWidIDListForFocus()
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" <input name='theAutoIDFocusList' id='theAutoIDFocusList' type='hidden' value='");

            foreach (ReportColumn rc in _arrRptColumn)
            {
                sb.Append(rc.GetWidIDForFocus() + "~");
            }

            sb.Append("'> ");
            return sb.ToString();
        }

        public void Initialize(bool force)
        {
            if (force || _arrRptColumn == null || _arrRptColumn.Count < 1)
            {
                ReportColumnBroker rcb = new ReportColumnBroker();
                _arrRptColumn = rcb.GetDefaultColumnList(this);
            }
        }

        private void FillStaticLists()
        {
            Initialize(false);

            _arrCondList = new ArrayList();
            _arrColList = new ArrayList();

            _arrColList.Add(new AttribValue("0", "--Please select--"));
            _arrCondList.Add(new AttribValue("0", "--Please select--"));

            foreach (ReportColumn rc in _arrRptColumn)
            {
                if (rc.IsPartofSelectonly != "N")
                {
                    if (rc.Alternate_Config_Code == 0)
                    {
                        _arrColList.Add(rc.GetDefaultSelect());
                    }      
                }
                if (rc.isPartofWhere == false)
                {
                    if (rc.IsPartofSelectonly != "Y")
                        _arrCondList.Add(rc.GetDefaultCondition());
                }
            }
        }

        private void FillAlternateStaticLists(string myCheckBoxes)
        {
            Initialize(false);
            _arrColList = new ArrayList();
            _arrColList.Add(new AttribValue("0", "--Please select--"));

            string[] words = myCheckBoxes.Split(',');
            foreach (string word in words)
            {
                foreach (ReportColumn rc in _arrRptColumn)
                {
                    if (rc.IsPartofSelectonly != "N" || rc.Alternate_Config_Code == Convert.ToInt32(word))
                        _arrColList.Add(rc.GetDefaultSelect());

                }
            }
        }

        public ArrayList GetColNameList()
        {
            if (_arrColList == null)
                FillStaticLists();

            return _arrColList;
        }

        public ArrayList GetAlternateColNameList(string myCheckBoxes)
        {
            _arrColList = null;
            if (_arrColList == null)
                FillAlternateStaticLists(myCheckBoxes);

            return _arrColList;
        }

        public ArrayList GetConditionList()
        {
            if (_arrCondList == null)
                FillStaticLists();

            return _arrCondList;
        }

        public DataSet ProcessSelect()
        {
            bool First = true;
            bool orderFirst = true;
            int Count = 0;
            ReportColumn rc;
            StringBuilder sbSql = new StringBuilder();
            sbSql.Append(" SET DATEFORMAT DMY SELECT DISTINCT ");

            //to do Select order....

            List<ReportColumn> arrselcol = new List<ReportColumn>(_arrRptColumn);
            Comparison<ReportColumn> compSel = new Comparison<ReportColumn>(CompareSelectOrder);
            arrselcol.Sort(compSel);

            for (int i = arrselcol.Count - 1; i >= 0; i--)
            {
                rc = arrselcol[i];

                if (rc.IsSelect)
                {
                    if (!First)
                        sbSql.Append(", ");

                    Count++;

                    if (rc.valuedAs == 4)
                        sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                    else
                        sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");

                    First = false;
                }
            }

            if (Count == 0)
            {
                for (int i = 0; i < _arrRptColumn.Count; i++)
                {
                    rc = _arrRptColumn[i];

                    if (rc.IsPartofSelectonly != "N")
                    {
                        if (!First)
                            sbSql.Append(", ");

                        Count++;

                        if (rc.valuedAs == 4)
                            sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                        else
                            sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");

                        First = false;
                    }
                }
            }

            sbSql.Append(" FROM " + _viewName);
            sbSql.Append(" WHERE ");

            PopulateWhere(sbSql);

            //TO do order by
            List<ReportColumn> arrlist = new List<ReportColumn>(_arrRptColumn);
            //arrlist =_arrRptColumn;
            Comparison<ReportColumn> c = new Comparison<ReportColumn>(CompareWithOrder);
            arrlist.Sort(c);

            for (int i = 0; i < arrlist.Count; i++)
            {
                rc = arrlist[i];

                if (rc.IsSelect)
                {
                    if (rc.SortOrd > 0)
                    {
                        string strOrd = "";

                        switch (rc.SortType)
                        {
                            case "D":
                                strOrd = "DESC";
                                break;

                            case "A":
                                strOrd = "ASC";
                                break;
                        }

                        if (strOrd != "")
                        {
                            if (!orderFirst)
                                sbSql.Append(", ");
                            else
                                sbSql.Append(" ORDER BY ");

                            sbSql.Append(rc.NameInDb + " " + strOrd);
                            orderFirst = false;
                        }
                    }
                }
            }

            DataSet ds = (new ReportQueryBroker()).ProcessSelect(sbSql.ToString());
            return ds;
        }

        public DataSet ProcessSelect(string StrCondition)
        {
            bool First = true;
            bool orderFirst = true;
            int Count = 0;
            ReportColumn rc;
            StringBuilder sbSql = new StringBuilder();
            sbSql.Append(" SET DATEFORMAT DMY SELECT DISTINCT ");

            //to do Select order....

            List<ReportColumn> arrselcol = new List<ReportColumn>(_arrRptColumn);
            Comparison<ReportColumn> compSel = new Comparison<ReportColumn>(CompareSelectOrder);
            arrselcol.Sort(compSel);

            for (int i = arrselcol.Count - 1; i >= 0; i--)
            {
                rc = arrselcol[i];

                if (rc.IsSelect)
                {
                    if (!First)
                        sbSql.Append(", ");

                    Count++;

                    if (rc.valuedAs == 4)
                        sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                    else
                        sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");

                    First = false;
                }
            }

            if (Count == 0)
            {
                for (int i = 0; i < _arrRptColumn.Count; i++)
                {
                    rc = _arrRptColumn[i];

                    if (rc.IsPartofSelectonly != "N")
                    {
                        if (!First)
                            sbSql.Append(", ");

                        Count++;

                        if (rc.valuedAs == 4)
                            sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                        else
                            sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");

                        First = false;
                    }
                }
            }

            if (_viewName.Contains("*"))
                sbSql.Append(" FROM " + _viewName.Substring(0, _viewName.IndexOf("*")));
            else
                sbSql.Append(" FROM " + _viewName);

            sbSql.Append(" WHERE ");
            PopulateWhere(sbSql);
            sbSql.Append(StrCondition);

            //TO do order by
            List<ReportColumn> arrlist = new List<ReportColumn>(_arrRptColumn);
            //arrlist =_arrRptColumn;
            Comparison<ReportColumn> c = new Comparison<ReportColumn>(CompareWithOrder);
            arrlist.Sort(c);

            for (int i = 0; i < arrlist.Count; i++)
            {
                rc = arrlist[i];

                if (rc.IsSelect)
                {
                    if (rc.SortOrd > 0)
                    {
                        string strOrd = "";

                        switch (rc.SortType)
                        {
                            case "D":
                                strOrd = "DESC";
                                break;

                            case "A":
                                strOrd = "ASC";
                                break;
                        }

                        if (strOrd != "")
                        {
                            if (!orderFirst)
                                sbSql.Append(", ");
                            else
                                sbSql.Append(" ORDER BY ");

                            sbSql.Append(rc.NameInDb + " " + strOrd);
                            orderFirst = false;
                        }
                    }
                }
            }

            DataSet ds = (new ReportQueryBroker()).ProcessSelect(sbSql.ToString());
            return ds;
        }

        public string ProcessSelect(string StrCondition, out int ColumnCount, out string ColColumns)
        {
            ColColumns = String.Empty;
            bool First = true;
            bool orderFirst = true;
            int Count = 0;
            ReportColumn rc;
            StringBuilder sbSql = new StringBuilder();
            sbSql.Append(" SET DATEFORMAT DMY SELECT DISTINCT ");

            List<ReportColumn> arrselcol = new List<ReportColumn>(_arrRptColumn);

            /* //Commented by Abhay
            Comparison<ReportColumn> compSel = new Comparison<ReportColumn>(CompareSelectOrder);
            arrselcol.Sort(compSel);
            for (int i = arrselcol.Count - 1; i >= 0; i--)
            //*/

            Comparison<ReportColumn> compSel = new Comparison<ReportColumn>(CompareWithOrder);
            arrselcol.Sort(compSel);
            for (int i = 0; i < arrselcol.Count; i++)
            {
                rc = arrselcol[i];
                if (rc.IsSelect)
                {
                    if (!First)
                        sbSql.Append(", ");
                    Count++;
                    if (rc.valuedAs == 4)
                        sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                    else
                        sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");
                    First = false;
                    ColColumns = ColColumns + rc.DisplayName + ",";
                }
            }

            ColumnCount = Count;

            if (Count == 0)
            {
                for (int i = 0; i < _arrRptColumn.Count; i++)
                {
                    rc = _arrRptColumn[i];
                    if (rc.IsPartofSelectonly != "N")
                    {
                        if (!First)
                            sbSql.Append(", ");

                        Count++;

                        if (rc.valuedAs == 4)
                            sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                        else
                            sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");

                        First = false;
                    }
                }
            }

            if (_viewName.Contains("*"))
                sbSql.Append(" FROM " + _viewName.Substring(0, _viewName.IndexOf("*")));
            else
                sbSql.Append(" FROM " + _viewName);

            sbSql.Append(" WHERE ");
            PopulateWhere(sbSql);
            sbSql.Append(StrCondition);

            //TO do order by
            List<ReportColumn> arrlist = new List<ReportColumn>(_arrRptColumn);
            //arrlist =_arrRptColumn;
            Comparison<ReportColumn> c = new Comparison<ReportColumn>(CompareWithOrder);
            arrlist.Sort(c);

            for (int i = 0; i < arrlist.Count; i++)
            {
                rc = arrlist[i];
                if (rc.IsSelect)
                {
                    if (rc.SortOrd > 0)
                    {
                        string strOrd = "";

                        switch (rc.SortType)
                        {
                            case "D":
                                strOrd = "DESC";
                                break;
                            case "A":
                                strOrd = "ASC";
                                break;
                        }

                        if (strOrd != "")
                        {
                            if (!orderFirst)
                                sbSql.Append(", ");
                            else
                                sbSql.Append(" ORDER BY ");

                            sbSql.Append(rc.NameInDb + " " + strOrd);
                            orderFirst = false;
                        }
                    }
                }
            }

            //DataSet ds = (new ReportQueryBroker()).ProcessSelect(sbSql.ToString());

            return sbSql.ToString();
        }

        public string ProcessSelect(string StrCondition, out int ColumnCount, out string ColColumns, out string availableDates)
        {
            availableDates = String.Empty;
            ColColumns = String.Empty;
            bool First = true;
            bool orderFirst = true;
            int Count = 0;
            ReportColumn rc;
            StringBuilder sbSql = new StringBuilder();
            sbSql.Append(" SET DATEFORMAT DMY SELECT DISTINCT ");

            //to do Select order....

            List<ReportColumn> arrselcol = new List<ReportColumn>(_arrRptColumn);
            Comparison<ReportColumn> compSel = new Comparison<ReportColumn>(CompareSelectOrder);
            arrselcol.Sort(compSel);

            for (int i = arrselcol.Count - 1; i >= 0; i--)
            {
                rc = arrselcol[i];

                if (rc.IsSelect)
                {
                    if (!First)
                        sbSql.Append(", ");

                    Count++;

                    if (rc.valuedAs == 4)
                        sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                    else
                        sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");

                    First = false;
                    ColColumns = ColColumns + rc.DisplayName + ",";
                }
            }

            ColumnCount = Count;

            if (Count == 0)
            {
                for (int i = 0; i < _arrRptColumn.Count; i++)
                {
                    rc = _arrRptColumn[i];

                    if (rc.IsPartofSelectonly != "N")
                    {
                        if (!First)
                            sbSql.Append(", ");

                        Count++;

                        if (rc.valuedAs == 4)
                            sbSql.Append("CONVERT(VARCHAR," + rc.NameInDb + ",103) [" + rc.DisplayName + "]");
                        else
                            sbSql.Append(rc.NameInDb + " [" + rc.DisplayName + "]");

                        First = false;
                    }
                }
            }

            if (_viewName.Contains("*"))
                sbSql.Append(" FROM " + _viewName.Substring(0, _viewName.IndexOf("*")));
            else
                sbSql.Append(" FROM " + _viewName);

            sbSql.Append(" WHERE ");
            PopulateWhere(sbSql, out availableDates);
            sbSql.Append(StrCondition);

            //TO do order by
            List<ReportColumn> arrlist = new List<ReportColumn>(_arrRptColumn);
            //arrlist =_arrRptColumn;
            Comparison<ReportColumn> c = new Comparison<ReportColumn>(CompareWithOrder);
            arrlist.Sort(c);

            for (int i = 0; i < arrlist.Count; i++)
            {
                rc = arrlist[i];
                if (rc.IsSelect)
                {
                    if (rc.SortOrd > 0)
                    {
                        string strOrd = "";

                        switch (rc.SortType)
                        {
                            case "D":
                                strOrd = "DESC";
                                break;
                            case "A":
                                strOrd = "ASC";
                                break;
                        }

                        if (strOrd != "")
                        {
                            if (!orderFirst)
                                sbSql.Append(", ");
                            else
                                sbSql.Append(" ORDER BY ");

                            sbSql.Append(rc.NameInDb + " " + strOrd);
                            orderFirst = false;
                        }
                    }
                }
            }

            //DataSet ds = (new ReportQueryBroker()).ProcessSelect(sbSql.ToString());
            return sbSql.ToString();
        }

        protected virtual void PopulateWhere(StringBuilder sbSql)
        {
            Subtitle_Lang = "";
            Dubbing_Lang = "";
            Country_Codes = "";
            Channel_Codes = "";
            Cat_Codes = "";
            CBFC_Ratings_Codes = "";

            for (int i = 0; i < _arrRptCond.Count; i++)
            {
                if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "S_LANG")
                    Subtitle_Lang = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue.Replace("'", "");
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "D_LANG")
                    Dubbing_Lang = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue.Replace("'", "");
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "COU.COUNTRY_CODE")
                    Country_Codes = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue.Replace("'", "");
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "CHANNELNAMES")
                    Channel_Codes = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue.Replace("'", "");
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "CAT_NAME")
                    Cat_Codes = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue.Replace("'", "");
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "COLUMNS_VALUE")
                    CBFC_Ratings_Codes = _arrRptCond[i].logicalConnect.Trim().ToUpper() + "~" + _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue.Replace("'", "");
                else
                    _arrRptCond[i].FormWhSQL(sbSql);
            }
        }
        protected virtual void PopulateWhere(StringBuilder sbSql, out string availableDates)
        {
            Subtitle_Lang = "";
            Dubbing_Lang = "";
            Country_Codes = "";
            availableDates = String.Empty;

            for (int i = 0; i < _arrRptCond.Count; i++)
            {
                if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "S_LANG")
                    Subtitle_Lang = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue;
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "D_LANG")
                    Dubbing_Lang = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue;
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "COU.COUNTRY_CODE")
                    Country_Codes = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue;
                else if (_arrRptCond[i].LeftCol.NameInDb.ToUpper() == "CHANNELNAMES")
                    Country_Codes = _arrRptCond[i].theOp.Trim().ToUpper() + "~" + _arrRptCond[i].RightValue;
                else
                    _arrRptCond[i].FormWhSQL(sbSql, out availableDates);
            }
        }

        public int CompareWithOrder(ReportColumn i, ReportColumn j)
        {
            if (i.SortOrd < j.SortOrd)
                return -1;
            else if (i.SortOrd == j.SortOrd)
                return 0;
            else return 1;
        }

        public int CompareSelectOrder(ReportColumn i, ReportColumn j)
        {
            if (i.SelectOrder > j.SelectOrder)
                return -1;
            else if (i.SelectOrder == j.SelectOrder)
                return 0;
            else return 1;
        }

        public void AddGUI(HtmlTable ht, StringBuilder sbHidID, StringBuilder sbHidUserText, StringBuilder sbHidStringAllCond, string businessUnitCode, bool theatricalTerr, int UserCode)
        {
            foreach (ReportColumn rc in _arrRptColumn)
            {
                if (rc.IsPartofSelectonly != "Y")
                    rc.AddGUI(ht, businessUnitCode, theatricalTerr, UserCode);
            }

            foreach (ReportCondition rCond in _arrRptCond)
            {
                try
                {
                    rCond.FillHidden(sbHidID, sbHidUserText, sbHidStringAllCond);
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public void AddColumn(ReportColumn rCol)
        {
            this._arrRptColumn.Add(rCol);
        }

        public void AddCondition(ReportCondition rCond)
        {
            this._arrRptCond.Add(rCond);
        }

        public void AddCondtionFromGUI(string strGUIcond)
        {
            if (_arrRptCond == null)
                _arrRptCond = new List<ReportCondition>();
            else
                _arrRptCond.Clear();

            string[] arrGUICond = strGUIcond.Split('~');
            string colName, op, val, AndOr;
            int indx = 1;
            ReportCondition rcon;
            bool First = true;

            while (indx < arrGUICond.Length)
            {
                colName = arrGUICond[indx++];
                op = arrGUICond[indx++];
                val = arrGUICond[indx++];

                if (First)
                {
                    AndOr = "";
                    indx++; //there is still an entry to be ignored
                }
                else
                    AndOr = arrGUICond[indx++];

                rcon = new ReportCondition(GetReportColumn(colName, false));
                rcon.Setup(op, val, AndOr);
                _arrRptCond.Add(rcon);

                First = false;
            }
        }

        public ReportColumn GetReportColumn(string nameInDB, bool isForSelect)
        {
            foreach (ReportColumn rc in _arrRptColumn)
            {
                if (rc.NameInDb == nameInDB)
                {
                    if (isForSelect && (rc.IsPartofSelectonly == "B" || rc.IsPartofSelectonly == "Y"))
                        return rc;

                    if (isForSelect == false && (rc.IsPartofSelectonly == "B" || rc.IsPartofSelectonly == "N"))
                        return rc;
                }
            }
            return null;
        }

        public override DatabaseBroker GetBroker()
        {
            return new ReportQueryBroker();
        }

        public override void LoadObjects()
        {
            ((ReportQueryBroker)this.GetBroker()).LoadChildren(this);
        }

        public override string Save()
        {
            return base.Save();
        }

        public override void UnloadObjects()
        {
            int count = 0;

            foreach (ReportColumn rcol in _arrRptColumn)
            {
                if (rcol.IsSelect)
                    count++;
            }

            if (count == 0)
            {
                foreach (ReportColumn rcol in _arrRptColumn)
                {
                    rcol.IsSelect = true;
                }
            }

            foreach (ReportColumn rcol in _arrRptColumn)
            {
                rcol.IsTransactionRequired = this.IsTransactionRequired;
                rcol.SqlTrans = this.SqlTrans;
                rcol.Save();
            }

            if (_arrRptCond.Count > 0)
            {
                ReportCondition rCondation = (ReportCondition)_arrRptCond[0];
                rCondation.DeleteABunchofRows();
            }

            foreach (ReportCondition rCond in _arrRptCond)
            {
                rCond.IsTransactionRequired = this.IsTransactionRequired;
                rCond.SqlTrans = this.SqlTrans;
                rCond.Save();
            }
        }

        public string GetCondValuesForCol(string colName)
        {
            foreach (ReportCondition rCd in this._arrRptCond)
            {
                if (rCd.LeftCol.IsPartofSelectonly == "B" || rCd.LeftCol.IsPartofSelectonly == "N")
                {
                    if (rCd.LeftCol.NameInDb.ToUpper() == colName.ToUpper())
                        return rCd.RightValue;
                }
            }
            throw new RecordNotFoundException();
        }

        public string GetSelectedColumnList(string isSort,out int ColumnCount, out string ColColumns)
        {
            ColColumns = String.Empty;
            bool First = true;
            int Count = 0;
            ReportColumn rc;
            StringBuilder sbSql = new StringBuilder();

            //to do Select order....

            List<ReportColumn> arrselcol = new List<ReportColumn>(_arrRptColumn);
            if (isSort == "N")
            {
                Comparison<ReportColumn> compSel = new Comparison<ReportColumn>(CompareSelectOrder);
                arrselcol.Sort(compSel);

                for (int i = arrselcol.Count - 1; i >= 0; i--)
                {
                    rc = arrselcol[i];

                    if (rc.IsSelect)
                    {
                        if (!First)
                            sbSql.Append(", ");

                        Count++;

                        string[] arrName = rc.NameInDb.Split('.');
                        string name = arrName[arrName.Length - 1];

                        //if (name.Contains(","))
                        //    name = (name.Split(',')[0]);

                        if (rc.valuedAs == 4)
                            sbSql.Append("CONVERT(VARCHAR," + name + ",103) [" + rc.DisplayName + "]");
                        else
                            sbSql.Append(name + " [" + rc.DisplayName + "]");

                        First = false;
                        ColColumns = ColColumns + rc.DisplayName + ",";
                    }
                }
            }
            else
            {
                foreach (var item in arrselcol.Where(x => x.IsSelect == true).OrderBy(x => x.SortOrd).ThenBy(x => x.DisplayOrd).ToList())
                {
                    if (item.IsSelect)
                    {
                        if (!First)
                            sbSql.Append(", ");

                        Count++;

                        string[] arrName = item.NameInDb.Split('.');
                        string name = arrName[arrName.Length - 1];

                        if (item.valuedAs == 4)
                            sbSql.Append("CONVERT(VARCHAR," + name + ",103) [" + item.DisplayName + "]");
                        else
                            sbSql.Append(name + " [" + item.DisplayName + "]");

                        First = false;
                        ColColumns = ColColumns + item.DisplayName + ",";
                    }
                }
            }
            ColumnCount = Count;

            if (Count == 0)
            {
                for (int i = 0; i < _arrRptColumn.Count; i++)
                {
                    rc = _arrRptColumn[i];

                    if (rc.IsPartofSelectonly != "N")
                    {
                        if (!First)
                            sbSql.Append(", ");

                        Count++;

                        string[] arrName = rc.NameInDb.Split('.');
                        string name = arrName[arrName.Length - 1];

                        //if (arrName[0].Contains(","))
                        //    name = (name.Split(',')[0]);

                        if (rc.valuedAs == 4)
                            sbSql.Append("Convert(varchar," + name + ",103) [" + rc.DisplayName + "]");
                        else
                            sbSql.Append(name + " [" + rc.DisplayName + "]");

                        First = false;
                    }
                }
            }

            return sbSql.ToString();
        }
        public string GetWhereCondition(string strCondtion)
        {
            string str = "";
            string returnStr = "";
            StringBuilder strBuilder = new StringBuilder();
            PopulateWhere(strBuilder);

            if ((strBuilder.ToString().Trim().StartsWith("and ")))
            {
                str = "AND (" + strBuilder.ToString().Substring(4) + ") ";
            }
            else if (strBuilder.ToString().Trim().StartsWith("or "))
            {
                str = "AND (" + strBuilder.ToString().Substring(3) + ") ";
            }
            else if (strBuilder.ToString() != "")
            {
                str = "AND (" + strBuilder.ToString() + ") ";
            }
            else
            {
                str = strBuilder.ToString();
            }

            returnStr = (str + strCondtion).Replace(" and and ", " and ").Replace(" and or ", " and ");

            return returnStr;
        }
    }
}