using System;
using System.Data.SqlClient;
using System.Data;
using System.Collections;
using System.Web;

using System.Web.UI.WebControls;
using System.Web.UI;
using AjaxControlToolkit;
using System.Collections.Generic;
using System.Reflection;

using System.Collections.Specialized;
using System.Configuration;
using System.Net;

/// <summary>
/// Summary description for UTOFramework
/// Contains Following Classes:
/// ----Framework Classes------
/// Persistent
/// DatabaseBroker
/// Criteria
/// AttribValue
/// ----Exception Classes------
/// DeactivateNotAllowed
/// DuplicateRecordException
/// RecordNotFoundException
/// </summary>
namespace UTOFrameWork.FrameworkClasses
{
    #region========Persistent=============
    /// <summary>
    /// Summary description for Persistent.
    /// </summary>
    public abstract class Persistent
    {
        private object _sqlTrans = null; //this will be SqlTransaction if the subclass is transactional

        public const int NOT_SAVED_ID = 0;

        /// <summary>
        ///default constructor  
        /// </summary>
        public Persistent()
        {

        }

        public Persistent(int theCode)
            : this()
        {
            _code = theCode;
        }

        #region "----------------------- MEMBER VARIABLES ----------------"

        /// <summary>
        /// Member variable generally used for primary key of dataBase Table
        /// </summary>
        private int _code;

        /// <summary>
        /// Member variable will contain the N if u need to unloadobject() and
        /// otherwise this field is Y
        /// </summary>
        private bool _isProxy = true;

        /// <summary>
        /// Member variable will contain true if u need to delete the entity and
        /// N if do not wish to delete
        /// </summary>
        private bool _isDeleted = false;

        /// <summary>
        /// Member variable will contain the true if u need to Update the entity and
        /// N if u don't want to go for Update
        /// </summary>
        private bool _isDirty = false;

        /// <summary>
        /// Member variable will contain true if u need to activate the entity and 
        /// false if u need to deactivate the entity.
        /// </summary>
        private bool _isActivated = false; //this field will contain true if u need to activate the entity and false if u need to deactivate the entity.

        /// <summary>
        /// Object of DataBase Broker
        /// </summary>
        public DatabaseBroker broker;

        /// <summary>
        /// Member variable is for isActive field of table. 
        /// </summary>
        private string _isActive;
        //private string _is_Theatrical_Territory;

        /// <summary>
        /// Member variable is for dataBase table field of DateTime for Updated on DateTime
        /// </summary>
        private string _lastUpdatedOn;

        /// <summary>
        /// Member variable is for Updated By Login User ID
        /// </summary>
        private int _lastUpdatedBy;


        /// <summary>
        /// Member variable is for storing the time of locking the record
        /// </summary>
        private string _lockTime;


        /// <summary>
        /// Member variable is for storing the time of updation of the record.
        /// </summary>
        private string _lastUpdateTime;


        /// <summary>
        /// Mamber variable will contain the grid/table column name on which user want to sort the recordset
        /// </summary>
        private string _orderByColumnName = "";

        /// <summary>
        /// Mamber variable will contain either ASC or DESC and it's depends upon the user click
        /// </summary>
        private string _orderByCondition = "ASC";

        /// <summary>
        /// Member variable for checking whether transaction is required or not.
        /// </summary>
        private bool _isTransactionRequired = false;
        private bool _isBeginningOfTrans = false;
        private bool _isEndOfTrans = false;
        private bool _isLastIdRequired = false;
        private string _uploadedOn;
        private int _uploadedBy;
        private int _insertedBy;
        private string _InsertedOn;
        private int _LastActionBy;
        private string _tableName;
        private string _pkColName;

        #endregion

        #region "------------------------ PROPERTIES -----------------------"

        /// <summary>
        /// This property is to access private _code
        /// </summary>
        public int IntCode
        {
            get
            {
                return this._code;
            }
            set
            {
                this._code = value;
            }
        }


        /// <summary>
        /// This property is to access private _isDirty
        /// </summary>
        public virtual bool IsDirty
        {
            get
            {
                return this._isDirty;
            }
            set
            {
                this._isDirty = value;
            }
        }


        /// <summary>
        /// This property is to access private _isDeleted
        /// </summary>
        public bool IsDeleted
        {
            get
            {
                return this._isDeleted;
            }
            set
            {
                this._isDeleted = value;
            }
        }

        /// <summary>
        /// This property is to access private _isActivated
        /// </summary>
        public bool IsActivated
        {
            get
            {
                return this._isActivated;
            }
            set
            {
                this._isActivated = value;
            }
        }

        /// <summary>
        /// This property is to access private _isProxy
        /// </summary>
        public bool IsProxy
        {
            get
            {
                return this._isProxy;
            }
            set
            {
                this._isProxy = value;
            }
        }

        /// <summary>
        /// This property is to access private _isActive
        /// </summary>
        //public string Is_Theatrical_Territory
        //{
        //    get
        //    {
        //        return this._is_Theatrical_Territory;
        //    }
        //    set
        //    {
        //        this._is_Theatrical_Territory = value;
        //    }
        //}


        public string Is_Active
        {
            get
            {
                return this._isActive;
            }
            set
            {
                this._isActive = value;
            }
        }
        /// <summary>
        /// This property is for access private _lastUpdatedOn
        /// </summary>
        public string LastUpdatedOn
        {
            get
            {
                return this._lastUpdatedOn;
            }
            set
            {
                this._lastUpdatedOn = value;
            }
        }

        /// <summary>
        /// This property is for access private _lastUpdatedBy
        /// </summary>
        public int LastUpdatedBy
        {
            get
            {
                return this._lastUpdatedBy;
            }
            set
            {
                this._lastUpdatedBy = value;
            }

        }


        public string OrderByColumnName
        {
            get
            {
                return this._orderByColumnName;
            }
            set
            {
                this._orderByColumnName = value;
            }
        }

        public string OrderByCondition
        {
            get
            {
                return this._orderByCondition;
            }
            set
            {
                this._orderByCondition = value;
            }
        }

        public string OrderByReverseCondition
        {
            get
            {
                if (this._orderByCondition.Trim().ToUpper() == "ASC")
                    return "DESC";

                return "ASC";
            }
        }

        public object SqlTrans
        {
            get
            {
                return this._sqlTrans;
            }
            set
            {
                this._sqlTrans = value;
            }
        }


        /// <summary>
        /// Property for last inserted Id Required 
        /// </summary>
        public bool IsLastIdRequired
        {
            get
            {
                return _isLastIdRequired;
            }

            set
            {
                _isLastIdRequired = value;
            }
        }

        /// <summary>
        /// Property for accessing member variable _endTrans.
        /// </summary>
        public bool IsEndOfTrans
        {
            get
            {
                return _isEndOfTrans;
            }

            set
            {
                IsTransactionRequired = value;
                _isEndOfTrans = value;
            }
        }

        /// <summary>
        /// Property for accessing member variable _beginTrans.
        /// </summary>
        public bool IsBeginningOfTrans
        {
            get
            {
                return _isBeginningOfTrans;
            }

            set
            {
                IsTransactionRequired = value;
                _isBeginningOfTrans = value;
            }
        }


        /// <summary>
        /// Property for accessing member variable _transactionRequired.
        /// </summary>
        public bool IsTransactionRequired
        {
            get
            {
                return _isTransactionRequired;
            }

            set
            {
                _isTransactionRequired = value;
            }
        }
        public string UploadedOn
        {
            get
            {
                return _uploadedOn;
            }

            set
            {
                _uploadedOn = value;
            }
        }

        public int UploadedBy
        {
            get
            {
                return _uploadedBy;
            }

            set
            {
                _uploadedBy = value;
            }
        }

        public string LockTime
        {
            get
            {
                return _lockTime;
            }

            set
            {
                _lockTime = value;
            }

        }


        public string LastUpdatedTime
        {
            get
            {
                if (_lastUpdateTime == null) return "";
                return _lastUpdateTime;
            }

            set
            {
                _lastUpdateTime = value;
            }

        }
        public int InsertedBy
        {
            set { _insertedBy = value; }
            get { return _insertedBy; }
        }
        public string InsertedOn
        {
            set { _InsertedOn = value; }
            get { return _InsertedOn; }
        }
        public int LastActionBy
        {
            get { return this._LastActionBy; }
            set { this._LastActionBy = value; }
        }
        public string tableName
        {
            get { return _tableName; }
            set { _tableName = value; }
        }

        public string pkColName
        {
            get { return _pkColName; }
            set { _pkColName = value; }
        }
        #endregion

        #region "-------------------------- METHODS ------------------"

        /// <summary>
        /// Abstract method  Used by object made for dataBase table
        /// </summary>
        /// <returns></returns>
        public abstract DatabaseBroker GetBroker();

        /// <summary>
        ///  Abstract method  Used by object made for dataBase table
        /// </summary>
        public abstract void UnloadObjects();

        /// <summary>
        ///  Abstract method  Used to fetch the objects
        /// </summary>
        public virtual void LoadObjects()
        {
            throw new Exception("not coded");
        }

        /// <summary>
        ///  Abstract method  Used by object made for dataBase table to save dataBase changes
        /// </summary>
        /// <returns></returns>
        public virtual string Save()
        {
            return this.GetBroker().Dematerialise(this);
        }

        public virtual string Save(bool isEdit, bool isTransactional, object sqlTransaction)
        {
            this.IsDirty = isEdit;
            this.IsTransactionRequired = isTransactional;
            this.SqlTrans = sqlTransaction;
            return this.GetBroker().Dematerialise(this);
        }

        /// <summary>
        /// Used to fetch Object values declared in Object
        /// </summary>
        public void Fetch()
        {
            broker = this.GetBroker();
            broker.Materialise(this);
        }

        public void FetchDeep()
        {
            Fetch();
            LoadObjects();
        }

        public virtual string getRecordStatus()
        {
            return null;
        }
        public virtual string getRecordStatus(out int UserIntcode)
        {
            //UserIntcode = 0;
            //return null;
            return this.GetBroker().getRecordStatus(this, out UserIntcode);
        }

        public virtual void unlockRecord()
        {
            this.GetBroker().unlockRecord(this);
        }


