using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UTOFrameWork.FrameworkClasses;
using System.Collections;

//namespace R_RightsFramework.Classes.master
//{
//    class UserEntity
//    {
//    }
//}

public class UserEntity : Persistent
{
    public UserEntity()
    {
        OrderByColumnName = "Users_Entity_Code";
        OrderByCondition = "ASC";
        tableName = "Users_Entity";
        pkColName = "Users_Entity_Code";
    }

    #region ---------------Attributes And Prperties---------------


    private int _UserCode;
    public int UserCode
    {
        get { return this._UserCode; }
        set { this._UserCode = value; }
    }

    private int _EntityCode;
    public int EntityCode
    {
        get { return this._EntityCode; }
        set { this._EntityCode = value; }
    }

    private char _ISDefault;
    public char ISDefault
    {
        get { return this._ISDefault; }
        set { this._ISDefault = value; }
    }

    private Entity _ObjEntity;
    public Entity ObjEntity
    {
        get
        {
            if (_ObjEntity == null)
                return new Entity();
            return _ObjEntity;
        }
        set { _ObjEntity = value; }
    }

    private string _EntityName;
    public string EntityName
    {
        get { return this._EntityName; }
        set { this._EntityName = value; }
    }

    #endregion

    public override DatabaseBroker GetBroker()
    {
        return new UserEntityBroker();
    }

    public override void UnloadObjects()
    {
        throw new NotImplementedException();
    }

    public override void LoadObjects()
    {
        if (this.EntityCode > 0)
        {
            Entity tmpObjEntity = new Entity();
            tmpObjEntity.IntCode = this.EntityCode;
            tmpObjEntity.Fetch();
            this.ObjEntity = tmpObjEntity;
        }
        

    }
}
