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
using UTOFrameWork.FrameworkClasses;
/// <summary>
/// Summary description for Movie
/// </summary>
public class Title : Persistent
{
    #region-----------Constructor-------------
    public Title()
    {
        OrderByColumnName = "Title_Name";
        OrderByCondition = "ASC";
        pkColName = "title_code";
        tableName = "title";
    }

    //Added by dada to update Released date
    public Title(string Released)
    {
        OrderByColumnName = "Title_Name";
        OrderByCondition = "ASC";
        this.released_by = Released;

    }
    #endregion

    #region-----------Attributes--------------
    private string _originalTitle;
  //  private string _englishTitle;
    
    private string _TitleName="";
    public string TitleName
    {
        get { return _TitleName; }
        set { _TitleName = value; }
    }

    private string _synopsis;
    private Country _objPurchTerritory;
    private string _TitleCodeId="";

    public string TitleCodeId
    {
        get { return _TitleCodeId; }
        set { _TitleCodeId = value; }
    }
   // private Talent _objDirector;
    private Talent _objScreenplay;
    private Talent _objScript;
    //private Talent _objDialogues;
    //private Talent _objWriter;
    //private Talent _objStory;
    //private Vendor _objProducer;

    private Entity _objEntity;
    private Language _objLanguage;
    private int _yearOfProduction;
    //private int _preCBFCDuration;
    private int _Duration;

    public int Duration
    {
        get { return _Duration; }
        set { _Duration = value; }
    }
    private ArrayList _arrKeyStar;
    private ArrayList _arrLanguage;
    private ArrayList _arrOrgCountry;
    private ArrayList _arrGenre;
    //private ArrayList _arrProducer;
    private string _keyStarCast;
    private string _orgCountry;
    private string _strGenre;
    private string _ProducerMulti;
    private string _Genere;
    private int _dealTypeCode;

    private int _movRlsYear;
 //   private string _movieNo;
    private string _releasedOn;
    private string _released_by;
    //private int _Producer;
    //private int _Director;
    private string _DirectorName;
    //private int _ScreenPlay;
    //private int _Script;
    //private int _Dialogues;

    private int _Entity;
    //private int _SamePersonTalentCode;


    //public int SamePersonTalentCode
    //{
    //    get { return _SamePersonTalentCode; }
    //    set { _SamePersonTalentCode = value; }
    //}

    private ArrayList _arrKeyStar_del;
    public ArrayList arrKeyStar_del
    {
        get
        {
            if (this._arrKeyStar_del == null)
                this._arrKeyStar_del = new ArrayList();
            return this._arrKeyStar_del;
        }
        set { this._arrKeyStar_del = value; }
    }
    
    private ArrayList _arrTitleAudioDetails;
    private ArrayList _arrMapExtendedColumns;
    public ArrayList ArrMapExtendedColumns
    {
        get
        {
            if (this._arrMapExtendedColumns == null)
                this._arrMapExtendedColumns = new ArrayList();
            return _arrMapExtendedColumns;
        }
        set { _arrMapExtendedColumns = value; }
    }
    private ArrayList _arrMapExtendedColumns_del;
    public ArrayList ArrMapExtendedColumns_del
    {
        get
        {
            if (this._arrMapExtendedColumns_del == null)
                this._arrMapExtendedColumns_del = new ArrayList();
            return _arrMapExtendedColumns_del;
        }
        set { _arrMapExtendedColumns_del = value; }
    }
    #endregion

    #region-----------Properties--------------

    public String Genere
    {
        get { return _Genere; }
        set { _Genere = value; }
    }

    public String Producer
    {
        get { return _ProducerMulti; }
        set { _ProducerMulti = value; }
    }



    public String DirectorName
    {
        get { return _DirectorName; }
        set { _DirectorName = value; }
    }

    //public int Director
    //{
    //    get { return _Director; }
    //    set { _Director = value; }
    //}

    public int Entity
    {
        get { return _Entity; }
        set { _Entity = value; }
    }

    public string ReleasedOn
    {
        get { return _releasedOn; }
        set { _releasedOn = value; }
    }
    public string released_by
    {
        get { return this._released_by; }
        set { this._released_by = value; }
    }

