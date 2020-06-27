using System;
using System.Data;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Collections;
/// <summary>
/// Summary description for Title
/// </summary>
public class MapExtendedColumns : Persistent
{
    public MapExtendedColumns()
    {
        OrderByColumnName = "Column_Value";
        OrderByCondition = "ASC";
        tableName = "Map_Extended_Columns";
        pkColName = "Map_Extended_Columns_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _RecordCode;
    public int RecordCode
    {
        get { return this._RecordCode; }
        set { this._RecordCode = value; }
    }

    private string _TableName = "TITLE";
    public string TableName
    {
        get { return this._TableName; }
        set { this._TableName = value; }
    }

    private int _ColumnsCode;
    public int ColumnsCode
    {
        get { return this._ColumnsCode; }
        set { this._ColumnsCode = value; }
    }

    private int _ColumnsValueCode;
    public int ColumnsValueCode
    {
        get { return this._ColumnsValueCode; }
        set { this._ColumnsValueCode = value; }
    }

    private string _ColumnValue = "";
    public string ColumnValue
    {
        get { return this._ColumnValue; }
        set { this._ColumnValue = value; }
    }

    private string _IsMultipleSelect = "N";
    public string IsMultipleSelect
    {
        get { return this._IsMultipleSelect; }
        set { this._IsMultipleSelect = value; }
    }
    #endregion

    #region ---------------Object And ArrayList---------------
    private ExtendedColumns _objExtendedColumns;
    public ExtendedColumns ObjExtendedColumns
    {
        get
        {
            if (_objExtendedColumns == null)
                _objExtendedColumns = new ExtendedColumns();
            return _objExtendedColumns;
        }
        set { _objExtendedColumns = value; }
    }

    private ExtendedColumnsValue _objExtendedColumnsValue;
    public ExtendedColumnsValue ObjExtendedColumnsValue
    {
        get
        {
            if (_objExtendedColumnsValue == null)
                _objExtendedColumnsValue = new ExtendedColumnsValue();
            return _objExtendedColumnsValue;
        }
        set { _objExtendedColumnsValue = value; }
    }

    private ArrayList _arrMapExtendedColumnsDetails;
    public ArrayList ArrMapExtendedColumnsDetails
    {
        get
        {
            if (this._arrMapExtendedColumnsDetails == null)
                this._arrMapExtendedColumnsDetails = new ArrayList();
            return _arrMapExtendedColumnsDetails;
        }
        set { _arrMapExtendedColumnsDetails = value; }
    }

    private ArrayList _arrMapExtendedColumnsDetails_del;
    public ArrayList ArrMapExtendedColumnsDetails_del
    {
        get
        {
            if (this._arrMapExtendedColumnsDetails_del == null)
                this._arrMapExtendedColumnsDetails_del = new ArrayList();
            return _arrMapExtendedColumnsDetails_del;
        }
        set { _arrMapExtendedColumnsDetails_del = value; }
    }
    private string _status = "";
    public string Status
    {
        get { return _status; }
        set { _status = value; }
    }
    #endregion
    #region ---------------Methods---------------

    public override DatabaseBroker GetBroker()
    {
        return new MapExtendedColumnsBroker();
    }

    public override void LoadObjects()
    {
        if (this.IntCode > 0)
        {
            //Map_Extended_Columns
            this.ArrMapExtendedColumnsDetails = DBUtil.FillArrayList(new MapExtendedColumnsDetails(), " AND Map_Extended_Columns_Code=" + this.IntCode, false);
            //[Extended_Columns]
            ObjExtendedColumns.IntCode = this.ColumnsCode;
            ObjExtendedColumns.Fetch();
            if (ObjExtendedColumns.IsMultipleSelect.Trim().ToUpper() == "Y")//MultiSelect
            {
                string strValueCode = "";
                foreach (MapExtendedColumnsDetails objMapExtendedColumnsDetails in ArrMapExtendedColumnsDetails)
                {
                    strValueCode += "," + Convert.ToString(objMapExtendedColumnsDetails.ColumnsValueCode);
                }
                if (ObjExtendedColumns.RefTable.Trim().ToUpper() == "TALENT")
                {
                    ObjExtendedColumnsValue.ColumnsValue = GetTalentNameUsingTalentCode(strValueCode, ObjExtendedColumns.AdditionalCondition);
                    ObjExtendedColumnsValue.All_Talent_Code = strValueCode.Trim().Trim(',');
                }
                else
                    ObjExtendedColumnsValue.ColumnsValue = GetCommaSeparetedColumnVauesName(strValueCode);
            }
            //[Extended_Columns_Value]
            else if (this.ColumnsValueCode > 0 && ObjExtendedColumns.IsDefinedValues.Trim().ToUpper() == "Y" && ObjExtendedColumns.ControlType.Trim().ToUpper() == "DDL" && ObjExtendedColumns.IsMultipleSelect.Trim().ToUpper() == "N")
            {
                ObjExtendedColumnsValue.IntCode = this.ColumnsValueCode;
                ObjExtendedColumnsValue.Fetch();
            }
            else if (ObjExtendedColumns.ControlType.Trim().ToUpper() == "TXT")//Text box
            {
                ObjExtendedColumnsValue.ColumnsValue = this.ColumnValue;//Text Box
            }
        }
    }

    public override void UnloadObjects()
    {
        if (this.ArrMapExtendedColumnsDetails_del != null)
        {
            foreach (MapExtendedColumnsDetails objMapExtendedColumns in this.ArrMapExtendedColumnsDetails_del)
            {
                objMapExtendedColumns.IsTransactionRequired = true;
                objMapExtendedColumns.SqlTrans = this.SqlTrans;
                objMapExtendedColumns.IsDeleted = true;
                objMapExtendedColumns.IsProxy = false;
                objMapExtendedColumns.Save();
            }
        }

        if (this.ArrMapExtendedColumnsDetails != null)
        {
            foreach (MapExtendedColumnsDetails objMapExtendedColumns in this.ArrMapExtendedColumnsDetails)
            {
                objMapExtendedColumns.MapExtendedColumnsCode = this.IntCode;
                objMapExtendedColumns.IsTransactionRequired = true;
                objMapExtendedColumns.SqlTrans = this.SqlTrans;
                objMapExtendedColumns.IsProxy = true;
                if (objMapExtendedColumns.IntCode > 0)
                    objMapExtendedColumns.IsDirty = true;
                objMapExtendedColumns.Save();
            }
        }
    }
    public string GetTalentNameUsingTalentCode(string TalentCode, string AdditionalCondition)
    {
        TalentCode = TalentCode.Trim().Trim(',') == "" ? "0" : TalentCode.Trim().Trim(',');
        string sql = "Select STUFF(("
                            + " Select   distinct ', '  +  T.talent_name  from Talent T"
                            + " Inner Join Talent_Role TR ON T.talent_code = TR.talent_code " + AdditionalCondition + ""
                            + " Where T.talent_code IN(" + TalentCode.Trim() + ")"
                            + " FOR XML PATH('') ), 1, 1, '') as talent_name";
        string TalentName = "";
        TalentName = DatabaseBroker.ProcessScalarReturnString(sql);
        return TalentName;
    }
    public string GetRoleCode(string AdditionalCondition)
    {
        string RoleCode = "0";
        string sql = "SELECT Role_Code FROM [Role] WHERE 1 =1 " + AdditionalCondition;
        RoleCode = DatabaseBroker.ProcessScalarReturnString(sql);
        return RoleCode;
    }
    public string GetCommaSeparetedColumnVauesName(string strColumnValue)
    {
        strColumnValue = strColumnValue.Trim().Trim(',') == "" ? "0" : strColumnValue.Trim().Trim(',');
        string sql = "Select STUFF(("
                    + " Select distinct ','  + ISNULL(Columns_Value,'') from Extended_Columns_Value"
                    + " Where Columns_Value_Code IN(" + strColumnValue + ")"
                    + " FOR XML PATH('') ), 1, 1, '') as ColumnsValuess";
        string sqlResult = DatabaseBroker.ProcessScalarReturnString(sql);
        return sqlResult;
    }

    #endregion
}