        public virtual void refreshRecord()
        {

        }
        public static T DeepCopy<T>(T obj)
        {
            if (obj == null)
                throw new ArgumentNullException("Object cannot be null");
            return (T)Process(obj);
        }

        static object Process(object obj)
        {
            if (obj == null)
                return null;
            Type type = obj.GetType();
            if (type.IsValueType || type == typeof(string))
            {
                return obj;
            }
            else if (type.IsArray)
            {
                Type elementType = Type.GetType(type.FullName.Replace("[]", string.Empty));
                var array = obj as Array;
                Array copied = Array.CreateInstance(elementType, array.Length);
                for (int i = 0; i < array.Length; i++)
                {
                    copied.SetValue(Process(array.GetValue(i)), i);
                }
                return Convert.ChangeType(copied, obj.GetType());
            }
            else if (type.IsClass)
            {
                object toret = Activator.CreateInstance(obj.GetType());
                FieldInfo[] fields = type.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                foreach (FieldInfo field in fields)
                {
                    object fieldValue = field.GetValue(obj);
                    if (fieldValue == null)
                        continue;
                    field.SetValue(toret, Process(fieldValue));
                }
                return toret;
            }
            else
                throw new ArgumentException("Unknown type");
        }

        #endregion
    }
    #endregion

    #region=======DatabaseBroker==========
    /// <summary>
    /// Summary description for DatabaseBroker.
    /// </summary>
    public abstract class DatabaseBroker
    {
        /// <summary>
        /// Public connectionString variable for coonection for database
        /// </summary>
        public string connectionString;

        public static int CommandTimeoutStatic { get; set; }
        public int CommandTimeout { get; set; }

        /// <summary>
        /// 
        /// </summary>
        protected SqlConnection myConnection = new SqlConnection();

        /// <summary>
        /// Constructor Logic...
        /// It creates Connection String for data access from BackEnd dataBase 
        /// with DatabaseName,DataServer,UserId,Password.
        /// </summary>
        public DatabaseBroker()
        {
            string strConnectionString = GetConnectionStr();
            myConnection.ConnectionString = strConnectionString;
        }
        public static string GetConnectionStr()
        {
            CommandTimeoutStatic = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeout"]);

            //Commented By Adesh 28May2014
            //string strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["DatabaseName"];
            //if (GlobalParams.entity_Type == "HV")
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["DatabaseName_HV"];

            //if (GlobalParams.entity_Type.ToString().ToUpper() == ConfigurationManager.AppSettings["RightsU"].ToUpper())
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU"];

            //if (GlobalParams.entity_Type.ToString().ToUpper() == ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper())
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU_VMPL"];
            //End

            string strDataBase = strDataBase = "Initial Catalog=" + Convert.ToString(new ParentPage().ObjLoginEntity.DatabaseName);

            string strServer = "Data Source=" + Convert.ToString(ConfigurationManager.AppSettings["DataServer"]);
            string strUserId = "User Id=" + Convert.ToString(ConfigurationManager.AppSettings["UserId"]);
            string strPassword = " Password=" + Convert.ToString(ConfigurationManager.AppSettings["Password"]);
            string StrTimeOut = " Connection Timeout =" + Convert.ToString(ConfigurationManager.AppSettings["TimeOut"]);
            string strConnectionString = strServer + ";" + strDataBase + ";" + strUserId + ";" + strPassword + ";" + StrTimeOut;
            return strConnectionString;
        }
        public static string GetDataBaseName()
        {
            //string strDataBase = "Initial Catalog=" + Convert.ToString(ConfigurationManager.AppSettings["RightsU"]);
            string strDataBase = "Initial Catalog=" + Convert.ToString(new ParentPage().ObjLoginEntity.DatabaseName);
            return strDataBase;
        }
        public static SqlConnection GetSqlConnection()
        {
            SqlConnection myConn = new SqlConnection();
            string strConnectionString = GetConnectionStr();
            myConn.ConnectionString = strConnectionString;

            return myConn;
        }

        private void AttachParameters(SqlCommand command, SqlParameter[] commandParameters)
        {
            command.Parameters.Clear();

            if (command == null) throw new ArgumentNullException("command");
            if (commandParameters != null)
            {
                for (int i = 0; i < commandParameters.Length; i++)
                {


                    SqlParameter sp = new SqlParameter();
                    sp = (SqlParameter)commandParameters.GetValue(i);
                    //SqlParameter Obj = new SqlParameter(sp.ParameterName, sp.Value);
                    SqlParameter Obj = new SqlParameter(sp.ParameterName, sp.Value);
                    Obj.Direction = sp.Direction;

                    if (Obj != null)
                    {
                        //Check for derived output value with no value assigned
                        if ((Obj.Direction == ParameterDirection.InputOutput ||
                            Obj.Direction == ParameterDirection.Input) &&
                            (Obj.Value == null || Obj.Value.ToString() == ""))
                        {
                            Obj.Value = DBNull.Value;
                        }
                        command.Parameters.Add(Obj);
                    }
                }
            }
        }

        public SqlParameter SqlParameter(string ParameterName, object Value, SqlDbType sqlDbType)
        {
            SqlParameter objSqlParameter = new SqlParameter();
            objSqlParameter.ParameterName = ParameterName;
            objSqlParameter.Value = Value;
            objSqlParameter.SqlDbType = sqlDbType;
            return objSqlParameter;
        }

        public SqlParameter SqlParameter(string ParameterName, object Value, SqlDbType sqlDbType, bool IsOutPut)
        {
            SqlParameter objSqlParameter = new SqlParameter();
            objSqlParameter.ParameterName = ParameterName;
            objSqlParameter.Value = Value;
            if (IsOutPut)
                objSqlParameter.Direction = ParameterDirection.Output;
            objSqlParameter.SqlDbType = sqlDbType;
            return objSqlParameter;
        }

        public DataSet ProcessSelect(string ProcName, SqlParameter[] SqlParam, ref int RecordCount)
        {
            DataSet ds = new DataSet();
            SqlCommand SelectCommand = new SqlCommand();
            try
            {
                AttachParameters(SelectCommand, SqlParam);
                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = SelectCommand;
                dataAdapter.SelectCommand.CommandText = ProcName;
                dataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                dataAdapter.SelectCommand.Connection = myConnection;
                dataAdapter.Fill(ds, "List");
                if (SelectCommand.Parameters.Count > 0 && SelectCommand.Parameters[0].Direction == ParameterDirection.Output)
                    RecordCount = Convert.ToInt32(SelectCommand.Parameters[0].Value);
            }
            finally
            {
                myConnection.Close();
            }
            return ds;
        }
        /// <summary>
        /// Method that processes select sql command and gets table in DataSet.
        /// This is used for direct access to functionality of ProcesSelect()
        /// </summary>
        /// <param name="sql">sql command string</param>
        /// <returns>dataset</returns>
        public static DataSet ProcessSelectDirectly(string sql)
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = GetConnectionStr();