    public string originalTitle
    {
        get { return _originalTitle; }
        set { _originalTitle = value; }
    }
    //public string englishTitle
    //{
    //    get { return _englishTitle; }
    //    set { _englishTitle = value; }
    //}
    public string synopsis
    {
        get { return _synopsis; }
        set { _synopsis = value; }
    }
    public Country objPurchTerritory
    {
        get
        {
            if (_objPurchTerritory == null)
            {
                _objPurchTerritory = new Country();
            }
            return _objPurchTerritory;
        }
        set { _objPurchTerritory = value; }
    }
    private DealType _objDealType;
    public DealType objDealType
    {
        get
        {
            if (_objDealType == null)
            {
                _objDealType = new DealType();
            }
            return _objDealType;
        }
        set { _objDealType = value; }
    }
    //public Talent objDirector
    //{
    //    get
    //    {
    //        if (_objDirector == null)
    //        {
    //            _objDirector = new Talent();
    //        }
    //        return _objDirector;
    //    }
    //    set { _objDirector = value; }
    //}
    //public Vendor objProducer
    //{
    //    get
    //    {
    //        if (_objProducer == null)
    //        {
    //            _objProducer = new Vendor();
    //        }
    //        return _objProducer;
    //    }
    //    set { _objProducer = value; }
    //}




    //public int ScreenPlay
    //{
    //    get { return _ScreenPlay; }
    //    set { _ScreenPlay = value; }
    //}

    //public int Script
    //{
    //    get { return _Script; }
    //    set { _Script = value; }
    //}
    //public int Dialogues
    //{
    //    get { return _Dialogues; }
    //    set { _Dialogues = value; }
    //}





    //public Talent objScreenplay
    //{
    //    get
    //    {
    //        if (_objScreenplay == null)
    //        {
    //            _objScreenplay = new Talent();
    //        }
    //        return _objScreenplay;
    //    }
    //    set { _objScreenplay = value; }
    //}


    //public Talent objScript
    //{
    //    get
    //    {
    //        if (_objScript == null)
    //        {
    //            _objScript = new Talent();
    //        }
    //        return _objScript;
    //    }
    //    set { _objScript = value; }
    //}

    //public Talent objDialogues
    //{
    //    get
    //    {
    //        if (_objDialogues == null)
    //        {
    //            _objDialogues = new Talent();
    //        }
    //        return _objDialogues;
    //    }
    //    set { _objDialogues = value; }
    //}

    //public Talent objWriter
    //{
    //    get
    //    {
    //        if (_objWriter == null)
    //        {
    //            _objWriter = new Talent();
    //        }
    //        return _objWriter;
    //    }
    //    set { _objWriter = value; }
    //}


    //public Talent objStory
    //{
    //    get
    //    {
    //        if (_objStory == null)
    //        {
    //            _objStory = new Talent();
    //        }
    //        return _objStory;
    //    }
    //    set { _objStory = value; }
    //}

    //public Entity objEntity {
    //    get {
    //        if (_objEntity == null) {
    //            _objEntity = new Entity();
    //        }
    //        return _objEntity;
    //    }
    //    set { _objEntity = value; }
    //}


    public int dealTypeCode
    {
        get { return _dealTypeCode; }
        set { _dealTypeCode = value; }
    }
    public int yearOfProduction
    {
        get { return _yearOfProduction; }
        set { _yearOfProduction = value; }
    }
    //public int preCBFCDuration
    //{
    //    get { return _preCBFCDuration; }
    //    set { _preCBFCDuration = value; }
    //}
    public ArrayList arrKeyStar
    {
        get
        {
            if (_arrKeyStar == null)
            {
                _arrKeyStar = new ArrayList();
            }
            return _arrKeyStar;
        }
        set { _arrKeyStar = value; }
    }
    public ArrayList arrLanguage
    {
        get
        {
            if (_arrLanguage == null)
            {
                _arrLanguage = new ArrayList();
            }
            return _arrLanguage;
        }
        set { _arrLanguage = value; }
    }
    public ArrayList arrOrgCountry
    {
        get
        {
            if (_arrOrgCountry == null)
            {
                _arrOrgCountry = new ArrayList();
            }
            return _arrOrgCountry;
        }
        set { _arrOrgCountry = value; }
    }


    public ArrayList arrGenre
    {
        get
        {
            if (_arrGenre == null)
            {
                _arrGenre = new ArrayList();
            }
            return _arrGenre;
        }
        set { _arrGenre = value; }
    }

    //public ArrayList arrProducer
    //{
    //    get
    //    {
    //        if (_arrProducer == null)
    //        {
    //            _arrProducer = new ArrayList();
    //        }
    //        return _arrProducer;
    //    }
    //    set { _arrProducer = value; }
    //}

    public string keyStarCast
    {
        get { return _keyStarCast; }
        set { _keyStarCast = value; }
    }
    public string orgCountry
    {
        get { return _orgCountry; }
        set { _orgCountry = value; }
    }
    public string movie_genres
    {
        get { return _strGenre; }
        set { _strGenre = value; }
    }

