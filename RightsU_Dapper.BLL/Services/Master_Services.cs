using RightsU_Dapper.DAL.Repository;
using RightsU_Dapper.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.BLL.Services
{
    public class Talent_Service
    {
        Talent_Repository objTalent_Repository = new Talent_Repository();
        public Talent_Service()
        {
            this.objTalent_Repository = new Talent_Repository();
        }
        public Talent GetTalentByID(int? ID, Type[] RelationList = null)
        {
            return objTalent_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Talent> GetTalentList()
        {
            return objTalent_Repository.GetAll();
        }
        public void AddEntity(Talent obj)
        {
            objTalent_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Talent obj)
        {
            objTalent_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Talent obj)
        {
            objTalent_Repository.Delete(obj);
        }

        public IEnumerable<Talent> SearchFor(object param)
        {
            return objTalent_Repository.SearchFor(param);
        }
        public IEnumerable<Talent> GetList(Type[] additionalTypes = null)
        {
            return objTalent_Repository.GetAll();
        }
        private bool ValidateDuplicate(Talent objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Role_Service
    {
        // private readonly Role_Repository objRole;
        Role_Repository objRole_Repository = new Role_Repository();
        //public Role_Service(string Connection_Str)
        //{
        //    this.objRole = new Role_Repository(Connection_Str);
        //}
        public IEnumerable<Role> SearchFor(object param)
        {
            return objRole_Repository.SearchFor(param);
        }

        public IEnumerable<Role> GetList()
        {
            return objRole_Repository.GetAll();
        }
        public Role GetRoleByID(int? ID, Type[] RelationList = null)
        {
            return objRole_Repository.Get(ID, RelationList);
        }
    }
    public class Language_Group_Service
    {
        Language_Group_Repository objLanguageGroup_Repository = new Language_Group_Repository();
        public Language_Group_Service()
        {
            this.objLanguageGroup_Repository = new Language_Group_Repository();
        }
        public Language_Group GetLanguageGroupByID(int? ID, Type[] RelationList = null)
        {
            return objLanguageGroup_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Language_Group> GetLanguageGroupList()
        {
            return objLanguageGroup_Repository.GetAll();
        }
        public void AddEntity(Language_Group obj)
        {
            objLanguageGroup_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Language_Group obj)
        {
            objLanguageGroup_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Language_Group obj)
        {
            objLanguageGroup_Repository.Delete(obj);
        }

        public IEnumerable<Language_Group> SearchFor(object param)
        {
            return objLanguageGroup_Repository.SearchFor(param);
        }
        public IEnumerable<Language_Group> GetList(Type[] additionalTypes = null)
        {
            return objLanguageGroup_Repository.GetAll(additionalTypes);
        }
        private bool ValidateDuplicate(Language_Group objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Language_Service
    {
        Language_Repository objLanguage_Repository = new Language_Repository();

        //public Language_Service(string Connection_Str)
        //{
        //    this.objLanguage_Repository = new Language_Repository(Connection_Str);
        //}
        public IEnumerable<Language> SearchFor(object param)
        {
            return objLanguage_Repository.SearchFor(param);
        }
        //public IQueryable<Language> SearchFor(Expression<Func<Language, bool>> predicate)
        //{
        //    return objLanguageGroup_Repository.SearchFor(predicate);
        //}

        //public Language GetById(int id)
        //{
        //    return objLanguage_Repository.GetById(id);
        //}
        public IEnumerable<Language> GetList(Type[] additionalTypes = null)
        {
            return objLanguage_Repository.GetAll(additionalTypes);
        }
        public void AddEntity(Language obj)
        {
            objLanguage_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Language obj)
        {
            objLanguage_Repository.Update(obj);
        }

        public void DeleteLanguage(Language obj)
        {
            objLanguage_Repository.Delete(obj);
        }
        //public override bool Validate(Language objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Language objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Language objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        private bool ValidateDuplicate(Language objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Language_Name == objToValidate.Language_Name && s.Language_Code != objToValidate.Language_Code).Count() > 0)
            //{
            //    resultSet = "Language already exists";
            //    return false;
            //}

            resultSet = "";
            return true;
        }

    }
    public class Promoter_Remarks_Service
    {
        Promoter_Remarks_Repository objPromoter_Remarks_Repository = new Promoter_Remarks_Repository();
        public IEnumerable<Promoter_Remarks> GetList(Type[] additionalTypes = null)
        {
            return objPromoter_Remarks_Repository.GetAll();
        }

        public IEnumerable<Promoter_Remarks> SearchFor(object param)
        {
            return objPromoter_Remarks_Repository.SearchFor(param);
        }
        public Promoter_Remarks GetPromoterRemarkByID(int? ID, Type[] RelationList = null)
        {
            return objPromoter_Remarks_Repository.Get(ID, RelationList);
        }
        public void AddEntity(Promoter_Remarks obj)
        {
            objPromoter_Remarks_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Promoter_Remarks obj)
        {
            objPromoter_Remarks_Repository.Update(obj);
        }
        //public bool Save(Promoter_Remarks objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objPromoter_Remarks_Repository, out resultSet);
        //}

        //public bool Update(Promoter_Remarks objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objPromoter_Remarks_Repository, out resultSet);
        //}
        public void DeletePromoter_Remarks(Promoter_Remarks obj)
        {
            objPromoter_Remarks_Repository.Delete(obj);
        }
        //public bool Delete(Promoter_Remarks objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objPromoter_Remarks_Repository, out resultSet);
        //}

        //public override bool Validate(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        //private bool ValidateDuplicate(Promoter_Remarks objToValidate, out dynamic resultSet)
        //{
        //    if (objToValidate.EntityState != State.Deleted)
        //    {
        //        int duplicateRecordCount = SearchFor(s => s.Promoter_Remark_Desc.ToUpper() == objToValidate.Promoter_Remark_Desc.ToUpper() &&
        //            s.Promoter_Remarks_Code != objToValidate.Promoter_Remarks_Code).Count();

        //        if (duplicateRecordCount > 0)
        //        {
        //            resultSet = "Promoter Remark already exists";
        //            return false;
        //        }
        //    }

        //    resultSet = "";
        //    return true;
        //}
    }
    public class Grade_Master_Service
    {
        private readonly Grade_Master_Repository objRepository;

        //public Grade_Master_Service(string Connection_Str)
        //{
        //    this.objRepository = new Grade_Master_Repository(Connection_Str);
        //}
        Grade_Master_Repository objGrade_Master_Remarks_Repository = new Grade_Master_Repository();
        public IEnumerable<Grade_Master> GetList(Type[] additionalTypes = null)
        {
            return objGrade_Master_Remarks_Repository.GetAll();
        }

        public IEnumerable<Grade_Master> SearchFor(object param)
        {
            return objGrade_Master_Remarks_Repository.SearchFor(param);
        }
        public Grade_Master GetGrade_MasterByID(int? ID, Type[] RelationList = null)
        {
            return objGrade_Master_Remarks_Repository.Get(ID, RelationList);
        }
        public void AddEntity(Grade_Master obj)
        {
            objGrade_Master_Remarks_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Grade_Master obj)
        {
            objGrade_Master_Remarks_Repository.Update(obj);
        }

        public void DeleteGrade_Master(Grade_Master obj)
        {
            objGrade_Master_Remarks_Repository.Delete(obj);
        }
        //public override bool Validate(Grade_Master objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Grade_Master objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Grade_Master objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        private bool ValidateDuplicate(Grade_Master objToValidate, out dynamic resultSet)
        {
            //if (objToValidate.EntityState != State.Deleted)
            //{
            //    int duplicateRecordCount = SearchFor(s => s.Grade_Name.ToUpper() == objToValidate.Grade_Name.ToUpper() &&
            //        s.Grade_Code != objToValidate.Grade_Code).Count();

            //    if (duplicateRecordCount > 0)
            //    {
            //        resultSet = "Grade already exists";
            //        return false;
            //    }
            //}

            resultSet = "";
            return true;
        }
    }
    public class Currency_Service
    {
        Currency_Repository objCurrency_Repository = new Currency_Repository();
        public Currency_Service()
        {
            this.objCurrency_Repository = new Currency_Repository();
        }
        public Currency GetTalentByID(int? ID, Type[] RelationList = null)
        {
            return objCurrency_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Currency> GetTalentList()
        {
            return objCurrency_Repository.GetAll();
        }
        public void AddEntity(Currency obj)
        {
            objCurrency_Repository.Add(obj);
        }
        public void UpdateCurrency(Currency obj)
        {
            objCurrency_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Currency obj)
        {
            objCurrency_Repository.Delete(obj);
        }

        public IEnumerable<Currency> SearchFor(object param)
        {
            return objCurrency_Repository.SearchFor(param);
        }
        public IEnumerable<Currency> GetList(Type[] additionalTypes = null)
        {
            return objCurrency_Repository.GetAll();
        }
        private bool ValidateDuplicate(Currency objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Genres_Service
    {
        Genres_Repository objGenres_Repository = new Genres_Repository();
        public Genres_Service()
        {
            this.objGenres_Repository = new Genres_Repository();
        }
        public Genre GetGenresByID(int? ID, Type[] RelationList = null)
        {
            return objGenres_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Genre> GetTalentList()
        {
            return objGenres_Repository.GetAll();
        }
        public void AddEntity(Genre obj)
        {
            objGenres_Repository.Add(obj);
        }
        public void UpdateGenres(Genre obj)
        {
            objGenres_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Genre obj)
        {
            objGenres_Repository.Delete(obj);
        }

        public IEnumerable<Genre> SearchFor(object param)
        {
            return objGenres_Repository.SearchFor(param);
        }
        public IEnumerable<Genre> GetList(Type[] additionalTypes = null)
        {
            return objGenres_Repository.GetAll();
        }
        private bool ValidateDuplicate(Genre objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Cost_Type_Service
    {
        Cost_Type_Repository objCostType_Repository = new Cost_Type_Repository();
        public Cost_Type_Service()
        {
            this.objCostType_Repository = new Cost_Type_Repository();
        }
        public Cost_Type GetGenresByID(int? ID, Type[] RelationList = null)
        {
            return objCostType_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Cost_Type> GetTalentList()
        {
            return objCostType_Repository.GetAll();
        }
        public void AddEntity(Cost_Type obj)
        {
            objCostType_Repository.Add(obj);
        }
        public void UpdateGenres(Cost_Type obj)
        {
            objCostType_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Cost_Type obj)
        {
            objCostType_Repository.Delete(obj);
        }

        public IEnumerable<Cost_Type> SearchFor(object param)
        {
            return objCostType_Repository.SearchFor(param);
        }
        public IEnumerable<Cost_Type> GetList(Type[] additionalTypes = null)
        {
            return objCostType_Repository.GetAll();
        }
        private bool ValidateDuplicate(Cost_Type objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Document_Type_Service
    {
        Document_Type_Repository objDocumentType_Repository = new Document_Type_Repository();
        public Document_Type_Service()
        {
            this.objDocumentType_Repository = new Document_Type_Repository();
        }
        public Document_Type GetGenresByID(int? ID, Type[] RelationList = null)
        {
            return objDocumentType_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Document_Type> GetTalentList()
        {
            return objDocumentType_Repository.GetAll();
        }
        public void AddEntity(Document_Type obj)
        {
            objDocumentType_Repository.Add(obj);
        }
        public void UpdateGenres(Document_Type obj)
        {
            objDocumentType_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Document_Type obj)
        {
            objDocumentType_Repository.Delete(obj);
        }

        public IEnumerable<Document_Type> SearchFor(object param)
        {
            return objDocumentType_Repository.SearchFor(param);
        }
        public IEnumerable<Document_Type> GetList(Type[] additionalTypes = null)
        {
            return objDocumentType_Repository.GetAll();
        }
        private bool ValidateDuplicate(Document_Type objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Right_Rule_Service
    {
        Right_Rule_Repository objRightRule_Repository = new Right_Rule_Repository();

        public Right_Rule_Service()
        {
            this.objRightRule_Repository = new Right_Rule_Repository();
        }
        public Right_Rule GetRightRuleByID(int? ID, Type[] RelationList = null)
        {
            return objRightRule_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Right_Rule> GetTalentList()
        {
            return objRightRule_Repository.GetAll();
        }
        public void AddEntity(Right_Rule obj)
        {
            objRightRule_Repository.Add(obj);
        }
        public void UpdateGenres(Right_Rule obj)
        {
            objRightRule_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Right_Rule obj)
        {
            objRightRule_Repository.Delete(obj);
        }

        public IEnumerable<Right_Rule> SearchFor(object param)
        {
            return objRightRule_Repository.SearchFor(param);
        }
        public IEnumerable<Right_Rule> GetList(Type[] additionalTypes = null)
        {
            return objRightRule_Repository.GetAll();
        }


        //private readonly Right_Rule_Repository objRepository;

        //public Right_Rule_Service(string Connection_Str)
        //{
        //    this.objRepository = new Right_Rule_Repository(Connection_Str);
        //}
        //public IQueryable<Right_Rule> SearchFor(Expression<Func<Right_Rule, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Right_Rule GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Right_Rule objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}
        //public bool Update(Right_Rule objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Right_Rule objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Right_Rule objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Right_Rule objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Right_Rule objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}
        private bool ValidateDuplicate(Right_Rule objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Right_Rule_Name == objToValidate.Right_Rule_Name && s.Right_Rule_Code != objToValidate.Right_Rule_Code).Count() > 0)
            //{
            //    resultSet = "Right Rule already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Country_Service
    {
        Country_Repository objCountry_Repository = new Country_Repository();

        public Country_Service()
        {
            this.objCountry_Repository = new Country_Repository();
        }
        public Country GetRightRuleByID(int? ID, Type[] RelationList = null)
        {
            return objCountry_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Country> GetTalentList()
        {
            return objCountry_Repository.GetAll();
        }
        public void AddEntity(Country obj)
        {
            objCountry_Repository.Add(obj);
        }
        public void UpdateGenres(Country obj)
        {
            objCountry_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Country obj)
        {
            objCountry_Repository.Delete(obj);
        }

        public IEnumerable<Country> SearchFor(object param)
        {
            return objCountry_Repository.SearchFor(param);
        }
        public IEnumerable<Country> GetList(Type[] additionalTypes = null)
        {
            return objCountry_Repository.GetAll();
        }

        //    //public override bool Validate(Country objToValidate, out dynamic resultSet)
        //    //{
        //    //    return ValidateDuplicate(objToValidate, out resultSet);
        //    //}

        //    //public override bool ValidateUpdate(Country objToValidate, out dynamic resultSet)
        //    //{
        //    //    return ValidateDuplicate(objToValidate, out resultSet);
        //    //}

        //    //public override bool ValidateDelete(Country objToValidate, out dynamic resultSet)
        //    //{
        //    //    return ValidateDuplicate(objToValidate, out resultSet);
        //    //}
        //    private bool ValidateDuplicate(Country objToValidate, out dynamic resultSet)
        //    {
        //        //if (SearchFor(s => s.Country_Name.Trim() == objToValidate.Country_Name.Trim() && s.Country_Code != objToValidate.Country_Code).Count() > 0)
        //        //{
        //        //    resultSet = "Country already exists";
        //        //    return false;
        //        //}

        //        resultSet = "";
        //        return true;
        //    }

    }
    public class Currency_Exchange_Rate_Service
    {
        Currency_Exchange_Rate_Repository objCurrency_Exchange_Rate_Repository = new Currency_Exchange_Rate_Repository();
        public Currency_Exchange_Rate_Service()
        {
            this.objCurrency_Exchange_Rate_Repository = new Currency_Exchange_Rate_Repository();
        }
        public Currency_Exchange_Rate GetTalentByID(int? ID, Type[] RelationList = null)
        {
            return objCurrency_Exchange_Rate_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Currency_Exchange_Rate> GetTalentList()
        {
            return objCurrency_Exchange_Rate_Repository.GetAll();
        }
        public void AddEntity(Currency_Exchange_Rate obj)
        {
            objCurrency_Exchange_Rate_Repository.Add(obj);
        }
        public void UpdateMusic_Deal(Currency_Exchange_Rate obj)
        {
            objCurrency_Exchange_Rate_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Currency_Exchange_Rate obj)
        {
            objCurrency_Exchange_Rate_Repository.Delete(obj);
        }

        public IEnumerable<Currency_Exchange_Rate> SearchFor(object param)
        {
            return objCurrency_Exchange_Rate_Repository.SearchFor(param);
        }
        public IEnumerable<Currency_Exchange_Rate> GetList(Type[] additionalTypes = null)
        {
            return objCurrency_Exchange_Rate_Repository.GetAll();
        }
        private bool ValidateDuplicate(Currency_Exchange_Rate objToValidate, out dynamic resultSet)
        {
            //if (SearchFor(s => s.Talent_Name == objToValidate.Talent_Name && s.Talent_Code != objToValidate.Talent_Code).Count() > 0)
            //{
            //    resultSet = "Talent already exists";
            //    return false;
            //}
            resultSet = "";
            return true;
        }
    }
    public class Entity_Service
    {
        Entity_Repository objEntity_Repository = new Entity_Repository();
        public Entity_Service()
        {
            this.objEntity_Repository = new Entity_Repository();
        }
        public RightsU_Dapper.Entity.Entity GetByID(int? ID, Type[] RelationList = null)
        {
            return objEntity_Repository.Get(ID, RelationList);
        }
        public IEnumerable<RightsU_Dapper.Entity.Entity> GetAll(Type[] additionalTypes = null)
        {
            return objEntity_Repository.GetAll();
        }
        public void AddEntity(RightsU_Dapper.Entity.Entity obj)
        {
            objEntity_Repository.Add(obj);
        }
        public void UpdateEntity(RightsU_Dapper.Entity.Entity obj)
        {
            objEntity_Repository.Update(obj);
        }
        public void DeleteEntity(RightsU_Dapper.Entity.Entity obj)
        {
            objEntity_Repository.Delete(obj);
        }
    }
    public class Material_Medium_Service
    {
        Material_Medium_Repository objMaterial_Medium_Repository = new Material_Medium_Repository();

        public Material_Medium_Service()
        {
            this.objMaterial_Medium_Repository = new Material_Medium_Repository();
        }
        public Material_Medium GetRightRuleByID(int? ID, Type[] RelationList = null)
        {
            return objMaterial_Medium_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Material_Medium> GetTalentList()
        {
            return objMaterial_Medium_Repository.GetAll();
        }
        public void AddEntity(Material_Medium obj)
        {
            objMaterial_Medium_Repository.Add(obj);
        }
        public void UpdateGenres(Material_Medium obj)
        {
            objMaterial_Medium_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Material_Medium obj)
        {
            objMaterial_Medium_Repository.Delete(obj);
        }
        public IEnumerable<Material_Medium> GetList(Type[] additionalTypes = null)
        {
            return objMaterial_Medium_Repository.GetAll();
        }

        //private readonly Material_Medium_Repository objRepository;

        //public Material_Medium_Service(string Connection_Str)
        //{
        //    this.objRepository = new Material_Medium_Repository(Connection_Str);
        //}
        //public IQueryable<Material_Medium> SearchFor(Expression<Func<Material_Medium, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Material_Medium GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}
        //public bool Save(Material_Medium objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public bool Update(Material_Medium objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Material_Medium objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Material_Medium objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Material_Medium objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Material_Medium objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        private bool ValidateDuplicate(Material_Medium objToValidate, out dynamic resultSet)
        {
            //if (objToValidate.EntityState != State.Deleted)
            //{
            //    int duplicateRecordCount = SearchFor(s => s.Material_Medium_Name.ToUpper() == objToValidate.Material_Medium_Name.ToUpper() &&
            //        s.Material_Medium_Code != objToValidate.Material_Medium_Code).Count();

            //    if (duplicateRecordCount > 0)
            //    {
            //        resultSet = "Material Medium already exists";
            //        return false;
            //    }
            //}

            resultSet = "";
            return true;
        }
    }
    public class Material_Type_Service
    {
        Material_Type_Repository objMaterial_Type_Repository = new Material_Type_Repository();

        public Material_Type_Service()
        {
            this.objMaterial_Type_Repository = new Material_Type_Repository();
        }
        public Material_Type GetMaterial_TypeByID(int? ID, Type[] RelationList = null)
        {
            return objMaterial_Type_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Material_Type> GetTalentList()
        {
            return objMaterial_Type_Repository.GetAll();
        }
        public void AddEntity(Material_Type obj)
        {
            objMaterial_Type_Repository.Add(obj);
        }
        public void UpdateGenres(Material_Type obj)
        {
            objMaterial_Type_Repository.Update(obj);
        }
        public void DeleteMusic_Deal(Material_Type obj)
        {
            objMaterial_Type_Repository.Delete(obj);
        }

        public IEnumerable<Material_Type> SearchFor(object param)
        {
            return objMaterial_Type_Repository.SearchFor(param);
        }
        public IEnumerable<Material_Type> GetList(Type[] additionalTypes = null)
        {
            return objMaterial_Type_Repository.GetAll();
        }
        //private readonly Material_Type_Repository objRepository;

        //public Material_Type_Service(string Connection_Str)
        //{
        //    this.objRepository = new Material_Type_Repository(Connection_Str);
        //}
        //public IQueryable<Material_Type> SearchFor(Expression<Func<Material_Type, bool>> predicate)
        //{
        //    return objRepository.SearchFor(predicate);
        //}

        //public Material_Type GetById(int id)
        //{
        //    return objRepository.GetById(id);
        //}

        //public bool Save(Material_Type objToSave, out dynamic resultSet)
        //{
        //    return base.Save(objToSave, objRepository, out resultSet);
        //}

        //public bool Update(Material_Type objToUpdate, out dynamic resultSet)
        //{
        //    return base.Update(objToUpdate, objRepository, out resultSet);
        //}

        //public bool Delete(Material_Type objToDelete, out dynamic resultSet)
        //{
        //    return base.Delete(objToDelete, objRepository, out resultSet);
        //}

        //public override bool Validate(Material_Type objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateUpdate(Material_Type objToValidate, out dynamic resultSet)
        //{
        //    return ValidateDuplicate(objToValidate, out resultSet);
        //}

        //public override bool ValidateDelete(Material_Type objToValidate, out dynamic resultSet)
        //{
        //    resultSet = "";
        //    return true;
        //}

        private bool ValidateDuplicate(Material_Type objToValidate, out dynamic resultSet)
        {
            //if (objToValidate.EntityState != State.Deleted)
            //{
            //    int duplicateRecordCount = SearchFor(s => s.Material_Type_Name.ToUpper() == objToValidate.Material_Type_Name.ToUpper() &&
            //        s.Material_Type_Code != objToValidate.Material_Type_Code).Count();

            //    if (duplicateRecordCount > 0)
            //    {
            //        resultSet = "Material Type already exists";
            //        return false;
            //    }
            //}

            resultSet = "";
            return true;
        }
    }
    public class Category_Service
    {
        Category_Repository objCategory_Repository = new Category_Repository();

        public Category_Service()
        {
            this.objCategory_Repository = new Category_Repository();
        }
        public Category GetCategoryByID(int? ID, Type[] RelationList = null)
        {
            return objCategory_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Category> GetTalentList()
        {
            return objCategory_Repository.GetAll();
        }
        public void AddEntity(Category obj)
        {
            objCategory_Repository.Add(obj);
        }
        public void UpdateCategory(Category obj)
        {
            objCategory_Repository.Update(obj);
        }
        public void DeleteCategory(Category obj)
        {
            objCategory_Repository.Delete(obj);
        }
        public IEnumerable<Category> GetList(Type[] additionalTypes = null)
        {
            return objCategory_Repository.GetAll();
        }
    }
    public class System_Parameter_New_Service
    {
        System_Parameter_New_Repository objSystem_Parameter_New_Repository = new System_Parameter_New_Repository();

        public System_Parameter_New_Service()
        {
            this.objSystem_Parameter_New_Repository = new System_Parameter_New_Repository();
        }
        public System_Parameter_New GetCategoryByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Parameter_New_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Parameter_New> GetTalentList()
        {
            return objSystem_Parameter_New_Repository.GetAll();
        }
        public void AddEntity(System_Parameter_New obj)
        {
            objSystem_Parameter_New_Repository.Add(obj);
        }
        public void UpdateCategory(System_Parameter_New obj)
        {
            objSystem_Parameter_New_Repository.Update(obj);
        }
        public void DeleteCategory(System_Parameter_New obj)
        {
            objSystem_Parameter_New_Repository.Delete(obj);
        }
        public IEnumerable<System_Parameter_New> GetList(Type[] additionalTypes = null)
        {
            return objSystem_Parameter_New_Repository.GetAll();
        }
    }
    public class Platform_Group_Service
    {
        Platform_Group_Repository objPlatform_Group_Repository = new Platform_Group_Repository();

        public Platform_Group_Service()
        {
            this.objPlatform_Group_Repository = new Platform_Group_Repository();
        }
        public Platform_Group GetPlatformGroupByID(int? ID, Type[] RelationList = null)
        {
            return objPlatform_Group_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Platform_Group> GetTalentList()
        {
            return objPlatform_Group_Repository.GetAll();
        }
        public void AddEntity(Platform_Group obj)
        {
            objPlatform_Group_Repository.Add(obj);
        }
        public void UpdateCategory(Platform_Group obj)
        {
            objPlatform_Group_Repository.Update(obj);
        }
        public void DeleteCategory(Platform_Group obj)
        {
            objPlatform_Group_Repository.Delete(obj);
        }
        public IEnumerable<Platform_Group> GetList(Type[] additionalTypes = null)
        {
            return objPlatform_Group_Repository.GetAll(additionalTypes);
        }
    }
    public class Platform_Service
    {
        Platform_Repository objPlatform_Repository = new Platform_Repository();
        public IEnumerable<Platform> GetList(Type[] additionalTypes = null)
        {
            return objPlatform_Repository.GetAll();
        }
        public Platform GetPlatformByID(int? ID, Type[] RelationList = null)
        {
            return objPlatform_Repository.Get(ID, RelationList);
        }
    }
    public class Milestone_Nature_Service
    {
        Milestone_Nature_Repository objMilestone_Nature_Repository = new Milestone_Nature_Repository();

        public Milestone_Nature_Service()
        {
            this.objMilestone_Nature_Repository = new Milestone_Nature_Repository();
        }
        public Milestone_Nature GetMilestone_NatureGroupByID(int? ID, Type[] RelationList = null)
        {
            return objMilestone_Nature_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Milestone_Nature> GetTalentList()
        {
            return objMilestone_Nature_Repository.GetAll();
        }
        public void AddEntity(Milestone_Nature obj)
        {
            objMilestone_Nature_Repository.Add(obj);
        }
        public void UpdateCategory(Milestone_Nature obj)
        {
            objMilestone_Nature_Repository.Update(obj);
        }
        public void DeleteCategory(Milestone_Nature obj)
        {
            objMilestone_Nature_Repository.Delete(obj);
        }
        public IEnumerable<Milestone_Nature> GetList(Type[] additionalTypes = null)
        {
            return objMilestone_Nature_Repository.GetAll();
        }
    }
    public class Platform_Group_Details_Service
    {
        Platform_Group_Details_Repository objPlatform_Group_Details_Repository = new Platform_Group_Details_Repository();

        public Platform_Group_Details_Service()
        {
            this.objPlatform_Group_Details_Repository = new Platform_Group_Details_Repository();
        }
        public Platform_Group_Details GetPlatform_Group_DetailsGroupByID(int? ID, Type[] RelationList = null)
        {
            return objPlatform_Group_Details_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Platform_Group_Details> GetTalentList()
        {
            return objPlatform_Group_Details_Repository.GetAll();
        }
        public void AddEntity(Platform_Group_Details obj)
        {
            objPlatform_Group_Details_Repository.Add(obj);
        }
        public void UpdateCategory(Platform_Group_Details obj)
        {
            objPlatform_Group_Details_Repository.Update(obj);
        }
        public void DeleteCategory(Platform_Group_Details obj)
        {
            objPlatform_Group_Details_Repository.Delete(obj);
        }
        public IEnumerable<Platform_Group_Details> GetList(Type[] additionalTypes = null)
        {
            return objPlatform_Group_Details_Repository.GetAll(additionalTypes);
        }

    }
    public class Program_Service
    {
        Program_Repository objProgram_Repository = new Program_Repository();

        public Program_Service()
        {
            this.objProgram_Repository = new Program_Repository();
        }
        public Program GetProgramGroupByID(int? ID, Type[] RelationList = null)
        {
            return objProgram_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Program> GetTalentList()
        {
            return objProgram_Repository.GetAll();
        }
        public void AddEntity(Program obj)
        {
            objProgram_Repository.Add(obj);
        }
        public void UpdateCategory(Program obj)
        {
            objProgram_Repository.Update(obj);
        }
        public void DeleteCategory(Program obj)
        {
            objProgram_Repository.Delete(obj);
        }
        public IEnumerable<Program> GetList(Type[] additionalTypes = null)
        {
            return objProgram_Repository.GetAll(additionalTypes);
        }
    }
    public class Deal_Type_Service
    {
        Deal_Type_Repository objDeal_Type_Repository = new Deal_Type_Repository();

        public Deal_Type_Service()
        {
            this.objDeal_Type_Repository = new Deal_Type_Repository();
        }
        public Deal_Type GetDeal_TypeByID(int? ID, Type[] RelationList = null)
        {
            return objDeal_Type_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Deal_Type> GetTalentList()
        {
            return objDeal_Type_Repository.GetAll();
        }
        public void AddEntity(Deal_Type obj)
        {
            objDeal_Type_Repository.Add(obj);
        }
        public void UpdateCategory(Deal_Type obj)
        {
            objDeal_Type_Repository.Update(obj);
        }
        public void DeleteCategory(Deal_Type obj)
        {
            objDeal_Type_Repository.Delete(obj);
        }
        public IEnumerable<Deal_Type> GetList(Type[] additionalTypes = null)
        {
            return objDeal_Type_Repository.GetAll(additionalTypes);
        }
    }
    public class Party_Category_Service
    {
        Party_Category_Repository objParty_Category_Repository = new Party_Category_Repository();

        public Party_Category_Service()
        {
            this.objParty_Category_Repository = new Party_Category_Repository();
        }
        public Party_Category GetParty_CategoryByID(int? ID, Type[] RelationList = null)
        {
            return objParty_Category_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Party_Category> GetTalentList()
        {
            return objParty_Category_Repository.GetAll();
        }
        public void AddEntity(Party_Category obj)
        {
            objParty_Category_Repository.Add(obj);
        }
        public void UpdateCategory(Party_Category obj)
        {
            objParty_Category_Repository.Update(obj);
        }
        public void DeleteCategory(Party_Category obj)
        {
            objParty_Category_Repository.Delete(obj);
        }
        public IEnumerable<Party_Category> GetList(Type[] additionalTypes = null)
        {
            return objParty_Category_Repository.GetAll(additionalTypes);
        }
    }
    public class BV_HouseId_Data_Service
    {
        BV_HouseId_Data_Repository objBV_HouseId_Data_Repository = new BV_HouseId_Data_Repository();

        public BV_HouseId_Data_Service()
        {
            this.objBV_HouseId_Data_Repository = new BV_HouseId_Data_Repository();
        }
        public BV_HouseId_Data GetBV_HouseId_DataByID(int? ID, Type[] RelationList = null)
        {
            return objBV_HouseId_Data_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BV_HouseId_Data> GetTalentList()
        {
            return objBV_HouseId_Data_Repository.GetAll();
        }
        public void AddEntity(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Add(obj);
        }
        public void UpdateBV_HouseId_Data(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Update(obj);
        }
        public void DeleteCategory(BV_HouseId_Data obj)
        {
            objBV_HouseId_Data_Repository.Delete(obj);
        }
        public IEnumerable<BV_HouseId_Data> GetList(Type[] additionalTypes = null)
        {
            return objBV_HouseId_Data_Repository.GetAll(additionalTypes);
        }

    }
    public class Acq_Deal_Movie_Service
    {
        Acq_Deal_Movie_Repository objAcq_Deal_Movie_Repository = new Acq_Deal_Movie_Repository();

        public Acq_Deal_Movie_Service()
        {
            this.objAcq_Deal_Movie_Repository = new Acq_Deal_Movie_Repository();
        }
        public Acq_Deal_Movie GetAcq_Deal_MovieByID(int? ID, Type[] RelationList = null)
        {
            return objAcq_Deal_Movie_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Acq_Deal_Movie> GetTalentList()
        {
            return objAcq_Deal_Movie_Repository.GetAll();
        }
        public void AddEntity(Acq_Deal_Movie obj)
        {
            objAcq_Deal_Movie_Repository.Add(obj);
        }
        public void UpdateAcq_Deal_Movie(Acq_Deal_Movie obj)
        {
            objAcq_Deal_Movie_Repository.Update(obj);
        }
        public void DeleteCategory(Acq_Deal_Movie obj)
        {
            objAcq_Deal_Movie_Repository.Delete(obj);
        }
        public IEnumerable<Acq_Deal_Movie> GetList(Type[] additionalTypes = null)
        {
            return objAcq_Deal_Movie_Repository.GetAll(additionalTypes);
        }
    }
    public class Title_Content_Mapping_Service
    {
        Title_Content_Mapping_Repository objTitle_Content_Mapping_Repository = new Title_Content_Mapping_Repository();

        public Title_Content_Mapping_Service()
        {
            this.objTitle_Content_Mapping_Repository = new Title_Content_Mapping_Repository();
        }
        public Title_Content_Mapping GetTitle_Content_MappingByID(int? ID, Type[] RelationList = null)
        {
            return objTitle_Content_Mapping_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Title_Content_Mapping> GetTalentList()
        {
            return objTitle_Content_Mapping_Repository.GetAll();
        }
        public void AddEntity(Title_Content_Mapping obj)
        {
            objTitle_Content_Mapping_Repository.Add(obj);
        }
        public void UpdateTitle_Content_Mapping_Movie(Title_Content_Mapping obj)
        {
            objTitle_Content_Mapping_Repository.Update(obj);
        }
        public void DeleteCategory(Title_Content_Mapping obj)
        {
            objTitle_Content_Mapping_Repository.Delete(obj);
        }
        public IEnumerable<Title_Content_Mapping> GetList(Type[] additionalTypes = null)
        {
            return objTitle_Content_Mapping_Repository.GetAll(additionalTypes);
        }
    }
    public class Email_Config_Detail_Service
    {
        Email_Config_Detail_Repository objEmail_Config_Detail_Repository = new Email_Config_Detail_Repository();

        public Email_Config_Detail_Service()
        {
            this.objEmail_Config_Detail_Repository = new Email_Config_Detail_Repository();
        }
        public Email_Config_Detail GetTitle_Content_MappingByID(int? ID, Type[] RelationList = null)
        {
            return objEmail_Config_Detail_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Email_Config_Detail> GetTalentList()
        {
            return objEmail_Config_Detail_Repository.GetAll();
        }
        public void AddEntity(Email_Config_Detail obj)
        {
            objEmail_Config_Detail_Repository.Add(obj);
        }
        public void UpdateEmail_Config_Detail_Movie(Email_Config_Detail obj)
        {
            objEmail_Config_Detail_Repository.Update(obj);
        }
        public void DeleteCategory(Email_Config_Detail obj)
        {
            objEmail_Config_Detail_Repository.Delete(obj);
        }

        public IEnumerable<Email_Config_Detail> GetList(Type[] additionalTypes = null)
        {
            return objEmail_Config_Detail_Repository.GetAll(additionalTypes);
        }
    }
    public class Email_Config_Service
    {
        Email_Config_Repository objEmail_Config_Repository = new Email_Config_Repository();

        public Email_Config_Service()
        {
            this.objEmail_Config_Repository = new Email_Config_Repository();
        }
        public Email_Config GetEmail_ConfigByID(int? ID, Type[] RelationList = null)
        {
            return objEmail_Config_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Email_Config> GetTalentList()
        {
            return objEmail_Config_Repository.GetAll();
        }
        public void AddEntity(Email_Config obj)
        {
            objEmail_Config_Repository.Add(obj);
        }
        public void UpdateTitle_Content_Mapping_Movie(Email_Config obj)
        {
            objEmail_Config_Repository.Update(obj);
        }
        public void DeleteCategory(Email_Config obj)
        {
            objEmail_Config_Repository.Delete(obj);
        }
        public IEnumerable<Email_Config> GetList(Type[] additionalTypes = null)
        {
            return objEmail_Config_Repository.GetAll(additionalTypes);
        }
    }
    public class Channel_Service
    {
        Channel_Repository objChannel_Repository = new Channel_Repository();

        public Channel_Service()
        {
            this.objChannel_Repository = new Channel_Repository();
        }
        public Channel GetChannelByID(int? ID, Type[] RelationList = null)
        {
            return objChannel_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Channel> GetTalentList()
        {
            return objChannel_Repository.GetAll();
        }
        public void AddEntity(Channel obj)
        {
            objChannel_Repository.Add(obj);
        }
        public void UpdateChannel(Channel obj)
        {
            objChannel_Repository.Update(obj);
        }
        public void DeleteCategory(Channel obj)
        {
            objChannel_Repository.Delete(obj);
        }
        public IEnumerable<Channel> GetList(Type[] additionalTypes = null)
        {
            return objChannel_Repository.GetAll(additionalTypes);
        }
    }
    public class Security_Group_Service
    {
        Security_Group_Repository objSecurity_Group_Repository = new Security_Group_Repository();

        public Security_Group_Service()
        {
            this.objSecurity_Group_Repository = new Security_Group_Repository();
        }
        public Security_Group GetSecurity_GroupByID(int? ID, Type[] RelationList = null)
        {
            return objSecurity_Group_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Security_Group> GetTalentList()
        {
            return objSecurity_Group_Repository.GetAll();
        }
        public void AddEntity(Security_Group obj)
        {
            objSecurity_Group_Repository.Add(obj);
        }
        public void UpdateChannel(Security_Group obj)
        {
            objSecurity_Group_Repository.Update(obj);
        }
        public void DeleteCategory(Security_Group obj)
        {
            objSecurity_Group_Repository.Delete(obj);
        }

        public IEnumerable<Security_Group> GetList(Type[] additionalTypes = null)
        {
            return objSecurity_Group_Repository.GetAll(additionalTypes);
        }
    }
    public class Payment_Term_Service
    {
        Payment_Terms_Repository objPayment_Term_Repository = new Payment_Terms_Repository();
        public Payment_Term_Service()
        {
            this.objPayment_Term_Repository = new Payment_Terms_Repository();
        }
        public Payment_Term GetByID(int? ID, Type[] RelationList = null)
        {
            return objPayment_Term_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Payment_Term> GetAll()
        {
            return objPayment_Term_Repository.GetAll();
        }
        public void AddEntity(Payment_Term obj)
        {
            objPayment_Term_Repository.Add(obj);
        }
        public void UpdateEntity(Payment_Term obj)
        {
            objPayment_Term_Repository.Update(obj);
        }
        public void DeleteEntity(Payment_Term obj)
        {
            objPayment_Term_Repository.Delete(obj);
        }

    }
    public class Royalty_Recoupment_Service
    {
        Royalty_Recoupment_Repository objRoyalty_Recoupment_Repository = new Royalty_Recoupment_Repository();
        public Royalty_Recoupment_Service()
        {
            this.objRoyalty_Recoupment_Repository = new Royalty_Recoupment_Repository();
        }
        public Royalty_Recoupment GetByID(int? ID, Type[] RelationList = null)
        {
            return objRoyalty_Recoupment_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Royalty_Recoupment> GetAll()
        {
            return objRoyalty_Recoupment_Repository.GetAll();
        }
        public void AddEntity(Royalty_Recoupment obj)
        {
            objRoyalty_Recoupment_Repository.Add(obj);
        }
        public void UpdateEntity(Royalty_Recoupment obj)
        {
            objRoyalty_Recoupment_Repository.Update(obj);
        }
        public void DeleteEntity(Royalty_Recoupment obj)
        {
            objRoyalty_Recoupment_Repository.Delete(obj);
        }

    }
    public class Royalty_Recoupment_Details_Service
    {
        Royalty_Recoupment_Details_Repository objRoyalty_Recoupment_Details_Repository = new Royalty_Recoupment_Details_Repository();
        public Royalty_Recoupment_Details_Service()
        {
            this.objRoyalty_Recoupment_Details_Repository = new Royalty_Recoupment_Details_Repository();
        }
        public Royalty_Recoupment_Details GetByID(int? ID, Type[] RelationList = null)
        {
            return objRoyalty_Recoupment_Details_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Royalty_Recoupment_Details> GetAll()
        {
            return objRoyalty_Recoupment_Details_Repository.GetAll();
        }
        public void AddEntity(Royalty_Recoupment_Details obj)
        {
            objRoyalty_Recoupment_Details_Repository.Add(obj);
        }
        public void UpdateEntity(Royalty_Recoupment_Details obj)
        {
            objRoyalty_Recoupment_Details_Repository.Update(obj);
        }
        public void DeleteEntity(Royalty_Recoupment_Details obj)
        {
            objRoyalty_Recoupment_Details_Repository.Delete(obj);
        }

    }
    public class User_Service
    {
        User_Repository objUser_Repository = new User_Repository();
        public User_Service()
        {
            this.objUser_Repository = new User_Repository();
        }
        public User GetByID(int? ID, Type[] RelationList = null)
        {
            return objUser_Repository.Get(ID, RelationList);
        }
        public IEnumerable<User> GetAll()
        {
            return objUser_Repository.GetAll();
        }
        public void AddEntity(User obj)
        {
            objUser_Repository.Add(obj);
        }
        public void UpdateEntity(User obj)
        {
            objUser_Repository.Update(obj);
        }
        public void DeleteEntity(User obj)
        {
            objUser_Repository.Delete(obj);
        }

    }
    public class Users_Exclusive_Rights_Service
    {
        Users_Exclusion_Rights_Repository objUsers_Exclusion_Rights_Repository = new Users_Exclusion_Rights_Repository();
        public Users_Exclusive_Rights_Service()
        {
            this.objUsers_Exclusion_Rights_Repository = new Users_Exclusion_Rights_Repository();
        }
        public Users_Exclusion_Rights GetByID(int? ID, Type[] RelationList = null)
        {
            return objUsers_Exclusion_Rights_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Users_Exclusion_Rights> GetAll()
        {
            return objUsers_Exclusion_Rights_Repository.GetAll();
        }
        public void AddEntity(Users_Exclusion_Rights obj)
        {
            objUsers_Exclusion_Rights_Repository.Add(obj);
        }
        public void UpdateEntity(Users_Exclusion_Rights obj)
        {
            objUsers_Exclusion_Rights_Repository.Update(obj);
        }
        public void DeleteEntity(Users_Exclusion_Rights obj)
        {
            objUsers_Exclusion_Rights_Repository.Delete(obj);
        }

    }
    public class Business_Unit_Service
    {
        Business_Unit_Repository objBusiness_Unit_Repository = new Business_Unit_Repository();
        public Business_Unit_Service()
        {
            this.objBusiness_Unit_Repository = new Business_Unit_Repository();
        }
        public Business_Unit GetByID(int? ID, Type[] RelationList = null)
        {
            return objBusiness_Unit_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Business_Unit> GetAll()
        {
            return objBusiness_Unit_Repository.GetAll();
        }
        public void AddEntity(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Add(obj);
        }
        public void UpdateEntity(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Update(obj);
        }
        public void DeleteEntity(Business_Unit obj)
        {
            objBusiness_Unit_Repository.Delete(obj);
        }

    }
    public class Users_Password_Detail_Service
    {
        Users_Password_Detail_Repository objUsers_Password_Detail_Repository = new Users_Password_Detail_Repository();
        public Users_Password_Detail_Service()
        {
            this.objUsers_Password_Detail_Repository = new Users_Password_Detail_Repository();
        }
        public Users_Password_Detail GetByID(int? ID, Type[] RelationList = null)
        {
            return objUsers_Password_Detail_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Users_Password_Detail> GetAll()
        {
            return objUsers_Password_Detail_Repository.GetAll();
        }
        public void AddEntity(Users_Password_Detail obj)
        {
            objUsers_Password_Detail_Repository.Add(obj);
        }
        public void UpdateEntity(Users_Password_Detail obj)
        {
            objUsers_Password_Detail_Repository.Update(obj);
        }
        public void DeleteEntity(Users_Password_Detail obj)
        {
            objUsers_Password_Detail_Repository.Delete(obj);
        }

    }
    public class SAP_WBS_Service
    {
        SAP_WBS_Repository objSAP_WBS_Repository = new SAP_WBS_Repository();
        public SAP_WBS_Service()
        {
            this.objSAP_WBS_Repository = new SAP_WBS_Repository();
        }
        public SAP_WBS GetByID(int? ID, Type[] RelationList = null)
        {
            return objSAP_WBS_Repository.Get(ID, RelationList);
        }
        public IEnumerable<SAP_WBS> GetAll()
        {
            return objSAP_WBS_Repository.GetAll();
        }
        public void AddEntity(SAP_WBS obj)
        {
            objSAP_WBS_Repository.Add(obj);
        }
        public void UpdateEntity(SAP_WBS obj)
        {
            objSAP_WBS_Repository.Update(obj);
        }
        public void DeleteEntity(SAP_WBS obj)
        {
            objSAP_WBS_Repository.Delete(obj);
        }

    }
    public class BVException_Service
    {
        BVException_Repository objBVException_Repository = new BVException_Repository();
        public BVException_Service()
        {
            this.objBVException_Repository = new BVException_Repository();
        }
        public BVException GetByID(int? ID, Type[] RelationList = null)
        {
            return objBVException_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BVException> GetAll(Type[] RelationList = null)
        {
            return objBVException_Repository.GetAll(RelationList);
        }
        public void AddEntity(BVException obj)
        {
            objBVException_Repository.Add(obj);
        }
        public void UpdateEntity(BVException obj)
        {
            objBVException_Repository.Update(obj);
        }
        public void DeleteEntity(BVException obj)
        {
            objBVException_Repository.Delete(obj);
        }

    }

    public class System_Language_Service
    {
        System_Language_Repository objSystem_Language_Repository = new System_Language_Repository();
        public System_Language_Service()
        {
            this.objSystem_Language_Repository = new System_Language_Repository();
        }
        public System_Language GetByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Language_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Language> GetAll(Type[] RelationList = null)
        {
            return objSystem_Language_Repository.GetAll(RelationList);
        }
        public void AddEntity(System_Language obj)
        {
            objSystem_Language_Repository.Add(obj);
        }
        public void UpdateEntity(System_Language obj)
        {
            objSystem_Language_Repository.Update(obj);
        }
        public void DeleteEntity(System_Language obj)
        {
            objSystem_Language_Repository.Delete(obj);
        }
    }

    public class System_Module_Message_Service
    {
        System_Module_Message_Repository objSystem_Module_Message_Repository = new System_Module_Message_Repository();
        public System_Module_Message_Service()
        {
            this.objSystem_Module_Message_Repository = new System_Module_Message_Repository();
        }
        public System_Module_Message GetByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Module_Message_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Module_Message> GetAll(Type[] RelationList = null)
        {
            return objSystem_Module_Message_Repository.GetAll(RelationList);
        }
        public void AddEntity(System_Module_Message obj)
        {
            objSystem_Module_Message_Repository.Add(obj);
        }
        public void UpdateEntity(System_Module_Message obj)
        {
            objSystem_Module_Message_Repository.Update(obj);
        }
        public void DeleteEntity(System_Module_Message obj)
        {
            objSystem_Module_Message_Repository.Delete(obj);
        }
    }
    public class System_Module_Service
    {
        System_Module_Repository objSystem_Module_Repository = new System_Module_Repository();
        public System_Module_Service()
        {
            this.objSystem_Module_Repository = new System_Module_Repository();
        }
        public System_Module GetByID(int? ID, Type[] RelationList = null)
        {
            return objSystem_Module_Repository.Get(ID, RelationList);
        }
        public IEnumerable<System_Module> GetAll(Type[] RelationList = null)
        {
            return objSystem_Module_Repository.GetAll(RelationList);
        }
        public void AddEntity(System_Module obj)
        {
            objSystem_Module_Repository.Add(obj);
        }
        public void UpdateEntity(System_Module obj)
        {
            objSystem_Module_Repository.Update(obj);
        }
        public void DeleteEntity(System_Module obj)
        {
            objSystem_Module_Repository.Delete(obj);
        }
    }
    public class USP_GetSystem_Language_Message_ByModule_Service
    {
        USP_GetSystem_Language_Message_ByModule_Repository objUSP_Repository = new USP_GetSystem_Language_Message_ByModule_Repository();

        public USP_GetSystem_Language_Message_ByModule_Service()
        {
            this.objUSP_Repository = new USP_GetSystem_Language_Message_ByModule_Repository();
        }
        public IEnumerable<USP_GetSystem_Language_Message_ByModule_Result> USP_GetSystem_Language_Message_ByModule(Nullable<int> module_Code, string form_ID, Nullable<int> system_Language_Code)
        {
            return objUSP_Repository.USP_GetSystem_Language_Message_ByModule(module_Code, form_ID, system_Language_Code);
        }
    }
    public class Workflow_Module_Service
    {
        Workflow_Module_Repository objWorkflow_Module_Repository = new Workflow_Module_Repository();
        public Workflow_Module_Service()
        {
            this.objWorkflow_Module_Repository = new Workflow_Module_Repository();
        }
        public Workflow_Module GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Module_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow_Module> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Module_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow_Module obj)
        {
            objWorkflow_Module_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow_Module obj)
        {
            objWorkflow_Module_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow_Module obj)
        {
            objWorkflow_Module_Repository.Delete(obj);
        }
    }
    public class Workflow_Service
    {
        Workflow_Repository objWorkflow_Repository = new Workflow_Repository();
        public Workflow_Service()
        {
            this.objWorkflow_Repository = new Workflow_Repository();
        }
        public Workflow GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow obj)
        {
            objWorkflow_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow obj)
        {
            objWorkflow_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow obj)
        {
            objWorkflow_Repository.Delete(obj);
        }
    }
    public class Workflow_Role_Service
    {
        Workflow_Role_Repository objWorkflow_Role_Repository = new Workflow_Role_Repository();
        public Workflow_Role_Service()
        {
            this.objWorkflow_Role_Repository = new Workflow_Role_Repository();
        }
        public Workflow_Role GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Role_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow_Role> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Role_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow_Role obj)
        {
            objWorkflow_Role_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow_Role obj)
        {
            objWorkflow_Role_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow_Role obj)
        {
            objWorkflow_Role_Repository.Delete(obj);
        }
    }
    public class Workflow_Module_Role_Service
    {
        Workflow_Module_Role_Repository objWorkflow_Module_Role_Repository = new Workflow_Module_Role_Repository();
        public Workflow_Module_Role_Service()
        {
            this.objWorkflow_Module_Role_Repository = new Workflow_Module_Role_Repository();
        }
        public Workflow_Module_Role GetByID(int? ID, Type[] RelationList = null)
        {
            return objWorkflow_Module_Role_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Workflow_Module_Role> GetAll(Type[] RelationList = null)
        {
            return objWorkflow_Module_Role_Repository.GetAll(RelationList);
        }
        public void AddEntity(Workflow_Module_Role obj)
        {
            objWorkflow_Module_Role_Repository.Add(obj);
        }
        public void UpdateEntity(Workflow_Module_Role obj)
        {
            objWorkflow_Module_Role_Repository.Update(obj);
        }
        public void DeleteEntity(Workflow_Module_Role obj)
        {
            objWorkflow_Module_Role_Repository.Delete(obj);
        }
    }
    public class Users_Business_Unit_Service
    {
        Users_Business_Unit_Repository objUsers_Business_Unit_Repository = new Users_Business_Unit_Repository();
        public Users_Business_Unit_Service()
        {
            this.objUsers_Business_Unit_Repository = new Users_Business_Unit_Repository();
        }
        public Users_Business_Unit GetByID(int? ID, Type[] RelationList = null)
        {
            return objUsers_Business_Unit_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Users_Business_Unit> GetAll(Type[] RelationList = null)
        {
            return objUsers_Business_Unit_Repository.GetAll(RelationList);
        }
        public void AddEntity(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Add(obj);
        }
        public void UpdateEntity(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Update(obj);
        }
        public void DeleteEntity(Users_Business_Unit obj)
        {
            objUsers_Business_Unit_Repository.Delete(obj);
        }
    }
    public class USP_Validate_Episode_Service
    {
        USP_Validate_Episode_Repository objUSP_Repository = new USP_Validate_Episode_Repository();

        public USP_Validate_Episode_Service()
        {
            this.objUSP_Repository = new USP_Validate_Episode_Repository();
        }
        public IEnumerable<USP_Validate_Episode_Result> USP_Validate_Episode(string title_with_Episode, string Program_Type)
        {
            return objUSP_Repository.USP_Validate_Episode(title_with_Episode, Program_Type);
        }
    }
    public class USP_UpdateContentHouseID_Service
    {
        USP_UpdateContentHouseID_Repository objUSP_UpdateContentHouseID_Repository = new USP_UpdateContentHouseID_Repository();

        public USP_UpdateContentHouseID_Service()
        {
            this.objUSP_UpdateContentHouseID_Repository = new USP_UpdateContentHouseID_Repository();
        }
        public void USP_UpdateContentHouseID(Nullable<int> BV_HouseId_Data_Code, Nullable<int> MappedDealTitleCode)
        {
            objUSP_UpdateContentHouseID_Repository.USP_UpdateContentHouseID(BV_HouseId_Data_Code, MappedDealTitleCode);
        }
    }
    public class BMS_Log_Service
    {
        BMS_Log_Repository objBMS_Log_Repository = new BMS_Log_Repository();
        public BMS_Log_Service()
        {
            this.objBMS_Log_Repository = new BMS_Log_Repository();
        }
        public BMS_Log GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Log_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Log> GetAll(Type[] RelationList = null)
        {
            return objBMS_Log_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Log obj)
        {
            objBMS_Log_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Log obj)
        {
            objBMS_Log_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Log obj)
        {
            objBMS_Log_Repository.Delete(obj);
        }
    }

    public class USP_List_BMS_log_Service
    {
        USP_List_BMS_log_Repository objUSP_Repository = new USP_List_BMS_log_Repository();

        public USP_List_BMS_log_Service()
        {
            this.objUSP_Repository = new USP_List_BMS_log_Repository();
        }
        public IEnumerable<USP_List_BMS_log_Result> USP_List_BMS_log(string strSearch, Nullable<int> pageNo, string isPaging, Nullable<int> pageSize, out int recordCount)
        {
            return objUSP_Repository.USP_List_BMS_log(strSearch, pageNo, isPaging, pageSize, out recordCount);
        }
    }
    public class BMS_All_Masters_Service
    {
        BMS_All_Masters_Repository objBMS_All_Masters_Repository = new BMS_All_Masters_Repository();
        public BMS_All_Masters_Service()
        {
            this.objBMS_All_Masters_Repository = new BMS_All_Masters_Repository();
        }
        public BMS_All_Masters GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_All_Masters_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_All_Masters> GetAll(Type[] RelationList = null)
        {
            return objBMS_All_Masters_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_All_Masters obj)
        {
            objBMS_All_Masters_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_All_Masters obj)
        {
            objBMS_All_Masters_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_All_Masters obj)
        {
            objBMS_All_Masters_Repository.Delete(obj);
        }
    }
    public class USP_List_Amort_Rule_Service
    {
        USP_List_Amort_Rule_Repository objUSP_Repository = new USP_List_Amort_Rule_Repository();

        public USP_List_Amort_Rule_Service()
        {
            this.objUSP_Repository = new USP_List_Amort_Rule_Repository();
        }
        public IEnumerable<USP_List_Amort_Rule_Result> USP_List_Amort_Rule(string strSearch, Nullable<int> pageNo, string orderByCndition, string isPaging, Nullable<int> pageSize, out int recordCount, Nullable<int> user_Code, string moduleCode)
        {
            return objUSP_Repository.USP_List_Amort_Rule(strSearch, pageNo, orderByCndition, isPaging, pageSize, out recordCount, user_Code, moduleCode);
        }
    }
    public class Amort_Rule_Service
    {
        Amort_Rule_Repository objAmort_Rule_Repository = new Amort_Rule_Repository();
        public Amort_Rule_Service()
        {
            this.objAmort_Rule_Repository = new Amort_Rule_Repository();
        }
        public Amort_Rule GetByID(int? ID, Type[] RelationList = null)
        {
            return objAmort_Rule_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Amort_Rule> GetAll(Type[] RelationList = null)
        {
            return objAmort_Rule_Repository.GetAll(RelationList);
        }
        public void AddEntity(Amort_Rule obj)
        {
            objAmort_Rule_Repository.Add(obj);
        }
        public void UpdateEntity(Amort_Rule obj)
        {
            objAmort_Rule_Repository.Update(obj);
        }
        public void DeleteEntity(Amort_Rule obj)
        {
            objAmort_Rule_Repository.Delete(obj);
        }
    }
    public class USPBindJobAndExecute_Service
    {
        USPBindJobAndExecute_Repository objUSP_Repository = new USPBindJobAndExecute_Repository();

        public USPBindJobAndExecute_Service()
        {
            this.objUSP_Repository = new USPBindJobAndExecute_Repository();
        }
        public IEnumerable<USPBindJobAndExecute_Result> USPBindJobAndExecute(string type, string jobName)
        {
            return objUSP_Repository.USPBindJobAndExecute(type, jobName);
        }
    }
    public class USPRUBVMappingList_Service
    {
        USPRUBVMappingList_Repository objUSP_Repository = new USPRUBVMappingList_Repository();

        public USPRUBVMappingList_Service()
        {
            this.objUSP_Repository = new USPRUBVMappingList_Repository();
        }
        public IEnumerable<USPRUBVMappingList_Result> USPRUBVMappingList(string dropdownOption, string tabselect, Nullable<int> pageNo, Nullable<int> pageSize, out int recordCount)
        {
            return objUSP_Repository.USPRUBVMappingList(dropdownOption, tabselect, pageNo, pageSize, out recordCount);
        }
    }
    public class BMS_Asset_Service
    {
        BMS_Asset_Repository objBMS_Asset_Repository = new BMS_Asset_Repository();
        public BMS_Asset_Service()
        {
            this.objBMS_Asset_Repository = new BMS_Asset_Repository();
        }
        public BMS_Asset GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Asset_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Asset> GetAll(Type[] RelationList = null)
        {
            return objBMS_Asset_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Asset obj)
        {
            objBMS_Asset_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Asset obj)
        {
            objBMS_Asset_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Asset obj)
        {
            objBMS_Asset_Repository.Delete(obj);
        }
    }
    public class BMS_Deal_Content_Service
    {
        BMS_Deal_Content_Repository objBMS_Deal_Content_Repository = new BMS_Deal_Content_Repository();
        public BMS_Deal_Content_Service()
        {
            this.objBMS_Deal_Content_Repository = new BMS_Deal_Content_Repository();
        }
        public BMS_Deal_Content GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Deal_Content> GetAll(Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Deal_Content obj)
        {
            objBMS_Deal_Content_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Deal_Content obj)
        {
            objBMS_Deal_Content_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Deal_Content obj)
        {
            objBMS_Deal_Content_Repository.Delete(obj);
        }
    }
    public class BMS_Deal_Content_Rights_Service
    {
        BMS_Deal_Content_Rights_Repository objBMS_Deal_Content_Rights_Repository = new BMS_Deal_Content_Rights_Repository();
        public BMS_Deal_Content_Rights_Service()
        {
            this.objBMS_Deal_Content_Rights_Repository = new BMS_Deal_Content_Rights_Repository();
        }
        public BMS_Deal_Content_Rights GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Rights_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Deal_Content_Rights> GetAll(Type[] RelationList = null)
        {
            return objBMS_Deal_Content_Rights_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Deal_Content_Rights obj)
        {
            objBMS_Deal_Content_Rights_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Deal_Content_Rights obj)
        {
            objBMS_Deal_Content_Rights_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Deal_Content_Rights obj)
        {
            objBMS_Deal_Content_Rights_Repository.Delete(obj);
        }
    }
    public class BMS_Deal_Service
    {
        BMS_Deal_Repository objBMS_Deal_Repository = new BMS_Deal_Repository();
        public BMS_Deal_Service()
        {
            this.objBMS_Deal_Repository = new BMS_Deal_Repository();
        }
        public BMS_Deal GetByID(int? ID, Type[] RelationList = null)
        {
            return objBMS_Deal_Repository.Get(ID, RelationList);
        }
        public IEnumerable<BMS_Deal> GetAll(Type[] RelationList = null)
        {
            return objBMS_Deal_Repository.GetAll(RelationList);
        }
        public void AddEntity(BMS_Deal obj)
        {
            objBMS_Deal_Repository.Add(obj);
        }
        public void UpdateEntity(BMS_Deal obj)
        {
            objBMS_Deal_Repository.Update(obj);
        }
        public void DeleteEntity(BMS_Deal obj)
        {
            objBMS_Deal_Repository.Delete(obj);
        }
    }
    public class Music_Language_Service
    {
        Music_Language_Repository objMusic_Language_Repository = new Music_Language_Repository();
        public Music_Language_Service()
        {
            this.objMusic_Language_Repository = new Music_Language_Repository();
        }
        public Music_Language GetByID(int? ID, Type[] RelationList = null)
        {
            return objMusic_Language_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Music_Language> GetAll(Type[] RelationList = null)
        {
            return objMusic_Language_Repository.GetAll(RelationList);
        }
        public void AddEntity(Music_Language obj)
        {
            objMusic_Language_Repository.Add(obj);
        }
        public void UpdateEntity(Music_Language obj)
        {
            objMusic_Language_Repository.Update(obj);
        }
        public void DeleteEntity(Music_Language obj)
        {
            objMusic_Language_Repository.Delete(obj);
        }
    }





























    public class Music_Label_Service
    {
        Music_Label_Repository objMusic_Label_Repository = new Music_Label_Repository();
        public Music_Label_Service()
        {
            this.objMusic_Label_Repository = new Music_Label_Repository();
        }
        public Music_Label GetByID(int? ID, Type[] RelationList = null)
        {
            return objMusic_Label_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Music_Label> GetAll(Type[] RelationList = null)
        {
            return objMusic_Label_Repository.GetAll(RelationList);
        }
        public void AddEntity(Music_Label obj)
        {
            objMusic_Label_Repository.Add(obj);
        }
        public void UpdateEntity(Music_Label obj)
        {
            objMusic_Label_Repository.Update(obj);
        }
        public void DeleteEntity(Music_Label obj)
        {
            objMusic_Label_Repository.Delete(obj);
        }
    }
    public class Title_Service
    {
        Title_Repository objTitle_Repository = new Title_Repository();
        public Title_Service()
        {
            this.objTitle_Repository = new Title_Repository();
        }
        public Title GetByID(int? ID, Type[] RelationList = null)
        {
            return objTitle_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Title> GetAll(Type[] RelationList = null)
        {
            return objTitle_Repository.GetAll(RelationList);
        }
        public void AddEntity(Title obj)
        {
            objTitle_Repository.Add(obj);
        }
        public void UpdateEntity(Title obj)
        {
            objTitle_Repository.Update(obj);
        }
        public void DeleteEntity(Title obj)
        {
            objTitle_Repository.Delete(obj);
        }
    }
    public class Music_Album_Service
    {
        Music_Album_Repository objMusic_Album_Repository = new Music_Album_Repository();
        public Music_Album_Service()
        {
            this.objMusic_Album_Repository = new Music_Album_Repository();
        }
        public Music_Album GetByID(int? ID, Type[] RelationList = null)
        {
            return objMusic_Album_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Music_Album> GetAll(Type[] RelationList = null)
        {
            return objMusic_Album_Repository.GetAll(RelationList);
        }
        public void AddEntity(Music_Album obj)
        {
            objMusic_Album_Repository.Add(obj);
        }
        public void UpdateEntity(Music_Album obj)
        {
            objMusic_Album_Repository.Update(obj);
        }
        public void DeleteEntity(Music_Album obj)
        {
            objMusic_Album_Repository.Delete(obj);
        }
    }
    public class Music_Album_Talent_Service
    {
        Music_Album_Talent_Repository objMusic_Album_Talent_Repository = new Music_Album_Talent_Repository();
        public Music_Album_Talent_Service()
        {
            this.objMusic_Album_Talent_Repository = new Music_Album_Talent_Repository();
        }
        public Music_Album_Talent GetByID(int? ID, Type[] RelationList = null)
        {
            return objMusic_Album_Talent_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Music_Album_Talent> GetAll(Type[] RelationList = null)
        {
            return objMusic_Album_Talent_Repository.GetAll(RelationList);
        }
        public void AddEntity(Music_Album_Talent obj)
        {
            objMusic_Album_Talent_Repository.Add(obj);
        }
        public void UpdateEntity(Music_Album_Talent obj)
        {
            objMusic_Album_Talent_Repository.Update(obj);
        }
        public void DeleteEntity(Music_Album_Talent obj)
        {
            objMusic_Album_Talent_Repository.Delete(obj);
        }
    }
    public class Music_Theme_Service
    {
        Music_Theme_Repository objMusic_Theme_Repository = new Music_Theme_Repository();
        public Music_Theme_Service()
        {
            this.objMusic_Theme_Repository = new Music_Theme_Repository();
        }
        public Music_Theme GetByID(int? ID, Type[] RelationList = null)
        {
            return objMusic_Theme_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Music_Theme> GetAll(Type[] RelationList = null)
        {
            return objMusic_Theme_Repository.GetAll(RelationList);
        }
        public void AddEntity(Music_Theme obj)
        {
            objMusic_Theme_Repository.Add(obj);
        }
        public void UpdateEntity(Music_Theme obj)
        {
            objMusic_Theme_Repository.Update(obj);
        }
        public void DeleteEntity(Music_Theme obj)
        {
            objMusic_Theme_Repository.Delete(obj);
        }
    }
    public class Vendor_Service
    {
        Vendor_Repository objVendor_Repository = new Vendor_Repository();
        public Vendor_Service()
        {
            this.objVendor_Repository = new Vendor_Repository();
        }
        public Vendor GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Vendor> GetAll(Type[] additionalTypes = null)
        {
            return objVendor_Repository.GetAll(additionalTypes);
        }
        public void AddEntity(Vendor obj)
        {
            objVendor_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor obj)
        {
            objVendor_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor obj)
        {
            objVendor_Repository.Delete(obj);
        }
        public bool Validate(Vendor objToValidate, out string resultSet)
        {
            return ValidateDuplicate(objToValidate, out resultSet);
        }
        private bool ValidateDuplicate(Vendor objToValidate, out string resultSet)
        {
            if (GetAll().Where(s => s.Vendor_Name == objToValidate.Vendor_Name && s.Vendor_Code != objToValidate.Vendor_Code).Count() > 0)
            {
                resultSet = "Party already exists";
                return false;
            }

            resultSet = "";
            return true;
        }
    }
    public class Vendor_Country_Service
    {
        Vendor_Country_Repository objVendor_Country_Repository = new Vendor_Country_Repository();
        public Vendor_Country_Service()
        {
            this.objVendor_Country_Repository = new Vendor_Country_Repository();
        }
        public Vendor_Country GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Country_Repository.Get(ID, RelationList);
        }
        public void AddEntity(Vendor_Country obj)
        {
            objVendor_Country_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor_Country obj)
        {
            objVendor_Country_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor_Country obj)
        {
            objVendor_Country_Repository.Delete(obj);
        }
    }
    public class Vendor_Role_Service
    {
        Vendor_Role_Repository objVendor_Role_Repository = new Vendor_Role_Repository();
        public Vendor_Role_Service()
        {
            this.objVendor_Role_Repository = new Vendor_Role_Repository();
        }
        public Vendor_Role GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Role_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Vendor_Role> GetAll()
        {
            return objVendor_Role_Repository.GetAll();
        }
        public void AddEntity(Vendor_Role obj)
        {
            objVendor_Role_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor_Role obj)
        {
            objVendor_Role_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor_Role obj)
        {
            objVendor_Role_Repository.Delete(obj);
        }
    }
    public class Party_Group_Service
    {
        Party_Group_Repository objParty_Group_Repository = new Party_Group_Repository();
        public Party_Group_Service()
        {
            this.objParty_Group_Repository = new Party_Group_Repository();
        }
        public Party_Group GetByID(int? ID, Type[] RelationList = null)
        {
            return objParty_Group_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Party_Group> GetAll()
        {
            return objParty_Group_Repository.GetAll();
        }
        public void AddEntity(Party_Group obj)
        {
            objParty_Group_Repository.Add(obj);
        }
        public void UpdateEntity(Party_Group obj)
        {
            objParty_Group_Repository.Update(obj);
        }
        public void DeleteEntity(Party_Group obj)
        {
            objParty_Group_Repository.Delete(obj);
        }
    }
    public class Vendor_Contacts_Service
    {
        Vendor_Contacts_Repository objVendor_Contacts_Repository = new Vendor_Contacts_Repository();
        public Vendor_Contacts_Service()
        {
            this.objVendor_Contacts_Repository = new Vendor_Contacts_Repository();
        }
        public Vendor_Contacts GetByID(int? ID, Type[] RelationList = null)
        {
            return objVendor_Contacts_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Vendor_Contacts> GetAll()
        {
            return objVendor_Contacts_Repository.GetAll();
        }
        public void AddEntity(Vendor_Contacts obj)
        {
            objVendor_Contacts_Repository.Add(obj);
        }
        public void UpdateEntity(Vendor_Contacts obj)
        {
            objVendor_Contacts_Repository.Update(obj);
        }
        public void DeleteEntity(Vendor_Contacts obj)
        {
            objVendor_Contacts_Repository.Delete(obj);
        }
    }
    public class USP_MODULE_RIGHTS_Service
    {
        USP_MODULE_RIGHTS_Repository objUSP_Repository = new USP_MODULE_RIGHTS_Repository();

        public USP_MODULE_RIGHTS_Service()
        {
            this.objUSP_Repository = new USP_MODULE_RIGHTS_Repository();
        }
        public string USP_MODULE_RIGHTS(Nullable<int> module_Code, Nullable<int> security_Group_Code, Nullable<int> users_Code)
        {
            return objUSP_Repository.USP_MODULE_RIGHTS(module_Code, security_Group_Code, users_Code);
        }
    }
    public class Territory_Services
    {
        Territory_Repository objTerritory_Repository = new Territory_Repository();
        public Territory_Services()
        {
            this.objTerritory_Repository = new Territory_Repository();
        }
        public Territory GetByID(int? ID, Type[] RelationList = null)
        {
            return objTerritory_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Territory> GetAll(Type[] additionalTypes = null)
        {
            return objTerritory_Repository.GetAll();
        }
        public void AddEntity(Territory obj)
        {
            objTerritory_Repository.Add(obj);
        }
        public void UpdateEntity(Territory obj)
        {
            objTerritory_Repository.Update(obj);
        }
        public void DeleteEntity(Territory obj)
        {
            objTerritory_Repository.Delete(obj);
        }
    }
    public class Territory_Details_Services
    {
        Territory_Details_Repository objTerritory_Details_Repository = new Territory_Details_Repository();
        public Territory_Details_Services()
        {
            this.objTerritory_Details_Repository = new Territory_Details_Repository();
        }
        public Territory_Details GetByID(int? ID, Type[] RelationList = null)
        {
            return objTerritory_Details_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Territory_Details> GetAll(Type[] additionalTypes = null)
        {
            return objTerritory_Details_Repository.GetAll();
        }
        public void AddEntity(Territory_Details obj)
        {
            objTerritory_Details_Repository.Add(obj);
        }
        public void UpdateEntity(Territory_Details obj)
        {
            objTerritory_Details_Repository.Update(obj);
        }
        public void DeleteEntity(Territory_Details obj)
        {
            objTerritory_Details_Repository.Delete(obj);
        }
    }
    public class USP_List_Territory_Service
    {
        USP_List_Territory_Repository objUSP_List_Territory_Repository = new USP_List_Territory_Repository();

        public USP_List_Territory_Service()
        {
            this.objUSP_List_Territory_Repository = new USP_List_Territory_Repository();
        }
        public IEnumerable<USP_List_Territory_Result> USP_List_Territory(Nullable<int> sysLanguageCode)
        {
            return objUSP_List_Territory_Repository.USP_List_Territory(sysLanguageCode);
        }
    }
    public class Additional_Expense_Services
    {
        Addtional_Expense_Repository objAddtional_Expense_Repository = new Addtional_Expense_Repository();
        public Additional_Expense_Services()
        {
            this.objAddtional_Expense_Repository = new Addtional_Expense_Repository();
        }
        public Additional_Expense GetByID(int? ID, Type[] RelationList = null)
        {
            return objAddtional_Expense_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Additional_Expense> GetAll(Type[] additionalTypes = null)
        {
            return objAddtional_Expense_Repository.GetAll();
        }
        public void AddEntity(Additional_Expense obj)
        {
            objAddtional_Expense_Repository.Add(obj);
        }
        public void UpdateEntity(Additional_Expense obj)
        {
            objAddtional_Expense_Repository.Update(obj);
        }
        public void DeleteEntity(Additional_Expense obj)
        {
            objAddtional_Expense_Repository.Delete(obj);
        }
    }
    public class Language_Services
    {
        Language_Repository objLanguage_Repository = new Language_Repository();
        public Language_Services()
        {
            this.objLanguage_Repository = new Language_Repository();
        }
        public Language GetByID(int? ID, Type[] RelationList = null)
        {
            return objLanguage_Repository.Get(ID, RelationList);
        }
        public IEnumerable<Language> GetAll(Type[] additionalTypes = null)
        {
            return objLanguage_Repository.GetAll();
        }
        public void AddEntity(Language obj)
        {
            objLanguage_Repository.Add(obj);
        }
        public void UpdateEntity(Language obj)
        {
            objLanguage_Repository.Update(obj);
        }
        public void DeleteEntity(Language obj)
        {
            objLanguage_Repository.Delete(obj);
        }
    }
}