            DataSet ds = new DataSet();
            SqlCommand SelectCommand = new SqlCommand();
            SelectCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = SelectCommand;
                dataAdapter.SelectCommand.CommandText = sql;
                dataAdapter.SelectCommand.Connection = myConn;
                dataAdapter.Fill(ds, "List");
            }
            finally
            {
                myConn.Close();
            }
            return ds;
        }


        public static DataSet ProcessSelectUsingTrans(string sql, ref SqlTransaction sqlTrans)  //ADDED BY PRASHANT
        {
            DataSet ds = new DataSet();
            SqlCommand SelectCommand = new SqlCommand();
            SelectCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = SelectCommand;
                dataAdapter.SelectCommand.CommandText = sql;
                dataAdapter.SelectCommand.Connection = sqlTrans.Connection;
                dataAdapter.SelectCommand.Transaction = sqlTrans;
                dataAdapter.Fill(ds, "List");
            }
            catch (Exception ex)
            {
                ex.Message.ToString();
            }
            finally
            {
                //myConnection.Close();
            }
            return ds;
        }

        public static string ProcessScalarUsingTrans(string sql, ref SqlTransaction sqlTrans)
        {
            DataSet ds = new DataSet();
            SqlCommand ScalarCommand = new SqlCommand();
            ScalarCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                ScalarCommand.CommandText = sql;
                ScalarCommand.Transaction = sqlTrans;
                ScalarCommand.Connection = sqlTrans.Connection;
                return Convert.ToString(ScalarCommand.ExecuteScalar());
            }
            catch (Exception ex)
            {
                sqlTrans.Rollback();
                throw ex;
            }

        }
        public static string ProcessScalarUsingTrans(string sql, ref SqlTransaction sqlTrans, int commandTimeOut)
        {
            DataSet ds = new DataSet();
            SqlCommand ScalarCommand = new SqlCommand();
            ScalarCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {

                ScalarCommand.CommandText = sql;
                ScalarCommand.CommandTimeout = commandTimeOut;
                ScalarCommand.Transaction = sqlTrans;
                ScalarCommand.Connection = sqlTrans.Connection;
                return Convert.ToString(ScalarCommand.ExecuteScalar());
            }
            catch (Exception ex)
            {
                sqlTrans.Rollback();
                throw ex;
            }

        }

        public static string ProcessScalarReturnString(string sql)
        {
            SqlConnection myConn = new SqlConnection();
            myConn = GetSqlConnection();
            SqlCommand ScalarCommand = new SqlCommand();
            ScalarCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                ScalarCommand.CommandText = sql;
                ScalarCommand.Connection = myConn;
                myConn.Open();
                return Convert.ToString(ScalarCommand.ExecuteScalar());
            }
            catch
            {
                return "ERROR";
            }
            finally
            {
                myConn.Close();
            }
        }






        /// <summary>
        /// Abstract Method which is used by object Broker which inherites DataBaseBroker.
        /// It is used for creating sql select statement as per Paging is required or not
        /// </summary>
        /// <param name="critseriaObj">criteria as Object</param>
        /// <param name="parentObj"></param>
        /// <param name="childObj"></param>
        /// <param name="searchString">For select statement sql search criteria</param>
        /// <returns>sql string for select from database table</returns>
        public abstract string GetSelectSql(Criteria objCriteria, string strSearchString);

        /// <summary>
        /// Abstract method used to Populate object by it's values
        /// </summary>
        /// <param name="dRow">DataRow</param>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns></returns>
        public abstract Persistent PopulateObject(DataRow dRow, Persistent obj);

        /// <summary>
        /// Abstract method used for Duplicate record check condition
        /// </summary>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns>sql statement string</returns>
        public abstract Boolean CheckDuplicate(Persistent obj);

        /// <summary>
        /// Abstract Method which is used by object Broker for generating insert record statement
        /// </summary>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns>insert sql statement in string</returns>
        public abstract string GetInsertSql(Persistent obj);

        /// <summary>
        /// Abstract method used for getting Update sql statement
        /// </summary>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns>Update sql statement string</returns>
        public abstract string GetUpdateSql(Persistent obj);

        /// <summary>
        /// Abstract Method which is used by object broker which inherites DataBaseBroker.
        /// Delete is possible returns "Delete".
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public abstract bool CanDelete(Persistent obj, out string strMessage);

        /// <summary>
        /// Abstract method used for getting Delete sql statement
        /// </summary>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns></returns>
        public abstract string GetDeleteSql(Persistent obj);

        /// <summary>
        /// Abstract method used 
        /// </summary>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns></returns>
        public abstract string GetActivateDeactivateSql(Persistent obj);

        /// <summary>
        /// Abstract Method  used to count number of records for dataBase table select statement.
        /// </summary>
        /// <param name="searchString">search criteria for count</param>
        /// <returns>sql statement which counts records</returns>
        public abstract string GetCountSql(string strSearchString);

        /// <summary>
        /// Generates select statement for selecting records for code value
        /// </summary>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns></returns>
        public abstract string GetSelectSqlOnCode(Persistent obj);
        int RecordCount;
        public virtual DataSet GetSelectSqlUsp(Persistent obj)
        {
            return new DataSet();
        }

        /// <summary>
        /// Method used for populating object for select statement for Code value
        /// </summary>
        /// <param name="obj">Object of which the current Object Broker is</param>
        /// <returns>Arraylist containing populated object values</returns>
        public ArrayList Materialise(Persistent obj)
        {
            string sql = GetSelectSqlOnCode(obj);
            DataSet ds;
            if (sql != "")
            {

                if (obj.IsTransactionRequired == true)
                {
                    SqlTransaction sqltrans = (SqlTransaction)obj.SqlTrans;
                    ds = ProcessSelect(sql, ref sqltrans);
                }
                else
                {
                    ds = ProcessSelect(sql);
                }
            }
            else ds = GetSelectSqlUsp(obj);
            if (ds.Tables[0].Rows.Count < 1)
            {
                throw new RecordNotFoundException();
            }
            ArrayList objectArray = new ArrayList();
            foreach (DataRow aDataRow in ds.Tables[0].Rows)
            {
                objectArray.Add(PopulateObject(aDataRow, obj));
            }
            return objectArray;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="persistentCriteria"></param>
        /// <param name="parentObj"></param>
        /// <param name="childObj"></param>
        /// <param name="searchString"></param>
        /// <returns></returns>
        public ArrayList MaterialiseCount(object persistentCriteria, string searchString)
        {
            string sql = GetCountSql(searchString);
            DataSet ds = ProcessSelect(sql);
            ArrayList arrCnt = new ArrayList();
            arrCnt.Add((int)ds.Tables[0].Rows[0][0]);
            return arrCnt;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="persistentCriteria"></param>
        /// <param name="parentObj"></param>
        /// <param name="childObj"></param>
        /// <param name="searchString"></param>
        /// <returns></returns>
        public ArrayList MaterialiseList(Criteria objCriteria, string searchString)
        {
            string sql = GetSelectSql(objCriteria, searchString);
            DataSet ds;
            if (sql != "")
            {
                ds = ProcessSelect(sql);
            }
            else ds = GetSelectSqlUsp((Persistent)objCriteria.ClassRef);
            ArrayList objectArray = new ArrayList();
            foreach (DataRow aDataRow in ds.Tables[0].Rows)
            {
                Persistent tmpObj = PopulateObject(aDataRow, null);

                if (objCriteria.IsSubClassRequired)
                {
                    tmpObj.LoadObjects();
                }
                objectArray.Add(tmpObj);
            }
            return objectArray;
        }

        /// <summary>
        /// Method that processes select sql command and gets table in DataSet.
        /// </summary>
        /// <param name="sql">sql command string</param>
        /// <returns>dataset</returns>
        public DataSet ProcessSelect(string sql)
        {
            DataSet ds = new DataSet();
            SqlCommand SelectCommand = new SqlCommand();
            SelectCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = SelectCommand;
                dataAdapter.SelectCommand.CommandText = sql;
                dataAdapter.SelectCommand.Connection = myConnection;
                dataAdapter.Fill(ds, "List");
            }
            finally
            {
                myConnection.Close();
            }
            return ds;
        }

        /// <summary>
        /// Method that processes select sql command and gets table in DataSet
        /// </summary>
        /// <param name="sql">sql command string</param>
        /// <param name="sqlTran">SqlTransaction</param>
        /// <returns>dataSet</returns>
        public DataSet ProcessSelect(string sql, ref SqlTransaction sqlTran)
        {
            DataSet ds = new DataSet();
            SqlCommand SelectCommand = new SqlCommand();
            SelectCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = SelectCommand;
                dataAdapter.SelectCommand.CommandText = sql;
                dataAdapter.SelectCommand.Connection = sqlTran.Connection;
                dataAdapter.SelectCommand.Transaction = sqlTran;
                dataAdapter.Fill(ds, "List");
            }
            catch (Exception ex)
            {
                ex.Message.ToString();
            }
            finally
            {
                //myConnection.Close();
            }
            return ds;
        }

        /// <summary>
        /// MEthod that processes Scalar SQL command which returns only one value as result
        /// </summary>
        /// <param name="sql">sql command string</param>
        /// <returns>Object</returns>        
        public object ProcessScalar(string sql)
        {
            SqlCommand ScalarCommand = new SqlCommand();
            ScalarCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                ScalarCommand.CommandTimeout = 3600;
                ScalarCommand.CommandText = sql;
                ScalarCommand.Connection = myConnection;
                myConnection.Open();
                return ScalarCommand.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                myConnection.Close();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public object ProcessScalar(string sql, ref SqlTransaction sqlTrans)
        {
            SqlCommand ScalarCommand = new SqlCommand();
            ScalarCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                ScalarCommand.CommandText = sql;
                ScalarCommand.Transaction = sqlTrans;
                ScalarCommand.Connection = sqlTrans.Connection;
                return ScalarCommand.ExecuteScalar();
            }
            catch (Exception ex)
            {
                sqlTrans.Rollback();
                throw ex;
            }

        }

        /// <summary>
        /// Method used to get Last ID of recently inserted record
        /// </summary>
        /// <returns>Last ID</returns>
        public int GetLastInsertID()
        {
            string sql = "select isnull(SCOPE_IDENTITY(),1) as LastId";
            DataSet ds = ProcessSelect(sql);
            return Convert.ToInt32(ds.Tables[0].Rows[0][0]);
        }

        /// <summary>
        /// Method Used to get Last ID of recently inserted record of sqlTransaction
        /// </summary>
        /// <param name="sqlTran">SqlTransaction</param>
        /// <returns>Last ID</returns>
        public int GetLastInsertID(ref SqlTransaction sqlTran)
        {
            string sql = "select isnull(SCOPE_IDENTITY(),1) as LastId";
            DataSet ds = ProcessSelect(sql, ref sqlTran);
            return Convert.ToInt32(ds.Tables[0].Rows[0][0]);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="obj">persistence</param>
        /// <returns>"U"=successful Update, 
        /// "D"=unsuccessful Update/Insert due to duplicate entry,
        /// "DS"=delete Successful,
        /// "status"=value from Candelete other than 'Delete' because of which delete is skipped,
        /// "A"=Successful Insertion of new record,
        /// </returns>
        public string Dematerialise(Persistent objPersist)
        {
            SqlTransaction sqlTrans;
            if (objPersist.IsBeginningOfTrans)
            {
                if (objPersist.SqlTrans == null)
                {
                    myConnection.Open();
                    objPersist.SqlTrans = myConnection.BeginTransaction();
                }
                else
                {
                    sqlTrans = (SqlTransaction)objPersist.SqlTrans;
                    if (sqlTrans.Connection == null)
                    {
                        myConnection.Open();
                        objPersist.SqlTrans = myConnection.BeginTransaction();
                    }

                }
            }
            sqlTrans = (SqlTransaction)objPersist.SqlTrans;
            try
            {
                if (objPersist.IsDirty)
                {
                    if (CheckDuplicate(objPersist) == false)
                    {
                        if (objPersist.IsTransactionRequired == false && objPersist.IsBeginningOfTrans == false && objPersist.IsEndOfTrans == false)
                        {
                            ProcessNonQuery(GetUpdateSql(objPersist), objPersist.IsLastIdRequired);
                        }
                        else
                        {
                            ProcessNonQuery(GetUpdateSql(objPersist), objPersist.IsLastIdRequired, ref sqlTrans);
                            if (sqlTrans.Connection == null)
                                return "E";
                        }

                        if (objPersist.IsProxy == false)
                        {
                            objPersist.UnloadObjects();
                        }
                        if (objPersist.IsEndOfTrans == true)
                        {
                            if (sqlTrans.Connection != null)
                                sqlTrans.Commit();
                        }
                        return "U";
                    }
                    else
                    {
                        if (objPersist.IsTransactionRequired == true || objPersist.IsBeginningOfTrans == true || objPersist.IsEndOfTrans == true)
                        {
                            if (sqlTrans.Connection != null)
                                sqlTrans.Rollback();
                        }
                        return "D";
                    }
                }
                else if (objPersist.IsActivated)
                {
                    //IF NEED TO ACTIVATE AND DEACTIVATE THE ENTITY.
                    try
                    {
                        if (objPersist.IsTransactionRequired == false)
                        {
                            CanDeact(objPersist);
                            ProcessNonQuery(GetActivateDeactivateSql(objPersist), objPersist.IsLastIdRequired);
                        }
                        else if (objPersist.IsTransactionRequired)
                        {
                            CanDeact(objPersist, ref sqlTrans);
                            ProcessNonQuery(GetActivateDeactivateSql(objPersist), objPersist.IsLastIdRequired, ref sqlTrans);
                        }
                    }
                    catch (DeactivateNotAllowed de)
                    {
                        return de.Message; //Not Deactivated
                    }
                    return "U";

                }
                else
                {
                    if (objPersist.IsDeleted)
                    {
                        string strMessage = "";
                        bool blnStatus = CanDelete(objPersist, out strMessage);
                        if (blnStatus)
                        {
                            if (objPersist.IsTransactionRequired == false && objPersist.IsBeginningOfTrans == false && objPersist.IsEndOfTrans == false)
                            {
                                ProcessNonQuery(GetDeleteSql(objPersist), objPersist.IsLastIdRequired);
                            }
                            else
                            {
                                ProcessNonQuery(GetDeleteSql(objPersist), objPersist.IsLastIdRequired, ref sqlTrans);
                            }
                            if (objPersist.IsEndOfTrans == true)
                            {
                                if (sqlTrans.Connection != null)
                                    sqlTrans.Commit();
                            }
                            return "DS";
                        }
                        else
                        {
                            objPersist.unlockRecord();
                            return strMessage;
                        }
                    }
                    else
                    {
                        if (CheckDuplicate(objPersist) == false)
                        {
                            int lastId;
                            // this will be useful for non-transactional execution
                            objPersist.IsLastIdRequired = true;
                            if (objPersist.IsBeginningOfTrans == false && objPersist.IsEndOfTrans == false && objPersist.IsTransactionRequired == false)
                            {
                                lastId = ProcessNonQuery(GetInsertSql(objPersist), objPersist.IsLastIdRequired);
                            }
                            else // this will be useful for transactional excution
                            {
                                lastId = ProcessNonQuery(GetInsertSql(objPersist), objPersist.IsLastIdRequired, ref sqlTrans);
                                if (sqlTrans.Connection == null)
                                    return "E";
                            }
                            objPersist.IntCode = lastId;
                            if (objPersist.IsProxy == false)
                            {
                                objPersist.UnloadObjects();
                            }
                            if (objPersist.IsEndOfTrans == true)
                            {
                                if (sqlTrans.Connection != null)
                                    sqlTrans.Commit();
                            }
                            return "A";
                        }
                        else
                        {
                            if (objPersist.IsTransactionRequired == true || objPersist.IsBeginningOfTrans == true || objPersist.IsEndOfTrans == true)
                            {
                                if (sqlTrans.Connection != null)
                                    sqlTrans.Rollback();
                            }
                            return "D";
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                if (sqlTrans != null)
                    if (sqlTrans.Connection != null)
                        sqlTrans.Rollback();
                throw ex;
            }
            finally
            {
                if (objPersist.IsEndOfTrans == true)
                {
                    if (sqlTrans != null)
                        if (sqlTrans.Connection != null)
                        {
                            if (sqlTrans.Connection.State == ConnectionState.Open)
                                sqlTrans.Connection.Close();
                            sqlTrans = null;
                        }
                    if (myConnection.State == ConnectionState.Open)
                    {
                        myConnection.Close();
                    }
                }
            }
        }

        /// <summary>
        /// Method used for execution of Non-Query of SQL
        /// </summary>
        /// <param name="sql">CommandText</param>
        /// <param name="lastIdRequire">Y for required last ID</param>
        /// <returns>lastID</returns>
        protected int ProcessNonQuery(string sql, bool lastIdRequire)
        {
            SqlCommand nonQryCommand = new SqlCommand();
            int lastId = 0;
            try
            {
                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;
                if (myConnection.State == ConnectionState.Closed)
                {
                    myConnection.Open();
                }

                nonQryCommand.Connection = myConnection;
                nonQryCommand.ExecuteNonQuery();
                if (lastIdRequire)
                    lastId = GetLastInsertID();
            }
            finally
            {
                myConnection.Close();
            }
            return lastId;
        }

        protected int ProcessNonQuery(string sql, bool lastIdRequire, SqlTransaction sqlTrans)
        {
            SqlCommand nonQryCommand = new SqlCommand();
            int lastId = 0;
            try
            {
                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;
                nonQryCommand.Transaction = sqlTrans;
                nonQryCommand.Connection = sqlTrans.Connection;
                nonQryCommand.ExecuteNonQuery();
                if (lastIdRequire)
                    lastId = GetLastInsertID();
            }
            catch (Exception ex)
            {
                sqlTrans.Rollback();
                throw ex;
            }
            return lastId;
        }

        public static int ProcessNonQueryDirectly(string sql)
        {
            SqlCommand nonQryCommand = new SqlCommand();
            int countId = 0;
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = GetConnectionStr();
            try
            {
                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;
                if (myConn.State == ConnectionState.Closed)
                {
                    myConn.Open();
                }

                nonQryCommand.Connection = myConn;
                countId = Convert.ToInt32(nonQryCommand.ExecuteNonQuery());
            }
            finally
            {
                myConn.Close();
            }
            return countId;
        }

        public static int ProcessScalarDirectly(string sql)
        {
            SqlConnection myConn = new SqlConnection();
            string strDataBase = strDataBase = "Initial Catalog=" + Convert.ToString(new ParentPage().ObjLoginEntity.DatabaseName);

            //Commneted By Adesh
            //string strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["DatabaseName"];
            //if (GlobalParams.entity_Type == "HV")
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["DatabaseName_HV"];
            //if (GlobalParams.entity_Type.ToString().ToUpper() == ConfigurationManager.AppSettings["RightsU"].ToUpper())
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU"];
            //if (GlobalParams.entity_Type.ToString().ToUpper() == ConfigurationManager.AppSettings["RightsU_VMPL"].ToUpper())
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU_VMPL"];
            //End

            //if (GlobalParams.entity_Type == "RightsU")
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU"];

            //if (GlobalParams.entity_Type == "RightsU_VMPL")
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU_VMPL"];


            //if (GlobalParams.entity_Type.ToString().ToUpper() == "RIGHTSU_VIACOM18")
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU"];
            //if (GlobalParams.entity_Type.ToString().ToUpper() == "RIGHTSU_VMPL_TEST")
            //    strDataBase = "Initial Catalog=" + ConfigurationManager.AppSettings["RightsU_VMPL"];

            CommandTimeoutStatic = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeout"]);
            string strServer = "Data Source=" + ConfigurationManager.AppSettings["DataServer"];
            string strUserId = "User Id=" + ConfigurationManager.AppSettings["UserId"];
            string strPassword = " Password=" + ConfigurationManager.AppSettings["Password"];
            string StrTimeOut = " Connection Timeout =" + ConfigurationManager.AppSettings["TimeOut"];
            string strConnectionString = strServer + ";" + strDataBase + ";" + strUserId + ";" + strPassword + ";" + StrTimeOut;
            myConn.ConnectionString = strConnectionString;
            DataSet ds = new DataSet();
            SqlCommand ScalarCommand = new SqlCommand();
            ScalarCommand.CommandTimeout = CommandTimeoutStatic;
            try
            {
                ScalarCommand.CommandText = sql;
                ScalarCommand.Connection = myConn;
                myConn.Open();
                return Convert.ToInt32(ScalarCommand.ExecuteScalar());
            }
            catch
            {
                return -1;
            }
            finally
            {
                myConn.Close();
            }
        }
        /// <summary>
        /// Method used for execution of Non-Query Transaction of SQL.
        /// </summary>
        /// <param name="sql">CommandText</param>
        /// <param name="lastIdRequire">Y for required last ID</param>
        /// <param name="sqlTran">SqlTransaction</param>
        /// <returns>lastId</returns>
        protected int ProcessNonQuery(string sql, bool lastIdRequire, ref SqlTransaction sqlTran)
        {
            SqlCommand nonQryCommand = new SqlCommand();
            nonQryCommand.CommandTimeout = CommandTimeoutStatic;
            int lastId = 0;
            try
            {
                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;
                nonQryCommand.Connection = sqlTran.Connection;
                nonQryCommand.Transaction = sqlTran;
                nonQryCommand.ExecuteNonQuery();
                if (lastIdRequire)
                    lastId = GetLastInsertID(ref sqlTran);
            }
            catch (Exception ex)
            {
                sqlTran.Rollback();
                throw ex;
            }
            return lastId;
        }

        public virtual void CanDeact(Persistent objPersist, ref SqlTransaction sqlTrans)
        {
            //       do nothing
        }
        public virtual void CanDeact(Persistent objPersist)
        {
            //       do nothing
        }

        /// <summary>
        /// Method Added For Uploading And Validation
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        protected System.Data.SqlClient.SqlDataReader ProcessReader(string sql)
        {
            SqlCommand nonQryCommand = new SqlCommand();
            System.Data.SqlClient.SqlDataReader rd;
            try
            {

                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;

                if (myConnection.State == ConnectionState.Closed)
                {
                    myConnection.Open();
                }
                nonQryCommand.Connection = myConnection;
                rd = nonQryCommand.ExecuteReader(CommandBehavior.CloseConnection);
                //	myConnection.Close();
                return rd;
            }
            catch (Exception ex)
            {
                string err = ex.Message;
                return null;
            }
        }
        protected static void ExecuteScalar(string sql, out int getId)
        {
            getId = 0;
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = GetConnectionStr();

            SqlCommand nonQryCommand = new SqlCommand();

            try
            {

                nonQryCommand.CommandType = CommandType.Text;
                nonQryCommand.CommandText = sql;

                if (myConn.State == ConnectionState.Closed)
                {
                    myConn.Open();
                }
                nonQryCommand.Connection = myConn;
                getId = (int)nonQryCommand.ExecuteScalar();
                myConn.Close();
            }
            catch (Exception ex)
            {
                string err = ex.Message;
            }
        }


        public static ArrayList ExecSP(string spName, ArrayList arrParam)
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = GetConnectionStr();

            SqlCommand cmdForSP = new SqlCommand(spName, myConn);
            cmdForSP.CommandType = CommandType.StoredProcedure;

            foreach (AttribValue av in arrParam)
            {
                cmdForSP.Parameters.Add(new SqlParameter(av.Attrib.ToString(), av.Val.ToString()));
            }
            SqlDataReader dr;
            myConn.Open();
            dr = cmdForSP.ExecuteReader();
            int numOfFlds = dr.VisibleFieldCount;

            ArrayList arrTbl = new ArrayList();
            ArrayList arrRow = null;
            while (dr.Read())
            {
                arrRow = new ArrayList();
                for (int i = 0; i < numOfFlds; i++)
                {
                    arrRow.Add(dr.GetValue(i));
                }
                arrTbl.Add(arrRow);
            }
            dr.Close();
            myConn.Close();
            return arrTbl;
        }

        public static DataSet ExecSPDS(string spName, ArrayList arrParam)
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = GetConnectionStr();

            DataSet ds = new DataSet();
            SqlCommand SelectCommand = new SqlCommand();
            SelectCommand.CommandTimeout = CommandTimeoutStatic;
            foreach (AttribValue av in arrParam)
            {
                SelectCommand.Parameters.Add(new SqlParameter(av.Attrib.ToString(), av.Val.ToString()));
            }
            try
            {
                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                dataAdapter.SelectCommand = SelectCommand;
                dataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                dataAdapter.SelectCommand.CommandText = spName;
                dataAdapter.SelectCommand.Connection = myConn;
                dataAdapter.Fill(ds, "List");
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                myConn.Close();
            }
            return ds;
        }

        public virtual string getRecordStatus(Persistent objPersist)
        {
            return null;
        }

        public virtual string getRecordStatus(Persistent objPersist, out int UserIntcode)
        {
            UserIntcode = 0;
            return null;
        }


        public virtual void unlockRecord(Persistent objPersist)
        {
        }

        public virtual void refreshRecord(Persistent objPersist)
        {
        }

    }
    #endregion

    #region=======Criteria================
    public class Criteria
    {
        public bool IsSubClassRequired = false;
        private bool _isPagingRequired = false;
        private bool _isCountRequired = false;
        public Persistent ClassRef;
        public object ObjBroker;
        private int _intRecordsPerPage = 10;
        private int _intPageNo = 1;
        private int _intRecordCount;
        private int _intPagesPerBatch = 5;

        public Criteria()
            : base()
        {

        }
        public Criteria(Persistent pRef)
            : this()
        {
            ClassRef = pRef;
        }

        public int PagesPerBatch
        {
            get
            {
                return this._intPagesPerBatch;
            }
            set
            {
                this._intPagesPerBatch = value;
            }
        }

        public ArrayList Execute(string searchString)
        {
            DatabaseBroker objDBbroker;
            objDBbroker = this.ClassRef.GetBroker();
            if (this.IsCountRequired)
            {
                return objDBbroker.MaterialiseCount(this, searchString);
            }
            else
            {
                return objDBbroker.MaterialiseList(this, searchString);
            }
        }

        public bool IsCountRequired
        {
            get
            {
                return this._isCountRequired;
            }
            set
            {
                this._isCountRequired = value;
            }
        }
        public int PageNo
        {
            get
            {
                return this._intPageNo;
            }
            set
            {
                this._intPageNo = value;
            }
        }
        public int RecordPerPage
        {
            get
            {
                return this._intRecordsPerPage;
            }
            set
            {
                this._intRecordsPerPage = value;
            }
        }
        public int RecordCount
        {

            get
            {
                return this._intRecordCount;
            }
            set
            {
                this._intRecordCount = value;
            }
        }

        public bool IsPagingRequired
        {
            get
            {
                return this._isPagingRequired;
            }
            set
            {
                this._isPagingRequired = value;
            }
        }

        public int GetPagingP1()
        {
            int p1 = this.RecordPerPage;
            int p2 = GetPagingP2();
            if (p2 > this.RecordCount)
            {
                p1 = p1 - (p2 - this.RecordCount);
            }
            if (p1 <= 0)
            {
                p1 = this.RecordPerPage < this.RecordCount ? this.RecordPerPage : this.RecordCount;
            }
            return p1;
        }

        public int GetPagingP2()
        {
            if (this.PageNo == 1)
            {
                return this.RecordPerPage;
            }
            return this.RecordPerPage * this.PageNo;
        }

        public ArrayList ValidateUser(string userName, string password)
        {
            return new ArrayList();
        }

        public string getPagingSQL(string sql)
        {

            int p1 = this.GetPagingP1();

            int p2 = this.GetPagingP2();

            string sqlOut = "select * from ( Select Top " + p1 + " * From (Select Top " + p2 + " * from ( " + sql + ") as a2 Order By " + this.getASCstr()

            + ") As a1 Order By " + this.getDESCstr()

            + " ) as a3 Order By " + this.getASCstr();

            return sqlOut;
        }

        public string getASCstr()
        {

            return getOrdByInsertedStr(this.ClassRef.OrderByColumnName, this.ClassRef.OrderByCondition);

        }

        public string getDESCstr()
        {
            return getOrdByInsertedStr(this.ClassRef.OrderByColumnName, this.ClassRef.OrderByReverseCondition);
        }

        private string getOrdByInsertedStr(string colCSV, string theOrder)
        {
            string tmp = ",";
            if (colCSV.IndexOf(tmp) > 0)
            {
                string retStr = colCSV.Replace(tmp, " " + theOrder + tmp);
                retStr = retStr + " " + theOrder;
                return retStr;
            }
            return colCSV + " " + theOrder;
        }

        public void pageSetup(int pageNo)
        {
            this.IsPagingRequired = true;

            this.RecordPerPage = 10;

            int intPages = Convert.ToInt32(Math.Floor(Convert.ToDouble((this.RecordCount - 1) / this.RecordPerPage)));
            int totalPages = intPages + 1;

            int pg = pageNo;
            if (pg > totalPages)
                pg = totalPages;

            this.PageNo = (pg > 0 ? pg : 1);
        }

        public ArrayList getList(string searchString)
        {
            this.IsPagingRequired = false;
            this.IsCountRequired = false;
            return this.Execute(searchString);
        }

        public ArrayList getListForActiveDeactive(string searchString)
        {
            this.IsPagingRequired = true; ;
            this.IsCountRequired = false;
            return this.Execute(searchString);
        }

    }
    #endregion

    #region=======DeactivateNotAllowed====
    /// <summary>
    /// Summary description for DeactivateNotAllowed
    /// </summary>
    public class DeactivateNotAllowed : Exception
    {
        public DeactivateNotAllowed()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public DeactivateNotAllowed(string msg)
            : base(msg)
        {
        }
    }
    #endregion

    #region======DuplicateRecordException=
    /// <summary>
    /// Summary description for DuplicateRecord
    /// </summary>
    public class DuplicateRecordException : Exception
    {
        private DuplicateRecordException()
        {
        }
        public DuplicateRecordException(string msg)
            : base(msg)
        {
        }
    }
    #endregion

    #region======RecordNotFoundException==
    /// <summary>
    /// Summary description for RecordNotFound
    /// </summary>
    public class RecordNotFoundException : Exception
    {
        public RecordNotFoundException()
        {
            //do nothing
        }
        public RecordNotFoundException(string msg)
            : base(msg)
        {
            //do nothing
        }
    }
    #endregion

    #region ================ Mail Sending Failed ==============

    public class MailSendingFailed : Exception
    {
        public MailSendingFailed()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        public MailSendingFailed(string msg)
            : base(msg)
        {
        }
    }

    #endregion

    #region ===== AttribValue ========
    public class AttribValue
    {
        /// <summary>
        /// Summary description for AttribValue.
        /// </summary>
        private Object _attribVal;
        private Object _valueVal;

        public Object Attrib
        {
            get
            {
                return _attribVal;
            }
            set
            {
                _attribVal = value;
            }

        }
        public Object Val
        {
            get
            {
                return _valueVal;
            }
            set
            {
                _valueVal = value;
            }
        }
        public AttribValue(Object a, Object v)
        {
            Attrib = a;
            Val = v;
        }
    }
    #endregion

    #region======AttribValueExcelUpload==============
    /// <summary>
    /// Summary description for AttribValue.
    /// </summary>
    public class AttribValueExcelUpload
    {
        private Object _attribVal;
        private Object _valueVal;

        public Object Attrib
        {
            get
            {
                return _attribVal;
            }
            set
            {
                _attribVal = value;
            }

        }
        public Object Val
        {
            get
            {
                return _valueVal;
            }
            set
            {
                _valueVal = value;
            }
        }
        public bool _isValidationRequired;
        public bool _isMandatory;
        public bool _isSkipValidationCharPresent;
        public string _strSkipValidationCharPresentValue;
        public string _strSkipValidationCharToBeReplacedWithValue;
        public bool _isNumericValidation;
        public bool _isDecimalValidation;
        public double _maxNumberValue;
        public bool _isDateValidation;
        public string _getDateFormatCode;
        public int _maxLength;
        public bool _isCheckFromDataBaseOnIDValidationRequired;
        public string _columnToBeSelected;
        public string _forWhichDBTable;
        public string _checkFromDataBaseOnIDValidationValue;
        public string _frmTitle, _downloadSampleFile, _excelFileFormat, _fileFor;
        public string _searchStringForSql;
        public object _classForUploadInterface;
        /// <summary>
        /// It sets validation attributes for Excel Upload Module for a cell of excel sheet.
        /// </summary>
        /// <param name="a">Simple Text of Excel Header. i.e. "First Name"</param>
        /// <param name="v">value of "a" with all spaces removed and in Upper Case. i.e. "FIRSTNAME"</param>
        /// <param name="isValidationRequired">If valiadation Required for this excel cell? i.e. true=Validation Required & false=Validation Not Required</param>
        /// <param name="isSkipValidationCharPresent">Is any character or string to be considered in excel cell as Skip Validation? i.e. If "-" is present for numeric cell, we need to skip it.</param>
        /// <param name="strSkipValidationCharPresentValue">If isSkipValidationCharPresent=true then, the value of char or string has to be considered for skip. i.e. "-"</param>
        /// <param name="strSkipValidationCharToBeReplacedWithValue">If isSkipValidationCharPresent=true then, the value to be replaced for strSkipValidationCharPresentValue. i.e. "0" should be replaced for strSkipValidationCharPresentValue as "-"</param>
        /// <param name="isNumericValidation">Is Numeric Validation Required? i.e. true=Numeric Validation Required & false=Numeric Validation Not Required</param>
        /// <param name="isDecimalValidation">Is Decimal Validation Required? i.e. true=Decimal Validation Required & false=Decimal Validation Not Required. i.e. for numeric values as "10.344" we should set isDecimalValidation=true</param>
        /// <param name="maxNumberValue">What is maximum possible Numeric Value?</param>
        /// <param name="isDateValidation">Is Date Validation Required? i.e. true=Date Validation Required or false=Date Validation Not Required. Note:If there is numeric validation then no date validation is possible.</param>
        /// <param name="dateFormatCode">Set date format here. i.e. "dd-mm-yyyy"   Note:You need to write appropriate code in the method isDateFormatCorrect() of "ExcelReader.cs" class, if there is no code which converts your date in "mm/dd/yyyy" format.</param>
        /// <param name="maxLength">It sets maximum length of any string in excel sheet cell other than "isNumericValidation" is set as "true".</param>
        /// <param name="isCheckFromDataBaseOnIDValidationRequired">Is check for excel sheet cell data from database table required? i.e. true=Validation from database required or false=Validation from database not required.</param>
        /// <param name="columnToBeSelected">Which column to be selected from database tabel? i.e. if our select is like "select [dbTableCodeColumnNameToBeSelected] from [dbTableName] where [dbTableIDColumnNameForSearch]='[dbTableIDColumnNameValue]' [searchStringForSql]" then, in this dbTableCodeColumnNameToBeSelected=[dbTableCodeColumnNameToBeSelected] </param>
        /// <param name="forWhichDBTable">From which database table to be selected? i.e. if our select is like "select [dbTableCodeColumnNameToBeSelected] from [dbTableName] where [dbTableIDColumnNameForSearch]='[dbTableIDColumnNameValue]' [searchStringForSql]" then, in this forWhichDBTable=[dbTableName]</param>
        /// <param name="checkFromDataBaseOnIDValidationValue">On which select criteria from database tabel? i.e. if our select is like "select [dbTableCodeColumnNameToBeSelected] from [dbTableName] where [dbTableIDColumnNameForSearch]='[dbTableIDColumnNameValue]' [searchStringForSql]" then, in this checkFromDataBaseOnIDValidationValue=[dbTableIDColumnNameValue]</param>
        /// <param name="searchStringForSql">On which select statement search criteria (Note:search string should be like " and requiredCode>0 ")? i.e. if our select is like "select [dbTableCodeColumnNameToBeSelected] from [dbTableName] where [dbTableIDColumnNameForSearch]='[dbTableIDColumnNameValue]' [searchStringForSql]" then, in this searchStringForSql=[searchStringForSql]</param>
        public AttribValueExcelUpload(Object a, Object v, bool isValidationRequired, bool isMandatory, bool isSkipValidationCharPresent, string strSkipValidationCharPresentValue, string strSkipValidationCharToBeReplacedWithValue, bool isNumericValidation, bool isDecimalValidation, double maxNumberValue, bool isDateValidation, string dateFormatCode, int maxLength, bool isCheckFromDataBaseOnIDValidationRequired, string columnToBeSelected, string forWhichDBTable, string checkFromDataBaseOnIDValidationValue, string searchStringForSql)
        {
            Attrib = a;
            Val = v;
            _isValidationRequired = isValidationRequired;
            _isMandatory = isMandatory;
            _isSkipValidationCharPresent = isSkipValidationCharPresent;
            _strSkipValidationCharPresentValue = strSkipValidationCharPresentValue;
            _strSkipValidationCharToBeReplacedWithValue = strSkipValidationCharToBeReplacedWithValue;
            _isNumericValidation = isNumericValidation;
            _isDecimalValidation = isDecimalValidation;
            _maxNumberValue = maxNumberValue;
            _isDateValidation = isDateValidation;
            _getDateFormatCode = dateFormatCode;
            _maxLength = maxLength;
            _isCheckFromDataBaseOnIDValidationRequired = isCheckFromDataBaseOnIDValidationRequired;
            _columnToBeSelected = columnToBeSelected;
            _forWhichDBTable = forWhichDBTable;
            _checkFromDataBaseOnIDValidationValue = checkFromDataBaseOnIDValidationValue;
            _searchStringForSql = searchStringForSql;
        }
        public AttribValueExcelUpload(string frmTitleIn, string downloadSampleFileIn, string excelFileFormatIn, string fileFor, object classForUploadInterface)
        {
            _frmTitle = frmTitleIn;
            _downloadSampleFile = downloadSampleFileIn;
            _excelFileFormat = excelFileFormatIn;
            _fileFor = fileFor;
            _classForUploadInterface = classForUploadInterface;
        }
        public AttribValueExcelUpload(Object a, Object v)
        {
            Attrib = a;
            Val = v;
        }
    }
    #endregion

    #region ==================== DBUTIL ==============

    public class DBUtil
    {
        public const string RECORD_ADDED = "A";
        public const string RECORD_UPDATED = "U";
        public const string RECORD_DELETED = "DS";
        public const string RECORD_DUPLICATE = "D";

        public const string RECORD_STATUS_CHANGED = "C";
        public const string RECORD_STATUS_LOCKED = "L";
        public const string RECORD_STATUS_DELETED = "D";
        public const string RECORD_STATUS_UPDATABLE = "U";

        public static void BindList(ref ListBox lst, Persistent obj, string strFilter, string DataTextField, string DataValueField)
        {
            BindList(ref lst, obj, strFilter, DataTextField, DataValueField, false);
        }

        public static string GetSystemParameterValue(string parameterName)
        {
            parameterName = parameterName.Trim();
            string strQuery = "select parameter_value from system_parameter_new where parameter_name = '" + parameterName + "'";
            string parameterValue = DatabaseBroker.ProcessScalarReturnString(strQuery);
            if (parameterValue.Trim().ToUpper().Equals("ERROR"))
                parameterValue = "";

            return parameterValue;
        }
        public static void BindList(ref ListBox lst, Persistent obj, string strFilter, string DataTextField, string DataValueField, bool IsSubClassReq)
        {
            Criteria objC = new Criteria();
            objC.ClassRef = obj;
            objC.IsSubClassRequired = IsSubClassReq;
            ArrayList arr = objC.Execute(strFilter);
            if (arr.Count > 0)
            {
                lst.DataSource = arr;
                lst.DataTextField = DataTextField;
                lst.DataValueField = DataValueField;
                lst.DataBind();
                foreach (ListItem li in lst.Items)
                {
                    li.Attributes.Add("Title", li.Text);
                }

            }
            else
            {

                lst.DataSource = "";
                lst.DataTextField = DataTextField;
                lst.DataValueField = DataValueField;
                lst.DataBind();

            }
        }
        public static void BindDropDownList(ref System.Web.UI.WebControls.DropDownList ddl, Persistent obj, string strFilter, string DataTextField, string DataValueField, bool IsSelect, string Name)
        {
            Criteria objC = new Criteria();
            objC.ClassRef = obj;
            ArrayList arr = objC.Execute(strFilter);
            ddl.DataSource = arr;
            ddl.DataTextField = DataTextField;
            ddl.DataValueField = DataValueField;
            if (arr.Count > 0)
            {
                ddl.DataBind();
            }
            if (IsSelect)
            {
                string str = "- - - Please Select " + Name + " - - -";
                ddl.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
            }
            AddToolTipforDDL(ref ddl);
        }
        public static void BindRadioButtonList(ref System.Web.UI.WebControls.RadioButtonList rdoBtnList, Persistent obj, string strFilter, string DataTextField, string DataValueField)
        {
            BindRadioButtonList(ref rdoBtnList, obj, strFilter, DataTextField, DataValueField, false);
        }
        public static void BindRadioButtonList(ref System.Web.UI.WebControls.RadioButtonList rdoBtnList, Persistent obj, string strFilter, string DataTextField, string DataValueField, bool isOtherReq)
        {
            Criteria objC = new Criteria();
            objC.ClassRef = obj;
            ArrayList arr = objC.Execute(strFilter);
            if (isOtherReq)
            {
                DealType objDealType = new DealType("Other", -1);
                arr.Add(objDealType);
            }
            rdoBtnList.DataSource = arr;
            rdoBtnList.DataTextField = DataTextField;
            rdoBtnList.DataValueField = DataValueField;
            rdoBtnList.DataBind();

        }
        public static void BindDropDownList(ref System.Web.UI.WebControls.DropDownList ddl, Persistent obj, string strFilter, string DataTextField, string DataValueField, bool IsSelect, string Name, bool isSubclassReq)
        {
            Criteria objC = new Criteria();
            objC.ClassRef = obj;
            objC.IsSubClassRequired = isSubclassReq;
            ArrayList arr = objC.Execute(strFilter);
            ddl.DataSource = arr;
            ddl.DataTextField = DataTextField;
            ddl.DataValueField = DataValueField;
            ddl.DataBind();
            if (IsSelect)
            {
                string str = "- - - Please Select " + Name + " - - -";
                ddl.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
            }
            AddToolTipforDDL(ref ddl);
        }
        //anita
        //public static void BindDropDownList(ref Anthem.DropDownList ddl, Persistent obj, string strFilter, string DataTextField, string DataValueField, bool IsSelect, string Name)
        //{
        //    Criteria objC = new Criteria();
        //    objC.ClassRef = obj;
        //    ArrayList arr = objC.Execute(strFilter);
        //    ddl.DataSource = arr;
        //    ddl.DataTextField = DataTextField;
        //    ddl.DataValueField = DataValueField;
        //    ddl.DataBind();
        //    if (IsSelect)
        //    {
        //        string str = "- - - Please Select " + Name + " - - -";
        //        ddl.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
        //    }
        //    AddToolTipforDDL(ref ddl);
        //}

        //public static void BindDropDownList(ref Anthem.DropDownList ddl, Persistent obj, string strFilter, string DataTextField, string DataValueField, bool IsSelect, string Name, bool isSubclassReq)
        //{
        //    Criteria objC = new Criteria();
        //    objC.ClassRef = obj;
        //    objC.IsSubClassRequired = isSubclassReq;
        //    ArrayList arr = objC.Execute(strFilter);
        //    ddl.DataSource = arr;
        //    ddl.DataTextField = DataTextField;
        //    ddl.DataValueField = DataValueField;
        //    ddl.DataBind();
        //    if (IsSelect)
        //    {
        //        string str = "- - - Please Select " + Name + " - - -";
        //        ddl.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
        //    }
        //    AddToolTipforDDL(ref ddl);
        //}
        ////

        //public static void BindDropDownListForHrs(ref System.Web.UI.WebControls.DropDownList ddl)
        //{
        //    ArrayList arrHH = new ArrayList();
        //    string str = "";
        //    for (int i = 0; i < 24; i++)
        //    {
        //        if (i < 10)
        //        {
        //            str = "0" + i.ToString();
        //            arrHH.Add(str);
        //        }
        //        else
        //        {
        //            arrHH.Add(i.ToString());
        //        }
        //    }
        //    ddl.DataValueField = "";
        //    ddl.DataTextField = "";

        //    ddl.DataSource = arrHH;
        //    ddl.DataBind();

        //}
        //public static void GetListOfHours(ref DropDownList ddl)
        //{
        //    string str = "";
        //    for (int i = 0; i <= 24; i++)
        //    {
        //        str = i.ToString();
        //        if (i < 10)
        //        {
        //            str = "0" + i.ToString();
        //        }
        //        ddl.Items.Add(new ListItem(str, str));
        //    }
        //}

        //public static void BindDropDownListForMinutes(ref System.Web.UI.WebControls.DropDownList ddl)
        //{
        //    ArrayList arrMM = new ArrayList();
        //    string str = "";
        //    for (int i = 0; i <= 30; i++)
        //    {
        //        if (i < 10)
        //        {
        //            str = "0" + i.ToString();
        //            arrMM.Add(str);
        //        }
        //        else
        //        {
        //            arrMM.Add(i.ToString());
        //        }
        //    }
        //    ddl.DataSource = arrMM;
        //    ddl.DataBind();

        //}
        public static void BindCheckBoxList(ref System.Web.UI.WebControls.CheckBoxList chbList, Persistent obj, string strFilter, string DataTextField, string DataValueField)
        {
            Criteria objC = new Criteria();
            objC.ClassRef = obj;
            ArrayList arr = objC.Execute(strFilter);
            chbList.DataSource = arr;
            chbList.DataTextField = DataTextField;
            chbList.DataValueField = DataValueField;
            chbList.DataBind();
        }
        //Added by Adesh for DropDownList ToolTip code to support to IE7 and letter version of IE

        public static void AddToolTipforDDL(ref System.Web.UI.WebControls.DropDownList ddl)
        {
            foreach (System.Web.UI.WebControls.ListItem li in ddl.Items)
            {
                li.Attributes.Add("title", li.Text);
            }
        }
        //public static void AddToolTipforDDL(ref Anthem.DropDownList ddl)
        //{
        //    foreach (System.Web.UI.WebControls.ListItem li in ddl.Items)
        //    {
        //        li.Attributes.Add("title", li.Text);
        //    }
        //}

        public static DateTime getServerDate()
        {
            string sql = "select getDate()";
            return Convert.ToDateTime(ProcessScalar(sql));
        }

        public static object ProcessScalar(string sql)
        {
            SqlConnection sqlCon = DatabaseBroker.GetSqlConnection();
            SqlCommand sqlCmd = new SqlCommand(sql, sqlCon);
            try
            {
                sqlCon.Open();
                return sqlCmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                sqlCon.Close();
            }
        }


        public static void AddDummyRowIfDataSourceEmpty(System.Web.UI.WebControls.GridView objGridView, object obj)
        {
            if (objGridView.Rows.Count == 0)
            {
                ArrayList arr = new ArrayList();
                arr.Add(obj);
                objGridView.DataSource = arr;
                objGridView.DataBind();
                objGridView.Rows[0].Visible = false;
            }
        }

        public static void BindGirdView(ref GridView gv, Criteria objCrt, string strFilter, ref Label lblTotal, int pageNo, ref DataList dtLst)
        {
            ArrayList arr = new ArrayList();
            ArrayList arrDtLst = new ArrayList();
            if (objCrt.IsPagingRequired)
            {
                int maxPages, RecordCount;
                arrDtLst = GlobalUtil.getArrBatchWisePaging(objCrt.ClassRef, strFilter, objCrt.RecordPerPage, objCrt.PagesPerBatch, lblTotal, pageNo, out maxPages, out RecordCount);
                dtLst.DataSource = arrDtLst;
                dtLst.DataBind();

                if (maxPages < pageNo)
                {
                    pageNo = maxPages;
                }
                objCrt.PageNo = pageNo;
                objCrt.RecordCount = RecordCount;
                arr = objCrt.Execute(strFilter);
                gv.DataSource = arr;
                gv.DataBind();
            }
            else
            {
                arr = objCrt.Execute(strFilter);
                gv.DataSource = arr;
                gv.DataBind();
            }
        }

        public static void BindDropDownListForChannel(ref System.Web.UI.WebControls.DropDownList ddl, ArrayList arrayList, string DataTextField, string DataValueField, bool IsSelect, string Name)
        {
            ddl.DataSource = arrayList;
            ddl.DataTextField = DataTextField;
            ddl.DataValueField = DataValueField;
            ddl.DataBind();
            if (IsSelect)
            {
                string str = "- - Please Select " + Name + " - -";
                ddl.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
            }
            AddToolTipforDDL(ref ddl);
        }

        //public static void BindDropDownListForChannel(ref Anthem.DropDownList ddl, ArrayList arrayList, string DataTextField, string DataValueField, bool IsSelect, string Name)
        //{
        //    ddl.DataSource = arrayList;
        //    ddl.DataTextField = DataTextField;
        //    ddl.DataValueField = DataValueField;
        //    ddl.DataBind();
        //    if (IsSelect)
        //    {
        //        string str = "- - Please Select " + Name + " - -";
        //        ddl.Items.Insert(0, new System.Web.UI.WebControls.ListItem(str, "0"));
        //    }
        //    AddToolTipforDDL(ref ddl);
        //}

        public static SqlTransaction DeleteChild(string strClassName, ArrayList arr, int parentCode, SqlTransaction sqlTrans)
        {
            Persistent objPFirst = (Persistent)GlobalParams.createInstance(strClassName);
            objPFirst = (Persistent)arr[0];
            objPFirst.IsTransactionRequired = true;
            if (sqlTrans == null)
                objPFirst.IsBeginningOfTrans = true;
            else
                objPFirst.SqlTrans = sqlTrans;
            objPFirst.IsDeleted = true;
            try
            {
                objPFirst.Save();
            }
            catch (SqlException ex)
            {
                throw ex;
            }
            if (arr.Count > 1)
            {
                Persistent objP = (Persistent)GlobalParams.createInstance(strClassName);
                for (int i = 1; i < arr.Count; i++)
                {
                    objP = (Persistent)arr[i];
                    objP.SqlTrans = objPFirst.SqlTrans;
                    objP.IsTransactionRequired = true;
                    objP.IsDeleted = true;
                    objP.Save();
                }
            }
            return (SqlTransaction)objPFirst.SqlTrans;
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

        public static void FillArrayList(Persistent Obj, string strSearch, bool isSubClassReq, ArrayList destArrayList)
        {
            ArrayList arrFilledObject;
            Criteria ObjCri = new Criteria(Obj);
            ObjCri.IsPagingRequired = false;
            ObjCri.IsSubClassRequired = isSubClassReq;
            arrFilledObject = ObjCri.Execute(strSearch);
            foreach (object o in arrFilledObject)
            {
                destArrayList.Add(o);
            }
        }


        public static string GetRecordStatus(SqlConnection myConnection, Persistent obj, string tableName, string primaryKeyColumnName, out int UserIntcode)
        {//, string errMsg, string addOnSql) { 
            string strSql;
            int TimeDiffForLock = Convert.ToInt32(GlobalParams.timeDiffForLock);
            strSql = "SELECT lock_time, last_updated_time, isNUll(datediff(ss,lock_time,getdate()),500) TimeDiff, Last_Action_By FROM " + tableName + " WHERE " + primaryKeyColumnName + " = " + obj.IntCode;

            DataSet dsRecord = new DataSet();
            dsRecord = GetDataSetForSQL(myConnection, strSql);
            string returnString;

            if (dsRecord.Tables[0].Rows.Count <= 0)
            {
                UserIntcode = 0;
                return RECORD_STATUS_DELETED;
            }
            else if (obj.LastUpdatedTime != dsRecord.Tables[0].Rows[0]["last_updated_time"].ToString())
            {
                returnString = RECORD_STATUS_CHANGED;
            }
            else if (Convert.ToInt32(dsRecord.Tables[0].Rows[0]["TimeDiff"]) < TimeDiffForLock)
            {
                returnString = RECORD_STATUS_LOCKED;
            }
            else
            {

                string strUpdate = "UPDATE " + tableName + " SET lock_time=getdate(), Last_Action_By=" + obj.LastActionBy + " WHERE " + primaryKeyColumnName + " = " + obj.IntCode;
                ProcessNonQuery(myConnection, strUpdate);
                returnString = RECORD_STATUS_UPDATABLE;
            }

            if (dsRecord.Tables[0].Rows[0]["Last_Action_By"] == DBNull.Value)
                UserIntcode = obj.LastActionBy;
            else
                UserIntcode = Convert.ToInt32(dsRecord.Tables[0].Rows[0]["Last_Action_By"]);

            return returnString;
        }

        public static DataSet GetDataSetForSQL(SqlConnection myConnection, string Sql)
        {
            SqlDataAdapter da = new SqlDataAdapter(Sql, myConnection);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }

        public static void ProcessNonQuery(SqlConnection myConnection, string Sql)
        {
            try
            {
                if (myConnection.State == ConnectionState.Closed)
                {
                    myConnection.Open();
                }
                SqlCommand cmd = new SqlCommand(Sql, myConnection);
                cmd.ExecuteNonQuery();
            }
            finally
            {
                myConnection.Close();
            }
        }

        public static void RefreshOrUnlockRecord(SqlConnection myConnection, Persistent obj, string tableName, string primaryKeyColumnName, bool IsRefresh)
        {
            string strSql;
            strSql = "UPDATE " + tableName + " SET lock_time = " + (IsRefresh ? "getdate()" : "null") + " WHERE " + primaryKeyColumnName + "=" + obj.IntCode;
            ProcessNonQuery(myConnection, strSql);
        }
        public static bool HasRecords(SqlConnection conn, string tabName, string colName, string colValue)
        {
            string sql;
            sql = "select count(*) as c from " + tabName + " where " + colName + " = '" + colValue + "'";
            return GetCountForSQL(conn, sql) > 0;
        }

        public static int GetCountForSQL(SqlConnection myConnection, string Sql)
        {
            int retVal = -1;
            myConnection.Open();
            SqlDataReader dr = new SqlCommand(Sql, myConnection).ExecuteReader();
            if (dr.HasRows)
            {
                dr.Read();
                retVal = Convert.ToInt16(dr[0]);
            }
            myConnection.Close();

            return retVal;
        }
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
        //-----------------------------------
        public static void alertNadRedirect(Page senderPage, string alertMsg, string alertKey, string strURL)
        {
            alertMsg = alertMsg.Replace("'", "\'");
            string strScript = "<script language=JavaScript>function AlertNadRedirect(){ alert(\"" + alertMsg + "\");"
                + " window.location = '" + strURL + "';} AlertNadRedirect();</script>";
            if (!senderPage.ClientScript.IsStartupScriptRegistered(alertKey))
            {
                senderPage.ClientScript.RegisterStartupScript(senderPage.GetType(), alertKey, strScript);
            }
        }

        public static int GetMonthBetweenDates(string rightStartDate, string rightEndDate)
        {
            string startDate, endDate;
            startDate = GlobalUtil.MakedateFormat(rightStartDate);
            endDate = GlobalUtil.MakedateFormat(rightEndDate);
            endDate = Convert.ToDateTime(endDate).AddDays(1).ToString("dd-MMM-yyyy");
            string strQuery = "Select DATEDIFF(MM, '" + startDate + "', '" + endDate + "')";
            int totalMonth = DatabaseBroker.ProcessScalarDirectly(strQuery);

            return totalMonth;
        }
        public static AjaxControlToolkit.CascadingDropDownNameValue[] GetItemsForCascadingDropDownWebMethod(string knownCategoryValues, Persistent objPer, string bindPropertyNameText, string bindPropertyNameValue, string strParentCategory, string strParentFieldName, bool isSelectActiveOnly, string SearchString)
        {
            // Get a dictionary of known category/value pairs
            StringDictionary kv = CascadingDropDown.ParseKnownCategoryValuesString(knownCategoryValues);

            ArrayList arr = new ArrayList();
            List<CascadingDropDownNameValue> values = new List<CascadingDropDownNameValue>();
            if (strParentFieldName != "")
            {
                string strParentFieldValue = kv[strParentCategory];
                Type t = objPer.GetType();
                PropertyInfo pi = t.GetProperty(strParentFieldName);
                if (strParentFieldValue != null && strParentFieldValue != "" && pi != null)
                {
                    Persistent objP = (Persistent)pi.GetValue(objPer, null);
                    objP.IntCode = Convert.ToInt32(strParentFieldValue);
                    pi.SetValue(objPer, objP, null);
                }
            }
            arr = new Criteria(objPer).Execute(SearchString);
            foreach (Persistent objP in arr)
            {
                string val = "", text = "";
                Type t = objP.GetType();
                PropertyInfo pi = t.GetProperty(bindPropertyNameValue);
                if (pi != null)
                {
                    val = pi.GetValue(objP, null).ToString();
                }
                pi = t.GetProperty(bindPropertyNameText);
                if (pi != null)
                {
                    text = pi.GetValue(objP, null).ToString();
                }
                values.Add(new CascadingDropDownNameValue(text, val));
            }
            return values.ToArray();
        }


        public static object ProcessScalar(string sql, ref SqlTransaction sqlTrans)
        {
            SqlConnection sqlCon = sqlTrans.Connection;
            SqlCommand sqlCmd = new SqlCommand(sql, sqlCon, sqlTrans);
            try
            {
                return sqlCmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataSet GetDataSetForSQL(SqlTransaction sqlTrans, string Sql)
        {
            SqlCommand sqlCmd = new SqlCommand(Sql, sqlTrans.Connection, sqlTrans);
            SqlDataAdapter da = new SqlDataAdapter(sqlCmd);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
        }

        public static int getWeekStartDate()
        {
            string sql = "select start_day_of_week from dbo.system_param";
            return Convert.ToInt32(ProcessScalar(sql));
        }

        public static bool Lock_Record(int record_Code, int module_Code, int user_Code, out int Record_Locking_Code, out string strMessage)
        {
            Record_Locking_Code = 0;
            strMessage = "";
            string strQuery = "SELECT TOP 1 RC.Record_Locking_Code, U.Users_Code,  U.First_Name + ' ' + U.Last_Name as User_Name, "
                + " DATEDIFF(second, RC.Release_Time, GETDATE()) AS Locked_Second"
                + " FROM Record_Locking RC INNER JOIN Users U ON U.Users_Code = RC.User_Code"
                + " WHERE RC.Is_Active = 'Y' AND RC.Record_Code = " + record_Code
                + " AND RC.Module_Code = " + module_Code
                + " ORDER BY RC.Record_Locking_Code";

            DataTable dt = DatabaseBroker.ProcessSelectDirectly(strQuery).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string userName = dt.Rows[0]["User_Name"].ToString();
                int RLCode = Convert.ToInt32(dt.Rows[0]["Record_Locking_Code"].ToString());
                int lockedSecond = Convert.ToInt32(dt.Rows[0]["Locked_Second"].ToString());
                int uCode = Convert.ToInt32(dt.Rows[0]["Users_Code"].ToString());
                int maxLockTimeInSecond = Convert.ToInt32(GetSystemParameterValue("Max_Record_Lock_Duration_In_Second"));

                if (uCode == user_Code || lockedSecond > maxLockTimeInSecond)
                {
                    Release_Record(RLCode, true);
                }
                else
                {
                    strMessage = GlobalParams.msgRecordLockedByUser.Replace("{USERNAME}", userName);
                    return false;
                }
            }

            string hostName = Dns.GetHostName(); // Retrive the Name of HOST
            //string myIP = Dns.GetHostEntry(hostName).AddressList[1].ToString(); // Get the IP
            //string myIP = "192.168.0.117";
            //var  myIP  =Convert.ToString( (new System.Web.HttpRequest()).ServerVariables["REMOTE_ADDR"]);
            //HttpContext.Current.Request.UserHostAddress;
            string myIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            strQuery = "INSERT INTO Record_Locking(Record_Code, User_Code, Module_Code, Lock_Time, Release_Time, IP_Address, Is_Active)"
                + " VALUES (" + record_Code + ", " + user_Code + ", " + module_Code + ", GETDATE(), GETDATE(), '" + myIP + "', 'Y')";

            DatabaseBroker.ProcessNonQueryDirectly(strQuery);

            strQuery = "select ISNULL(IDENT_CURRENT('Record_Locking'), 0) Code";
            Record_Locking_Code = Convert.ToInt32(DatabaseBroker.ProcessScalarReturnString(strQuery));
            return true;
        }

        public static void Release_Record(int record_Locking_Code, bool Is_Infinite_Lock = false)
        {
            string strReleaseTime_Value = "GETDATE()";
            if(Is_Infinite_Lock)
                strReleaseTime_Value = "NULL";

            string strQuery = "UPDATE Record_Locking SET Is_Active = 'N', Release_Time =  " + strReleaseTime_Value
                + " WHERE Record_Locking_Code = " + record_Locking_Code;

            DatabaseBroker.ProcessNonQueryDirectly(strQuery);
        }

        public static void Refresh_Lock(int record_Locking_Code)
        {
            string strQuery = "UPDATE Record_Locking SET Release_Time =  GETDATE() WHERE Record_Locking_Code = " + record_Locking_Code;

            DatabaseBroker.ProcessNonQueryDirectly(strQuery);
        }

        public static string GetTitleNameInFormat(string dealTypeCondition, string titleName, int? episodeFrom, int? episodeTo)
        {
            string name = "";

            if (dealTypeCondition == GlobalParams.Deal_Music)
            {
                if (episodeFrom == 0 && episodeTo == 0)
                    name = titleName + " ( Unlimited )";
                else
                    name = titleName + " ( " + episodeTo + " )";
            }
            else if (dealTypeCondition == GlobalParams.Deal_Program)
                name = titleName + " ( " + episodeFrom + " - " + episodeTo + " )";
            else
                name = titleName;

            return name;
        }
    }

    #endregion

    #region ===========ENUMS===============

    public enum UserStatus
    {
        active,
        deactive,
    }

    public enum UserStatusIsActive
    {
        Y,
        N,
    }

    public enum YesNo
    {
        Y,
        N,
    }

    public enum RecordLockingStatus
    {
        changed,
        locked,
        deleted,
        updatable,
    }

    public enum RecordSaveStatus
    {
        added,
        updated,
        deleted,
        duplicate,
        error,
    }

    public enum NavigateAction
    {
        edit,
        add,
        view,
    }

    public enum ChildRecordStatus
    {
        newlyAdded,
        modified,
        deleted,
        existing,
    }

    public enum NumericType
    {
        int16Type,
        int32Type,
        int64Type,
        floatType,
        doubleType,
        decimalType,
    }

    public enum WeekDays
    {
        Mon,
        Tue,
        Wed,
        Thr,
        Fri,
        Sat,
        Sun,
    }

    #endregion=
}