    public int movRlsYear
    {
        get { return _movRlsYear; }
        set { _movRlsYear = value; }
    }
    //public string movieNo
    //{
    //    get { return _movieNo; }
    //    set { _movieNo = value; }
    //}


    public Language objOriginalLanguage
    {
        get
        {
            if (_objLanguage == null)
            {
                _objLanguage = new Language();
            }
            return _objLanguage;
        }
        set { _objLanguage = value; }
    }

    
    public ArrayList arrTitleAudioDetails
    {
        get
        {
            if (_arrTitleAudioDetails == null)
            {
                _arrTitleAudioDetails = new ArrayList();
            }
            return _arrTitleAudioDetails;
        }
        set { _arrTitleAudioDetails = value; }
    }

    private ArrayList _arrTitleAudioDetails_del;
    public ArrayList arrTitleAudioDetails_del
    {
        get
        {
            if (_arrTitleAudioDetails_del == null)
            {
                _arrTitleAudioDetails_del = new ArrayList();
            }
            return _arrTitleAudioDetails_del;
        }
        set { _arrTitleAudioDetails_del = value; }
    }

    private ArrayList _arrTitleAudioDetails_Temp;
    public ArrayList arrTitleAudioDetails_Temp  
    {
        get
        {
            if (_arrTitleAudioDetails_Temp == null)
            {
                _arrTitleAudioDetails_Temp = new ArrayList();
            }
            return _arrTitleAudioDetails_Temp;
        }
        set { _arrTitleAudioDetails_Temp = value; }
    }

    private ArrayList _arrTitleAudioDetails_del_Temp; 
    public ArrayList arrTitleAudioDetails_del_Temp
    {
        get
        {
            if (_arrTitleAudioDetails_del_Temp == null)
            {
                _arrTitleAudioDetails_del_Temp = new ArrayList();
            }
            return _arrTitleAudioDetails_del_Temp;
        }
        set { _arrTitleAudioDetails_del_Temp = value; }
    }
    
    private ArrayList _arrTitleReleasedOn;
    public ArrayList arrTitleReleasedOn
    {
        get
        {
            if (_arrTitleReleasedOn == null)
            {
                _arrTitleReleasedOn = new ArrayList();
            }
            return _arrTitleReleasedOn;
        }
        set { _arrTitleReleasedOn = value; }
    }

    private ArrayList _arrTitleReleasedOn_Del;
    public ArrayList arrTitleReleasedOn_Del
    {
        get
        {
            if (_arrTitleReleasedOn_Del == null)
            {
                _arrTitleReleasedOn_Del = new ArrayList();
            }
            return _arrTitleReleasedOn_Del;
        }
        set { _arrTitleReleasedOn_Del = value; }
    }

    private string _isShowReleaseBtn;
    public string isShowReleaseBtn
    {
        get { return _isShowReleaseBtn; }
        set { _isShowReleaseBtn = value; }
    }

    /*****************END ADDED BY DADA FOR TITLE REALEASE**********************/

    private int _GradeCode;
    public int GradeCode
    {
        get { return _GradeCode; }
        set { _GradeCode = value; }
    }

    private string _TitleStarCast;
    public string TitleStarCast
    {
        get { return _TitleStarCast; }
        set { _TitleStarCast = value; }
    }

    private GradeMaster _objGradeMaster;
    public GradeMaster objGradeMaster
    {
        get
        {
            if (_objGradeMaster == null)
            { _objGradeMaster = new GradeMaster(); }
            return _objGradeMaster;
        }
        set { _objGradeMaster = value; }
    }

    #endregion

    #region-----------Properties--------------

    private ArrayList _arrTitleReleasedOn_Wrapper;
    public ArrayList arrTitleReleasedOn_Wrapper
    {
        get
        {
            if (this._arrTitleReleasedOn_Wrapper == null)
                this._arrTitleReleasedOn_Wrapper = new ArrayList();
            return this._arrTitleReleasedOn_Wrapper;
        }
        set { this._arrTitleReleasedOn_Wrapper = value; }
    }

    private string _TitleRelease_Flag = YesNo.N.ToString();
    public string TitleRelease_Flag
    {
        get { return _TitleRelease_Flag; }
        set { _TitleRelease_Flag = value; }
    }



    private string _Writer;

    public string Writer
    {
        get { return _Writer; }
        set { _Writer = value; }
    }


    private string _IsDoneBySame;
    public string IsDoneBySame
    {
        get { return _IsDoneBySame; }
        set { _IsDoneBySame = value; }
    }

    private int _titleLanguageCode = 0;

    public int TitleLanguageCode
    {
        get { return _titleLanguageCode; }
        set { _titleLanguageCode = value; }
    }
    
    private bool _titleDealMovieExsits;

    public bool TitleDealMovieExsits
    {
        get { return _titleDealMovieExsits; }
        set { _titleDealMovieExsits = value; }
    }

    #endregion

    #region-----------Methods-----------------
    public override DatabaseBroker GetBroker()
    {
        return new TitleBroker();
    }
    public override void LoadObjects()
    {


        if (_objPurchTerritory != null && _objPurchTerritory.IntCode > 0)
        {
            _objPurchTerritory.Fetch();
        }
        if (this.objOriginalLanguage.IntCode > 0)
        {
            this.objOriginalLanguage.Fetch();
        }
        if (this.IntCode > 0)
        {
            this.arrKeyStar = DBUtil.FillArrayList(new TitleStarCast(), " AND title_code=" + this.IntCode, true);         
            keyStarCast = GetTalentName(this.IntCode, GlobalParams.RoleCode_StarCast);
        }
        if (this.IntCode > 0)
        {
           this.Producer = GetTalentName(this.IntCode, GlobalParams.Role_code_Producer);
        }
        if (this.IntCode > 0)
        {         
            this.DirectorName = GetTalentName(this.IntCode, GlobalParams.RoleCode_Director);
        }
        if (this.IntCode > 0)
        {
            this.arrGenre = DBUtil.FillArrayList(new TitleGenres(), "AND title_code=" + this.IntCode, true);
            Genere = getGenre(this.arrGenre);
        }
        if (this.dealTypeCode > 0)
        {
            objDealType.IntCode = this.dealTypeCode;
            objDealType.Fetch();
        }
        this.arrOrgCountry = DBUtil.FillArrayList(new TitleTerritory(), " AND title_code=" + this.IntCode, true);
        orgCountry = getOrgCountry(this.arrOrgCountry);
        if (this.IntCode > 0)
        {
            this.arrTitleAudioDetails = DBUtil.FillArrayList(new TitleAudioDetails(), " and title_Code=" + this.IntCode + " ", true);
        }
        if (this.IntCode > 0)
        {
            //this.arrTitleReleasedOn = DBUtil.FillArrayList(new TitleReleasedOn(), " and title_Code=" + this.IntCode + " ", true);
            //this.arrTitleReleasedOn_Del = DBUtil.FillArrayList(new TitleReleasedOn(), " and title_Code=" + this.IntCode + " ", true);
        }

        if (this.GradeCode > 0)
        {
            this.objGradeMaster.IntCode = this.GradeCode;
            this.objGradeMaster.Fetch();
        }

    }
    public void loadArrayLists()
    {
        this.arrKeyStar = DBUtil.FillArrayList(new TitleStarCast(), " AND title_code=" + this.IntCode, true);
        this.arrOrgCountry = DBUtil.FillArrayList(new TitleTerritory(), " AND title_code=" + this.IntCode, true);
        this.arrGenre = DBUtil.FillArrayList(new TitleGenres(), " AND title_code=" + this.IntCode, true);
        this.ArrMapExtendedColumns = DBUtil.FillArrayList(new MapExtendedColumns(), " AND Record_Code=" + this.IntCode, true);        
        keyStarCast = GetTalentName(this.IntCode, GlobalParams.RoleCode_StarCast);
        orgCountry = getOrgCountry(this.arrOrgCountry);
        movie_genres = getGenre(this.arrGenre);        
       // Producer = GetTalentName(this.IntCode, GlobalParams.Role_code_Producer);
        if (this.objDealType.IntCode > 0)
        {
            this.objDealType.Fetch();
        }
        if (this.IntCode > 0)
        {
            this.arrTitleAudioDetails = DBUtil.FillArrayList(new TitleAudioDetails(), " and title_Code=" + this.IntCode + " ", true);
            this.arrTitleAudioDetails_Temp = DBUtil.FillArrayList(new TitleAudioDetails(), " and title_Code=" + this.IntCode + " ", true);
            this.arrTitleAudioDetails_del_Temp = DBUtil.FillArrayList(new TitleAudioDetails(), " and title_Code=" + this.IntCode + " ", true);
        }
        if (this.IntCode > 0)   //NEED FOR TITLE VIEW 
        {
            this.arrTitleReleasedOn = DBUtil.FillArrayList(new TitleReleasedOn(), " and title_Code=" + this.IntCode + " ", true);
        }
    }

    public void loadTitleReleasedOn()   //NEED FOR TITLE Released On
    {
        if (this.IntCode > 0)
        {
            this.arrTitleReleasedOn = DBUtil.FillArrayList(new TitleReleasedOn(), " and title_Code=" + this.IntCode + " ", true);
            this.arrTitleReleasedOn_Del = DBUtil.FillArrayList(new TitleReleasedOn(), " and title_Code=" + this.IntCode + " ", true);
        }
    }

    private string getGenre(ArrayList arrGenre)
    {
        string strGenre = "";
        foreach (TitleGenres objtmpTer in arrGenre)
        {
            if (strGenre != "")
            {
                strGenre += ",";
            }
            strGenre += objtmpTer.objMovGenre.GenresName;
        }
        string strSelected = strGenre.Trim(",".ToCharArray()).Replace(",", ", ");
        return strSelected;
    }

    private string getProducer(ArrayList arrProducer)
    {
        string strProducer = "";
        foreach (TitleProducer objtmpTer in arrProducer)
        {
            if (strProducer != "")
            {
                strProducer += ",";
            }
            strProducer += objtmpTer.objTalent.talentName;
        }
        string strSelected = strProducer.Trim(",".ToCharArray()).Replace(",", ",");
        return strSelected;
    }

    private string getOrgCountry(ArrayList arrOrgCountry)
    {
        string strOrgCountry = "";
        foreach (TitleTerritory objtmpTer in arrOrgCountry)
        {
            if (strOrgCountry != "")
            {
                strOrgCountry += ",";
            }
            strOrgCountry += objtmpTer.objTerritory.CountryName;
        }
        string strSelected = strOrgCountry.Trim(",".ToCharArray()).Replace(",", ", ");
        return strSelected;
    }
    private string getkeyStarCast(ArrayList arrKeyStar)
    {
        string keyStarCast = "";
        foreach (TitleStarCast objtmpTer in arrKeyStar)
        {
            if (keyStarCast != "")
            {
                keyStarCast += ",";
            }
            keyStarCast += objtmpTer.objTalent.talentName;
        }
        string strSelected = keyStarCast.Trim(",".ToCharArray()).Replace(",", ",");
        return strSelected;
    }
    public override void UnloadObjects()
    {
        if (this.TitleRelease_Flag == YesNo.Y.ToString())       //Only when title release.
        {
            /////********************Title Release********************/////
            foreach (TitleReleasedOn objTitleReleasedOn in this.arrTitleReleasedOn_Del)
            {
                objTitleReleasedOn.TitleCode = this.IntCode;
                objTitleReleasedOn.IsTransactionRequired = true;
                objTitleReleasedOn.SqlTrans = this.SqlTrans;
                objTitleReleasedOn.IsProxy = true;
                objTitleReleasedOn.IsDeleted = true;
                objTitleReleasedOn.Save();
            }

            foreach (TitleReleasedOn objTitleReleasedOn in this.arrTitleReleasedOn)
            {
                objTitleReleasedOn.TitleCode = this.IntCode;
                objTitleReleasedOn.IsTransactionRequired = true;
                objTitleReleasedOn.SqlTrans = this.SqlTrans;
                objTitleReleasedOn.IsProxy = false;              
                objTitleReleasedOn.Save();
            }
            /////********************Title Release********************/////
        }
        else
        {
            /////*****************KEY STAR*****************/////
            if (arrKeyStar_del != null)
            {
                foreach (TitleStarCast objTitleStarCast_Del in this.arrKeyStar_del)
                {
                    objTitleStarCast_Del.IsTransactionRequired = true;
                    objTitleStarCast_Del.SqlTrans = this.SqlTrans;
                    objTitleStarCast_Del.IsDeleted = true;
                    objTitleStarCast_Del.Save();
                }
            }
            foreach (TitleStarCast objTitleStarCast in this.arrKeyStar)
            {
                objTitleStarCast.IsProxy = true;
                objTitleStarCast.IsTransactionRequired = true;
                objTitleStarCast.SqlTrans = this.SqlTrans;
                objTitleStarCast.titleCode = this.IntCode;
                switch (objTitleStarCast.status)
                {
                    case GlobalParams.LINE_ITEM_NEWLY_ADDED:
                        objTitleStarCast.IsDirty = false;
                        objTitleStarCast.Save();
                        break;
                    case GlobalParams.LINE_ITEM_MODIFIED:
                        objTitleStarCast.IsDirty = true;
                        objTitleStarCast.Save();
                        break;
                    case GlobalParams.LINE_ITEM_DELETED:
                        objTitleStarCast.IsDeleted = true;
                        objTitleStarCast.Save();
                        break;
                }
            }

            /////*****************END KEY STAR*****************/////

            /////*****************TERRITORY*****************/////
            foreach (TitleTerritory objTitleTerritory in this.arrOrgCountry)
            {
                objTitleTerritory.IsProxy = true;
                objTitleTerritory.IsTransactionRequired = true;
                objTitleTerritory.SqlTrans = this.SqlTrans;
                objTitleTerritory.titleCode = this.IntCode;
                switch (objTitleTerritory.status)
                {
                    case GlobalParams.LINE_ITEM_NEWLY_ADDED:
                        objTitleTerritory.IsDirty = false;
                        objTitleTerritory.Save();
                        break;
                    case GlobalParams.LINE_ITEM_MODIFIED:
                        objTitleTerritory.IsDirty = true;
                        objTitleTerritory.Save();
                        break;
                    case GlobalParams.LINE_ITEM_DELETED:
                        objTitleTerritory.IsDeleted = true;
                        objTitleTerritory.Save();
                        break;
                }
            }
            /////*****************END TERRITORY*****************///////

            /////*****************GENERES*****************/////
            foreach (TitleGenres objTitleGnrDtl in this.arrGenre)
            {
                objTitleGnrDtl.IsProxy = true;
                objTitleGnrDtl.IsTransactionRequired = true;
                objTitleGnrDtl.SqlTrans = this.SqlTrans;
                objTitleGnrDtl.titleCode = this.IntCode;
                switch (objTitleGnrDtl.status)
                {
                    case GlobalParams.LINE_ITEM_NEWLY_ADDED:
                        objTitleGnrDtl.IsDirty = false;
                        objTitleGnrDtl.Save();
                        break;
                    case GlobalParams.LINE_ITEM_MODIFIED:
                        objTitleGnrDtl.IsDirty = true;
                        objTitleGnrDtl.Save();
                        break;
                    case GlobalParams.LINE_ITEM_DELETED:
                        objTitleGnrDtl.IsDeleted = true;
                        objTitleGnrDtl.Save();
                        break;
                }
            }
            /////*****************END GENERES*****************/////

            /////*****************PRODUCER*****************/////
            //foreach (TitleProducer objTitleproducer in this.arrProducer)
            //{
            //    objTitleproducer.IsProxy = true;
            //    objTitleproducer.IsTransactionRequired = true;
            //    objTitleproducer.SqlTrans = this.SqlTrans;
            //    objTitleproducer.titleCode = this.IntCode;
            //    switch (objTitleproducer.status)
            //    {
            //        case GlobalParams.LINE_ITEM_NEWLY_ADDED:
            //            objTitleproducer.IsDirty = false;
            //            objTitleproducer.Save();
            //            break;
            //        case GlobalParams.LINE_ITEM_MODIFIED:
            //            objTitleproducer.IsDirty = true;
            //            objTitleproducer.Save();
            //            break;
            //        case GlobalParams.LINE_ITEM_DELETED:
            //            objTitleproducer.IsDeleted = true;
            //            objTitleproducer.Save();
            //            break;
            //    }
            //}
            /////*****************END PRODUCER*****************/////

            /*ADDED BY DADA FOR AUDIO MUSIC DETAILS ON 25-OCT-2010 */
            if (this.arrTitleAudioDetails_del != null)
            {
                foreach (TitleAudioDetails objTitleAudioDetails in this.arrTitleAudioDetails_del)
                {
                    objTitleAudioDetails.IsTransactionRequired = true;
                    objTitleAudioDetails.SqlTrans = this.SqlTrans;
                    objTitleAudioDetails.IsDeleted = true;
                    objTitleAudioDetails.IsProxy = false;
                    objTitleAudioDetails.Save();
                }
            }

            if (this.arrTitleAudioDetails != null)
            {
                foreach (TitleAudioDetails objTitleAudioDetails in this.arrTitleAudioDetails)
                {
                    objTitleAudioDetails.TitleCode = this.IntCode;
                    objTitleAudioDetails.IsTransactionRequired = true;
                    objTitleAudioDetails.SqlTrans = this.SqlTrans;
                    objTitleAudioDetails.IsProxy = false;
                    if (objTitleAudioDetails.IntCode > 0)
                        objTitleAudioDetails.IsDirty = true;
                    objTitleAudioDetails.Save();
                }
            }

            if (this.ArrMapExtendedColumns_del != null)
            {
                foreach (MapExtendedColumns objMapExtendedColumns in this.ArrMapExtendedColumns_del)
                {
                    objMapExtendedColumns.IsTransactionRequired = true;
                    objMapExtendedColumns.SqlTrans = this.SqlTrans;
                    objMapExtendedColumns.IsDeleted = true;
                    objMapExtendedColumns.IsProxy = false;
                    objMapExtendedColumns.Save();
                }
            }

            if (this.ArrMapExtendedColumns != null)
            {
                foreach (MapExtendedColumns objMapExtendedColumns in this.ArrMapExtendedColumns)
                {
                    objMapExtendedColumns.IsProxy = false;
                    objMapExtendedColumns.IsTransactionRequired = true;
                    objMapExtendedColumns.SqlTrans = this.SqlTrans;
                    objMapExtendedColumns.RecordCode = this.IntCode;
                    switch (objMapExtendedColumns.Status)
                    {
                        case GlobalParams.LINE_ITEM_NEWLY_ADDED:
                            objMapExtendedColumns.IsDirty = false;
                            objMapExtendedColumns.Save();
                            break;
                        case GlobalParams.LINE_ITEM_MODIFIED:
                            objMapExtendedColumns.IsDirty = true;
                            objMapExtendedColumns.Save();
                            break;
                        case GlobalParams.LINE_ITEM_DELETED:
                            objMapExtendedColumns.IsDeleted = true;
                            objMapExtendedColumns.Save();
                            break;
                    }
                }
            }
        }
    }
    override public string getRecordStatus()
    {
        return (((TitleBroker)this.GetBroker())).getRecordStatus(this);
    }

    override public string getRecordStatus(out int userCode)
    {
        return (((TitleBroker)this.GetBroker())).getRecordStatus(this, out userCode);
    }

    override public void unlockRecord()
    {
        (((TitleBroker)this.GetBroker())).unlockRecord(this);
    }

    override public void refreshRecord()
    {
        (((TitleBroker)this.GetBroker())).refreshRecord(this);
    }
    public Boolean IsHoldback(int movieCode)
    {
        return (((TitleBroker)this.GetBroker())).IsHoldback(movieCode);
    }
    public Boolean IsAwardRlsExist(int movieCode)
    {
        return (((TitleBroker)this.GetBroker())).IsAwardRlsExist(movieCode);
    }
    public Boolean IsTitleExist(string movieName, int movieCode)
    {
        return (((TitleBroker)this.GetBroker())).IsTitleExist(movieName, movieCode);
    }
    public Boolean IsMovieExistInDealMovie(int movieCode)
    {
        return (((TitleBroker)this.GetBroker())).IsMovieExistInDealMovie(movieCode);
    }

    public void updateAndUnLockMovie()
    {
        (((TitleBroker)this.GetBroker())).updateAndUnLockMovie(this);
    }


    //Added to update ReleasedOn date
    public string UpdateRelesedDate(string Released)
    {

        return (((TitleBroker)this.GetBroker())).UpdateRelesedDate(this, Released);
    }

    public DateTime GetDealSigndedDate(int titlecode)
    {
        return (((TitleBroker)this.GetBroker())).GetDealSigndedDate(titlecode);
    }

    public string HoldBack(int titlecode)
    {
        return (((TitleBroker)this.GetBroker())).Holdback(titlecode);
    }

    public int getDealMovieCode(int titlecode)
    {
        return (((TitleBroker)this.GetBroker())).getDealMovieCode(titlecode);
    }
    public bool checkMovieRefExist(int titlecode)
    {
        return (((TitleBroker)this.GetBroker())).checkMovieRefExist(titlecode);
    }
    public string ExecStoredProcedure(int DealMovieCode)
    {
        return (((TitleBroker)this.GetBroker())).ExecStoredProcedure(DealMovieCode);
    }
    //
    #endregion

    public string getSynopsis(int titlecode)
    {
        return (((TitleBroker)this.GetBroker())).getSynopsis(titlecode);
    }

    public bool SetEnableOnRef(int titleCode)
    {
        return (((TitleBroker)this.GetBroker())).SetEnableOnRef(titleCode);
    }

    public bool CanChangeOriginalLanguage(int titleCode)
    {
        return (((TitleBroker)this.GetBroker())).CanChangeOriginalLanguage(titleCode);
    }

    public int GetDocumentaryWriter(int IntCode)
    {
        int result = 0;
        string sql = "select TT.talent_code from title_talent TT " +
                         " inner join Talent T on T.talent_code = TT.talent_code " +
                         " inner join Talent_Role TR on TR.talent_code = T.talent_code   and TR.role_code = 20 and TT.title_code = " + this.IntCode;

        sql = DatabaseBroker.ProcessScalarReturnString(sql);


        if (sql != "")
            result = Convert.ToInt32(sql);
        return result;
    }
    public string GetTalentName(int titleCode, int RoleCode)
    {
        string result = "";
        string sql = "select STUFF((select DISTINCT ', ' + cast( T.talent_name as NVARCHAR(max)) from Title_Talent TT "
                       + " INNER JOIN Talent T On T.talent_code =TT.talent_code"
                       + " Where TT.title_code=" + titleCode + " And TT.Role_code =" + RoleCode + " "
                       + " FOR XML PATH('')), 1, 1, '') as TalentName";
        sql = DatabaseBroker.ProcessScalarReturnString(sql);
        if (sql != null && sql != "")
            result = sql;
        return result;


    }
    public string GetTalentCode(int title_code, int RoleCode)
    {
        string result = "";
        string sql = "select STUFF((select DISTINCT '~' + cast( TT.talent_code as varchar(max)) from title_talent TT "
                     + " inner join Talent T on T.talent_code = TT.talent_code "
                     + " inner join Talent_Role TR on TR.talent_code = T.talent_code  and TR.role_code =" + RoleCode + "  and TT.title_code = " + title_code + ""
                     + " FOR XML PATH('')), 1, 1, '') as TalentCode";
        sql = DatabaseBroker.ProcessScalarReturnString(sql);
        if (sql != "")
            result = sql;
        return result;
    }
    public int GetDocumentaryStoryWriter(int IntCode)
    {
        int result = 0;
        string sql = "select TT.talent_code from title_talent TT " +
                    " inner join Talent T on T.talent_code = TT.talent_code " +
                    " inner join Talent_Role TR on TR.talent_code = T.talent_code  and TR.role_code = 16 and TT.title_code = " + IntCode;


        sql = DatabaseBroker.ProcessScalarReturnString(sql);

        if (sql != "")
            result = Convert.ToInt32(sql);
        return result;
    }


    public int GetDocumentaryScriptWriter(int IntCode)
    {
        int result = 0;
        string sql = "select TT.talent_code from title_talent TT " +
                     " inner join Talent T on T.talent_code = TT.talent_code " +
                     " inner join Talent_Role TR on TR.talent_code = T.talent_code  and TR.role_code = 17 and TT.title_code = " + IntCode;

        sql = DatabaseBroker.ProcessScalarReturnString(sql);

        if (sql != "")
            result = Convert.ToInt32(sql);
        return result;
    }

    public int GetDocumentaryScreenPlayWriter(int IntCode)
    {
        int result = 0;
        string sql = "select TT.talent_code from title_talent TT " +
                         " inner join Talent T on T.talent_code = TT.talent_code " +
                         " inner join Talent_Role TR on TR.talent_code = T.talent_code   and TR.role_code = 18 and TT.title_code = " + IntCode;

        sql = DatabaseBroker.ProcessScalarReturnString(sql);

        if (sql != "")
            result = Convert.ToInt32(sql);
        return result;
    }


    public int GetDocumentaryDialogueWriter(int IntCode)
    {
        int result = 0;
        string sql = "select TT.talent_code from title_talent TT " +
                         " inner join Talent T on T.talent_code = TT.talent_code " +
                         " inner join Talent_Role TR on TR.talent_code = T.talent_code  and TR.role_code = 19 and TT.title_code = " + IntCode;

        sql = DatabaseBroker.ProcessScalarReturnString(sql);

        if (sql != "")
            result = Convert.ToInt32(sql);

        return result;
    }

    public int GetLyricistWriter(int IntCode)
    {
        int result = 0;
        string sql = "select TT.talent_code from title_talent TT " +
                         " inner join Talent T on T.talent_code = TT.talent_code " +
                         " inner join Talent_Role TR on TR.talent_code = T.talent_code  and TR.role_code = 15 and TT.title_code = " + IntCode;

        sql = DatabaseBroker.ProcessScalarReturnString(sql);

        if (sql != "")
            result = Convert.ToInt32(sql);

        return result;
    }


    public int GetMusiccomposer(int IntCode)
    {
        int result = 0;
        string sql = "select TT.talent_code from title_talent TT " +
                         " inner join Talent T on T.talent_code = TT.talent_code " +
                         " inner join Talent_Role TR on TR.talent_code = T.talent_code  and TR.role_code = 21 and TT.title_code = " + IntCode;

        sql = DatabaseBroker.ProcessScalarReturnString(sql);

        if (sql != "")
            result = Convert.ToInt32(sql);

        return result;
    }

    private string getTitleStarCast(int TitleCode)
    {
        string starCast = string.Empty;
        string strSql = " select dbo.fn_GetStarCastForTitle_Viacom (" + TitleCode + ") ";
        starCast = DatabaseBroker.ProcessScalarReturnString(strSql);
        starCast = starCast.Trim().Trim(',');
        return starCast;
    }

}

